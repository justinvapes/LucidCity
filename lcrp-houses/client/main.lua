scCore = nil
local timer, drawRange, timeInd, keyRequests, keyChanges, activeKey = 0, 0, -1, 0, 0, 51
local HasAlreadyEnteredMarker, isDead, isInMarker, canUpdate, atShop, inShop, shouldDelete, inHome, isUnfurnishing, blinking, shouldDrawhelpText = false, false, false, false, false, false, false, false, false, false, false, false
local LastZone, CurrentAction, currentZone, spawnedFurn, homeID, dor2Update, returnPos
local currentHouseID = nil
local CurrentActionData, PlayerData, Houses, ParkedCars, SpawnedHome, FrontDoor, spawnedHouseSpots, scriptBlips, validObjects, spawnedProps, persFurn, ticks, totalKeys = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
local Blips, Markers = Config.Blips, Config.Markers
local currentHouse
local renderGUI2
local oldProp
PlayerJob = nil
PlayerData = nil
local bypass = false
local cryptoPcInRange = false
local canLeave = false

local cryptoPCProp = 'deskpc_model'

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        Citizen.Wait(1000)
    
		isLoggedIn = true
		PlayerData = scCore.Functions.GetPlayerData()
		PlayerJob = PlayerData.job
		onDuty = PlayerJob.onduty
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		if isLoggedIn then
			if currentHouse ~= nil then
				if PlayerData.citizenid == currentHouse.owner or HasKeys(currentHouse) then
					TriggerEvent('lcrp-garages:client:setHouseGarage', currentHouse, true)
				else
					TriggerEvent('lcrp-garages:client:setHouseGarage', currentHouse, false)
				end
			end
		end
	end
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)


RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = scCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
    onDuty = PlayerJob.onduty
end)

Citizen.CreateThread(function()
	while not isLoggedIn do
		Citizen.Wait(10)
	end

	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do 
		scCore.ShowHelpNotification('Final loading, please wait. ', false, false, 100)
		Citizen.Wait(100)
		scCore.ShowHelpNotification('Final loading, please wait.. ', false, false, 100)
		Citizen.Wait(100)
		scCore.ShowHelpNotification('Final loading, please wait...', false, false, 100)
		Citizen.Wait(100)
	end
	TriggerServerEvent('lcrp-houses-new:server:getHouses')
	--TriggerServerEvent('lcrp-houses-new:updateHomes')

	if Config.MonthlyContracts.Use then --currently not used
		TriggerServerEvent('lcrp-houses-new:checkOwnedDates')
	end

	local blip = AddBlipForCoord(Config.Furnishing.Store.shopPos)

	SetBlipSprite (blip, Blips.Furniture.Sprite)
	SetBlipScale  (blip, Blips.Furniture.Scale)
	SetBlipAsShortRange(blip, true)
	SetBlipColour (blip, Blips.Furniture.Color)
	SetBlipDisplay(blip, Blips.Furniture.Display)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Blips.Furniture.Text)
	EndTextCommandSetBlipName(blip)

  local readyHomes = {}
	while #readyHomes < 1 do
    Citizen.Wait(100)
    for k,v in pairs(Houses) do
      table.insert(readyHomes, k)
    end
  end

  scCore.TriggerServerCallback('lcrp-houses-new:getHouseIn', function(address)
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	house = Houses[address]
	if house then
		SetEntityCoords(ped, house.door)
	end
    if Houses[address] then
		scCore.TriggerServerCallback('lcrp-houses-new:server:getHouseInside', function(inside)
		
			Houses[house.id].storage = inside.storage
			Houses[house.id].wardrobe = inside.wardrobe
			Houses[house.id].furniture = inside.furniture
			--print(json.encode(Houses[house.id]))
			if Config.ReconnectInside then
				if PlayerData.citizenid == Houses[address].owner or HasKeys(Houses[address]) or CanRaid() then
				  TriggerEvent('lcrp-houses-new:spawnHome', Houses[address], 'owned')
				else
				  local pos = GetEntityCoords(PlayerPedId())
				  TriggerEvent('lcrp-houses-new:spawnHome', Houses[address], 'owned', {x = pos.x, y = pos.y, z = pos.z}, 'false')
				end
			  else
				currentHouse = house
				ClearAreaOfEverything(pos, Config.Shells[house.shell].shellsize, false, false, false, false)
				TriggerServerEvent('lcrp-houses-new:playerEnteredExitedHome', address, false)
			  end
	
		end, house.id)
    end
  end)

  
	TriggerServerEvent('lcrp-houses-new:refreshVehicles')
	local sleep
	while true do
		sleep = 500
		local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)
		local storedDis = 100
		isInMarker, canUpdate = false, false
		for k,v in pairs(Houses) do
			local dis = #(pos - v.door)
			if dis ~= nil and v.draw ~= nil then
				if dis <= v.draw then
					currentZone = v
					sleep = 5
					if dis <= 5 and dis > 1.25 and not bypass then
						closeMenuFull()
					end
					if dis <= 1.25 then
						isInMarker  = true
						--[[ if IsControlJustReleased(0, 51) then
							HouseMenu(CurrentActionData)
							Menu.hidden = not Menu.hidden
						end ]]
						Menu.renderGUI()
					end
					if currentZone ~= nil then
						currentHouse = currentZone
					end
					if scCore.Functions.GetPlayerData().citizenid == v.owner then
						if Markers.OwnedMarkers then
							if checkTerritory then
								DrawMarker(28, v.door.x, v.door.y, v.door.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.draw + 0.0, v.draw + 0.0, v.draw + 0.0, 255, 0, 0, 100, false, false, 2, nil, nil, false)
							end
							DrawMarker(1, v.door, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, false, 2, false, false, false, false)
						end
					elseif v.owner == 'nil' then
						if Markers.UnOwnedMarks then
							if checkTerritory then
								DrawMarker(28, v.door.x, v.door.y, v.door.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.draw + 0.0, v.draw + 0.0, v.draw + 0.0, 255, 0, 0, 100, false, false, 2, nil, nil, false)
							end
							DrawMarker(1, v.door, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, false, 2, false, false, false, false)
						end
					else
						if Markers.OtherMarkers then
							if checkTerritory then
								DrawMarker(28, v.door.x, v.door.y, v.door.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.draw + 0.0, v.draw + 0.0, v.draw + 0.0, 255, 0, 0, 100, false, false, 2, nil, nil, false)
							end
							DrawMarker(1, v.door, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, false, 2, false, false, false, false)
						end
					end
					

					for i = 1,#v.doors do
						if v.doors[i] ~= nil then
							if type(v.doors[i].pos) ~= 'vector3' then
								v.doors[i].pos = vector3(doRound(v.doors[i].pos.x, 2), doRound(v.doors[i].pos.y, 2), doRound(v.doors[i].pos.z, 2))
							end
							if not v.doors[i].object then
								v.doors[i].object = GetClosestObjectOfType(v.doors[i].pos, 2.0, v.doors[i].prop, false, false, false)
							end
							if not DoesEntityExist(v.doors[i].object) then
								v.doors[i].object = GetClosestObjectOfType(v.doors[i].pos, 2.0, v.doors[i].prop, false, false, false)
							end
							if v.owner == 'nil' then
								v.doors[i].locked = false
							end
							local dis = #(pos - v.doors[i].pos)
							if dis <= 2.5 then
								FreezeEntityPosition(v.doors[i].object, v.doors[i].locked)
								DrawDoorText(v.doors[i].pos, v.doors[i].locked)
								if v.owner == PlayerData.citizenid or HasKeys(v) then
									storedDis = dis
									canUpdate = true
									dor2Update = v.doors[i]
									currentZone = v

									if IsControlJustReleased(1, 47) then
										TriggerServerEvent('lcrp-houses-new:updateDoor', currentZone, dor2Update)
									end

									if Markers.OwnedMarkers then
										DrawMarker(1, v.door, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, false, 2, false, false, false, false)
									end
								else
									if v.owner == 'nil' then
										if Markers.UnOwnedMarks then
											DrawMarker(1, v.door, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, false, 2, false, false, false, false)
										end
									else
										if Markers.OtherMarkers then
											DrawMarker(1, v.door, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, false, 2, false, false, false, false)
										end
									end
								end
							end
							
							if v.doors[i].locked == true then
								SetEntityHeading(v.doors[i].object, v.doors[i].head)
							end
						end
					end
					for i = 1,#v.garages do
						if v.garages[i] ~= nil then
							if type(v.garages[i].pos) ~= 'vector3' then
								v.garages[i].pos = vector3(doRound(v.garages[i].pos.x, 2), doRound(v.garages[i].pos.y, 2), doRound(v.garages[i].pos.z, 2))
							end
							if not v.garages[i].object then
								v.garages[i].object = GetClosestObjectOfType(v.garages[i].pos, 2.0, v.garages[i].prop, false, false, false)
							end
							if not DoesEntityExist(v.garages[i].object) then
								v.garages[i].object = GetClosestObjectOfType(v.garages[i].pos, 2.0, v.garages[i].prop, false, false, false)
							end
							if v.owner == 'nil' then
								v.garages[i].locked = false
							end
							local dis = #(pos - v.garages[i].pos)
							if dis <= v.garages[i].draw * 2.0 then
								FreezeEntityPosition(v.garages[i].object, v.garages[i].locked)
								if dis <= v.garages[i].draw then
									DrawDoorText(v.garages[i].pos, v.garages[i].locked)
									if dis < storedDis then
										if v.owner == PlayerData.citizenid or HasKeys(v) then
											canUpdate = true
											door2Update = v.garages[i]
											currentZone = v

											if IsControlJustReleased(1, 47) then
												TriggerServerEvent('lcrp-houses-new:updateDoor', currentZone, door2Update)
											end

										end
									end
								end
							end
						end
					end

					if Config.Parking.ScriptParking ~= false then
						if v.owner ~= 'nil' or Config.Parking.AllowNil then
							if Config.Parking.AllowAll or v.owner == PlayerData.citizenid or HasKeys(v) then
								v.garageType = tonumber(v.garageType)
								if v.garageType == 1 then
									if IsPedInAnyVehicle(ped, true) then
										for i = 1, #v.parkings do
											vec = vector3(v.parkings[i].x, v.parkings[i].y, v.parkings[i].z - 1.0)
											dis = #(pos - vec)
											if PlayerData.citizenid == v.owner then
												if Markers.OwnedMarkers then
													DrawMarker(1, vec, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 255, 100, false, false, 2, false, false, false, false)
												end
											else
												if Markers.OtherMarkers then
													DrawMarker(1, vec, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 0, 100, false, false, 2, false, false, false, false)
												end
											end
											if dis <= 1.5 then
												DrawPrompt(vec, Config.Strings.parkCar)
												if IsControlJustReleased(0, 51) then
													local veh = GetVehiclePedIsIn(ped, false)
													if not IsParkingTaken(vec, GetVehicleNumberPlateText(veh)) then
														if DoesEntityExist(veh) then
															if GetPedInVehicleSeat(veh, -1) == ped then
																local vehProps  = scCore.Functions.GetVehicleProperties(veh)
																local livery = GetVehicleLivery(veh)
																local damages	= {
																	eng = GetVehicleEngineHealth(veh),
																	bod = GetVehicleBodyHealth(veh),
																	tnk = GetVehiclePetrolTankHealth(veh),
																	drt = GetVehicleDirtLevel(veh),
																	oil = GetVehicleOilLevel(veh),
																	lok = GetVehicleDoorLockStatus(veh),
																	drvlyt = GetIsLeftVehicleHeadlightDamaged(veh),
																	paslyt = GetIsRightVehicleHeadlightDamaged(veh),
																	dor = {},
																	win = {},
																	tyr = {}
																}
																local vehPos    = GetEntityCoords(veh)
																local vehHead   = GetEntityHeading(veh)
																for i = 0,5 do
																	damages.dor[i] = not DoesVehicleHaveDoor(veh, i)
																end
																for i = 0,3 do
																	damages.win[i] = not IsVehicleWindowIntact(veh, i)
																end
																damages.win[6] = not IsVehicleWindowIntact(veh, 6)
																damages.win[7] = not IsVehicleWindowIntact(veh, 7)
																for i = 0,7 do
																	damages.tyr[i] = false
																	if IsVehicleTyreBurst(veh, i, false) then
																		damages.tyr[i] = 'popped'
																	elseif IsVehicleTyreBurst(veh, i, true) then
																		damages.tyr[i] = 'gone'
																	end
																end
																LastPlate = vehProps.plate
																if Config.BlinkOnRefresh then
																	if not blinking then
																		blinking = true
																		if timeInd ~= 270 then
																			timeInd = GetTimecycleModifierIndex()
																			SetTimecycleModifier('Glasses_BlackOut')
																		end
																	end
																end
																DeleteEntity(veh)
																SetEntityCoords(ped, GetOffsetFromEntityInWorldCoords(ped, -1.0, 0.0, 0.0))
																TriggerServerEvent('lcrp-houses-new:parkUnpark', {
																	location = {x = vehPos.x, y = vehPos.y, z = vehPos.z, h = vehHead},
																	props    = vehProps,
																	livery   = livery,
																	damages   = damages
																})
															else
																scCore.Notification('You must be driving to do this')
															end
														else
															scCore.Notification(Config.Strings.mstBNCr)
														end
													else
														scCore.Notification('You are too close to another parked vehicle, move elsewhere')
													end
												end
											end
										end
									end

								end
							end
						end
					end
				end
			end
		end
		
		local dis = #(pos - Config.Furnishing.Store.enter)
		if dis <= Config.Furnishing.Store.range then
			if not Config.Furnishing.Store.isMLO then
				sleep = 5
				if Markers.FurnMarkers then
					DrawMarker(1, Config.Furnishing.Store.enter, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, false, 2, false, false, false, false)
				end
				if dis < 1.25 then
					DrawPrompt(Config.Furnishing.Store.enter, Config.Strings.ntrFurn)
					if IsControlJustReleased(0, 51) then
						OpenFurnStore()
					end
				end
			end
		end
		if not Config.Furnishing.Store.isMLO then
			dis = #(pos - Config.Furnishing.Store.exitt)
			if Markers.FurnMarkers then
				if dis <= Config.Furnishing.Store.range then
					sleep = 5
					DrawMarker(1, Config.Furnishing.Store.exitt.x, Config.Furnishing.Store.exitt.y, Config.Furnishing.Store.exitt.z-1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, false, 2, false, false, false, false)
				end
			end
			if dis <= 1.25 then
				DrawPrompt(Config.Furnishing.Store.exitt, Config.Strings.xitFurn)
				if IsControlJustReleased(0, 51) then
					for k,v in pairs(spawnedProps) do
						DeleteEntity(v)
					end
					SetEntityCoords(ped, Config.Furnishing.Store.enter)
					SetEntityHeading(ped, Config.Furnishing.Store.exthead)
					atShop = false
					inShop = false
				end
			end
		end
		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('lcrp-houses-new:hasEnteredMarker', currentZone)
		end
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('lcrp-houses-new:hasExitedMarker', LastZone)
		end
		Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	while scCore == nil do Citizen.Wait(10) end
	while true do
		Citizen.Wait(250)
		local pos = GetEntityCoords(PlayerPedId())
		for k,v in pairs(ParkedCars) do
			local dis = #(pos - v.pos)
			if dis < 100.0 then
				if not ParkedCars[k].entity or not DoesEntityExist(ParkedCars[k].entity) then
					local model = v.props.model
					if not HasModelLoaded(model) then
						ticks[model] = 0
						while not HasModelLoaded(model) do
							Citizen.Wait(10)
							RequestModel(model)
							ticks[model] = ticks[model] + 1
							if ticks[model] >= Config.ModelWaitTicks then
								ticks[model] = 0
								scCore.ShowHelpNotification('Model '..v.props.model..' failed to load, found in server image, please attempt re-logging to solve')
								return
							end
						end
					end
					if HasModelLoaded(model) then
						ParkedCars[k].entity = CreateVehicle(v.props.model, v.pos.x, v.pos.y, v.pos.z, v.location.h, false, false)
						while not DoesEntityExist(ParkedCars[k].entity) do Citizen.Wait(10); print('waiting for game to create')end
						scCore.Functions.SetVehicleProperties(ParkedCars[k].entity, v.props)
						SetVehicleOnGroundProperly(ParkedCars[k].entity)
						SetEntityAsMissionEntity(ParkedCars[k].entity, true, true)
						SetModelAsNoLongerNeeded(v.props.model)
						SetEntityInvincible(ParkedCars[k].entity, true)
						SetVehicleLivery(ParkedCars[k].entity, v.livery)
						SetVehicleEngineHealth(ParkedCars[k].entity, v.damages.eng)
						SetVehicleOilLevel(ParkedCars[k].entity, v.damages.oil)
						SetVehicleBodyHealth(ParkedCars[k].entity, v.damages.bod)
						SetVehicleDoorsLocked(ParkedCars[k].entity, v.damages.lok)
						SetVehiclePetrolTankHealth(ParkedCars[k].entity, v.damages.tnk)
						for g,f in pairs(v.damages.dor) do
							if v.damages.dor[g] then
								SetVehicleDoorBroken(ParkedCars[k].entity, tonumber(g), true)
							end
						end
						for g,f in pairs(v.damages.win) do
							if v.damages.win[g] then
								SmashVehicleWindow(ParkedCars[k].entity, tonumber(g))
							end
						end
						for g,f in pairs(v.damages.tyr) do
							if v.damages.tyr[g] == 'popped' then
								SetVehicleTyreBurst(ParkedCars[k].entity, tonumber(g), false, 850.0)
							elseif v.damages.tyr[g] == 'gone' then
								SetVehicleTyreBurst(ParkedCars[k].entity, tonumber(g), true, 1000.0)
							end
						end
						while not HasCollisionLoadedAroundEntity(ParkedCars[k].entity) do
							Citizen.Wait(10)
						end
						SetVehicleOnGroundProperly(ParkedCars[k].entity)
						FreezeEntityPosition(ParkedCars[k].entity, true)
					end
					Citizen.Wait(100)
				end
			else
				if ParkedCars[k]~= nil then
					DeleteEntity(ParkedCars[k].entity)
					ParkedCars[k].entity = nil
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local pos = GetEntityCoords(PlayerPedId())
		if not isUnfurnishing then
			for k,v in pairs(persFurn) do
				local dis = #(pos - v.pos)
				if dis < 100.0 then
					if not persFurn[k].entity then
						local model = GetHashKey(v.model)
						if not HasModelLoaded(model) then
							ticks[model] = 0
							while not HasModelLoaded(model) do
								Citizen.Wait(10)
								RequestModel(model)
								ticks[model] = ticks[model] + 1
								if ticks[model] >= Config.ModelWaitTicks then
									ticks[model] = 0
									scCore.ShowHelpNotification('Model '..v.model..' failed to load, found in server image, please attempt re-logging to solve')
									return
								end
							end
						end
						if HasModelLoaded(model) then
							persFurn[k].entity = CreateObjectNoOffset(model, v.pos.x, v.pos.y, v.pos.z, false, false, false)
							while not DoesEntityExist(persFurn[k].entity) do Citizen.Wait(10) end
							SetEntityAsMissionEntity(persFurn[k].entity, true, true)
							SetEntityHeading(persFurn[k].entity, v.head)
							SetModelAsNoLongerNeeded(model)
							SetEntityInvincible(persFurn[k].entity, true)
							FreezeEntityPosition(persFurn[k].entity, true)
							while not HasCollisionLoadedAroundEntity(persFurn[k].entity) do
								print('waiting for furniture')
								Citizen.Wait(10)
							end
						end
					end
				elseif persFurn[k].entity ~= nil then
					DeleteEntity(persFurn[k].entity)
					persFurn[k].entity = nil
				end
			end
		end
	end
