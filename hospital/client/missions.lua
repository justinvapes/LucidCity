local mission,missionLabel,jobConfig,isWorking,taskLoaded = nil, nil, nil, nil, nil

local cooldown, currentRoom, randomRoomLocation, currentLocation = 0, 0, 0, 1

RegisterNetEvent("hospital:client:SetDoctorMission")
AddEventHandler("hospital:client:SetDoctorMission", function(duty)
    jobConfig = Config.DoctorJobs.doctor
    
    if duty and cooldown > 0 then
        return 
    end

    if PlayerJob.name == "ambulance" and PlayerJob.grade == 2 then
        jobConfig = Config.DoctorJobs.nurse
    end

    mission = jobConfig[math.random(1, #jobConfig)].job

    cooldown = Config.MissionCooldown

    randomRoomLocation = math.random(1, #Config.Locations.jobs[mission][currentLocation].coords)
    currentRoom = Config.Locations.jobs[mission][currentLocation].coords[randomRoomLocation]
    missionLabel = Config.Locations.jobs[mission][currentLocation].text
    TriggerEvent("lcrp-interact:client:updateInteraction", "zone", currentLocation..mission..randomRoomLocation, 'hasHospitalMission', true) 
    Citizen.Wait(4000)
    scCore.Notification("Your new task is: ".. missionLabel)

    taskLoaded = true
    CreateJobBlip()

    if mission == "consultpatient" then
        spawnMissionNPC(currentRoom.pedX, currentRoom.pedY, currentRoom.pedZ, currentRoom.pedH)
    end
end)

RegisterNetEvent("hospital:client:CheckEMSTask")
AddEventHandler("hospital:client:CheckEMSTask", function()
    scCore.Notification("Your current task is: ".. missionLabel)
    CreateJobBlip()
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if cooldown >= 1000 then
            cooldown = cooldown - 1000
        end
    end
end)

--[[ Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if mission ~= nil and currentRoom ~= nil and PlayerJob.name == "ambulance" then 
            if currentLocation ~= 0 and taskLoaded then
                if not DoesBlipExist(currentBlip) then
                    CreateJobBlip()
                end
                local pos = GetEntityCoords(GetPlayerPed(-1))

                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, currentRoom.x, currentRoom.y, currentRoom.z, true) < 10.0) and not isWorking then
                    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, currentRoom.x, currentRoom.y, currentRoom.z, true) < 1.0) and not isWorking then
                       
                        
                        scCore.Draw3DText(currentRoom.x, currentRoom.y, currentRoom.z, "~r~[E]~w~ - ".. Config.Locations.jobs[mission][currentLocation].text)

                        if IsControlJustReleased(0, Keys["E"]) then
                            local plyID = PlayerPedId()
                            isWorking = true

                            if not (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, currentRoom.x, currentRoom.y, currentRoom.z, true) < 0.1) then
                                TaskGoStraightToCoord(plyID, currentRoom.x, currentRoom.y, currentRoom.z, 1.0, -1, 0.0, 0.0) -- go to the coord
                                Citizen.Wait(700)
                                SetEntityHeading(PlayerPedId(), currentRoom.h)
                                SetEntityCoords(PlayerPedId(), currentRoom.x, currentRoom.y, currentRoom.z - 1.0)
                            end
                            
                            -- If animName is being used instead then it will trigger animations event
                            -- This is mainly used for animations with props to make life easier
                            if Config.Locations.jobs[mission][currentLocation].anim == nil then
                                TriggerEvent('animations:client:EmoteCommandStart', {Config.Locations.jobs[mission][currentLocation].animName})
                            end

                            scCore.TaskBar("doctor_task", Config.Locations.jobs[mission][currentLocation].taskbar, Config.Locations.jobs[mission][currentLocation].time, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                animDict = Config.Locations.jobs[mission][currentLocation].animDict,
                                anim = Config.Locations.jobs[mission][currentLocation].anim,
                                flags = 16,
                            }, {}, {}, function() -- Done
                                isWorking = false
                                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                StopAnimTask(GetPlayerPed(-1), Config.Locations.jobs[mission][currentLocation].animDict, Config.Locations.jobs[mission][currentLocation].anim, 1.0)
                                NextTask()
                                CreateJobBlip()
                            end, function() -- Cancel
                                isWorking = false
                                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                StopAnimTask(GetPlayerPed(-1), Config.Locations.jobs[mission][currentLocation].animDict, Config.Locations.jobs[mission][currentLocation].anim, 1.0)
                                scCore.Notification("Cancelled", "error")
                            end)
                        end
                    end
                end
            end
        else
            Citizen.Wait(5000)
        end
    end
