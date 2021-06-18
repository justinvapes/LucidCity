scCore = nil

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)


local isNearPump = false
local isFueling = false
local currentFuel = 0.0
local currentCost = 0.0
local fuelSynced = false
local inBlacklisted = false

function ManageFuelUsage(vehicle)
	if not DecorExistOn(vehicle, Config.FuelDecor) then
		SetFuel(vehicle, math.random(200, 800) / 10)
	elseif not fuelSynced then
		SetFuel(vehicle, GetFuel(vehicle))

		fuelSynced = true
	end

	if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - Config.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] * (Config.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
	end
end

Citizen.CreateThread(function()
	DecorRegister(Config.FuelDecor, 1)

	for i = 1, #Config.Blacklist do
		if type(Config.Blacklist[i]) == 'string' then
			Config.Blacklist[GetHashKey(Config.Blacklist[i])] = true
		else
			Config.Blacklist[Config.Blacklist[i]] = true
		end
	end

	for i = #Config.Blacklist, 1, -1 do
		table.remove(Config.Blacklist, i)
	end

	while true do
		Citizen.Wait(1000)

		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)

			if Config.Blacklist[GetEntityModel(vehicle)] then
				inBlacklisted = true
			else
				inBlacklisted = false
			end

			if not inBlacklisted and GetPedInVehicleSeat(vehicle, -1) == ped then
				ManageFuelUsage(vehicle)
			end
		else
			if fuelSynced then
				fuelSynced = false
			end

			if inBlacklisted then
				inBlacklisted = false
			end
		end
	end
end)

function FindNearestFuelPump()
	local coords = GetEntityCoords(PlayerPedId())
	local fuelPumps = {}
	local handle, object = FindFirstObject()
	local success

	repeat
		if Config.PumpModels[GetEntityModel(object)] then
			table.insert(fuelPumps, object)
		end

		success, object = FindNextObject(handle, object)
	until not success

	EndFindObject(handle)

	local pumpObject = 0
	local pumpDistance = 1000

	for k,v in pairs(fuelPumps) do
		local dstcheck = GetDistanceBetweenCoords(coords, GetEntityCoords(v))

		if dstcheck < pumpDistance then
			pumpDistance = dstcheck
			pumpObject = v
		end
	end

	return pumpObject, pumpDistance
end

--[[ Citizen.CreateThread(function()
	Citizen.Wait(200)
	while true do
		Citizen.Wait(250)

		local pumpObject, pumpDistance = FindNearestFuelPump()

		if pumpDistance < 2.5 then
			isNearPump = pumpObject
		else
			isNearPump = false
			Citizen.Wait(math.ceil(pumpDistance * 20))
		end
	end
end) ]]

function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end
	end
end

AddEventHandler('fuel:startFuelUpTick', function(pumpObject, ped, vehicle)
	currentFuel = GetVehicleFuelLevel(vehicle)

	while isFueling do
		Citizen.Wait(500)

		local oldFuel = DecorGetFloat(vehicle, Config.FuelDecor)
		local fuelToAdd = math.random(10, 20) / 10.0
		local extraCost = fuelToAdd / 1.5

		if not pumpObject then
			if GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100 >= 0 then
				currentFuel = oldFuel + fuelToAdd

				SetPedAmmo(ped, 883325847, math.floor(GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100))
			else
				isFueling = false
				TriggerEvent('lcrp-interact:client:updateInteraction', 'model', GetEntityModel(isNearPump), 'event', 'fuel:client:refuelVehicle')
				TriggerEvent('lcrp-interact:client:updateInteraction', 'model', GetEntityModel(isNearPump), 'isFueling', isFueling)
			end
		else
			currentFuel = oldFuel + fuelToAdd
		end

		if currentFuel > 100.0 then
			currentFuel = 100.0
			isFueling = false
			TriggerEvent('lcrp-interact:client:updateInteraction', 'model', GetEntityModel(isNearPump), 'event', 'fuel:client:refuelVehicle')
			TriggerEvent('lcrp-interact:client:updateInteraction', 'model', GetEntityModel(isNearPump), 'isFueling', isFueling)
		end

		currentCost = currentCost + extraCost

		if scCore.Functions.GetPlayerData().money["cash"] >= currentCost then
			SetFuel(vehicle, currentFuel)
		else
			isFueling = false
			TriggerEvent('lcrp-interact:client:updateInteraction', 'model', GetEntityModel(isNearPump), 'event', 'fuel:client:refuelVehicle')
			TriggerEvent('lcrp-interact:client:updateInteraction', 'model', GetEntityModel(isNearPump), 'isFueling', isFueling)
		end
	end

	if pumpObject then
		TriggerServerEvent('fuel:pay', currentCost)
	end

	currentCost = 0.0
end)

function Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)

	return math.floor(num * mult + 0.5) / mult
end

AddEventHandler('fuel:refuelFromPump', function(pumpObject, ped, vehicle)
	TaskTurnPedToFaceEntity(ped, vehicle, 1000)
	Citizen.Wait(250)
	SetCurrentPedWeapon(ped, -1569615261, true)
	LoadAnimDict("timetable@gardener@filling_can")
	TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)

	TriggerEvent('fuel:startFuelUpTick', pumpObject, ped, vehicle)

	while isFueling do
		Citizen.Wait(1)

		for k,v in pairs(Config.DisableKeys) do
			DisableControlAction(0, v)
		end

		local vehicleCoords = GetEntityCoords(vehicle)

		if pumpObject then
			scCore.Draw3DText(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, Round(currentFuel, 1) .. "%")
		end

		if not IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
			TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
		end

		--[[ if IsControlJustReleased(0, 38) or DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) or (isNearPump and GetEntityHealth(pumpObject) <= 0) then
			isFueling = false

			TriggerEvent('lcrp-interact:client:updateInteractionOptions', 'model', GetEntityModel(isNearPump), 'event', 'fuel:client:refuelVehicle')
			TriggerEvent('lcrp-interact:client:updateInteractionOptions', 'model', GetEntityModel(isNearPump), 'isFueling', isFueling)
		end ]]
	end

	ClearPedTasks(ped)
	RemoveAnimDict("timetable@gardener@filling_can")
end)

--[[ Citizen.CreateThread(function()
	Citizen.Wait(200)
	while true do
		Citizen.Wait(1)

		local ped = PlayerPedId()

		if not isFueling and ((isNearPump and GetEntityHealth(isNearPump) > 0) or (GetSelectedPedWeapon(ped) == 883325847 and not isNearPump)) then
			if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) == ped then
				local pumpCoords = GetEntityCoords(isNearPump)

				scCore.Draw3DText(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.2, Config.Strings.ExitVehicle)
			else
				local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
				local vehicleCoords = GetEntityCoords(vehicle)
				local vehicleClass = GetVehicleClass(vehicle)
				local pumpDist = 2.5
				if vehicleClass == 16 or vehicleClass == 15 then pumpDist = 10 end
				if DoesEntityExist(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(ped), vehicleCoords) < pumpDist then
					if not DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) then
						local stringCoords = GetEntityCoords(isNearPump)
						local canFuel = true

						if GetSelectedPedWeapon(ped) == 883325847 then
							stringCoords = vehicleCoords

							if GetAmmoInPedWeapon(ped, 883325847) < 100 then
								canFuel = false
							end
						end
						
						if GetVehicleFuelLevel(vehicle) < 95 and canFuel then
							if scCore.Functions.GetPlayerData().money["cash"] > 0 then
								scCore.Draw3DText(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.EToRefuel)

								if IsControlJustReleased(0, 38) then
									isFueling = true

									TriggerEvent('fuel:refuelFromPump', isNearPump, ped, vehicle)
									LoadAnimDict("timetable@gardener@filling_can")
								end
							else
								scCore.Draw3DText(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.NotEnoughCash)
							end
						else
							scCore.Draw3DText(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.FullTank)
						end
					end
				else
					Citizen.Wait(250)
				end
			end
		else
			Citizen.Wait(250)
		end
	end
end) ]]

