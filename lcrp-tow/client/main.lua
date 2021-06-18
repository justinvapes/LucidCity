scCore = nil

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

local PlayerJob = {}
local CurrentPlate = nil
local JobsDone = 0
local NpcOn = false
local CurrentLocation = {}
local CurrentBlip = nil
local LastVehicle = 0
local VehicleSpawned = false

local selectedVeh = nil
local TowVehBlip
RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    PlayerJob = scCore.Functions.GetPlayerData().job

    if string.match(PlayerJob.name, "mechanic") then
        TowVehBlip = AddBlipForCoord(Config.TowLocation[PlayerJob.name].x, Config.TowLocation[PlayerJob.name].y, Config.TowLocation[PlayerJob.name].z)
        SetBlipSprite(TowVehBlip, 326)
        SetBlipDisplay(TowVehBlip, 4)
        SetBlipScale(TowVehBlip, 0.6)
        SetBlipAsShortRange(TowVehBlip, true)
        SetBlipColour(TowVehBlip, 15)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.TowLabel)
        EndTextCommandSetBlipName(TowVehBlip)
    end
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo

    if string.match(PlayerJob.name, "mechanic") then
        TowVehBlip = AddBlipForCoord(Config.TowLocation[PlayerJob.name].x, Config.TowLocation[PlayerJob.name].y, Config.TowLocation[PlayerJob.name].z)
        SetBlipSprite(TowVehBlip, 326)
        SetBlipDisplay(TowVehBlip, 4)
        SetBlipScale(TowVehBlip, 0.6)
        SetBlipAsShortRange(TowVehBlip, true)
        SetBlipColour(TowVehBlip, 15)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.TowLabel)
        EndTextCommandSetBlipName(TowVehBlip)
    else
        if DoesBlipExist(TowVehBlip) then
            RemoveBlip(TowVehBlip)
        end
    end
end)
local isTowed = false
RegisterNetEvent('jobs:client:ToggleNpc')
AddEventHandler('jobs:client:ToggleNpc', function()
    if string.match(PlayerJob.name, "mechanic") then
        if CurrentTow ~= nil then 
            scCore.Notification("Finish your work first!", "error")
            return
        end
        NpcOn = not NpcOn
        if NpcOn then
            isTowed = false
            local randomLocation = getRandomVehicleLocation()
            CurrentLocation.x = Config.Locations["towspots"][randomLocation].coords.x
            CurrentLocation.y = Config.Locations["towspots"][randomLocation].coords.y
            CurrentLocation.z = Config.Locations["towspots"][randomLocation].coords.z
            CurrentLocation.model = Config.Locations["towspots"][randomLocation].model
            CurrentLocation.id = randomLocation

            CurrentBlip = AddBlipForCoord(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z)
            SetBlipColour(CurrentBlip, 3)
            SetBlipRoute(CurrentBlip, true)
            SetBlipRouteColour(CurrentBlip, 3)
            awaitingTow()
        else
            if DoesBlipExist(CurrentBlip) then
                RemoveBlip(CurrentBlip)
                CurrentLocation = {}
                CurrentBlip = nil
            end
            VehicleSpawned = false
        end
    end
end)

RegisterNetEvent('lcrp-tow:client:Impound')
AddEventHandler('lcrp-tow:client:Impound', function()
    local vehicle = scCore.Functions.GetClosestVehicle()
    if vehicle ~= 0 and vehicle ~= nil then
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local vehpos = GetEntityCoords(vehicle)
        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 5.0) and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
            local plate = GetVehicleNumberPlateText(vehicle)
            scCore.Notification("Vehicle impounded with plate: ".. plate)
            scCore.Functions.DeleteVehicle(vehicle)
        end
    end
end)

