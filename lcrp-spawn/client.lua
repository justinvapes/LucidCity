Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

scCore = nil

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

local choosingSpawn = false

RegisterNetEvent('lcrp-spawn:client:openUI')
AddEventHandler('lcrp-spawn:client:openUI', function(value, new)
    SetEntityVisible(GetPlayerPed(-1), false)
    DoScreenFadeOut(250)
    Citizen.Wait(2000)
    DoScreenFadeIn(250)
    scCore.Functions.GetPlayerData(function(PlayerData)     
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + 150, -85.00, 0.00, 0.00, 100.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    end)
    Citizen.Wait(500)
    SetDisplay(value)
end)

RegisterNUICallback("exit", function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "ui",
        status = false
    })
    choosingSpawn = false
end)

local cam = nil
local cam2 = nil

RegisterNUICallback('setCam', function(data)
    local location = tostring(data.posname)
    local type = tostring(data.type)

    local camZPlus1 = 300
    local camZPlus2 = 100
    local pointCamCoords = 75
    local pointCamCoords2 = 0
    local cam1Time = 500
    local cam2Time = 1000

    if DoesCamExist(cam) then
        DestroyCam(cam, true)
    end

    if DoesCamExist(cam2) then
        DestroyCam(cam2, true)
    end

    if type == "current" then
        scCore.Functions.GetPlayerData(function(PlayerData)
            cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + camZPlus1, 300.00,0.00,0.00, 110.00, false, 0)
            PointCamAtCoord(cam2, PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + pointCamCoords)
            SetCamActiveWithInterp(cam2, cam, cam1Time, true, true)
            if DoesCamExist(cam) then
                DestroyCam(cam, true)
            end
            Citizen.Wait(cam1Time)

            cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + camZPlus2, 300.00,0.00,0.00, 110.00, false, 0)
            PointCamAtCoord(cam, PlayerData.position.x, PlayerData.position.y, PlayerData.position.z + pointCamCoords2)
            SetCamActiveWithInterp(cam, cam2, cam2Time, true, true)
            print("Log: Selected last position: "..PlayerData.position.x, PlayerData.position.y, PlayerData.position.z)
            SetEntityCoords(GetPlayerPed(-1), PlayerData.position.x, PlayerData.position.y, PlayerData.position.z)
        end)
    elseif type == "house" then
        local campos = Config.Houses[location].coords.enter

        cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + camZPlus1, 300.00,0.00,0.00, 110.00, false, 0)
        PointCamAtCoord(cam2, campos.x, campos.y, campos.z + pointCamCoords)
        SetCamActiveWithInterp(cam2, cam, cam1Time, true, true)
        if DoesCamExist(cam) then
            DestroyCam(cam, true)
        end
        Citizen.Wait(cam1Time)

        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + camZPlus2, 300.00,0.00,0.00, 110.00, false, 0)
        PointCamAtCoord(cam, campos.x, campos.y, campos.z + pointCamCoords2)
        SetCamActiveWithInterp(cam, cam2, cam2Time, true, true)
        print("Log: Selected spawn at house")
        SetEntityCoords(GetPlayerPed(-1), campos.x, campos.y, campos.z)
    end
end)

