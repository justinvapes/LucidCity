scCore = nil

Citizen.CreateThread(function()
	while scCore == nil do
		TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
		Citizen.Wait(0)
	end
end)

local closestDoorKey, closestDoorValue = nil, nil

function DrawText3Ds(x, y, z, text)
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

local maxDistance = 1.25

Citizen.CreateThread(function()
	Citizen.Wait(500)
	while true do
		Citizen.Wait(0)
		local playerCoords, awayFromDoors = GetEntityCoords(GetPlayerPed(-1)), true

		for k,doorID in ipairs(QB.Doors) do
			local textCoords = doorID.textCoords
			if (type(textCoords) ~= "table") then
				textCoords = { [1] = textCoords }
			end

			for j, textCoord in pairs(textCoords) do
				local distance = #(playerCoords - textCoord)

				if doorID.distance then
					maxDistance = doorID.distance
				end
				if distance < 50 then
					awayFromDoors = false
					if doorID.doors then
						for _,v in ipairs(doorID.doors) do
							if type(v.objName) == 'string' and (not v.object or not DoesEntityExist(v.object)) then
								v.object = GetClosestObjectOfType(v.objCoords, 1.0, GetHashKey(v.objName), false, false, false)
							elseif type(v.objName) == 'number' and (not v.object or not DoesEntityExist(v.object)) then
								v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objName, false, false, false)
							end
							FreezeEntityPosition(v.object, doorID.locked)

							if doorID.locked and v.objYaw and GetEntityRotation(v.object).z ~= v.objYaw then
								SetEntityRotation(v.object, 0.0, 0.0, v.objYaw, 2, true)
							end
						end
					else
						if type(doorID.objName) == 'string' and (not doorID.object or not DoesEntityExist(doorID.object)) then
							doorID.object = GetClosestObjectOfType(doorID.objCoords, 1.0, GetHashKey(doorID.objName), false, false, false)
						elseif type(doorID.objName) == 'number' and (not doorID.object or not DoesEntityExist(doorID.object)) then
							doorID.object = GetClosestObjectOfType(doorID.objCoords, 1.0, doorID.objName, false, false, false)
						end
						FreezeEntityPosition(doorID.object, doorID.locked)

						if doorID.locked and doorID.objYaw and GetEntityRotation(doorID.object).z ~= doorID.objYaw then
							SetEntityRotation(doorID.object, 0.0, 0.0, doorID.objYaw, 2, true)
						end
					end
				end

				if distance < maxDistance then
					awayFromDoors = false

					local isAuthorized = IsAuthorized(doorID)
					local displayName = ""
					if (doorID.displayName ~= nil) then
						displayName = doorID.displayName
					end

					if isAuthorized then
						if doorID.locked then
							displayText = "~r~[E]~w~ - " .. displayName .. " Locked"
						else
							displayText = "~r~[E]~w~ - " .. displayName .. " Unlocked"
						end
					else
						if doorID.locked then
							displayText = displayName .. " Locked"
						else
							displayText = displayName .. " Unlocked"
						end
					end

					if doorID.locking then
						if doorID.locked then
							displayText = displayName .. " Unlocking.."
						else
							displayText = displayName .. " Locking.."
						end
					end

					DrawText3Ds(textCoord.x, textCoord.y, textCoord.z, displayText)

					if IsControlJustReleased(0, 38) then
						if isAuthorized then
							setDoorLocking(doorID, k)
						end
					end
				end
			end
		end

		if awayFromDoors then
			Citizen.Wait(5000)
		end
	end
end)

RegisterNetEvent('lockpicks:UseLockpick')
AddEventHandler('lockpicks:UseLockpick', function()
	local ped = GetPlayerPed(-1)
	local pos = GetEntityCoords(ped)
	scCore.TriggerServerCallback('lcrp-radio:server:GetItem', function(hasItem)
		for k, v in pairs(QB.Doors) do
			local dist = GetDistanceBetweenCoords(pos, QB.Doors[k].textCoords.x, QB.Doors[k].textCoords.y, QB.Doors[k].textCoords.z)
			if dist < 1.5 then
				if QB.Doors[k].pickable then
					if QB.Doors[k].locked then
						if hasItem then
							closestDoorKey, closestDoorValue = k, v
							TriggerEvent('lcrp-lockpick:client:openLockpick', lockpickFinish)
						else
							scCore.Notification("You are missing an screw driver set", "error")
						end
					else
						scCore.Notification('The door is already unlocked', 'error', 2500)
					end
				else
					scCore.Notification('Door lock is too strong', 'error', 2500)
				end
			end
		end
    end, "screwdriverset")
end)

function lockpickFinish(success)
    if success then
		scCore.Notification('Unlocked!', 'success', 2500)
		setDoorLocking(closestDoorValue, closestDoorKey)
    else
        scCore.Notification('Failed to unlock', 'error', 2500)
    end
end

function setDoorLocking(doorId, key)
	doorId.locking = true
	openDoorAnim()
    SetTimeout(400, function()
		doorId.locking = false
		doorId.locked = not doorId.locked
		TriggerServerEvent('lcrp-doors:server:updateState', key, doorId.locked)
	end)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function IsAuthorized(doorID)
	local PlayerData = scCore.Functions.GetPlayerData()

	for _,job in pairs(doorID.authorizedJobs) do
		if job == PlayerData.job.name then
			return true
		end
	end
	
	return false
end

function openDoorAnim()
    loadAnimDict("anim@heists@keycard@") 
    TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
	SetTimeout(400, function()
		ClearPedTasks(GetPlayerPed(-1))
	end)
end

RegisterNetEvent('lcrp-doors:client:setState')
AddEventHandler('lcrp-doors:client:setState', function(doorID, state)
	QB.Doors[doorID].locked = state
end)

RegisterNetEvent('lcrp-doors:client:setDoors')
AddEventHandler('lcrp-doors:client:setDoors', function(doorList)
	QB.Doors = doorList
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("lcrp-doors:server:setupDoors")
end)