end) ]]

function CreateJobBlip()

    if currentLocation ~= 0 and taskLoaded then
        if DoesBlipExist(currentBlip) then
            RemoveBlip(currentBlip)
        end
        currentBlip = AddBlipForCoord(currentRoom.x, currentRoom.y, currentRoom.z)

        SetBlipSprite (currentBlip, Config.Locations.jobs[mission].mapblip)
        SetBlipDisplay(currentBlip, 4)
        SetBlipScale  (currentBlip, 0.7)
        SetBlipAsShortRange(currentBlip, true)
        SetBlipColour(currentBlip, Config.Locations.jobs[mission].mapblipColour)
    
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Task")
        EndTextCommandSetBlipName(currentBlip)
    end
end

function NextTask()
    local tasks = #Config.Locations.jobs[mission]
    
    CreateJobBlip()
    if currentLocation >= tasks then
        
        if mission == "consultpatient" then
            if patientAI ~= nil then
                SetPedAsNoLongerNeeded(patientAI)
            end
            options = {
                {
                    event = "hospital:client:doMission",
                    icon = Config.Locations.jobs["consultpatient"][1].icon,
                    label = Config.Locations.jobs["consultpatient"][1].text,
                    duty = true,
                    hasHospitalMission = false,
                    parameters = {room = randomRoomLocation, step = 1, mission = "consultpatient"}
                },
            }
            TriggerEvent("lcrp-interact:client:updateInteractionOptions","zone","1consultpatient"..randomRoomLocation,options )
        else
            
            TriggerEvent("lcrp-interact:client:updateInteraction", "zone", currentLocation..mission..randomRoomLocation, 'hasHospitalMission', false)
        end
        currentLocation = 1
        TriggerServerEvent("hospital:server:TaskFinished", mission)
        currentRoom = Config.Locations.jobs[mission][currentLocation].coords[randomRoomLocation]
    else
        currentLocation = currentLocation + 1

        if mission == "consultpatient" then
            options = {
                {
                    event = "hospital:client:doMission",
                    icon = Config.Locations.jobs[mission][currentLocation].icon,
                    label = Config.Locations.jobs[mission][currentLocation].text,
                    duty = true,
                    hasHospitalMission = true,
                    parameters = {room = randomRoomLocation, step = currentLocation, mission = "consultpatient"}
                },
            }
            TriggerEvent("lcrp-interact:client:updateInteractionOptions","zone","1consultpatient"..randomRoomLocation,options)
        else
            TriggerEvent("lcrp-interact:client:updateInteraction", "zone", (currentLocation-1)..mission..randomRoomLocation, 'hasHospitalMission', false)
            currentRoom = Config.Locations.jobs[mission][currentLocation].coords[randomRoomLocation]
            TriggerEvent("lcrp-interact:client:updateInteraction", "zone", currentLocation..mission..randomRoomLocation, 'hasHospitalMission', true)
        end
        scCore.Notification("Step completed! Proceed", "success")
    end
end