RegisterNetEvent('lcrp-tow:client:TowVehicle')
AddEventHandler('lcrp-tow:client:TowVehicle', function()
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
    if isTowVehicle(vehicle) then
        if CurrentTow == nil then 
            --[[ Replaced "scCore.Functions.GetClosestVehicle()" with custom implementation "getVehicleInDirection"
                 scCore native could not return polcice and other vehicles types (NPC) ]] 
            local playerped = PlayerPedId()
            local coordA = GetEntityCoords(playerped, 1)
            local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
            local targetVehicle = getVehicleInDirection(coordA, coordB)

            if NpcOn and CurrentLocation ~= nil then
                if GetEntityModel(targetVehicle) ~= GetHashKey(CurrentLocation.model) then
                    scCore.Notification("This is not the right vehicle", "error")
                    return
                end
            end
            if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                if vehicle ~= targetVehicle then
                    local towPos = GetEntityCoords(vehicle)
                    local targetPos = GetEntityCoords(targetVehicle)
                    if GetDistanceBetweenCoords(towPos.x, towPos.y, towPos.z, targetPos.x, targetPos.y, targetPos.z, true) < 11.0 then
                        scCore.TaskBar("towing_vehicle", "Towing vehicle", 5000, false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = "mini@repair",
                            anim = "fixing_a_ped",
                            flags = 16,
                        }, {}, {}, function() -- Done
                            StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                            AttachEntityToEntity(targetVehicle, vehicle, GetEntityBoneIndexByName(vehicle, 'bodyshell'), 0.0, -1.5 + -0.85, 0.0 + 1.15, 0, 0, 0, 1, 1, 0, 1, 0, 1)
                            FreezeEntityPosition(targetVehicle, true)
                            CurrentTow = targetVehicle
                            if NpcOn then
                                isTowed = true
                                RemoveBlip(CurrentBlip)
                                CurrentBlip = AddBlipForCoord(Config.TowLocation[PlayerJob.name].x, Config.TowLocation[PlayerJob.name].y, Config.TowLocation[PlayerJob.name].z)
                                SetBlipColour(CurrentBlip, 3)
                                SetBlipRoute(CurrentBlip, true)
                                SetBlipRouteColour(CurrentBlip, 3)
                                --scCore.Notification("Vehicle impounded", "success", 5000)
                            end
                            scCore.Notification("Vehicle towed!")
                        end, function() -- Cancel
                            StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                            scCore.Notification("Failed!", "error")
                        end)
                    end
                end
            end
        else
            scCore.TaskBar("untowing_vehicle", "Untowing vehicle", 5000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "mini@repair",
                anim = "fixing_a_ped",
                flags = 16,
            }, {}, {}, function() -- Done
                StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                FreezeEntityPosition(CurrentTow, false)
                Citizen.Wait(250)
                AttachEntityToEntity(CurrentTow, vehicle, 20, -0.0, -15.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                DetachEntity(CurrentTow, true, true)
                if NpcOn then
                    local targetPos = GetEntityCoords(CurrentTow)
                    if GetDistanceBetweenCoords(targetPos.x, targetPos.y, targetPos.z, Config.TowLocation[PlayerJob.name].x, Config.TowLocation[PlayerJob.name].y, Config.TowLocation[PlayerJob.name].z, true) < 25.0 then
                        deliverVehicle(CurrentTow)
                    end
                end
                CurrentTow = nil
                scCore.Notification("Vehicle untowed!")
            end, function() -- Cancel
                StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
                scCore.Notification("Failed!", "error")
            end)
        end
    else
        scCore.Notification("You must be in a flatbed vehicle first.", "error")
    end
end)

