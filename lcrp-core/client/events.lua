-- scCore Command Events
RegisterNetEvent('scCore:Command:TeleportToPlayer')
AddEventHandler('scCore:Command:TeleportToPlayer', function(othersource)
	local coords = GetEntityCoords(GetPlayerPed(-1))
	TriggerServerEvent('lcrp-admin:server:playerTp', coords, othersource)
end)

RegisterNetEvent('scCore:Command:TeleportToCoords')
AddEventHandler('scCore:Command:TeleportToCoords', function(x, y, z)
	local entity = GetPlayerPed(-1)
	if IsPedInAnyVehicle(entity, false) then
		entity = GetVehiclePedIsUsing(entity)
	end
	SetEntityCoords(entity, x, y, z)
end)

RegisterNetEvent('scCore:Command:SpawnVehicle')
AddEventHandler('scCore:Command:SpawnVehicle', function(model)
	scCore.Functions.SpawnVehicle(model, function(vehicle)
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
		TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
	end)
end)

RegisterNetEvent('scCore:Command:DeleteVehicle')
AddEventHandler('scCore:Command:DeleteVehicle', function()
	if IsPedInAnyVehicle(GetPlayerPed(-1)) then
		scCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	else
		local vehicle = scCore.Functions.GetClosestVehicle()
		scCore.Functions.DeleteVehicle(vehicle)
	end
end)

RegisterNetEvent('scCore:Command:Revive')
AddEventHandler('scCore:Command:Revive', function()
	local coords = scCore.Functions.GetCoords(GetPlayerPed(-1))
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z+0.2, coords.a, true, false)
	SetPlayerInvincible(GetPlayerPed(-1), false)
	ClearPedBloodDamage(GetPlayerPed(-1))
end)

RegisterNetEvent('scCore:Command:GoToMarker')
AddEventHandler('scCore:Command:GoToMarker', function()
	Citizen.CreateThread(function()
		local entity = PlayerPedId()
		if IsPedInAnyVehicle(entity, false) then
			entity = GetVehiclePedIsUsing(entity)
		end
		local success = false
		local blipFound = false
		local blipIterator = GetBlipInfoIdIterator()
		local blip = GetFirstBlipInfoId(8)

		while DoesBlipExist(blip) do
			if GetBlipInfoIdType(blip) == 4 then
				cx, cy, cz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector())) --GetBlipInfoIdCoord(blip)
				blipFound = true
				break
			end
			blip = GetNextBlipInfoId(blipIterator)
		end

		if blipFound then
			DoScreenFadeOut(250)
			while IsScreenFadedOut() do
				Citizen.Wait(250)
			end
			local groundFound = false
			local yaw = GetEntityHeading(entity)
			
			for i = 0, 1000, 1 do
				SetEntityCoordsNoOffset(entity, cx, cy, ToFloat(i), false, false, false)
				SetEntityRotation(entity, 0, 0, 0, 0 ,0)
				SetEntityHeading(entity, yaw)
				SetGameplayCamRelativeHeading(0)
				Citizen.Wait(0)
				--groundFound = true
				if GetGroundZFor_3dCoord(cx, cy, ToFloat(i), cz, false) then --GetGroundZFor3dCoord(cx, cy, i, 0, 0) GetGroundZFor_3dCoord(cx, cy, i)
					cz = ToFloat(i)
					groundFound = true
					break
				end
			end
			if not groundFound then
				cz = -300.0
			end
			success = true
		else
			
		end

		if success then
			SetEntityCoordsNoOffset(entity, cx, cy, cz, false, false, true)
			SetGameplayCamRelativeHeading(0)
			if IsPedSittingInAnyVehicle(PlayerPedId()) then
				if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
					SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
				end
			end
			--HideLoadingPromt()
			DoScreenFadeIn(250)
		end
	end)
end)

-- Other stuff
RegisterNetEvent('scCore:Player:SetPlayerData')
AddEventHandler('scCore:Player:SetPlayerData', function(val)
	scCore.PlayerData = val
end)

RegisterNetEvent('scCore:Player:UpdatePlayerData')
AddEventHandler('scCore:Player:UpdatePlayerData', function()
	local data = {}
	data.position = scCore.Functions.GetCoords(GetPlayerPed(-1))
	TriggerServerEvent('scCore:UpdatePlayer', data)
end)

RegisterNetEvent('scCore:Player:UpdatePlayerPosition')
AddEventHandler('scCore:Player:UpdatePlayerPosition', function()
	local position = scCore.Functions.GetCoords(GetPlayerPed(-1))
	TriggerServerEvent('scCore:UpdatePlayerPosition', position)
end)

RegisterNetEvent('scCore:Client:LocalOutOfCharacter')
AddEventHandler('scCore:Client:LocalOutOfCharacter', function(playerId, playerName, message)
	local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerId)), false)
	local pos = GetEntityCoords(GetPlayerPed(-1), false)
	local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true)
	if dist < 20.0 then
		if dist == 0 and GetPlayerServerId(PlayerId()) == playerId then
			TriggerEvent("chatMessage", "LOCAL | " .. playerName, "normal", message)
		elseif dist ~= 0 then
			TriggerEvent("chatMessage", "LOCAL | " .. playerName, "normal", message)
		end
    end
end)

RegisterNetEvent('scCore:Client:LocalThink')
AddEventHandler('scCore:Client:LocalThink', function(playerId, playerName, message)
	local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerId)), false)
	local pos = GetEntityCoords(GetPlayerPed(-1), false)
	local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true)
	if dist < 20.0 then
		if dist == 0 and GetPlayerServerId(PlayerId()) == playerId then
			TriggerEvent("chatMessage", "" .. playerName.. " Thinks", "thinks", message)
		elseif dist ~= 0 then
			TriggerEvent("chatMessage", "" .. playerName.. " Thinks", "thinks", message)
		end
    end
end)

RegisterNetEvent('scCore:Notification')
AddEventHandler('scCore:Notification', function(text, type, length)
	scCore.Notification(text, type, length)
end)

RegisterNetEvent('scCore:Client:TriggerCallback')
AddEventHandler('scCore:Client:TriggerCallback', function(name, ...)
	if scCore.ServerCallbacks[name] ~= nil then
		scCore.ServerCallbacks[name](...)
		scCore.ServerCallbacks[name] = nil
	end
end)

RegisterNetEvent("scCore:Client:UseItem")
AddEventHandler('scCore:Client:UseItem', function(item)
	TriggerServerEvent("scCore:Server:UseItem", item)
end)