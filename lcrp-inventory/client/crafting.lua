scCore = nil
local itemInfos = {}

Citizen.CreateThread(function()
	while scCore == nil do
		TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
		Citizen.Wait(0)
	end
	ItemsToItemInfo()
end)



RegisterNetEvent("inventory:client:OpenCrafting")
AddEventHandler("inventory:client:OpenCrafting", function()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local craftObject = GetClosestObjectOfType(pos, 2.0, -573669520, false, false, false)
	local isOnIsland = exports["lcrp-scripts"]:isOnIsland()

	if isOnIsland then return scCore.Notification("You can't use crafting bench on island!", "error") end

	if craftObject ~= 0 then
		local crafting = {}
		crafting.label = "Crafting"
		crafting.items = GetThresholdItems()
		TriggerServerEvent("inventory:server:OpenInventory", "crafting", math.random(1, 99), crafting)
	end
end)

function GetThresholdItems()
	local items = {}

	for k, item in pairs(Config.CraftingItems) do
		local blueprint = Config.CraftingItems[k].blueprintType

		if blueprint ~= nil then
			blueprints = scCore.Functions.GetPlayerData().metadata["weaponblueprint"][blueprint]
		end

		if blueprints then
			items[k] = Config.CraftingItems[k]
		elseif scCore.Functions.GetPlayerData().metadata["craftingrep"] >= Config.CraftingItems[k].threshold then
			if blueprint == nil then
				items[k] = Config.CraftingItems[k]
			end
		end
	end
	return items
end