function CreateBlip(coords)
	local blip = AddBlipForCoord(coords)

	SetBlipSprite(blip, 361)
	SetBlipScale  (blip, 0.45)
	SetBlipColour(blip, 75)
	SetBlipDisplay(blip, 4)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Gas station")
	EndTextCommandSetBlipName(blip)

	return blip
end

Citizen.CreateThread(function()
	for k,v in pairs(Config.GasStations) do
		CreateBlip(v)
	end
end)

function GetFuel(vehicle)
	return DecorGetFloat(vehicle, Config.FuelDecor)
end

function SetFuel(vehicle, fuel)
	if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
		DecorSetFloat(vehicle, Config.FuelDecor, GetVehicleFuelLevel(vehicle))
	end
end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
	exports["lcrp-interact"]:AddTargetModel(Config.Pumps, {
		options = {
			{
				event = "fuel:client:refuelVehicle",
				icon = "fas fa-gas-pump",
				label = "Refuel vehicle",
				duty = false,
				isFueling = false
			},
		},
		job = {"all"}, distance = 1.5
	})
end)

RegisterNetEvent("fuel:client:stopRefuel")
AddEventHandler("fuel:client:stopRefuel", function()
	if DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) or (isNearPump and GetEntityHealth(pumpObject) <= 0) then
		isFueling = false

		TriggerEvent('lcrp-interact:client:updateInteraction', 'model', GetEntityModel(isNearPump), 'event', 'fuel:client:refuelVehicle')
		TriggerEvent('lcrp-interact:client:updateInteraction', 'model', GetEntityModel(isNearPump), 'isFueling', isFueling)
	end
end)


RegisterNetEvent("fuel:client:refuelVehicle")
AddEventHandler("fuel:client:refuelVehicle", function()
	local ped = PlayerPedId()
	local pumpObject, pumpDistance = FindNearestFuelPump()

	if pumpDistance < 2.5 then
		isNearPump = pumpObject
	else
		isNearPump = false
		Citizen.Wait(math.ceil(pumpDistance * 20))
	end

	if not isFueling and ((isNearPump and GetEntityHealth(isNearPump) > 0) or (GetSelectedPedWeapon(ped) == 883325847 and not isNearPump)) then
		if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) == ped then
			local pumpCoords = GetEntityCoords(isNearPump)
		else
			local pos = GetEntityCoords(ped)
			local vehicle = GetClosestVehicle(pos['x'], pos['y'], pos['z'], 5.001, 0, 127)	
			local vehicleCoords = GetEntityCoords(vehicle)
			local vehicleClass = GetVehicleClass(vehicle)
			local pumpDist = 2.5
			if vehicleClass == 16 or vehicleClass == 15 then pumpDist = 10 end
			if DoesEntityExist(vehicle) and GetDistanceBetweenCoords(pos, vehicleCoords) < pumpDist then
				if not DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) then
					local stringCoords = GetEntityCoords(isNearPump)
					local canFuel = true

					if GetSelectedPedWeapon(ped) == 883325847 then
						stringCoords = vehicleCoords

						if GetAmmoInPedWeapon(ped, 883325847) < 100 then
							canFuel = false
						end
					end
					
					if GetVehicleFuelLevel(vehicle) < 95 and canFuel then
						if scCore.Functions.GetPlayerData().money["cash"] > 0 then
							isFueling = true
							TriggerEvent('lcrp-interact:client:updateInteraction', 'model', GetEntityModel(isNearPump), 'event', 'fuel:client:stopRefuel')
							TriggerEvent('lcrp-interact:client:updateInteraction', 'model', GetEntityModel(isNearPump), 'isFueling', isFueling)
							TriggerEvent('fuel:refuelFromPump', isNearPump, ped, vehicle)
							LoadAnimDict("timetable@gardener@filling_can")
						else
							scCore.Notification(Config.Strings.NotEnoughCash, 'error')
						end
					else
						scCore.Notification(Config.Strings.FullTank,'error')
					end
				end
			else
				scCore.Notification(Config.Strings.NoVehicle,'error')
			end
		end
	end
end)