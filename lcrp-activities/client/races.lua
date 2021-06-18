local hudPosition = vec(0.015, 0.725)

local racerPedsCoords = {
    [1] = {
        x = 134.3369, 
        y = 6640.123, 
        z = 30.76, 
        h = 224.85, 
        model = "ig_talcc", 
        pedName = "Tom",
        checkpoints = {
            [1] = {
                coords = {x = 100.75, y = 6478.75, z = 30.34},
            },
            [2] = {
                coords = {x = -262.64, y = 6121.66, z = 31.20},
            },
            [3] = {
                coords = {x = -788.98, y = 5488.97, z = 34.28},
            },
            [4] = {
                coords = {x = -1807.95, y = 4717.21, z = 57.04},
            },
            [5] = {
                coords = {x = -2403.55, y = 3905.43, z = 24.65},
            },
            [6] = {
                coords = {x = -2663.13, y = 2623.12, z = 16.65},
            },
            [7] = {
                coords = {x = -2996.23, y = 1598.89, z = 29.74},
            },
            [8] = {
                coords = {x = -3054.62, y = 731.63, z = 22.12},
            },
            [9] = {
                coords = {x = -2101.35, y = -217.81, z = 19.72},
            },
            [10] = {
                coords = {x = -1647.64, y = -342.79, z = 50.00},
            },
            [11] = {
                coords = {x = -1399.123, y = -537.93, z = 30.84},
            },
            [11] = {
                coords = {x = -1143.65, y = -698.32, z = 21.50},
            },
            [12] = {
                coords = {x = -658.55, y = -958.05, z = 21.41},
            },
            [13] = {
                coords = {x = -294.92, y = -1142.22, z = 23.12},
            },
            [14] = {
                coords = {x = 56.31, y = -1210.53, z = 29.34},
            },
            [15] = {
                coords = {x = 299.32, y = -1225.33, z = 38.29},
            },
            [16] = {
                coords = {x = 1080.80, y = -1191.10, z = 55.78},
            },
            [17] = {
                coords = {x = 2095.27, y = -614.87, z = 95.71},
            },
            [18] = {
                coords = {x = 2603.06, y = 242.72, z = 98.29},
            },
            [19] = {
                coords = {x = 2455.48, y = 963.42, z = 86.55},
            },
            [20] = {
                coords = {x = 1940.61, y = 1813.86, z = 62.62},
            },
            [21] = {
                coords = {x = 2129.36, y = 2656.67, z = 50.52},
            },
            [22] = {
                coords = {x = 2813.97, y = 3418.87, z = 55.73},
            },
            [23] = {
                coords = {x = 2732.91, y = 4703.26, z = 44.33},
            },
            [24] = {
                coords = {x = 2269.89, y = 5972.99, z = 50.19},
            },
            [25] = {
                coords = {x = 1684.59, y = 6386.22, z = 31.23},
            },
            [26] = {
                coords = {x = 1031.96, y = 6491.73, z = 20.98},
            },
            [27] = {
                coords = {x = 220.41, y = 6562.47, z = 31.80},
            },
        },
    },
    [2] = {
        x = -2521.39, 
        y = 2315.03, 
        z = 32.21, 
        h = 270.24, 
        model = "s_m_y_waretech_01", 
        pedName = "Charles",
        checkpoints = {
            [1] = {
                coords = {x = -2448.35, y = 2298.93, z = 30.64},
            },
            [2] = {
                coords = {x = -2065.28, y = 2278.57, z = 40.40},
            },
            [3] = {
                coords = {x = -1661.59, y = 2220.51, z = 87.0},
            },
            [4] = {
                coords = {x = -1642.64, y = 2208.56, z = 89.24},
            },
            [5] = {
                coords = {x = -1789.08, y = 1857.11, z = 151.10},
            },
            [6] = {
                coords = {x = -2000.43, y = 1783.14, z = 179.78},
            },
            [7] = {
                coords = {x = -1987.32, y = 1910.93, z = 185.00},
            },
            [8] = {
                coords = {x = -2042.46, y = 2005.29, z = 189.69},
            },
            [9] = {
                coords = {x = -2321.28, y = 1869.84, z = 182.16},
            },
            [10] = {
                coords = {x = -2544.18, y = 1909.54, z = 1869.34},
            },
            [11] = {
                coords = {x = -2661.21, y = 1504.94, z = 116.34},
            },
            [12] = {
                coords = {x = -2821.78, y = 1290.94, z = 67.45},
            },
            [13] = {
                coords = {x = -2920.04, y = 1333.3, z = 45.84},
            },
            [14] = {
                coords = {x = -3095.85, y = 1188.65, z = 19.40},
            },
            [15] = {
                coords = {x = -2704.53, y = 2276.78, z = 19.14},
            },
        },
    }
}

