-- Optimizations
local showMap, showBars, showArmor, showOxygen, isOpen, cinematicHud, isPaused
local pulseHealth, pulseArmor, pulseStamina, pulseOxygen
local healthActive, armorActive, hungerActive, thirstActive, stressActive, staminaActive, oxygenActive, microphoneActive, cinematicActive
local healthSwitch, armorSwitch, hungerSwitch, thirstSwitch, stressSwitch, staminaSwitch, oxygenSwitch, microphoneSwitch, cinematicSwitch

-- Variables
local speed = 0.0
local seatbeltOn = false
local cruiseOn = false
local bleedingPercentage = 0
local hunger = 100
local thirst = 100
local whisper, normal, shout = 33, 66, 100 
local microphone = normal -- Change this for default (whisper, normal, shout)

-- Main Thread
CreateThread(function()
	while true do
        local health 			= nil
		local ped 				= PlayerPedId()
		local player 			= PlayerId()
		local oxygen 			= GetPlayerUnderwaterTimeRemaining(player) * Config.oxygenMax
		local stamina 			= 100 - GetPlayerSprintStaminaRemaining(player)
		local armor, id 		= GetPedArmour(ped), GetPlayerServerId(player)
		local fuel              = exports['LegacyFuel']:GetFuel(GetVehiclePedIsIn(GetPlayerPed(-1)))
		local engine            = GetVehicleEngineHealth(GetVehiclePedIsIn(GetPlayerPed(-1)))
		PedCar                  = GetVehiclePedIsIn(ped, false)

		if not GetVehiclePedIsIn(ped, false) or GetVehiclePedIsIn(ped, false) == 0 then
			PedCar = GetVehiclePedIsIn(ped, true)
		end
		carSpeed = math.ceil(GetEntitySpeed(PedCar) * 1.23)

		SendNUIMessage({action = "updateGas", key = "gas", value = fuel})
		SendNUIMessage({action = "updateSpeed", speed = carSpeed})

		if IsEntityDead(ped) then
			health = 0
		else
			health = GetEntityHealth(ped) - 100
		end
		if (oxygen <= 0) then
			oxygen = 0
		end
		
		if not cinematicHud and not isPaused then
			-- if (armor <= 0) then
			-- 	if not armorSwitch then
			-- 		SendNUIMessage({action = 'armorHide'})
			-- 		armorActive = true
			-- 		showArmor = true
			-- 	else
			-- 		SendNUIMessage({action = 'armorShow'})
			-- 		armorActive = false
			-- 		showArmor = false
			-- 	end
			if not armorSwitch then
				SendNUIMessage({action = 'armorShow'})
				armorActive = false
				showArmor = false
			end
		end
		if Config.pulseHud then
			if (health <= Config.pulseStart) and not (health == 0) then
				if not pulseHealth then
					SendNUIMessage({action = 'healthStart'})
					pulseHealth = true
				end
			elseif (health > Config.pulseStart) and pulseHealth then
				SendNUIMessage({action = 'healthStop'})
				pulseHealth = false
			end
			if (armor <= Config.pulseStart) and not (armor == 0) then
				if not pulseArmor then
					SendNUIMessage({action = 'armorStart'})
					pulseArmor = true
				end
			elseif (armor > Config.pulseStart) and pulseArmor then
				SendNUIMessage({action = 'armorStop'})
				pulseArmor = false
			end
			if (stamina <= Config.pulseStart) then 
				if not pulseStamina then
					SendNUIMessage({action = 'staminaStart'})
					pulseStamina = true
				end
			elseif (stamina > Config.pulseStart) and pulseStamina then
				SendNUIMessage({action = 'staminaStop'})
				pulseStamina = false
			end
			if (oxygen <= Config.pulseStart) and not (oxygen == 0) then 
				if not pulseOxygen then
					SendNUIMessage({action = 'oxygenStart'})
					pulseOxygen = true
				end
			elseif (oxygen > Config.pulseStart) and pulseOxygen then
				SendNUIMessage({action = 'staminaStop'})
				pulseStamina = false
			end
		end
		if IsPauseMenuActive() and not isPaused and not isOpen then
			if not healthActive then
				healthActive = true
				SendNUIMessage({action = 'healthHide'})
			end
			if not armorActive then
				armorActive = true
				SendNUIMessage({action = 'armorHide'})
			end
			if not staminaActive then
				staminaActive = true
				SendNUIMessage({action = 'staminaHide'})
			end
			if not hungerActive then
				hungerActive = true
				SendNUIMessage({action = 'hungerHide'})
			end
			if not thirstActive then
				thirstActive = true
				SendNUIMessage({action = 'thirstHide'})
			end
			if not stressActive then
				stressActive = true
				SendNUIMessage({action = 'stressHide'})
			end
			if oxygenActive then
				oxygenActive = false
				SendNUIMessage({action = 'oxygenHide'})
			end
			if microphoneActive then
				microphoneActive = false
				SendNUIMessage({action = 'microphoneHide'})
			end
			if cinematicActive then
				cinematicActive = false
				SendNUIMessage({action = 'cinematicHide'})
			end
			isPaused = true
		elseif not IsPauseMenuActive() and isPaused and not cinematicHud then
			if healthActive and not healthSwitch then
				healthActive = false
				SendNUIMessage({action = 'healthShow'})
			end
			if armorActive and not armorSwitch and not showArmor then
				armorActive = false
				SendNUIMessage({action = 'armorShow'})
			end
			if staminaActive and not staminaSwitch then
				staminaActive = false
				SendNUIMessage({action = 'staminaShow'})
			end
			if hungerActive and not hungerSwitch then
				hungerActive = false
				SendNUIMessage({action = 'hungerShow'})
			end
			if thirstActive and not thirstSwitch then
				thirstActive = false
				SendNUIMessage({action = 'thirstShow'})
			end
			if stressActive and not stressSwitch then
				stressActive = false
				SendNUIMessage({action = 'stressShow'})
			end
			if not oxygenActive and oxygenSwitch and showOxygen then
				oxygenActive = true
				SendNUIMessage({action = 'oxygenShow'})
			end
			if not microphoneActive and microphoneSwitch then
				microphoneActive = true
				SendNUIMessage({action = 'microphoneShow'})
			end
			if not cinematicActive and cinematicSwitch then
				cinematicActive = true
				SendNUIMessage({action = 'cinematicShow'})
			end
			isPaused = false
		elseif not IsPauseMenuActive() and cinematicHud and isPaused then
			if not healthActive then
				healthActive = true
				SendNUIMessage({action = 'healthHide'})
			end
			if not armorActive then
				armorActive = true
				SendNUIMessage({action = 'armorHide'})
			end
			if not staminaActive then
				staminaActive = true
				SendNUIMessage({action = 'staminaHide'})
			end
			if not hungerActive then
				hungerActive = true
				SendNUIMessage({action = 'hungerHide'})
			end
			if not thirstActive then
				thirstActive = true
				SendNUIMessage({action = 'thirstHide'})
			end
			if not stressActive then
				stressActive = true
				SendNUIMessage({action = 'stressHide'})
			end
			if oxygenActive then
				oxygenActive = false
				SendNUIMessage({action = 'oxygenHide'})
			end
			if microphoneActive then
				microphoneActive = false
				SendNUIMessage({action = 'microphoneHide'})
			end
			cinematicActive = true
			SendNUIMessage({action = 'cinematicShow'})
			isPaused = false
		end
		SendNUIMessage({
			action = "hud",
			health = health,
			armor = armor,
			stamina = stamina,
			hunger = hunger,
			thirst = thirst,
			stress = stress,
			stamina = stamina,
			oxygen = oxygen,
			speed = math.ceil(speed),
			fuel = fuel,
			engine = engine,
		})
		Wait(Config.waitTime)
	end
end)