-- CRAFTING ITEMS DESCRIPTIONS
function ItemsToItemInfo()
	itemInfos = {
		[1] = {costs = "Craft: "..scCore.Shared.Items["metalscrap"]["label"] .. ": 5x, " ..scCore.Shared.Items["plastic"]["label"] .. ": 7x."},
		[2] = {costs = "Craft: "..scCore.Shared.Items["metalscrap"]["label"] .. ": 5x, " ..scCore.Shared.Items["plastic"]["label"] .. ": 7x."},
		[3] = {costs = "Craft: "..scCore.Shared.Items["metalscrap"]["label"] .. ": 30x, " ..scCore.Shared.Items["plastic"]["label"] .. ": 45x, "..scCore.Shared.Items["aluminum"]["label"] .. ": 28x."},
		[4] = {costs = "Craft: "..scCore.Shared.Items["metalscrap"]["label"] .. ": 36x, " ..scCore.Shared.Items["steel"]["label"] .. ": 24x, "..scCore.Shared.Items["aluminum"]["label"] .. ": 28x."},
		[5] = {costs = "Craft: "..scCore.Shared.Items["metalscrap"]["label"] .. ": 50x, " ..scCore.Shared.Items["steel"]["label"] .. ": 37x, "..scCore.Shared.Items["copper"]["label"] .. ": 26x. "},
		[6] = {costs = "Craft: "..scCore.Shared.Items["metalscrap"]["label"] .. ": 10x, " ..scCore.Shared.Items["plastic"]["label"] .. ": 90x, "..scCore.Shared.Items["aluminum"]["label"] .. ": 2x. "},
		[7] = {costs = "Craft: "..scCore.Shared.Items["metalscrap"]["label"] .. ": 15x, " ..scCore.Shared.Items["plastic"]["label"] .. ": 80x, "..scCore.Shared.Items["aluminum"]["label"] .. ": 3x. "},
		[8] = {costs = "Craft: "..scCore.Shared.Items["metalscrap"]["label"] .. ": 20x, " ..scCore.Shared.Items["plastic"]["label"] .. ": 60x, "..scCore.Shared.Items["aluminum"]["label"] .. ": 5x. "},
		[9] = {costs = "Craft: "..scCore.Shared.Items["metalscrap"]["label"] .. ": 10x, " ..scCore.Shared.Items["plastic"]["label"] .. ": 100x, "..scCore.Shared.Items["aluminum"]["label"] .. ": 5x. "},
		[10] = {costs = "Craft: "..scCore.Shared.Items["pistol_clip"]["label"] .. ": 1x, " ..scCore.Shared.Items["pistol_grip"]["label"] .. ": 1x, "..scCore.Shared.Items["pistol_slide"]["label"] .. ": 1x, "..scCore.Shared.Items["gun_trigger"]["label"] .. ": 1x. "},
		[11] = {costs = "Craft: "..scCore.Shared.Items["iron"]["label"] .. ": 60x, " ..scCore.Shared.Items["glass"]["label"] .. ": 30x "},
		[12] = {costs = "Craft: "..scCore.Shared.Items["aluminum"]["label"] .. ": 60x, " ..scCore.Shared.Items["glass"]["label"] .. ": 30x "},
		[13] = {costs = "Craft: "..scCore.Shared.Items["metalscrap"]["label"] .. ": 140x, " ..scCore.Shared.Items["steel"]["label"] .. ": 190x, "..scCore.Shared.Items["rubber"]["label"] .. ": 60x."},
		[14] = {costs = "Craft: "..scCore.Shared.Items["iron"]["label"] .. ": 33x, " ..scCore.Shared.Items["steel"]["label"] .. ": 44x, "..scCore.Shared.Items["plastic"]["label"] .. ": 55x, "..scCore.Shared.Items["aluminum"]["label"] .. ": 22x."},
		[15] = {costs = "Craft: "..scCore.Shared.Items["metalscrap"]["label"] .. ": 165x, " ..scCore.Shared.Items["steel"]["label"] .. ": 180x, "..scCore.Shared.Items["rubber"]["label"] .. ": 75x."},
		[16] = {costs = "Craft: "..scCore.Shared.Items["metalscrap"]["label"] .. ": 255x, " ..scCore.Shared.Items["steel"]["label"] .. ": 210x, "..scCore.Shared.Items["rubber"]["label"] .. ": 145x."},
		[17] = {costs = "Craft: "..scCore.Shared.Items["metalscrap"]["label"] .. ": 230x, " ..scCore.Shared.Items["steel"]["label"] .. ": 110x, "..scCore.Shared.Items["rubber"]["label"] .. ": 130x."},
		[18] = {costs = "Craft: "..scCore.Shared.Items["metalscrap"]["label"] .. ": 270x, " ..scCore.Shared.Items["steel"]["label"] .. ": 260x, "..scCore.Shared.Items["rubber"]["label"] .. ": 155x."},
		[19] = {costs = "Craft: "..scCore.Shared.Items["metalscrap"]["label"] .. ": 300x, " ..scCore.Shared.Items["steel"]["label"] .. ": 150x, "..scCore.Shared.Items["rubber"]["label"] .. ": 170x."},
		[20] = {costs = "Craft: "..scCore.Shared.Items["aluminum"]["label"] .. ": 20x, " ..scCore.Shared.Items["pistol_grip"]["label"] .. ": 1x, "..scCore.Shared.Items["metal_spring"]["label"] .. ": 2x, "..scCore.Shared.Items["gun_trigger"]["label"] .. ": 1x, "..scCore.Shared.Items["bolt_assembly"]["label"] .. ": 1x, "..scCore.Shared.Items["smg_magazine"]["label"] .. ": 1x, ".. scCore.Shared.Items["smg_extractor"]["label"] .. ": 1x, "..scCore.Shared.Items["smg_barrel"]["label"] .. ": 1x."},
		[21] = {costs = "Craft: "..scCore.Shared.Items["metalscrap"]["label"] .. ": 205x, " ..scCore.Shared.Items["steel"]["label"] .. ": 340x, "..scCore.Shared.Items["rubber"]["label"] .. ": 110x, "..scCore.Shared.Items["smg_extendedclip"]["label"] .. ": 2x."},
		[22] = {costs = "Craft: "..scCore.Shared.Items["metalscrap"]["label"] .. ": 85x, " ..scCore.Shared.Items["steel"]["label"] .. ": 44x, "..scCore.Shared.Items["rubber"]["label"] .. ": 30x."},
		[23] = {costs = "Craft: "..scCore.Shared.Items["aluminum"]["label"] .. ": 40x, " ..scCore.Shared.Items["gun_trigger"]["label"] .. ": 1x, "..scCore.Shared.Items["metal_spring"]["label"] .. ": 2x, "..scCore.Shared.Items["ak_barrel"]["label"] .. ": 1x, "..scCore.Shared.Items["ak_magazine"]["label"] .. ": 1x, "..scCore.Shared.Items["ak_stock"]["label"] .. ": 1x, " .. scCore.Shared.Items["plastic"]["label"] .. ": 400x, ".. scCore.Shared.Items["ak_bolt"]["label"] .. ": 1x, ".. scCore.Shared.Items["ak_barrel_pin"]["label"] .. ": 1x, ".. scCore.Shared.Items["ak_piston_pin"]["label"] .. ": 1x, ".. scCore.Shared.Items["ak_receiver_cover"]["label"] .. ": 1x."},

		-- Blueprint shit
		[24] = {costs = "Craft: "..scCore.Shared.Items["aluminum"]["label"] .. ": 80x, " ..scCore.Shared.Items["gun_trigger"]["label"] .. ": 1x, "..scCore.Shared.Items["metal_spring"]["label"] .. ": 2x, "..scCore.Shared.Items["rifle_stock"]["label"] .. ": 1x, "..scCore.Shared.Items["rifle_stock_tube"]["label"] .. ": 1x, "..scCore.Shared.Items["rifle_grip"]["label"] .. ": 1x, " .. scCore.Shared.Items["plastic"]["label"] .. ": 200x."},
		[25] = {costs = "Craft: "..scCore.Shared.Items["aluminum"]["label"] .. ": 60x, " ..scCore.Shared.Items["gun_trigger"]["label"] .. ": 1x, "..scCore.Shared.Items["metal_spring"]["label"] .. ": 2x, "..scCore.Shared.Items["rifle_stock"]["label"] .. ": 1x, "..scCore.Shared.Items["rifle_stock_tube"]["label"] .. ": 1x, "..scCore.Shared.Items["rifle_grip"]["label"] .. ": 1x, ".. scCore.Shared.Items["plastic"]["label"] .. ": 300x."},
		[26] = {costs = "Craft: "..scCore.Shared.Items["aluminum"]["label"] .. ": 60x, " ..scCore.Shared.Items["gun_trigger"]["label"] .. ": 1x, "..scCore.Shared.Items["metal_spring"]["label"] .. ": 2x, "..scCore.Shared.Items["rifle_stock"]["label"] .. ": 1x, "..scCore.Shared.Items["rifle_stock_tube"]["label"] .. ": 1x, "..scCore.Shared.Items["rifle_grip"]["label"] .. ": 1x, ".. scCore.Shared.Items["plastic"]["label"] .. ": 420x."},
		[27] = {costs = "Craft: "..scCore.Shared.Items["aluminum"]["label"] .. ": 60x, " ..scCore.Shared.Items["gun_trigger"]["label"] .. ": 1x, "..scCore.Shared.Items["metal_spring"]["label"] .. ": 2x, "..scCore.Shared.Items["rifle_stock"]["label"] .. ": 1x, "..scCore.Shared.Items["rifle_stock_tube"]["label"] .. ": 1x, "..scCore.Shared.Items["rifle_grip"]["label"] .. ": 1x, ".. scCore.Shared.Items["plastic"]["label"] .. ": 300x."},
	}

	local items = {}
	for k, item in pairs(Config.CraftingItems) do
		local itemInfo = scCore.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfos[item.slot].costs,
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
			blueprintType = item.blueprintType,
		}
	end
	Config.CraftingItems = items
end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
	exports["lcrp-interact"]:AddTargetModel({-573669520}, {
		options = {
			{
				event = "inventory:client:OpenCrafting",
				icon = "fas fa-tools",
				label = "Crafting Bench",
				duty = false,
			},
		},
		job = {"all"}, distance = 1.5
	})
end)