local recordedCheckpoints = {}
local renderGUI = false
local races = {}
local raceStatus = {
    state = nil,
    index = 0,
    checkpoint = 0,
    lap = 0
}


RegisterNetEvent("lcrp-activities:client:createRace")
AddEventHandler("lcrp-activities:client:createRace", function(index, amount, startCoords, checkpoints, laps, organizer)
    local race = {
        amount = amount,
        laps = laps,
        started = false,
        startTime = GetGameTimer() + 600000,
        startCoords = startCoords,
        checkpoints = checkpoints,
        organizer = organizer
    }
    races[index] = race
end)

RegisterNetEvent("lcrp-activities:client:joinedRace")
AddEventHandler("lcrp-activities:client:joinedRace", function(index)
    raceStatus.index = index
    raceStatus.state = "joined"
    local race = races[index]
    local checkpoints = race.checkpoints

    for index, checkpoint in pairs(checkpoints) do
        checkpoint.blip = AddBlipForCoord(checkpoint.coords.x, checkpoint.coords.y, checkpoint.coords.z)
        SetBlipColour(checkpoint.blip, 14)
        SetBlipAsShortRange(checkpoint.blip, true)
        ShowNumberOnBlip(checkpoint.blip, index)
    end

    SetWaypointOff()
    SetBlipRoute(checkpoints[1].blip, true)
    SetBlipRouteColour(checkpoints[1].blip, 14)
end)

RegisterNetEvent("lcrp-activities:client:removeRace")
AddEventHandler("lcrp-activities:client:removeRace", function(index)
    if index == raceStatus.index then
        cleanupRace()
        cleanupRecording()
        raceStatus.index = 0
        raceStatus.checkpoint = 0
        raceStatus.state = nil
    elseif index < raceStatus.index then
        raceStatus.index = raceStatus.index - 1
    end
    table.remove(races, index)
end)

