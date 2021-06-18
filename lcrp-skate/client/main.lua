

local Skateboard = {}
local player = nil

Attached = false

--[[ RegisterCommand("longboard", function()
	Skateboard.Start()
end) ]]
--

RegisterNetEvent('skateboard:Spawn')
AddEventHandler('skateboard:Spawn', function()
    Skateboard.Start()
end)

AddEventHandler('longboard:clear', function()
	Skateboard.Clear()
end)

AddEventHandler('longboard:start', function()
	Skateboard.Clear()
    Skateboard.Start()
end)


Skateboard.Start = function()
	player = GetPlayerPed(-1)
	if DoesEntityExist(Skateboard.Entity) then return end

	Skateboard.Spawn()

	while DoesEntityExist(Skateboard.Entity) and DoesEntityExist(Skateboard.Driver) do
		Citizen.Wait(5)

		local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),  GetEntityCoords(Skateboard.Entity), true)

		Skateboard.HandleKeys(distanceCheck)

		if distanceCheck <= Config.LoseConnectionDistance then
			if not NetworkHasControlOfEntity(Skateboard.Driver) then
				NetworkRequestControlOfEntity(Skateboard.Driver)
			elseif not NetworkHasControlOfEntity(Skateboard.Entity) then
				NetworkRequestControlOfEntity(Skateboard.Entity)
			end
		else
			TaskVehicleTempAction(Skateboard.Driver, Skateboard.Entity, 6, 2500)
		end

		Citizen.CreateThread(function()
			Citizen.Wait(50)
			StopCurrentPlayingAmbientSpeech(Skateboard.Driver)	
			if Attached then
				-- Ragdoll system
				local x = GetEntityRotation(Skateboard.Entity).x
				local y = GetEntityRotation(Skateboard.Entity).y
				
				if (-40.0 < x and x > 40.0) or (-40.0 < y and y > 40.0) then
					Skateboard.AttachPlayer(false)
					SetPedToRagdoll(player, 5000, 4000, 0, true, true, false)
				end	
			end           
		end)
	end
end

Skateboard.HandleKeys = function(distanceCheck)
	if distanceCheck <= 1.5 then
		if IsControlJustPressed(0, 38) then
			Skateboard.Attach("pick")
			TriggerServerEvent('skateboard:pick')	
		end

		if IsControlJustReleased(0, 113) then
			if Attached then
				Skateboard.AttachPlayer(false)
			else
				Skateboard.AttachPlayer(true)
			end
		end
	end
	
	if distanceCheck < Config.LoseConnectionDistance then
		local overSpeed = (GetEntitySpeed(Skateboard.Entity)*3.6) > Config.MaxSpeedKmh
		
		-- prevents ped from driving away
		TaskVehicleTempAction(Skateboard.Driver, Skateboard.Entity, 1, 1)
		ForceVehicleEngineAudio(Skateboard.Entity, 0)
		-- Input Control longboard 
		if Attached then
			if IsControlPressed(0, 87) and not IsControlPressed(0, 88) and not overSpeed then
				TaskVehicleTempAction(Skateboard.Driver, Skateboard.Entity, 9, 1)
			end
		end

		if IsControlPressed(0, 22) and Attached then
			-- Jump system
			if not IsEntityInAir(Skateboard.Entity) then	
				local vel = GetEntityVelocity(Skateboard.Entity)
				TaskPlayAnim(PlayerPedId(), "move_crouch_proto", "idle_intro", 5.0, 8.0, -1, 0, 0, false, false, false)
				local duration = 0
				local boost = 0
				while IsControlPressed(0, 22) do
					Citizen.Wait(10)
					duration = duration + 10.0
					ForceVehicleEngineAudio(Skateboard.Entity, 0)
				end
				boost = Config.maxJumpHeigh * duration / 250.0
				if boost > Config.maxJumpHeigh then boost = Config.maxJumpHeigh end
				StopAnimTask(PlayerPedId(), "move_crouch_proto", "idle_intro", 1.0)
				SetEntityVelocity(Skateboard.Entity, vel.x, vel.y, vel.z + boost)
				TaskPlayAnim(player, "move_strafe@stealth", "idle", 8.0, 2.0, -1, 1, 1.0, false, false, false)
			end
		end
		if Attached then
			if IsControlJustReleased(0, 87) or IsControlJustReleased(0, 88) and not overSpeed then
				TaskVehicleTempAction(Skateboard.Driver, Skateboard.Entity, 6, 2500)
			end

			if IsControlPressed(0, 88) and not IsControlPressed(0, 87) and not overSpeed then
				TaskVehicleTempAction(Skateboard.Driver, Skateboard.Entity, 22, 1)
			end

			if IsControlPressed(0, 89) and IsControlPressed(0, 88) and not overSpeed then
				TaskVehicleTempAction(Skateboard.Driver, Skateboard.Entity, 13, 1)
			end

			if IsControlPressed(0, 90) and IsControlPressed(0, 88) and not overSpeed then
				TaskVehicleTempAction(Skateboard.Driver, Skateboard.Entity, 14, 1)
			end

			if IsControlPressed(0, 87) and IsControlPressed(0, 88) and not overSpeed then
				TaskVehicleTempAction(Skateboard.Driver, Skateboard.Entity, 30, 100)
			end

			if IsControlPressed(0, 89) and IsControlPressed(0, 87) and not overSpeed then
				TaskVehicleTempAction(Skateboard.Driver, Skateboard.Entity, 7, 1)
			end

			if IsControlPressed(0, 90) and IsControlPressed(0, 87) and not overSpeed then
				TaskVehicleTempAction(Skateboard.Driver, Skateboard.Entity, 8, 1)
			end

			if IsControlPressed(0, 89) and not IsControlPressed(0, 87) and not IsControlPressed(0, 88) and not overSpeed then
				TaskVehicleTempAction(Skateboard.Driver, Skateboard.Entity, 4, 1)
			end

			if IsControlPressed(0, 90) and not IsControlPressed(0, 87) and not IsControlPressed(0, 88) and not overSpeed then
				TaskVehicleTempAction(Skateboard.Driver, Skateboard.Entity, 5, 1)
			end
			if HasEntityCollidedWithAnything(Skateboard.Entity) and GetEntitySpeed(Skateboard.Entity) * 3.6 > 20 then
				Skateboard.AttachPlayer(false)
				SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
			end
		end
	else
		Skateboard.Clear()
	end
