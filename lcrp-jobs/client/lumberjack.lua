
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------ SELLWOOD ---------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

scCore = nil
cachedData = {}

HandleStore = function()
    local storeData = Config.WoodShop

    WaitForModel(storeData["ped"]["model"])

    local pedHandle = CreatePed(5, storeData["ped"]["model"], storeData["ped"]["position"], storeData["ped"]["heading"], false)
    while not DoesEntityExist(pedHandle) do
        Citizen.Wait(0)
    end
    SetEntityInvincible(pedHandle, true)
    SetEntityAsMissionEntity(pedHandle, true, true)
    SetBlockingOfNonTemporaryEvents(pedHandle, true)
    FreezeEntityPosition(pedHandle, true)
    SetModelAsNoLongerNeeded(storeData["ped"]["model"])

    local storeBlip = AddBlipForCoord(storeData["ped"]["position"])
	
    SetBlipSprite(storeBlip, storeData["blip"]["sprite"])
    SetBlipScale(storeBlip, 0.65)
    SetBlipColour(storeBlip, storeData["blip"]["color"])
    SetBlipAsShortRange(storeBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(storeData["name"])
    EndTextCommandSetBlipName(storeBlip)
end


FadeOut = function(duration)
    DoScreenFadeOut(duration)
    
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
end

FadeIn = function(duration)
    DoScreenFadeIn(500)

    while not IsScreenFadedIn() do
        Citizen.Wait(0)
    end
end

WaitForModel = function(model)
    if not IsModelValid(model) then
        return
    end

	if not HasModelLoaded(model) then
		RequestModel(model)
	end
	
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end
end

DrawBusySpinner = function(text)
    SetLoadingPromptTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    ShowLoadingPrompt(3)
end



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------ LUMBERJACK ---------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TscCore"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }

scCore = nil

local mining = false
local textDel = Config.textDel
local ClosestBerth = 1
local sellX4 = 1205.84  
local sellY4 = -1271.42
local sellZ4 = 35.23
local delX = 1187.84  --del auto 
local delY = -1286.76
local delZ = 34.95
local HasVehicle = true
local procesX = -584.66
local procesY = 5285.63
local procesZ = 70.26
local pineca = vector3(procesX, procesY, procesZ)

Citizen.CreateThread(function()  
    Citizen.Wait(500)
	HandleStore() 
    for k, v in pairs(Config.Lumber.WoodPosition) do
        addBlip(v.coords, 79, 0.5, 25, Strings['wood'])
    end
    addBlip(Config.Lumber.Process, 238, 0.7, 5, Strings['process'])
end)


------------------------------------

function ProcessWood()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local inventory = scCore.Functions.GetPlayerData().items
    local cutAmount = 0
    for k, v in pairs(inventory) do
        if v.name == "wood_cut" then
            cutAmount = cutAmount + v.amount
        end
    end
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.9, -0.98))
    LoadDict('amb@medic@standing@tendtodead@idle_a')
    TaskPlayAnim(GetPlayerPed(-1), 'amb@medic@standing@tendtodead@idle_a', 'idle_a', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
    FreezeEntityPosition(playerPed, true)
    scCore.TaskBar("sell_wood", "Processing wood...", cutAmount * 3000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(GetPlayerPed(-1))
        FreezeEntityPosition(playerPed, false)
        TriggerServerEvent('lcrp-wood:processwood', cutAmount)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    end, function() -- Cancel
        ClearPedTasks(GetPlayerPed(-1))
        FreezeEntityPosition(playerPed, false)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    end)
end


function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end

---load dict and model
loadModel = function(model)
    while not HasModelLoaded(model) do Wait(0) RequestModel(model) end
    return model
end

loadDict = function(dict, anim)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
    return dict
end

helpText = function(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

addBlip = function(coords, sprite, size, colour, text)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipScale  (blip, size)
    SetBlipColour (blip, colour)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end


----TEXT 3D
function DrawText3D2(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 90)
end


RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
	exports["lcrp-interact"]:AddBoxZone("lumberSellWood", vector3(-552.07, 5348.36, 74.75), 1.4, 1.2, {
        name="lumberSellWood",
        heading=345,
        --debugPoly=true,
        minZ=73.55,
        maxZ=76.55 }, {
        options = {
            {
                event = "lumberjack:client:SellWood",
                icon = "fas fa-tree",
                label = "Sell processed wood",
                duty = false,
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("lumberProcessWoodLogs", vector3(-582.49, 5284.54, 70.26), 4.0, 1.8, {
        name="lumberProcessWoodLogs",
        heading=63,
        --debugPoly=true,
        minZ=68.86,
        maxZ=71.46 }, {
        options = {
            {
                event = "lumberjack:client:ProcessWood",
                icon = "fas fa-times",
                label = "Process wood logs",
                duty = false,
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("lumberCutWood", vector3(-553.16, 5369.8, 70.31), 1.6, 5.2, {
        name="lumberCutWood",
        heading=70,
        --debugPoly=true,
        minZ=69.31,
        maxZ=72.11 }, {
        options = {
            {
                event = "lumberjack:client:CutWood",
                icon = "fas fa-axe",
                label = "Cut wood",
                duty = false,
                parameters = {coords = vector3(-554.017, 5369.98, 70.37), heading = 255.49}
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("lumberCutWood1", vector3(-532.51, 5371.4, 70.4), 4.4, 1.8, {
        name="lumberCutWood1",
        heading=73,
        --debugPoly=true,
        minZ=69.2,
        maxZ=72.0 }, {
        options = {
            {
                event = "lumberjack:client:CutWood",
                icon = "fas fa-axe",
                label = "Cut wood",
                duty = false,
                parameters = {coords = vector3(-532.02, 5372.40, 70.43), heading = 165.62}
            },
        },
        job = {"all"}, distance = 3.0})
end)

RegisterNetEvent("lumberjack:client:SellWood")
AddEventHandler("lumberjack:client:SellWood", function()
    local pedCoords = GetEntityCoords(PlayerPedId())
    local dstCheck = #(pedCoords - Config.WoodShop["ped"]["position"])
    if dstCheck < 3.0 then
        TriggerServerEvent("lcrp-wood:sellwood")
    end
end)

RegisterNetEvent("lumberjack:client:ProcessWood")
AddEventHandler("lumberjack:client:ProcessWood", function()
    local pedCoords = GetEntityCoords(PlayerPedId())
    local dist = #(pedCoords - pineca)
    local hasWood = false
    local waiting = false
    if dist <= 3.5 then
        scCore.TriggerServerCallback('scCore:HasItem', function(result)
                hasWood = result
                waiting = true
        end, 'wood_cut')
        while(not waiting) do
            Citizen.Wait(100)
        end
        if (hasWood) then
            ProcessWood()
        else
            scCore.Notification('You have no wood logs to process', 'error')
        end	
    end
end)

RegisterNetEvent("lumberjack:client:CutWood")
AddEventHandler("lumberjack:client:CutWood", function(loc)
    local start = true
    local closeTo = {coords = vector3(loc.coords.x, loc.coords.y, loc.coords.z), heading = loc.heading}
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), closeTo.coords, true) <= 3.0 then
        if type(closeTo) == 'table' then
            Citizen.CreateThread(function()
                while GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), closeTo.coords, true) <= 5 do
                    Wait(5)
                    if start then
                        start = not start
                        mining = true
                        SetEntityHeading(PlayerPedId(), closeTo.heading)
                        FreezeEntityPosition(PlayerPedId(), true)
                        local model = loadModel(GetHashKey(Config.Lumber.Objects['pickaxe']))
                        local axe = CreateObject(model, GetEntityCoords(PlayerPedId()), true, false, false)
                        AttachEntityToEntity(axe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.09, 0.03, -0.02, -78.0, 13.0, 28.0, false, true, true, true, 0, true)
                        while mining do
                            Wait(5)
                            SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'))
                            helpText(Strings['wood_info'])
                            DisableControlAction(0, 24, true)
                            showSubtitle("Press (~g~[Backspace]~w~) to quit cutting wood",1001)
                            if IsDisabledControlJustReleased(0, 24) then
                                local dict = loadDict('melee@hatchet@streamed_core')
                                TaskPlayAnim(PlayerPedId(), dict, 'plyr_rear_takedown_b', 8.0, -8.0, -1, 2, 0, false, false, false)
                                local timer = GetGameTimer() + 800
                                while GetGameTimer() <= timer do Wait(0) DisableControlAction(0, 24, true) end
                                ClearPedTasks(PlayerPedId())
                                
                                if math.random(0, 100) <= Config.Lumber.ChanceToGetItem then
                                    TriggerServerEvent('lcrp-wood:getItem')
                                end
                            elseif IsControlJustReleased(0, 194) then
                                break
                            end
                        end
                        mining = false
                        DeleteObject(axe)
                        FreezeEntityPosition(PlayerPedId(), false)
                    end
                end
            end)
        end
    end
end)

function showSubtitle(message, time)
    BeginTextCommandPrint('STRING')
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandPrint(1000, 1)
end