RegisterNetEvent('lcrp-spawn:client:lastPosition')
AddEventHandler('lcrp-spawn:client:lastPosition', function()
    local location = "current"
    local type = "current"
    local ped = GetPlayerPed(-1)
    local PlayerData = scCore.Functions.GetPlayerData()
    local homeIn = PlayerData.homeIn
    while(PlayerData == nil) do
        Citizen.Wait(1)
    end 

    if DoesCamExist(cam) then
        DestroyCam(cam, true)
    end

    if DoesCamExist(cam2) then
        DestroyCam(cam2, true)
    end
    print('current')
    SetDisplay(false)
    DoScreenFadeOut(500)
    
    RenderScriptCams(false, true, 500, true, true)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    SetCamActive(cam2, false)
    DestroyCam(cam2, true)
    SetEntityVisible(GetPlayerPed(-1), true)
    TriggerServerEvent('scCore:Server:OnPlayerLoaded')
    TriggerEvent('scCore:Client:OnPlayerLoaded')
    Citizen.Wait(1000)
    if homeIn ~= 'none' then
        print("spawning in house")
    else
        print("Setting last position coords")
        print(PlayerData.position.x .. PlayerData.position.y .. PlayerData.position.z)
        local pos3 = vector3(PlayerData.position.x, PlayerData.position.y, PlayerData.position.z)
        local islandVec = vector3(4840.571, -5174.425, 2.0)
        local distance1 = #(pos3 - islandVec)
        if distance1 < 2000.0 then
            TriggerEvent('spawnIsland', PlayerData.position)
            scCore.Notification('Loading the Island...')
        else
            SetEntityCoords(GetPlayerPed(-1), PlayerData.position.x, PlayerData.position.y, PlayerData.position.z+1)
            SetEntityHeading(GetPlayerPed(-1), PlayerData.position.a)
        end
    end
    local isDead = PlayerData.metadata["isdead"]
    if not isDead then 
        TriggerEvent("hospital:client:Revive")
    end
    TriggerEvent('playerSpawned', spawn)
    ShutdownLoadingScreen()
    DoScreenFadeIn(250)
end)



function SetDisplay(bool)
    choosingSpawn = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool
    })
end

Citizen.CreateThread(function()
    while choosingSpawn do
        Citizen.Wait(0)

        DisableAllControlActions(0)
    end
end)

RegisterNetEvent('lcrp-houses:client:setHouseConfig')
AddEventHandler('lcrp-houses:client:setHouseConfig', function(houseConfig)
    Config.Houses = houseConfig
end)

-- Spawns --

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('scCore:Client:OnPlayerUnload')
AddEventHandler('scCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    CurrentApartment = nil
    InApartment = false
    CurrentOffset = 0
end)

local shouldStopIntro = false
local inStart = false
local isinintroduction = false
local introstep = 0
local timer = 0
local inputgroups = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31}
local infos = {
    "Welcome to ~o~LUCIDCITY~w~", -- [1]
    "Your ID Card can be bought at the ~r~Court House~w~", -- [2]
    "You can get a job at the ~y~Employment center~w~", -- [3]
    "~y~Whitelisted jobs~w~ have the best salaries", -- [4]
    "You can get your ~r~Drivers License~w~ at the driving school" -- [5]
}