Citizen.CreateThread(function()
    while true do
        sleep = 1000
        local player = GetPlayerPed(-1)
        if IsPedInAnyVehicle(player, false) then
            local position = GetEntityCoords(player)
            local vehicle = GetVehiclePedIsIn(player, false)

            if raceStatus.state == "racing" then
                sleep = 5
                local race = races[raceStatus.index]
                if raceStatus.checkpoint == 0 then
                    raceStatus.checkpoint = 1
                    raceStatus.lap = 1
                    local checkpoint = race.checkpoints[raceStatus.checkpoint]
                    local checkpointType = raceStatus.checkpoint < #race.checkpoints and 45 or 9

                    SetBlipRoute(checkpoint.blip, true)
                    SetBlipRouteColour(checkpoint.blip, 14)
                else
                    local checkpoint = race.checkpoints[raceStatus.checkpoint]
                    if GetDistanceBetweenCoords(position.x, position.y, position.z, checkpoint.coords.x, checkpoint.coords.y, 0, false) < 25.0 then
                        --RemoveBlip(checkpoint.blip)
                        
                        if raceStatus.checkpoint == #(race.checkpoints) and raceStatus.lap == race.laps then
                            PlaySoundFrontend(-1, "ScreenFlash", "WastedSounds")
                            local currentTime = (GetGameTimer() - race.startTime)
                            TriggerServerEvent('lcrp-activities:finishedRace_sv', raceStatus.index, currentTime)

                            cleanupRace()
                            cleanupRecording()

                            raceStatus.checkpoint = 0
                            
                            raceStatus.index = 0
                            raceStatus.state = nil
                        elseif raceStatus.checkpoint == #(race.checkpoints) then
                            PlaySoundFrontend(-1, "RACE_PLACED", "HUD_AWARDS")

                            raceStatus.checkpoint = 1
                            raceStatus.lap = raceStatus.lap + 1
                            local nextCheckpoint = race.checkpoints[raceStatus.checkpoint]
                            local checkpointType = raceStatus.checkpoint < #race.checkpoints and 45 or 9

                            SetNewWaypoint(checkpoint.coords.x, checkpoint.coords.y)
                            SetBlipRoute(nextCheckpoint.blip, true)
                            SetBlipRouteColour(nextCheckpoint.blip, 14)
                        else
                            PlaySoundFrontend(-1, "RACE_PLACED", "HUD_AWARDS")

                            raceStatus.checkpoint = raceStatus.checkpoint + 1
                            local nextCheckpoint = race.checkpoints[raceStatus.checkpoint]
                            local checkpointType = raceStatus.checkpoint < #race.checkpoints and 45 or 9

                            SetNewWaypoint(checkpoint.coords.x, checkpoint.coords.y)
                            SetBlipRoute(nextCheckpoint.blip, true)
                            SetBlipRouteColour(nextCheckpoint.blip, 14)
                        end
                    end
                end

                local timeSeconds = (GetGameTimer() - race.startTime)/1000.0
                local timeMinutes = math.floor(timeSeconds/60.0)
                timeSeconds = timeSeconds - 60.0*timeMinutes
                local checkpoint = race.checkpoints[raceStatus.checkpoint]
                Draw2DText(hudPosition.x, hudPosition.y + 0.02, ("~w~CHECKPOINT %d/%d"):format(raceStatus.checkpoint - 1, #race.checkpoints), 0.5)
                Draw2DText(hudPosition.x, hudPosition.y + 0.00, ("~w~LAPS %d/%d"):format(raceStatus.lap, race.laps), 0.5)
                Draw2DText(hudPosition.x, hudPosition.y - 0.04, ("~w~TOTAL: %02d:%06.3f"):format(timeMinutes, timeSeconds), 0.7)
            end  

            if raceStatus.state == "joined" then
                sleep = 5
                local race = races[raceStatus.index]
                currentTime = GetGameTimer()
                count = race.startTime - currentTime

                if count <= 0 then
                    raceStatus.state = "racing"
                    raceStatus.checkpoint = 0
                    FreezeEntityPosition(vehicle, false)
                elseif count <= 5000 then
                    Draw2DText(0.5, 0.4, ("~w~%d"):format(math.ceil(count/1000.0)), 3.0)
                    FreezeEntityPosition(vehicle, true)
                else
                    count = math.ceil((race.startTime - currentTime)/1000.0)
                    Draw2DText(hudPosition.x, hudPosition.y + 0.02, ("Race starting in ~g~".. count .. "~w~s"), 0.7)
                end

            end

        end
        Citizen.Wait(sleep)
    end
end)

function cleanupRace()
    if raceStatus.index ~= 0 then
        local race = races[raceStatus.index]
        local checkpoints = race.checkpoints

        for _, checkpoint in pairs(checkpoints) do
            if checkpoint.blip then
                RemoveBlip(checkpoint.blip)
            end
        end

        if raceStatus.state == "racing" then
            local lastCheckpoint = checkpoints[#checkpoints]
            SetNewWaypoint(lastCheckpoint.coords.x, lastCheckpoint.coords.y)
        end

        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        FreezeEntityPosition(vehicle, false)
    end
end

local spawnedPeds = {}

Citizen.CreateThread(function()
    for k,v in pairs(racerPedsCoords) do
        modelHash = GetHashKey(v.model)
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(1)
        end
        if not DoesEntityExist(ped) then
            
            RequestAnimDict("mini@strip_club@idles@bouncer@base")
            while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
                Wait(1)
            end
            ped =  CreatePed(4, modelHash, v.x, v.y, v.z, 3374176, false, true)
            spawnedPeds[k] = {
                spawnedPed = true,
                ped = ped
            }
            
            SetEntityAsMissionEntity(ped)
            SetEntityHeading(ped, v.h)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            TaskSetBlockingOfNonTemporaryEvents(ped, true)
            TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
            TaskLookAtEntity(ped, GetPlayerPed(-1), -1,2048,3)
            ped = nil
        end
    end
end)

function openRacerPedMenu(data)
    ClearMenu()
    if raceStatus.state == "joined" then
        local race = races[raceStatus.index]
        local currentTime = GetGameTimer()
        local count = race.startTime - currentTime
        
        Menu.addButton("Status: ~g~Joined ~w~(Cost: ~r~$"..race.amount.."~w~, Laps: ~r~".. race.laps.."~w~)", "title")

        if count <= 0 then
            raceStatus.state = "racing"
            raceStatus.checkpoint = 0
        end

        Menu.addButton("Leave Race", "leaveRace")
    else
        for index, race in pairs(races) do
            currentTime = GetGameTimer()
            local count = math.ceil((race.startTime - currentTime)/1000.0)
            if race.organizer == data.pedName then
                Menu.addButton("Join Race (Cost: ~r~$"..race.amount.."~w~, Laps: ~r~".. race.laps.."~w~)", "joinRace", index)
            else
                Menu.addButton("There are no races at this moment", "closeMenuFull")
            end
        end
        if json.encode(races) == "[]" then
            Menu.addButton("There are no races at this moment", "closeMenuFull")
        end
        --[[if json.encode(races) == "[]" then
            Menu.addButton("Create Race", "createRace", data)
        end ]]
    end
    Menu.addButton("Close Menu", "closeMenuFull")
end

function joinRace(index)
    closeMenuFull()
    TriggerServerEvent('lcrp-activities:joinRace_sv', index)
end

--[[ function createRace(data)
    closeMenuFull()
    local raceMoney = scCore.KeyboardInput("Enter $ amount", "", 10)
    local lapCount = scCore.KeyboardInput("Enter Lap Count", "", 1)
    raceMoney = tonumber(raceMoney)
    lapCount = tonumber(lapCount)

    if raceMoney ~= nil and raceMoney > 0 then
        if lapCount ~= nil and lapCount > 0 then
            local startCoords = GetEntityCoords(GetPlayerPed(-1))

            for k, v in pairs(data.checkpoints) do 
                -- print(data.checkpoints[k].coords.x .. " ".. data.checkpoints[k].coords.y.. " ".. data.checkpoints[k].coords.z )
                checkpointCoords = data.checkpoints[k].coords

                local blip = AddBlipForCoord(checkpointCoords.x, checkpointCoords.y, checkpointCoords.z)
                SetBlipColour(blip, 14)
                SetBlipAsShortRange(blip, true)
                ShowNumberOnBlip(blip, #recordedCheckpoints + 1)

                table.insert(recordedCheckpoints, {blip = blip, coords = checkpointCoords})
            end

            TriggerServerEvent('lcrp-activities:server:createRace', raceMoney, startCoords, recordedCheckpoints, lapCount)

            -- Citizen.Wait(100) -- Needs to wait for 'races' data to pass
            -- for index, race in pairs(races) do
            --     TriggerServerEvent('lcrp-activities:joinRace_sv', index)
            -- end
        else
            closeMenuFull()
            return scCore.Notification("Wrong Lap Count!", "error")
        end
    else
        closeMenuFull()
        return scCore.Notification("Wrong money amount!", "error")
    end
end ]]

function leaveRace()
    closeMenuFull()
    cleanupRecording()
    TriggerServerEvent('lcrp-activities:leaveRace_sv', raceStatus.index)
    cleanupRace()
    raceStatus.index = 0
    raceStatus.checkpoint = 0
    raceStatus.state = nil
end

function title()
end

function cleanupRecording()
    for _, checkpoint in pairs(recordedCheckpoints) do
        RemoveBlip(checkpoint.blip)
        checkpoint.blip = nil
    end
    recordedCheckpoints = {}
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        local dist = GetDistanceBetweenCoords(GetGameplayCamCoords(), x, y, z, 1)
        local scale = 1.8*(1/dist)*(1/GetGameplayCamFov())*100
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropShadow(0, 0, 0, 0,255)
        SetTextDropShadow()
        SetTextEdge(4, 0, 0, 0, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function Draw2DText(x, y, text, scale)
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()

	exports["lcrp-interact"]:AddBoxZone("pedRace2", vector3(-2521.55, 2315.05, 33.22), 0.75, 1, {
        name="pedRace2",
        heading=0,
        --debugPoly=true,
        minZ=32.22,
        maxZ=34.22 }, {
        options = {
            {
                event = "lcrp-activities:client:openRaceMenu",
                icon = "fas fa-flag-checkered",
                label = "Talk to Charles",
                duty = false,
                parameters = racerPedsCoords[2]
            },
        },
        job = {"all"}, distance = 5.0})

    exports["lcrp-interact"]:AddBoxZone("pedRace", vector3(134.38, 6640.1, 31.77), 0.6, 0.7, {
    name="pedRace",
    heading=225,
    --debugPoly=true,
    minZ=30.77,
    maxZ=32.77 }, {
        options = {
            {
                event = "lcrp-activities:client:openRaceMenu",
                icon = "fas fa-flag-checkered",
                label = "Talk to Tom",
                duty = false,
                parameters = racerPedsCoords[1]
            },
        },
    job = {"all"}, distance = 5.0})

end)

RegisterNetEvent("lcrp-activities:client:openRaceMenu")
AddEventHandler("lcrp-activities:client:openRaceMenu", function(data)
    Citizen.CreateThread(function()
        openRacerPedMenu(data)
        if Menu.hidden then Menu.hidden = not Menu.hidden end
        while not Menu.hidden do
            Menu.renderGUI()
            Citizen.Wait(5)
        end
    end)  
end)