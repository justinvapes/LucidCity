local zones = {
	{['x'] = -837.8238, ['y'] = -104.9415, ['z'] = 28.18537, ['radius'] = 70.0}, -- Spawn Point
    {['x'] = 304.57, ['y'] = -589.02, ['z'] = 43.29, ['radius'] = 70.0}, -- Pillbox Hospital
	-- {['x'] = -212.3634, ['y'] = -1325.48, ['z'] = 30.88615, ['radius'] = 70.0}, -- Bennys
	-- {['x'] = 75.80375, ['y'] = -388.0662, ['z'] = 30.93518, ['radius'] = 70.0}, -- Construction site
	-- {['x'] = -339.123, ['y'] = -133.25, ['z'] = 38.63, ['radius'] = 70.0}, -- Lucid Motors
	-- {['x'] = 1839.35  , ['y'] = 3673.19, ['z'] = 34.27, ['radius'] = 70.0},   
	-- {['x'] = -248.82  , ['y'] = 6330.47, ['z'] = 32.42, ['radius'] = 70.0},
	--{ ['x'] = 00.00, ['y'] = 00.00, ['z'] = 00.00} -- EXAMPLE
}

-- Blip settings
local color = 2 -- Green zone color. Obviously its green
local text = "Green Zone" -- Name of the green zone map blip

-- Settings
local GreenZoneDist = 70.0

-- Locales
local EnteredGreenZone = 'You entered green zone'
local LeftGreenZone = 'You left green zone'
local disabledGreenZone = 'You can\'t do that in a green zone'

-- Dont touch
local notifIn = false
local notifOut = false
local gz = nil
local savedAmmo = false
local closestZone = 1

Citizen.CreateThread(function()
	for k,zone in pairs(zones) do
		coords = vector3(zone.x, zone.y, zone.z)

		local blip = AddBlipForRadius(coords, zone.radius)

		SetBlipHighDetail(blip, true)
		SetBlipColour(blip, 2)
		SetBlipAlpha (blip, 128)
	end
end)

RegisterNetEvent('weapons:client:SetCurrentWeapon')
AddEventHandler('weapons:client:SetCurrentWeapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		sleep = 500
		local player = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(player, true))
		for k,zone in pairs(zones) do
			local dist = Vdist(zone.x, zone.y, zone.z, x, y, z)
			if dist <= GreenZoneDist then
				sleep = 5
				if not savedAmmo then
					local weapon = GetSelectedPedWeapon(player)
					local ammo = GetAmmoInPedWeapon(player, weapon)
					TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, tonumber(ammo))
					savedAmmo = true
					gz = k
				end
				if not notifIn then																		  
					NetworkSetFriendlyFireOption(false)
					ClearPlayerWantedLevel(player)
					SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true)
					notifIn = true
					notifOut = false
				end
			else
				if savedAmmo and k == gz then
					savedAmmo = false
				end
				if not notifOut then
					--SetPlayerInvincible(player, false)
					NetworkSetFriendlyFireOption(true)
					notifOut = true
					notifIn = false
				end
			end
			if notifIn then
				DisableControlAction(2, 37, true) -- disable weapon wheel (Tab)
				DisableControlAction(0, 45, true) -- disable R
				DisableControlAction(0, 80, true) -- disable R
				DisableControlAction(0, 140, true) -- disable R
				DisableControlAction(0, 250, true) -- disable R
				DisableControlAction(0, 263, true) -- disable R
				DisableControlAction(0, 106, true) -- Disable in-game mouse controls
				DisableControlAction(0, 140, true)
				DisableControlAction(0, 141, true)
				DisableControlAction(0, 142, true)
				DisablePlayerFiring(player,true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
				--SetPlayerInvincible(player, true)
				if IsDisabledControlJustPressed(2, 37) then --if Tab is pressed, send error message
					SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true) -- if tab is pressed it will set them to unarmed (this is to cover the vehicle glitch until I sort that all out)
					exports['lcrp-core']:Notification("You can\'t do that in green zone", "error")
				end
				if IsDisabledControlJustPressed(0, 106) then --if LeftClick is pressed, send error message
					SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true) -- If they click it will set them to unarmed
					exports['lcrp-core']:Notification("You can\'t do that in green zone", "error")
				end
			else
				--SetPlayerInvincible(PlayerId(), false)
			end
		end
		Citizen.Wait(sleep)
	end
end)