
scCore = nil

local Keys = {
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

Citizen.CreateThread(function()
	while scCore == nil do
		TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
		Citizen.Wait(0)
	end
end)

local inside = false
local closestHouse

local currHouse = nil
local houseName = nil

local openingDoor = false



local inRobbery = false
local noise = 0
local maxNoise
local policeCalled = false

local isCarrying = false
local spawnedObj = {}

local shiftControl = 21 -- INPUT_SPRINT
local spaceControl = 22 -- INPUT_JUMP
local enterControl = 23 -- INPUT_ENTER
local attackControl = 24 -- INPUT_ATTACK
local aggroControl = 25 -- AIM

local isHacking

local PlayerPed

local inRange,returnPos

local lockpicking = false

local houseObj = {}
local POIOffsets = nil
local usingAdvanced = false

local requiredItemsShowed = false

local requiredItems,ticks,SpawnedHome = {},{},{}

local shells = {
    [1] = 'furnitured_lowapart',
    [2] = 'furnitured_midapart'
}
local exitOffset = {
    [1] = {
        ['x'] = 5.0,
        ['y'] = -1.0,
        ['z'] = -19.0
    },
    [2] = {
        ['x'] = 1.62,
        ['y'] = -9.81,
        ['z'] = -20.0
    },
    [3] = {
        ['x'] = 0.0,
        ['y'] = 0.0,
        ['z'] = 0.0
    }
}

RegisterNetEvent("house-robberies:client:sellItems")
AddEventHandler("house-robberies:client:sellItems", function(data)
    local sellPrice = exports['lcrp-pawnshop']:GetSellingPrice()
    if sellPrice ~= 0 then
        TriggerServerEvent("lcrp-pawnshop:server:sellPawnItems")
    else
        scCore.Notification('You have nothing to give me','error')
    end
end)

RegisterNetEvent("house-robberies:client:pickupItem")
AddEventHandler("house-robberies:client:pickupItem", function(data)
    if inside then
        if not Config.RobberyHouses[data.houseName]["pickableItems"][data.item]["stolen"] then
            TriggerServerEvent('lcrp-robberies:server:itemStolen', data.houseName, data.item)
        else
            scCore.Notification("Someone is already on it!","error")
        end
    end
end)

RegisterNetEvent("house-robberies:client:search")
AddEventHandler("house-robberies:client:search", function(cabin)
    if inside then
        if not Config.RobberyHouses[houseName]["furniture"][cabin]["isBusy"] then
            searchCabin(cabin)
        else
            scCore.Notification("Someone is already on it!","error")
        end
    end
end)

RegisterNetEvent("house-robberies:client:hack")
AddEventHandler("house-robberies:client:hack", function(data)
    if inside then
        scCore.Functions.GetPlayerData(function(PlayerData)
            local found = false
            for k,v in pairs(PlayerData.items) do
                if v.info ~= nil then
                    if v.info.type == 'Registered' and v.info.firstname == PlayerData.charinfo.firstname and v.info.lastname == PlayerData.charinfo.lastname and v.name == 'cryptostick' then
                        found = true
                        if not Config.RobberyHouses[houseName][data]["searched"] then
                            startHack('hackdesk',v)
                        else
                            scCore.Notification("Someone is already on it!","error")
                        end
                        break        
                    end
                end
            end
            if not found then
                scCore.Notification("You don't have a Cryptostick registered to your name in your inventory",'error')
            end
        end)
    end
end)

RegisterNetEvent("house-robberies:client:exit")
AddEventHandler("house-robberies:client:exit", function(tier)
    leaveRobberyHouse()
end)

RegisterNetEvent("house-robberies:client:enter")
AddEventHandler("house-robberies:client:enter", function(data)
    if Config.RobberyHouses[data.house]["opened"] then
        enterRobberyHouse(data.house)
    end
end)


RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddBoxZone("jamestownstpainting1", vector3(492.27, -1823.02, 9.21), 0.2, 1, {
        name="jamestownstpainting1",
        heading=0,
        --debugPoly=true,
        minZ=8.81,
        maxZ=9.81 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup Painting",
				duty = false,
                stolen = false,
				parameters = {houseName = "JamestownSt", item = "painting1"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("jamestownsttv1", vector3(498.22, -1825.43, 9.21), 0.6, 0.6, {
        name="jamestownsttv1",
        heading=0,
        --debugPoly=true,
        minZ=8.81,
        maxZ=9.41 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup TV",
				duty = false,
                stolen = false,
				parameters = {houseName = "JamestownSt", item = "tv1"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("jamestownst1", vector3(496.61, -1825.46, 9.21), 0.8, 1.25, {
        name="jamestownst1",
        heading=0,
        --debugPoly=true,
        minZ=8.01,
        maxZ=9.21 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 1,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("jamestownst2", vector3(491.64, -1818.52, 9.21), 1.4, 1.6, {
        name="jamestownst2",
        heading=315,
        --debugPoly=true,
        minZ=7.71,
        maxZ=9.11 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 2,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("jamestownst3", vector3(499.26, -1818.31, 9.21), 1.0, 1.8, {
        name="jamestownst3",
        heading=0,
        --debugPoly=true,
        minZ=8.01,
        maxZ=9.41 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 3,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("jamestownst4", vector3(501.82, -1823.36, 9.21), 1.6, 1, {
        name="jamestownst4",
        heading=0,
        --debugPoly=true,
        minZ=8.01,
        maxZ=9.61 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 4,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("jamestownExit", vector3(500.37, -1825.24, 9.21), 1.0, 1.4, {
        name="jamestownExit",
        heading=0,
        --debugPoly=true,
        minZ=7.81,
        maxZ=10.61 }, {
		options = {
			{
				event = "house-robberies:client:exit",
				icon = "fas fa-house-leave",
				label = "Leave House",
				duty = false,
                parameters = 1
			},
		},
	job = {"all"}, distance = 1.5 })

    ---- BAYCITYAVE

    exports["lcrp-interact"]:AddBoxZone("baycityavepainting1", vector3(-1228.98, -1208.65, -11.32), 0.4, 0.8, {
        name="baycityavepainting1",
        heading=0,
        --debugPoly=true,
        minZ=-11.72,
        maxZ=-10.52 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup Painting",
				duty = false,
                stolen = false,
				parameters = {houseName = "BayCityAve", item = "painting1"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("baycityavetv1", vector3(-1223.11, -1211.18, -11.32), 0.6, 0.6, {
        name="baycityavetv1",
        heading=0,
        --debugPoly=true,
        minZ=-11.92,
        maxZ=-11.12 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup TV",
				duty = false,
                stolen = false,
				parameters = {houseName = "BayCityAve", item = "tv1"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("baycityave1", vector3(-1224.67, -1211.17, -11.32), 0.8, 1.2, {
        name="baycityave1",
        heading=0,
        --debugPoly=true,
        minZ=-12.52,
        maxZ=-11.12 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 1,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("baycityave2", vector3(-1229.71, -1204.17, -11.32), 1.4, 1.8, {
        name="baycityave2",
        heading=315,
        --debugPoly=true,
        minZ=-12.52,
        maxZ=-11.52 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 2,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("baycityave3", vector3(-1222.07, -1204.12, -11.32), 1.0, 1.8, {
        name="baycityave3",
        heading=0,
        --debugPoly=true,
        minZ=-12.52,
        maxZ=-11.12 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 3,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("baycityave4", vector3(-1219.39, -1209.13, -11.32), 1.6, 1, {
        name="baycityave4",
        heading=0,
        --debugPoly=true,
        minZ=-12.52,
        maxZ=-10.92 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 4,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("baycityaveExit", vector3(-1220.95, -1210.78, -11.32), 0.8, 1.4, {
        name="baycityaveExit",
        heading=0,
        --debugPoly=true,
        minZ=-12.52,
        maxZ=-9.92 }, {
		options = {
			{
				event = "house-robberies:client:exit",
				icon = "fas fa-house-leave",
				label = "Leave House",
				duty = false,
                parameters = 1
			},
		},
	job = {"all"}, distance = 1.5 })

    ---- ProcopioDr

    exports["lcrp-interact"]:AddBoxZone("procopiodrpainting1", vector3(-275.61, 6401.33, 11.85), 0.2, 0.8, {
        name="procopiodrpainting1",
        heading=0,
        --debugPoly=true,
        minZ=11.65,
        maxZ=12.65 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup Painting",
				duty = false,
                stolen = false,
				parameters = {houseName = "ProcopioDr", item = "painting1"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("procopiodrtv1", vector3(-269.72, 6398.91, 11.85), 0.6, 0.6, {
        name="procopiodrtv1",
        heading=0,
        --debugPoly=true,
        minZ=11.45,
        maxZ=12.05 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup TV",
				duty = false,
                stolen = false,
				parameters = {houseName = "ProcopioDr", item = "tv1"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("procopiodr1", vector3(-266.14, 6400.97, 11.85), 1.6, 1, {
        name="procopiodr1",
        heading=0,
        --debugPoly=true,
        minZ=10.85,
        maxZ=12.25 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 1,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("procopiodr2", vector3(-276.34, 6405.87, 11.85), 1.4, 1.6, {
        name="procopiodr2",
        heading=315,
        --debugPoly=true,
        minZ=10.65,
        maxZ=12.65 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 2,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("procopiodr3", vector3(-268.72, 6406.08, 11.85), 1.0, 2.0, {
        name="procopiodr3",
        heading=0,
        --debugPoly=true,
        minZ=10.65,
        maxZ=12.05 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 3,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("procopiodr4", vector3(-271.31, 6398.86, 11.85), 0.8, 1.2, {
        name="procopiodr4",
        heading=0,
        --debugPoly=true,
        minZ=10.45,
        maxZ=11.85 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 4,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("procopiodrExit", vector3(-267.54, 6399.31, 11.85), 0.6, 1.4, {
        name="procopiodrExit",
        heading=0,
        --debugPoly=true,
        minZ=10.65,
        maxZ=13.25 }, {
		options = {
			{
				event = "house-robberies:client:exit",
				icon = "fas fa-house-leave",
				label = "Leave House",
				duty = false,
                parameters = 1
			},
		},
	job = {"all"}, distance = 1.5 })

    ---- PicturePerfectDrive

    exports["lcrp-interact"]:AddBoxZone("pictureperfectdrivepainting2", vector3(-780.22, 469.74, 79.65), 0.6, 0.8, {
        name="pictureperfectdrivepainting2",
        heading=0,
        --debugPoly=true,
        minZ=80.05,
        maxZ=81.25 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup Painting",
				duty = false,
                stolen = false,
				parameters = {houseName = "PicturePerfectDrive", item = "painting2"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("pictureperfectdrivetv2", vector3(-778.3, 462.05, 79.65), 0.8, 1.2, {
        name="pictureperfectdrivetv2",
        heading=0,
        --debugPoly=true,
        minZ=79.25,
        maxZ=80.45 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup TV",
				duty = false,
                stolen = false,
				parameters = {houseName = "PicturePerfectDrive", item = "tv2"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("pictureperfectdrive1", vector3(-792.16, 463.8, 79.65), 0.8, 1, {
        name="pictureperfectdrive1",
        heading=0,
        --debugPoly=true,
        minZ=78.45,
        maxZ=80.65 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 1,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("pictureperfectdrive2", vector3(-784.06, 460.51, 79.65), 1.4, 1, {
        name="pictureperfectdrive2",
        heading=0,
        --debugPoly=true,
        minZ=78.65,
        maxZ=79.85 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 2,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("pictureperfectdrive3", vector3(-787.15, 458.2, 79.65), 1.0, 1.6, {
        name="pictureperfectdrive3",
        heading=0,
        --debugPoly=true,
        minZ=78.45,
        maxZ=79.85 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 3,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("pictureperfectdrive4", vector3(-776.9, 463.3, 79.65), 1.2, 1, {
        name="pictureperfectdrive4",
        heading=0,
        --debugPoly=true,
        minZ=78.45,
        maxZ=79.85 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 4,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("pictureperfectdrive5", vector3(-780.95, 467.18, 79.65), 0.65, 1, {
        name="pictureperfectdrive5",
        heading=0,
        --debugPoly=true,
        minZ=78.45,
        maxZ=79.85 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 5,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("pictureperfectdrivehackdesk", vector3(-779.07, 454.7, 79.65), 2.8, 1.2, {
        name="pictureperfectdrivehackdesk",
        heading=0,
        --debugPoly=true,
        minZ=78.45,
        maxZ=80.45 }, {
		options = {
			{
				event = "house-robberies:client:hack",
				icon = "fas fa-usb-drive",
				label = "Attempt hack",
				duty = false,
                stolen = false,
				parameters = "hackdesk",
			},
		},
	job = {"all"}, distance = 2.5 })

    exports["lcrp-interact"]:AddBoxZone("pictureperfectdriveExit", vector3(-783.07, 448.78, 79.65), 0.8, 1.4, {
        name="pictureperfectdriveExit",
        heading=0,
        --debugPoly=true,
        minZ=78.65,
        maxZ=81.05 }, {
		options = {
			{
				event = "house-robberies:client:exit",
				icon = "fas fa-house-leave",
				label = "Leave House",
				duty = false,
                parameters = 2
			},
		},
	job = {"all"}, distance = 2.0 })

    ---- MiltonRD

    exports["lcrp-interact"]:AddBoxZone("miltonrdpainting2", vector3(-532.45, 829.1, 176.99), 1, 1, {
        name="miltonrdpainting2",
        heading=0,
        --debugPoly=true,
        minZ=177.39,
        maxZ=178.59 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup Painting",
				duty = false,
                stolen = false,
				parameters = {houseName = "MiltonRD", item = "painting2"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("miltonrdtv2", vector3(-530.48, 821.37, 176.99), 1.0, 1.4, {
        name="miltonrdtv2",
        heading=0,
        --debugPoly=true,
        minZ=176.59,
        maxZ=177.99 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup TV",
				duty = false,
                stolen = false,
				parameters = {houseName = "MiltonRD", item = "tv2"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("miltonrd1", vector3(-536.1, 819.73, 176.99), 1.4, 0.8, {
        name="miltonrd1",
        heading=0,
        --debugPoly=true,
        minZ=175.99,
        maxZ=177.39 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 1,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("miltonrd2", vector3(-529.11, 822.48, 176.99), 1.2, 1, {
        name="miltonrd2",
        heading=0,
        --debugPoly=true,
        minZ=175.99,
        maxZ=176.99 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 2,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("miltonrd3", vector3(-539.31, 817.45, 176.99), 1.0, 1.6, {
        name="miltonrd3",
        heading=0,
        --debugPoly=true,
        minZ=175.99,
        maxZ=177.39 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 3,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("miltonrd4", vector3(-533.09, 826.39, 176.99), 0.65, 0.8, {
        name="miltonrd4",
        heading=0,
        --debugPoly=true,
        minZ=175.94,
        maxZ=177.14 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 4,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("miltonrd5", vector3(-544.27, 822.99, 176.99), 0.8, 1, {
        name="miltonrd5",
        heading=0,
        --debugPoly=true,
        minZ=175.99,
        maxZ=177.59 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 5,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("miltonrdhackdesk", vector3(-531.13, 813.87, 176.99), 2.8, 2.4, {
        name="miltonrdhackdesk",
        heading=0,
        --debugPoly=true,
        minZ=175.99,
        maxZ=177.59 }, {
		options = {
			{
				event = "house-robberies:client:hack",
				icon = "fas fa-usb-drive",
				label = "Attempt hack",
				duty = false,
                stolen = false,
				parameters = "hackdesk"
			},
		},
	job = {"all"}, distance = 2.5 })

    exports["lcrp-interact"]:AddBoxZone("miltonrdExit", vector3(-535.26, 808.01, 176.99), 0.8, 1.4, {
        name="miltonrdExit",
        heading=0,
        --debugPoly=true,
        minZ=175.99,
        maxZ=178.59 }, {
		options = {
			{
				event = "house-robberies:client:exit",
				icon = "fas fa-house-leave",
				label = "Leave House",
				duty = false,
                parameters = 2
			},
		},
	job = {"all"}, distance = 2.0 })

    ---- EastMirrorDr

    exports["lcrp-interact"]:AddBoxZone("eastmirrordrpainting2", vector3(1233.87, -714.92, 40.43), 0.4, 1.0, {
        name="eastmirrordrpainting2",
        heading=0,
        --debugPoly=true,
        minZ=40.83,
        maxZ=42.03 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup Painting",
				duty = false,
                stolen = false,
				parameters = {houseName = "MiltonRD", item = "painting2"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("eastmirrordrtv2", vector3(1235.76, -722.44, 40.43), 0.6, 1.2, {
        name="eastmirrordrtv2",
        heading=0,
        --debugPoly=true,
        minZ=40.03,
        maxZ=41.23 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup TV",
				duty = false,
                stolen = false,
				parameters = {houseName = "MiltonRD", item = "tv2"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("eastmirrordr1", vector3(1230.06, -724.11, 40.43), 1.4, 1, {
        name="eastmirrordr1",
        heading=0,
        --debugPoly=true,
        minZ=39.23,
        maxZ=40.63 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 1,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("eastmirrordr2", vector3(1237.19, -721.33, 40.43), 1.2, 1, {
        name="eastmirrordr2",
        heading=0,
        --debugPoly=true,
        minZ=39.23,
        maxZ=40.43 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 2,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("eastmirrordr3", vector3(1226.94, -726.4, 40.43), 1.0, 1.6, {
        name="eastmirrordr3",
        heading=0,
        --debugPoly=true,
        minZ=39.03,
        maxZ=40.83 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 3,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("eastmirrordr4", vector3(1233.22, -717.46, 40.43), 0.7, 1, {
        name="eastmirrordr4",
        heading=359,
        --debugPoly=true,
        minZ=39.23,
        maxZ=40.83 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 4,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("eastmirrordr5", vector3(1221.95, -720.84, 40.43), 0.8, 1, {
        name="eastmirrordr5",
        heading=0,
        --debugPoly=true,
        minZ=38.83,
        maxZ=41.03 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 5,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("eastmirrordrhackdesk", vector3(1234.92, -729.98, 40.43), 2.8, 2.0, {
        name="eastmirrordrhackdesk",
        heading=0,
        --debugPoly=true,
        minZ=39.23,
        maxZ=41.03 }, {
		options = {
			{
				event = "house-robberies:client:hack",
				icon = "fas fa-usb-drive",
				label = "Attempt hack",
				duty = false,
                stolen = false,
				parameters = "hackdesk"
			},
		},
	job = {"all"}, distance = 2.5 })

    exports["lcrp-interact"]:AddBoxZone("eastmirrordrExit", vector3(1231.05, -735.76, 40.43), 0.6, 1.4, {
        name="eastmirrordrExit",
        heading=0,
        --debugPoly=true,
        minZ=39.23,
        maxZ=41.83 }, {
		options = {
			{
				event = "house-robberies:client:exit",
				icon = "fas fa-house-leave",
				label = "Leave House",
				duty = false,
                parameters = 2
			},
		},
	job = {"all"}, distance = 2.0 })

    ---- RockfordHills
    exports["lcrp-interact"]:AddBoxZone("rockfordhillsbust", vector3(-787.11, 334.47, 211.2), 1, 1, {
        name="rockfordhillsbust",
        heading=0,
        --debugPoly=true,
        minZ=210.2,
        maxZ=212.0 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup Bust",
				duty = false,
                stolen = false,
				parameters = {houseName = "RockfordHills", item = "bust"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("rockfordhillspainting1", vector3(-787.51, 341.58, 211.2), 0.8, 0.4, {
        name="rockfordhillspainting1",
        heading=0,
        --debugPoly=true,
        minZ=211.2,
        maxZ=212.2 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup Painting",
				duty = false,
                stolen = false,
				parameters = {houseName = "RockfordHills", item = "painting1"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("rockfordhillspainting2", vector3(-761.56, 330.38, 211.4), 0.8, 0.6, {
        name="rockfordhillspainting2",
        heading=0,
        --debugPoly=true,
        minZ=211.2,
        maxZ=212.4 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup Painting",
				duty = false,
                stolen = false,
				parameters = {houseName = "RockfordHills", item = "painting2"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("rockfordhillspainting3", vector3(-772.23, 333.41, 211.4), 0.8, 0.4, {
        name="rockfordhillspainting3",
        heading=0,
        --debugPoly=true,
        minZ=211.2,
        maxZ=212.4 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup Painting",
				duty = false,
                stolen = false,
				parameters = {houseName = "RockfordHills", item = "painting3"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("rockfordhills1", vector3(-762.83, 326.49, 211.4), 0.8, 1.8, {
        name="rockfordhills1",
        heading=0,
        --debugPoly=true,
        minZ=210.4,
        maxZ=211.6 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 1,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("rockfordhills2", vector3(-789.18, 333.93, 210.83), 3.2, 1, {
        name="rockfordhills2",
        heading=0,
        --debugPoly=true,
        minZ=209.83,
        maxZ=211.03 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 2,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("rockfordhills3", vector3(-795.15, 335.55, 210.8), 1, 1, {
        name="rockfordhills3",
        heading=0,
        --debugPoly=true,
        minZ=209.6,
        maxZ=210.6 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 3,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("rockfordhills4", vector3(-790.68, 329.92, 210.8), 1, 1.6, {
        name="rockfordhills4",
        heading=0,
        --debugPoly=true,
        minZ=209.8,
        maxZ=211.2 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 4,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("rockfordhills5", vector3(-795.05, 332.25, 210.8), 1, 1, {
        name="rockfordhills5",
        heading=0,
        --debugPoly=true,
        minZ=209.8,
        maxZ=210.8 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 5,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("rockfordhills6", vector3(-795.07, 326.47, 210.8), 3.4, 1, {
        name="rockfordhills6",
        heading=0,
        --debugPoly=true,
        minZ=209.8,
        maxZ=211.0 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 6,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("rockfordhills7", vector3(-787.04, 337.85, 211.2), 3.0, 1, {
        name="rockfordhills7",
        heading=0,
        --debugPoly=true,
        minZ=210.2,
        maxZ=211.4 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 7,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("rockfordhills8", vector3(-770.21, 334.84, 211.4), 0.4, 2.0, {
        name="rockfordhills8",
        heading=0,
        --debugPoly=true,
        minZ=210.0,
        maxZ=213.0 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 8,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("rockfordhills9", vector3(-768.77, 339.87, 211.4), 2.0, 1.2, {
        name="rockfordhills9",
        heading=0,
        --debugPoly=true,
        minZ=210.4,
        maxZ=211.8 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 9,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("rockfordhillshackdesk", vector3(-764.49, 333.59, 211.4), 1.0, 1.65, {
        name="rockfordhillshackdesk",
        heading=0,
        --debugPoly=true,
        minZ=210.4,
        maxZ=212.0 }, {
		options = {
			{
				event = "house-robberies:client:hack",
				icon = "fas fa-usb-drive",
				label = "Attempt hack",
				duty = false,
                stolen = false,
				parameters = "hackdesk"
			},
		},
	job = {"all"}, distance = 2.5 })

    exports["lcrp-interact"]:AddBoxZone("rockfordhillsExit", vector3(-785.7, 323.66, 212.0), 1.8, 1, {
        name="rockfordhillsExit",
        heading=0,
        --debugPoly=true,
        minZ=211.0,
        maxZ=213.6 }, {
		options = {
			{
				event = "house-robberies:client:exit",
				icon = "fas fa-house-leave",
				label = "Leave House",
				duty = false,
                parameters = 3
			},
		},
	job = {"all"}, distance = 2.0 })

    ---- DidionDr
    exports["lcrp-interact"]:AddBoxZone("didiondrbust", vector3(-769.48, 316.47, 170.6), 0.8, 1, {
        name="didiondrbust",
        heading=0,
        --debugPoly=true,
        minZ=169.6,
        maxZ=171.6 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup Bust",
				duty = false,
                stolen = false,
				parameters = {houseName = "DidionDr", item = "bust"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("didiondrpainting1", vector3(-766.61, 322.77, 170.6), 0.8, 0.2, {
        name="didiondrpainting1",
        heading=0,
        --debugPoly=true,
        minZ=170.4,
        maxZ=171.6 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup Painting",
				duty = false,
                stolen = false,
				parameters = {houseName = "DidionDr", item = "painting1"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("didiondrpainting2", vector3(-757.57, 324.74, 175.4), 0.8, 1.0, {
        name="didiondrpainting2",
        heading=0,
        --debugPoly=true,
        minZ=175.4,
        maxZ=176.4 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup Painting",
				duty = false,
                stolen = false,
				parameters = {houseName = "DidionDr", item = "painting2"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("didiondrpainting3", vector3(-776.04, 323.1, 173.0), 1.0, 0.8, {
        name="didiondrpainting3",
        heading=0,
        --debugPoly=true,
        minZ=173.0,
        maxZ=174.0 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup Painting",
				duty = false,
                stolen = false,
				parameters = {houseName = "DidionDr", item = "painting3"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("didiondr1", vector3(-758.91, 316.77, 170.6), 1.2, 1, {
        name="didiondr1",
        heading=0,
        --debugPoly=true,
        minZ=169.6,
        maxZ=170.6 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 1,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("didiondr2", vector3(-762.67, 322.19, 170.6), 1.0, 2.1, {
        name="didiondr2",
        heading=0,
        --debugPoly=true,
        minZ=169.6,
        maxZ=170.8 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 2,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("didiondr3", vector3(-760.62, 327.6, 170.61), 1.0, 2.2, {
        name="didiondr3",
        heading=0,
        --debugPoly=true,
        minZ=169.61,
        maxZ=170.81 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 3,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("didiondr4", vector3(-771.64, 329.05, 176.81), 2.0, 0.8, {
        name="didiondr4",
        heading=0,
        --debugPoly=true,
        minZ=175.61,
        maxZ=177.01 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 4,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("didiondr5", vector3(-757.61, 314.51, 175.4), 0.8, 2.6, {
        name="didiondr5",
        heading=0,
        --debugPoly=true,
        minZ=174.4,
        maxZ=175.6 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 5,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("didiondr6", vector3(-753.77, 314.45, 175.4), 0.8, 2.6, {
        name="didiondr6",
        heading=0,
        --debugPoly=true,
        minZ=174.4,
        maxZ=175.4 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 6,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("didiondr7", vector3(-754.51, 331.72, 175.4), 0.6, 3.0, {
        name="didiondr7",
        heading=0,
        --debugPoly=true,
        minZ=174.4,
        maxZ=175.6 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 7,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("didiondr8", vector3(-764.76, 326.39, 175.4), 0.8, 2.8, {
        name="didiondr8",
        heading=0,
        --debugPoly=true,
        minZ=174.4,
        maxZ=175.8 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 8,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("didiondr9", vector3(-770.06, 328.41, 175.4), 2.8, 1.2, {
        name="didiondr9",
        heading=0,
        --debugPoly=true,
        minZ=174.2,
        maxZ=175.6 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 9,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("didiondrhackdesk", vector3(-778.6, 329.12, 176.8), 2.2, 1.2, {
        name="didiondrhackdesk",
        heading=0,
        --debugPoly=true,
        minZ=175.8,
        maxZ=177.4 }, {
		options = {
			{
				event = "house-robberies:client:hack",
				icon = "fas fa-usb-drive",
				label = "Attempt hack",
				duty = false,
                stolen = false,
				parameters = "hackdesk"
			},
		},
	job = {"all"}, distance = 2.5 })

    exports["lcrp-interact"]:AddBoxZone("didiondrExit", vector3(-781.92, 326.17, 176.8), 2.8, 2.8, {
        name="didiondrExit",
        heading=0,
        --debugPoly=true,
        minZ=175.8,
        maxZ=178.2 }, {
		options = {
			{
				event = "house-robberies:client:exit",
				icon = "fas fa-house-leave",
				label = "Leave House",
				duty = false,
                parameters = 3
			},
		},
	job = {"all"}, distance = 2.0 })

    ---- StrangewaysDr
    exports["lcrp-interact"]:AddBoxZone("strangewaysdrbust", vector3(-780.43, 335.09, 156.2), 0.8, 0.8, {
        name="strangewaysdrbust",
        heading=0,
        --debugPoly=true,
        minZ=155.2,
        maxZ=157.0 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup Bust",
				duty = false,
                stolen = false,
				parameters = {houseName = "StrangewaysDr", item = "bust"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("strangewaysdrpainting1", vector3(-798.18, 332.37, 158.6), 1.0, 0.8, {
        name="strangewaysdrpainting1",
        heading=0,
        --debugPoly=true,
        minZ=158.45,
        maxZ=159.65 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup Painting",
				duty = false,
                stolen = false,
				parameters = {houseName = "StrangewaysDr", item = "painting1"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("strangewaysdrpainting2", vector3(-780.7, 343.32, 156.2), 1, 1, {
        name="strangewaysdrpainting2",
        heading=0,
        --debugPoly=true,
        minZ=156.05,
        maxZ=157.25 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup Painting",
				duty = false,
                stolen = false,
				parameters = {houseName = "StrangewaysDr", item = "painting2"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("strangewaysdrpainting3", vector3(-786.52, 341.5, 153.79), 0.8, 0.75, {
        name="strangewaysdrpainting3",
        heading=359,
        --debugPoly=true,
        minZ=153.74,
        maxZ=154.79 }, {
		options = {
			{
				event = "house-robberies:client:pickupItem",
				icon = "far fa-person-carry",
				label = "Pickup Painting",
				duty = false,
                stolen = false,
				parameters = {houseName = "StrangewaysDr", item = "painting3"},
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("strangewaysdr1", vector3(-795.86, 330.08, 153.8), 1.0, 2.2, {
        name="strangewaysdr1",
        heading=0,
        --debugPoly=true,
        minZ=152.8,
        maxZ=154.0 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 1,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("strangewaysdr2", vector3(-793.8, 335.45, 153.79), 1.0, 2.0, {
        name="strangewaysdr2",
        heading=0,
        --debugPoly=true,
        minZ=152.79,
        maxZ=153.99 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 2,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("strangewaysdr3", vector3(-797.49, 340.85, 153.79), 1.2, 1, {
        name="strangewaysdr3",
        heading=0,
        --debugPoly=true,
        minZ=152.79,
        maxZ=153.59 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 3,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("strangewaysdr4", vector3(-796.71, 338.77, 158.6), 1.8, 1, {
        name="strangewaysdr4",
        heading=0,
        --debugPoly=true,
        minZ=157.6,
        maxZ=158.8 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 4,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("strangewaysdr5", vector3(-800.89, 343.16, 158.62), 1, 2.6, {
        name="strangewaysdr5",
        heading=0,
        --debugPoly=true,
        minZ=157.62,
        maxZ=158.62 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 5,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("strangewaysdr6", vector3(-801.97, 326.01, 158.6), 1.0, 3.0, {
        name="strangewaysdr6",
        heading=0,
        --debugPoly=true,
        minZ=157.6,
        maxZ=158.8 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 6,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("strangewaysdr7", vector3(-784.89, 328.57, 160.01), 2.0, 1, {
        name="strangewaysdr7",
        heading=0,
        --debugPoly=true,
        minZ=159.01,
        maxZ=160.01 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 7,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("strangewaysdr8", vector3(-791.63, 331.31, 158.6), 0.8, 2.4, {
        name="strangewaysdr8",
        heading=0,
        --debugPoly=true,
        minZ=157.6,
        maxZ=159.0 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 8,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("strangewaysdr9", vector3(-786.47, 329.22, 158.6), 2.8, 1.2, {
        name="strangewaysdr9",
        heading=0,
        --debugPoly=true,
        minZ=157.6,
        maxZ=159.0 }, {
		options = {
			{
				event = "house-robberies:client:search",
				icon = "far fa-search",
				label = "Search",
				duty = false,
                stolen = false,
				parameters = 9,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("strangewaysdrhackdesk", vector3(-777.83, 328.63, 160.0), 2.0, 1.4, {
        name="strangewaysdrhackdesk",
        heading=0,
        --debugPoly=true,
        minZ=159.0,
        maxZ=160.6 }, {
		options = {
			{
				event = "house-robberies:client:hack",
				icon = "fas fa-usb-drive",
				label = "Attempt hack",
				duty = false,
                stolen = false,
				parameters = "hackdesk"
			},
		},
	job = {"all"}, distance = 2.5 })

    exports["lcrp-interact"]:AddBoxZone("strangewaysdrExit", vector3(-774.65, 331.5, 160.0), 2.8, 2.8, {
        name="strangewaysdrExit",
        heading=0,
        --debugPoly=true,
        minZ=159.0,
        maxZ=161.4 }, {
		options = {
			{
				event = "house-robberies:client:exit",
				icon = "fas fa-house-leave",
				label = "Leave House",
				duty = false,
                parameters = 3
			},
		},
	job = {"all"}, distance = 2.0 })
    
    --HOUSE ENTERS
    exports["lcrp-interact"]:AddBoxZone("jamestownstEnter", vector3(495.1, -1823.68, 28.86), 0.4, 1.2, {
        name="jamestownstEnter",
        heading=320,
        --debugPoly=true,
        minZ=27.86,
        maxZ=30.26 }, {
		options = {
			{
				event = "house-robberies:client:enter",
				icon = "fas fa-door-open",
				label = "Enter House",
				duty = false,
                stolen = true,
                parameters = {house = 'JamestownSt', tier = 1}
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("baycityaveEnter", vector3(-1226.35, -1209.05, 8.26), 1.2, 1, {
        name="baycityaveEnter",
        heading=10,
        --debugPoly=true,
        minZ=6.66,
        maxZ=9.66 }, {
		options = {
			{
				event = "house-robberies:client:enter",
				icon = "fas fa-door-open",
				label = "Enter House",
				duty = false,
                stolen = true,
                parameters = {house = 'BayCityAve', tier = 1}
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("procopiodrEnter", vector3(-272.73, 6401.26, 31.5), 0.8, 1.2, {
        name="procopiodrEnter",
        heading=25,
        --debugPoly=true,
        minZ=30.5,
        maxZ=32.9 }, {
		options = {
			{
				event = "house-robberies:client:enter",
				icon = "fas fa-door-open",
				label = "Enter House",
				duty = false,
                stolen = true,
                parameters = {house = 'ProcopioDr', tier = 1}
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("pictureperfectdriveEnter", vector3(-784.87, 459.96, 100.18), 0.6, 1.2, {
        name="pictureperfectdriveEnter",
        heading=31,
        --debugPoly=true,
        minZ=99.18,
        maxZ=101.78 }, {
		options = {
			{
				event = "house-robberies:client:enter",
				icon = "fas fa-door-open",
				label = "Enter House",
				duty = false,
                stolen = true,
                parameters = {house = 'PicturePerfectDrive', tier = 2}
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("miltonrdEnter", vector3(-536.95, 817.63, 197.5), 0.8, 1.4, {
        name="miltonrdEnter",
        heading=343,
        --debugPoly=true,
        minZ=196.5,
        maxZ=199.3 }, {
		options = {
			{
				event = "house-robberies:client:enter",
				icon = "fas fa-door-open",
				label = "Enter House",
				duty = false,
                stolen = true,
                parameters = {house = 'MiltonRD', tier = 2}
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("eastmirrordrEnter", vector3(1230.06, -725.34, 60.8), 1.4, 1, {
        name="eastmirrordrEnter",
        heading=5,
        --debugPoly=true,
        minZ=59.8,
        maxZ=62.8 }, {
		options = {
			{
				event = "house-robberies:client:enter",
				icon = "fas fa-door-open",
				label = "Enter House",
				duty = false,
                stolen = true,
                parameters = {house = 'EastMirrorDr', tier = 2}
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("rockfordhillsEnter", vector3(-771.83, 351.04, 87.99), 0.8, 1.2, {
        name="rockfordhillsEnter",
        heading=0,
        --debugPoly=true,
        minZ=86.99,
        maxZ=89.59 }, {
		options = {
			{
				event = "house-robberies:client:enter",
				icon = "fas fa-door-open",
				label = "Enter House",
				duty = false,
                stolen = true,
                parameters = {house = 'RockfordHills', tier = 3}
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("didiondrEnter", vector3(-103.07, 397.24, 112.43), 0.8, 1.6, {
        name="didiondrEnter",
        heading=336,
        --debugPoly=true,
        minZ=111.43,
        maxZ=114.43 }, {
		options = {
			{
				event = "house-robberies:client:enter",
				icon = "fas fa-door-open",
				label = "Enter House",
				duty = false,
                stolen = true,
                parameters = {house = 'DidionDr', tier = 3}
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("strangewaysdrEnter", vector3(-634.99, 44.21, 42.69), 2.4, 1, {
        name="strangewaysdrEnter",
        heading=0,
        --debugPoly=true,
        minZ=41.69,
        maxZ=44.69 }, {
		options = {
			{
				event = "house-robberies:client:enter",
				icon = "fas fa-door-open",
				label = "Enter House",
				duty = false,
                stolen = true,
                parameters = {house = 'StrangewaysDr', tier = 3}
			},
		},
	job = {"all"}, distance = 2.0 })

    --BUYERS
    
    exports["lcrp-interact"]:AddBoxZone("robberybuyer1", vector3(894.37, -915.92, 26.28), 0.8, 0.8, {
        name="robberybuyer1",
        heading=0,
        --debugPoly=true,
        minZ=25.28,
        maxZ=27.28 }, {
		options = {
			{
				event = "house-robberies:client:sellItems",
				icon = "fas fa-sack-dollar",
				label = "Sell Items",
				duty = false,
                stolen = false,
                parameters = 1
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("robberybuyer2", vector3(512.26, -532.54, 25.62), 0.8, 1.0, {
        name="robberybuyer2",
        heading=355,
        --debugPoly=true,
        minZ=24.42,
        maxZ=26.82 }, {
		options = {
			{
				event = "house-robberies:client:sellItems",
				icon = "fas fa-sack-dollar",
				label = "Sell Items",
				duty = false,
                stolen = false,
                parameters = 2
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("robberybuyer3", vector3(-1169.55, -2162.78, 13.24), 1, 1, {
        name="robberybuyer3",
        heading=45,
        --debugPoly=true,
        minZ=12.24,
        maxZ=14.44 }, {
		options = {
			{
				event = "house-robberies:client:sellItems",
				icon = "fas fa-sack-dollar",
				label = "Sell Items",
				duty = false,
                stolen = false,
                parameters = 3
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("robberybuyer4", vector3(-478.88, -2688.64, 8.76), 0.8, 1, {
        name="robberybuyer4",
        heading=45,
        --debugPoly=true,
        minZ=7.76,
        maxZ=9.76 }, {
		options = {
			{
				event = "house-robberies:client:sellItems",
				icon = "fas fa-sack-dollar",
				label = "Sell Items",
				duty = false,
                stolen = false,
                parameters = 4
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("robberybuyer5", vector3(-134.03, -2377.0, 9.32), 1.4, 1, {
        name="robberybuyer5",
        heading=0,
        --debugPoly=true,
        minZ=8.32,
        maxZ=10.32 }, {
		options = {
			{
				event = "house-robberies:client:sellItems",
				icon = "fas fa-sack-dollar",
				label = "Sell Items",
				duty = false,
                stolen = false,
                parameters = 5
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("robberybuyer6", vector3(1176.1, -2996.5, 5.9), 0.6, 1, {
        name="robberybuyer6",
        heading=0,
        --debugPoly=true,
        minZ=4.9,
        maxZ=6.9 }, {
		options = {
			{
				event = "house-robberies:client:sellItems",
				icon = "fas fa-sack-dollar",
				label = "Sell Items",
				duty = false,
                stolen = false,
                parameters = 6
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("robberybuyer7", vector3(3859.85, 4458.4, 1.83), 0.8, 0.8, {
        name="robberybuyer7",
        heading=0,
        --debugPoly=true,
        minZ=0.63,
        maxZ=2.83 }, {
		options = {
			{
				event = "house-robberies:client:sellItems",
				icon = "fas fa-sack-dollar",
				label = "Sell Items",
				duty = false,
                stolen = false,
                parameters = 7
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("robberybuyer8", vector3(1378.57, 4301.91, 36.52), 0.8, 0.8, {
        name="robberybuyer8",
        heading=305,
        --debugPoly=true,
        minZ=35.52,
        maxZ=37.52 }, {
		options = {
			{
				event = "house-robberies:client:sellItems",
				icon = "fas fa-sack-dollar",
				label = "Sell Items",
				duty = false,
                stolen = false,
                parameters = 8
			},
		},
	job = {"all"}, distance = 2.0 })

end)

CurrentCops = 4

Citizen.CreateThread(function()
    while true do
        local hours = GetClockHours()
        if hours == Config.ResetRobberyHouses then
            for k,v in pairs(Config.RobberyHouses) do
                ResetHouseState(k)
                TriggerEvent("lcrp-interact:client:updateInteraction", 'zone', k:lower()..'Enter', 'stolen', true)
            end
        end
        Citizen.Wait(60000)
    end
end)


function ResetHouseState(house)
    if inside then
        leaveRobberyHouse()
    end

    policeCalled = false
    Config.RobberyHouses[house]["opened"] = false
    for k, v in pairs(Config.RobberyHouses[house]["furniture"]) do
        v["searched"] = false
        TriggerEvent("lcrp-interact:client:updateInteraction", 'zone', (house..k):lower(), 'stolen', false)
    end
    for k,v in pairs(Config.RobberyHouses[house]['pickableItems']) do
        v['stolen'] = false
        TriggerEvent("lcrp-interact:client:updateInteraction", 'zone', (house..k):lower(), 'stolen', false)
    end
    if Config.RobberyHouses[house]['tier'] == 2 then
        Config.RobberyHouses[house]['hackdesk']['searched'] = false
        TriggerEvent("lcrp-interact:client:updateInteraction", 'zone', (house..'hackdesk'):lower(), 'stolen', false)
    end
end
 
RegisterNetEvent('lcrp-houserobbery:client:setCabinState')
AddEventHandler('lcrp-houserobbery:client:setCabinState', function(house, cabin, state)
    Config.RobberyHouses[house]["furniture"][cabin]["searched"] = state
    TriggerEvent("lcrp-interact:client:updateInteraction", 'zone', (house..cabin):lower(), 'stolen', state)
end)

 RegisterNetEvent('police:SetCopCount')
 AddEventHandler('police:SetCopCount', function(amount)
    TriggerServerEvent('appheists:server:SetCopCount',amount)
    CurrentCops = amount
 end)
 
 RegisterNetEvent('lcrp-houserobbery:client:enterHouse')
 AddEventHandler('lcrp-houserobbery:client:enterHouse', function(house)
    enterRobberyHouse(house)
 end)

RegisterNetEvent('appheists:client:policeCalled')
AddEventHandler('appheists:client:policeCalled', function()
     policeCalled = true
end)

RegisterNetEvent('lockpicks:UseLockpick')
AddEventHandler('lockpicks:UseLockpick', function(isAdvanced)
    if closestHouse ~= nil then
        scCore.TriggerServerCallback('appheists:server:playerHasRobbery', function(isAllowed)
            if isAllowed then
                local hours = GetClockHours()
                if hours >= Config.MinimumTime or hours <= Config.MaximumTime then
                    usingAdvanced = isAdvanced
                    if usingAdvanced then
                        lockPick()
                    else
                        scCore.TriggerServerCallback('scCore:HasItem', function(result)
                            if result then
                                lockPick()
                            else
                                scCore.Notification('You\'re missing items', 'error', 3500)
                            end

                        end, "screwdriverset")
                    end
                end
            end
        end, closestHouse)
    end
end)

function lockPick() 
    if CurrentCops >= Config.MinimumHouseRobberyPolice then
        if not Config.RobberyHouses[closestHouse]["opened"] then
            --TriggerServerEvent('lcrp-houserobbery:server:enterHouse', closestHouse)
            TriggerEvent('lcrp-lockpick:client:openLockpick', lockpickFinish)

            if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
            end
        else
            scCore.Notification('Door is already open', 'error', 3500)
        end
    else
        scCore.Notification('Not enough cops', 'error', 3500)
    end
end



function PoliceCall()
    policeCalled = true
    local nameHouse
    if houseName ~= nil then
        namehouse = houseName
    else
        nameHouse = closestHouse
    end
    local pos = {x=Config.RobberyHouses[nameHouse]['coords']['x'],y=Config.RobberyHouses[nameHouse]['coords']['y'],z=Config.RobberyHouses[nameHouse]['coords']['z']}
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local streetLabel = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    if street2 ~= nil and street2 ~= "" then 
        streetLabel = streetLabel .. " " .. street2
    end
    local gender = "Man"
    if scCore.Functions.GetPlayerData().charinfo.gender == 1 then
        gender = "Women"
    end
    TriggerServerEvent('appheists:server:policeCalled',nameHouse)
    TriggerServerEvent("police:server:HouseRobberyCall", pos, msg, gender, streetLabel)
end

function setNoise()
    local playerStealthLvl = 0
    
    if scCore ~= nil then
        local PlayerData = scCore.Functions.GetPlayerData() 

        if PlayerData.metadata.skill.stealth ~= nil then
            playerStealthLvl = tonumber(PlayerData.metadata.skill.stealth)
        end
    end
    maxNoise = 0
    local houseTier
    if nameHouse ~= nil then
        houseTier = Config.RobberyHouses[nameHouse]['tier']
    elseif closestHouse ~= nil then
        houseTier = Config.RobberyHouses[closestHouse]['tier']
    else
        houseTier = 2
    end

    if houseTier == 1 then
        maxNoise = 20 + playerStealthLvl * 0.6
    elseif houseTier == 2 then
        maxNoise = 20 + playerStealthLvl * 0.5
    elseif houseTier == 3 then
        maxNoise = 20 + playerStealthLvl * 0.4        
    else  
        print("Oops, this shouldn't have happened")
    end

    return playerStealthLvl
end


function lockpickFinish(success)
    if success then
        local playerStealth = setNoise()

        if playerStealth > 50 then playerStealth = 50 end -- AS THERES NO MEAN TO GAIN STEALTH RIGHT NOW

        if math.random(1,100) > playerStealth then
            --PoliceCall()
        end
        TriggerServerEvent('lcrp-houserobbery:server:enterHouse', closestHouse)
        scCore.Notification('Succesful!', 'primary', 2500)
    else
        if usingAdvanced then
            local itemInfo = scCore.Shared.Items["advancedlockpick"]
            if math.random(1, 100) < 20 then
                TriggerServerEvent("scCore:Server:RemoveItem", "advancedlockpick", 1)
                TriggerEvent('inventory:client:ItemBox', itemInfo, "remove")
            end
        else
            local itemInfo = scCore.Shared.Items["lockpick"]
            if math.random(1, 100) < 40 then
                TriggerServerEvent("scCore:Server:RemoveItem", "lockpick", 1)
                TriggerEvent('inventory:client:ItemBox', itemInfo, "remove")
            end
        end
        
        scCore.Notification('Failed', 'error', 2500)
    end
end

RegisterNetEvent('lcrp-houserobbery:client:setHouseState')
AddEventHandler('lcrp-houserobbery:client:setHouseState', function(house, state)
    Config.RobberyHouses[house]["opened"] = state
    TriggerEvent("lcrp-interact:client:updateInteraction", 'zone', house:lower().."Enter", 'stolen', false)
end)

-- CHECKS PLAYER POSITION RELATIVE TO ROBBERYHOUSES IN CONFIG
-- IF PLAYER IS ALLOWED TO ROB (TIME AND COPS AVAILABLE)
-- IF HOUSE IS OPENED DRAWS TEXT SO PLAYER CAN GET IN
-- IF CLOSE ENOUGH SHOW REQUIRED ITEM TO BREAK IN IF MISSING

function showNecessaryItems(robberyName)
    Citizen.CreateThread(function()
        Citizen.Wait(500)
        requiredItems = {
            [1] = {name = scCore.Shared.Items["lockpick"]["name"], image = scCore.Shared.Items["lockpick"]["image"]},
            [2] = {name = scCore.Shared.Items["screwdriverset"]["name"], image = scCore.Shared.Items["screwdriverset"]["image"]},
        }

        while not inside do
            inRange = false
            sleep = 1000

            local PlayerPos = GetEntityCoords(PlayerPedId())
            local hours = GetClockHours()
            closestHouse = robberyName

            local dist = GetDistanceBetweenCoords(PlayerPos, Config.RobberyHouses[robberyName]["coords"]["x"], Config.RobberyHouses[robberyName]["coords"]["y"], Config.RobberyHouses[robberyName]["coords"]["z"], true)
            if dist <= 1.5 then
                inRange = true
                sleep = 5

                if not requiredItemsShowed then
                    requiredItemsShowed = true
                    TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                end
            elseif requiredItemsShowed then
                requiredItemsShowed = false
                TriggerEvent('inventory:client:requiredItems', requiredItems, false)
            end
            Citizen.Wait(sleep)
        end
        requiredItemsShowed = false
        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
    end)
end

function enterRobberyHouse(house1)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    openHouseAnim()
    inRobbery = true
    startNoiseCount()
    houseName = house1
    local house = Config.RobberyHouses[houseName]
    inside = true
    returnPos = GetEntityCoords(PlayerPedId())

    if house['tier'] == 3 then
        spawnPickableItems(house)
        setPlayer(vector3(Config.RobberyHouses[houseName]['spawn']['x'], Config.RobberyHouses[houseName]['spawn']['y'], Config.RobberyHouses[houseName]['spawn']['z']))
    else
        spawnShell(house)
    end
end

function openHouseAnim()
    loadAnimDict("anim@heists@keycard@") 
    TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Citizen.Wait(400)
    ClearPedTasks(GetPlayerPed(-1))
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function LockpickDoorAnim(time)
    -- time = time / 1000
    loadAnimDict("veh@break_in@0h@p_m_one@") --"missexile3"
    -- TaskPlayAnim(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while true do
            if openingDoor then
                TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 1, 0, 0, 0, 0)
            else
                StopAnimTask(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
                break
            end
            Citizen.Wait(1000)
        end
    end)
end

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(GetPlayerPed(-1), 3)
    local model = GetEntityModel(GetPlayerPed(-1))
    local retval = true
    if model == GetHashKey("mp_m_freemode_01") then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

function searchCabin(cabin)
    local lockpickTime = 10000
    local ped = GetPlayerPed(-1)
    local Skillbar = exports['lcrp-skillbar']:GetSkillbarObject()
    if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
        local pos = GetEntityCoords(GetPlayerPed(-1))
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    LockpickDoorAnim(lockpickTime)
    TriggerServerEvent('lcrp-robberies:server:SetBusyState', cabin, houseName, true)
    TriggerEvent("lcrp-interact:client:updateInteraction", 'zone', (houseName..cabin):lower(), 'stolen', true)

    FreezeEntityPosition(ped, true)

    IsLockpicking = true

    Skillbar.Start({
        duration = 500,
        pos = math.random(10, 30),
        width = math.random(10, 15),
    }, function()
        scCore.TaskBar("search_cabin", "Search cabins", lockpickTime, false, true, {}, {}, {}, {}, function()
            openingDoor = false
            ClearPedTasks(GetPlayerPed(-1))
            TriggerServerEvent('lcrp-robberies:server:SetBusyState', cabin, houseName, false)
            Config.RobberyHouses[houseName]["furniture"][cabin]["searched"] = true
            TriggerServerEvent('lcrp-robberies:server:searchCabin', cabin, houseName)
            FreezeEntityPosition(ped, false)
            SetTimeout(500, function()
                IsLockpicking = false
            end)
        end, function()
            scCore.Notification("Search cancelled!")
            openingDoor = false
            ClearPedTasks(GetPlayerPed(-1))
            TriggerServerEvent('lcrp-robberies:server:SetBusyState', cabin, houseName, false)
            FreezeEntityPosition(ped, false)
            SetTimeout(500, function()
                IsLockpicking = false
            end)
        end)  
    end, function()
        -- Fail
        openingDoor = false
        ClearPedTasks(GetPlayerPed(-1))
        TriggerServerEvent('lcrp-robberies:server:SetBusyState', cabin, houseName, false)
        scCore.Notification("Canceled", "error")
        FreezeEntityPosition(ped, false)
        SetTimeout(500, function()
            IsLockpicking = false
        end)
    end)
    
end

RegisterNetEvent('lcrp-robberies:client:SetBusyState')
AddEventHandler('lcrp-robberies:client:SetBusyState', function(cabin, house, bool)
    if type(cabin) == 'string' then
        Config.RobberyHouses[house][cabin]["isBusy"] = bool
    else
        Config.RobberyHouses[house]["furniture"][cabin]["isBusy"] = bool
    end
    TriggerEvent("lcrp-interact:client:updateInteraction", 'zone', (house..cabin):lower(), 'stolen', bool)
end)

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(GetPlayerPed(-1), 3)
    local model = GetEntityModel(GetPlayerPed(-1))
    local retval = true
    if model == GetHashKey("mp_m_freemode_01") then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

--
RegisterNetEvent('lcrp-robberies:client:HoldObjAnim')
AddEventHandler('lcrp-robberies:client:HoldObjAnim',function(item)
    isCarrying = true
    TriggerEvent('weapons:ResetHolster')
    SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
    RemoveAllPedWeapons(GetPlayerPed(-1), true)
    carryObject(item)
end)

RegisterNetEvent('lcrp-robberies:client:StopHoldObj')
AddEventHandler('lcrp-robberies:client:StopHoldObj',function()
    isCarrying = false
    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    Citizen.Wait(500)
    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
end)
-- DISABLE CONTROLS


function carryObject(obj)
    TriggerEvent('animations:client:EmoteCommandStart', {obj})
    Citizen.CreateThread(function()
        while isCarrying do
            Citizen.Wait(5)
            if not IsEntityPlayingAnim(PlayerPedId(),"anim@heists@box_carry@", "idle",3) then
                TriggerEvent('animations:client:EmoteCommandStart', {obj})
            end
            DisableControlAction(0, spaceControl, true)
            DisableControlAction(0, shiftControl, true)
            DisableControlAction(0, attackControl, true)
            DisableControlAction(0, aggroControl, true)
            DisableControlAction(0, Keys['E'], true)
            if not inside then
                DisableControlAction(0, enterControl, true)
            end
        end
    end)
end
--

-- STEALTH - ROBBERY NOISE
function startNoiseCount()
    Citizen.CreateThread(function()
        while inRobbery do
            if scCore ~= nil then
                if not IsPedWalking(playerPed) and not IsPedRunning(playerPed) and
                    not IsPedSprinting(playerPed) then
                    if noise > 2 then
                        noise = noise - 2
                    else
                        noise = 0
                    end
                end
                if maxNoise == nil and (closestHouse ~= nil or houseName ~= nil) then
                    setNoise()
                end
                noise = noise + GetPlayerCurrentStealthNoise() * 0.8
                if noise >= maxNoise and not policeCalled then
                    PoliceCall()
                    policeCalled = true
                end
            end
            Citizen.Wait(1000)
        end
    end)
end

-- STEALTH END

RegisterNetEvent('lcrp-robberies:client:NotifyClient')
AddEventHandler('lcrp-robberies:client:NotifyClient', function(success, totalCoins,house)
    if scCore ~= nil then
        if type(totalCoins) == 'string' then
            Config.RobberyHouses[house]['hackdesk']['searched'] = true
            TriggerEvent("lcrp-interact:client:updateInteraction", 'zone', (house..'hackdesk'):lower(), 'stolen', true)
        else
            if success then
                scCore.Notification('Crypto wallet hacked! A total of '..math.floor(totalCoins)..' coins were transfered to your Cryptostick', 'success')
                Config.RobberyHouses[house]['hackdesk']['searched'] = true
                TriggerEvent("lcrp-interact:client:updateInteraction", 'zone', (house..'hackdesk'):lower(), 'stolen', true)
            else
                scCore.Notification('Hack failed', 'error')
            end
        end
    end
end)

RegisterNetEvent('lcrp-robberies:client:itemStolen')
AddEventHandler('lcrp-robberies:client:itemStolen', function(house, item)
    if spawnedObj[Config.RobberyHouses[house]['pickableItems'][item]['model']] ~= nil then
        DeleteObject(spawnedObj[Config.RobberyHouses[house]['pickableItems'][item]['model']])
    end
    Config.RobberyHouses[house]['pickableItems'][item]['stolen'] = true
    TriggerEvent("lcrp-interact:client:updateInteraction", 'zone', (house..item):lower(), 'stolen', true)
end)

function startHack(cabin,item)
    local taskTime = 10000
    local Skillbar = exports['lcrp-skillbar']:GetSkillbarObject()
    local ped = GetPlayerPed(-1)
    isHacking = true

    FreezeEntityPosition(ped, true)

    Citizen.CreateThread(function()
        loadAnimDict("missah_2_ext_altleadinout")
        while isHacking do
            TaskPlayAnim(ped, "missah_2_ext_altleadinout",
                         "hack_loop", 8.0, 8.0, -1, 1, 0, 0, 0, 0)
            Citizen.Wait(5)
        end
        StopEntityAnim(ped, "hack_loop", "missah_2_ext_altleadinout", true)
    end)

    TriggerServerEvent('lcrp-robberies:server:SetBusyState', cabin, houseName, true)
    Skillbar.Start({
        duration = 500,
        pos = math.random(10, 30),
        width = math.random(10, 15),
    }, function()
        -- TaskStartScenarioInPlace(playerPed, "amb@prop_human_seat_computer@male", 0, true) -- NEEDS PROPER ANIMATION
        scCore.TaskBar("hack_pc", "Attempting to steal Cryptocoins",
                       taskTime, false, true, {}, {}, {}, {}, function()
            TriggerServerEvent('cryptostick:server:onHackFinish',item,houseName,Config.RobberyHouses[houseName]['tier'])
            FreezeEntityPosition(ped, false)
            SetTimeout(500, function()
                isHacking = false
            end)
            TriggerServerEvent('lcrp-robberies:server:SetBusyState', cabin, houseName, false)
        end, function()
            scCore.Notification("Hacking cancelled!")
            FreezeEntityPosition(ped, false)
            SetTimeout(500, function()
                isHacking = false
            end)
            TriggerServerEvent('lcrp-robberies:server:SetBusyState', cabin, houseName, false)
        end)
        -- ClearPedTasks(GetPlayerPed(-1))
        -- FreezeEntityPosition(ped, false)
    end, function()
        FreezeEntityPosition(ped, false)
        SetTimeout(500, function()
            isHacking = false
        end)
        TriggerServerEvent('lcrp-robberies:server:SetBusyState', cabin, houseName, false)
    end)

end

function SpawnObject(model, coords, cb)
    local modelName = model
    if tonumber(model) ~= nil then model = tonumber(model) end
    if type(model) == 'string' then model = GetHashKey(model) end

    Citizen.CreateThread(function()
        RequestModel(model)
        while not HasModelLoaded(model) do Citizen.Wait(0) end

        obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, false)
        spawnedObj[modelName] = obj

        if cb ~= nil then cb(obj) end
    end)
end

function setPlayer(spawnP)
    local ped = PlayerPedId()
    DoScreenFadeOut(100)
    while not IsScreenFadedOut() do Citizen.Wait(1) end
    -- spawnPed(house["ped"]["coords"])
    SetEntityCoords(ped, spawnP)
    Citizen.Wait(1000)
    FreezeEntityPosition(ped, true)
    while not HasCollisionLoadedAroundEntity(ped) do
        Citizen.Wait(1)
    end
    DoScreenFadeIn(100)
    FreezeEntityPosition(ped, false)
end

function spawnShell(house)
    local shell = shells[house['tier']]
    local model = shell
    if IsModelInCdimage(model) then
        if not HasModelLoaded(model) then
            ticks[model] = 0
            while not HasModelLoaded(model) do
                scCore.ShowHelpNotification('Requesting model, please wait')
                DisableAllControlActions(0)
                Citizen.Wait(10)
                RequestModel(model)
                ticks[model] = ticks[model] + 1
                if ticks[model] >= Config.ModelWaitTicks then
                    ticks[model] = 0
                    scCore.ShowHelpNotification(
                        'Model ' .. shell ..
                            ' failed to load, found in server image, please attempt re-logging to solve')
                    return
                end
            end
        end
        if HasModelLoaded(model) then
            local x, y, z = house['coords'].x, house['coords'].y, house['coords'].z - 20
            local pX,pY = x+exitOffset[house['tier']]['x'],y+exitOffset[house['tier']]['y']
            local height = GetWaterHeight(x, y, z)
            local spot
            if height == false then
                spot = vector3(x, y, z)
            else
                spot = GetSafeSpot()
            end
            local spot = vector3(x, y, z)
            local pSpawn = vector3(pX,pY,z)
            local home = CreateObjectNoOffset(model, spot, true, false, false)
            if DoesEntityExist(home) then
                spawnPickableItems(house)
                
                if house['tier'] == 2 then
                    spawnHackdesk(house)
                end

                FreezeEntityPosition(home, true)
                SpawnedHome = {}
                table.insert(SpawnedHome, home)
                setPlayer(pSpawn)
            else
                scCore.Notification(Config.Strings.wntRong)
            end
        end
    end
end

function spawnPickableItems(house)
    for k in pairs(house['pickableItems']) do
        if not house['pickableItems'][k]['stolen'] then
            SpawnObject(house['pickableItems'][k]['model'],
            {x = house['coords'].x+house['pickableItems'][k]['coords']['x'], y = house['coords'].y+house['pickableItems'][k]['coords']['y'], z = house['coords'].z +house['pickableItems'][k]['coords']['z']}, function(obj)
            SetEntityHeading(obj, house['pickableItems'][k]['coords']['h'])
            if k == 'tv1' or k == 'tv2' then
                PlaceObjectOnGroundProperly(obj)
            end
            FreezeEntityPosition(obj, true)
            end)  
        end
    end
end

function spawnHackdesk(house)
    SpawnObject(GetHashKey(house['hackdesk']['model']),
        {x = house['coords'].x+house['hackdesk']['coords']['x'], y = house['coords'].y+house['hackdesk']['coords']['y'], z = house['coords'].z +house['hackdesk']['coords']['z']}, function(obj)
        SetEntityHeading(obj, house['hackdesk']['coords']['h'])
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
        end)
end

function leaveRobberyHouse()
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    openHouseAnim()
    inRobbery = false
    noise = 0

    local ped = PlayerPedId()
    SetEntityCoords(ped, returnPos)

    inside = false
    currHouse = nil
    houseName = nil
    -- DeletePed(newPed) 
    for k,v in pairs(spawnedObj) do
        DeleteObject(v)
    end
    if not tier == 3 then
        for i = 1,#SpawnedHome do
            DeleteEntity(SpawnedHome[i])
        end
    end 
    SpawnedHome = {}
    spawnedObj = {}
    returnPos = nil
end

RegisterNetEvent('lcrp-houses-robberies:client:ArrivedAtJob')
AddEventHandler('lcrp-houses-robberies:client:ArrivedAtJob',function(robberyName)
    arrivedAtJob = {true,robberyName}
    showNecessaryItems(robberyName)
    Citizen.CreateThread(function()
        while arrivedAtJob[1] do
            local player = GetEntityCoords(GetPlayerPed(-1))
            local dist = GetDistanceBetweenCoords(player,Config.RobberyHouses[robberyName].coords.x,Config.RobberyHouses[robberyName].coords.y,Config.RobberyHouses[robberyName].coords.z,false)
            
            if dist > 80 and Config.RobberyHouses[robberyName].opened and not inside then
                local buyer = math.random(1, #Config.RobberyBuyerLocations)
                TriggerServerEvent('appheists:server:PlayerLeftJob', robberyName, buyer)
                arrivedAtJob[1] = false
            end
            Citizen.Wait(2000)
        end
    end)
end)

RegisterNetEvent('robberies:client:spawnBuyer')
AddEventHandler('robberies:client:spawnBuyer',function(buyerid)
    TriggerEvent("lcrp-interact:client:updateInteraction", 'zone', 'buyer'..buyerid, 'stolen', false) 
    local buyer = Config.RobberyBuyerLocations[buyerid]
    local hasArrivedAtBuyer = false

    buyerBlip = AddBlipForCoord(buyer.x,buyer.y,buyer.z)

    SetBlipRoute(buyerBlip, true)
    SetBlipRouteColour(buyerBlip, 69)

    Citizen.CreateThread(function()
        local blipCoords = GetBlipCoords(buyerBlip)
        while not hasArrivedAtBuyer do
            local player = GetEntityCoords(GetPlayerPed(-1))
            if GetDistanceBetweenCoords(player,blipCoords) < 5 then
                if buyerBlip ~= nil then
                    hasArrivedAtBuyer = true
                    RemoveBlip(buyerBlip)
                end
            end
            Citizen.Wait(1000)
        end   
    end)

    Citizen.CreateThread(function()
        Citizen.Wait(600000)
        if buyerBlip ~= nil then
            hasArrivedAtBuyer = true
            RemoveBlip(buyerBlip)
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
            ped = CreatePed(4, modelHash, buyer.x, buyer.y, buyer.z, 3374176, false, true)
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
            TaskLookAtEntity(ped, GetPlayerPed(-1), -1, 2048, 3)

            if distance <= 5.0 then
                sleep = 5
                if pedDistance > 0.5 or not IsEntityPlayingAnim(ped, "mini@strip_club@idles@bouncer@base","base", 3) then
                    SetEntityCoords(ped, buyer.x, buyer.y, buyer.z)
                    SetEntityHeading(ped, buyer.h)
                    TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
                end
                
            elseif distance > 80 and hasArrivedAtBuyer then
                DeleteEntity(ped)
                spawnedPed = false
                TriggerEvent('appheists:client:JobCompleted')
                TriggerEvent("lcrp-interact:client:updateInteraction", 'zone', 'buyer'..buyerid, 'stolen', false)
            end
            Citizen.Wait(sleep)
        end
    end) 
end)