local trashObject = nil
local washingAction = 1
local cookAction = 1
local JobCooldown = 0
local isCarrying = false
local jailAlarm = false
local shiftControl = 21 -- INPUT_SPRINT
local spaceControl = 22 -- INPUT_JUMP
local enterControl = 23 -- INPUT_ENTER
local attackControl = 24 -- INPUT_ATTACK
local aggroControl = 25 -- AIM
currentBlip = nil

RegisterNetEvent("lcrp-jail:client:DoCookTask")
AddEventHandler("lcrp-jail:client:DoCookTask", function(data)
    if inJail then
        if currentJob == "Cook" then
            if data.location == 1 or data.location == 2 then

                if data.location == 1 then
                    TriggerEvent('animations:client:EmoteCommandStart', {"pickup2"})
                    taskbarLabel = "Picking Up ".. data.label
                elseif data.location == 2 then
                    TriggerEvent('animations:client:EmoteCommandStart', {"fill"})
                    taskbarLabel = "Filling Water"
                end
                
                scCore.TriggerServerCallback('scCore:HasItem', function(hasItem)
                    if not hasItem then
                        scCore.TaskBar("prison_cookPick", taskbarLabel, math.random(1500, 2500), false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {}, {}, {}, function() -- Done
                            TriggerServerEvent("lcrp-jail:server:GiveCookItem", data)
                            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        end, function() -- Cancel
                            scCore.Notification("Cancelled", "error")
                            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        end)
                    else
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        scCore.Notification("You already have ".. scCore.Shared.Items[data.item].label.."!", "error")
                    end
                end, data.item)
            elseif data.location == 4 then
                if cookAction == 2 then
                    scCore.TriggerServerCallback('scCore:HasItem', function(hasItem)
                        if hasItem then
                            TriggerEvent('animations:client:EmoteCommandStart', {"pickup2"})
                            scCore.TaskBar("pick_laundry", "Placing "..data.label, math.random(2000, 3000), false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                cookAction = 1
                                TriggerServerEvent("lcrp-jail:server:GiveCookItem", data)
                                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                            end, function() -- Cancel
                                scCore.Notification("Cancelled", "error")
                                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                            end)
                        else
                            scCore.Notification("You are missing ".. scCore.Shared.Items[data.item].label.."!", "error")
                        end
                    end, data.item)
                else
                    scCore.Notification("You have to cook soup first!", "error")
                end
            end
        else
            scCore.Notification("Your job is not Cook!", "error")
        end
    else
        scCore.Notification("You are not even serving time, What are you doing here?", "error")
    end
end)

RegisterNetEvent("lcrp-jail:client:StartCooking")
AddEventHandler("lcrp-jail:client:StartCooking", function(data)
    if cookAction == 1 then
        scCore.TaskBar("pick_laundry", "Cooking "..data.label, math.random(5000, 10000), false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "amb@prop_human_bbq@male@idle_a",
            anim = "idle_b",
            flags = 16,
        }, {}, {}, function() -- Done
            TriggerServerEvent("lcrp-jail:server:GiveCookItem", data)
            ClearPedTasks(PlayerPedId())
            cookAction = 2
        end, function() -- Cancel
            scCore.Notification("Cancelled", "error")
            ClearPedTasks(PlayerPedId())
        end)
    else
        scCore.Notification("You already cooked soup, now go place it on the table!", "error")
    end
end)

RegisterNetEvent("lcrp-jail:client:FinishedCookJob")
AddEventHandler("lcrp-jail:client:FinishedCookJob", function()
    if inJail and currentJob == "Cook" and cookAction == 2 then
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, Config.Locations.jobs["Cook"][4].coords.x, Config.Locations.jobs["Cook"][4].coords.y, Config.Locations.jobs["Cook"][4].coords.z, true)
        
        if distance < 4.0 then
            jailTime = jailTime - math.random(3, 5)
            scCore.Notification("You've worked some time off your sentence")
        end
    end 
end)

