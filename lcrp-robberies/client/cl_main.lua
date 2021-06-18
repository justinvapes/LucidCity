scCore = nil
CurrentCops = 0
isLoggedIn = false
PlayerJob = nil
onDuty = false
closestBank = nil
copsCalled = false

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerJob = scCore.Functions.GetPlayerData().job
    scCore.TriggerServerCallback('lcrp-robberies:server:GetConfig', function(config)
        Config = config
        ResetBankDoors()
        startClosestBankThread()
        StartIsNearJewelleyThread()

        Citizen.CreateThread(function()
            Dealer = AddBlipForCoord(Config.JewelleryLocation["coords"]["x"], Config.JewelleryLocation["coords"]["y"], Config.JewelleryLocation["coords"]["z"])
        
            SetBlipSprite (Dealer, 439)
            SetBlipDisplay(Dealer, 4)
            SetBlipScale  (Dealer, 0.7)
            SetBlipAsShortRange(Dealer, true)
            SetBlipColour(Dealer, 37)
        
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName("Jewellery store")
            EndTextCommandSetBlipName(Dealer)
        end)
    end)

    onDuty = true
end)

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
	CurrentCops = amount
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = true
end)

RegisterNetEvent('scCore:Client:SetDuty')
AddEventHandler('scCore:Client:SetDuty', function(duty)
    onDuty = duty
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if scCore == nil then
            TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
            Citizen.Wait(200)
        end
    end
end)
function startClosestBankThread()
    Citizen.CreateThread(function()
        while true do
            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)
            
            if scCore ~= nil then
                inRange = false
                
                for k, v in pairs(Config.Banks) do
                    local dist = GetDistanceBetweenCoords(pos, Config.Banks[k]["coords"]["x"], Config.Banks[k]["coords"]["y"], Config.Banks[k]["coords"]["z"])

                    if dist < 40 then
                        closestBank = k
                        inRange = true
                        break
                    end
                end
    
                if not inRange then
                    Citizen.Wait(2000)
                    closestBank = nil
                end
            end

            Citizen.Wait(3)
        end
    end)
