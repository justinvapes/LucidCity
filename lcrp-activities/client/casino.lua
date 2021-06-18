scCore = nil
local blipX = -1400.94
local blipY = -605.00
local blipZ = 29.50
local pic = 'CHAR_SOCIAL_CLUB'
local elements = {}
local lastBetAmount = nil
local lastBet = nil
local casinoTables = {
	-1273284377,
}

local CasinoLocations = {
	elevators = {
		[1] = {x = 922.75, y = 52.20, z = 72.07, minZ=70.97, maxZ=74.17, label = "Go to elevator hallway (rooftop)"},
		[2] = {x = 964.74, y = 58.74, z = 112.55, minZ=111.55, maxZ=114.15, label = "Go to casino level"},
	},
	CasinoExchange = {
		[1] = {x = 949.8195, y = 35.499, z = 71.83, minZ=70.79, maxZ=73.79},
		[2] = {x = -371.71, y = 211.91, z = 81.30, minZ=80.31, maxZ=82.91}
	},
	casinoDuty = {
		[1] = {x = 959.94, y = 34.75, z = 71.84, minZ=71.69, maxZ=72.49, heading = 330, job = "casino", lX = 1.0, lY = 3.8},
		[2] = {x = -381.75, y = 209.60, z = 81.31, minZ=71.69, maxZ=72.49, heading = 0, job = "casinounderground", lX = 2.2, lY = 1.3},
	},
	owner = {
		[1] = {x = 956.87, y = 56.5, z = 75.44, minZ=75.19, maxZ=75.99, heading = 330, job = "casino", lX = 1.0, lY = 3.2},
		[2] = {x = -379.53, y = 206.54, z = 81.31, minZ=81.11, maxZ=81.91, heading = 0, job = "casinounderground", lX = 0.6, lY = 2.0}
	},
}

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent('lcrp-activities:client:openRoulette')
AddEventHandler('lcrp-activities:client:openRoulette', function()
	scCore.TriggerServerCallback('lcrp-activities:server:FetchCasinoChips', function(playerChips)
		if playerChips >= 10 then
			SendNUIMessage({
				type = "show_table",
				zetony = playerChips
			})
			SetNuiFocus(true, true)
		else
			scCore.Notification('You need at least 10 chips to play!', 'error')
			SendNUIMessage({
				type = "reset_bet"
			})
		end
	end)
end)


RegisterNUICallback('exit', function(data, cb)
	cb('ok')
	SetNuiFocus(false, false)
end)

RegisterNUICallback('betup', function(data, cb)
	cb('ok')
	TriggerServerEvent('InteractSound_SV:PlayOnSource', 'betup', 1.0)
end)

RegisterNUICallback('roll', function(data, cb)
	cb('ok')
	TriggerServerEvent('lcrp-activities:server:startRoulette', data.kolor, data.kwota)
	TriggerServerEvent('InteractSound_SV:PlayOnSource', 'roulette', 1.0)
end)

RegisterNetEvent('lcrp-activities:client:playRoulleteAnim')
AddEventHandler('lcrp-activities:client:playRoulleteAnim', function(data, nr)
	if data == 1 then 
		SendNUIMessage({
			type = "show_roulette",
			hwButton = nr
		})
	else
		SendNUIMessage({type = 'hide_roulette'})
		SetNuiFocus(false, false)
	end
end)

RegisterNetEvent("lcrp-activities:client:CasinoElevator")
AddEventHandler('lcrp-activities:client:CasinoElevator', function(action)
	local playerPed = PlayerPedId()

	if action == 1 then
		DoScreenFadeOut(100)
		SetEntityCoords(playerPed, CasinoLocations.elevators[2].x, CasinoLocations.elevators[2].y, CasinoLocations.elevators[2].z, false, false, false, true)  
		SetEntityHeading(playerPed, 235.78) 
		Citizen.Wait(500)
		DoScreenFadeIn(500)
	elseif action == 2 then
		DoScreenFadeOut(100)
		SetEntityCoords(playerPed, CasinoLocations.elevators[1].x, CasinoLocations.elevators[1].y, CasinoLocations.elevators[1].z, false, false, false, true)  
		SetEntityHeading(playerPed, 60.0) 
		Citizen.Wait(500)
		DoScreenFadeIn(500)
	end
end)