end)

doRound = function(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

IsParkingTaken = function(pos, plate)
	plate = MathTrim(plate)
	local taken = false
	for k,v in pairs(ParkedCars) do
		local dis = #(pos - v.pos)
		if dis < 2.0 then
			if not MathTrim(GetVehicleNumberPlateText(v.entity)) == plate then
				taken = true
			end
		end
	end
	return taken
end

IsParkingTooClose = function(pos)
	local tooClose = false
	for k,v in pairs(Houses) do
		for i = 1,#v.parkings do
			local vec = vector3(v.parkings[i].x, v.parkings[i].y, v.parkings[i].z)
			local dis = #(vec - pos)
			if dis <= 2.5 then
				tooClose = true
			end
		end
	end
	return tooClose
end

GetSafeSpot = function()
	for i = 1,#Config.Defaults.SpawnSpots do
		if not IsHomeTouchingHome(Config.Defaults.SpawnSpots[i].x, Config.Defaults.SpawnSpots[i].y, Config.Defaults.SpawnSpots[i].z) then
			return Config.Defaults.SpawnSpots[i]
		end
	end
	return vector3(0.0, 0.0, 0.0)
end

CreateRandomAddress = function()
	math.randomseed(GetGameTimer())
	local streetName, streetNum = '', math.random(1000, 99999)
	for i = 1, 5 do
		streetName = streetName..string.char(math.random(97,122))
	end
	streetName = streetName..' '
	for i = 1, 10 do
		streetName = streetName..string.char(math.random(97,122))
	end
	return streetNum..' '..streetName..' Drive'
end

IsHouseUnlocked = function(home)
	unLocked = false
	--[[ if PlayerData.citizenid == home.owner then
		unLocked = true
	end ]]
	for i = 1,#home.doors do
		if home.doors[i] ~= nil then
			if home.doors[i].locked == false then
				unLocked = true
			end
		end
	end
	for i = 1,#home.garages do
		if home.garages[i] ~= nil then
			if home.garages[i].locked == false then
				unLocked = true
			end
		end
	end
	return unLocked
end

HelpText1 = function(msg, beep)
	SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 200)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(msg)
    DrawText(Config.HelpText.X, Config.HelpText.Y)
end

HelpText2 = function(msg, beep)
	SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 200)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(msg)
    DrawText(Config.HelpText.X, Config.HelpText.Y + 0.09)
end


HelpText3 = function(msg, beep)
	SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 200)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(msg)
    DrawText(Config.HelpText.X, Config.HelpText.Y + 0.17)
end

DrawText3Ds = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

CanRaid = function()
	local hasJob = false
	for k,v in pairs(Config.Raids.Jobs) do
		if PlayerData.job.name == k then
			if PlayerData.job.grade >= v then
				hasJob = true
			end
		end
	end
	return hasJob
end

HasKeys = function(house)
	local hasKey = false
	if house.keys and type(house.keys) == 'table' then
		for i = 1,#house.keys do
			if PlayerData.citizenid == house.keys[i] then
				hasKey = true
			end
		end
	end
	return hasKey
end

IsUnlocked = function(house)
	if house.locked then
		return house.locked == 'false'
	end
end

IsHouseSpawned = function(house)
	local isSpawned, owner, spot = false
	for k,v in pairs(spawnedHouseSpots) do
		if k == house.id then
			isSpawned = true
			owner = v.owner
			spot = v.spot
		end
	end
	return isSpawned, owner, spot
end

DrawDoorText = function(pos, text)
	
	if text == true then
		text = "~r~[G]~w~ - Locked"
	else
		text = "~r~[G]~w~ - Unlocked"
	end
	local onScreen,_x,_y=World3dToScreen2d(pos.x, pos.y, pos.z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local scale = 0.5
	local text = text
	
	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(2)
		AddTextComponentString(text)
		DrawText(_x,_y)
		local factor = (string.len(text)) / 370
		DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)

		ClearDrawOrigin()
	end
end

DrawPrompt = function(pos, text)
	local onScreen,_x,_y=World3dToScreen2d(pos.x, pos.y, pos.z+1.0)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local scale = 0.5
	local text = text
	
	if onScreen then
		SetTextScale(scale, scale)
		SetTextFont(0)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(1, 1, 0, 0, 255)
		SetTextEdge(0, 0, 0, 0, 150)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(2)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end

--[[ function HouseMenu(CurrentActionData)
	local ped = PlayerPedId()
	house = CurrentActionData
	local isMLO = house.shell == 'mlo'
	currentHouse = house
	ClearMenu()

	if house.owner == 'nil' then
		if house.isSpec < 2 then
			if PlayerData.citizenid == house.prevowner then
				Menu.addButton("Remove house sale listing ($"..house.price..")", "BuyHouse", house)
			else
				Menu.addButton(Config.Strings.buyText:format(house.price), "BuyHouse", house)
			end
		end
		if house.isSpec > 0 then
			Menu.addButton(Config.Strings.buySpec:format(house.price*(Config.SpecialProperties.Percentage/100), Config.SpecialProperties.AccountLabel), "buySpec", nil)
		end
		if not isMLO then
			Menu.addButton(Config.Strings.viewTxt, "viewHouse", house)
		end
	elseif PlayerData.citizenid == house.owner then
		if not isMLO then
			Menu.addButton(Config.Strings.entrTxt, "enterHouse", house)
		end
		Menu.addButton(Config.Strings.sellTxt, "VerifySell", house)
		Menu.addButton(Config.Strings.gvKyTxt, "giveHouseKeyMenu", house)
		Menu.addButton(Config.Strings.tkKyTxt, "takeHouseKeyMenu", house)
	elseif HasKeys(house) then
		if not isMLO then
			Menu.addButton(Config.Strings.entrTxt, "useHouseKey", house)
			Menu.addButton(Config.Strings.nokText, "knockHouseDoor", nil)
		end
	elseif IsUnlocked(house) then
		if not isMLO then
			Menu.addButton(Config.Strings.entrTxt, "useHouseKey", house)
			Menu.addButton(Config.Strings.nokText, "knockHouseDoor", nil)
		end
	elseif CanRaid() then
		if not isMLO then
			Menu.addButton(Config.Strings.nokText, "knockHouseDoor", nil)
			Menu.addButton(Config.Strings.raidTxt, "raidHouse", nil)
		end
	
	else
		if not isMLO and Config.BandE.Allow then
			Menu.addButton(Config.Strings.nokText, "knockHouseDoor", nil)
		end
	end
	Menu.addButton("Close Menu", "closeMenuFull", nil) 
end ]]



-- [[ FUNCTIONS ]] --

function BuyHouse(house)
	ClearMenu()
	if  PlayerData.citizenid == house.prevowner then
		closeMenuFull()
		TriggerServerEvent('lcrp-houses-new:purchaseHome', house, buyer)
	else
		if Config.FurnishedHouses[house.shell] == nil then
			closeMenuFull()
			TriggerServerEvent('lcrp-houses-new:purchaseHome', house)
		else
			Menu.addButton(Config.Strings.autoFrn, "title", nil)
		
			Menu.addButton("Yes", "purchaseWithFurnitureYes", house, true)
			Menu.addButton("No", "purchaseWithFurnitureNo", house)

			Menu.addButton("Close Menu", "closeMenuFull", nil) 
		end
	end
end

function purchaseWithFurnitureYes(house)		
	closeMenuFull()
	TriggerServerEvent('lcrp-houses-new:purchaseHome', house)
end

function purchaseWithFurnitureNo(house)		
	closeMenuFull()
	TriggerServerEvent('lcrp-houses-new:purchaseHome', house, false)
end

function title()
end

function buySpec()
	ClearMenu()

	if  PlayerData.citizenid == house.prevowner then
		closeMenuFull()
		TriggerServerEvent('lcrp-houses-new:purchaseHome', house)
	end
end

function buySpec()
	if  PlayerData.citizenid == house.prevowner then
		closeMenuFull()
		TriggerServerEvent('lcrp-houses-new:purchaseHome', house)
	else
		ClearMenu()

		Menu.addButton(Config.Strings.autoFrn, "title", nil)
		
		Menu.addButton(Config.Strings.confTxt, "BuySpecWithFurnitureYes", house)
		Menu.addButton(Config.Strings.decText, "BuySpecWithFurnitureNo", house)

		Menu.addButton("Close Menu", "closeMenuFull", nil) 
	end
end

function BuySpecWithFurnitureYes(house)
	closeMenuFull()
	TriggerServerEvent('lcrp-houses-new:purchaseHome', house, 'nil', true)
end

function BuySpecWithFurnitureNo(house)
	closeMenuFull()
	TriggerServerEvent('lcrp-houses-new:purchaseHome', house, false, true)
end

function viewHouse(house)

	scCore.TriggerServerCallback('lcrp-houses-new:server:getHouseInside', function(inside)
		
		Houses[house.id].storage = inside.storage
		Houses[house.id].wardrobe = inside.wardrobe
		Houses[house.id].furniture = inside.furniture
		
		--print(json.encode(Houses[house.id]))
		scCore.TriggerServerCallback('lcrp-houses-new:getSpots', function(spots)
			spawnedHouseSpots = spots
			closeMenuFull()
			TriggerEvent('lcrp-houses-new:spawnHome', Houses[house.id], 'visit')
		end)

	end, house.id)

end

function enterHouse(house)
	scCore.TriggerServerCallback('lcrp-houses-new:server:getHouseInside', function(inside)
		
		Houses[house.id].storage = inside.storage
		Houses[house.id].wardrobe = inside.wardrobe
		Houses[house.id].furniture = inside.furniture
		--print(json.encode(Houses[house.id]))
		
		scCore.TriggerServerCallback('lcrp-houses-new:getSpots', function(spots)
			spawnedHouseSpots = spots
			local houseSpawned, houseOwner, spawnSpot = IsHouseSpawned(Houses[house.id])
			TriggerServerEvent('lcrp-houses:server:SetInsideMeta', house, true)
			TriggerEvent('lcrp-drugs:client:getHousePlants', house.id)
			if not houseSpawned then
				closeMenuFull()
				TriggerEvent('lcrp-houses-new:spawnHome', Houses[house.id], 'owned')
			else
				closeMenuFull()
				TriggerServerEvent('lcrp-houses-new:doorKnock', house.id, 'false')
			end
		end)

	end, house.id)
end

function knockHouseDoor(house)
	scCore.TriggerServerCallback('lcrp-houses-new:getSpots', function(spots)
		spawnedHouseSpots = spots
		closeMenuFull()
		TriggerServerEvent('lcrp-houses-new:doorKnock', house.id)
	end)
end

function raidHouse(house)
	scCore.TriggerServerCallback('lcrp-houses-new:getSpots', function(spots)
		spawnedHouseSpots = spots
		closeMenuFull()
		TriggerServerEvent('lcrp-houses-new:doorKnock', house.id, 'true')
	end)
end