end


Skateboard.Spawn = function()
	-- models to load
	Skateboard.LoadModels({ GetHashKey("triBike3"), 68070371, GetHashKey("p_defilied_ragdoll_01_s"), "pickup_object", "move_strafe@stealth", "move_crouch_proto"})

	local spawnCoords, spawnHeading = GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()) * 2.0, GetEntityHeading(PlayerPedId())

	Skateboard.Entity = CreateVehicle(GetHashKey("triBike3"), spawnCoords, spawnHeading, true)
	Skateboard.Skate = CreateObject(GetHashKey("p_defilied_ragdoll_01_s"), 0.0, 0.0, 0.0, true, true, true)
	
	-- load models
	while not DoesEntityExist(Skateboard.Entity) do
		Citizen.Wait(5)
	end
	while not DoesEntityExist(Skateboard.Skate) do
		Citizen.Wait(5)
	end

	SetHandling() -- Modify hanfling for upgrade the stability
	SetEntityNoCollisionEntity(Skateboard.Entity, player, false) -- disable collision between the player and the rc
	SetEntityCollision(Skateboard.Entity, true, true)
	SetEntityVisible(Skateboard.Entity, false)
	PlaceObjectOnGroundProperly(Skateboard.Skate)
	AttachEntityToEntity(Skateboard.Skate, Skateboard.Entity, GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, -0.60, 0.0, 0.0, 90.0, false, true, true, true, 1, true)

	Skateboard.Driver = CreatePed(12	, 68070371, spawnCoords, spawnHeading, true, true)

	-- Driver properties
	SetEnableHandcuffs(Skateboard.Driver, true)
	SetEntityInvincible(Skateboard.Driver, true)
	SetEntityVisible(Skateboard.Driver, false)
	FreezeEntityPosition(Skateboard.Driver, true)
	TaskWarpPedIntoVehicle(Skateboard.Driver, Skateboard.Entity, -1)
	--SetPedAlertness(Skateboard.Driver, 0)

	while not IsPedInVehicle(Skateboard.Driver, Skateboard.Entity) do
		Citizen.Wait(0)
	end
	--TriggerServerEvent("shareImOnSkate", {Skateboard.Skate, Skateboard.Entity, Skateboard.Driver})
	Skateboard.Attach("place")
end

function SetHandling()
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fSteeringLock", 9.0)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fDriveInertia", 0.05)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fMass", 1800.0)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fPercentSubmerged", 105.0)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fDriveBiasFront", 0.0)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fInitialDriveForce", 0.25)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fInitialDriveMaxFlatVel", 135.0)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fTractionCurveMax", 2.2)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fTractionCurveMin", 2.12)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fTractionCurveLateral", 22.5)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fTractionSpringDeltaMax", 0.1)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fLowSpeedTractionLossMult", 0.7)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fCamberStiffnesss", 0.0)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fTractionBiasFront", 0.478)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fTractionLossMult", 0.0)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fSuspensionForce", 5.2)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fSuspensionForce", 1.2)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fSuspensionReboundDamp", 1.7)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fSuspensionUpperLimit", 0.1	)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fSuspensionLowerLimit", -0.3)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fSuspensionRaise", 0.0)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fSuspensionBiasFront", 0.5)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fAntiRollBarForce", 0.0)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fAntiRollBarBiasFront", 0.65)
	SetVehicleHandlingFloat(Skateboard.Entity, "CHandlingData", "fBrakeForce", 0.53)
end