RegisterNetEvent("lcrp-activities:client:JobStash")
AddEventHandler("lcrp-activities:client:JobStash", function(action)
	if PlayerJob.name == "casinounderground" then
		if action == 1 then
			TriggerEvent("inventory:client:SetCurrentStash", "undergroundcasino")
			TriggerServerEvent("inventory:server:OpenInventory", "stash", "undergroundcasino", {
				maxweight = 200000,
				slots = 1,
			})
		else
			TriggerEvent("inventory:client:SetCurrentStash", "undergroundcasino_private")
			TriggerServerEvent("inventory:server:OpenInventory", "stash", "undergroundcasino_private", {
				maxweight = 2000000,
				slots = 15,
			})
		end
	end
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddTargetModel(casinoTables, {
      options = {
          {
              event = "lcrp-activities:client:openRoulette",
              icon = "fad fa-sack-dollar",
              label = "Bet On Roulette",
              duty = false,
          },
      },
    job = {"all"}, distance = 1.5})

	for k, chipexchange in pairs(CasinoLocations.CasinoExchange) do
		exports["lcrp-interact"]:AddBoxZone("CasinoExchange"..k, vector3(chipexchange.x, chipexchange.y, chipexchange.z), 2.0, 2.0, {
			name="CasinoExchange"..k,
			heading=0,
			minZ=chipexchange.minZ,
			maxZ=chipexchange.maxZ,
		}, {
			options = {
				{
					event = "lcrp-activities:client:ExchangeCasinoChips",
					icon = "fal fa-cash-register",
					label = "Exchange Casino Chips",
					duty = false,
					serverEvent = true,
				},
			},
		job = {"all"}, distance = 2.0 })
	end

	for k, elevator in pairs(CasinoLocations.elevators) do
		exports["lcrp-interact"]:AddBoxZone("CasinoElevators"..k, vector3(elevator.x, elevator.y, elevator.z), 2.0, 2.0, {
			name="CasinoElevators"..k,
			heading=0,
			minZ=elevator.minZ,
			maxZ=elevator.maxZ,
		}, {
			options = {
				{
					event = "lcrp-activities:client:CasinoElevator",
					icon = "fas fa-sort-circle",
					label = elevator.label,
					duty = false,
					parameters = k,
				},
			},
		job = {"all"}, distance = 2.0 })
	end

	for k, duty in pairs(CasinoLocations.casinoDuty) do
		exports["lcrp-interact"]:AddBoxZone("casinoDuty"..k, vector3(duty.x, duty.y, duty.z), duty.lX, duty.lY, {
			name="casinoDuty"..k,
			heading=duty.heading,
			minZ=duty.minZ,
			maxZ=duty.minX 
		}, {
			options = {
				{
					event = "police:client:Duty",
					icon = "fas fa-address-card",
					label = "Clock in",
					duty = false,
					parameters = "duty",
				},
				{
					event = "police:client:Duty",
					icon = "fas fa-address-card",
					label = "Clock out",
					duty = true,
					parameters = "duty",
				},
			},
		job = {duty.job}, distance = 2.5 })
	end

	for k, owner in pairs(CasinoLocations.owner) do
		exports["lcrp-interact"]:AddBoxZone("CasinoBoss"..k, vector3(owner.x, owner.y, owner.z), owner.lX, owner.lY, {
			name="CasinoBoss"..k,
			heading=owner.heading,
			minZ=owner.minZ,
			maxZ=owner.minX 
		 }, {
			options = {
				{
					event = "police:client:BossActions",
					icon = "fad fa-user-secret",
					label = "Boss Actions",
					duty = true,
				},
			},
		job = {owner.job}, distance = 2.0 })
	end

	exports["lcrp-interact"]:AddBoxZone("CasinoUndergroundStash2", vector3(-377.72, 205.04, 81.31), 0.8, 1.8, {
		name="CasinoUndergroundStash2",
		heading=0,
		minZ=80.31,
		maxZ=82.51 }, {
		options = {
			{
				event = "lcrp-activities:client:JobStash",
				icon = "fas fa-briefcase",
				label = "Open Stash",
				duty = true,
				parameters = 1,
			},
			{
				event = "lcrp-activities:client:JobStash",
				icon = "fas fa-briefcase",
				label = "Open Private Stash",
				duty = true,
				parameters = 2,
			},
		},
	job = {"casinounderground"}, distance = 2.0 })
end)