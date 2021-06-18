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

scCore = nil
local spawnedPeds = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if scCore == nil then
            TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData =  scCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
	
end)

-- STRIP CLUB --

Citizen.CreateThread(function()
    RequestModel(GetHashKey("a_f_y_topless_01"))

	while not HasModelLoaded(GetHashKey("a_f_y_topless_01")) do
		Wait(10)
	end

	for _, item in pairs(Config.Locations24) do
		local npc = CreatePed(1, 0x9CF26183, item.x, item.y, item.z, item.heading, false, true)
		local npc2 = CreatePed(1, 0x9CF26183, item.x, item.y, item.z, item.heading, false, true)
		local ad = "mini@strip_club@lap_dance_2g@ld_2g_p1"
	
		RequestAnimDict(ad)
		while not HasAnimDictLoaded(ad) do
		Citizen.Wait(1000)
		end
		
		local netScene = CreateSynchronizedScene(item.x, item.y, item.z, vec3(0.0, 0.0, 0.0), 2)
		TaskSynchronizedScene(npc, netScene, ad, "ld_2g_p1_s1", 1.0, -4.0, 261, 0, 0)
		TaskSynchronizedScene(npc2, netScene, ad, "ld_2g_p1_s2", 1.0, -4.0, 261, 0, 0)
		FreezeEntityPosition(npc, true)	
		FreezeEntityPosition(npc2, true)	
		SetEntityHeading(npc, item.heading)
		SetEntityHeading(npc2, item.heading)
		SetEntityInvincible(npc, true)
		SetEntityInvincible(npc2, true)
		SetBlockingOfNonTemporaryEvents(npc, true)
		SetBlockingOfNonTemporaryEvents(npc2, true)
		SetSynchronizedSceneLooped(netScene, 1)
		SetModelAsNoLongerNeeded(model)
	end
end)

--[[ Citizen.CreateThread(function()
	for k,v in pairs(Config.StriperPoleDancing) do
		RequestModel(GetHashKey(v.model))

		while not HasModelLoaded(GetHashKey(v.model)) do
			Wait(10)
		end

		local npc = CreatePed(1, 0x5C14EDFA, v.x, v.y, v.z, v.heading, false, true)

		spawnedPeds[k] = npc

		FreezeEntityPosition(npc, true)	
		SetEntityHeading(npc, v.heading)
		SetEntityInvincible(npc, true)
		SetBlockingOfNonTemporaryEvents(npc, true)
		RequestAnimDict("mini@strip_club@pole_dance@pole_dance3")

		while not HasAnimDictLoaded("mini@strip_club@pole_dance@pole_dance3") do
			Citizen.Wait(100)
		end

		local netScene3 = CreateSynchronizedScene(v.x, v.y, v.z, vec3(0.0, 0.0, 0.0), 2)
		TaskSynchronizedScene(npc, netScene3, "mini@strip_club@pole_dance@pole_dance3", "pd_dance_03", 1.0, -4.0, 261, 0, 0)
		SetSynchronizedSceneLooped(netScene3, 1)
		SetModelAsNoLongerNeeded(model)
	end
end) ]]

function PlayAnim(Dict, Anim, Flag)
    LoadDict(Dict)
    TaskPlayAnim(PlayerPedId(), Dict, Anim, 8.0, -8.0, -1, Flag or 0, 0, false, false, false)
end

function LoadDict(Dict)
    while not HasAnimDictLoaded(Dict) do 
        Wait(0)
        RequestAnimDict(Dict)
    end
end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()

	exports["lcrp-interact"]:AddBoxZone("vanillaDuty", vector3(109.35, -1304.04, 28.77), 1.2, 2.4, {
		name="vanillaDuty",
		heading=300,
		--debugPoly=true,
		minZ=27.57,
		maxZ=30.37
        }, {
		options = {
			{
				event = "police:client:Duty",
				icon = "far fa-clipboard",
				label = "Clock in",
				duty = false,
				parameters = "duty",
			},
			{
				event = "police:client:Duty",
				icon = "far fa-clipboard",
				label = "Clock out",
				duty = true,
				parameters = "duty",
			},
		},
	job = {"vanilla"}, distance = 2.0 })

	exports["lcrp-interact"]:AddBoxZone("vanillaBoss", vector3(95.82, -1292.98, 29.26), 0.8, 1.4, {
		name="vanillaBoss",
		heading=305,
		--debugPoly=true,
		minZ=28.26,
		maxZ=29.86 }, {
        options = {
            {
                event = "police:server:OpenSocietyMenu",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
                parameters = 'vanilla'
            },
        },
        job = {"vanilla"}, distance = 2.0})

	exports["lcrp-interact"]:AddBoxZone("vanilla2Poledance", vector3(102.14, -1290.18, 29.25), 1, 1, {
		name="vanilla2Poledance",
		heading=30,
		--debugPoly=true,
		minZ=28.05,
		maxZ=30.25 }, {
		options = {
			{
				event = "nightclub:client:Poledance",
				icon = "fas fa-transporter",
				label = "Poledance",
				duty = true,
				stripperGrade = 4,
				parameters = 2
			},
		},
		job = {"vanilla"}, distance = 2.0})

	exports["lcrp-interact"]:AddBoxZone("vanilla3Poledance", vector3(108.8, -1289.28, 29.25), 1, 1, {
		name="vanilla3Poledance",
		heading=30,
		--debugPoly=true,
		minZ=28.05,
		maxZ=30.25 }, {
		options = {
			{
				event = "nightclub:client:Poledance",
				icon = "fas fa-transporter",
				label = "Poledance",
				duty = true,
				stripperGrade = 4,
				parameters = 3
			},
		},
		job = {"vanilla"}, distance = 2.0})
	
	exports["lcrp-interact"]:AddBoxZone("vanilla1Poledance", vector3(104.77, -1294.49, 29.25), 1, 1, {
		name="vanilla1Poledance",
		heading=30,
		--debugPoly=true,
		minZ=28.05,
		maxZ=30.25 }, {
		options = {
			{
				event = "nightclub:client:Poledance",
				icon = "fas fa-transporter",
				label = "Poledance",
				duty = true,
				stripperGrade = 4,
				parameters = 1
			},
		},
		job = {"vanilla"}, distance = 2.0})

	exports["lcrp-interact"]:AddBoxZone("vanilla1Poledance", vector3(104.77, -1294.49, 29.25), 1, 1, {
		name="vanilla1Poledance",
		heading=30,
		--debugPoly=true,
		minZ=28.05,
		maxZ=30.25 }, {
		options = {
			{
				event = "nightclub:client:Poledance",
				icon = "fas fa-transporter",
				label = "Poledance",
				duty = true,
				stripperGrade = 4,
				parameters = 1
			},
		},
		job = {"vanilla"}, distance = 2.0})

	exports["lcrp-interact"]:AddBoxZone("vanillaOutfits", vector3(104.63, -1303.61, 28.79), 2.8, 1.4, {
		name="vanillaOutfits",
		heading=30,
		--debugPoly=true,
		minZ=27.79,
		maxZ=29.99 }, {
		options = setInteractClothes(),
	job = {"vanilla"}, distance = 2.0})