function giveHouseKey(house)
	local player, distance = scCore.Functions.GetClosestPlayer()
	if distance <= 1.5 and distance > 0 then
		TriggerServerEvent('lcrp-houses-new:giveKey', GetPlayerServerId(player), house)
	else
		scCore.Notification("No one around!", "error")
	end
end

function takeHouseKey(house)
	local player, distance = scCore.Functions.GetClosestPlayer()
	if distance <= 1.5 and distance > 0 then
		TriggerServerEvent('lcrp-houses-new:takeKey', house, GetPlayerServerId(player))
	else
		scCore.Notification("No one around!", "error")
	end
end

function useHouseKey(house)
	scCore.TriggerServerCallback('lcrp-houses-new:server:getHouseInside', function(inside)
		
		Houses[house.id].storage = inside.storage
		Houses[house.id].wardrobe = inside.wardrobe
		Houses[house.id].furniture = inside.furniture
		--print(json.encode(Houses[house.id]))

		scCore.TriggerServerCallback('lcrp-houses-new:getSpots', function(spots)
			spawnedHouseSpots = spots
			local houseSpawned, houseOwner, spawnSpot = IsHouseSpawned(house)
			TriggerServerEvent('lcrp-houses:server:SetInsideMeta', house, true)
			TriggerEvent('lcrp-drugs:client:getHousePlants', house.id)
			if not houseSpawned then
				closeMenuFull()
				TriggerEvent('lcrp-houses-new:spawnHome', Houses[house.id], 'owned')
			else
				closeMenuFull()
				TriggerServerEvent('lcrp-houses-new:doorKnock', house.id, 'false')
			end
		end)

	end, house.id)
end

function OpenOutfitsMenu()
	ClearMenu()

    Menu.addButton("Outfits", "OutfitList", nil)
    Menu.addButton("Close Menu", "closeMenuFull", nil)
end

function OutfitList()
    scCore.TriggerServerCallback("lcrp-clothes:outfitList", function(result)
		ClearMenu()
		if result == nil or json.encode(result) == "[]" then
			scCore.Notification("You have no outfits!", "error")
			closeMenuFull()
		else
			for k, v in pairs(result) do
				Menu.addButton("Slot: " .. result[k].slot .. " | Name: " ..result[k].name, "SelectOutfit", result[k].slot)
			end

			Menu.addButton("Back", "OpenOutfitsMenu")
		end
    end)
end

function SelectOutfit(outfit)
    TriggerEvent('InteractSound_CL:PlayOnOne','Clothes1', 0.6)
    TriggerServerEvent("lcrp-clothes:get_outfit", outfit)
    closeMenuFull()
end

ExitMenu = function(house)
	TriggerEvent('lcrp-houses-interact:client:exitOptions', true)
end

function lockHouseDoor(house)
	closeMenuFull()
	if house.locked == 'false' then
		house.locked = 'true'
	else
		house.locked = 'false'
	end
	TriggerServerEvent('lcrp-houses-new:lockHouse', house)
end

function letInHouseMenu(house)
	

	ClearMenu()

	if distance <= 1.5 and distance > 0 then
		letInHouseData = {}
		letInHouseData.player = player
		letInHouseData.house = house
		Menu.addButton(GetPlayerName(player), "letInHouse", letInHouseData)
	else
		closeMenuFull()
		return scCore.Notification("No player close by!", "error")
	end
	Menu.addButton("Close Menu", "closeMenuFull", nil) 
end

function letInHouse(house)
	local door = house.door
	local vec = vector3(door.x, door.y, door.z)
	local player, distance = scCore.Functions.GetClosestPlayer(vec)
	if distance <= 1.5 and distance > 0 then
		TriggerServerEvent('lcrp-houses-new:knockAccept', GetPlayerServerId(player), GetEntityCoords(SpawnedHome[1]), house.id)
	else
		scCore.Notification("No one by the door", "error")
	end
end

function exitHouse(house)
	door = house.door
	vec = vector3(door.x, door.y, door.z)
	ped = GetPlayerPed(-1);
	closeMenuFull()
	if Config.BlinkOnRefresh then
		if not blinking then
			blinking = true
			if timeInd ~= 270 then
				timeInd = GetTimecycleModifierIndex()
				SetTimecycleModifier('Glasses_BlackOut')
			end
		end
	end
	scCore.Notification(Config.Strings.amExitt)
	SetEntityCoords(ped, vec.x, vec.y, vec.z)
	FreezeEntityPosition(PlayerPedId(), true)
	while not HasCollisionLoadedAroundEntity(ped) do
		Citizen.Wait(1)
		SetEntityCoords(ped, vec.x, vec.y, vec.z)
		DisableAllControlActions(0)
	end
	scCore.Notification(Config.Strings.amClose)
	Citizen.Wait(1000)
	if Config.BlinkOnRefresh then
		if timeInd ~= -1 then
			SetTimecycleModifier(Config.TimeCycleMods[tostring(timeInd)])
		else
			timeInd = -1
			ClearTimecycleModifier()
		end
		blinking = false
	end
	FreezeEntityPosition(PlayerPedId(), false)
	TriggerServerEvent('lcrp-houses-new:regSpot', 'remove', vec, house.id)
	TriggerServerEvent('lcrp-houses-new:playerEnteredExitedHome', house.id, false)
	TriggerServerEvent('lcrp-houses:server:SetInsideMeta', house, false)
	TriggerEvent('lcrp-drugs:client:leaveHouse')
	for i = 1,#SpawnedHome do
		if DoesEntityExist(SpawnedHome[i]) then
			DeleteEntity(SpawnedHome[i])
		end
	end
	spawnedFurn = nil
	inHome = false
	currentHouseID = nil
	TriggerEvent('lcrp-houses-new:setPlayerInHome', inHome)
	FrontDoor = {}
	SpawnedHome = {}
end

GetKey = function()
	keyRequests = keyRequests + 1
	if keyRequests == 100 then
		for k,v in pairs(Config.BandE.EventKeys) do
			table.insert(totalKeys, v)
		end
		math.randomseed(GetGameTimer())
    activeKey = totalKeys[math.random(#totalKeys)]
		keyRequests = 0
		keyChanges = keyChanges + 1
	end
end

DrawShopText = function(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x, y, z)
  local pos = vector3(x,y,z)
  local lngth = #(pos-GetGameplayCamCoords())
	local scale = 5/lngth
	local text = text
	
	if onScreen then
		SetTextScale(scale, scale)
		SetTextFont(0)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(1, 1, 0, 0, 255)
		SetTextEdge(0, 0, 0, 0, 150)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(2)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end

SetHomeWeather = function()
	if Config.Weather.ClockTime.x == 24 then
		Config.Weather.ClockTime.x = 0
	end
	SetRainFxIntensity(Config.Weather.RainIntensity) -- May not be needed, just doing it in-case
	SetWeatherTypeNowPersist(Config.Weather.WeatherType) -- initial set weather
	NetworkOverrideClockTime(math.floor(Config.Weather.ClockTime.x), math.floor(Config.Weather.ClockTime.y), math.floor(Config.Weather.ClockTime.z))
end


SelectPrice = function(house)
	closeMenuFull()
	local ped = PlayerPedId()
	TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_STAND_MOBILE', 0, false)
	local chosePrice = nil
	local setPrice = scCore.KeyboardInput(Config.Strings.setPryc, "", 10)
	setPrice = tonumber(setPrice)

	if setPrice == nil then
		scCore.Notification(Config.Strings.needNum)
	elseif setPrice > Config.MaxSellPrice then
		scCore.Notification(Config.Strings.lowPryc:format(Config.MaxSellPrice))
	else
		chosePrice = setPrice
		closeMenuFull()
	end

	while true do
		Citizen.Wait(5)
		if chosePrice ~= nil then
			break
		end
	end

	if chosePrice ~= nil then
		TriggerServerEvent('lcrp-houses-new:sellHouse', house.id, chosePrice, 'market')
	else
		scCore.Notification(Config.Strings.noPrice)
	end

	Citizen.Wait(1500)
	ClearPedTasks(ped)
	scCore.Notification(Config.Strings.onMarkt:format(house.id,chosePrice))
end

RollCheck = function(roll, market)
	local didWin = false
	if market == 'byback' then
		for i = 1,#Config.BuyBack.Win do
			if roll == Config.BuyBack.Win[i] then
				didWin = true
			end
		end
	end
	return didWin
end

AttemptBuyBack = function(house)
	closeMenuFull()
	local ped = PlayerPedId()
	scCore.Notification(Config.Strings.buyBack:format(house.id))
	TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_STAND_MOBILE', 0, false)
	Citizen.Wait(2500)
	TriggerServerEvent('lcrp-houses-new:sellHouse', house.id, math.floor(house.price * 0.7), 'byback')
	scCore.Notification(Config.Strings.bawtBck:format(house.id,math.floor(house.price * 0.7)))
	ClearPedTasks(ped)
end

function confirmFurniturePurchase(furnitureData)
	TriggerServerEvent('lcrp-houses-new:purchaseFurn', furnitureData)
	closeMenuFull()
	atShop = false
end

function OpenFurnStore()
	local ped = PlayerPedId()
	ClearMenu()

	if oldProp ~= nil then
		DeleteEntity(oldProp)
	end

	Menu.addButton("Choose category", "title", nil)

	local sortedCategories = {}

	for categoryNumber, categories in pairs(Config.Furnishing.Props) do
		table.insert(sortedCategories, categoryNumber)
	end

	table.sort(sortedCategories, function(a,b)
		return a < b
	end)

	for k, v in pairs(sortedCategories) do
		Menu.addButton(v, "OpenFurnMenu", v)
	end

	FreezeEntityPosition(PlayerPedId(), true)
	SetEntityHeading(ped, Config.Furnishing.Store.heading)

	Menu.addButton("Close Menu", "closeMenuFull", nil)
end

function OpenFurnMenu(furnMenuData)
	ClearMenu()
	Menu.addButton(furnMenuData, "title", nil)

	if oldProp ~= nil then
		DeleteEntity(oldProp)
	end

	for g,f in pairs(Config.Furnishing.Props[furnMenuData].items) do
		furnitureData = {}
		furnitureData.pos = Config.Furnishing.Props[furnMenuData].pos
		furnitureData.price = f.price
		furnitureData.label = f.label
		furnitureData.prop = f.prop
		furnitureData.v = furnMenuData
		furnitureData.categories = furnMenuData
		Menu.addButton(f.label..':'..Config.CurrencyIcon..f.price, "loadShopFurniture", furnitureData) 
	end

	Menu.addButton("Back", "OpenFurnStore", nil)
end

function loadShopFurniture(furnitureData)
	ClearMenu()
	Menu.addButton("Purchase this furniture?", "title", nil)
	Menu.addButton("Confirm", "confirmFurniturePurchase", furnitureData)

	if oldProp ~= nil then
		DeleteEntity(oldProp)
	end

	local model = furnitureData.prop
	
	if not HasModelLoaded(model) then
		ticks[model] = 0
		while not HasModelLoaded(model) do
			scCore.ShowHelpNotification('Requesting model, please wait')
			DisableAllControlActions(0)
			Citizen.Wait(10)
			RequestModel(model)
			ticks[model] = ticks[model] + 1
			if ticks[model] >= Config.ModelWaitTicks then
				ticks[model] = 0
				FreezeEntityPosition(PlayerPedId(), false)
				scCore.ShowHelpNotification('Model '..furnitureData.label..' failed to load, found in server image, please attempt re-logging to solve')
				Menu.addButton("Back", "OpenFurnMenu", furnitureData.categories)
				return
			end
		end
	end

	if HasModelLoaded(model) then
		local pos = GetEntityCoords(PlayerPedId())
		local prop = CreateObjectNoOffset(model, pos + vector3(2, 0, 0), false, false, false)
		oldProp = prop
		SetEntityAsMissionEntity(prop, true, true)
		PlaceObjectOnGroundProperly(prop)
		FreezeEntityPosition(prop, true)
	end

	Menu.addButton("Back", "OpenFurnMenu", furnitureData.categories)
end

function FurnishHome(house)
	ClearMenu()
	
	spawnedFurn = nil
	local ped = PlayerPedId()
	scCore.TriggerServerCallback('lcrp-houses-new:getBoughtFurniture', function(ownedFurn)

    if type(ownedFurn) ~= 'table' then 
		ownedFurn = {} 
	end

	if json.encode(ownedFurn) == "[]" then
		closeMenuFull()
		return scCore.Notification("You have no owned furniture!", "error")
	end

	for k,v in pairs(ownedFurn) do
		furnishData = {}
		furnishData.v = v
		furnishData.house = house
		furnishData.prop = ownedFurn[k].prop
		furnishData.label = ownedFurn[k].label
		Menu.addButton(k, "LoadFurniture", furnishData)
	end

	Menu.addButton("Close Menu", "closeMenuFull", nil) 	
	end)
end

function LoadFurniture(furnishData)
	local ped = PlayerPedId()
	local model = furnishData.prop
	local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, 0.0)
	local prop = CreateObjectNoOffset(GetHashKey(model), offset, false, false, false)
	local moveSpeed = 0.001
	PlaceObjectOnGroundProperly(prop)
	FreezeEntityPosition(prop, true)
	closeMenuFull()
	spawnedFurn = prop
	FurnitureData = {}
	FurnitureData.spawnedFurn = spawnedFurn
	FurnitureData.SpawnedHome = SpawnedHome
	FurnitureData.prop = prop
	FurnitureData.model = model
	FurnitureData.house = furnishData.house
	FurnitureData.label = furnishData.label

	if spawnedFurn ~= nil then
		shouldDrawhelpText = true
	end

	Citizen.CreateThread(function()
		while spawnedFurn ~= nil and shouldDrawhelpText do
			Citizen.Wait(1)
			HelpText1(Config.Strings.frnHelp1)
			HelpText2(Config.Strings.frnHelp2)
			HelpText3(Config.Strings.frnHelp3)
			DisableControlAction(0, 51)
			DisableControlAction(0, 96)
			DisableControlAction(0, 97)
			for i = 108, 112 do
				DisableControlAction(0, i)
			end
			DisableControlAction(0, 117)
			DisableControlAction(0, 118)
			DisableControlAction(0, 171)
			DisableControlAction(0, 254)
			if IsDisabledControlPressed(0, 171) then
				moveSpeed = moveSpeed + 0.001
			end
			if IsDisabledControlPressed(0, 254) then
				moveSpeed = moveSpeed - 0.001
			end
			if moveSpeed > 1.0 or moveSpeed < 0.001 then
				moveSpeed = 0.001
			end
			HudWeaponWheelIgnoreSelection()
			for i = 123, 128 do
				DisableControlAction(0, i)
			end
			if IsDisabledControlJustPressed(0, 186) then -- X
				CancelFurniturePlacement()
				DeleteEntity(prop)
			end
			if IsDisabledControlJustPressed(0, 176) then -- ENTER
				ConfirmFurniturePlacement(FurnitureData)
			end
			if IsDisabledControlJustPressed(0, 51) then
				PlaceObjectOnGroundProperly(spawnedFurn)
			end
			if IsDisabledControlPressed(0, 96) then
				SetEntityCoords(spawnedFurn, GetOffsetFromEntityInWorldCoords(spawnedFurn, 0.0, 0.0, moveSpeed))
			end
			if IsDisabledControlPressed(0, 97) then
				SetEntityCoords(spawnedFurn, GetOffsetFromEntityInWorldCoords(spawnedFurn, 0.0, 0.0, -moveSpeed))
			end
			if IsDisabledControlPressed(0, 108) then
				SetEntityHeading(spawnedFurn, GetEntityHeading(spawnedFurn) + 0.5)
			end
			if IsDisabledControlPressed(0, 109) then
				SetEntityHeading(spawnedFurn, GetEntityHeading(spawnedFurn) - 0.5)
			end
			if IsDisabledControlPressed(0, 111) then
				SetEntityCoords(spawnedFurn, GetOffsetFromEntityInWorldCoords(spawnedFurn, 0.0, -moveSpeed, 0.0))
			end
			if IsDisabledControlPressed(0, 110) then
				SetEntityCoords(spawnedFurn, GetOffsetFromEntityInWorldCoords(spawnedFurn, 0.0, moveSpeed, 0.0))
			end
			if IsDisabledControlPressed(0, 117) then
				SetEntityCoords(spawnedFurn, GetOffsetFromEntityInWorldCoords(spawnedFurn, moveSpeed, 0.0, 0.0))
			end
			if IsDisabledControlPressed(0, 118) then
				SetEntityCoords(spawnedFurn, GetOffsetFromEntityInWorldCoords(spawnedFurn, -moveSpeed, 0.0, 0.0))
			end
		end
	end)

	local testMod = GetHashKey(model)
	if GetEntityModel(spawnedFurn) ~= testMod then
		if not HasModelLoaded(testMod) then
			ticks[testMod] = 0
			while not HasModelLoaded(testMod) do
				scCore.ShowHelpNotification('Requesting model, please wait')
				DisableAllControlActions(0)
				Citizen.Wait(10)
				RequestModel(testMod)
				ticks[testMod] = ticks[testMod] + 1
				if ticks[testMod] >= Config.ModelWaitTicks then
					ticks[testMod] = 0
					scCore.ShowHelpNotification('Model '..model..' failed to load, found in server image, please attempt re-logging to solve')
					shouldDrawhelpText = false
					return
				end
			end
		end
		
		if HasModelLoaded(testMod) then
			if spawnedFurn ~= nil then
				DeleteEntity(spawnedFurn)
			end
			offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, 0.0)
			prop = CreateObjectNoOffset(testMod, offset, false, false, false)
			moveSpeed = 0.001
			--PlaceObjectOnGroundProperly(prop)
			FreezeEntityPosition(prop, true)
			spawnedFurn = prop
		end
	end
