Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

scCore = nil
Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

isLoggedIn = false
inJail = false
jailTime = 0
currentJob = nil
currentLocation = nil
CellsBlip = nil
TimeBlip = nil
ShopBlip = nil
PlayerJob = {}

local inJailClothes = false
local trashModels = {GetHashKey("prop_rub_litter_06")}
local broomModels = {-177104014}

Citizen.CreateThread(function()
    TriggerEvent('lcrp-jail:client:JailAlarm', false)
	while true do 
		Citizen.Wait(7)
		if jailTime > 0  then 
			inJail = true
			Citizen.Wait(1000 * 60)
			if jailTime > 0 and inJail then
				jailTime = jailTime - 1
				if jailTime <= 0 then
					jailTime = 0
					TriggerEvent("chatMessage", "SYSTEM", "warning", "Your time is up! Check yourself out at the visitors center")
				end
				TriggerServerEvent("lcrp-jail:server:SetJailStatus", jailTime)
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
	scCore.TriggerServerCallback('lcrp-jail:server:IsAlarmActive', function(active)
		if active then
			TriggerEvent('lcrp-jail:client:JailAlarm', true)
		end
	end)

	PlayerJob = scCore.Functions.GetPlayerData().job

	-- Freeze door object in laundry room
	Citizen.Wait(5000)
	local doorobject = GetClosestObjectOfType(1779.487, 2610.69, 50.71056, 1.0, 1028191914, false, false, false)
    SetEntityRotation(doorobject, 0.0, 0.0, 370.0, 2, true)
    FreezeEntityPosition(doorobject, true)
end)

function CreateCellsBlip()
	if CellsBlip ~= nil then
		RemoveBlip(CellsBlip)
	end
	CellsBlip = AddBlipForCoord(Config.Locations["yard"].coords.x, Config.Locations["yard"].coords.y, Config.Locations["yard"].coords.z)

	SetBlipSprite (CellsBlip, 238)
	SetBlipDisplay(CellsBlip, 4)
	SetBlipScale  (CellsBlip, 0.8)
	SetBlipAsShortRange(CellsBlip, true)
	SetBlipColour(CellsBlip, 4)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Cell")
	EndTextCommandSetBlipName(CellsBlip)

	if TimeBlip ~= nil then
		RemoveBlip(TimeBlip)
	end
	TimeBlip = AddBlipForCoord(Config.Locations["freedom"].coords.x, Config.Locations["freedom"].coords.y, Config.Locations["freedom"].coords.z)

	SetBlipSprite (TimeBlip, 466)
	SetBlipDisplay(TimeBlip, 4)
	SetBlipScale  (TimeBlip, 0.8)
	SetBlipAsShortRange(TimeBlip, true)
	SetBlipColour(TimeBlip, 4)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Check jailtime")
	EndTextCommandSetBlipName(TimeBlip)

	if ShopBlip ~= nil then
		RemoveBlip(ShopBlip)
	end
	ShopBlip = AddBlipForCoord(Config.Locations["shop"].coords.x, Config.Locations["shop"].coords.y, Config.Locations["shop"].coords.z)

	SetBlipSprite (ShopBlip, 52)
	SetBlipDisplay(ShopBlip, 4)
	SetBlipScale  (ShopBlip, 0.5)
	SetBlipAsShortRange(ShopBlip, true)
	SetBlipColour(ShopBlip, 0)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Canteen")
	EndTextCommandSetBlipName(ShopBlip)
end

function setInJailClothes(status)
	inJailClothes = status
end

function isInJailClothes()
	return inJailClothes
end

RegisterNetEvent("lcrp-jail:client:JailClothes")
AddEventHandler("lcrp-jail:client:JailClothes", function()
	if inJail then
		if scCore.Functions.GetPlayerData().charinfo.gender == 1 then -- FEMALE
			ClothingDataName = {
				outfitData = {
					["torso2"]      = { item = 60, texture = 3},
					["t-shirt"]     = { item = 15, texture = 0},
					["pants"]       = { item = 39, texture = 3},
					["arms"]        = { item = 3, texture = 0},
					["vest"]        = { item = 0, texture = 0},
					["shoes"]       = { item = 24, texture = 0},
					["hat"]         = { item = -1, texture = 0},
					["accessory"]   = { item = -1, texture = 0},
				}
			}
		else -- MALE
			ClothingDataName = {
				outfitData = {
					["torso2"]      = { item = 66, texture = 3},
					["t-shirt"]     = { item = 15, texture = 0},
					["pants"]       = { item = 39, texture = 3},
					["arms"]        = { item = 12, texture = 0},
					["vest"]        = { item = 0, texture = 0},
					["shoes"]       = { item = 6, texture = 0},
					["hat"]         = { item = -1, texture = 0},
					["accessory"]   = { item = -1, texture = 0},
				}
			}
		end
		inJailClothes = true
		TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
	end
end)