Skateboard.Attach = function(param)
	if not DoesEntityExist(Skateboard.Entity) then
		return
	end
	
	if param == "place" then
		-- Place longboard
		AttachEntityToEntity(Skateboard.Entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.1, 0.0, -0.2, 70.0, 0.0, 270.0, 1, 1, 0, 0, 2, 1)

		TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)

		Citizen.Wait(800)

		DetachEntity(Skateboard.Entity, false, true)

		PlaceObjectOnGroundProperly(Skateboard.Entity)
	elseif param == "pick" then
		-- Pick longboard
		Citizen.Wait(100)

		TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)

		Citizen.Wait(600)
	
		AttachEntityToEntity(Skateboard.Entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.1, 0.0, -0.2, 70.0, 0.0, 270.0, 1, 1, 0, 0, 2, 1)
		
		Citizen.Wait(900)
		
		-- Clear 
		Skateboard.Clear()

	end

end

Skateboard.Clear = function(models)
	DetachEntity(Skateboard.Entity)
	DeleteEntity(Skateboard.Skate)
	DeleteVehicle(Skateboard.Entity)
	DeleteEntity(Skateboard.Driver)

	Skateboard.UnloadModels()
	Attach = false
	Attached  = false
end


Skateboard.LoadModels = function(models)
	for modelIndex = 1, #models do
		local model = models[modelIndex]

		if not Skateboard.CachedModels then
			Skateboard.CachedModels = {}
		end

		table.insert(Skateboard.CachedModels, model)

		if IsModelValid(model) then
			while not HasModelLoaded(model) do
				RequestModel(model)	
				Citizen.Wait(10)
			end
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)
				Citizen.Wait(10)
			end    
		end
	end
end

Skateboard.UnloadModels = function()
	for modelIndex = 1, #Skateboard.CachedModels do
		local model = Skateboard.CachedModels[modelIndex]

		if IsModelValid(model) then
			SetModelAsNoLongerNeeded(model)
		else
			RemoveAnimDict(model)   
		end
	end
end
local vehiclesMuted = {}

Skateboard.AttachPlayer = function(toggle)
	if toggle then
		TaskPlayAnim(player, "move_strafe@stealth", "idle", 8.0, 8.0, -1, 1, 1.0, false, false, false)
		AttachEntityToEntity(player, Skateboard.Entity, 20, 0.0, 0.15, 0.03, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
		SetEntityCollision(player, true, true)
		Attached = true		
	elseif not toggle then
		DetachEntity(player, false, false)
		Attached = false
		StopAnimTask(player, "move_strafe@stealth", "idle", 1.0)	
	end	
end


--[[ RegisterNetEvent("shareHeIsOnSkate")
AddEventHandler("shareHeIsOnSkate", function(id) 
		local player = GetPlayerFromServerId(id)
		local vehicle = GetEntityAttachedTo(GetPlayerPed(player))
		if not vehiclesMuted[vehicle] then
			Citizen.CreateThread(function() 
				vehiclesMuted[vehicle] = true
				while vehicle do
					Citizen.Wait(10)
					ForceVehicleEngineAudio(vehicle, 0)
					if HasEntityCollidedWithAnything(vehicle) and GetEntitySpeed(Skateboard.Entity) * 3.6 > 20 then
						Skateboard.AttachPlayer(false)
						SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
					end
				end
				table.remove(vehiclesMuted, vehicle)
			end)
		end	
end) ]]

Citizen.CreateThread(function()
	local modelHash = GetHashKey('a_m_m_skater_01')
	RequestModel(modelHash)
	while not HasModelLoaded(modelHash) do
		Wait(1)
	end	
	RequestAnimDict("amb@world_human_car_park_attendant@male@idle_a")
	while not HasAnimDictLoaded("amb@world_human_car_park_attendant@male@idle_a") do
		Wait(1)
	end
	local ped =  CreatePed(4, modelHash, -1127.21, -1439.51, 4.22, 3374176, false, true)
	while not DoesEntityExist(ped) do
		Citizen.Wait(0)
	end


	local blip = AddBlipForCoord(-1117.48, -1438.72, 5.107)
    SetBlipSprite (blip, 354)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.9)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Skate Shop")
    EndTextCommandSetBlipName(blip)

	SetEntityAsMissionEntity(ped)
	SetEntityHeading(ped, 256.90)
	FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	TaskPlayAnim(ped,"amb@world_human_car_park_attendant@male@idle_a","idle_a", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
	exports["lcrp-interact"]:AddBoxZone("buySkate", vector3(-1126.75, -1439.44, 5.23), 1.75, 1.2, {
		name="buySkate",
		heading=35,
		--debugPoly=true,
		minZ=4.23,
		maxZ=6.03 }, {
		options = {
			{
				event = "lcrp-skate:server:buySkate",
				icon = "far fa-snowboarding",
				label = "Buy skate",
				duty = false,
				serverEvent = true
			},
		},
	job = {"all"}, distance = 3 })

end)