end

function ConfirmFurniturePlacement(FurnitureData)
	SpawnedHome = FurnitureData.SpawnedHome
	spawnedFurn = FurnitureData.spawnedFurn
	house = FurnitureData.house
	prop = FurnitureData.prop
	label = FurnitureData.label
	model = FurnitureData.model
	shouldDrawhelpText = false

	local itemSpot = GetEntityCoords(spawnedFurn)
	offset = GetOffsetFromEntityGivenWorldCoords(SpawnedHome[1], itemSpot)
	local itemHead = GetEntityHeading(spawnedFurn)
	local furn = house.furniture
	table.insert(furn.inside, {x = doRound(offset.x, 2), y = doRound(offset.y, 2), z = doRound(offset.z, 2), heading = doRound(itemHead, 2), prop = model, label = prop})
	table.insert(SpawnedHome, spawnedFurn)
	local mLo = house.shell == 'mlo'
	TriggerServerEvent('lcrp-houses-new:placeFurniture', house.id, offset.x, offset.y, offset.z, itemHead, model, label, mLo)
	closeMenuFull()
	house.furniture = furn
	Citizen.Wait(500)
	-- FurnishHome(house)
end

function CancelFurniturePlacement()
	closeMenuFull()
	shouldDrawhelpText = false
end

function UnFurnishHome(house)
	local furni = house.furniture
	ClearMenu()

	if furni ~= nil then

		Menu.addButton(Config.Strings.frnMenu, "title", nil)

		for k,v in ipairs(furni.inside) do
			unFurnishData = {}
			unFurnishData.house = house
			unFurnishData.furni = furni
			unFurnishData.prop = v.prop
			unFurnishData.label = v.label
			unFurnishData.pos = {x = v.x, y = v.y, z = v.z}
			Menu.addButton(v.label, "SellFurniture", unFurnishData)
		end

		Menu.addButton("Close Menu", "closeMenuFull", nil) 
	end
end

function SellFurniture(unFurnishData)
	local sellFurn
	local sellLabel
	local spawnedCams = {}
	furni = unFurnishData.furni
	house = unFurnishData.house
	pos = unFurnishData.pos
	label = unFurnishData.label
	prop = unFurnishData.prop
	rotationTimes = 0

	ClearMenu()

	local testMod = GetHashKey(prop)
	sellLabel = label

	if (GetEntityModel(sellFurn) ~= testMod) or (sellLabel ~= label) then
		local offSet = GetOffsetFromEntityInWorldCoords(SpawnedHome[1], pos.x, pos.y, pos.z)
		local prop = GetClosestObjectOfType(offSet, 1.0, testMod, false, false, false)
		if prop == 0 then
			prop = GetClosestObjectOfType(offSet, 5.0, testMod, false, false, false)
		end
		offSet = GetOffsetFromEntityInWorldCoords(prop, 0.0, 1.0, 1.0)
		FreezeEntityPosition(PlayerPedId(), true)

		--CAMERA
		local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		table.insert(spawnedCams, cam)
		SetCamCoord(cam, offSet.x, offSet.y, offSet.z)
		PointCamAtEntity(cam, prop)
		RenderScriptCams(true, false, 0, 0, 0)
		rotatingX = offSet.x

		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(5)

				-- F (right)
				if IsControlJustReleased(0, 49) then
					rotationTimes = rotationTimes + 1
					rotatingX = rotatingX - 0.1
					
					-- Prevent player from rotating way too much.
					if rotationTimes < 20 then
						SetCamCoord(cam, rotatingX, offSet.y, offSet.z)
					else
						scCore.Notification("Can't rotate anymore, press H to reset!", "error")
					end
				end

				-- G (left)
				if IsControlJustReleased(0, 47) then
					rotationTimes = rotationTimes + 1
					rotatingX = rotatingX + 0.1
					
					-- Prevent player from rotating way too much.
					if rotationTimes < 20 then
						SetCamCoord(cam, rotatingX, offSet.y, offSet.z)
					else
						scCore.Notification("Can't rotate anymore, press H to reset", "error")
					end
				end

				-- Reset camera (H)
				if IsControlJustReleased(0, 74) then
					rotationTimes = 0
					rotatingX = offSet.x
					
					SetCamCoord(cam, offSet.x, offSet.y, offSet.z)
				end
			end
		end)

		sellFurn = prop
		sellLabel = label

		unFurnishData.spawnedCams = spawnedCams

		Menu.addButton("Confirm", "ConfirmSellFurniture", unFurnishData)
		Menu.addButton("Cancel", "CancelSellFurniture", unFurnishData)
	else
		closeMenuFull()
		FreezeEntityPosition(PlayerPedId(), false)
		return scCore.Notification("Something went wrong!", "error")
	end

end

function ConfirmSellFurniture(unFurnishData)
	local sellFurn
	local sellLabel
	furni = unFurnishData.furni
	house = unFurnishData.house
	pos = unFurnishData.pos
	label = unFurnishData.label
	prop = unFurnishData.prop
	spawnedCams = unFurnishData.spawnedCams

	closeMenuFull()
	FreezeEntityPosition(PlayerPedId(), false)

	local testMod = GetHashKey(prop)
	sellLabel = label

	if (GetEntityModel(sellFurn) ~= testMod) or (sellLabel ~= label) then
		local offSet = GetOffsetFromEntityInWorldCoords(SpawnedHome[1], pos.x, pos.y, pos.z)
		local prop = GetClosestObjectOfType(offSet, 1.0, testMod, false, false, false)
		if prop == 0 then
			prop = GetClosestObjectOfType(offSet, 5.0, testMod, false, false, false)
		end
		offSet = GetOffsetFromEntityInWorldCoords(prop, 0.0, 1.0, 1.0)

		RenderScriptCams(false, false, 0, false, false)
		for i = 1,#spawnedCams do
			DestroyCam(spawnedCams[i], false)
		end

		sellFurn = prop
		sellLabel = label
	end

	for k,v in pairs(SpawnedHome) do
		if v == sellFurn then
			DeleteEntity(v)
			table.remove(SpawnedHome, k)
			local mLo = house.shell == 'mlo'

			TriggerServerEvent('lcrp-houses-new:removeFurniture', house.id, pos, prop, label, mLo)
		end
	end

	for k,v in ipairs(furni.inside) do
		if v.x == pos.x and v.y == pos.y and v.z == pos.z then
			table.remove(furni.inside, k)
		end
	end

	house.furniture = furni
	UnFurnishHome(house)
end

function CancelSellFurniture(unFurnishData)
	closeMenuFull()
	FreezeEntityPosition(PlayerPedId(), false)
	RenderScriptCams(false, false, 0, false, false)

	spawnedCams = unFurnishData.spawnedCams
	house = unFurnishData.house

	for i = 1,#spawnedCams do
		DestroyCam(spawnedCams[i], false)
	end
	UnFurnishHome(house)
end

IsHomeTouchingHome = function(x, y, z)
	local touching = false
	local pos = vector3(x, y, z)
  for k,v in pairs(spawnedHouseSpots) do
		local dis = #(pos - v.spot)
		if dis <= v.size then
			touching = true
		end
	end
	return touching
end

IsHomeTouchingWater = function(x, y, z, model)
	local minDim, maxDim = GetModelDimensions(model)
	if GetWaterHeight(x, y, z) then
		return true
	end
	for x2 = math.floor(x-minDim.x),math.floor(x+maxDim.x) do
		for y2 = math.floor(y-minDim.y),math.floor(y+maxDim.y) do
			for z2 = math.floor(z-minDim.z),math.floor(z+maxDim.z) do
				if GetWaterHeight(x2,y2,z2) then
					return true
				end
			end
		end
	end
	return false
end

RegisterNetEvent('lcrp-houses-new:getIsInHouse')
AddEventHandler('lcrp-houses-new:getIsInHouse', function(cb)
	cb(inHome)
end)

RegisterNetEvent('lcrp-houses-new:getCurrentHouse')
AddEventHandler('lcrp-houses-new:getCurrentHouse', function(cb)
	cb(CurrentActionData)
end)