end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
	exports["lcrp-interact"]:AddBoxZone("pacificDisableCameras", vector3(660.44, 1283.91, 360.3), 0.8, 0.6, {
        name="pacificDisableCameras",
        heading=0,
        --debugPoly=true,
        minZ=360.5,
        maxZ=361.5 }, {
        options = {
            {
                event = "lcrp-robberies:client:disableBankCameras",
                icon = "fas fa-cctv",
                label = "Cut off CCTV power",
                duty = false,
                pacificRobberyStarted = false,
                parameters = "pacific"
            },
        },
        job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("paletoDisableCameras", vector3(2579.91, 5060.4, 44.96), 1.0, 2.6, {
        name="paletoDisableCameras",
        heading=15,
        --debugPoly=true,
        minZ=43.96,
        maxZ=46.36 }, {
        options = {
            {
                event = "lcrp-robberies:client:disableBankCameras",
                icon = "fas fa-cctv",
                label = "Cut off CCTV power",
                duty = false,
                paletoRobberyStarted = false,
                parameters = "paleto"
            },
        },
        job = {"all"}, distance = 2.0})
end)

RegisterNetEvent("lcrp-robberies:client:disableBankCameras")
AddEventHandler("lcrp-robberies:client:disableBankCameras", function(bank)
    local pos = GetEntityCoords(PlayerPedId())
    local powerDist = GetDistanceBetweenCoords(pos, Config.Banks[bank]["power"].x, Config.Banks[bank]["power"].y, Config.Banks[bank]["power"].z)
    if powerDist < 5 then
        if CurrentCops >= Config.MinimumBigBankPolice then
            PowerOffCameras(bank)
        else
            scCore.Notification("Not enough police in town", "error")
        end
    else
        scCore.Notification("Too far")    
    end
end)

RegisterNetEvent("lcrp-robberies:client:enablePowerCutoff")
AddEventHandler("lcrp-robberies:client:enablePowerCutoff", function(bank)
    TriggerEvent("lcrp-interact:client:updateInteraction","zone",bank.."DisableCameras", bank.."RobberyStarted", true)
end)

function PowerOffCameras(bank)
    scCore.TaskBar("powering_off", "Disabling camera link", math.random(5000, 10000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@gangops@facility@servers@",
        anim = "hotwire",
        flags = 16,
    }, {}, {}, function() -- Done
        TriggerServerEvent("lcrp-robberies:DisableCamera", bank)
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
        scCore.Notification("Canceled", "error")
    end)
end

RegisterNetEvent('electronickit:UseElectronickit')
AddEventHandler('electronickit:UseElectronickit', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    if closestBank ~= nil and closestBank ~= 'paleto' then
        local bank = Config.Banks[closestBank]
        if GetDistanceBetweenCoords(pos, bank.coords.x, bank.coords.y, bank.coords.z,true) < 1.5 and not bank.isOpened then
            TriggerServerEvent("lcrp-robberies:server:CanStartRobbery", "electronickit", closestBank )
        end
    end
end)

RegisterNetEvent('lcrp-robberies:server:StartRobbery')
AddEventHandler('lcrp-robberies:server:StartRobbery', function(item, bank)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    if item == "electronickit" then
        UseElectronickit(bank)
    else
        UseSecurityCard(item, bank)
    end  
end)

function UseSecurityCard(item, bank)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local securityTerminal
    local openBankDoor

    if item == "security_card_02" then 
        securityTerminal = vector3(261.86, 223.15, 106.28)
        openBankDoor = false
    else 
        securityTerminal = vector3(Config.Banks["paleto"]["coords"]["x"], Config.Banks["paleto"]["coords"]["y"],Config.Banks["paleto"]["coords"]["z"]) 
        openBankDoor = true
    end
    
    local dist = GetDistanceBetweenCoords(pos, securityTerminal,true)
    
    if dist < 1.5 then
        if CurrentCops >= Config.MinimumBigBankPolice then
            if not Config.Banks[bank]["isOpened"] then 

                scCore.TaskBar("security_pass", "Validating...", math.random(5000, 10000), false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "anim@gangops@facility@servers@",
                    anim = "hotwire",
                    flags = 16,
                }, {}, {}, function() -- Done
                    StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                    if not openBankDoor then
                        TriggerServerEvent('lcrp-doors:server:updateState', 37, false) --pacific door for security card
                        TriggerServerEvent("scCore:Server:RemoveItem", "security_card_02", 1)
                        scCore.Notification("Door system bypassed", "success")
                    else
                        TriggerServerEvent('lcrp-robberies:server:setBankState', "paleto", true)
                        TriggerServerEvent("scCore:Server:RemoveItem", "security_card_01", 1)
                        TriggerServerEvent('lcrp-doors:server:updateState', 65, false)
                        TriggerServerEvent('lcrp-doors:server:updateState', 46, false)
                    end
                    CallCops(bank, pos)
                end, function() -- Cancel
                    StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                    scCore.Notification("Canceled..", "error")
                end)
            else
                scCore.Notification("Looks like the bank is already open", "error")
            end
        else
            scCore.Notification("Not enough police in town!", "error")
        end
    end
end

function UseElectronickit(bank)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local dist = GetDistanceBetweenCoords(pos, Config.Banks[bank]["coords"]["x"], Config.Banks[bank]["coords"]["y"], Config.Banks[bank]["coords"]["z"],true)
    local minimumPolice = Config.MinimumBigBankPolice
    if type(bank) == "number" then
        minimumPolice = Config.MinimumSmallBankPolice
    end
    if dist < 1.5 then
        if CurrentCops >= minimumPolice then
            if not Config.Banks[bank]["isOpened"] then
                scCore.TaskBar("hack_gate", "Connecting electronic kit", math.random(5000, 10000), false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "anim@gangops@facility@servers@",
                    anim = "hotwire",
                    flags = 16,
                }, {}, {}, function() -- Done
                    StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                    TriggerEvent("mhacking:show")
                    TriggerEvent("mhacking:start", math.random(5, 9), math.random(10, 18), OnHackDone)
                    TriggerServerEvent("scCore:Server:RemoveItem", "electronickit", 1)
                    TriggerServerEvent("scCore:Server:RemoveItem", "trojan_usb", 1)
                    CallCops(bank, pos)
                end, function() -- Cancel
                    StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                    scCore.Notification("Canceled..", "error")
                end)
            end
        else
            scCore.Notification("Not enough police in town", "error")
        end
    end
