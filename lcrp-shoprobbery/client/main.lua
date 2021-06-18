Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

scCore = nil

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

local uiOpen = false
local currentRegister   = 0
local copsCalled = false
local CurrentCops = 0
local PlayerJob = {}
local onDuty = false
local usingAdvanced = false

Citizen.CreateThread(function()
    Wait(1000)
    if scCore.Functions.GetPlayerData().job ~= nil and next(scCore.Functions.GetPlayerData().job) then
        PlayerJob = scCore.Functions.GetPlayerData().job
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 60 * 5)
        if copsCalled then
            copsCalled = false
        end
    end
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    PlayerJob = scCore.Functions.GetPlayerData().job
    onDuty = true
end)

RegisterNetEvent('scCore:Client:SetDuty')
AddEventHandler('scCore:Client:SetDuty', function(duty)
    onDuty = duty
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = true
end)

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('lockpicks:UseLockpick')
AddEventHandler('lockpicks:UseLockpick', function(isAdvanced)
    usingAdvanced = isAdvanced
    for k, v in pairs(Config.Registers) do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local dist = GetDistanceBetweenCoords(pos, Config.Registers[k].x, Config.Registers[k].y, Config.Registers[k].z)
        if dist <= 1 then
            if not Config.Registers[k].robbed then
                if CurrentCops >= Config.MinimumStoreRobberyPolice then
                    if usingAdvanced then
                        lockpick(true)
                        currentRegister = k
                        if not IsWearingHandshoes() then
                            TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                        end
                        if not copsCalled then
                            local s1 = pos.x, pos.y, pos.z
                            local street = GetStreetNameFromHashKey(s1)
                            local streetLabel = street
                            if street ~= nil then 
                                streetLabel = streetLabel
                            end
                            TriggerEvent("lcrp-weazelnews:client:CrimeStatistics", "robbery", 1)
                            TriggerServerEvent("lcrp-shoprobbery:server:callCops", "cashier", currentRegister, streetLabel, pos)
                            copsCalled = true
                        end
                    else
                        scCore.TriggerServerCallback('scCore:HasItem', function(result)
                            if result then
                                lockpick(true)
                                currentRegister = k
                                if not IsWearingHandshoes() then
                                    TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                                end
                                if not copsCalled then
                                    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
                                    local street1 = GetStreetNameFromHashKey(s1)
                                    local street2 = GetStreetNameFromHashKey(s2)
                                    local streetLabel = street1
                                    if street2 ~= nil then 
                                        streetLabel = streetLabel .. " " .. street2
                                    end
                                    TriggerEvent("lcrp-weazelnews:client:CrimeStatistics", "robbery", 1)
                                    TriggerServerEvent("lcrp-shoprobbery:server:callCops", "cashier", currentRegister, streetLabel, pos)
                                    copsCalled = true
                                end
                            else
                                scCore.Notification("It looks like you are missing a tool kit", "error")
                            end
                        end, "screwdriverset")
                    end
                    
                else
                    scCore.Notification("Not enough cops in town", "error")
                end
            else
                scCore.Notification("Cash register is empty!","error")
            end
        end
    end
end)

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(GetPlayerPed(-1), 3)
    local model = GetEntityModel(GetPlayerPed(-1))
    local retval = true
    
    if model == GetHashKey("mp_m_freemode_01") then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

function setupRegister()
    scCore.TriggerServerCallback('lcrp-shoprobbery:server:getRegisterStatus', function(Registers)
        for k, v in pairs(Registers) do
            Config.Registers[k].robbed = Registers[k].robbed
        end
    end)
end

function lockpick(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        toggle = bool,
    })
    SetCursorLocation(0.5, 0.2)
    uiOpen = bool
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(100)
    end
end

function takeAnim()
    local ped = GetPlayerPed(-1)
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
    Citizen.Wait(2500)
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "exit", 8.0, 8.0, -1, 50, 0, false, false, false)
end

local openingDoor = false
RegisterNUICallback('success', function()
    if currentRegister ~= 0 then
        lockpick(false)
        TriggerServerEvent('lcrp-shoprobbery:server:setRegisterStatus', currentRegister)
        local lockpickTime = 30000
        LockpickDoorAnim(lockpickTime)
        scCore.TaskBar("search_register", "Stealing", lockpickTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "veh@break_in@0h@p_m_one@",
            anim = "low_force_entry_ds",
            flags = 16,
        }, {}, {}, function() -- Done
            openingDoor = false
            copsCalled = false
            ClearPedTasks(GetPlayerPed(-1))
            TriggerServerEvent('lcrp-shoprobbery:server:takeMoney', currentRegister, true)            
            currentRegister = 0
        end, function() -- Cancel
            openingDoor = false
            copsCalled = false
            ClearPedTasks(GetPlayerPed(-1))
            scCore.Notification("Canceled", "error")
            currentRegister = 0
        end)
        Citizen.CreateThread(function()
            while openingDoor do
                TriggerServerEvent('lcrp-hud:Server:GainStress', math.random(1, 3))
                Citizen.Wait(10000)
            end
        end)
    else
        SendNUIMessage({
            action = "kekw",
        })
    end
end)

function LockpickDoorAnim(time)
    time = time / 1000
    loadAnimDict("veh@break_in@0h@p_m_one@")
    TaskPlayAnim(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(2000)
            time = time - 2
            --TriggerServerEvent('lcrp-shoprobbery:server:takeMoney', currentRegister, false)
            if time <= 0 then
                openingDoor = false
                StopAnimTask(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
            end
        end
    end)
end

RegisterNUICallback('callcops', function()
    TriggerEvent("police:SetCopAlert")
end)

RegisterNUICallback('fail', function()
    if usingAdvanced then
        if math.random(1, 100) < 20 then
            TriggerServerEvent("scCore:Server:RemoveItem", "advancedlockpick", 1)
            TriggerEvent('inventory:client:ItemBox', scCore.Shared.Items["advancedlockpick"], "remove")
        end
    else
        if math.random(1, 100) < 40 then
            TriggerServerEvent("scCore:Server:RemoveItem", "lockpick", 1)
            TriggerEvent('inventory:client:ItemBox', scCore.Shared.Items["lockpick"], "remove")
        end
    end
    if (IsWearingHandshoes() and math.random(1, 100) <= 25) then
        local pos = GetEntityCoords(GetPlayerPed(-1))
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    lockpick(false)
end)

RegisterNUICallback('exit', function()
    lockpick(false)
end)

RegisterNetEvent('lcrp-shoprobbery:client:setRegisterStatus')
AddEventHandler('lcrp-shoprobbery:client:setRegisterStatus', function(register, bool)
    Config.Registers[register].robbed = bool
end)

RegisterNetEvent('lcrp-shoprobbery:client:robberyCall')
AddEventHandler('lcrp-shoprobbery:client:robberyCall', function(type, key, streetLabel, coords)
    if PlayerJob.name == "police" or PlayerJob.name == "statepolice" or PlayerJob.name == 'fib' and onDuty then
        local cameraId = 4
        cameraId = Config.Registers[key].camId

        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        TriggerEvent('lcrp-alerts:client:AddPoliceAlert', {
            timeOut = 12000,
            alertTitle = "Shop robbery",
            coords = {
                x = coords.x,
                y = coords.y,
                z = coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-video"></i>',
                    detail = "Camera ID: ".. cameraId,
                },
                [2] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = streetLabel,
                },
            },
            callSign = "10-90",
        })

        local transG = 250
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 458)
        SetBlipColour(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 1.0)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("911: Shop robbery")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)