RegisterNetEvent('lcrp-houses-new:spawnHome')
AddEventHandler('lcrp-houses-new:spawnHome', function(house, spawnType, givenPos, isRaid)
	if type(house) ~= 'table' then
		house = Houses[house]
	end
	
	local ped = PlayerPedId()
	local pos = (givenPos ~= nil and givenPos) or GetEntityCoords(ped)
	local model = house.shell
	if not HasModelLoaded(model) then
		ticks[model] = 0
		while not HasModelLoaded(model) do
			scCore.ShowHelpNotification('Requesting model, please wait')
			DisableAllControlActions(0)
			Citizen.Wait(10)
			RequestModel(model)
			ticks[model] = ticks[model] + 1
			if ticks[model] >= Config.ModelWaitTicks then
				ticks[model] = 0
				scCore.ShowHelpNotification('Model '..model..' failed to load, found in server image, please attempt re-logging to solve')
				return
			end
		end
	end
	if HasModelLoaded(model) then
		ped = PlayerPedId()
		local x, y, z, spot
		if givenPos == nil then
			x, y, z = pos.x, pos.y, pos.z - Config.Shells[house.shell].shellsize
			local tooClose = IsHomeTouchingHome(x, y, z)
			if tooClose then
				z = z - 10.0
			end
			local inWater = IsHomeTouchingWater(x, y, z, house.shell)
			if inWater then
				spot = GetSafeSpot()
			else
				spot = vector3(x, y, z)
			end
		else
			spot = vector3(pos.x, pos.y, pos.z)
		end
		local home = CreateObjectNoOffset(house.shell, spot, false, false, false)
		if DoesEntityExist(home) then
			ped = PlayerPedId()
			SetEntityHeading(home, 0.0)
			FreezeEntityPosition(home, true)
			SetEntityDynamic(home, false)
			TriggerServerEvent('lcrp-houses-new:regSpot', 'insert', spot, house.id, Config.Shells[house.shell].shellsize)
			if isRaid ~= nil and isRaid == 'false' then
				local keyOptions = Config.KeyOptions.CanDo
				table.insert(SpawnedHome, home)
				local furni = house.furniture
				if furni ~= nil then
					for k,v in pairs(furni.inside) do
						local spawnSpot = GetOffsetFromEntityInWorldCoords(home, v.x, v.y, v.z)
						local model = GetHashKey(v.prop)
						if v.prop == cryptoPCProp then
							drawCryptoMarker(spawnSpot)
						end
						if IsModelInCdimage(model) then
							if not HasModelLoaded(model) then
								ticks[model] = 0
								while not HasModelLoaded(model) do
									Citizen.Wait(10)
									RequestModel(model)
									ticks[model] = ticks[model] + 10
									if ticks[model] >= Config.ModelWaitTicks then
										ticks[model] = 0
										scCore.ShowHelpNotification('Model '..model..' failed to load, found in server image, please attempt re-logging to solve')
										return
									end
								end
							end
						end
						if HasModelLoaded(model) then
							local prop = CreateObjectNoOffset(model, spawnSpot, false, false, false)
							if v.heading ~= nil then
								SetEntityHeading(prop, v.heading)
							end
							FreezeEntityPosition(prop, true)
							table.insert(SpawnedHome, prop)
						end
					end
				end
				FrontDoor = vector3(house.door.x, house.door.y, house.door.z)
				if Config.BlinkOnRefresh then
					if not blinking then
						blinking = true
						if timeInd ~= 270 then
							timeInd = GetTimecycleModifierIndex()
							SetTimecycleModifier('Glasses_BlackOut')
						end
					end
				end
				scCore.Notification(Config.Strings.amEnter)
				local doorPos = GetOffsetFromEntityInWorldCoords(home, Config.Shells[house.shell].door)
				ped = PlayerPedId()
				SetEntityCoords(ped, doorPos.x, doorPos.y, doorPos.z + 1.0)
				Citizen.Wait(1000)
				FreezeEntityPosition(PlayerPedId(), true)
				while not HasCollisionLoadedAroundEntity(ped) do
					Citizen.Wait(1)
					SetEntityCoords(ped, doorPos.x, doorPos.y, doorPos.z + 1.0)
					DisableAllControlActions(0)
				end
				scCore.Notification(Config.Strings.amClose)
				Citizen.Wait(1000)
				if Config.BlinkOnRefresh then
					if timeInd ~= -1 then
						SetTimecycleModifier(Config.TimeCycleMods[tostring(timeInd)])
					else
						timeInd = -1
						ClearTimecycleModifier()
					end
					blinking = false
				end
				FreezeEntityPosition(PlayerPedId(), false)
				inHome = true
        		TriggerEvent('lcrp-houses-new:setPlayerInHome', inHome)
				TriggerServerEvent('lcrp-houses-new:playerEnteredExitedHome', house.id, true)
				while inHome do
					ped = PlayerPedId()
					Citizen.Wait(0)
					local pos = GetEntityCoords(ped)
					if Config.Weather.SetHouseWeather then
						SetHomeWeather()
					end
					local helth = GetEntityHealth(ped)
					local offset = GetEntityCoords(home)
					local dis = #(pos - offset)
					if (dis > Config.Shells[house.shell].shellsize or helth <= 100) and PlayerPedId() == ped then
						closeMenuFull()
						if Config.BlinkOnRefresh then
							if not blinking then
								blinking = true
								if timeInd ~= 270 then
									timeInd = GetTimecycleModifierIndex()
									SetTimecycleModifier('Glasses_BlackOut')
								end
							end
						end
						scCore.Notification(Config.Strings.amExitt)
						SetEntityCoords(ped, FrontDoor)
						FreezeEntityPosition(PlayerPedId(), true)
						while not HasCollisionLoadedAroundEntity(ped) do
							Citizen.Wait(1)
							SetEntityCoords(ped, FrontDoor)
							DisableAllControlActions(0)
						end
						scCore.Notification(Config.Strings.amClose)
						Citizen.Wait(1000)
						if Config.BlinkOnRefresh then
							if timeInd ~= -1 then
								SetTimecycleModifier(Config.TimeCycleMods[tostring(timeInd)])
							else
								timeInd = -1
								ClearTimecycleModifier()
							end
							blinking = false
						end
						FreezeEntityPosition(PlayerPedId(), false)
						for i = 1,#SpawnedHome do
							DeleteEntity(SpawnedHome[i])
						end
						TriggerServerEvent('lcrp-houses-new:regSpot', 'remove', pos, house.id)
						TriggerServerEvent('lcrp-houses-new:playerEnteredExitedHome', house.id, false)
						spawnedFurn = nil
						inHome = false
            			TriggerEvent('lcrp-houses-new:setPlayerInHome', inHome)
						FrontDoor = {}
						SpawnedHome = {}
					end
					local offset = GetOffsetFromEntityInWorldCoords(home, Config.Shells[house.shell].door)
					local dis = #(pos - offset)
					if Markers.ExitMarkers then
						DrawMarker(1, offset, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, false, 2, false, false, false, false)
					end
					if dis <= 5 and dis > 1.25  and not bypass then
						closeMenuFull()
						canLeave = false
					end
					if dis <= 1.25 then
						canLeave = true
					end
					
				end
			elseif givenPos ~= nil then
				local title = Config.Strings.nokAcpt
				if isRaid ~= nil then
					title = Config.Strings.conRaid
				end
				closeMenuFull()
				table.insert(SpawnedHome, home)
				local furni = house.furniture
				if furni ~= nil then
					for k,v in pairs(furni.inside) do
						local spawnSpot = GetOffsetFromEntityInWorldCoords(home, v.x, v.y, v.z)
						local model = GetHashKey(v.prop)
						if v.prop == cryptoPCProp then
							drawCryptoMarker(spawnSpot)
						end
						if IsModelInCdimage(model) then
							if not HasModelLoaded(model) then
								ticks[model] = 0
								while not HasModelLoaded(model) do
									Citizen.Wait(10)
									RequestModel(model)
									ticks[model] = ticks[model] + 10
									if ticks[model] >= Config.ModelWaitTicks then
										ticks[model] = 0
										scCore.ShowHelpNotification('Model '..model..' failed to load, found in server image, please attempt re-logging to solve')
										return
									end
								end
							end
						end
						if HasModelLoaded(model) then
							local prop = CreateObjectNoOffset(model, spawnSpot, false, false, false)
								if v.heading ~= nil then
									SetEntityHeading(prop, v.heading)
								end
									FreezeEntityPosition(prop, true)
									table.insert(SpawnedHome, prop)
								end
							end
						end
						FrontDoor = vector3(house.door.x, house.door.y, house.door.z)
						if Config.BlinkOnRefresh then
							if not blinking then
								blinking = true
								if timeInd ~= 270 then
									timeInd = GetTimecycleModifierIndex()
									SetTimecycleModifier('Glasses_BlackOut')
								end
							end
						end
						local doorPos = GetOffsetFromEntityInWorldCoords(home, Config.Shells[house.shell].door)
						scCore.Notification(Config.Strings.amEnter)
						ped = PlayerPedId()
						SetEntityCoords(ped, doorPos.x, doorPos.y, doorPos.z + 1.0)
						Citizen.Wait(1000)
						FreezeEntityPosition(PlayerPedId(), true)
						while not HasCollisionLoadedAroundEntity(ped) do
							Citizen.Wait(1)
							SetEntityCoords(ped, doorPos.x, doorPos.y, doorPos.z + 1.0)
							DisableAllControlActions(0)
						end
						scCore.Notification(Config.Strings.amClose)
						Citizen.Wait(1000)
						if Config.BlinkOnRefresh then
							if timeInd ~= -1 then
								SetTimecycleModifier(Config.TimeCycleMods[tostring(timeInd)])
							else
								timeInd = -1
								ClearTimecycleModifier()
							end
							blinking = false
						end
						FreezeEntityPosition(PlayerPedId(), false)
						inHome = true
						TriggerEvent('lcrp-houses-new:setPlayerInHome', inHome)
						TriggerServerEvent('lcrp-houses-new:playerEnteredExitedHome', house.id, true)
						while inHome do
							ped = PlayerPedId()
							Citizen.Wait(0)
							local pos = GetEntityCoords(ped)
							if Config.Weather.SetHouseWeather then
								SetHomeWeather()
							end
							local helth = GetEntityHealth(ped)
							local offset = GetEntityCoords(home)
							local dis = #(pos - offset)
							if (dis > Config.Shells[house.shell].shellsize or helth <= 100) and PlayerPedId() == ped then
								closeMenuFull()
								if Config.BlinkOnRefresh then
									if not blinking then
										blinking = true
										if timeInd ~= 270 then
											timeInd = GetTimecycleModifierIndex()
											SetTimecycleModifier('Glasses_BlackOut')
										end
									end
								end
								scCore.Notification(Config.Strings.amExitt)
								SetEntityCoords(ped, FrontDoor)
								FreezeEntityPosition(PlayerPedId(), true)
								while not HasCollisionLoadedAroundEntity(ped) do
									Citizen.Wait(1)
									SetEntityCoords(ped, FrontDoor)
									DisableAllControlActions(0)
								end
								scCore.Notification(Config.Strings.amClose)
								Citizen.Wait(1000)
								if Config.BlinkOnRefresh then
									if timeInd ~= -1 then
										SetTimecycleModifier(Config.TimeCycleMods[tostring(timeInd)])
									else
										timeInd = -1
										ClearTimecycleModifier()
									end
									blinking = false
								end
								FreezeEntityPosition(PlayerPedId(), false)
								for i = 1,#SpawnedHome do
									DeleteEntity(SpawnedHome[i])
								end
								TriggerServerEvent('lcrp-houses-new:regSpot', 'remove', pos, house.id)
								TriggerServerEvent('lcrp-houses-new:playerEnteredExitedHome', house.id, false)
								spawnedFurn = nil
								inHome = false
								TriggerEvent('lcrp-houses-new:setPlayerInHome', inHome)
								FrontDoor = {}
								SpawnedHome = {}
							end
							local offset = GetOffsetFromEntityInWorldCoords(home, Config.Shells[house.shell].door)
							local dis = #(pos - offset)
							if Markers.ExitMarkers then
								DrawMarker(1, offset, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, false, 2, false, false, false, false)
							end
							if dis <= 5 and dis > 1.25  and not bypass then
								closeMenuFull()
								canLeave = false
							end
							if dis <= 1.25 then
								canLeave = true
							end
							
						end
			else
				ped = PlayerPedId()
				pos = GetEntityCoords(ped)
				currentHouseID = house.id
				inHome = true
				TriggerEvent('lcrp-houses-new:setPlayerInHome', inHome)
				FrontDoor = vector3(house.door.x, house.door.y, house.door.z)
				table.insert(SpawnedHome, home)
				local furni = house.furniture
				if furni ~= nil then
					for k,v in pairs(furni.inside) do
						local spawnSpot = GetOffsetFromEntityInWorldCoords(home, v.x, v.y, v.z)
						local model = GetHashKey(v.prop)
						if v.prop == cryptoPCProp then
							drawCryptoMarker(spawnSpot)
						end
						if IsModelInCdimage(model) then
							if not HasModelLoaded(model) then
								ticks[model] = 0
								while not HasModelLoaded(model) do
									Citizen.Wait(10)
									RequestModel(model)
									ticks[model] = ticks[model] + 10
									if ticks[model] >= Config.ModelWaitTicks then
										ticks[model] = 0
										scCore.ShowHelpNotification('Model '..model..' failed to load, found in server image, please attempt re-logging to solve')
										return
									end
								end
							end
						end

						if HasModelLoaded(model) then
							local prop = CreateObjectNoOffset(model, spawnSpot, false, false, false)
							if v.heading ~= nil then
								SetEntityHeading(prop, v.heading)
							end
							FreezeEntityPosition(prop, true)
							table.insert(SpawnedHome, prop)
						end
					end
				else
					print('The house furniture table did not exist?')
				end
				if Config.BlinkOnRefresh then
					if not blinking then
						blinking = true
						if timeInd ~= 270 then
							timeInd = GetTimecycleModifierIndex()
							SetTimecycleModifier('Glasses_BlackOut')
						end
					end
				end
				scCore.Notification(Config.Strings.amEnter)
				local offset = GetOffsetFromEntityInWorldCoords(home, Config.Shells[house.shell].door)
				ped = PlayerPedId()
				SetEntityCoords(ped, offset.x, offset.y, offset.z + 1.0)
				TaskTurnPedToFaceEntity(ped, home, 1000)
				Citizen.Wait(1000)
				FreezeEntityPosition(PlayerPedId(), true)
				while not HasCollisionLoadedAroundEntity(ped) do
					Citizen.Wait(1)
					SetEntityCoords(ped, offset.x, offset.y, offset.z + 1.0)
					DisableAllControlActions(0)
				end
				scCore.Notification(Config.Strings.amClose)
				Citizen.Wait(1000)
				if Config.BlinkOnRefresh then
					if timeInd ~= -1 then
						SetTimecycleModifier(Config.TimeCycleMods[tostring(timeInd)])
					else
						timeInd = -1
						ClearTimecycleModifier()
					end
					blinking = false
				end
				FreezeEntityPosition(PlayerPedId(), false)
				inHome = true
        		TriggerEvent('lcrp-houses-new:setPlayerInHome', inHome)
				TriggerServerEvent('lcrp-houses-new:playerEnteredExitedHome', house.id, true)
				while inHome do
					ped = PlayerPedId()
					Citizen.Wait(5)
					pos = GetEntityCoords(ped)
					if Config.Weather.SetHouseWeather then
						SetHomeWeather()
					end
					local helth = GetEntityHealth(ped)
					local offset = GetEntityCoords(home)
					local dis = #(pos - offset)
					if (dis > Config.Shells[house.shell].shellsize or helth <= 100) and PlayerPedId() == ped then
						closeMenuFull()
						if Config.BlinkOnRefresh then
							if not blinking then
								blinking = true
								if timeInd ~= 270 then
									timeInd = GetTimecycleModifierIndex()
									SetTimecycleModifier('Glasses_BlackOut')
								end
							end
						end
						scCore.Notification(Config.Strings.amExitt)
						SetEntityCoords(ped, FrontDoor)
						FreezeEntityPosition(PlayerPedId(), true)
						while not HasCollisionLoadedAroundEntity(ped) do
							Citizen.Wait(1)
							SetEntityCoords(ped, FrontDoor)
							DisableAllControlActions(0)
						end
						scCore.Notification(Config.Strings.amClose)
						Citizen.Wait(1000)
						if Config.BlinkOnRefresh then
							if timeInd ~= -1 then
								SetTimecycleModifier(Config.TimeCycleMods[tostring(timeInd)])
							else
								timeInd = -1
								ClearTimecycleModifier()
							end
							blinking = false
						end
						FreezeEntityPosition(PlayerPedId(), false)
						for i = 1,#SpawnedHome do
							DeleteEntity(SpawnedHome[i])
						end
						TriggerServerEvent('lcrp-houses-new:regSpot', 'remove', pos, house.id)
						TriggerServerEvent('lcrp-houses-new:playerEnteredExitedHome', house.id, false)
						spawnedFurn = nil
						inHome = false
            			TriggerEvent('lcrp-houses-new:setPlayerInHome', inHome)
						FrontDoor = {}
						SpawnedHome = {}
					end
					offset = GetOffsetFromEntityInWorldCoords(home, Config.Shells[house.shell].door)
					dis = #(pos - offset)
					if Markers.ExitMarkers then
						DrawMarker(1, offset, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, false, 2, false, false, false, false)
					end
					if dis <= 5 and dis > 1.25  and not bypass then
						closeMenuFull()
						canLeave = false
					end
					if dis <= 1.25 then
						canLeave = true
					end
					
				end
			end
		else
			scCore.Notification(Config.Strings.wntRong)
		end
	end
end)

RegisterNetEvent('lcrp-houses-new:doorKnock')
AddEventHandler('lcrp-houses-new:doorKnock', function(knocker)
	if knocker ~= nil then
		if inHome then
			scCore.Notification(Config.Strings.dorKnok)
		else
			TriggerServerEvent('lcrp-houses-new:knockFail', knocker)
		end
	else
		scCore.Notification(Config.Strings.notHome)
	end
end)