RegisterNetEvent('lcrp-spawn:client:startCinematic')
AddEventHandler('lcrp-spawn:client:startCinematic', function(cData, isNew)
    local playerPed = GetPlayerPed(-1);

        if not isNew then
            print("LOG: Character isnt new, spawning to last location")
            TriggerEvent("lcrp-spawn:client:lastPosition")
        else
            print("LOG: Character is new")
            SetPlayerModel(PlayerId(), `mp_m_freemode_01`)
            local introcam
            TriggerEvent('chat:clear')  --- Clear current chat
            SetEntityVisible(playerPed, false, 0) --- Make Player Invisible
            SetEntityCoordsNoOffset(playerPed, -103.8, -921.06, 287.29, false, false, false, true) --- Teleport Infront of Maze Bank IN Air
            FreezeEntityPosition(playerPed, true) --- Freeze The Player There
            SetFocusEntity(playerPed) ---- Focus on the player (To Render the building)
            TriggerServerEvent('scCore:Server:OnPlayerLoaded')
            TriggerEvent('scCore:Client:OnPlayerLoaded')
    
            PrepareMusicEvent("FM_INTRO_START")
            Wait(1)
            SetOverrideWeather("EXTRASUNNY")
            NetworkOverrideClockTime(19, 0, 0)
            BeginSrl()
            introstep = 1
            isinintroduction = true
            Wait(1)
            DoScreenFadeIn(500)

            while true do
                Wait(0)
                inStart = true

            if shouldStopIntro then
                introstep = 6
            end

            if introstep == 1 then

                TriggerMusicEvent("FM_INTRO_START")
                introcam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
                SetCamActive(introcam, true)
                SetFocusArea(638.2548, 923.7698, 359.2265, 0.0)
                SetCamParams(introcam, 649.58, 966.03, 352.83, -14.367, 0.0, 348.057, 42.2442, 0, 1, 1, 2)
                SetCamParams(introcam, 665.3689, 1021.78, 340.714, -9.6114, 0.0, 348.057, 44.8314, 7200, 0, 0, 2)
                ShakeCam(introcam, "HAND_SHAKE", 0.15)
                RenderScriptCams(true, false, 3000, 1, 1)
                timer = GetNetworkTime() + 6700
                introstep = 1.5
            elseif introstep == 1.5 then

                Wait(800)
                while GetNetworkTime() < timer do
                    Wait(0)
                    DrawTxt(0.925, 1.44, 1.0, 1.08, 0.6, "~w~ PRESS ~w~[~r~SPACE~w~] TO SKIP", 255, 255, 255, 255)
                    DrawScreenTxt(infos[1])
                end
                introstep = 2
            elseif introstep == 2 then

                DoScreenFadeOut(800)
                Wait(800)
                SetFocusArea(-496.84, -282.54, 69.3747, 0.0, 0.0, 0.0)
                NetworkOverrideClockTime(19, 0, 0)
                Wait(320)
                DoScreenFadeIn(800)
                SetCamParams(introcam, -496.84, -282.54, 69.3747, -14.367, 0.0, 29.58, 44.9958992, 0, 1, 1, 2)
                SetCamParams(introcam, -512.09, -258.23, 61.7247, -14.367, 0.0, 29.58, 44.9958992, 6000, 0, 0, 2)
                timer = GetNetworkTime() + 8000
                introstep = 2.5
            elseif introstep == 2.5 then

                Wait(800)
                while GetNetworkTime() < timer do
                    Wait(0)
                    DrawTxt(0.95, 1.44, 1.0, 1.08, 0.6, "~w~ PRESS ~w~[~r~SPACE~w~] TO SKIP", 255, 255, 255, 255)
                    DrawScreenTxt(infos[2])
                end
                introstep = 3
            elseif introstep == 3 then
                DoScreenFadeOut(800)
                Wait(800)
                SetFocusArea(-1011.79, -322.2498, 66.099, 0.0, 0.0, 0.0)
                NetworkOverrideClockTime(19, 0, 0)
                Wait(320)
                DoScreenFadeIn(800)
                SetCamParams(introcam, -1023.595, -308.96, 64.88, -14.367, 0.0, 45.0069, 44.9958992, 0, 1, 1, 2)
                SetCamParams(introcam, -1052.07, -282.50, 52.35, -14.367, 0.0, 45.0069, 44.9958992, 6000, 0, 0, 2)
                timer = GetNetworkTime() + 8000
                introstep = 3.5
            elseif introstep == 3.5 then
                Wait(800)
                while GetNetworkTime() < timer do
                    Wait(0)
                    DrawTxt(0.955, 1.44, 1.0, 1.08, 0.6, "~w~ PRESS ~w~[~r~SPACE~w~] TO SKIP", 255, 255, 255, 255)
                    DrawScreenTxt(infos[3])
                end
                introstep = 4
            elseif introstep == 4 then
                DoScreenFadeOut(800)
                Wait(800)
                SetFocusArea(-1512.93, -844.55, 44.03, 0.0, 0.0, 0.0)
                NetworkOverrideClockTime(19, 0, 0)
                Wait(320)
                DoScreenFadeIn(800)
                SetCamParams(introcam, -1512.93, -844.55, 44.03, -13.0682, 0.0572, 0.7306, 74.56, 0, 1, 1, 2)
                SetCamParams(introcam, -1584.06, -826.79, 30.03, -2.3097, 0.0572, 0.7406, 74.56, 6000, 0, 0, 2)
                timer = GetNetworkTime() + 8000
                introstep = 4.5
            elseif introstep == 4.5 then
                Wait(800)
                while GetNetworkTime() < timer do
                    Wait(0)
                    DrawTxt(0.965, 1.44, 1.0, 1.08, 0.6, "~w~ PRESS ~w~[~r~SPACE~w~] TO SKIP", 255, 255, 255, 255)
                    DrawScreenTxt(infos[4])
                end
                introstep = 5
            elseif introstep == 5 then
                DoScreenFadeOut(800)
                Wait(800)
                SetFocusArea(-4.6668, -900.9736, 184.887, 0.0, 0.0, 0.0)
                NetworkOverrideClockTime(19, 0, 0)
                Wait(320)
                DoScreenFadeIn(800)
                SetCamParams(introcam, -4.6668, -900.9736, 184.887, -1.6106, -0.5186, 78.3786, 45.0069, 0, 1, 1, 2)
                SetCamParams(introcam, -23.0087, -896.4288, 184.1939, -2.8529, -0.5186, 81.8262, 45.0069, 8800, 0, 0, 2)
                timer = GetNetworkTime() + 8000
                introstep = 5.5
            elseif introstep == 5.5 then
                Wait(800)
                while GetNetworkTime() < timer do
                    Wait(0)
                    DrawTxt(0.95, 1.44, 1.0, 1.08, 0.6, "~w~ PRESS ~w~[~r~SPACE~w~] TO SKIP", 255, 255, 255, 255)
                    DrawScreenTxt(infos[5])
                end
                introstep = 6
            elseif introstep == 6 then
                SetEntityVisible(playerPed, true, 0) --- set visable
                FreezeEntityPosition(playerPed, false) -- unfreeze
                DestroyCam(createdCamera, 0)
                DestroyCam(createdCamera, 0)
                RenderScriptCams(0, 0, 1, 1, 1)
                createdCamera = 0
                ClearTimecycleModifier("scanline_cam_cheap")

                inStart = false
                shouldStopIntro = false
                
                TriggerEvent("lcrp-spawn:client:spawnPoint")


                return			   		   
            end
        end
    end
end)

