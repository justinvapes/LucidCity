local myPet = nil
local isOut = false
local isFollowing = false
local isAnim = false
local vehicle = nil
local isDefense = false
local petType = nil
local food = nil
local isDead = 0
local doctor = nil

Citizen.CreateThread(function()
	while scCore == nil do
		TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
		Citizen.Wait(200)
	end
	
	Citizen.Wait(5000)
	DoRequestModel(-1788665315) -- rottweiler
	DoRequestModel(1462895032) -- cat
	--DoRequestModel(1682622302) -- wolf
	DoRequestModel(-541762431) -- rabbit
	DoRequestModel(1318032802) -- husky
	DoRequestModel(-1323586730) -- pig
	DoRequestModel(1125994524) -- caniche
	DoRequestModel(1832265812) -- pug
	DoRequestModel(882848737) -- retriever
	DoRequestModel(1126154828) -- shepherd
	DoRequestModel(-1384627013) -- westy
	DoRequestModel(351016938)  -- police
end)

local petShop = {x = -1408.38, y = -437.34, z = 36.55}  
local checkIn = {isBusy = false, x = -1406.037, y = -436.24, z = 36.55}

--[[ Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, petShop.x, petShop.y, petShop.z, true)
		local distanceCheck = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, checkIn.x, checkIn.y, checkIn.z, true)
		local sleep = 1000
		if distance < 8 then
			sleep = 5
			if distance < 1.5 then
				DrawText3D(petShop.x, petShop.y, petShop.z, "~g~[E]~w~ - To browse the pets shop")
				if IsControlJustReleased(0, Keys["E"]) then
					PetShop()
					Menu.hidden = not Menu.hidden
				end
				Menu.renderGUI()
			end
		end
		if distanceCheck < 8 then
			sleep = 5
			if distanceCheck < 1.5 and not checkIn.isBusy then
				DrawText3D(checkIn.x, checkIn.y, checkIn.z, "~g~[E]~w~ - To check in - $1500")
				if IsControlJustReleased(0, Keys["E"]) then
					startDogPickup()
				end
			elseif distanceCheck < 1.5 and checkIn.isBusy then
				DrawText3D(checkIn.x, checkIn.y, checkIn.z, "~g~[E]~w~ - The employee is busy")
			end
		end
		--if isOut then
			--if myPet ~= nil then
				--if IsEntityDead(myPet) then
					--isDead = 1
					--TriggerServerEvent('lcrp-pets:server:updatePet', food, isDead)
					--Citizen.Wait(20000)
					--DeletePed(myPet)
					--isFollowing = false
					--isOut = false
				--end
			--end
		--end
		Citizen.Wait(sleep)
	end
end) ]]

--decreaseFood = function()
	--Citizen.CreateThread(function()
		--while isOut do
			--if food ~= nil and food > 0 then
				--food = food - 10
				--if food <= 0 then
					--SetEntityHealth(myPet, 0)
				--end
			--end
			--Citizen.Wait(900000)
		--end
	--end)
--end