--[[ RegisterNetEvent('lcrp-houses-new:updateHomes')
AddEventHandler('lcrp-houses-new:updateHomes', function(houses, address, delete)
	while scCore == nil do Citizen.Wait(10) end
	if address == nil then
		if Config.BlinkOnRefresh then
			if not blinking then
				blinking = true
				if timeInd ~= 270 then
					scCore.Notification(Config.Strings.amBlink)
					timeInd = GetTimecycleModifierIndex()
					SetTimecycleModifier('Glasses_BlackOut')
				end
			end
		end
		for i = 1,#scriptBlips do
			RemoveBlip(scriptBlips[i])
		end
		Houses = {}
		for k,v in pairs(houses) do
			local door = json.decode(v.door)
			local storage = json.decode(v.storage)
			local wardrobe = json.decode(v.wardrobe)
			v.door = vector3(door.x, door.y, door.z)
			v.storage = vector3(storage.x, storage.y, storage.z)
			v.wardrobe = vector3(wardrobe.x, wardrobe.y, wardrobe.z)
			v.doors = json.decode(v.doors)
			v.garages = json.decode(v.garages)
			v.furniture = json.decode(v.furniture)
			v.parkings = json.decode(v.parkings)
			v.keys = json.decode(v.keys)
			Houses[v.id] = v
		end
		for k,v in pairs(Houses) do
			if PlayerData.citizenid == v.owner then
				local blips = Blips.OwnedHome
				if blips.Use then
					local blip = AddBlipForCoord(v.door)
					SetBlipScale  (blip, 1.0)
					SetBlipAsShortRange(blip, true)
					SetBlipSprite (blip, blips.Sprite)
					SetBlipColour (blip, blips.Color)
					SetBlipScale  (blip, blips.Scale)
					SetBlipDisplay(blip, blips.Display)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(blips.Text:gsub('useaddress', k))
					EndTextCommandSetBlipName(blip)
					table.insert(scriptBlips, blip)
				end
			end
			if v.furniture then
				for g,f in pairs(v.furniture.outside) do
					table.insert(persFurn, {model = f.prop, pos = vector3(f.x, f.y, f.z), head = f.heading})
				end
			end
		end
		Citizen.Wait(500)
		if Config.BlinkOnRefresh then
			if timeInd ~= -1 then
				SetTimecycleModifier(Config.TimeCycleMods[tostring(timeInd)])
			else
				timeInd = -1
				ClearTimecycleModifier()
			end
			blinking = false
		end
	else
		if Config.BlinkOnRefresh then
			if not blinking then
				blinking = true
				if timeInd ~= 270 then
					scCore.Notification(Config.Strings.amBlink)
					timeInd = GetTimecycleModifierIndex()
					SetTimecycleModifier('Glasses_BlackOut')
				end
			end
		end
		for i = 1,#scriptBlips do
			RemoveBlip(scriptBlips[i])
		end
		local door = json.decode(houses.door)
		local storage = json.decode(houses.storage)
		local wardrobe = json.decode(houses.wardrobe)
		houses.door = vector3(door.x, door.y, door.z)
		houses.storage = vector3(storage.x, storage.y, storage.z)
		houses.wardrobe = vector3(wardrobe.x, wardrobe.y, wardrobe.z)
		houses.doors = json.decode(houses.doors)
		houses.garages = json.decode(houses.garages)
		houses.furniture = json.decode(houses.furniture)
		houses.parkings = json.decode(houses.parkings)
		houses.keys = json.decode(houses.keys)
		Houses[address] = houses
		for k,v in pairs(Houses) do
			if PlayerData.citizenid == v.owner then
				local blips = Blips.OwnedHome
				if blips.Use then
					local blip = AddBlipForCoord(v.door)
					SetBlipScale  (blip, 1.0)
					SetBlipAsShortRange(blip, true)
					SetBlipSprite (blip, blips.Sprite)
					SetBlipColour (blip, blips.Color)
					SetBlipScale  (blip, blips.Scale)
					SetBlipDisplay(blip, blips.Display)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(blips.Text:gsub('useaddress', k))
					EndTextCommandSetBlipName(blip)
					table.insert(scriptBlips, blip)
				end
			end
			if v.furniture then
				for g,f in pairs(v.furniture.outside) do
					table.insert(persFurn, {model = f.prop, pos = vector3(f.x, f.y, f.z), head = f.heading})
				end
			end
		end
		Citizen.Wait(500)
		if Config.BlinkOnRefresh then
			if timeInd ~= -1 then
				SetTimecycleModifier(Config.TimeCycleMods[tostring(timeInd)])
			else
				timeInd = -1
				ClearTimecycleModifier()
			end
			blinking = false
		end
	end
end) ]]

RegisterNetEvent('lcrp-houses:client:setLocation')
AddEventHandler('lcrp-houses:client:setLocation', function(data)
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local coords = {x = pos.x, y = pos.y, z = pos.z}
	local isMlo = nil

	if currentHouse ~= nil then
		if currentHouse.shell then
			local doorPos = currentHouse.door
			local distance = GetDistanceBetweenCoords(doorPos, pos.x, pos.y, pos.z, false)
			local draw = currentHouse.draw * 1.0
			if currentHouse.shell == "MLO" then
				if distance < draw then
					isMlo = currentHouse
				else
					return scCore.Notification("You are too far away from your house, increase your land size!", "error")
				end
			end
		end
	end
    if data == 'setstash' then
        TriggerServerEvent('lcrp-houses:server:setLocation', coords, 1, isMlo)
    elseif data == 'setoutift' then
        TriggerServerEvent('lcrp-houses:server:setLocation', coords, 2, isMlo)
    end
end)


RegisterNetEvent('lcrp-houses:client:refreshHouse')
AddEventHandler('lcrp-houses:client:refreshHouse', function(houseLabel)
	local plyData = scCore.Functions.GetPlayerData()
	if plyData ~= nil then
		if plyData.metadata["inside"].house ~= nil then
			if plyData.metadata["inside"].house.id == houseLabel then
				exitHouse(Houses[houseLabel])
				enterHouse(Houses[houseLabel])
			end
		end
	end
end)

RegisterNetEvent("lcrp-houses-new:refreshVehicles")
AddEventHandler("lcrp-houses-new:refreshVehicles", function(vehicles)
	while scCore == nil do Citizen.Wait(10) end
	for k,v in pairs(ParkedCars) do
		Citizen.CreateThread(function()
			while not IsSpawnPointClear(v.pos, 1.0) do
				Citizen.Wait(5)
				local veh = scCore.Functions.GetClosestVehicle(v.pos)
				if DoesEntityExist(veh) then
					if string.match(GetVehicleNumberPlateText(veh), v.props.plate) then
						DeleteEntity(veh)
					end
				end
			end
		end)
	end
	ParkedCars = {}
	for k,v in ipairs(vehicles) do
		ParkedCars[v.plate] = v.vehicle
		ParkedCars[v.plate].pos = vector3(v.vehicle.location.x, v.vehicle.location.y, v.vehicle.location.z)
	end
	if Config.BlinkOnRefresh then
		if timeInd ~= -1 then
			SetTimecycleModifier(Config.TimeCycleMods[tostring(timeInd)])
		else
			timeInd = -1
			ClearTimecycleModifier()
		end
		blinking = false
	end
end)

function IsSpawnPointClear(pos, maxDistance)
	local vehicles = {}
	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end
	return #EnumerateEntitiesWithinDistance(vehicles, false, pos, maxDistance) == 0
end

function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
	local nearbyEntities = {}

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	for k,entity in pairs(entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if distance <= maxDistance then
			table.insert(nearbyEntities, isPlayerEntities and k or entity)
		end
	end

	return nearbyEntities
end

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
		local next = true

		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

RegisterNetEvent('lcrp-houses-new:driveCar')
AddEventHandler('lcrp-houses-new:driveCar', function(vehicle)
	Citizen.Wait(100)
	while not HasModelLoaded(vehicle.props.model) do
		Citizen.Wait(10)
		RequestModel(vehicle.props.model)
	end
	ClearAreaOfEverything(vehicle.location.x, vehicle.location.y, vehicle.location.z, 1.0, false, false, false, false)
  	Citizen.Wait(50)
	local spawnedCar = CreateVehicle(vehicle.props.model, vehicle.location.x, vehicle.location.y, vehicle.location.z, vehicle.location.h, true, true)
	while not DoesEntityExist(spawnedCar) do 
		Citizen.Wait(10)
	end
	scCore.Functions.SetVehicleProperties(spawnedCar, vehicle.props)
	SetVehicleOnGroundProperly(spawnedCar)
	SetEntityAsMissionEntity(spawnedCar, true, true)
	SetModelAsNoLongerNeeded(vehicle.props.model)
	SetVehicleLivery(spawnedCar, vehicle.livery)
	SetVehicleEngineHealth(spawnedCar, vehicle.damages.eng)
	SetVehicleOilLevel(spawnedCar, vehicle.damages.oil)
	SetVehicleBodyHealth(spawnedCar, vehicle.damages.bod)
	SetVehicleDoorsLocked(spawnedCar, vehicle.damages.lok)
	SetVehiclePetrolTankHealth(spawnedCar, vehicle.damages.tnk)
	for k,v in pairs(vehicle.damages.dor) do
		if vehicle.damages.dor[k] then
			SetVehicleDoorBroken(spawnedCar, tonumber(k), true)
		end
	end
	for k,v in pairs(vehicle.damages.win) do
		if vehicle.damages.win[k] then
			SmashVehicleWindow(spawnedCar, tonumber(k))
		end
	end
	for k,v in pairs(vehicle.damages.tyr) do
		if vehicle.damages.tyr[k] == 'popped' then
			SetVehicleTyreBurst(spawnedCar, tonumber(k), false, 850.0)
		elseif vehicle.damages.tyr[k] == 'gone' then
			SetVehicleTyreBurst(spawnedCar, tonumber(k), true, 1000.0)
		end
	end
	while not HasCollisionLoadedAroundEntity(spawnedCar) do
		Citizen.Wait(10)
	end
	SetVehicleOnGroundProperly(spawnedCar)
	TaskWarpPedIntoVehicle(PlayerPedId(), spawnedCar, -1)
  Citizen.CreateThread(function()
    local waits = 0
    while true do
      Citizen.Wait(0)
      if waits == 1000 then break end
      waits = waits + 1
    end
  end)
end)

AddEventHandler('lcrp-houses-new:hasEnteredMarker', function(house)
	CurrentAction = 'front_door'
	CurrentActionData = house
	currentHouse = house
end)

AddEventHandler('lcrp-houses-new:hasExitedMarker', function()
	CurrentAction = nil
	CurrentActionData = {}
end)
	
AddEventHandler('onResourceStop', function(resource)
	local ped = PlayerPedId()
	if resource == GetCurrentResourceName() then
		closeMenuFull()
		if atShop then
			local ped = PlayerPedId()
			for k,v in pairs(spawnedProps) do
				DeleteEntity(v)
			end
			if inShop then
				SetEntityCoords(ped, Config.Furnishing.Store.enter)
				SetEntityHeading(ped, Config.Furnishing.Store.exthead)
			end
		end
		for k,v in pairs(persFurn) do
			DeleteEntity(v.entity)
		end
		if inHome then
			if Config.BlinkOnRefresh then
				if not blinking then
					blinking = true
					if timeInd ~= 270 then
						timeInd = GetTimecycleModifierIndex()
						SetTimecycleModifier('Glasses_BlackOut')
					end
				end
			end
			SetEntityCoords(ped, FrontDoor)
			FreezeEntityPosition(PlayerPedId(), true)
			while not HasCollisionLoadedAroundEntity(ped) do
				Citizen.Wait(1)
			end
			FreezeEntityPosition(PlayerPedId(), false)
			if Config.BlinkOnRefresh then
				if timeInd ~= -1 then
					SetTimecycleModifier(Config.TimeCycleMods[tostring(timeInd)])
				else
					timeInd = -1
					ClearTimecycleModifier()
				end
				blinking = false
			end
			for i = 1,#SpawnedHome do
				DeleteEntity(SpawnedHome[i])
			end
			SpawnedHome = {}
		end
	end
end)

function SelectedShell(selectedShell)
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	closeMenuFull()
	address = selectedShell.address
	shell = selectedShell.shell
	rank = selectedShell.rank
	local housePrice = scCore.KeyboardInput("Enter house price ", "", 10)
	housePrice = tonumber(housePrice)

	if housePrice ~= nil then
		local landSize = scCore.KeyboardInput(Config.Strings.lndSize, "", 10)
		landSize = tonumber(landSize)
		draw = landSize * 1.0
		drawRange = 0
		
		if landSize ~= nil then
			local garageType = scCore.KeyboardInput("Type 2 to setup the garage", "", 10)
			garageType = tonumber(garageType)

			if garageType == 1 or garageType == 2 then
				TriggerServerEvent('lcrp-houses-new:createHouse', address, doRound(pos.x, 2), doRound(pos.y, 2), doRound(pos.z, 2) - 1.0, shell, housePrice, draw, garageType, rank)
			else
				scCore.Notification("Garage type is invalid, has to be either 1 or 2!", "error")
				return
			end
		else
			scCore.Notification("Land Size is invalid!", "error")
			return
		end
	else
		scCore.Notification("House price is invalid!", "error")
		return
	end
end


RegisterNetEvent("lcrp-houses:client:CreateHouse")
AddEventHandler("lcrp-houses:client:CreateHouse", function(raw, args)
	local shell = Config.Defaults.Shell
	local price = Config.Defaults.Price
	local draw = Config.Defaults.Draw

	closeMenuFull()

	-- Needs house id generate

	if PlayerJob.name == "realestate" and PlayerJob.grade >= 3 then
		local pos = GetEntityCoords(PlayerPedId())
		for k, v in pairs(Houses) do
			local dis = #(pos - v.door)
			if dis ~= nil and v.draw ~= nil then
				if dis <= v.draw then
					scCore.Notification("You are in someone\'s territory therefore can\'t create an house here. Use /checkTerritory command.", "error")
					return
				end
			end
		end
		local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)
		local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
		local address = GetStreetNameFromHashKey(s1)
		local street2 = GetStreetNameFromHashKey(s2)
		if street2 ~= nil and street2 ~= "" then 
			address = address .. " " .. street2
		end
				
		Menu.hidden = not Menu.hidden
		renderGUI2 = true
		bypass = true
		if address == nil or address == '' then
			scCore.Notification(Config.Strings.noAddrs)
			address = CreateRandomAddress()
		end

		Menu.addButton(Config.Strings.chsShll, "title", nil)
		if string.len(address) > 55 then
			scCore.Notification(Config.Strings.add2Sht:format(string.len(address)))
		else
			SelectedmloData = {}
			SelectedmloData.shell = "mlo"
			SelectedmloData.address = address
			Menu.addButton("MLO", "SelectedShell", SelectedmloData)
			for k,v in spairs(Config.Shells, function(t,a,b) return t[b].rank < t[a].rank end) do
				SelectedData = {}
				SelectedData.shell = k
				SelectedData.address = address
				SelectedData.rank = v.rank
				Menu.addButton(k, "SelectedShell", SelectedData)
			end
		end

		Menu.addButton("Close Menu", "closeMenuFull", nil) 

		while renderGUI2 do
			Wait(5)
			local playerLoc = GetEntityCoords(ped)
			local distance = GetDistanceBetweenCoords(pos, playerLoc.x, playerLoc.y, playerLoc.z, false)
	
			Menu.renderGUI()
		end
	else
		scCore.Notification(Config.Strings.noPerms)
	end
end)

RegisterCommand("checkTerritory", function()
	if PlayerJob.name == "realestate" and PlayerJob.grade >= 3 then
		checkTerritory = not checkTerritory
	end
end)

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

RegisterNetEvent("lcrp-houses:client:SetWardrobe")
AddEventHandler("lcrp-houses:client:SetWardrobe", function()
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	local dis = 1000

	ClearMenu()
	Menu.hidden = not Menu.hidden

	Menu.addButton(Config.Strings.clstAdd, "title", nil)

	for k,v in pairs(Houses) do
		if SpawnedHome[1] == nil then
			dis = #(pos - v.door)
			if dis <= v.draw then
				wardrobeData = {}
				wardrobeData.k = k
				wardrobeData.pos = {x = v.door.x, y = v.door.y, z = v.door.z}
				wardrobeData.draw = v.draw
				Menu.addButton(k, "SetWardrobe", wardrobeData) 
			end
		end
		if SpawnedHome[1] ~= nil then
			if v.id == currentHouseID then
				wardrobeData = {}
				wardrobeData.k = k
				wardrobeData.pos = {x = v.door.x, y = v.door.y, z = v.door.z}
				wardrobeData.draw = v.draw
				Menu.addButton(k, "SetWardrobe", wardrobeData) 
			end
		end
	end
	Menu.renderGUI()
end)

function SetWardrobe(wardrobeData)
	pos = GetEntityCoords(ped)
	vec = vector3(wardrobeData.pos.x, wardrobeData.pos.y, wardrobeData.pos.z)
	dis = #(pos - vec)

	if SpawnedHome[1] == nil and dis > wardrobeData.draw then
		scCore.Notification(Config.Strings.uTooFar)
	else
		if SpawnedHome[1] ~= nil then
			local home = SpawnedHome[1]
			local offset = GetOffsetFromEntityGivenWorldCoords(home, pos)
			pos = vector3(offset.x, offset.y, offset.z)
			TriggerServerEvent('lcrp-houses-new:setHomeStorage', wardrobeData.k, doRound(pos.x, 2), doRound(pos.y, 2), doRound(pos.z, 2) - 1.0)
		else
			TriggerServerEvent('lcrp-houses-new:setHomeStorage', wardrobeData.k, doRound(pos.x, 2), doRound(pos.y, 2), doRound(pos.z, 2) - 1.0)
		end
	end
