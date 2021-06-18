scCore = nil

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)
-------------------------------------------------------------------------------
-- FUNCTIONS
-------------------------------------------------------------------------------
local function drawHint(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end



function enterBets()
    local bets = scCore.KeyboardInput("Enter bet value ","", 10)
    if bets and tonumber(bets) ~= nil then
    	TriggerServerEvent('lcrp-slots:BetsAndMoney', tonumber(bets))
    else
		scCore.Notification('You need to enter the amount of chips you want to bet (999999 is max)', 'error')
    end
end
-------------------------------------------------------------------------------
-- NET EVENTS
-------------------------------------------------------------------------------
RegisterNetEvent("lcrp-slots:UpdateSlots")
AddEventHandler("lcrp-slots:UpdateSlots", function(lei)
	SetNuiFocus(true, true)
	open = true
	SendNUIMessage({
		showPacanele = "open",
		coinAmount = tonumber(lei)
	})
end)

-------------------------------------------------------------------------------
-- NUI CALLBACKS
-------------------------------------------------------------------------------
RegisterNUICallback('exitWith', function(data, cb)
	cb('ok')
	SetNuiFocus(false, false)
	open = false
	--TriggerServerEvent("lcrp-slots:PayOutRewards", data.coinAmount)
end)

RegisterNUICallback('payCoins', function(data, cb)
	cb('ok')
	TriggerServerEvent("lcrp-slots:PayCoins", data.coinAmount)
end)

RegisterNUICallback('receiveCoins', function(data, cb)
	cb('ok')
	TriggerServerEvent("lcrp-slots:PayOutRewards", data.coinAmount)
end)

-------------------------------------------------------------------------------
-- THREADS
-------------------------------------------------------------------------------
Citizen.CreateThread(function ()
	SetNuiFocus(false, false)
	open = false

	local wTime = 500
	local x = 1
	while true do
		Citizen.Wait(wTime)
		langaAparat = false

		for i=1, #Config.Slots, 1 do
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.Slots[i].x, Config.Slots[i].y, Config.Slots[i].z, true) < 2  then
				x = i
				wTime = 0
				langaAparat = true
				scCore.ShowHelpNotification('Press ~INPUT_PICKUP~ to play slot machine')
			elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.Slots[x].x, Config.Slots[x].y, Config.Slots[x].z, true) > 4 then
				wTime = 500
			end
		end
	end
end)

Citizen.CreateThread(function ()
	heading = 0
	while true do
		Citizen.Wait(1)
		if open then
			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisableControlAction(0, 24, true) -- Attack
			DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
		elseif IsControlJustReleased(0, 38) and langaAparat then
			enterBets()
		end
		
	end
end)