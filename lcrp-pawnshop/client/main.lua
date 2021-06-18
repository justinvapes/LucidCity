Keys = {
	['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
	['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
	['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
	['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
	['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
	['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
	['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
	['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}
local buyer = {
	model = "ig_terry", 
	x = 115.17, 
    y = -1686.57, 
    z = 32.51, 
    h = 312.06,
}

scCore = nil

Citizen.CreateThread(function()
	while scCore == nil do
		TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    spawnedPed = false
	modelHash = GetHashKey(buyer.model)
	RequestModel(modelHash)

	while not HasModelLoaded(modelHash) do
		Wait(1)
	end

	if not DoesEntityExist(ped) then
		spawnedPed = true
		RequestAnimDict("mini@strip_club@idles@bouncer@base")
		while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
			Wait(1)
		end
		ped =  CreatePed(4, modelHash, buyer.x, buyer.y, buyer.z, 3374176, false, true)
		SetEntityAsMissionEntity(ped)
		SetEntityHeading(ped, buyer.h)
		FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
		TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	end
	-- 'mini@strip_club@idles@bouncer@stop','stop'
	-- "mini@strip_club@idles@bouncer@base","base"
	-- Loop incase ped gets punched n etc
	while spawnedPed do
		sleep = 1000
		entityCoords = GetEntityCoords(PlayerPedId())
		pedCoords = GetEntityCoords(ped)
		distance = GetDistanceBetweenCoords(entityCoords, buyer.x, buyer.y, buyer.z, false)
		pedDistance = GetDistanceBetweenCoords(buyer.x, buyer.y, buyer.z, pedCoords.x, pedCoords.y, pedCoords.z, false)

		if distance <= 2.0 then
			sleep = 5

			if pedDistance > 0.5 or not IsEntityPlayingAnim(ped, "mini@strip_club@idles@bouncer@base","base", 3) then
				SetEntityCoords(ped, buyer.x, buyer.y, buyer.z)
				SetEntityHeading(ped, buyer.h)
				TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
			end
		end
		Citizen.Wait(sleep)
	end
end)

local sellItemsSet = false
local sellPrice = 0
local sellHardwareItemsSet = false
local sellHardwarePrice = 0

function GetSellingPrice()
	local price = 0
	scCore.TriggerServerCallback('lcrp-pawnshop:server:getSellPrice', function(result)
		price = result
	end)
	Citizen.Wait(500)
	return price
end

function GetSellingHardwarePrice()
	local price = 0
	scCore.TriggerServerCallback('lcrp-pawnshop:server:getSellHardwarePrice', function(result)
		price = result
	end)
	Citizen.Wait(500)
	return price
end

RegisterNetEvent("lcrp-pawnshop:client:SellItems")
AddEventHandler("lcrp-pawnshop:client:SellItems", function(pawnshopType)
	if pawnshopType == "pawn" then
		sellPrice = GetSellingPrice()
		if GetClockHours() >= 9 and GetClockHours() <= 16 then
			if sellPrice ~= 0 then
				TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
				scCore.TaskBar("sell_pawn_items", "Selling items", math.random(6000, 9000), false, true, {}, {}, {}, {}, function() -- Done
					ClearPedTasks(GetPlayerPed(-1))
					TriggerServerEvent("lcrp-pawnshop:server:sellPawnItems")
					sellItemsSet = false
					sellPrice = 0
				end, function() -- Cancel
					sellItemsSet = false
					sellPrice = 0
					ClearPedTasks(GetPlayerPed(-1))
					scCore.Notification("Canceled", "error")
				end)
			else
				scCore.Notification("You have nothing to sell!", "error")
			end
		else
			scCore.Notification("Pawnshop is closed, opens at 9:00!", "error")
		end
	elseif pawnshopType == "hardware" then
		sellHardwarePrice = GetSellingHardwarePrice()
		if GetClockHours() >= 9 and GetClockHours() <= 16 then
			if sellHardwarePrice ~= 0 then
				TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
				scCore.TaskBar("sell_pawn_items", "Selling items", math.random(6000, 9000), false, true, {}, {}, {}, {}, function() -- Done
					ClearPedTasks(GetPlayerPed(-1))
					TriggerServerEvent("lcrp-pawnshop:server:sellHardwarePawnItems")
					sellHardwareItemsSet = false
					sellHardwarePrice = 0
				end, function() -- Cancel
					sellHardwareItemsSet = false
					sellHardwarePrice = 0
					ClearPedTasks(GetPlayerPed(-1))
					scCore.Notification("Canceled", "error")
				end)
			else
				scCore.Notification("You have nothing to sell!", "error")
			end
		else
			scCore.Notification("Pawnshop is closed, opens at 9:00!", "error")
		end
	end
end)

Citizen.CreateThread(function()
	local pawnBlip = AddBlipForCoord(115.19, -1686.48, 33.49)
	SetBlipSprite(pawnBlip, 52)
	SetBlipDisplay(pawnBlip, 4)
	SetBlipScale(pawnBlip, 0.7)
	SetBlipAsShortRange(pawnBlip, true)
	SetBlipColour(pawnBlip, 57)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Pawn Shop")
	EndTextCommandSetBlipName(pawnBlip)

	local blip = AddBlipForCoord(182.34, -1319.25, 29.32)
	SetBlipSprite(blip, 52)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 57)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Electronic Pawn Shop")
	EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddBoxZone("PawnHardwareLocation", vector3(182.34, -1319.25, 29.32), 2, 2, {
		name="PawnHardwareLocation",
		heading=335,
		minZ=28.32,
		maxZ=31.32 }, {
		options = {
			{
				event = "lcrp-pawnshop:client:SellItems",
				icon = "far fa-clipboard",
				label = "Sell Electronics",
				duty = false,
				parameters = "hardware",
			},
		},
	job = {"all"}, distance = 1.5 })

	exports["lcrp-interact"]:AddBoxZone("PawnShopLocation", vector3(115.19, -1686.48, 33.49), 2, 2, {
		name="PawnShopLocation",
		heading=320,
		minZ=32.49,
		maxZ=35.09 }, {
		options = {
			{
				event = "lcrp-pawnshop:client:SellItems",
				icon = "far fa-clipboard",
				label = "Sell Jewelry, TV's, Paintings",
				duty = false,
				parameters = "pawn",
			},
		},
	job = {"all"}, distance = 1.5 })
end)