function awaitingTow() 
    Citizen.CreateThread(function()
        local inRange = false
        local sleep = 1000
        while not isTowed do 
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if NpcOn and CurrentLocation ~= nil and next(CurrentLocation) ~= nil then
                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, CurrentLocation.x, CurrentLocation.y, CurrentLocation.z, true) < 50.0 and not VehicleSpawned then
                    inRange = true
                    sleep = 5
                    VehicleSpawned = true
                    scCore.Functions.SpawnVehicle(CurrentLocation.model, function(veh)
                        exports['LegacyFuel']:SetFuel(veh, 0.0)
                        if math.random(1,2) == 1 then
                            doCarDamage(veh)
                        end
                    end, CurrentLocation, true)
                end
            end
            if not inRange then
                sleep = 1000
                
            end
            Citizen.Wait(sleep)
        end
    end)
end

function deliverVehicle(vehicle)
    DeleteVehicle(vehicle)
    JobsDone = JobsDone + 1
    VehicleSpawned = false
    scCore.Notification("You have delivered a vehicle, continue your work!", "primary")
    TriggerServerEvent("lcrp-tow:server:VehTowed")
    local randomLocation = getRandomVehicleLocation()
    CurrentLocation.x = Config.Locations["towspots"][randomLocation].coords.x
    CurrentLocation.y = Config.Locations["towspots"][randomLocation].coords.y
    CurrentLocation.z = Config.Locations["towspots"][randomLocation].coords.z
    CurrentLocation.model = Config.Locations["towspots"][randomLocation].model
    CurrentLocation.id = randomLocation
    if DoesBlipExist(CurrentBlip) then
        RemoveBlip(CurrentBlip)
        CurrentBlip = nil
    end
    isTowed = false
    awaitingTow()
    CurrentBlip = AddBlipForCoord(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z)
    SetBlipColour(CurrentBlip, 3)
    SetBlipRoute(CurrentBlip, true)
    SetBlipRouteColour(CurrentBlip, 3)
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function getRandomVehicleLocation()
    local randomVehicle = math.random(1, #Config.Locations["towspots"])
    while (randomVehicle == LastVehicle) do
        Citizen.Wait(10)
        randomVehicle = math.random(1, #Config.Locations["towspots"])
    end
    return randomVehicle
end

function isTowVehicle(vehicle)
    local retval = false
    for k, v in pairs(Config.Vehicles) do
        if GetEntityModel(vehicle) == GetHashKey(k) then
            retval = true
        end
    end
    return retval
end

RegisterNetEvent('lcrp-tow:client:SpawnVehicle')
AddEventHandler('lcrp-tow:client:SpawnVehicle', function()
    if string.match(PlayerJob.name,"mechanic") then
        local coords = Config.TowLocation[PlayerJob.name]
        scCore.Functions.SpawnVehicle("flatbed", function(veh)
            SetVehicleNumberPlateText(veh, "TOW"..tostring(math.random(1000, 9999)))
            SetEntityHeading(veh, coords.h)
            exports['LegacyFuel']:SetFuel(veh, 100.0)
            SetEntityAsMissionEntity(veh, true, true)
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
            SetVehicleEngineOn(veh, true, true)
            CurrentPlate = GetVehicleNumberPlateText(veh)
            for i = 1, 9, 1 do 
                SetVehicleExtra(veh, i, 0)
            end
        end, coords, true)
    end
end)

function doCarDamage(currentVehicle)
	smash = false
	damageOutside = false
	damageOutside2 = false 
	local engine = 199.0
	local body = 149.0
	if engine < 200.0 then
		engine = 200.0
    end
    
    if engine  > 1000.0 then
        engine = 950.0
    end

	if body < 150.0 then
		body = 150.0
	end
	if body < 950.0 then
		smash = true
	end

	if body < 920.0 then
		damageOutside = true
	end

	if body < 920.0 then
		damageOutside2 = true
	end

    Citizen.Wait(100)
    SetVehicleEngineHealth(currentVehicle, engine)
	if smash then
		SmashVehicleWindow(currentVehicle, 0)
		SmashVehicleWindow(currentVehicle, 1)
		SmashVehicleWindow(currentVehicle, 2)
		SmashVehicleWindow(currentVehicle, 3)
		SmashVehicleWindow(currentVehicle, 4)
	end
	if damageOutside then
		SetVehicleDoorBroken(currentVehicle, 1, true)
		SetVehicleDoorBroken(currentVehicle, 6, true)
		SetVehicleDoorBroken(currentVehicle, 4, true)
	end
	if damageOutside2 then
		SetVehicleTyreBurst(currentVehicle, 1, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 2, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 3, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 4, false, 990.0)
	end
	if body < 1000 then
		SetVehicleBodyHealth(currentVehicle, 985.1)
	end
end

RegisterNetEvent('lcrp-tow:client:GetPaycheck')
AddEventHandler('lcrp-tow:client:GetPaycheck', function()
    if JobsDone > 0 then
        RemoveBlip(CurrentBlip)
        TriggerServerEvent("lcrp-tow:server:11101110")
        JobsDone = 0
        NpcOn = false
    else
        scCore.Notification("You haven\'t done any work yet", "error")
    end
end)

RegisterNetEvent('lcrp-tow:client:toggleVehicle')
AddEventHandler('lcrp-tow:client:toggleVehicle', function()
    if string.match(PlayerJob.name,"mechanic") then
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
            if isTowVehicle(vehicle) then
                TriggerServerEvent('lcrp-tow:server:DoBail', false)
            else
                scCore.Notification("This vehicle cannot be stored here!","error")
            end
        else
            TriggerServerEvent('lcrp-tow:server:DoBail', true)
       end
    end
end)

RegisterNetEvent("lcrp-tow:client:deleteVehicle")
AddEventHandler("lcrp-tow:client:deleteVehicle", function()
    scCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()

  exports["lcrp-interact"]:AddBoxZone("mechanicTowVehicle", vector3(-208.15, -1345.52, 30.98), 4.8, 9.2, {
    name="mechanicTowVehicle",
    heading=0,
    --debugPoly=true,
    minZ=29.98,
    maxZ=34.98 }, {
    options = {
        {
            event = 'lcrp-tow:client:toggleVehicle',
            icon = "fas fa-truck-pickup",
            label = "Take out vehicle",
            storeVeh = true,
            duty = true,
        },
      },
  job = {"mechanic"}, distance = 10.0 })

  exports["lcrp-interact"]:AddBoxZone("mechanicPaycheck", vector3(-203.22, -1340.76, 34.89), 1.4, 1, {
        name="mechanicPaycheck",
        heading=0,
        --debugPoly=true,
        minZ=33.89,
        maxZ=35.89 }, {
    options = {
        {
            event = 'lcrp-tow:client:GetPaycheck',
            icon = "fas fa-money-bill-wave",
            label = "Tow Paycheck",
            duty = true,
        },
      },
  job = {"mechanic"}, distance = 2.0 })

  exports["lcrp-interact"]:AddBoxZone("mechanic2TowVehicle", vector3(-370.24, -107.67, 38.68), 5.6, 15.8, {
    name="mechanic2TowVehicle",
    heading=340,
    --debugPoly=true,
    minZ=37.08,
    maxZ=41.48 }, {
    options = {
        {
            event = 'lcrp-tow:client:toggleVehicle',
            icon = "fas fa-truck-pickup",
            label = "Take out vehicle",
            duty = true,
            storeVeh = true,
        },
      },
  job = {"mechanic2"}, distance = 10.0 })

  exports["lcrp-interact"]:AddBoxZone("mechanic2Paycheck", vector3(-331.88, -118.47, 39.01), 1.8, 1, {
    name="mechanic2Paycheck",
    heading=340,
    --debugPoly=true,
    minZ=38.01,
    maxZ=39.41 }, {
    options = {
        {
            event = 'lcrp-tow:client:GetPaycheck',
            icon = "fas fa-money-bill-wave",
            label = "Tow Paycheck",
            duty = true,
        },
    },
    job = {"mechanic2"}, distance = 2.0 })

end)