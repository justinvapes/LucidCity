PlayerJob = nil
PlayerGrade = nil
onDuty = false
hasActiveLicense = false
myGym = nil

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("gym:server:setSubsPrices")
    scCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        onDuty = PlayerJob.onduty
        PlayerGrade = PlayerData.job.grade
        if PlayerGrade == nil then PlayerGrade = 0 end
        if string.match(PlayerJob.name, "gym") then
            hasActiveLicense = true
            myGym = PlayerJob.name
        elseif PlayerData.metadata["licences"]["gym"] ~= nil then
            hasActiveLicense = PlayerData.metadata["licences"]["gym"]["active"]
            if hasActiveLicense then
                scCore.TriggerServerCallback('gym:server:CheckValid', function(active)
                    if active then
                        myGym = PlayerData.metadata["licences"]["gym"]["gym"]
                    end
                end)
            end
        end
    end)
    isLoggedIn = true
end)

RegisterNetEvent('gym:client:setSubsPrices')
AddEventHandler('gym:client:setSubsPrices', function(gymLicenseTiers)
    Config.gymLicenseTiers = gymLicenseTiers
    TriggerEvent("lcrp-interact:client:updateInteractionOptions",'zone','gym2Subscriptions', setSubscriptions('gym2'))
    TriggerEvent("lcrp-interact:client:updateInteractionOptions",'zone','gymSubscriptions', setSubscriptions('gym'))
end)


RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = JobInfo.onduty
    PlayerGrade = JobInfo.grade
    if string.match(PlayerJob.name, "gym") then
        hasActiveLicense = true
        myGym = PlayerJob.name
    end
end)

RegisterNetEvent('scCore:Client:OnMetaUpdate')
AddEventHandler('scCore:Client:OnMetaUpdate', function(Meta)
    if Meta["licences"]["gym"] ~= nil then
        hasActiveLicense = Meta["licences"]["gym"]["active"]
        if hasActiveLicense then
            myGym = Meta["licences"]["gym"]["gym"]
        end
    end
end)

Exercises = {
    ["Pushups"] = {
        ["idleDict"] = "amb@world_human_push_ups@male@idle_a",
        ["idleAnim"] = "idle_c",
        ["actionDict"] = "amb@world_human_push_ups@male@base",
        ["actionAnim"] = "base",
        ["actionTime"] = 1100,
        ["enterDict"] = "amb@world_human_push_ups@male@enter",
        ["enterAnim"] = "enter",
        ["enterTime"] = 3050,
        ["exitDict"] = "amb@world_human_push_ups@male@exit",
        ["exitAnim"] = "exit",
        ["exitTime"] = 3400,
        ["actionProcent"] = 1,
        ["actionProcentTimes"] = 3,
    },
    ["Situps"] = {
        ["idleDict"] = "amb@world_human_sit_ups@male@idle_a",
        ["idleAnim"] = "idle_a",
        ["actionDict"] = "amb@world_human_sit_ups@male@base",
        ["actionAnim"] = "base",
        ["actionTime"] = 3400,
        ["enterDict"] = "amb@world_human_sit_ups@male@enter",
        ["enterAnim"] = "enter",
        ["enterTime"] = 4200,
        ["exitDict"] = "amb@world_human_sit_ups@male@exit",
        ["exitAnim"] = "exit", 
        ["exitTime"] = 3700,
        ["actionProcent"] = 1,
        ["actionProcentTimes"] = 10,
    },
    ["Chins"] = {
        ["idleDict"] = "amb@prop_human_muscle_chin_ups@male@idle_a",
        ["idleAnim"] = "idle_a",
        ["actionDict"] = "amb@prop_human_muscle_chin_ups@male@base",
        ["actionAnim"] = "base",
        ["actionTime"] = 3000,
        ["enterDict"] = "amb@prop_human_muscle_chin_ups@male@enter",
        ["enterAnim"] = "enter",
        ["enterTime"] = 1600,
        ["exitDict"] = "amb@prop_human_muscle_chin_ups@male@exit",
        ["exitAnim"] = "exit",
        ["exitTime"] = 3700,
        ["actionProcent"] = 1,
        ["actionProcentTimes"] = 10,
    },
}