Citizen.CreateThread(function()
    while true do
        if scCore ~= nil and isLoggedIn and LCRPHud.Show then
            local playerPed = GetPlayerPed(-1)
            if IsPedInAnyVehicle(playerPed, false) then
                local vehicle = GetVehiclePedIsIn(playerPed)
                speed = GetEntitySpeed(GetVehiclePedIsIn(playerPed, false)) * 2.236936
                if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                    if GetVehicleClass(vehicle) == 16 or GetVehicleClass(vehicle) == 15 then
                        local randomAmount = math.random(1,10)
                        if randomAmount > 5 and speed >= 60 then
                            TriggerServerEvent("player:UpdateSkill", "add", "flying", 1)
                        end
                    else
                        local randomAmount = math.random(1,10)
                        if randomAmount > 5 and speed >= 60 then
                            TriggerServerEvent("player:UpdateSkill", "add", "driving", 1)
                        end
                    end
                end
                if speed >= Stress.MinimumSpeed then
                    if PlayerJob ~= nil then
                        if PlayerJob.name ~= nil then
                            if not (PlayerJob.name == "airlines" and (GetVehicleClass(vehicle) == 16 or GetVehicleClass(vehicle) == 15)) then
                                TriggerServerEvent('lcrp-hud:Server:GainStress', math.random(1, 2))
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(20000)
    end
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1000)
        if IsPedInAnyVehicle(PlayerPedId()) and isLoggedIn and LCRPHud.Show then
			-- setMinimapPos()
			DisplayRadar(true)
            SetRadarZoom(1200)
            SendNUIMessage({
                action = "car",
                show = true,
            })
			if IsWaypointActive() then
				local dist = (#(GetEntityCoords(PlayerPedId()) - GetBlipCoords(GetFirstBlipInfoId(8))) / 1000) * 0.715
				SendNUIMessage({action = "waypointDistance", show = true, distance = dist})
			else
				SendNUIMessage({action = "waypointDistance", show = false})
			end
        else
			seatbeltOn = false
            DisplayRadar(false)
            SendNUIMessage({
                action = "car",
                show = false,
            })
			SendNUIMessage({
                action = "seatbelt",
                seatbelt = seatbeltOn,
            })
        end
    end
end)