Citizen.CreateThread(function()
	--DoRequestModel(-730659924) -- Doctor doctor
	--doctor = CreatePed(20, -730659924, -1405.54, -437.56, 36.55, 1, 1) 
	--Citizen.Wait(1000)
	--SetEntityAsMissionEntity(doctor, true, true)
	--FreezeEntityPosition(doctor, true) 
	--SetBlockingOfNonTemporaryEvents(doctor, true)
	--SetPedCanBeTargetted(doctor, false)
	--SetEntityInvincible(doctor, true)

	local vetBlip = AddBlipForCoord(-1405.86, -431.53, 36.54)
	SetBlipSprite(vetBlip, 273)
	SetBlipColour(vetBlip, 24)
	SetBlipScale(vetBlip, 0.7)
	SetBlipAsShortRange(vetBlip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Premium Pet Clinic")
	EndTextCommandSetBlipName(vetBlip)
end)

function startDogPickup()
	--RequestAnimDict("anim@mp_player_intselfiethumbs_up")
	--while not HasAnimDictLoaded("anim@mp_player_intselfiethumbs_up") do
		--Citizen.Wait(0)
--	end
	--TaskPlayAnim(doctor, "anim@mp_player_intselfiethumbs_up", "idle_a", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
	TriggerServerEvent('lcrp-pets:server:callPet', true)
	Citizen.Wait(5000)
	--ClearPedTasksImmediately(doctor)
	--FreezeEntityPosition(doctor, true) 
	--SetBlockingOfNonTemporaryEvents(doctor, true)
	--(doctor, false)
	--SetEntityInvincible(doctor, true)
end

followOwner = function()
    Citizen.CreateThread(function()
		while isFollowing do
			if myPet ~= nil then
				local playerPed = PlayerPedId()
				local dist = GetVecDist(GetEntityCoords(playerPed), GetEntityCoords(myPet))
				if dist > 2.5 and dist < 500 then
					if GetEntitySpeed(myPet) == 0 then
						TaskGoToEntity(myPet, playerPed, -1, 4.0, 100.0, 1073741824, 0)
					end
				end
				Citizen.Wait(0)
			end
		end
    end)
end


defenseMode = function()
    Citizen.CreateThread(function()
		while isDefense do
			if myPet ~= nil then
				local playerPed = PlayerPedId()
				if HasEntityBeenDamagedByAnyPed(playerPed) then
					local player, distance = GetClosestPlayer()
					local enemySvId = GetPlayerServerId(player)
					local enemyPed = GetPlayerPed(GetPlayerFromServerId(enemySvId))
					if HasEntityBeenDamagedByEntity(playerPed, enemyPed, 1) then
						SetPedCombatAttributes(myPet, 46, true)
						SetPedCombatAbility(myPet, 100)
						TaskCombatPed(myPet, enemyPed, 0, 16)
						Citizen.Wait(15000)
					end
				end
			end
			Citizen.Wait(1)
		end
    end)
end

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

GetVecDist = function(v1,v2)
    if not v1 or not v2 or not v1.x or not v2.x then 
		return 0; 
	end
    	return math.sqrt(  ( (v1.x or 0) - (v2.x or 0) )*(  (v1.x or 0) - (v2.x or 0) )+( (v1.y or 0) - (v2.y or 0) )*( (v1.y or 0) - (v2.y or 0) )+( (v1.z or 0) - (v2.z or 0) )*( (v1.z or 0) - (v2.z or 0) )  )
  	end


RegisterNetEvent('lcrp-pets:client:callPet')
AddEventHandler('lcrp-pets:client:callPet', function(citizenid)
	if not isOut then
		TriggerServerEvent('lcrp-pets:server:callPet')
	else
		scCore.Notification('Your pet is already out.', 'error')
	end
end)


RegisterNetEvent('lcrp-pets:client:dismissPet')
AddEventHandler('lcrp-pets:client:dismissPet', function()
	if isOut then
		scCore.Notification('You dismissed your pet.')
		TriggerServerEvent('lcrp-pets:server:updatePet', food, isDead)
		isFollowing = false
		local coords = GetEntityCoords(PlayerPedId())
		TaskGoToCoordAnyMeans(myPet, coords.x + 40, coords.y, coords.z, 5.0, 0, 0, 786603, 0xbf800000)
		Citizen.Wait(5000)
		DeletePed(myPet)
		isOut = false
	end
end)


RegisterNetEvent('lcrp-pets:client:spawnPet')
AddEventHandler('lcrp-pets:client:spawnPet', function(petName, petFood, model, onVet)
	if isOut then
		scCore.Notification('Your pet is already out.', 'error')
	else
		if onVet == nil then
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), checkIn.x, checkIn.y, checkIn.z) < 10 then
				onVet = true
			end
		end
		local playerPed = nil
		local LastPosition = nil
		local spawnOutside = onVet
		if spawnOutside then
			LastPosition = {x = -1406.09, y = -430.24, z =  37.54}
			scCore.Notification('Your pet is waiting outside.')
		else
			playerPed = PlayerPedId()
			LastPosition = GetEntityCoords(playerPed)
			scCore.Notification('You called your pet.')
		end
		TriggerEvent('animations:client:EmoteCommandStart', {"whistle"})
		food = petFood
		Citizen.SetTimeout(3000, function()
			myPet = CreatePed(28, model, LastPosition.x +1, LastPosition.y +1, LastPosition.z -1, 1, 1)
			petBlip = AddBlipForEntity(myPet)

			SetBlipSprite(petBlip, 273)
			SetBlipColour(petBlip, 7)
			SetBlipScale(petBlip, 0.7)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(petName)
			EndTextCommandSetBlipName(petBlip)

			SetBlockingOfNonTemporaryEvents(myPet, true)
			SetPedCanBeTargetted(myPet, false)
			SetEntityInvincible(myPet, true)
			isOut = true
			isFollowing = true
			--decreaseFood()
			followOwner()
		end)
	end
end)