end

RegisterNetEvent("lcrp-houses:client:ChangeRange")
AddEventHandler("lcrp-houses:client:ChangeRange", function()
	local landSize = scCore.KeyboardInput(Config.Strings.lndSize, "", 10)
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	landSize = tonumber(landSize)
	if landSize ~= nil then
		draw = landSize * 1.0
		for k,v in pairs(Houses) do
			dis = #(pos - v.door)
			if dis <= v.draw then
				closestHouse = k
			end
		end
		TriggerServerEvent('lcrp-houses-new:updateLandSize', closestHouse, draw)
	else
		scCore.Notification("Land Size is invalid!", "error")
		return
	end
end)

RegisterNetEvent("lcrp-houses:client:AddParking")
AddEventHandler("lcrp-houses:client:AddParking", function()
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	local dis = 1000

	closeMenuFull()
	Menu.hidden = not Menu.hidden
	renderGUI2 = true
	bypass = true
	Menu.addButton(Config.Strings.clstAdd, "title", nil)
	for k,v in pairs(Houses) do
		dis = #(pos - v.door)
		if pos == nil or v.door == nil or v.draw == nil then 
			print(pos)
			print(v.door)
			print(v.draw)
		end
		if dis <= v.draw then
			addParkingData = {}
			addParkingData.k = k
			addParkingData.pos = {x = v.door.x, y = v.door.y, z = v.door.z}
			addParkingData.draw = v.draw
			addParkingData.type = v.garageType
			Menu.addButton(k, "SelectedParkingAddress", addParkingData) 
		end
	end

	Menu.addButton("Close Menu", "closeMenuFull", nil) 

	while renderGUI2 do
		Wait(5)
		local playerLoc = GetEntityCoords(ped)
		local distance = GetDistanceBetweenCoords(pos, playerLoc.x, playerLoc.y, playerLoc.z, false)
		Menu.renderGUI()
	end
end)

function SelectedParkingAddress(addParkingData)
	ped = PlayerPedId()
	pos = GetEntityCoords(ped)
	heading = GetEntityHeading(GetPlayerPed(-1))
	vec = vector3(addParkingData.pos.x, addParkingData.pos.y, addParkingData.pos.z)
	dis = #(pos - vec)
	coords = {
		x = pos.x,
		y = pos.y,
		z = pos.z,
		h = heading,
	}
	if dis > addParkingData.draw then
		scCore.Notification(Config.Strings.uTooFar)
	else
		if Config.Parking.ScriptParking then
			local tooClose = IsParkingTooClose(pos)
			if not tooClose then
				closeMenuFull()
				if addParkingData.type == 1 then
					TriggerServerEvent('lcrp-houses-new:createParking', addParkingData.k, coords.x, coords.y, coords.z)
				else
					TriggerServerEvent('lcrp-houses:server:addGarage', addParkingData.k, coords)
				end
			else
				scCore.Notification(Config.Strings.prk2Cls)
			end
		end
	end
end

RegisterNetEvent("lcrp-houses:client:DeleteHouse")
AddEventHandler("lcrp-houses:client:DeleteHouse", function()
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	local dis = 1000

	ClearMenu()
	Menu.hidden = not Menu.hidden
	renderGUI2 = true
	bypass = true
	Menu.addButton(Config.Strings.clstAdd, "title", nil)

	for k,v in pairs(Houses) do
		dis = #(pos - v.door)
		if dis <= v.draw then
			Menu.addButton(k, "DeleteHouse", k) 
		end
	end

	Menu.addButton("Close Menu", "closeMenuFull", nil) 

	while renderGUI2 do
		Wait(5)
		local playerLoc = GetEntityCoords(ped)
		local distance = GetDistanceBetweenCoords(pos, playerLoc.x, playerLoc.y, playerLoc.z, false)

		Menu.renderGUI()
	end
end)

function DeleteHouse(DeleteHouseData)
	areYouSure = scCore.KeyboardInput("Are you sure? Type: yes / no", "", 5)
	if areYouSure ~= nil then
		if areYouSure == "yes" or areYouSure == "y" then
			closeMenuFull()
			TriggerServerEvent('lcrp-houses-new:deleteHome', DeleteHouseData)
		else
			scCore.Notification("Cancelled!", "error")
			closeMenuFull()
		end
	end
end

RegisterNetEvent("lcrp-houses:client:DeleteParking")
AddEventHandler("lcrp-houses:client:DeleteParking", function()
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	local house
	local parkingSpot

	for k,v in pairs(Houses) do
		for i = 1,#v.parkings do
			local vec = vector3(v.parkings[i].x, v.parkings[i].y, v.parkings[i].z)
			local dis = #(vec - pos)
			if dis <= 2.5 then
				house = v.id
				parkingSpot = vec
			end
		end
	end

	closeMenuFull()

	if house ~= nil then
		TriggerServerEvent('lcrp-houses-new:deleteParking', house, parkingSpot.x, parkingSpot.y, parkingSpot.z)
	else
		scCore.Notification("House not found!", "error")
	end
end)

RegisterNetEvent("lcrp-houses:client:DeleteDoor")
AddEventHandler("lcrp-houses:client:DeleteDoor", function()
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	local dis = 1000

	closeMenuFull()

	for k,v in pairs(Houses) do
		dis = #(pos - v.door)
		if dis <= v.draw then
			removeDoorData = {}
			removeDoorData.k = k
			removeDoorData.pos = {x = v.door.x, y = v.door.y, z = v.door.z}
		end
	end

	pos = GetEntityCoords(ped)
	vec = vector3(removeDoorData.pos.x, removeDoorData.pos.y, removeDoorData.pos.z)
	dis = #(pos - vec)
	local door, doorDis

	door, doorDis = GetClosestObject(nil, pos)

	if doorDis > 1.0 then
		scCore.Notification(Config.Strings.getClsr, "error")
	elseif doorDis < 0.5 then
		scCore.Notification('Too close, may touch door, no no square zone', "error")
	else
		if DoesEntityExist(door) then
			local doorPos, propHash = GetEntityCoords(door), GetEntityModel(door)
			TriggerServerEvent('lcrp-houses-new:removeDoorFromHome', removeDoorData.k, doorPos.x, doorPos.y, doorPos.z, propHash)
		else
			scCore.Notification(Config.Strings.dorNtFd, "error")
		end
	end
end)

RegisterNetEvent("lcrp-houses:client:AddDoor")
AddEventHandler("lcrp-houses:client:AddDoor", function()
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	local dis = 1000

	if PlayerJob.name == "realestate" and PlayerJob.grade >= 3 then
		closeMenuFull()

		for k,v in pairs(Houses) do
			dis = #(pos - v.door)
			if dis <= v.draw then
				addDoorData = {}
				addDoorData.k = k
				addDoorData.pos = {x = v.door.x, y = v.door.y, z = v.door.z}
				addDoorData.draw = v.draw
			end
		end

		pos = GetEntityCoords(ped)
		vec = vector3(addDoorData.pos.x, addDoorData.pos.y, addDoorData.pos.z)
		dis = #(pos - vec)
		local door, doorDis

		door, doorDis = GetClosestObject(nil, pos)

		if doorDis > 1.0 then
			scCore.Notification(Config.Strings.getClsr, "error")
		elseif doorDis < 0.5 then
			scCore.Notification('Too close, may touch door, no no square zone', "error")
		else
			if DoesEntityExist(door) then
				local velo = GetEntityVelocity(door)
				if velo.x == 0.0 and velo.y == 0.0 and velo.z == 0.0 then
					local doorPos, rotation, propHash = GetEntityCoords(door), GetEntityHeading(door), GetEntityModel(door)
					TriggerServerEvent('lcrp-houses-new:addDoorToHome', addDoorData.k, doorPos.x, doorPos.y, doorPos.z, rotation, propHash)
				else
					scCore.Notification('The door must stop swingin itself before adding', "error")
				end
			else
				scCore.Notification(Config.Strings.dorNtFd, "error")
			end
		end
	else
		scCore.Notification("You have no permission!", "error")
	end
end)

RegisterNetEvent("lcrp-houses:client:AddGarage")
AddEventHandler("lcrp-houses:client:AddGarage", function()
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	local dis = 1000

	closeMenuFull()

	Menu.hidden = not Menu.hidden
	renderGUI2 = true
	bypass = true
	Menu.addButton("Add Garage", "title", nil)

	for k,v in pairs(Houses) do
		dis = #(pos - v.door)
		if dis <= v.draw then
			addGarageData = {}
			addGarageData.k = k
			addGarageData.pos = {x = v.door.x, y = v.door.y, z = v.door.z}
			addGarageData.draw = v.draw
			Menu.addButton(k, "GarageLandSize", addGarageData)
		end
	end

	Menu.addButton("Close Menu", "closeMenuFull", nil)

	while renderGUI2 do
		Wait(5)
		local playerLoc = GetEntityCoords(ped)
		local distance = GetDistanceBetweenCoords(pos, playerLoc.x, playerLoc.y, playerLoc.z, false)

		Menu.renderGUI()
	end
end)