Locations = {  
    ["gym"] = {
        {["x"] = -78.28, ["y"] = -1285.897, ["z"] = 23.145 - 0.98, ["h"] = 90.09, ["exercise"] = "Chins"},
        {["x"] = -75.416, ["y"] = -1280.434,["z"] = 23.145 - 0.98, ["h"] = nil, ["exercise"] = "Pushups"},
        {["x"] = -74.33234, ["y"] = -1285.649, ["z"] = 23.55  - 0.98, ["h"] = nil, ["exercise"] = "Situps"},
    },
    ["gym2"] = {
        {["x"] = -743.99, ["y"] = 267.50, ["z"] = 75.67 - 0.98, ["h"] = 187.09, ["exercise"] = "Chins"},    
        {["x"] = -746.17, ["y"] = 267.06, ["z"] = 75.67 - 0.98, ["h"] = 187.09, ["exercise"] = "Chins"},
        {["x"] = -748.25, ["y"] = 266.71 , ["z"] = 75.67 - 0.98, ["h"] = 187.09, ["exercise"] = "Chins"},   
        {["x"] = -741.12, ["y"] = 261.19, ["z"] = 75.68 - 0.98, ["h"] = nil, ["exercise"] = "Pushups"}, 
        {["x"] = -762.33, ["y"] = 266.86, ["z"] = 75.69 - 0.98, ["h"] = nil, ["exercise"] = "Situps"},   
    }
} 

MapBlips = { 
    [1] = {["x"] = -45.13, ["y"] = -1289.88, ["z"] = 29.18, ["id"] = 311, ["color"] = 49, ["scale"] = 0.8, ["text"] = "Gym"},
    [2] = {["x"] = -756.85, ["y"] = 241.86, ["z"] = 75.67, ["id"] = 311, ["color"] = 7, ["scale"] = 0.8, ["text"] = "Lucid Fitness"},  
}


Staff = {
    ["gym"] = {
        ["chiefactions"] = {
            [1] = {x = -75.145, y = -1289.238, z = 23.145, h = 268.7441558379}
            },
        ["duty"] = {
            [1] = {x = -54.83985, y = -1294.059, z = 30.90, h = 66.798},
            },
        ["outfits"] = {
            [1] = {x = -68.28, y = -1289.869, z =23.145, h = 358.12},
            [2] = {x = -64.98, y = -1289.869, z =23.145, h = 358.12},
            }, 
        ["setLicense"] = {
            [1] = {x = -53.717, y = -1292.22, z =30.90, h = 3.5812},
            }, 
    },
    ["gym2"] = {
        ["chiefactions"] = {
            [1] = {x = -752.95, y = 270.08, z = 75.67, h = 268.7441558379}
            },
        ["duty"] = {
            [1] = {x = -761.83, y = 251.88, z = 75.67, h = 66.798},
            },
        ["outfits"] = {
            [1] = {x = -774.48, y = 263.01, z = 75.67},
            }, 
        ["setLicense"] = {
            [1] = {x = -764.65, y = 252.39, z = 75.67, h = 3.5812},
            }, 
    }  
}

buyLicense = {
    [1] = {x = -53.45359, y = -1291.134, z = 30.92, gym = "gym" },
    [2] = {x = -764.61 , y = 250.27, z = 75.67, gym = "gym2" } 

}

local Keys = {["E"] = 38, ["SPACE"] = 22, ["DELETE"] = 178}
local canExercise = false
local exercising = false
local procent = 0
local motionProcent = 0
local doingMotion = false
local motionTimesDone = 0