end

function CallCops(bank, pos)
    if not copsCalled then
        local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
        local streetLabel = street1
        if street2 ~= nil then 
            streetLabel = streetLabel .. " " .. street2
        end
        if Config.Banks[bank]["alarm"] then
            TriggerEvent("lcrp-weazelnews:client:CrimeStatistics", "robbery", 1)
            TriggerServerEvent("lcrp-robberies:server:callCops", bank, streetLabel, pos)
            copsCalled = true
        end
    end
end

function IsInOpenBankRobbery()
    if closestBank ~= nil then
        if Config.Banks[closestBank] ~= nil and Config.Banks[closestBank]["isOpened"] then
            return true
        end
        return false
    end
    return false
end

function CanOpenLockerAtBankRobbery()
    if closestBank ~= nil then
        if Config.Banks[closestBank] ~= nil and Config.Banks[closestBank]["isOpened"] then
            for k, v in pairs(Config.Banks[closestBank]["lockers"]) do
                local lockerDist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.Banks[closestBank]["lockers"][k].x, Config.Banks[closestBank]["lockers"][k].y, Config.Banks[closestBank]["lockers"][k].z)
                if not Config.Banks[closestBank]["lockers"][k]["isBusy"] then
                    if not Config.Banks[closestBank]["lockers"][k]["isOpened"] then
                        if lockerDist < 5 then
                            if lockerDist <= 0.5 then
                                local lockerPos = {x = Config.Banks[closestBank]["lockers"][k].x, y =  Config.Banks[closestBank]["lockers"][k].y, z = Config.Banks[closestBank]["lockers"][k].z}
                                return {retval = true, closestBank = closestBank, locker = k, lockerPos = lockerPos}
                            end
                        end
                    end
                end
            end
        end
    end
    return {retval = false}
end

RegisterNetEvent('lcrp-robberies:client:setBankState')
AddEventHandler('lcrp-robberies:client:setBankState', function(bankId, state)
    Config.Banks[bankId]["isOpened"] = state
    if state then
        OpenBankDoor(bankId)
    end
    TriggerServerEvent('lcrp-robberies:server:setTimeout')
end)

function OpenBankDoor(bankId)
    local object = GetClosestObjectOfType(Config.Banks[bankId]["coords"]["x"], Config.Banks[bankId]["coords"]["y"], Config.Banks[bankId]["coords"]["z"], 5.0, Config.Banks[bankId]["object"], false, false, false)
    local timeOut = 10
    local entHeading = Config.Banks[bankId]["heading"].closed

    if object ~= 0 then
        Citizen.CreateThread(function()
            while true do
                if type(bankId) == "number" then
                    if entHeading ~= Config.Banks[bankId]["heading"].open then
                        SetEntityHeading(object, entHeading - 10)
                        entHeading = entHeading - 0.5
                    else
                        break
                    end
                else
                    if bankId == "paleto" then
                        if entHeading < Config.Banks["paleto"]["heading"].open then
                            SetEntityHeading(object, entHeading + 10)
                            entHeading = entHeading + 0.5
                        else
                            break
                        end
                    else
                        if entHeading > Config.Banks["pacific"]["heading"].open then
                            SetEntityHeading(object, entHeading - 10)
                            entHeading = entHeading - 0.5
                        else
                            break
                        end
                    end
                end
                
                Citizen.Wait(10)
            end
        end)
    end
end
RegisterNetEvent('lcrp-robberies:client:ResetBankRobberies')
AddEventHandler('lcrp-robberies:client:ResetBankRobberies', function()
    for k,_ in pairs(Config.Banks) do
        Config.Banks[k]["isOpened"] = false
        if type(k)=="string" then
            TriggerEvent("lcrp-interact:client:updateInteraction","zone", k.."DisableCameras", k.."RobberyStarted", true)
        end
        for _, v in pairs(Config.Banks[k]["lockers"]) do
            v["isOpened"] = false
        end
    end
    copsCalled = false
end)