function spawnMissionNPC(pedX, pedY, pedZ, pedH)
    local Gender = math.random(1, #Config.patientAIs)
    local PedSkin = math.random(1, #Config.patientAIs[Gender])
    local model = GetHashKey(Config.patientAIs[Gender][PedSkin])

    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
     
    -- Ped is only visible for client player
    DeletePed(patientAI)
    patientAI = CreatePed(5, model, pedX, pedY, pedZ, 0.0, false, false)

    ClearPedTasks(patientAI)
    loadAnimDict("timetable@reunited@ig_10")
    TaskPlayAnim(patientAI, "timetable@reunited@ig_10" , "base_amanda", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
    SetEntityHeading(patientAI, pedH)
    SetEntityCoords(patientAI, pedX, pedY, pedZ - 1.0)
    FreezeEntityPosition(patientAI, true)
end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddBoxZone("1makepills1", vector3(310.75, -568.58, 43.28), 1, 1, {
        name="1makepills1",
        heading=340,
        --debugPoly=true,
        minZ=42.28,
        maxZ=44.68
        }, {
		options = {
			{
				event = "hospital:client:doMission",
				icon = "fas fa-vials",
				label = "Take chemicals",
				duty = true,
                hasHospitalMission = false,
                parameters = {room = 1, step = 1, mission = "makepills"}
			},
		},
	job = {"ambulance"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("2makepills1", vector3(309.6, -560.29, 43.28), 1.0, 1.6, {
        name="2makepills1",
        heading=340,
        --debugPoly=true,
        minZ=42.28,
        maxZ=44.28
        }, {
		options = {
			{
				event = "hospital:client:doMission",
				icon = "fas fa-flask",
				label = "Mix chemicals",
				duty = true,
                hasHospitalMission = false,
                parameters = {room = 1, step = 2, mission = "makepills"}
			},
		},
	job = {"ambulance"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("3makepills1", vector3(311.58, -566.49, 43.28), 1.0, 1.0, {
        name="3makepills1",
        heading=340,
        --debugPoly=true,
        minZ=42.28,
        maxZ=43.88
        }, {
		options = {
			{
				event = "hospital:client:doMission",
				icon = "fas fa-pills",
				label = "Make Pills",
				duty = true,
                hasHospitalMission = false,
                parameters = {room = 1, step = 3, mission = "makepills"}
			},
		},
	job = {"ambulance"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("1cleanbeds1", vector3(319.42, -580.84, 43.28), 2.8, 1.4, {
        name="1cleanbeds1",
        heading=339,
        --debugPoly=true,
        minZ=41.48,
        maxZ=43.68
        }, {
		options = {
			{
				event = "hospital:client:doMission",
				icon = "fas fa-stretcher",
				label = "Clean Bed",
				duty = true,
                hasHospitalMission = false,
                parameters = {room = 1, step = 1, mission = "cleanbeds"}
			},
		},
	job = {"ambulance"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("2cleanbeds1", vector3(324.22, -582.73, 43.28), 2.8, 1.4, {
        name="2cleanbeds1",
        heading=340,
        --debugPoly=true,
        minZ=42.28,
        maxZ=43.68
        }, {
		options = {
			{
				event = "hospital:client:doMission",
				icon = "fas fa-stretcher",
				label = "Clean Bed",
				duty = true,
                hasHospitalMission = false,
                parameters = {room = 1, step = 2, mission = "cleanbeds"}
			},
		},
	job = {"ambulance"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("3cleanbeds1", vector3(313.97, -578.87, 43.28), 2.8, 1.4, {
        name="3cleanbeds1",
        heading=340,
        --debugPoly=true,
        minZ=42.28,
        maxZ=43.68
        }, {
		options = {
			{
				event = "hospital:client:doMission",
				icon = "fas fa-stretcher",
				label = "Clean Bed",
				duty = true,
                hasHospitalMission = false,
                parameters = {room = 1, step = 3, mission = "cleanbeds"}
			},
		},
	job = {"ambulance"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("4cleanbeds1", vector3(309.33, -577.24, 43.28), 2.8, 1.4, {
        name="4cleanbed1",
        heading=340,
        --debugPoly=true,
        minZ=42.28,
        maxZ=43.68
        }, {
		options = {
			{
				event = "hospital:client:doMission",
				icon = "fas fa-stretcher",
				label = "Clean Bed",
				duty = true,
                hasHospitalMission = false,
                parameters = {room = 1, step = 4, mission = "cleanbeds"}
			},
		},
	job = {"ambulance"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("5cleanbeds1", vector3(307.72, -581.88, 43.28), 2.8, 1.3, {
        name="5cleanbed1",
        heading=339,
        --debugPoly=true,
        minZ=42.28,
        maxZ=43.68
        }, {
		options = {
			{
				event = "hospital:client:doMission",
				icon = "fas fa-stretcher",
				label = "Clean Bed",
				duty = true,
                hasHospitalMission = false,
                parameters = {room = 1, step = 5, mission = "cleanbeds"}
			},
		},
	job = {"ambulance"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("1sterilize1", vector3(311.02, -567.8, 43.28), 0.6, 1, {
        name="1sterelize1",
        heading=341,
        --debugPoly=true,
        minZ=42.28,
        maxZ=44.08
        }, {
		options = {
			{
				event = "hospital:client:doMission",
				icon = "fas fa-scalpel",
				label = "Sterilize Medical Equipment",
				duty = true,
                hasHospitalMission = false,
                parameters = {room = 1, step = 1, mission = "sterilize"}
			},
		},
	job = {"ambulance"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("1sterilize2", vector3(316.58, -570.06, 43.28), 0.8, 0.8, {
        name="1sterilize2",
        heading=340,
        --debugPoly=true,
        minZ=42.28,
        maxZ=43.68
        }, {
		options = {
			{
				event = "hospital:client:doMission",
				icon = "fas fa-scalpel",
				label = "Sterilize Medical Equipment",
				duty = true,
                hasHospitalMission = false,
                parameters = {room = 2, step = 1, mission = "sterilize"}
			},
		},
	job = {"ambulance"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("2sterilize1", vector3(311.85, -565.65, 43.28), 0.65, 0.8, {
        name="2sterilize1",
        heading=340,
        --debugPoly=true,
        minZ=42.28,
        maxZ=43.88
        }, {
		options = {
			{
				event = "hospital:client:doMission",
				icon = "fas fa-scalpel",
				label = "Sterilize Medical Equipment",
				duty = true,
                hasHospitalMission = false,
                parameters = {room = 1, step = 2, mission = "sterilize"}
			},
		},
	job = {"ambulance"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("2sterilize2", vector3(316.3, -565.03, 43.28), 0.6, 0.8, {
        name="2sterilize2",
        heading=335,
        --debugPoly=true,
        minZ=42.28,
        maxZ=43.48
        }, {
		options = {
			{
				event = "hospital:client:doMission",
				icon = "fas fa-scalpel",
				label = "Sterilize Medical Equipment",
				duty = true,
                hasHospitalMission = false,
                parameters = {room = 2, step = 2, mission = "sterilize"}
			},
		},
	job = {"ambulance"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("3sterilize1", vector3(308.53, -561.34, 43.28), 0.7, 1.2, {
        name="3sterilize1",
        heading=340,
        --debugPoly=true,
        minZ=42.28,
        maxZ=43.88
        }, {
		options = {
			{
				event = "hospital:client:doMission",
				icon = "fas fa-scalpel",
				label = "Sterilize Medical Equipment",
				duty = true,
                hasHospitalMission = false,
                parameters = {room = 1, step = 3, mission = "sterilize"}
			},
		},
	job = {"ambulance"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("3sterilize2", vector3(312.72, -566.3, 43.28), 1.25, 0.8, {
        name="3sterilize2",
        heading=344,
        --debugPoly=true,
        minZ=42.28,
        maxZ=43.88
        }, {
		options = {
			{
				event = "hospital:client:doMission",
				icon = "fas fa-scalpel",
				label = "Sterilize Medical Equipment",
				duty = true,
                hasHospitalMission = false,
                parameters = {room = 2, step = 3, mission = "sterilize"}
			},
		},
	job = {"ambulance"}, distance = 2.0 })


    exports["lcrp-interact"]:AddBoxZone("1consultpatient1", vector3(360.89, -598.86, 43.28), 1, 1, {
        name="1consultpatient1",
        heading=345,
        --debugPoly=true,
        minZ=42.28,
        maxZ=43.88
        }, {
		options = {
			{
				event = "hospital:client:doMission",
				icon = "fas fa-user-md",
				label = "Consult patient",
				duty = true,
                hasHospitalMission = false,
                parameters = {room = 1, step = 1, mission = "consultpatient"}
			},
		},
	job = {"ambulance"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("1consultpatient2", vector3(353.84, -596.61, 43.28), 1, 1, {
        name="1consultpatient2",
        heading=341,
        --debugPoly=true,
        minZ=42.28,
        maxZ=43.68
        }, {
		options = {
			{
				event = "hospital:client:doMission",
				icon = "fas fa-user-md",
				label = "Consult patient",
				duty = true,
                hasHospitalMission = false,
                parameters = {room = 2, step = 1, mission = "consultpatient"}
			},
		},
	job = {"ambulance"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("1consultpatient3", vector3(342.66, -590.89, 43.28), 1, 1, {
        name="1consultpatient3",
        heading=340,
        --debugPoly=true,
        minZ=42.28,
        maxZ=43.68
        }, {
		options = {
			{
				event = "hospital:client:doMission",
				icon = "fas fa-user-md",
				label = "Consult patient",
				duty = true,
                hasHospitalMission = false,
                parameters = {room = 3, step = 1, mission = "consultpatient"}
			},
		},
	job = {"ambulance"}, distance = 2.0 })

end)

RegisterNetEvent("hospital:client:doMission")
AddEventHandler("hospital:client:doMission", function(data)

    if data.step == currentLocation and data.room == randomRoomLocation and mission == data.mission then
        currMission = Config.Locations.jobs[data.mission][data.step]
        currRoom = currMission.coords[data.room]
        local pos = GetEntityCoords(PlayerPedId())
        local plyID = PlayerPedId()
        isWorking = true

        if not (GetDistanceBetweenCoords(pos, currRoom.x, currRoom.y, currRoom.z, true) < 0.1) then
            TaskGoStraightToCoord(plyID, currRoom.x, currRoom.y, currRoom.z, 1.0, -1, 0.0, 0.0) -- go to the coord
            Citizen.Wait(700)
            SetEntityHeading(PlayerPedId(), currRoom.h)
            SetEntityCoords(PlayerPedId(), currRoom.x, currRoom.y, currRoom.z - 1.0)
        end

        -- If animName is being used instead then it will trigger animations event
        -- This is mainly used for animations with props to make life easier
        if currMission.anim == nil then
            TriggerEvent('animations:client:EmoteCommandStart', {currMission.animName})
        end

        scCore.TaskBar("doctor_task", currMission.taskbar, currMission.time, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = currMission.animDict,
            anim = currMission.anim,
            flags = 16,
        }, {}, {}, function() -- Done
            isWorking = false
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            StopAnimTask(GetPlayerPed(-1), currMission.animDict, currMission.anim, 1.0)
            NextTask()
        end, function() -- Cancel
            isWorking = false
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            StopAnimTask(GetPlayerPed(-1), currMission.animDict, currMission.anim, 1.0)
            scCore.Notification("Cancelled", "error")
        end)
    else
        scCore.Notification("This task is not assigned to you!", "error")
    end 
    
end)