RegisterNetEvent('lcrp-pets:client:toggleDefendMode')
AddEventHandler('lcrp-pets:client:toggleDefendMode', function()
	if isOut then
		if petType == "rottweiller" or petType == "husky" or petType == "police" or petType == "shepherd" then
			if isDefense then
				scCore.Notification('Your pet is now on passive mode.')
				isDefense = false
			else
				scCore.Notification('Your pet is now on defensive mode.', 'error')
				isDefense = true
				defenseMode()
			end
		else
			scCore.Notification('This pet breed is not trained for combat.')
		end
	else
		scCore.Notification('Your pet is not out.', 'error')
	end
end)

RegisterNetEvent('lcrp-pets:client:sitPet')
AddEventHandler('lcrp-pets:client:sitPet', function()
	if isOut then
		DoRequestAnimSet("creatures@rottweiler@amb@world_dog_sitting@base") 
    	TaskPlayAnim(myPet, "creatures@rottweiler@amb@world_dog_sitting@base", "base", 2.0, 2.0, -1, 1, 0, false, false, false)
		isAnim = true
	else
		scCore.Notification('Your pet is not out.', 'error')
	end
end)

RegisterNetEvent('lcrp-pets:client:petFollow')
AddEventHandler('lcrp-pets:client:petFollow', function()
	if isOut then
		local isInVehicle = IsPedInVehicle(myPet, vehicle)
		if not isFollowing and isInVehicle then
			TaskLeaveVehicle(myPet, vehicle, 16)
			Citizen.Wait(100)
			local pos = GetEntityCoords(myPet)
			SetEntityCoords(myPet, pos.x, pos.y, pos.z - 0.5)
			isFollowing = true
			followOwner()
			scCore.Notification('Your pet is following you.')
		elseif not isFollowing then
			resetPetAnim()
			isFollowing = true
			followOwner()
			scCore.Notification('Your pet is following you.')
		else
			scCore.Notification('Your is already following you!', 'error')
		end
	else
		scCore.Notification('Your pet is not out.', 'error')
	end
end)

RegisterNetEvent('lcrp-pets:client:petUnfollow')
AddEventHandler('lcrp-pets:client:petUnfollow', function()
	if isOut then
		if isFollowing then
			isFollowing = false
			scCore.Notification('Your pet stopped following you.')
		else
			scCore.Notification('Your pet is not following you.', 'error')
		end
	else
		scCore.Notification('Your pet is not out.', 'error')
	end
end)

RegisterNetEvent('lcrp-pets:client:layPet')
AddEventHandler('lcrp-pets:client:layPet', function()
	if isOut then
		DoRequestAnimSet("creatures@rottweiler@amb@sleep_in_kennel@") 
    	TaskPlayAnim(myPet, "creatures@rottweiler@amb@sleep_in_kennel@", "sleep_in_kennel", 2.0, 2.0, -1, 1, 0, false, false, false)
		isAnim = true
	else
		scCore.Notification('Your pet is not out.', 'error')
	end
end)