Citizen.CreateThread(function()
	RequestStreamedTextureDict("circlemap", false)
	while not HasStreamedTextureDictLoaded("circlemap") do
		Wait(100)
	end

	AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
	
	SetMinimapClipType(1)
	
	SetMinimapComponentPosition('minimap', 'L', 'B', -0.0160, -0.030, 0.140, 0.23)
	-- SetMinimapComponentPosition('minimap', 'L', 'B', -0.0160, -0.030, 0.140, 0.23)
	SetMinimapComponentPosition('minimap_mask', 'I', 'I', 0.1, 0.95, 0.09, 0.14)
	SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.012, 0.015, 0.2, 0.292)
	
	local minimap = RequestScaleformMovie("minimap")
	SetRadarBigmapEnabled(true, false)
	Wait(0)
	SetRadarBigmapEnabled(false, false)
	  
	SetBlipAlpha(GetNorthRadarBlip(), 0)
    while true do
        Wait(5)
		BeginScaleformMovieMethod(minimap, 'HIDE_SATNAV') -- disable GPS destination distance
        ScaleformMovieMethodAddParamInt(3)
		EndScaleformMovieMethod()
		if IsBigmapActive() or IsBigmapFull() then
            SetBigmapActive(false, false)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if isLoggedIn and LCRPHud.Show and scCore ~= nil then
            scCore.TriggerServerCallback('hospital:GetPlayerBleeding', function(playerBleeding)
                if playerBleeding == 0 then
                    bleedingPercentage = 0
                elseif playerBleeding == 1 then
                    bleedingPercentage = 25
                elseif playerBleeding == 2 then
                    bleedingPercentage = 50
                elseif playerBleeding == 3 then
                    bleedingPercentage = 75
                elseif playerBleeding == 4 then
                    bleedingPercentage = 100
                end
            end)
        end

        Citizen.Wait(2500)
    end
end)

CreateThread(function()
    while isOpen do
        Wait(500)
        DisableControlAction(0, 322, true)
    end
end)

Citizen.CreateThread(function()
    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0) -- Level 0
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0) -- Level 1
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) -- Level 2
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0) -- Level 3
    SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0) -- Level 4
end)

-- NUI + Events
RegisterNUICallback('close', function(event)
	SendNUIMessage({ action = 'hide' })
	SetNuiFocus(false, false)
	isOpen = false
end)

RegisterNUICallback('change', function(data)
    TriggerEvent('PE:change', data.action)
end)