function startExercise(animInfo, pos)
    local playerPed = PlayerPedId()

    LoadDict(animInfo["idleDict"])
    LoadDict(animInfo["enterDict"])
    LoadDict(animInfo["exitDict"])
    LoadDict(animInfo["actionDict"])

    if pos["h"] ~= nil then
        SetEntityCoords(playerPed, pos["x"], pos["y"], pos["z"])
        SetEntityHeading(playerPed, pos["h"])
    end

    TaskPlayAnim(playerPed, animInfo["enterDict"], animInfo["enterAnim"], 8.0, -8.0, animInfo["enterTime"], 0, 0.0, 0, 0, 0)
    Citizen.Wait(animInfo["enterTime"])

    canExercise = true
    exercising = true

    Citizen.CreateThread(function()
        while exercising do
            Citizen.Wait(1)
            if procent <= 24.99 then
                color = "~r~"
            elseif procent <= 49.99 then
                color = "~o~"
            elseif procent <= 74.99 then
                color = "~b~"
            elseif procent <= 100 then
                color = "~g~"
            end

            DrawText2D(1.305, 1.38, 1.0,1.0,0.33, "Percentage: " .. color..procent .. "%", 255, 255, 255, 255)
            DrawText2D(1.305, 1.42, 1.0,1.0,0.33, "Press ~g~[SPACE]~w~ to train", 255, 255, 255, 255)
            DrawText2D(1.305, 1.45, 1.0,1.0,0.33, "Press ~r~[DELETE]~w~ to stop training", 255, 255, 255, 255)
        end
    end)

    Citizen.CreateThread(function()
        while canExercise do
            Citizen.Wait(8)
            local playerCoords = GetEntityCoords(playerPed)
            if procent <= 99 then
                TaskPlayAnim(playerPed, animInfo["idleDict"], animInfo["idleAnim"], 8.0, -8.0, -1, 0, 0.0, 0, 0, 0)
                if IsControlJustPressed(0, Keys["SPACE"]) then -- press space to train
                    canExercise = false
                    TaskPlayAnim(playerPed, animInfo["actionDict"], animInfo["actionAnim"], 8.0, -8.0, animInfo["actionTime"], 0, 0.0, 0, 0, 0)
                    AddProcent(animInfo["actionProcent"], animInfo["actionProcentTimes"], animInfo["actionTime"] - 70)
                    canExercise = true
                end
                if IsControlJustPressed(0, Keys["DELETE"]) then -- press delete to exit training
                    ExitTraining(animInfo["exitDict"], animInfo["exitAnim"], animInfo["exitTime"])
                end
            else
                ExitTraining(animInfo["exitDict"], animInfo["exitAnim"], animInfo["exitTime"])
                TriggerServerEvent("player:UpdateSkill", "add", "strength", 1)
                -- Here u can put a event to update some sort of skill or something.
                -- this is when u finished your exercise
            end
        end
    end)
end

function ExitTraining(exitDict, exitAnim, exitTime)
    TaskPlayAnim(PlayerPedId(), exitDict, exitAnim, 8.0, -8.0, exitTime, 0, 0.0, 0, 0, 0)
    Citizen.Wait(exitTime)
    canExercise = false
    exercising = false
    procent = 0
end

function AddProcent(amount, amountTimes, time)
    for i=1, amountTimes do
        Citizen.Wait(time/amountTimes)
        procent = procent + amount
    end
end

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end
      
function DrawText2D(x, y, width, height, scale, text, r, g, b, a, outline)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

Citizen.CreateThread(function()
    for i=1, #MapBlips, 1 do
        local Blip = MapBlips[i]
        blip = AddBlipForCoord(Blip["x"], Blip["y"], Blip["z"])
        SetBlipSprite(blip, Blip["id"])
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Blip["scale"])
        SetBlipColour(blip, Blip["color"])
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Blip["text"])
        EndTextCommandSetBlipName(blip)
    end
end)

--[[ RegisterNetEvent('gym:client:RegisterGymLicense')
AddEventHandler('gym:client:RegisterGymLicense', function(type, chosenGym)
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent("gym:server:RegisterGymLicense", playerId, type, chosenGym)
    else
        scCore.Notification("No one around!", "error")
    end
end) ]]

RegisterNetEvent('gym:client:RevokeGymLicense')
AddEventHandler('gym:client:RevokeGymLicense', function()
    if string.match(PlayerJob.name, "gym") then
        local player, distance = GetClosestPlayer()
        if player ~= -1 and distance < 2.5 then
            local playerId = GetPlayerServerId(player)
            TriggerServerEvent("gym:server:RevokeGymLicense", playerId)
        else
            scCore.Notification("No one around!", "error")
        end
    end
end)

RegisterNetEvent('gym:client:CheckGymLicense')
AddEventHandler('gym:client:CheckGymLicense', function()
    if string.match(PlayerJob.name, "gym") then
        local player, distance = GetClosestPlayer()
        if player ~= -1 and distance < 2.5 then
            local playerId = GetPlayerServerId(player)
            TriggerServerEvent("gym:server:CheckGymLicense", playerId)
        else
            scCore.Notification("No one around!", "error")
        end
    end
end)


function GetClosestPlayer()
    local closestPlayers = scCore.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end


Citizen.CreateThread(function()
    SpawnObject('prop_muscle_bench_05', { 
		x = -79.081,
		y = -1285.884,
		z = 23.2
	}, function(obj)
		SetEntityHeading(obj, 270.980)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
    end) 
end)

function SpawnObject(model, coords, cb)
    if tonumber(model) ~= nil then 
        model = tonumber(model)
    end
    if type(model) == 'string' then
        model = GetHashKey(model) 
    end
    
	Citizen.CreateThread(function()
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end

		local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, false)

        if cb ~= nil then
			cb(obj)
		end
	end)