RegisterNetEvent("lcrp-jail:client:DoJanitorTask")
AddEventHandler("lcrp-jail:client:DoJanitorTask", function()
    if inJail then
        local playerCoords = GetEntityCoords(PlayerPedId())
        local objFound = GetClosestObjectOfType(playerCoords, 1.5, GetHashKey("prop_rub_litter_06"), 0, 0, 0)
        local objFound2 = GetClosestObjectOfType(playerCoords, 0.5, GetHashKey("prop_tool_broom"), 0, 0, 0) -- broom

        -- Prevent triggering event when player isn't close to object
        if not DoesEntityExist(objFound) then
            return scCore.Notification("Trash not found?", "error")
        elseif not DoesEntityExist(objFound2) then
            return scCore.Notification("You need a broom to start cleaning!", "error")
        end

        if currentJob == "Janitor" then 
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            TriggerEvent('animations:client:EmoteCommandStart', {"broomanim"})
            scCore.TaskBar("prison_janitor", "Cleaning", math.random(5000, 10000), false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                JobDone()
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                TriggerEvent('animations:client:EmoteCommandStart', {"broom"})
            end, function() -- Cancel
                scCore.Notification("Cancelled", "error")
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                TriggerEvent('animations:client:EmoteCommandStart', {"broom"})
            end)
        else
            scCore.Notification("Your job is not Janitor!", "error")
        end
    else
        scCore.Notification("You are not even serving time, What are you doing here?", "error")
    end
end)

RegisterNetEvent("lcrp-jail:client:DoLaundryTask")
AddEventHandler("lcrp-jail:client:DoLaundryTask", function(data)
    local plyID = PlayerPedId()

    if inJail then
        if currentJob == "Launder" then 
            TaskGoStraightToCoord(plyID, data.coords.x, data.coords.y, data.coords.z, 1.0, -1, 0.0, 0.0) -- go to the coord
            Citizen.Wait(700)
            SetEntityHeading(PlayerPedId(), data.coords.h)
            SetEntityCoords(PlayerPedId(), data.coords.x, data.coords.y, data.coords.z - 1.0)
            if data.action == 1 then
                if not isCarrying then
                    scCore.TaskBar("pick_laundry", "Picking up laundry", math.random(5000, 10000), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "amb@prop_human_parking_meter@male@idle_a",
                        anim = "idle_a",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        isCarrying = true
                        carryObject("laundry")
                        ClearPedTasks(PlayerPedId())
                    end, function() -- Cancel
                        scCore.Notification("Cancelled", "error")
                        ClearPedTasks(PlayerPedId())
                    end)
                else
                    scCore.Notification("You already picked up laundry!", "error") 
                end
            end
            if data.action == 2 then
                if isCarrying then
                    isCarrying = false
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    Citizen.Wait(500)
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    scCore.TaskBar("pickup_detergent", "Picking up Laundry Detergent", math.random(2000, 3000), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                        disableCancel = true,
                    }, {
                        animDict = "amb@prop_human_parking_meter@male@idle_a",
                        anim = "idle_a",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        ClearPedTasks(PlayerPedId())
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        isCarrying = true
                        carryObject("laundry")
                        TriggerServerEvent("lcrp-jail:server:GiveLaundryDetergent")
                    end)
                else
                    scCore.Notification("Pick up laundry first!", "error") 
                end
            end
            if data.action == 3 then
                if washingAction == 4 or washingAction == 5 then 
                    return scCore.Notification("You already washed clothes!", "error") 
                end
                scCore.TriggerServerCallback('scCore:HasItem', function(Item)
                    if Item then
                        if isCarrying then
                            isCarrying = false
                            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                            Citizen.Wait(500)
                            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                            TriggerServerEvent("scCore:Server:RemoveItem", "laundry_detergent", 1)
                            TriggerEvent("inventory:client:ItemBox", scCore.Shared.Items["laundry_detergent"], "remove")
                            WashingMachineTasks()
                        else
                            scCore.Notification("Pick up laundry first!", "error") 
                        end
                    else
                        scCore.Notification("You need Laundry Detergent!", "error") 
                    end
                end, "laundry_detergent")
            end
            if data.action == 4 then
                if isCarrying and washingAction == 4 then
                    local cSCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
                    local IronSpawn = CreateObject(GetHashKey("prop_iron_01"), cSCoords.x, cSCoords.y, cSCoords.z, 1, 1, 1)
                    local netid = ObjToNet(IronSpawn)
                    isCarrying = false
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    Citizen.Wait(500)
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})     
                    
                    SetTimeout(1500, function()
                        AttachEntityToEntity(IronSpawn, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 57005), 0.15, 0.0, -0.05, 0.0, 90.0, 60.0, 1, 1, 0, 1, 0, 1)
                        ironModel = netid
                    end)
                
                    scCore.TaskBar("pickup_detergent", "Ironing clothes", math.random(5000, 6000), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                        disableCancel = true,
                    }, {
                        animDict = "amb@prop_human_bbq@male@enter",
                        anim = "enter",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        ClearPedTasks(PlayerPedId())
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        DetachEntity(NetToObj(ironModel), 1, 1)
                        DeleteEntity(NetToObj(ironModel))
                        isCarrying = true
                        ironModel = nil
                        washingAction = washingAction + 1
                        carryObject("laundry")
                    end)
                else
                    scCore.Notification("Wash clothes first!", "error") 
                end
            end
            if data.action == 5 then
                if isCarrying and washingAction == 5 then
                    isCarrying = false
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    Citizen.Wait(500)
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    scCore.TaskBar("prison_job", "Placing Clean Clothes", math.random(2000, 3000), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                        disableCancel = true,
                    }, {
                        animDict = "amb@medic@standing@timeofdeath@exit",
                        anim = "exit",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        data.washingAction = washingAction
                        washingAction = 1
                        jailTime = jailTime - math.random(2, 4)
                        ClearPedTasks(PlayerPedId())
                        scCore.Notification("You've worked some time off your sentence")
                        if math.random(1, 100) <= 10 then
                            TriggerServerEvent("lcrp-jail:server:RandomItem", data, currentJob)
                        end
                    end, function() -- Cancel
                        washingAction = 1
                        carryObject("laundry")
                        ClearPedTasks(PlayerPedId())
                    end)
                else
                    scCore.Notification("Wash and iron clothes first!", "error") 
                end
            end
        else
            scCore.Notification("Your job is not Launder!")
        end
    else
        scCore.Notification("You are not even serving time, What are you doing here?", "error")
    end