RegisterNetEvent('PE:change')
AddEventHandler('PE:change', function(action)
	if action == "hunger" then
		if not hungerActive then
			hungerActive = true
			hungerSwitch = true
			SendNUIMessage({action = 'hungerHide'})
		else
			hungerActive = false
			hungerSwitch = false
			SendNUIMessage({action = 'hungerShow'})
		end
	elseif action == "thirst" then
		if not thirstActive then
			thirstActive = true
			thirstSwitch = true
			SendNUIMessage({action = 'thirstHide'})
		else
			thirstActive = false
			thirstSwitch = false
			SendNUIMessage({action = 'thirstShow'})
		end
	end
	if action == "stress" then
		if not stressActive then
			stressActive = true
			stressSwitch = true
			SendNUIMessage({action = 'stressHide'})
		else
			stressActive = false
			stressSwitch = false
			SendNUIMessage({action = 'stressShow'})
		end
	end
    if action == "health" then
		if not healthActive then
			healthActive = true
			healthSwitch = true
			SendNUIMessage({action = 'healthHide'})
		else
			healthActive = false
			healthSwitch = false
			SendNUIMessage({action = 'healthShow'})
		end
    elseif action == "armor" then
		if not armorActive then
			armorActive = true
			armorSwitch = true
			SendNUIMessage({action = 'armorHide'})
		else
			armorActive = false
			armorSwitch = false
			SendNUIMessage({action = 'armorShow'})
		end
    elseif action == "stamina" then
		if not staminaActive then
			staminaActive = true
			staminaSwitch = true
			SendNUIMessage({action = 'staminaHide'})
		else
			staminaActive = false
			staminaSwitch = false
			SendNUIMessage({action = 'staminaShow'})
		end
	elseif action == "oxygen" then
		if not oxygenActive then
			oxygenActive = true
			oxygenSwitch = true
			SendNUIMessage({action = 'oxygenShow'})
		else
			oxygenActive = false
			oxygenSwitch = false
			SendNUIMessage({action = 'oxygenHide'})
		end
	elseif action == "map" then
		if not showMap then
			showMap = true
			DisplayRadar(true)
		else
			showMap = false
			DisplayRadar(false)
		end
	elseif action == "cinematic" then
		if not cinematicActive then
			cinematicActive = true
			cinematicSwitch = true
			cinematicHud = true
			if not healthActive then
				healthActive = true
				SendNUIMessage({action = 'healthHide'})
			end
			if not armorActive then
				armorActive = true
				SendNUIMessage({action = 'armorHide'})
			end
			if not staminaActive then
				staminaActive = true
				SendNUIMessage({action = 'staminaHide'})
			end
			if not hungerActive then
				hungerActive = true
				SendNUIMessage({action = 'hungerHide'})
			end
			if not thirstActive then
				thirstActive = true
				SendNUIMessage({action = 'thirstHide'})
			end
			if not stressActive then
				stressActive = true
				SendNUIMessage({action = 'stressHide'})
			end
			if oxygenActive then
				oxygenActive = false
				SendNUIMessage({action = 'oxygenHide'})
			end
			if microphoneActive then
				microphoneActive = false
				SendNUIMessage({action = 'microphoneHide'})
			end
			SendNUIMessage({action = 'cinematicShow'})
		else
			cinematicActive = false
			cinematicSwitch = false
			cinematicHud = false
			if healthActive and not healthSwitch then
				healthActive = false
				SendNUIMessage({action = 'healthShow'})
			end
			if armorActive and not armorSwitch and not showArmor then
				armorActive = false
				SendNUIMessage({action = 'armorShow'})
			end
			if staminaActive and not staminaSwitch then
				staminaActive = false
				SendNUIMessage({action = 'staminaShow'})
			end
			if hungerActive and not hungerSwitch then
				hungerActive = false
				SendNUIMessage({action = 'hungerShow'})
			end
			if thirstActive and not thirstSwitch then
				thirstActive = false
				SendNUIMessage({action = 'thirstShow'})
			end
			if stressActive and not stressSwitch then
				stressActive = false
				SendNUIMessage({action = 'stressShow'})
			end
			if not oxygenActive and oxygenSwitch and showOxygen then
				oxygenActive = true
				SendNUIMessage({action = 'oxygenShow'})
			end
			if not microphoneActive and microphoneSwitch then
				microphoneActive = true
				SendNUIMessage({action = 'microphoneShow'})
			end
			if not cinematicActive and cinematicSwitch then
				cinematicActive = true
				SendNUIMessage({action = 'cinematicShow'})
			end
			SendNUIMessage({action = 'cinematicHide'})
		end
	elseif action == "microphone" then
		if not microphoneActive then
			microphoneActive = true
			microphoneSwitch = true
			SendNUIMessage({action = 'microphoneShow'})
		else
			microphoneActive = false
			microphoneSwitch = false
			SendNUIMessage({action = 'microphoneHide'})
		end
    end
end)