end

function SelectOutfit(outfit)
    if outfit == "civilian" then
        TriggerServerEvent('lcrp-clothes:get_character_current')
        TriggerServerEvent("lcrp-clothes:retrieve_tats")
    end

    if outfit == "security" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 50, texture = 2},
                ["arms"]        = { item = 6, texture = 0}, 
                ["t-shirt"]     = { item = 23, texture = 1},  
                ["torso2"]      = { item = 72, texture = 2},  
                ["shoes"]       = { item = 36, texture = 3},
                ["glass"]       = { item = 17, texture = 2},    
                ["ear"]       = { item = 0, texture = 0}, 
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "training_male" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 2, texture = 0},
                ["torso2"]      = { item = 5, texture = 0},  
                ["shoes"]       = { item = 14, texture = 0},  
                ["arms"]         = { item = 5, texture = 0},  
                ["t-shirt"]     = { item = -1, texture = 0},  
                ["ear"]     = { item = -1, texture = 0},  
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "training_female" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 18, texture = 0},
                ["arms"]        = { item = 15, texture = 0}, 
                ["t-shirt"]     = { item = 15, texture = 2},  
                ["torso2"]      = { item = -1, texture = 8},  
                ["shoes"]       = { item = 14, texture = 0},  
                ["glass"]       = { item = -1, texture = 2},   
                ["ear"]         = { item = -1, texture = 0}
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end


    TriggerEvent('InteractSound_CL:PlayOnOne','Clothes1', 0.6)
    closeMenuFull()
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function close()
    Menu.hidden = true
