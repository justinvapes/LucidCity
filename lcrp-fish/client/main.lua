scCore = nil

Citizen.CreateThread(function()
    while scCore == nil do
        TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
        Citizen.Wait(200)
    end
end)

cachedData = {}

RegisterNetEvent("lcrp-fish:tryToFish")
AddEventHandler("lcrp-fish:tryToFish", function()
	TryToFish()
end)

Citizen.CreateThread(function()
	HandleStore()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)

		local ped = PlayerPedId()

		if cachedData["ped"] ~= ped then
			cachedData["ped"] = ped
		end
	end
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddBoxZone("LaSpadaFishRestaurant", vector3(Config.FishingRestaurant["ped"]["x"], Config.FishingRestaurant["ped"]["y"], Config.FishingRestaurant["ped"]["z"]), 2, 2, {
        name="LaSpadaFishRestaurant",
        heading=Config.FishingRestaurant["ped"]["heading"],
        minZ=Config.FishingRestaurant["ped"]["minZ"],
        maxZ=Config.FishingRestaurant["ped"]["maxZ"]
	}, {
        options = {
            {
                event = "lcrp-fish:client:SellFish",
                icon = "fad fa-fish",
                label = "Sell Fish",
                duty = false,
            },
        },
    job = {"all"}, distance = 2.5})
end)