local DoSleep
Citizen.CreateThread(function()
    while true do
        DoSleep = 5
        if inStart then
            DoSleep = 5
            if IsControlJustPressed(0, Keys["SPACE"]) then
                print("LOG: stopping start intro")
                shouldStopIntro = true
                inStart = false
            end
        else
            DoSleep = 500
        end
        Citizen.Wait(DoSleep)
    end
end)

function DrawScreenTxt(text)
    DrawTxt(0.93, 1.44, 1.0,1.0,0.6, text, 255, 255, 255, 255)
end

function DrawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

RegisterNetEvent("lcrp-spawn:client:spawnPoint")
AddEventHandler("lcrp-spawn:client:spawnPoint", function()
    local playerPed = GetPlayerPed(-1)
    FreezeEntityPosition(playerPed, false)
    RenderScriptCams(false, true, 500, true, true)
    SetFocusEntity(playerPed)
    DoScreenFadeOut(500)

    DoScreenFadeIn(250)

    scCore.Functions.GetPlayerData(function(PlayerData)
        SetEntityCoords(GetPlayerPed(-1), PlayerData.position.x, PlayerData.position.y, PlayerData.position.z)
        SetEntityHeading(GetPlayerPed(-1), PlayerData.position.a)
        FreezeEntityPosition(GetPlayerPed(-1), false)
    end)

    SetEntityCoords(playerPed, -837.8238, -104.9415, 28.18537) -- SPAWN AT DEFAULT LOCATION

    TriggerEvent("lcrp-clothes:defaultReset") -- RESETS TO DEFAULT FREEMODE PED
    TriggerEvent('raid-clothes:OpenBarberShopMenu')

    print("LOG: Spawning player ["..playerPed.."] at spawn location")
end)

function DrawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end