end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()

    exports["lcrp-interact"]:AddBoxZone("gymDuty", vector3(-53.22, -1294.18, 30.91), 1.4, 3.8, {
        name="gymDuty",
        heading=0,
        --debugPoly=true,
        minZ=29.51,
        maxZ=31.51
        }, {
        options = {
            {
                event = "police:client:Duty",
                icon = "fas fa-address-card",
                label = "Clock in",
                duty = false,
                parameters = "duty",
            },
            {
                event = "police:client:Duty",
                icon = "fas fa-address-card",
                label = "Clock out",
                duty = true,
                parameters = "duty",
            },
        },
        job = {"gym"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("gymBoss", vector3(-74.25, -1288.67, 23.15), 2.8, 1.4, {
        name="gymBoss",
        heading=0,
        --debugPoly=true,
        minZ=20.95,
        maxZ=23.55 }, {
        options = {
            {
                event = "police:server:OpenSocietyMenu",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
                parameters = 'gym'
            },
        },
        job = {"gym"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("gymOutfits", vector3(-68.44, -1290.65, 23.15), 3.6, 3.6, {
        name="gymOutfits",
        heading=0,
        --debugPoly=true,
        minZ=21.15,
        maxZ=24.55 }, {
        options = setInteractClothes("gym"),
        job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("gymOutfits2", vector3(-65.01, -1290.59, 23.15), 3.8, 3.4, {
        name="gymOutfits2",
        heading=0,
        --debugPoly=true,
        minZ=21.35,
        maxZ=24.55 }, {
        options = setInteractClothes("gym"),
        job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("gymPushups", vector3(-76.39, -1280.0, 23.15), 2.2, 2.0, {
        name="gymPushups",
        heading=0,
        --debugPoly=true,
        minZ=21.35,
        maxZ=23.35 }, {
        options = {
            {
                event = "gym:client:exercise",
                icon = "fas fa-dumbbell",
                label = "Pushups",
                duty = false,
                gymLicenseRequired = "gym",
                parameters = json.encode({gym='gym',exercise='pushup'})
            },
        },
        job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("gymSitups", vector3(-74.07, -1285.92, 23.15), 2.8, 2.8, {
        name="gymSitups",
        heading=0,
        --debugPoly=true,
        minZ=21.95,
        maxZ=23.95 }, {
        options = {
            {
                event = "gym:client:exercise",
                icon = "fas fa-dumbbell",
                label = "Situps",
                duty = false,
                gymLicenseRequired = "gym",
                parameters = json.encode({gym='gym',exercise='situp'})
            },
        },
        job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("gymChins", vector3(-79.27, -1286.37, 23.15), 2.4, 2.2, {
        name="gymChins",
        heading=0,
        --debugPoly=true,
        minZ=22.15,
        maxZ=25.35 }, {
        options = {
            {
                event = "gym:client:exercise",
                icon = "fas fa-dumbbell",
                label = "Chins",
                duty = false,
                gymLicenseRequired = "gym",
                parameters = json.encode({gym='gym',exercise='chin'})
            },
        },
        job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("gymSubscriptions", vector3(-53.38, -1291.82, 30.92), 0.6, 3.0, {
        name="gymSubscriptions",
        heading=0,
        --debugPoly=true,
        minZ=30.32,
        maxZ=31.9 }, {
        options = setSubscriptions('gym'),
        job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("gym2Duty", vector3(-754.61, 244.6, 75.68), 2.8, 1, {
        name="gym2Duty",
        heading=10,
        --debugPoly=true,
        minZ=74.68,
        maxZ=77.48
        }, {
        options = {
            {
                event = "police:client:Duty",
                icon = "fas fa-address-card",
                label = "Clock in",
                duty = false,
                parameters = "duty",
            },
            {
                event = "police:client:Duty",
                icon = "fas fa-address-card",
                label = "Clock out",
                duty = true,
                parameters = "duty",
            },
        },
        job = {"gym2"}, distance = 2.0 })
    
    exports["lcrp-interact"]:AddBoxZone("gym2Boss", vector3(-753.55, 269.96, 75.68), 2.8, 1.4, {
        name="gym2Boss",
        heading=10,
        --debugPoly=true,
        minZ=74.28,
        maxZ=76.28 }, {
        options = {
            {
                event = "police:server:OpenSocietyMenu",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
                parameters = 'gym2'
            },
        },
        job = {"gym2"}, distance = 2.0})

    ------------------

    exports["lcrp-interact"]:AddBoxZone("gym2Outfits", vector3(-775.78, 259.36, 75.67), 0.5, 4.8, {
        name="gym2Outfits",
        heading=11,
        --debugPoly=true,
        minZ=75.07,
        maxZ=77.27 }, {
        options = setInteractClothes("gym2"),
        job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("gym2Outfits2", vector3(-778.19, 260.66, 75.68), 3.8, 0.8, {
        name="gym2Outfits2",
        heading=11,
        --debugPoly=true,
        minZ=75.28,
        maxZ=77.28 }, {
        options = setInteractClothes("gym2"),
        job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("gym2Outfits3", vector3(-771.83, 264.41, 75.68), 5.6, 0.6, {
        name="gym2Outfits3",
        heading=10,
        --debugPoly=true,
        minZ=75.28,
        maxZ=77.28 }, {
        options = setInteractClothes("gym2"),
        job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("gym2Pushups", vector3(-741.12, 261.19, 75.68), 1.8, 2.0, {
        name="gym2Pushups",
        heading=10,
        --debugPoly=true,
        minZ=74.08,
        maxZ=76.08
         }, {
        options = {
            {
                event = "gym:client:exercise",
                icon = "fas fa-dumbbell",
                label = "Pushups",
                duty = false,
                gymLicenseRequired = "gym2",
                parameters = json.encode({gym='gym2',exercise='pushup'})
            },
        },
        job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("gym2Situps", vector3(-762.27, 267.14, 75.69), 2.8, 3.8, {
        name="gym2Situps",
        heading=10,
        --debugPoly=true,
        minZ=74.29,
        maxZ=76.49 }, {
        options = {
            {
                event = "gym:client:exercise",
                icon = "fas fa-dumbbell",
                label = "Situps",
                duty = false,
                gymLicenseRequired = "gym2",
                parameters = json.encode({gym='gym2',exercise='situp'})
            },
        },
        job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("gym2Chins", vector3(-743.84, 266.68, 75.68), 1.6, 1, {
        name="gym2Chins",
        heading=10,
        --debugPoly=true,
        minZ=74.68,
        maxZ=76.88 }, {
        options = {
            {
                event = "gym:client:exercise",
                icon = "fas fa-dumbbell",
                label = "Chins",
                duty = false,
                gymLicenseRequired = "gym2",
                parameters = json.encode({gym='gym2',exercise='chin'})
            },
        },
        job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("gym2Chins2", vector3(-746.07, 266.19, 75.68), 1.8, 1, {
        name="gym2Chins2",
        heading=10,
        --debugPoly=true,
        minZ=74.68,
        maxZ=76.88 }, {
        options = {
            {
                event = "gym:client:exercise",
                icon = "fas fa-dumbbell",
                label = "Chins",
                duty = false,
                gymLicenseRequired = "gym2",
                parameters = json.encode({gym='gym2',exercise='chin'})
            },
        },
        job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("gym2Chins3", vector3(-748.09, 265.85, 75.68), 1.8, 1, {
        name="gym2Chins3",
        heading=10,
        --debugPoly=true,
        minZ=74.48,
        maxZ=76.88 }, {
        options = {
            {
                event = "gym:client:exercise",
                icon = "fas fa-dumbbell",
                label = "Chins",
                duty = false,
                gymLicenseRequired = "gym2",
                parameters = json.encode({gym='gym2',exercise='chin'})
            },
        },
        job = {"all"}, distance = 2.0})
    exports["lcrp-interact"]:AddBoxZone("gym2Subscriptions", vector3(-764.36, 251.21, 75.68), 1.2, 5.2, {
        name="gym2Subscriptions",
        heading=10,
        --debugPoly=true,
        minZ=74.28,
        maxZ=76.28 }, {
        options = setSubscriptions('gym2'),
        job = {"all"}, distance = 2.0})
end)

RegisterNetEvent('gym:client:selectedOutfit')
AddEventHandler('gym:client:selectedOutfit', function(selection)
    SelectOutfit(selection)
end)

RegisterNetEvent('gym:client:exercise')
AddEventHandler('gym:client:exercise', function(exercise)
    exercise = json.decode(exercise)
    coords = GetEntityCoords(PlayerPedId())
    if hasActiveLicense then
        if myGym ~= nil and myGym == exercise.gym then 
            for i, v in pairs(Locations[myGym]) do
                local pos = Locations[myGym][i]
                local dist = GetDistanceBetweenCoords(pos["x"], pos["y"], pos["z"] + 0.98, coords, true)
                minDist = 2.0
                if dist <= minDist and not exercising then
                    startExercise(Exercises[pos["exercise"]], pos)
                end
            end
        else
            scCore.Notification("You don\'t have an active subscription in this gym!","error")
        end
    else
        scCore.Notification("You don\'t have an active subscription in this gym!","error")
    end
end)

Outfits = {
    [1] = {name = 'security', label = "Security"},
    [2] = {name = 'training_male', label = "Training Male"},
    [3] = {name = 'training_female', label = "Big Boi"},
}

function setInteractClothes(gym)
    outfits = {
        {
            event = "",
            icon = "",
            label = "Gym Outfits",
            duty = false,
            gymLicenseRequired = gym,
        },
        {
            event = "gym:client:selectedOutfit",
            icon = "far fa-tshirt",
            label = "Civilian",
            duty = false,
            gymLicenseRequired = gym,
            parameters = "civilian"
        },
    }
    for k,v in pairs(Outfits) do
        table.insert(outfits, {
            event = "gym:client:selectedOutfit",
            icon = "far fa-tshirt",
            label = v.label,
            duty = false,
            gymLicenseRequired = gym,
            parameters = v.name
        })
    end

    return outfits
end

RegisterNetEvent('gym:client:updatePrice')
AddEventHandler('gym:client:updatePrice', function(tier, newPrice)
	Config.gymLicenseTiers['gym'][tier].price = newPrice
    TriggerEvent("lcrp-interact:client:updateInteractionOptions",'zone','gymSubscriptions', setSubscriptions('gym'))
end)

RegisterNetEvent('gym2:client:updatePrice')
AddEventHandler('gym2:client:updatePrice', function(tier, newPrice)
	Config.gymLicenseTiers['gym2'][tier].price = newPrice
    TriggerEvent("lcrp-interact:client:updateInteractionOptions",'zone','gym2Subscriptions', setSubscriptions('gym2'))
end)

RegisterNetEvent('gym:client:buySubscription')
AddEventHandler('gym:client:buySubscription', function(data)
	subTier(data)
end)

function setSubscriptions(gym)
    subs = {
        {
            event = "",
            icon = "",
            label = "Buy Subscription",
            duty = false
        } 
    }
    
    for k,v in pairs(Config.gymLicenseTiers[gym]) do
        table.insert(subs,{
            event = "gym:client:buySubscription",
            icon = "far fa-ticket-alt",
            label = "Subscription "..k.." | "..v.time.." days | $"..v.price,
            duty = false,
            parameters = {tier = k, gym = gym}
        })
    end
    return subs
end

function subTier(data)
    TriggerServerEvent('gym:server:RegisterGymLicense', data.tier, data.gym)
end

function MyGym()
    return myGym
end