RegisterNetEvent('lcrp-pets:client:barkPet')
AddEventHandler('lcrp-pets:client:barkPet', function()
	if isOut then
		DoRequestAnimSet("creatures@rottweiler@amb@world_dog_barking@idle_a") 
    	TaskPlayAnim(myPet, "creatures@rottweiler@amb@world_dog_barking@idle_a", "idle_a", 2.0, 2.0, -1, 1, 0, false, false, false)
		isAnim = true
	else
		scCore.Notification('Your pet is not out.', 'error')
	end
end)

RegisterNetEvent('lcrp-pets:client:pawPet')
AddEventHandler('lcrp-pets:client:pawPet', function()
	if isOut then
		DoRequestAnimSet("creatures@rottweiler@tricks@") 
    	TaskPlayAnim(myPet, "creatures@rottweiler@tricks@", "paw_right_loop", 2.0, 2.0, -1, 1, 0, false, false, false)
		isAnim = true
	else
		scCore.Notification('Your pet is not out.', 'error')
	end
end)

RegisterNetEvent('lcrp-pets:client:tauntPet')
AddEventHandler('lcrp-pets:client:tauntPet', function()
	if isOut then
		DoRequestAnimSet("creatures@rottweiler@melee@streamed_taunts@") 
    	TaskPlayAnim(myPet, "creatures@rottweiler@melee@streamed_taunts@", "taunt_01", 2.0, 2.0, -1, 1, 0, false, false, false)
		isAnim = true
	else
		scCore.Notification('Your pet is not out.', 'error')
	end
end)


RegisterNetEvent('lcrp-pets:client:resetPet')
AddEventHandler('lcrp-pets:client:resetPet', function()
	if isOut then
		resetPetAnim()
	else
		scCore.Notification('Your pet is not out.', 'error')
	end
end)

RegisterNetEvent('lcrp-pets:client:goTo')
AddEventHandler('lcrp-pets:client:goTo', function()
	if isOut then
		isFollowing = false
		if isAnim then
			resetPetAnim()
		end
		local distance = 1000
		local cameraRotation = GetGameplayCamRot()
		local cameraCoord = GetGameplayCamCoord()
		local direction = RotationToDirection(cameraRotation)
		local destination = 
		{ 
			x = cameraCoord.x + direction.x * distance, 
			y = cameraCoord.y + direction.y * distance, 
			z = cameraCoord.z + direction.z * distance 
		}
		local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
		TaskGoToCoordAnyMeans(myPet, c.x, c.y, c.z, 5.0, 0, 0, 786603, 0xbf800000)
	else
		scCore.Notification('Your pet is not out.', 'error')
	end
end)

RegisterNetEvent('lcrp-pets:client:enterCarPet')
AddEventHandler('lcrp-pets:client:enterCarPet', function()
	if isOut then
		if isAnim then
			resetPetAnim()
		end
		local playerPed = PlayerPedId()
		vehicle  = GetVehiclePedIsUsing(playerPed)
		local coords   = GetEntityCoords(playerPed)
		local coords2  = GetEntityCoords(myPet)
		local distance = GetDistanceBetweenCoords(coords, coords2, true)
		local isInVehicle = IsPedInVehicle(myPet, vehicle)

		if not isInVehicle then
			if IsPedSittingInAnyVehicle(playerPed) then
				if GetVehicleClass(vehicle) ~= 8 then
					if distance < 30 then
						Citizen.Wait(200)
						if distance < 10 then
							distance = 10
						end
						if IsVehicleSeatFree(vehicle, 0) then
							ClearPedTasksImmediately(myPet)
							local doorpos = GetOffsetFromEntityInWorldCoords(vehicle, 0.25, 0, 0)
							TaskGoToCoordAnyMeans(myPet, doorpos.x, doorpos.y, doorpos.z, 10.0, 0, 0, 786603, 0xbf800000)
							SetVehicleDoorOpen(vehicle, 1, false, false)
							Citizen.Wait(0.625 * distance * 500)
							SetPedIntoVehicle(myPet, vehicle, 0)
							SetVehicleDoorShut(vehicle, 1, false)
							isFollowing = false
						elseif IsVehicleSeatFree(vehicle, 1) then
							ClearPedTasksImmediately(myPet)
							local doorpos = GetOffsetFromEntityInWorldCoords(vehicle, -0.25, -0.15, 0)
							TaskGoToCoordAnyMeans(myPet, doorpos.x, doorpos.y, doorpos.z, 10.0, 0, 0, 786603, 0xbf800000)
							SetVehicleDoorOpen(vehicle, 2, false, false)
							Citizen.Wait(0.625 * distance * 500)
							SetPedIntoVehicle(myPet, vehicle, 1)
							SetVehicleDoorShut(vehicle, 2, false)
							isFollowing = false
						elseif IsVehicleSeatFree(vehicle, 2) then
							ClearPedTasksImmediately(myPet)
							local doorpos = GetOffsetFromEntityInWorldCoords(vehicle, 0.25, -0.15, 0)
							TaskGoToCoordAnyMeans(myPet, doorpos.x, doorpos.y, doorpos.z, 10.0, 0, 0, 786603, 0xbf800000)
							SetVehicleDoorOpen(vehicle, 3, false, false)
							Citizen.Wait(0.625 * distance * 500)
							SetPedIntoVehicle(myPet, vehicle, 2)
							SetVehicleDoorShut(vehicle, 3, false)
							isFollowing = false
						end
						SetBlockingOfNonTemporaryEvents(myPet, true)
						SetPedCanBeTargetted(myPet, false)
						SetEntityInvincible(myPet, true)
					else
						scCore.Notification('Your pet is too far away.', 'error')
					end
				end
			else
				scCore.Notification('You must be in a vehicle.', 'error')
			end
		end
	else
		scCore.Notification('Your pet is not out.', 'error')
	end
end)