end)

RegisterNetEvent("lcrp-jail:client:ToggleJailAlarm")
AddEventHandler("lcrp-jail:client:ToggleJailAlarm", function()
    local alarmIpl = GetInteriorAtCoordsWithType(1787.004,2593.1984,45.7978,"int_prison_main")

    if jailAlarm then 
        RefreshInterior(alarmIpl)
        EnableInteriorProp(alarmIpl, "prison_alarm")

        Citizen.CreateThread(function()
            while not PrepareAlarm("PRISON_ALARMS") do
                Citizen.Wait(100)
            end
            StartAlarm("PRISON_ALARMS", true)
            jailAlarm = false
        end)
    else
        RefreshInterior(alarmIpl)
        DisableInteriorProp(alarmIpl, "prison_alarm")

        Citizen.CreateThread(function()
            while not PrepareAlarm("PRISON_ALARMS") do
                Citizen.Wait(100)
            end
            StopAllAlarms(true)
            jailAlarm = true
        end)
    end
end)

RegisterNetEvent("lcrp-jail:client:ChangeJob")
AddEventHandler("lcrp-jail:client:ChangeJob", function(job)
    if inJail then
        if currentJob == job then return scCore.Notification("Your job is already: ".. currentJob, "error") end
        if JobCooldown == 0 then
            currentJob = job
            JobCooldown = 15 * 60000 -- 15mins
            SetJobCooldown()
            LoadJob()
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            Citizen.Wait(500)
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            scCore.Notification("Your new job is: ".. currentJob)
        else
            scCore.Notification("You have to wait: ".. string.format("%01d", (JobCooldown / 60000)) .. " minutes before changing job!", "error")
        end
    else
        scCore.Notification("You are not even serving time, What are you doing here?", "error")
    end
end)

function LoadJob()
    DeleteObject(trashObject)
    currentLocation = 1
    washingAction = 1
    isCarrying = false
	if currentJob == "Janitor" then
		currentLocation = math.random(1, #Config.Locations.jobs[currentJob])
		TriggerEvent('lcrp-jail:client:CreateTrashObj')
	end
end

RegisterNetEvent("lcrp-jail:client:MakeShank")
AddEventHandler("lcrp-jail:client:MakeShank", function()
    scCore.TaskBar("laundry_wash", "Making Shank", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "amb@prop_human_bbq@male@idle_b",
        anim = "idle_d",
        flags = 16,
    }, {}, {}, function() -- Done
        TriggerServerEvent("lcrp-jail:server:CraftShank")
        ClearPedTasks(PlayerPedId())
    end, function() -- Cancel
        scCore.Notification("Cancelled", "error")
        ClearPedTasks(PlayerPedId())
    end)
end)

RegisterNetEvent("lcrp-jail:client:CreateTrashObj")
AddEventHandler("lcrp-jail:client:CreateTrashObj", function()
    if currentJob == "Janitor" then
        DeleteObject(trashObject)
        location = Config.Locations.jobs[currentJob][currentLocation].coords
        locationZ = getGroundZ(location.x, location.y, location.z)
        trashObject = CreateObject(GetHashKey("prop_rub_litter_06"), location.x, location.y, locationZ, 0, 1, 1)
        FreezeEntityPosition(trashObject, true)
    end
end)