RegisterNetEvent("hud:client:UpdateNeeds")
AddEventHandler("hud:client:UpdateNeeds", function(newHunger, newThirst)
    hunger = newHunger
    thirst = newThirst
end)

RegisterNetEvent("seatbelt:client:ToggleSeatbelt")
AddEventHandler("seatbelt:client:ToggleSeatbelt", function(toggle)
    if toggle == nil then
        seatbeltOn = not seatbeltOn
        SendNUIMessage({
            action = "seatbelt",
            status = seatbeltOn,
        })
    else
        seatbeltOn = toggle
        SendNUIMessage({
            action = "seatbelt",
            status = toggle,
        })
    end
end)

local LastHeading = nil
local Rotating = "left"

RegisterNetEvent('weapons:client:SetCurrentWeapon')
AddEventHandler('weapons:client:SetCurrentWeapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
end)
local savedAmmo = false
Citizen.CreateThread(function()
    while true do
        if IsPedInAnyVehicle(PlayerPedId(), true) then
            sleep = 5

            local ped = PlayerPedId()
            -- local PlayerHeading = GetEntityHeading(ped)
            -- if LastHeading ~= nil then
            --     if PlayerHeading < LastHeading then
            --         Rotating = "right"
            --     elseif PlayerHeading > LastHeading then
            --         Rotating = "left"
            --     end
            -- end
            -- LastHeading = PlayerHeading
            -- SendNUIMessage({
            --     action = "UpdateCompass",
            --     heading = PlayerHeading,
            --     lookside = Rotating,
            -- })
            if not savedAmmo then
                local weapon = GetSelectedPedWeapon(ped)
                if weapon ~= -1569615261 then
                    local ammo = GetAmmoInPedWeapon(ped, weapon)
                    if ammo > 0 then
                        TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, tonumber(ammo))
                    else
                        TriggerEvent('inventory:client:CheckWeapon')
                        TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, 0)
                    end
                    savedAmmo = true
                end
            end
        else
            if savedAmmo then
                savedAmmo = false
            end
            sleep = 500
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if seatbeltOn then
            DisableControlAction(0, 75, true)  -- Disable exit vehicle when stop
            DisableControlAction(27, 75, true) -- Disable exit vehicle when Driving
        end
    end
end)

-- Opening Menu
RegisterCommand('hud', function()
	if not isOpen and not isPaused then
		isOpen = true
		SendNUIMessage({ action = 'show' })
		SetNuiFocus(true, true)
	end
end)

-- RegisterCommand('+levelVoice', function()
-- 	if (microphone == 33) then
-- 		microphone = normal
-- 		SendNUIMessage({
-- 			action = "microphone",
-- 			microphone = microphone
-- 		})
-- 	elseif (microphone == 66) then
-- 		microphone = shout
-- 		SendNUIMessage({
-- 			action = "microphone",
-- 			microphone = microphone
-- 		})
-- 	elseif (microphone == 100) then
-- 		microphone = whisper
-- 		SendNUIMessage({
-- 			action = "microphone",
-- 			microphone = microphone
-- 		})
-- 	end
-- end)

RegisterKeyMapping('hud', 'Open hud menu', 'keyboard', Config.openKey)
-- RegisterKeyMapping('+levelVoice', 'Adjust just the voice range', 'keyboard', Config.voiceKey)

-- Handler
AddEventHandler('playerSpawned', function()
	DisplayRadar(false)
	Wait(Config.waitSpawn)
	SendNUIMessage({ action = 'setPosition' })
	SendNUIMessage({ action = 'setColors' })
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		Wait(Config.waitResource)
		SendNUIMessage({ action = 'setPosition' })
		SendNUIMessage({ action = 'setColors' })
	end
end)