end)

RegisterNetEvent("nightclub:client:Poledance")
AddEventHandler("nightclub:client:Poledance", function(pole)
	if PlayerJob.onduty and PlayerJob.name == "vanilla" and PlayerJob.grade == 4 then
		ClearPedTasks(PlayerPedId())
		LoadDict('mini@strip_club@pole_dance@pole_dance' .. pole)
		local scene = NetworkCreateSynchronisedScene(Config.PoleDance.Locations[pole], vector3(0.0, 0.0, 0.0), 2, false, false, 1065353216, 0, 1.3)
		NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, 'mini@strip_club@pole_dance@pole_dance' .. pole, 'pd_dance_0' .. pole, 1.5, -4.0, 1, 1, 1148846080, 0)
		NetworkStartSynchronisedScene(scene)
	end
end)

function setInteractClothes()
    outfits = {
        {
            event = "",
            icon = "",
            label = "Outfits",
            duty = true,
        },
        {
            event = "nightclub:client:selectedOutfit",
            icon = "far fa-tshirt",
            label = "Civilian",
            duty = true,
            parameters = "civilian"
        },
    }
    outfitList = Config.VanillaOutfitsMale
    if scCore.Functions.GetPlayerData().charinfo.gender == 1 then outfitList = Config.VanillaOutfitsFemale end
    for k,v in pairs(outfitList) do
        table.insert(outfits, {
            event = "nightclub:client:selectedOutfit",
            icon = "far fa-tshirt",
            label = v,
            duty = true,
            parameters = k
        })
    end

    return outfits
end

RegisterNetEvent('nightclub:client:selectedOutfit')
AddEventHandler('nightclub:client:selectedOutfit', function(selection)
    SelectOutfit(selection)
end)

function SelectOutfit(outfit)
    if outfit == "civilian" then
        TriggerServerEvent('lcrp-clothes:get_character_current')
        TriggerServerEvent("lcrp-clothes:retrieve_tats")
    end

    if outfit == "securitymale" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 50, texture = 2},
                ["arms"]        = { item = 6, texture = 0}, 
                ["t-shirt"]     = { item = 23, texture = 1},  
                ["torso2"]      = { item = 72, texture = 2},  
                ["shoes"]       = { item = 36, texture = 3},
                ["glass"]       = { item = 17, texture = 2},    
                ["ear"]       = { item = 0, texture = 0}, 
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end
	
	if outfit == "securityfemale" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 30, texture = 0},
                ["arms"]        = { item = 67, texture = 0}, 
                ["t-shirt"]     = { item = 59, texture = 1}, 
                ["torso2"]      = { item = 107, texture = 0},  
                ["shoes"]       = { item = 25, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

	if outfit == "stripperfemale" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 20, texture = 0},
                ["arms"]        = { item = 15, texture = 0}, 
                ["t-shirt"]     = { item = 22, texture = 0}, 
                ["torso2"]      = { item = 22, texture = 0},  
                ["shoes"]       = { item = 14, texture = 3},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    TriggerEvent('InteractSound_CL:PlayOnOne','Clothes1', 0.6)
end


-- CREDITS TO loffe_animations
--[[ Citizen.CreateThread(function()
	while true do
		sleep = 500
			for k, v in pairs(Config['PoleDance']['Locations']) do
				if #(GetEntityCoords(PlayerPedId()) - v['Position']) <= 1.0 then

					if IsControlJustReleased(0, 105) then
						ClearPedTasks(PlayerPedId())
					end

					sleep = 5
					if IsControlJustReleased(0, 51) then
						LoadDict('mini@strip_club@pole_dance@pole_dance' .. v['Number'])
						local scene = NetworkCreateSynchronisedScene(v['Position'], vector3(0.0, 0.0, 0.0), 2, false, false, 1065353216, 0, 1.3)
						NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, 'mini@strip_club@pole_dance@pole_dance' .. v['Number'], 'pd_dance_0' .. v['Number'], 1.5, -4.0, 1, 1, 1148846080, 0)
						NetworkStartSynchronisedScene(scene)
					end
				end
			end
		Citizen.Wait(sleep)
	end
end) ]]