RegisterNetEvent("lcrp-jail:client:OpenKantineShop")
AddEventHandler("lcrp-jail:client:OpenKantineShop", function()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["shop"].coords.x, Config.Locations["shop"].coords.y, Config.Locations["shop"].coords.z, true) < 5.0) then
		local ShopItems = {}
		ShopItems.label = "Jail Canteen"
		ShopItems.items = Config.CanteenItems
		ShopItems.slots = #Config.CanteenItems
		TriggerServerEvent("inventory:server:OpenInventory", "shop", "Kantineshop_"..math.random(1, 99), ShopItems)
	end
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
	isLoggedIn = true
	scCore.Functions.GetPlayerData(function(PlayerData)
		if PlayerData.metadata["injail"] > 0 then
			TriggerEvent("lcrp-jail:client:Enter", PlayerData.metadata["injail"])
		end
	end)
end)

RegisterNetEvent('scCore:Client:OnPlayerUnload')
AddEventHandler('scCore:Client:OnPlayerUnload', function()
	isLoggedIn = false
	inJail = false
	inJailClothes = false
	currentJob = nil
	RemoveBlip(currentBlip)
end)

RegisterNetEvent('lcrp-jail:client:Enter')
AddEventHandler('lcrp-jail:client:Enter', function(time)
	scCore.Notification("You're in jail for "..time.." months..", "error")
	TriggerEvent("chatMessage", "SYSTEM", "warning", "Your items has been seized, you'll get everything back when your time is up")
	DoScreenFadeOut(500)
	while not IsScreenFadedOut() do
		Citizen.Wait(10)
	end
	local RandomStartPosition = Config.Locations.spawns[math.random(1, #Config.Locations.spawns)]
	SetEntityCoords(GetPlayerPed(-1), RandomStartPosition.coords.x, RandomStartPosition.coords.y, RandomStartPosition.coords.z - 0.9, 0, 0, 0, false)
	SetEntityHeading(GetPlayerPed(-1), RandomStartPosition.coords.h)
	Citizen.Wait(500)
	TriggerEvent('animations:client:EmoteCommandStart', {RandomStartPosition.animation})

	inJail = true
	jailTime = time
	currentJob = Config.Jobs[math.random(1, #Config.Jobs)].label
	currentLocation = 1
	TriggerEvent("lcrp-jail:client:JailClothes")
	TriggerServerEvent("lcrp-jail:server:SetJailStatus", jailTime)
	TriggerServerEvent("lcrp-jail:server:SaveJailItems", jailTime)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "jail", 0.5)

	CreateCellsBlip()
	Citizen.Wait(2000)
	LoadJob()

	DoScreenFadeIn(1000)
	scCore.Notification("Do some work for sentence reduction, current job: "..currentJob)
end)

RegisterNetEvent('lcrp-jail:client:Leave')
AddEventHandler('lcrp-jail:client:Leave', function()
	if inJail then
		if jailTime > 0 then 
			scCore.Notification("You still have "..jailTime.." months left")
		else
			jailTime = 0
			TriggerServerEvent("lcrp-jail:server:SetJailStatus", 0)
			TriggerServerEvent("lcrp-jail:server:GiveJailItems")
			TriggerServerEvent('lcrp-clothes:get_character_current')
			TriggerServerEvent("lcrp-clothes:retrieve_tats")
			TriggerEvent("chatMessage", "SYSTEM", "warning", "you've received your stuff back.")
			inJail = false
			inJailClothes = false
			RemoveBlip(currentBlip)
			RemoveBlip(CellsBlip)
			CellsBlip = nil
			RemoveBlip(TimeBlip)
			TimeBlip = nil
			RemoveBlip(ShopBlip)
			ShopBlip = nil
			scCore.Notification("You're released, stay safe!")
			DoScreenFadeOut(500)
			while not IsScreenFadedOut() do
				Citizen.Wait(10)
			end
			SetEntityCoords(PlayerPedId(), Config.Locations["outside"].coords.x, Config.Locations["outside"].coords.y, Config.Locations["outside"].coords.z, 0, 0, 0, false)
			SetEntityHeading(PlayerPedId(), Config.Locations["outside"].coords.h)

			Citizen.Wait(500)

			DoScreenFadeIn(1000)
		end
	else
		scCore.Notification("You are not even serving time in jail!", "error")
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end
		SetEntityCoords(PlayerPedId(), Config.Locations["outside"].coords.x, Config.Locations["outside"].coords.y, Config.Locations["outside"].coords.z, 0, 0, 0, false)
		SetEntityHeading(PlayerPedId(), Config.Locations["outside"].coords.h)

		Citizen.Wait(500)

		DoScreenFadeIn(1000)

	end
end)

RegisterNetEvent('lcrp-jail:client:UnjailPerson')
AddEventHandler('lcrp-jail:client:UnjailPerson', function()
	if jailTime > 0 then
		TriggerServerEvent("lcrp-jail:server:SetJailStatus", 0)
		TriggerServerEvent("lcrp-jail:server:GiveJailItems")
		TriggerServerEvent('lcrp-clothes:get_character_current')
		TriggerServerEvent("lcrp-clothes:retrieve_tats")
		TriggerEvent("chatMessage", "SYSTEM", "warning", "You got your stuff back")
		inJail = false
		inJailClothes = false
		RemoveBlip(currentBlip)
		RemoveBlip(CellsBlip)
		CellsBlip = nil
		RemoveBlip(TimeBlip)
		TimeBlip = nil
		RemoveBlip(ShopBlip)
		ShopBlip = nil
		scCore.Notification("You're released, stay safe!")
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end
		SetEntityCoords(PlayerPedId(), Config.Locations["outside"].coords.x, Config.Locations["outside"].coords.y, Config.Locations["outside"].coords.z, 0, 0, 0, false)
		SetEntityHeading(PlayerPedId(), Config.Locations["outside"].coords.h)

		Citizen.Wait(500)

		DoScreenFadeIn(1000)
	end
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    jailJobs = {{
		event = "",
		icon = "",
		label = "Change Job",
		duty = false,
    }}

	for k,v in pairs(Config.Jobs) do
		table.insert(jailJobs, {
			event = "lcrp-jail:client:ChangeJob",
			icon = "fas fa-users-cog",
			label = v.label,
			duty = false,
			parameters = v.label,
		})
    end

    exports["lcrp-interact"]:AddBoxZone("checkJailTime", vector3(Config.Locations["freedom"].coords.x, Config.Locations["freedom"].coords.y, Config.Locations["freedom"].coords.z), 0.8, 3.6, {
        name="checkJailTime",
		heading=0,
		minZ=45.0,
		maxZ=46.6 
	}, {
        options = {
            {
                event = "lcrp-jail:client:Leave",
                icon = "far fa-user-clock",
                label = "Check Jail Time",
                duty = false,
            },
        },
    job = {"all"}, distance = 2.5})

	exports["lcrp-interact"]:AddBoxZone("changeJailJob", vector3(Config.Locations["changeJob"].coords.x, Config.Locations["changeJob"].coords.y, Config.Locations["changeJob"].coords.z), 0.8, 3.6, {
        name="changeJailJob",
		heading=0,
		minZ=49.55,
		maxZ=52.95
	}, {
        options = jailJobs,
		job = {"all"}, distance = 2.5
	})

	exports["lcrp-interact"]:AddBoxZone("jailCanteen", vector3(Config.Locations["shop"].coords.x, Config.Locations["shop"].coords.y, Config.Locations["shop"].coords.z), 2.0, 2.0, {
        name="jailCanteen",
		heading=0,
		minZ=44.5,
		maxZ=47.6 
	}, {
        options = {
            {
                event = "lcrp-jail:client:OpenKantineShop",
                icon = "fad fa-utensils-alt",
                label = "Canteen",
                duty = false,
            },
        },
    job = {"all"}, distance = 2.0})

	exports["lcrp-interact"]:AddBoxZone("guardAlarm", vector3(Config.Locations["guardAlarm"].coords.x, Config.Locations["guardAlarm"].coords.y, Config.Locations["guardAlarm"].coords.z), 2.6, 0.6, {
        name="guardAlarm",
		heading=0,
		minZ=50.35,
		maxZ=50.95
	}, {
        options = {
            {
                event = "lcrp-jail:server:ToggleJailAlarm",
                icon = "fas fa-siren-on",
                label = "Toggle Jail Alarm",
                duty = false,
				serverEvent=true,
            },
        },
    job = {"police"}, distance = 2.0})

	exports["lcrp-interact"]:AddTargetModel(trashModels, {
		options = {
			{
				event = "lcrp-jail:client:DoJanitorTask",
				icon = "far fa-broom",
				label = "Clean",
				duty = false,
			},
		},
	job = {"all"}, distance = 2.5})

	exports["lcrp-interact"]:AddTargetModel(broomModels, {
		options = {
			{
				event = "animations:client:EmoteCommandStart",
				icon = "fas fa-quidditch",
				label = "Pick Up Broom",
				duty = false,
				parameters = {"broom"},
			},
		},
	job = {"all"}, distance = 2.0})

	for k, v in pairs(Config.Locations.jobs["Launder"]) do
		for i = 1, #Config.Locations.jobs["Launder"][k].coords, 1 do
			exports["lcrp-interact"]:AddBoxZone(v.action..i, vector3(v.coords[i].x, v.coords[i].y, v.coords[i].z), v.coords[i].lY, v.coords[i].lZ, {
				name=v.action..i,
				heading=0,
				minZ=49.55,
				maxZ=51.95, 
			}, {
				options = {
					{
						event = "lcrp-jail:client:DoLaundryTask",
						icon = v.icon,
						label = v.label,
						duty = false,
						parameters = {action = k, coords = v.coords[i]}
					},
				},
			job = {"all"}, distance = v.distance})
		end
	end

	exports["lcrp-interact"]:AddBoxZone("PickupSoup", vector3(Config.Locations.jobs["Cook"][1].coords.x, Config.Locations.jobs["Cook"][1].coords.y, Config.Locations.jobs["Cook"][1].coords.z), Config.Locations.jobs["Cook"][1].coords.lY, Config.Locations.jobs["Cook"][1].coords.lZ, {
		name="PickupSoup",
		heading=0,
		minZ=44.8,
		maxZ=47.0,
	}, {
		options = {
			{
				event = "",
				icon = "",
				label = "Pickup Soup Powders",
				duty = false,
			},
			{
				event = "lcrp-jail:client:DoCookTask",
				icon = "fad fa-soup",
				label = "Meatball Soup Powder",
				duty = false,
				parameters = {item = "meatball_soup_powder", location = 1, label = "Meatball Soup Powder"},
			},
			{
				event = "lcrp-jail:client:DoCookTask",
				icon = "fad fa-soup",
				label = "Chicken Soup Powder",
				duty = false,
				parameters = {item = "chicken_soup_powder", location = 1, label = "Chicken Soup Powder"},
			},
			{
				event = "lcrp-jail:client:DoCookTask",
				icon = "fad fa-soup",
				label = "Miso Soup Powder",
				duty = false,
				parameters = {item = "miso_soup_powder", location = 1, label = "Miso Soup Powder"},
			},
		},
	job = {"all"}, distance = Config.Locations.jobs["Cook"][1].coords.dist})

	exports["lcrp-interact"]:AddBoxZone("FillWater", vector3(Config.Locations.jobs["Cook"][2].coords.x, Config.Locations.jobs["Cook"][2].coords.y, Config.Locations.jobs["Cook"][2].coords.z), Config.Locations.jobs["Cook"][2].coords.lY, Config.Locations.jobs["Cook"][2].coords.lZ, {
		name="FillWater",
		heading=0,
		minZ=44.8,
		maxZ=47.0,
	}, {
		options = {
			{
				event = "lcrp-jail:client:DoCookTask",
				icon = "fad fa-soup",
				label = "Fill Cup With Water",
				duty = false,
				parameters = {item = "cup_of_water", location = 2},
			},
		},
	job = {"all"}, distance = Config.Locations.jobs["Cook"][2].coords.dist})

	exports["lcrp-interact"]:AddBoxZone("CookSoup", vector3(Config.Locations.jobs["Cook"][3].coords.x, Config.Locations.jobs["Cook"][3].coords.y, Config.Locations.jobs["Cook"][3].coords.z), Config.Locations.jobs["Cook"][3].coords.lY, Config.Locations.jobs["Cook"][3].coords.lZ, {
		name="CookSoup",
		heading=0,
		minZ=44.8,
		maxZ=47.0,
	}, {
		options = {
			{
				event = "lcrp-jail:server:Cook",
				icon = "fal fa-soup",
				label = "Cook Meatball Soup",
				duty = false,
				serverEvent = true,
				parameters = {item = "meatball_soup", location = 3, label = "Meatball Soup"},
			},
			{
				event = "lcrp-jail:server:Cook",
				icon = "fal fa-soup",
				label = "Cook Chicken Soup",
				duty = false,
				serverEvent = true,
				parameters = {item = "chicken_soup", location = 3, label = "Chicken Soup"},
			},
			{
				event = "lcrp-jail:server:Cook",
				icon = "fal fa-soup",
				label = "Cook Miso Soup",
				duty = false,
				serverEvent = true,
				parameters = {item = "miso_soup", location = 3, label = "Miso Soup"},
			},
		},
	job = {"all"}, distance = Config.Locations.jobs["Cook"][3].coords.dist})

	exports["lcrp-interact"]:AddBoxZone("PlaceSoup", vector3(Config.Locations.jobs["Cook"][4].coords.x, Config.Locations.jobs["Cook"][4].coords.y, Config.Locations.jobs["Cook"][4].coords.z), Config.Locations.jobs["Cook"][4].coords.lY, Config.Locations.jobs["Cook"][4].coords.lZ, {
		name="PlaceSoup",
		heading=0,
		minZ=44.8,
		maxZ=47.0,
	}, {
		options = {
			{
				event = "",
				icon = "",
				label = "Place Soups",
				duty = false,
			},
			{
				event = "lcrp-jail:client:DoCookTask",
				icon = "fal fa-soup",
				label = "Meatball Soup",
				duty = false,
				parameters = {item = "meatball_soup", location = 4, label = "Meatball Soup"},
			},
			{
				event = "lcrp-jail:client:DoCookTask",
				icon = "fal fa-soup",
				label = "Chicken Soup",
				duty = false,
				parameters = {item = "chicken_soup", location = 4, label = "Chicken Soup"},
			},
			{
				event = "lcrp-jail:client:DoCookTask",
				icon = "fal fa-soup",
				label = "Miso Soup",
				duty = false,
				parameters = {item = "miso_soup", location = 4, label = "Miso Soup"},
			},
		},
	job = {"all"}, distance = Config.Locations.jobs["Cook"][4].coords.dist})

	-- Prison guard

	exports["lcrp-interact"]:AddBoxZone("guardArmory", vector3(Config.Locations["guardArmory"].coords.x, Config.Locations["guardArmory"].coords.y, Config.Locations["guardArmory"].coords.z), 3.4, 0.8, {
        name="guardArmory",
		heading=Config.Locations["guardArmory"].coords.h,
		minZ=44.8,
		maxZ=48.0 
	}, {
        options = {
            {
                event = "police:client:Armory",
                icon = "fas fa-shield",
                label = "Armory",
                duty = true,
				parameters = 2,
            },
        },
    job = {"police"}, distance = 2.0})

	exports["lcrp-interact"]:AddBoxZone("guardDuty", vector3(Config.Locations["guardDuty"].coords.x, Config.Locations["guardDuty"].coords.y, Config.Locations["guardDuty"].coords.z), 2.4, 0.8, {
		name="guardDuty",
		heading=Config.Locations["guardDuty"].coords.h,
		minZ=45.8,
		maxZ=47.2 }, {
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
	job = {"police"}, distance = 1.5 })

	exports["lcrp-interact"]:AddBoxZone("guardStash", vector3(Config.Locations["guardStash"].coords.x, Config.Locations["guardStash"].coords.y, Config.Locations["guardStash"].coords.z), 0.6, 2.4, {
		name="guardStash",
		heading=Config.Locations["guardStash"].coords.h,
		minZ=44.8,
		maxZ=46.8
	 }, {
		options = {
			{
				event = "police:client:PersonalStash",
				icon = "fas fa-briefcase",
				label = "Personal Stash",
				duty = true,
				parameters = 2,
			},
		},
	job = {"police"}, distance = 2.0 })

	exports["lcrp-interact"]:AddBoxZone("guardClothing", vector3(Config.Locations["guardClothing"].coords.x, Config.Locations["guardClothing"].coords.y, Config.Locations["guardClothing"].coords.z), 4.8, 3.6, {
        name="guardClothing",
        heading=Config.Locations["guardClothing"].coords.h,
		minZ=44.8,
		maxZ=48.0
	}, {
        options = {
            {
                event = "raid-clothes:OpenClothesMenu",
                icon = "fas fa-tshirt",
                label = "Clothing Menu",
                duty = true,
            },
            {
                event = "police:client:PersonalOutfits",
                icon = "fas fa-tshirt",
                label = "Outfit List",
                duty = true,
            },
        },
    job = {"police"}, distance = 2.5 })
end)