function RotationToDirection(rotation)
	local adjustedRotation = 
	{ 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	local direction = 
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

function resetPetAnim()
	ClearPedTasksImmediately(myPet)
	SetBlockingOfNonTemporaryEvents(myPet, true)
	SetEntityInvincible(myPet, true)
	SetPedCanBeTargetted(myPet, false)
	isAnim = false
end

function DoRequestModel(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(1)
	end
end

function DoRequestAnimSet(anim)
	RequestAnimDict(anim)
	while not HasAnimDictLoaded(anim) do
		Citizen.Wait(1)
	end
end

function DrawText3D(x, y, z, text)
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
	exports["lcrp-interact"]:AddBoxZone("PetShopBuy", vector3(-1408.15, -438.04, 36.56), 1.8, 0.6, {
		name="PetShopBuy",
		heading=301,
		--debugPoly=true,
		minZ=35.36,
		maxZ=37.16
        }, {
        options = setInteractPets(),
    job = {"all"}, distance = 2.0 })
end)

function setInteractPets()
	pets = {{
		event = "",
		icon = "",
		label = "Available Pets",
		duty = false,
		},
	}
	for k,v in pairs(Config.Pets) do
		table.insert(pets, {
			event = "petshop:client:buyPet",
			icon = v.icon,
			label = v.label.." | ".."$"..v.price,
			duty = false,
			parameters = json.encode(v)
		})
	end
	return pets
end

RegisterNetEvent("petshop:client:buyPet")
AddEventHandler("petshop:client:buyPet", function(chosenPet)
	chosenPet = json.decode(chosenPet)
	local PlayerData = scCore.Functions.GetPlayerData()
	if PlayerData.donations.hasPet == 1 then
		if PlayerData.fivem ~= nil then
			if not isOut then
				local citizenid = PlayerData.citizenid
				chosenName = scCore.KeyboardInput("Input the name for your "..chosenPet.label, "", 100)
				if chosenName == nil then chosenName = "My Pet" end
				petType = chosenPet.name
				TriggerServerEvent('lcrp-pets:server:buyPet', citizenid, chosenName, chosenPet.model, chosenPet.price)
			else
				scCore.Notification('Send your pet home to be able to replace it.', 'error')
			end
		else
			scCore.Notification('You don\'t have access to VIP pets because your FiveM account is not linked.')
		end
	else
		scCore.Notification('You don\'t have access to VIP pets. Check our website for more information.')
	end
end)


	