function GarageLandSize(addGarageData)
	ClearMenu()
	local ped = PlayerPedId()

	Menu.addButton(Config.Strings.clstAdd, "title", nil)

	pos = GetEntityCoords(ped)
	vec = vector3(addGarageData.pos.x, addGarageData.pos.y, addGarageData.pos.z)
	dis = #(pos - vec)
	if dis > addGarageData.draw then
		scCore.Notification(Config.Strings.uTooFar, "error")
		return closeMenuFull()
	else
		local door, doorDis
		door, doorDis = GetClosestObject(nil, pos)

		if doorDis > 2.5 then
			scCore.Notification(Config.Strings.getClsr)
			return closeMenuFull()
		else
			if DoesEntityExist(door) then
				local doorPos, rotation, propHash, draw = GetEntityCoords(door), GetEntityHeading(door), GetEntityModel(door)

				for i = 1,#Config.LandSize do
					addGarageData.doorPos = doorPos
					addGarageData.propHash = propHash
					Menu.addButton(Config.LandSize[i], "addGarageToHouse", {Config.LandSize[i] ,addGarageData})
				end

				-- drawRange = 5
				-- Citizen.CreateThread(function()
				-- 	while drawRange > 0 do
				-- 		Citizen.Wait(5)
				-- 		DrawMarker(2, GetOffsetFromEntityInWorldCoords(ped, 0.0, (drawRange * 1.0), 0.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 3.0, 255, 0, 0, 255, true, true, 2, 0, 0, 0, 0)
				-- 	end
				-- end)
			else
				closeMenuFull()
				return scCore.Notification(Config.Strings.dorNtFd, "error")
			end
		end
	end

	Menu.addButton("Close Menu", "closeMenuFull", nil)
end

function addGarageToHouse(addGarageData)
	closeMenuFull()
	draw = addGarageData[1] * 1.0
	addGarageData = addGarageData[2]
	--drawRange = 0
	TriggerServerEvent('lcrp-houses-new:addGarageToHome', addGarageData.k, addGarageData.doorPos.x, addGarageData.doorPos.y, addGarageData.doorPos.z, addGarageData.propHash, draw)
end

RegisterNetEvent("lcrp-houses:client:TestShell")
AddEventHandler("lcrp-houses:client:TestShell", function(args)
	scCore.TriggerServerCallback('lcrp-scoreboard:server:CheckPermissions', function(UserGroup)
		if UserGroup == "admin" or UserGroup == "god" then
			local ped = PlayerPedId()
			local pos = GetEntityCoords(ped)
			returnPos = pos
			local model = GetHashKey(args[1])
			if IsModelInCdimage(model) then
				if not HasModelLoaded(model) then
					ticks[model] = 0
					while not HasModelLoaded(model) do
						scCore.ShowHelpNotification('Requesting model, please wait')
						DisableAllControlActions(0)
						Citizen.Wait(10)
						RequestModel(model)
						ticks[model] = ticks[model] + 1
						if ticks[model] >= Config.ModelWaitTicks then
							ticks[model] = 0
							scCore.ShowHelpNotification('Model '..args[1]..' failed to load, found in server image, please attempt re-logging to solve')
							return
						end
					end
				end
				if HasModelLoaded(model) then
					local x, y, z = pos.x, pos.y, pos.z - 20
					local height = GetWaterHeight(x,y,z)
					local spot
					if height == false then
						spot = vector3(x, y, z)
					else
						spot = GetSafeSpot()
					end
					local spot = vector3(x, y, z)
					local home = CreateObjectNoOffset(model, spot, true, false, false)
					if DoesEntityExist(home) then
						FreezeEntityPosition(home, true)
						SpawnedHome = {}
						table.insert(SpawnedHome, home)
						DoScreenFadeOut(100)
						while not IsScreenFadedOut() do
							Citizen.Wait(1)
						end
						SetEntityCoords(ped, spot)
						Citizen.Wait(1000)
						FreezeEntityPosition(PlayerPedId(), true)
						while not HasCollisionLoadedAroundEntity(ped) do
							Citizen.Wait(1)
						end
						DoScreenFadeIn(100)
						FreezeEntityPosition(PlayerPedId(), false)
					else
						scCore.Notification(Config.Strings.wntRong)
					end
				end
			end
		else
			scCore.Notification(Config.Strings.noPerms)
		end
	end)
end)

RegisterNetEvent("lcrp-houses:client:ClearShell")
AddEventHandler("lcrp-houses:client:ClearShell", function()
	if returnPos ~= nil then
		scCore.TriggerServerCallback('lcrp-scoreboard:server:CheckPermissions', function(UserGroup)
			if UserGroup == "admin" or UserGroup == "god" then
				local ped = PlayerPedId()
				local pos = GetEntityCoords(ped)
				SetEntityCoords(ped, returnPos)
				for i = 1,#SpawnedHome do
					DeleteEntity(SpawnedHome[i])
				end
				SpawnedHome = {}
				returnPos = nil
			else
				scCore.Notification(Config.Strings.noPerms)
			end
		end)
	else
		scCore.Notification(Config.Strings.aftrTst)
	end
end)

MathTrim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

function closeMenuFull()
	local ped = GetPlayerPed(-1)
	if oldProp ~= nil then
		DeleteEntity(oldProp)
	end

	FreezeEntityPosition(PlayerPedId(), false)
	
	Menu.hidden = true
	currentGarage = nil
	renderGUI2 = false
	bypass = false
	ClearMenu()
end

function ClearMenu()
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function GetObjects()
	local objects = {}

	for object in EnumerateObjects() do
		table.insert(objects, object)
	end

	return objects
end

function GetClosestObject(filter, coords)
	local objects         = GetObjects()
	local closestDistance = -1
	local closestObject   = -1
	local filter          = filter
	local coords          = coords

	if type(filter) == 'string' then
		if filter ~= '' then
			filter = {filter}
		end
	end
	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
	end
	for i=1, #objects, 1 do
		local foundObject = false

		if filter == nil or (type(filter) == 'table' and #filter == 0) then
			foundObject = true
		else
			local objectModel = GetEntityModel(objects[i])

			for j=1, #filter, 1 do
				if objectModel == GetHashKey(filter[j]) then
					foundObject = true
				end
			end
		end
		if foundObject then
			local objectCoords = GetEntityCoords(objects[i])
			local distance     = GetDistanceBetweenCoords(objectCoords, coords.x, coords.y, coords.z, true)

			if closestDistance == -1 or closestDistance > distance then
				closestObject   = objects[i]
				closestDistance = distance
			end
		end
	end

	return closestObject, closestDistance
end


function drawCryptoMarker(spawnSpot)
	Citizen.CreateThread(function()
		while true do
			local plyCoords = GetEntityCoords(PlayerPedId())
			local dist = GetDistanceBetweenCoords(plyCoords,spawnSpot,true)
			if dist < 1.5 then
				DrawText3Ds(spawnSpot.x,spawnSpot.y,spawnSpot.z,"~g~Use Cryptostick")
				cryptoPcInRange = true
			else
				cryptoPcInRange = false
			end
			Citizen.Wait(5)
		end
	end)
end

RegisterNetEvent("lcrp-houses:client:cryptoDeskInRange")
AddEventHandler("lcrp-houses:client:cryptoDeskInRange", function(item)
	if cryptoPcInRange then
		scCore.TriggerServerCallback('crypto:getCoinsValues',function(assetsInfo)
			for k,v in pairs(item.info.coins) do
				for i,j in pairs(assetsInfo) do
					if k == assetsInfo[i]['abv'] then
						local amount = v * assetsInfo[i]['value']
						print("You have "..v..k.." valued at "..amount.."dollars")
					end
				end
				
			end
		end)
	end
end)

RegisterNetEvent('lcrp-houses-new:setPlayerInHome')


RegisterNetEvent('lcrp-houses-new:updateDoorAndGarage')
AddEventHandler('lcrp-houses-new:updateDoorAndGarage',function(address,doors,garages)
	Houses[address].doors = doors
	Houses[address].garages = garages
end)

RegisterNetEvent('lcrp-houses-new:client:updateParking')
AddEventHandler('lcrp-houses-new:client:updateParking',function(address,parkings)
	Houses[address].parkings = parkings
end)

RegisterNetEvent('lcrp-houses-new:client:purchaseHouse')
AddEventHandler('lcrp-houses-new:client:purchaseHouse',function(house)
	if PlayerData ~= nil then
		if PlayerData.citizenid == house.owner then
			local blips = Blips.OwnedHome
			if blips.Use then
				local blip = AddBlipForCoord(house.door)
				SetBlipScale  (blip, 1.0)
				SetBlipAsShortRange(blip, true)
				SetBlipSprite (blip, blips.Sprite)
				SetBlipColour (blip, blips.Color)
				SetBlipScale  (blip, blips.Scale)
				SetBlipDisplay(blip, blips.Display)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(blips.Text:gsub('useaddress', house.id))
				EndTextCommandSetBlipName(blip)
				table.insert(scriptBlips, blip)
			end
		end
	end
	Houses[house.id] = house
end)

RegisterNetEvent('lcrp-houses-new:client:sellHouse')
AddEventHandler('lcrp-houses-new:client:sellHouse',function(house)
	Houses[house.id] = house
end)

RegisterNetEvent('lcrp-houses-new:client:updateHouseLock')
AddEventHandler('lcrp-houses-new:client:updateHouseLock',function(address,locked)
	Houses[address].locked = locked
end)


RegisterNetEvent('lcrp-houses-new:client:deleteHouse')
AddEventHandler('lcrp-houses-new:client:deleteHouse',function(address)
	Houses[address] = nil
end)

RegisterNetEvent('lcrp-houses-new:client:updateLandSize')
AddEventHandler('lcrp-houses-new:client:updateLandSize',function(address,draw)
	Houses[address].draw = draw
end)

RegisterNetEvent('lcrp-houses-new:client:updateKeys')
AddEventHandler('lcrp-houses-new:client:updateKeys',function(address,keys)
	for k,v in pairs(scriptBlips) do
		RemoveBlip(v)
	end

	if currentHouseID ~= nil then
		scCore.TriggerServerCallback('lcrp-houses-new:server:getHouseInside', function(inside)
		
			Houses[address].storage = inside.storage
			Houses[address].wardrobe = inside.wardrobe
			Houses[address].furniture = inside.furniture

			Houses[address].keys = keys
			--print(json.encode(Houses[house.id]))
	
		end, address)
	else
		Houses[address].keys = keys
	end
	TriggerEvent('lcrp-houses-new:hasExitedMarker', LastZone)
	TriggerEvent('lcrp-houses-new:hasEnteredMarker', currentZone)
	
	for k,v in pairs(Houses) do
		if PlayerData.citizenid == v.owner or HasKeys(v) then
			local blips = Blips.OwnedHome
			if blips.Use then
				local blip = AddBlipForCoord(v.door)
				SetBlipScale  (blip, 1.0)
				SetBlipAsShortRange(blip, true)
				SetBlipSprite (blip, blips.Sprite)
				SetBlipColour (blip, blips.Color)
				SetBlipScale  (blip, blips.Scale)
				SetBlipDisplay(blip, blips.Display)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(blips.Text:gsub('useaddress', k))
				EndTextCommandSetBlipName(blip)
				table.insert(scriptBlips, blip)
			end
		end
	end
end)

RegisterNetEvent('lcrp-houses-new:client:newHouse')
AddEventHandler('lcrp-houses-new:client:newHouse',function(house)
	Houses[house.id] = house
end)

RegisterNetEvent('lcrp-houses-new:client:getHouses')
AddEventHandler('lcrp-houses-new:client:getHouses',function(houses)
	while scCore == nil do Citizen.Wait(10) end

	if Config.BlinkOnRefresh then
		if not blinking then
			blinking = true
			if timeInd ~= 270 then
				scCore.Notification(Config.Strings.amBlink)
				timeInd = GetTimecycleModifierIndex()
				SetTimecycleModifier('Glasses_BlackOut')
			end
		end
	end
	--[[ for i = 1,#scriptBlips do
		RemoveBlip(scriptBlips[i])
	end ]]
	Houses = houses
	for k,v in pairs(Houses) do
		if PlayerData.citizenid == v.owner or HasKeys(v) then
			local blips = Blips.OwnedHome
			if blips.Use then
				local blip = AddBlipForCoord(v.door)
				SetBlipScale  (blip, 1.0)
				SetBlipAsShortRange(blip, true)
				SetBlipSprite (blip, blips.Sprite)
				SetBlipColour (blip, blips.Color)
				SetBlipScale  (blip, blips.Scale)
				SetBlipDisplay(blip, blips.Display)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(blips.Text:gsub('useaddress', k))
				EndTextCommandSetBlipName(blip)
				table.insert(scriptBlips, blip)
			end
		end
	end
	Citizen.Wait(500)
	if Config.BlinkOnRefresh then
		if timeInd ~= -1 then
			SetTimecycleModifier(Config.TimeCycleMods[tostring(timeInd)])
		else
			timeInd = -1
			ClearTimecycleModifier()
		end
		blinking = false
	end
end)

-- Command to get house offsets for config 

-- RegisterCommand("houseoffset", function(raw)
-- 	local ped = PlayerPedId()
-- 	local pos = GetEntityCoords(ped)
-- 	local home = SpawnedHome[1]
-- 	local offset = GetOffsetFromEntityGivenWorldCoords(home, pos)
-- 	local vec = vector3(offset.x, offset.y, offset.z - 1.0)
-- end)

RegisterNetEvent("lcrp-houses:client:furnitureMenu")
AddEventHandler("lcrp-houses:client:furnitureMenu", function()
	OpenFurnStore()
	Menu.hidden = not Menu.hidden
    renderMenuFunc()
end)

renderMenuFunc = function()
    Citizen.CreateThread(function()
        while not Menu.hidden do
            Citizen.Wait(5)
			local pos = GetEntityCoords(PlayerPedId())
			local dis = #(pos - Config.Furnishing.Store.enter)
            if dis < 10 or Menu.hidden then
                Menu.renderGUI()
            else
                break
            end
        end
    end)
end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
	exports["lcrp-interact"]:AddBoxZone("RealEstateDuty", vector3(-718.77, 260.64, 84.1), 2.4, 0.6, {
		name="RealEstateDuty",
		heading=25,
		minZ=84.15,
		maxZ=84.95 }, {
		options = {
			{
				event = "police:client:Duty",
				icon = "far fa-clipboard",
				label = "Clock in",
				duty = false,
				parameters = "duty",
			},
			{
				event = "police:client:Duty",
				icon = "far fa-clipboard",
				label = "Clock out",
				duty = true,
				parameters = "duty",
			},
		},
	job = {"realestate"}, distance = 1.5 })

	exports["lcrp-interact"]:AddBoxZone("RealEstateBoss", vector3(-716.07, 261.42, 84.1), 1.2, 2.6, {
        name="RealEstateBoss",
		heading=25,
		minZ=83.95,
		maxZ=84.55 }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-car-alt",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"realestate"}, distance = 2.0 })


	exports["lcrp-interact"]:AddBoxZone("FurnitureStore", vector3(2746.6, 3473.85, 55.67), 15.0, 1.4, {
		name="FurnitureStore",
		heading=337,
		--debugPoly=true,
		minZ=54.67,
		maxZ=58.67 }, {
        options = {
            {
                event = "lcrp-houses:client:furnitureMenu",
                icon = "fas fa-couch",
                label = "Furniture Catalog",
                duty = false,
            },
			{
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-tools",
                label = "MegaMall Shop",
                duty = false,
				parameters = "hardware2"
            },
        },
    job = {"all"}, distance = 5.0 })

	exports["lcrp-interact"]:AddTargetModel(Config.Stash, {
        options = {
            {
                event = "lcrp-houses-interact:client:openStash",
                icon = "fad fa-box-open",
                label = "Open stash",
                duty = false,
            },
        },
      job = {"all"}, distance = 1.5})

	exports["lcrp-interact"]:AddTargetModel(Config.Wardrobe, {
		options = {
			{
				event = "lcrp-houses-interact:client:openWardrobe",
				icon = "fad fa-tshirt",
				label = "Change outfit",
				duty = false,
			},
			{
				event = "lcrp-houses-interact:client:saveCurrentOutfitName",
				icon = "fad fa-tshirt",
				label = "Save current outfit",
				duty = false,
			},
			{
				event = "lcrp-houses-interact:client:deleteOutfitMenu",
				icon = "fad fa-tshirt",
				label = "Delete outfit",
				duty = false,
			},
		},
	job = {"all"}, distance = 1.5})
end)

RegisterNetEvent('lcrp-houses-interact:client:saveCurrentOutfitName')
AddEventHandler('lcrp-houses-interact:client:saveCurrentOutfitName',function()
	local outfitName = scCore.KeyboardInput("Enter the name for the outfit", "", 20)
	if outfitName ~= nil then
		scCore.TriggerServerCallback("lcrp-clothes:outfitList", function(result)
			local id = 1
			if result ~= nil or json.encode(result) ~= "[]" then
				local count = 0
				local found = false
				for k, v in pairs(result) do
					count = count + 1
					if count ~= tonumber(v.slot) then
						id = count
						found = true
						break
					end
				end
				if not found then
					id = #result + 1
				end
			end
			TriggerEvent("raid-clothes:commandOutfit", 1, {1, id, outfitName})
		end)
	else
		scCore.Notification('Invalid name!', "error")
	end
end)

RegisterNetEvent('lcrp-houses-interact:client:deleteOutfitMenu')
AddEventHandler('lcrp-houses-interact:client:deleteOutfitMenu',function()
	local slot = scCore.KeyboardInput("Enter the slot number", "", 2)
	if slot ~= nil then
		TriggerEvent("raid-clothes:commandOutfit", 2, {2, slot})
	else
		scCore.Notification('Invalid slot!', "error")
	end
end)

RegisterNetEvent('lcrp-houses-interact:client:buyHouse')
AddEventHandler('lcrp-houses-interact:client:buyHouse',function(house)
	BuyHouse(house)
end)


RegisterNetEvent('lcrp-houses-interact:client:viewHouse')
AddEventHandler('lcrp-houses-interact:client:viewHouse',function(house)
	viewHouse(house)
end)


RegisterNetEvent('lcrp-houses-interact:client:enterHouse')
AddEventHandler('lcrp-houses-interact:client:enterHouse',function(house)
	enterHouse(house)
end)

RegisterNetEvent('lcrp-houses-interact:client:giveHouseKeyMenu')
AddEventHandler('lcrp-houses-interact:client:giveHouseKeyMenu',function(house)
	giveHouseKey(house)
end)

RegisterNetEvent('lcrp-houses-interact:client:takeHouseKeyMenu')
AddEventHandler('lcrp-houses-interact:client:takeHouseKeyMenu',function(house)
	takeHouseKey(house)
end)

RegisterNetEvent('lcrp-houses-interact:client:useHouseKey')
AddEventHandler('lcrp-houses-interact:client:useHouseKey',function(house)
	useHouseKey(house)
end)

RegisterNetEvent('lcrp-houses-interact:client:knockHouseDoor')
AddEventHandler('lcrp-houses-interact:client:knockHouseDoor',function(house)
	knockHouseDoor(house)
end)

RegisterNetEvent('lcrp-houses-interact:client:SelectPrice')
AddEventHandler('lcrp-houses-interact:client:SelectPrice',function(house)
	SelectPrice(house)
end)

RegisterNetEvent('lcrp-houses-interact:client:AttemptBuyBack')
AddEventHandler('lcrp-houses-interact:client:AttemptBuyBack',function(house)
	AttemptBuyBack(house)
end)

RegisterNetEvent('lcrp-houses-interact:client:letInHouse')
AddEventHandler('lcrp-houses-interact:client:letInHouse',function(house)
	letInHouse(house)
end)

RegisterNetEvent('lcrp-houses-interact:client:lockHouseDoor')
AddEventHandler('lcrp-houses-interact:client:lockHouseDoor',function(house)
	lockHouseDoor(house)
end)

RegisterNetEvent('lcrp-houses-interact:client:exitHouse')
AddEventHandler('lcrp-houses-interact:client:exitHouse',function(house)
	exitHouse(house)
end)

RegisterNetEvent('lcrp-houses-interact:client:FurnishHome')
AddEventHandler('lcrp-houses-interact:client:FurnishHome',function(house)
	FurnishHome(house)
	Menu.hidden = not Menu.hidden
	renderMenuFunc2()
end)

RegisterNetEvent('lcrp-houses-interact:client:UnFurnishHome')
AddEventHandler('lcrp-houses-interact:client:UnFurnishHome',function(house)
	UnFurnishHome(house)
	Menu.hidden = not Menu.hidden
	renderMenuFunc2()
end)

RegisterNetEvent('lcrp-houses-interact:client:openStash')
AddEventHandler('lcrp-houses-interact:client:openStash',function()
	if inHome then
		TriggerServerEvent("inventory:server:OpenInventory", "stash", currentHouse.id)
		TriggerEvent("inventory:client:SetCurrentStash", currentHouse.id)
	end
end)

RegisterNetEvent('lcrp-houses-interact:client:openWardrobe')
AddEventHandler('lcrp-houses-interact:client:openWardrobe',function()
	OpenOutfitsMenu()
	bypass = true
	Menu.hidden = not Menu.hidden
	renderMenuFunc2()
end)

function CanLeave()
	return canLeave
end

renderMenuFunc2 = function()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5)
            if not Menu.hidden then
                Menu.renderGUI()
            else
                break
            end
        end
    end)
end