function WashingMachineTasks()
    if washingAction == 1 then
        scCore.TaskBar("laundry_wash", "Placing Laundry", math.random(3000, 5000), false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "amb@world_human_bum_wash@male@high@idle_a",
            anim = "idle_a",
            flags = 16,
        }, {}, {}, function() -- Done
            washingAction = washingAction + 1
            WashingMachineTasks()
            ClearPedTasks(PlayerPedId())
        end, function() -- Cancel
            washingAction = 1
            scCore.Notification("Cancelled", "error")
            ClearPedTasks(PlayerPedId())
        end)
    elseif washingAction == 2 then
        scCore.TaskBar("laundry_wash", "Waiting...", math.random(7000, 10000), false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
            disableCancel = true,
        }, {
            animDict = "anim@heists@heist_corona@team_idles@male_a",
            anim = "idle",
            flags = 16,
        }, {}, {}, function() -- Done
            washingAction = washingAction + 1
            WashingMachineTasks()
            ClearPedTasks(PlayerPedId())
        end)
    elseif washingAction == 3 then
        scCore.TaskBar("laundry_wash", "Picking Up Clean Clothes", math.random(5000, 6000), false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
            disableCancel = true,
        }, {
            animDict = "amb@prop_human_parking_meter@male@idle_a",
            anim = "idle_a",
            flags = 16,
        }, {}, {}, function() -- Done
            isCarrying = true
            washingAction = washingAction + 1
            carryObject("laundry")
            ClearPedTasks(PlayerPedId())
        end)
    end
end

function SetJobCooldown()
	Citizen.CreateThread(function()
		while true do
			if JobCooldown >= 60000 then
				JobCooldown = JobCooldown - 60000
			else
				return
			end
			Citizen.Wait(60000) -- 1min
		end
	end)
end

function JobDone()
    if math.random(1, 100) <= 50 then
        scCore.Notification("You've worked some time off your sentence")
        jailTime = jailTime - math.random(1, 2)
    end
    local newLocation = math.random(1, #Config.Locations.jobs[currentJob])
    while (newLocation == currentLocation) do
        Citizen.Wait(100)
        newLocation = math.random(1, #Config.Locations.jobs[currentJob])
    end
    if currentJob == "Janitor" then
        if math.random(1, 100) <= 5 then
            TriggerServerEvent("lcrp-jail:server:RandomItem", Config.Locations.jobs[currentJob][currentLocation], currentJob)
        end
        currentLocation = newLocation
        TriggerEvent('lcrp-jail:client:CreateTrashObj')
    end
    CreateJobBlip()
end

function getGroundZ(x, y, z)
    local result, groundZ = GetGroundZFor_3dCoord(x + 0.0, y + 0.0, z + 0.0, Citizen.ReturnResultAnyway())
    return groundZ
end

function carryObject(obj)
    TriggerEvent('animations:client:EmoteCommandStart', {obj})
    Citizen.CreateThread(function()
        while isCarrying do
            Citizen.Wait(5)
            if not IsEntityPlayingAnim(PlayerPedId(),"anim@heists@box_carry@", "idle",3) then
                TriggerEvent('animations:client:EmoteCommandStart', {obj})
            end
            DisableControlAction(0, spaceControl, true)
            DisableControlAction(0, shiftControl, true)
            DisableControlAction(0, attackControl, true)
            DisableControlAction(0, aggroControl, true)
            DisableControlAction(0, Keys['E'], true)
            DisableControlAction(0, enterControl, true)
        end
    end)
end

function CreateJobBlip()
    if currentLocation ~= 0 then
        if DoesBlipExist(currentBlip) then
            RemoveBlip(currentBlip)
        end
        currentBlip = AddBlipForCoord(Config.Locations.jobs[currentJob][currentLocation].coords.x, Config.Locations.jobs[currentJob][currentLocation].coords.y, Config.Locations.jobs[currentJob][currentLocation].coords.z)

        SetBlipSprite (currentBlip, 456)
        SetBlipDisplay(currentBlip, 4)
        SetBlipScale  (currentBlip, 0.8)
        SetBlipAsShortRange(currentBlip, true)
        SetBlipColour(currentBlip, 1)
    
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(currentJob)
        EndTextCommandSetBlipName(currentBlip)
    end
end