Keys = {
	['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
	['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
	['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 215,
	['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
	['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
	['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
	['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
	['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

scCore = nil


Citizen.CreateThread(function()
    while scCore == nil do
        TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
        Citizen.Wait(200)
    end
end)



local inside = false
local currentpos = nil
local currentgarage = 0
local editCount = 0
local CurrentFuel = 0


local menu = Setmenu()
local myveh = {}

local gameplaycam = nil
local cam = nil

shopPercent = nil

local function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	DrawNotification(false, false)
end

local function f(n)
	return (n + 0.00001)
end

local function LocalPed()
	return GetPlayerPed(-1)
end

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function myveh.repair()
	SetVehicleFixed(myveh.vehicle)
end

local function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

local function StartFade()
	Citizen.CreateThread(function()
		DoScreenFadeOut(0)
		while IsScreenFadingOut() do
			Citizen.Wait(0)
		end
	end)
end
local function EndFade()
	Citizen.CreateThread(function()
		ShutdownLoadingScreen()

        DoScreenFadeIn(500)

        while IsScreenFadingIn() do
            Citizen.Wait(0)
        end
	end)
end

local function SetupModPrices()
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
	local model = GetEntityModel(vehicle)
	local percentage = shopPercent
	local vehiclePrice = 50000
	if scCore.Shared.VehicleModels[model] ~= nil then
		vehiclePrice = scCore.Shared.VehicleModels[model]["price"]
	end
	for k, v in pairs(LSC_Config.prices.mods[11]) do
		local price = ((vehiclePrice / 100) * percentage) + LSC_Config.prices.mods[11][k].DefaultPrice
		LSC_Config.prices.mods[11][k].price = math.ceil(price)
	end

	for k, v in pairs(LSC_Config.prices.mods[12]) do
		local price = ((vehiclePrice / 100) * percentage) + LSC_Config.prices.mods[12][k].DefaultPrice
		LSC_Config.prices.mods[12][k].price = math.ceil(price)
	end

	for k, v in pairs(LSC_Config.prices.mods[13]) do
		local price = ((vehiclePrice / 100) * percentage) + LSC_Config.prices.mods[13][k].DefaultPrice
		LSC_Config.prices.mods[13][k].price = math.ceil(price)
	end

	for k, v in pairs(LSC_Config.prices.mods[16]) do
		local price = ((vehiclePrice / 100) * percentage) + LSC_Config.prices.mods[16][k].DefaultPrice
		LSC_Config.prices.mods[16][k].price = math.ceil(price)
	end

	for k, v in pairs(LSC_Config.prices.mods[15]) do
		local price = ((vehiclePrice / 100) * percentage) + LSC_Config.prices.mods[15][k].DefaultPrice
		LSC_Config.prices.mods[15][k].price = math.ceil(price)
	end

	local price = ((vehiclePrice / 100) * percentage) + LSC_Config.prices.mods[18][2].DefaultPrice
	LSC_Config.prices.mods[18][2].price = math.ceil(price)
end

--Setup main menu
local LSCmenu = menu.new("Los Santos Customs","CATEGORIES", 0.16,0.13,0.24,0.36,0,{255,255,255,255})
LSCmenu.config.pcontrol = false

--Add mod to menu
local function AddMod(mod,parent,header,name,info,stock)
	local veh = myveh.vehicle
	SetVehicleModKit(veh,0)	
	if (GetNumVehicleMods(veh, mod) ~= nil and GetNumVehicleMods(veh,mod) > 0) or mod == 18 or mod == 22 then
		local m = parent:addSubmenu(header, name, info,true)
		if stock then
			local btn = m:addPurchase("Stock")
			btn.modtype = mod
			btn.mod = -1
		end
		if LSC_Config.prices.mods[mod].startprice then
			local price = LSC_Config.prices.mods[mod].startprice
			for i = 0,   tonumber(GetNumVehicleMods(veh,mod)) -1 do
				local lbl = GetModTextLabel(veh,mod,i)
				if lbl ~= nil then
					local mname = tostring(GetLabelText(lbl))
					if mname ~= "NULL" then
						local btn = m:addPurchase(mname,price)
						btn.modtype = mod
						btn.mod = i
						price = price + LSC_Config.prices.mods[mod].increaseby
					else
						mname = name.." #"..(i + 1)
						local btn = m:addPurchase(mname,price)
						btn.modtype = mod
						btn.mod = i
						price = price + LSC_Config.prices.mods[mod].increaseby
					end
				end
			end		
		else
			for n, v in pairs(LSC_Config.prices.mods[mod]) do
				btn = m:addPurchase(v.name,v.price)btn.modtype = mod
				btn.mod = v.mod
			end
		end
	end
end

--Set up inside camera
local function SetupInsideCam()
	local ped = LocalPed()
	local coords = currentpos.camera
	cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",true,2)
	SetCamCoord(cam, coords.x, coords.y, coords.z + 1.0)
	coords = currentpos.inside
	PointCamAtCoord(cam, coords.x, coords.y, coords.z)
	--PointCamAtEntity(cam, GetVehiclePedIsUsing(ped), p2, p3, p4, 1)
	SetCamActive(cam, true)
	RenderScriptCams( 1, 0, cam, 0, 0)
end

RegisterNetEvent('lscustoms:client:setGarageBusy')
AddEventHandler('lscustoms:client:setGarageBusy', function(garage, state)
	Config.Locations[myShop]["mod"][garage].isBusy = state
end)

RegisterNetEvent('lscustoms:client:getPriceMultiplier')
AddEventHandler('lscustoms:client:getPriceMultiplier', function(multiplier)
	shopPercent = multiplier
end)

RegisterNetEvent('lscustoms:client:updatePriceMultiplier')
AddEventHandler('lscustoms:client:updatePriceMultiplier', function(multiplier, shop)
	if myShop == shop then
		shopPercent = multiplier
	end
end)

RegisterNetEvent("lcrp-tuning:client:OpenLSCustoms")
AddEventHandler("lcrp-tuning:client:OpenLSCustoms", function()
	if inside == false then
		if PlayerJob ~= nil then
			if string.match(PlayerJob.name, "mechanic") then 
				if myShop ~= nil then 
					local ped = GetPlayerPed(-1)
					if IsPedSittingInAnyVehicle(ped) then
						local veh = GetVehiclePedIsUsing(ped)
						if DoesEntityExist(veh) and GetPedInVehicleSeat(veh, -1) == ped then
							for i,pos in ipairs(Config.Locations[myShop]["mod"]) do
								coords = pos.inside		
								if GetDistanceBetweenCoords(coords.x,coords.y,coords.z,GetEntityCoords(ped)) <= 5 then
									if not Config.Locations[myShop]["mod"][i].isBusy then
										if not tableContains(LSC_Config.ModelBlacklist,GetDisplayNameFromVehicleModel(GetEntityModel(veh)):lower()) then
											SetupModPrices()
											inside = true
											currentpos = pos
											currentgarage = i
											editCount = 0
											DriveInGarage()
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)

--So we can actually enter it?
function DriveInGarage()

	--Lock the garage
	--TriggerServerEvent('lockGarage',true,currentgarage)
	SetPlayerControl(PlayerId(),false,256)
	--StartFade()
	
	local pos = currentpos
	local ped = GetPlayerPed(-1)
	local veh = GetVehiclePedIsUsing(ped)
	CurrentFuel = exports['LegacyFuel']:GetFuel(veh)
	LSCmenu.buttons = {}

	DisplayRadar(false)
	if DoesEntityExist(veh) then
		--Set menu title
		
		LSCmenu:setTitle("Benny's Motorworks")
		LSCmenu.title_sprite = "shopui_title_supermod"
	
		-- if currentgarage == 4 or currentgarage == 5 then
		-- 	LSCmenu:setTitle("Beeker's Garage")
		-- 	LSCmenu.title_sprite = "shopui_title_carmod2"
		-- elseif currentgarage == 6 then
		-- 		LSCmenu:setTitle("Benny's Motorworks")
		-- 		LSCmenu.title_sprite = "shopui_title_supermod"
		-- elseif currentgarage == 1 or currentgarage == 2 or currentgarage == 3 then
		-- 	LSCmenu:setTitle("Los Santos Customs")
		-- 	LSCmenu.title_sprite = "shopui_title_carmod"
		-- end

		TriggerServerEvent('lcrp-lscustoms:server:setGarageBusy', currentgarage, true)
		
		-------------------------------Load some settings-----------------------------------
		
		--Controls
		LSCmenu.config.controls = LSC_Config.menu.controls
		 
		 --Max buttons
		LSCmenu:setMaxButtons(LSC_Config.menu.maxbuttons)
		
		--Width, height of menu
		LSCmenu.config.size.width = f(LSC_Config.menu.width) or 0.24;
		LSCmenu.config.size.height = f(LSC_Config.menu.height) or 0.36;
		
		--Position
		if type(LSC_Config.menu.position) == 'table' then
			LSCmenu.config.position = { x = LSC_Config.menu.position.x, y = LSC_Config.menu.position.y}
		elseif type(LSC_Config.menu.position) == 'string' then
			if LSC_Config.menu.position == "left" then
				LSCmenu.config.position = { x = 0.16, y = 0.13}
			elseif  LSC_Config.menu.position == "right" then
				LSCmenu.config.position = { x = 1-0.16, y = 0.13}
			end
		end
		
		--Theme
		if type(LSC_Config.menu.theme) == "table" then
			LSCmenu:setColors(LSC_Config.menu.theme.text_color,LSC_Config.menu.theme.stext_color,LSC_Config.menu.theme.bg_color,LSC_Config.menu.theme.sbg_color)
		elseif	type(LSC_Config.menu.theme) == "string" then
			if LSC_Config.menu.theme == "light" then
				--text_color,stext_color,bg_color,sbg_color
				LSCmenu:setColors({ r = 255,g = 255, b = 255, a = 255},{ r = 0,g = 0, b = 0, a = 255},{ r = 0,g = 0, b = 0, a = 155},{ r = 255,g = 255, b = 255, a = 255})
			elseif LSC_Config.menu.theme == "darkred" then
				LSCmenu:setColors({ r = 255,g = 255, b = 255, a = 255},{ r = 0,g = 0, b = 0, a = 255},{ r = 0,g = 0, b = 0, a = 155},{ r = 200,g = 15, b = 15, a = 200})
			elseif LSC_Config.menu.theme == "bluish" then	
				LSCmenu:setColors({ r = 255,g = 255, b = 255, a = 255},{ r = 255,g = 255, b = 255, a = 255},{ r = 0,g = 0, b = 0, a = 100},{ r = 0,g = 100, b = 255, a = 200})
			elseif LSC_Config.menu.theme == "greenish" then	
				LSCmenu:setColors({ r = 255,g = 255, b = 255, a = 255},{ r = 0,g = 0, b = 0, a = 255},{ r = 0,g = 0, b = 0, a = 100},{ r = 0,g = 200, b = 0, a = 200})
			end
		end
		
		LSCmenu:addSubmenu("CATEGORIES", "categories",nil, false)
		LSCmenu.categories.buttons = {}
		--Calculate price for vehicle repair and add repair  button
		local maxvehhp = 1000
		local damage = 0
		damage = (maxvehhp - GetVehicleBodyHealth(veh))/100
		LSCmenu:addPurchase("Fix vehicle", round(250+150*damage,0))
		
		--Setup table for vehicle with all mods, colors etc.
		SetVehicleModKit(veh,0)	
		myveh.vehicle = veh
		myveh.model = GetDisplayNameFromVehicleModel(GetEntityModel(veh)):lower()
		myveh.color =  table.pack(GetVehicleColours(veh))
		myveh.extracolor = table.pack(GetVehicleExtraColours(veh))
		myveh.color[3] = myveh.extracolor[1]
		myveh.neoncolor = table.pack(GetVehicleNeonLightsColour(veh))
		myveh.smokecolor = table.pack(GetVehicleTyreSmokeColor(veh))
		myveh.plateindex = GetVehicleNumberPlateTextIndex(veh)
		myveh.mods = {}
		for i = 0, 48 do
			myveh.mods[i] = {mod = nil}
		end
		for i,t in pairs(myveh.mods) do 
			if i == 22 or i == 18 then
				if IsToggleModOn(veh,i) then
				t.mod = 1
				else
				t.mod = 0
				end
			elseif i == 23 or i == 24 then
				t.mod = GetVehicleMod(veh,i)
				t.variation = GetVehicleModVariation(veh, i)
			else
				t.mod = GetVehicleMod(veh,i)
			end
		end
		if GetVehicleWindowTint(veh) == -1 or GetVehicleWindowTint(veh) == 0 then
			myveh.windowtint = false
		else
			myveh.windowtint = GetVehicleWindowTint(veh)
		end
		myveh.wheeltype = GetVehicleWheelType(veh)
		myveh.bulletProofTyres = GetVehicleTyresCanBurst(veh)
		
		--menu stuff 
		local chassis,interior,bumper,fbumper,rbumper = false,false,false,false
		
		for i = 0,48 do
			if GetNumVehicleMods(veh,i) ~= nil and GetNumVehicleMods(veh,i) ~= false and GetNumVehicleMods(veh,i) > 0 then
				if i == 1 then
					bumper = true
					fbumper = true
				elseif i == 2 then
					bumper = true
					rbumper = true
				elseif (i >= 42 and i <= 46) or i == 5 then --If any chassis mod exist then add chassis menu
					chassis = true
				elseif i >= 27 and i <= 37 then --If any interior mod exist then add interior menu
					interior = true
				end
			end
		end
		
		AddMod(0,LSCmenu.categories,"SPOILER", "Spoiler", nil,true)
		AddMod(3,LSCmenu.categories,"SKIRTS", "Skirts", nil,true)
		AddMod(4,LSCmenu.categories,"EXHAUST", "Exhausts", nil,true)
		AddMod(6,LSCmenu.categories,"GRILLE", "Grille", nil,true)
		AddMod(7,LSCmenu.categories,"HOOD", "Hood", nil,true)
		AddMod(8,LSCmenu.categories,"FENDERS", "Fenders", nil,true)
		if (not RoofNotAllowed(veh)) then
			AddMod(10,LSCmenu.categories,"ROOF", "Roof", nil,true)
		end

		
		AddMod(12,LSCmenu.categories,"BRAKES", "Brakes", nil,true)
		AddMod(13,LSCmenu.categories,"TRANSMISSION", "Transmission", nil,true)


		AddMod(14,LSCmenu.categories,"HORN", "Horn", nil,true)
		
		
		AddMod(15,LSCmenu.categories,"SUSPENSION","Suspension",nil,true)
		AddMod(16,LSCmenu.categories,"ARMOR","Armor",nil,true)
		AddMod(18, LSCmenu.categories, "TURBO", "Turbo", nil,false)
		
		
		if chassis then
			LSCmenu.categories:addSubmenu("CHASSIS", "Chassis",nil, true)
			AddMod(42, LSCmenu.categories.Chassis, "ARCH COVER", "Arch cover", nil,true) --headlight trim
			AddMod(43, LSCmenu.categories.Chassis, "AERIALS", "Aerials", nil,true) --foglights
			AddMod(44, LSCmenu.categories.Chassis, "ROOF SCOOPS", "Roof Scoops", nil,true) --roof scoops
			AddMod(45, LSCmenu.categories.Chassis, "Tank", "Tank", nil,true)
			AddMod(46, LSCmenu.categories.Chassis, "DOORS", "Doors", nil,true)-- windows
			AddMod(5,LSCmenu.categories.Chassis,"ROLL CAGE", "Roll cage", nil,true)
		end


		LSCmenu.categories:addSubmenu("ENGINE", "Engine",nil, true)
		AddMod(39, LSCmenu.categories.Engine, "ENGINE BLOCK", "Engine Block", nil,true)
		AddMod(40, LSCmenu.categories.Engine, "CAM COVER", "Cam Cover", nil,true)
		AddMod(41, LSCmenu.categories.Engine, "STRUT BRACE", "Strut Brace", nil,true)
		AddMod(11,LSCmenu.categories.Engine,"ENGINE TUNES", "Engine Tunes", nil,true)

		
		if interior then
			LSCmenu.categories:addSubmenu("INTERIOR", "Interior","", true)
			--LSCmenu.categories.Interior:addSubmenu("TRIM", "Trim","A selection of interior designs.", true)
			AddMod(27, LSCmenu.categories.Interior, "TRIM DESIGN", "Trim Design", nil,true)
			--There are'nt any working natives that could change interior color :(
			--LSCmenu.categories.Interior.Trim:addSubmenu("TRIM COLOR", "Trim Color","", true)
			AddMod(28, LSCmenu.categories.Interior, "ORNAMENTS", "Ornaments", nil,true)
			AddMod(29, LSCmenu.categories.Interior, "DASHBOARD", "Dashboard", nil,true)
			AddMod(30, LSCmenu.categories.Interior, "DIAL DESIGN", "Dials", nil,true)
			AddMod(31, LSCmenu.categories.Interior, "DOORS", "Doors", nil,true)
			AddMod(32, LSCmenu.categories.Interior, "SEATS", "Seats", nil,true)
			AddMod(33, LSCmenu.categories.Interior, "STEERING WHEELS", "Steering Wheels", nil,true)
			AddMod(34, LSCmenu.categories.Interior, "Shifter leavers", "Shifter leavers", nil,true)
			AddMod(35, LSCmenu.categories.Interior, "Plaques", "Plaques", nil,true)
			AddMod(36, LSCmenu.categories.Interior, "Speakers", "Speakers", nil,true)
			AddMod(37, LSCmenu.categories.Interior, "Trunk", "Trunk", nil,true)
		end
		
		LSCmenu.categories:addSubmenu("PLATES", "Plates",nil, true)
		LSCmenu.categories.Plates:addSubmenu("LICENSE", "License", nil,true)
		for n, mod in pairs(LSC_Config.prices.plates) do
			local btn = LSCmenu.categories.Plates.License:addPurchase(mod.name,mod.price)btn.plateindex = mod.plateindex
		end
		--Customize license plates
		AddMod(25, LSCmenu.categories.Plates, "Plate holder", "Plate holder", nil,true) --
		AddMod(26, LSCmenu.categories.Plates, "Vanity plates", "Vanity plates", nil,true) --
		--AddMod(47, LSCmenu.categories, "UNK47", "unk47", "",true)
		--AddMod(49, LSCmenu.categories, "UNK49", "unk49", "",true)
		AddMod(38,LSCmenu.categories,"HYDRAULICS","Hydraulics",nil, true)
		AddMod(48,LSCmenu.categories,"Liveries", "Liveries", nil, true)
		
		if bumper then
			LSCmenu.categories:addSubmenu("BUMPERS", "Bumpers", nil,true)
			if fbumper then
				AddMod(1,LSCmenu.categories.Bumpers,"FRONT BUMPERS", "Front bumpers", nil,true)
			end
			if rbumper then
				AddMod(2,LSCmenu.categories.Bumpers,"REAR BUMPERS", "Rear bumpers", nil,true)
			end
		end
		
		local m = LSCmenu.categories:addSubmenu("LIGHTS", "Lights", nil,true)
		AddMod(22,LSCmenu.categories.Lights,"HEADLIGHTS", "Headlights", nil, false)

		if not IsThisModelABike(GetEntityModel(veh)) then
			m = m:addSubmenu("NEON KITS", "Neon kits", nil, true)
			m:addSubmenu("NEON LAYOUT", "Neon layout", nil, true)
			local btn = m["Neon layout"]:addPurchase("None")

			for n, mod in pairs(LSC_Config.prices.neonlayout) do
				local btn = m["Neon layout"]:addPurchase(mod.name,mod.price)
			end
			
			m = m:addSubmenu("NEON COLOR", "Neon color", nil, true)
			for n, mod in pairs(LSC_Config.prices.neoncolor) do
					local btn = m:addPurchase(mod.name,mod.price)btn.neon = mod.neon
			end
		end

		
		respray = LSCmenu.categories:addSubmenu("RESPRAY", "Respray", nil,true)
			pcol = respray:addSubmenu("PRIMARY COLORS", "Primary color",  nil,true)
				pcol:addSubmenu("CHROME", "Chrome", nil,true)
				for n, c in pairs(LSC_Config.prices.chrome.colors) do
					local btn = pcol.Chrome:addPurchase(c.name,LSC_Config.prices.chrome.price)btn.colorindex = c.colorindex
					if btn.colorindex == myveh.color[1] then
						btn.purchased = true
					end
				end
				pcol:addSubmenu("CLASSIC", "Classic", nil,true)
				for n, c in pairs(LSC_Config.prices.classic.colors) do
					local btn = pcol.Classic:addPurchase(c.name,LSC_Config.prices.classic.price)btn.colorindex = c.colorindex
					if btn.colorindex == myveh.color[1] then
						btn.purchased = true
					end
				end
				pcol:addSubmenu("MATTE", "Matte", nil,true)
				for n, c in pairs(LSC_Config.prices.matte.colors) do
					local btn = pcol.Matte:addPurchase(c.name,LSC_Config.prices.matte.price)btn.colorindex = c.colorindex
					if btn.colorindex == myveh.color[1] then
						btn.purchased = true
					end
				end
				pcol:addSubmenu("METALLIC", "Metallic", nil,true)
				for n, c in pairs(LSC_Config.prices.metallic.colors) do
					local btn = pcol.Metallic:addPurchase(c.name,LSC_Config.prices.metallic.price)btn.colorindex = c.colorindex
					if btn.colorindex == myveh.color[1] and myveh.extracolor[1] == myveh.color[2] then
						btn.purchased = true
					end
				end
				pcol:addSubmenu("METALS", "Metals", nil,true)
				for n, c in pairs(LSC_Config.prices.metal.colors) do
					local btn = pcol.Metals:addPurchase(c.name,LSC_Config.prices.metal.price)btn.colorindex = c.colorindex
					if btn.colorindex == myveh.color[1] then
						btn.purchased = true
					end
				end
			scol = respray:addSubmenu("SECONDARY COLORS", "Secondary color", nil,true)
				scol:addSubmenu("CHROME", "Chrome", nil,true)
				for n, c in pairs(LSC_Config.prices.chrome2.colors) do
					local btn = scol.Chrome:addPurchase(c.name,LSC_Config.prices.chrome2.price)btn.colorindex = c.colorindex
					if btn.colorindex == myveh.color[2] then
						btn.purchased = true
					end
				end
				scol:addSubmenu("CLASSIC", "Classic", nil,true)
				for n, c in pairs(LSC_Config.prices.classic2.colors) do
					local btn = scol.Classic:addPurchase(c.name,LSC_Config.prices.classic2.price)btn.colorindex = c.colorindex
					if btn.colorindex == myveh.color[2] then
						btn.purchased = true
					end
				end
				scol:addSubmenu("MATTE", "Matte", nil,true)
				for n, c in pairs(LSC_Config.prices.matte2.colors) do
					local btn = scol.Matte:addPurchase(c.name,LSC_Config.prices.matte2.price)btn.colorindex = c.colorindex
					if btn.colorindex == myveh.color[2] then
						btn.purchased = true
					end
				end
				scol:addSubmenu("METALLIC", "Metallic", nil,true)
				for n, c in pairs(LSC_Config.prices.metallic2.colors) do
					local btn = scol.Metallic:addPurchase(c.name,LSC_Config.prices.metallic2.price)btn.colorindex = c.colorindex
					if btn.colorindex == myveh.color[2] and myveh.extracolor[1] == btn.colorindex then
						btn.purchased = true
					end
				end
				scol:addSubmenu("METALS", "Metals", nil,true)
				for n, c in pairs(LSC_Config.prices.metal2.colors) do
					local btn = scol.Metals:addPurchase(c.name,LSC_Config.prices.metal2.price)btn.colorindex = c.colorindex
					if btn.colorindex == myveh.color[2] then
						btn.purchased = true
					end
				end
			perl = respray:addSubmenu("PEARLESCENT", "Pearlescent color", nil,true)
			perl:addSubmenu("CHROME", "Chrome", nil,true)
				for n, c in pairs(LSC_Config.prices.chrome2.colors) do
					local btn = perl.Chrome:addPurchase(c.name,LSC_Config.prices.chrome2.price)btn.colorindex = c.colorindex
					if btn.colorindex == myveh.color[3] then
						btn.purchased = true
					end
				end
				perl:addSubmenu("CLASSIC", "Classic", nil,true)
				for n, c in pairs(LSC_Config.prices.classic2.colors) do
					local btn = perl.Classic:addPurchase(c.name,LSC_Config.prices.classic2.price)btn.colorindex = c.colorindex
					if btn.colorindex == myveh.color[3] then
						btn.purchased = true
					end
				end
				perl:addSubmenu("MATTE", "Matte", nil,true)
				for n, c in pairs(LSC_Config.prices.matte2.colors) do
					local btn = perl.Matte:addPurchase(c.name,LSC_Config.prices.matte2.price)btn.colorindex = c.colorindex
					if btn.colorindex == myveh.color[3] then
						btn.purchased = true
					end
				end
				perl:addSubmenu("METALLIC", "Metallic", nil,true)
				for n, c in pairs(LSC_Config.prices.metallic2.colors) do
					local btn = perl.Metallic:addPurchase(c.name,LSC_Config.prices.metallic2.price)btn.colorindex = c.colorindex
					if btn.colorindex == myveh.color[3] and myveh.extracolor[1] == btn.colorindex then
						btn.purchased = true
					end
				end
				perl:addSubmenu("METALS", "Metals", nil,true)
				for n, c in pairs(LSC_Config.prices.metal2.colors) do
					local btn = perl.Metals:addPurchase(c.name,LSC_Config.prices.metal2.price)btn.colorindex = c.colorindex
					if btn.colorindex == myveh.color[3] then
						btn.purchased = true
					end
				end
		
		
		LSCmenu.categories:addSubmenu("WHEELS", "Wheels", nil,true)
			wtype = LSCmenu.categories.Wheels:addSubmenu("WHEEL TYPE", "Wheel type", nil,true)
				if IsThisModelABike(GetEntityModel(veh)) then
					fwheels = wtype:addSubmenu("FRONT WHEEL", "Front wheel", nil,true)
						for n, w in pairs(LSC_Config.prices.frontwheel) do
							btn = fwheels:addPurchase(w.name,w.price)btn.wtype = w.wtype btn.modtype = 23 btn.mod = w.mod
						end
					bwheels = wtype:addSubmenu("BACK WHEEL", "Back wheel", nil,true)
						for n, w in pairs(LSC_Config.prices.backwheel) do
							btn = bwheels:addPurchase(w.name,w.price)btn.wtype = w.wtype btn.modtype = 24 btn.mod = w.mod
						end
				else
					sportw = wtype:addSubmenu("SPORT WHEELS", "Sport", nil,true)
						for n, w in pairs(LSC_Config.prices.sportwheels) do
							local btn = sportw:addPurchase(w.name,w.price)btn.wtype = w.wtype btn.modtype = 23 btn.mod = w.mod
						end
					musclew = wtype:addSubmenu("MUSCLE WHEELS", "Muscle", nil,true)
						for n, w in pairs(LSC_Config.prices.musclewheels) do
							local btn = musclew:addPurchase(w.name,w.price)btn.wtype =  w.wtype btn.modtype = 23 btn.mod = w.mod
						end
					lowriderw = wtype:addSubmenu("LOWRIDER WHEELS", "Lowrider", nil,true)
						for n, w in pairs(LSC_Config.prices.lowriderwheels) do
							local btn = lowriderw:addPurchase(w.name,w.price)btn.wtype =  w.wtype btn.modtype = 23 btn.mod = w.mod
						end
					suvw = wtype:addSubmenu("SUV WHEELS", "Suv", nil,true)
						for n, w in pairs(LSC_Config.prices.suvwheels) do
							local btn = suvw:addPurchase(w.name,w.price)btn.wtype = w.wtype btn.modtype = 23 btn.mod = w.mod
						end
					offroadw = wtype:addSubmenu("OFFROAD WHEELS", "Offroad", nil,true)
						for n, w in pairs(LSC_Config.prices.offroadwheels) do
							local btn = offroadw:addPurchase(w.name,w.price)btn.wtype = w.wtype btn.modtype = 23 btn.mod = w.mod
						end
					tunerw = wtype:addSubmenu("TUNER WHEELS", "Tuner", nil,true)
						for n, w in pairs(LSC_Config.prices.tunerwheels) do
							local btn = tunerw:addPurchase(w.name,w.price)btn.wtype = w.wtype btn.modtype = 23 btn.mod = w.mod
						end
					hughendw = wtype:addSubmenu("HIGHEND WHEELS", "Highend", nil,true)
						for n, w in pairs(LSC_Config.prices.highendwheels) do
							local btn = hughendw:addPurchase(w.name,w.price)btn.wtype = w.wtype btn.modtype = 23 btn.mod = w.mod
						end
					customwheels = wtype:addSubmenu("CUSTOM WHEELS", "Custom Tires", nil,true)
						for i = 51, 138, 1 do
							local veh = myveh.vehicle
							local lbl = GetModTextLabel(veh, 23, i)
							local mname = tostring(GetLabelText(lbl))
							local btn = customwheels:addPurchase(mname, 1000)btn.wtype = 0 btn.modtype = 23 btn.mod = i
						end
				end
					
		m = LSCmenu.categories.Wheels:addSubmenu("WHEEL COLOR", "Wheel color", nil, true)
			for n, c in pairs(LSC_Config.prices.wheelcolor.colors) do
				local btn = m:addPurchase(c.name,LSC_Config.prices.wheelcolor.price)btn.colorindex = c.colorindex
			end
		
		m = LSCmenu.categories.Wheels:addSubmenu("WHEEL ACCESSORIES", "Wheel accessories", nil, true)
			for n, mod in pairs(LSC_Config.prices.wheelaccessories) do
				local btn = m:addPurchase(mod.name,mod.price)btn.smokecolor = mod.smokecolor
			end
		
		m = LSCmenu.categories:addSubmenu("WINDOWS", "Windows", nil, true)	
			btn = m:addPurchase("None")btn.tint = false
			for n, tint in pairs(LSC_Config.prices.windowtint) do
				btn = m:addPurchase(tint.name,tint.price)btn.tint = tint.tint
			end
			
		Citizen.CreateThread(function()
			local shouldSet = false
			if pos.inside.z ~= 38.86 then
				shouldSet = true
			end
			if shouldSet then
				SetEntityCoords(veh,pos.inside.x, pos.inside.y, pos.inside.z)
				SetEntityHeading(veh,pos.outside.heading)
				SetVehicleOnGroundProperly(veh)
			end
			SetVehicleDoorsLocked(veh,4)
			SetPlayerInvincible(GetPlayerIndex(),true)
			Citizen.Wait(50)
			
			local c = 0
			while not IsVehicleStopped(veh) do
				Citizen.Wait(0)
				c = c + 1
				if c > 5000 then
					ClearPedTasks(ped)
					break
				end
			end
			Citizen.Wait(100)
			
			if IsVehicleDamaged(veh) or GetVehicleBodyHealth(veh) < 980 or GetVehicleEngineHealth(veh) < 980 then -- hieromate
				LSCmenu:Open("main")
			else
				LSCmenu:Open("categories")
			end
			
			FreezeEntityPosition(veh, true)
			SetEntityCollision(veh,false,false)
			SetPlayerControl(PlayerId(),true)
		end)
	end
end

local function DriveOutOfGarage(pos)
	Citizen.CreateThread(function()
		local ped = LocalPed()
		local veh = GetVehiclePedIsUsing(ped)
		
		pos = currentpos

		scCore.TaskBar("vehicletune_editvehicle", "Finishing", (editCount * 500), false, false, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function() -- Done
			SetEntityCollision(veh,true,true)
			FreezeEntityPosition(ped, false)
			FreezeEntityPosition(veh, false)
			local shouldSet = false
			if pos.inside.z ~= 38.86 then
				shouldSet = true
			end
			if shouldSet then
				SetEntityCoords(veh,pos.inside.x, pos.inside.y, pos.inside.z)
				SetEntityHeading(veh,pos.outside.heading)
				SetVehicleOnGroundProperly(veh)
			end
			SetVehicleDoorsLocked(veh,0)
			SetPlayerInvincible(GetPlayerIndex(),false)
			NetworkLeaveTransition()
			exports['LegacyFuel']:SetFuel(veh, CurrentFuel)
			
			NetworkFadeInEntity(veh, 1)	
			NetworkRegisterEntityAsNetworked(veh)
			ClearPedTasks(ped)
			inside = false
		
			currentgarage = 0
			SetPlayerControl(PlayerId(),true)
	
			TriggerServerEvent("lscustoms:server:SaveVehicleProps", scCore.Functions.GetVehicleProperties(veh))

			TriggerServerEvent('lscustoms:server:setGarageBusy', currentgarage, false)
			--TriggerServerEvent('lockGarage',false,lsc.currentgarage)
		end)
	end)
end

--Draw text on screen
local function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)	
end

--Get the length of table
local function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

--Check if table contains value
function tableContains(t,val)
	for k,v in pairs(t) do
		if v == val then
			return true
		end
	end
	return false
end

Citizen.CreateThread(function()
	for i,pos in ipairs(Config.Blips) do
		bennysBlip = AddBlipForCoord(pos.x, pos.y, pos.z)
		SetBlipAsFriendly(bennysBlip, true)
		SetBlipSprite(bennysBlip, 446)
		SetBlipColour(bennysBlip, 68)
		SetBlipScale(bennysBlip, 0.9)
		SetBlipAsShortRange(bennysBlip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Bennys")
		EndTextCommandSetBlipName(bennysBlip)
	end
	bennysBlip = AddBlipForCoord(-339.123, -133.25, 38.63)
	SetBlipAsFriendly(bennysBlip, true)
	SetBlipSprite(bennysBlip, 446)
	SetBlipColour(bennysBlip, 7)
	SetBlipScale(bennysBlip, 0.9)
	SetBlipAsShortRange(bennysBlip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Lucid Motors")
	EndTextCommandSetBlipName(bennysBlip)
end)

--Lets drive out of the garage 
function LSCmenu:OnmenuClose(m)
	DriveOutOfGarage(currentpos.outside)
end

function LSCmenu:onSelectedIndexChanged(name, button)
	name = name:lower()
	local m = LSCmenu.currentmenu
	local price = button.price or 0
	local veh = myveh.vehicle
	p = m.parent or self.name
	if m == "main" then
		m = self
	end
	CheckPurchases(m)
	m = m.name:lower()
	p = p:lower()
	--set up temporary shitt, or in other words show preview of selected mod
	if m == "chrome" or m ==  "classic" or m ==  "matte" or m ==  "metals" then
		if p == "primary color" then
			SetVehicleColours(veh,button.colorindex,myveh.color[2])
		elseif p == "secondary color" then
			SetVehicleColours(veh,myveh.color[1],button.colorindex)	
		else
			SetVehicleExtraColours(veh, button.colorindex, myveh.extracolor[2])
		end
	elseif m == "metallic" then
		if p == "primary color" then
			SetVehicleColours(veh,button.colorindex,myveh.color[2])
		elseif p == "secondary color" then
			SetVehicleColours(veh,myveh.color[1],button.colorindex)	
		else	
			SetVehicleExtraColours(veh, button.colorindex, myveh.extracolor[2])
		end
	elseif m == "wheel color" then
		SetVehicleExtraColours(veh,myveh.color[3], button.colorindex)
	elseif button.modtype and button.mod then
		if button.modtype ~= 18 and button.modtype ~= 22 then
			if button.wtype then
				SetVehicleWheelType(veh,button.wtype)
			end
			SetVehicleMod(veh,button.modtype, button.mod)	
		elseif button.modtype == 22 then
			ToggleVehicleMod(veh,button.modtype, button.mod)
		elseif button.modtype == 18 then
		end
	elseif m == "license" then
		SetVehicleNumberPlateTextIndex(veh,button.plateindex)
	elseif m == "neon color" then
		SetVehicleNeonLightsColour(veh,button.neon[1], button.neon[2], button.neon[3])
	elseif m == "windows" then
		SetVehicleWindowTint(veh, button.tint)
	else
	end
	if m == "horn" then
		--Maybe some way of playing the horn?
		OverrideVehHorn(veh,false,0)
		if IsHornActive(veh) or IsControlPressed(1,86) then
			StartVehicleHorn(veh, 10000, "HELDDOWN", 1)
		end
	end
end
--Didnt even need to use this 
function LSCmenu:OnmenuOpen(menu)

end

function LSCmenu:onButtonSelected(name, button)
	--Send the selected button to server
	if button.price then
		if not button.purchased then
			local closestPlayer, closestDistance = GetClosestPlayer()
			local closestPlayerId = GetPlayerServerId(closestPlayer)
			TriggerServerEvent("LSC:buttonSelected", name, button, closestPlayerId, myShop)
		end
	end
	
end


--So we get the button back from server +  bool that determines if we can prchase specific item or not
RegisterNetEvent("LSC:buttonSelected")
AddEventHandler("LSC:buttonSelected", function(name, button, canpurchase)
	name = name:lower()
	local m = LSCmenu.currentmenu
	local price = button.price or 0
	local veh = myveh.vehicle
	if m == "main" then
		m = LSCmenu
	end
	
	mname = m.name:lower()
	--Bunch of button shitt, that gets executed if button is selected + goes through checks
	if mname == "chrome" or mname ==  "classic" or mname ==  "matte" or mname ==  "metals" then
		if m.parent == "Primary color" then
			if button.name == "Stock" or button.purchased or CanPurchase(price, canpurchase) then
				myveh.color[1] = button.colorindex
			end
		elseif m.parent == "Secondary color" then
			if button.name == "Stock" or button.purchased or CanPurchase(price, canpurchase) then
				myveh.color[2] = button.colorindex
			end
		else
			if button.name == "Stock" or button.purchased or CanPurchase(price, canpurchase) then
				myveh.color[3] = button.colorindex
			end
		end
	elseif mname == "metallic" then
		if m.parent == "Primary color" then
			if button.name == "Stock" or button.purchased or CanPurchase(price, canpurchase)then
				myveh.color[1] = button.colorindex
			end
		elseif m.parent == "Secondary color" then
			if button.name == "Stock" or button.purchased or CanPurchase(price, canpurchase)then
				myveh.color[2] = button.colorindex
			end
		else
			if button.name == "Stock" or button.purchased or CanPurchase(price, canpurchase)then
				myveh.color[3] = button.colorindex
			end
		end	
	elseif mname == "liveries" or mname == "hydraulics" or mname == "horn" or mname == "tank" or mname == "ornaments" or  mname == "arch cover" or mname == "aerials" or mname == "roof scoops" or mname == "doors" or mname == "roll cage" or mname == "engine block" or mname == "cam cover" or mname == "strut brace" or mname == "trim design" or mname == "ormnametns" or mname == "dashboard" or mname == "dials" or mname == "seats" or mname == "steering wheels" or mname == "plate holder" or mname == "vanity plates" or mname == "shifter leavers" or mname == "plaques" or mname == "speakers" or mname == "trunk" or mname == "armor" or mname == "suspension" or mname == "transmission" or mname == "brakes" or mname == "engine tunes" or mname == "roof" or mname == "hood" or mname == "grille" or mname == "roll cage" or mname == "exhausts" or mname == "skirts" or mname == "rear bumpers" or mname == "front bumpers" or mname == "spoiler" then
		if button.name == "Stock" or button.purchased or CanPurchase(price, canpurchase)then
			myveh.mods[button.modtype].mod = button.mod
			SetVehicleMod(veh,button.modtype,button.mod)
		end
	elseif mname == "fenders" then
		if button.name == "Stock" or button.purchased or CanPurchase(price, canpurchase)then
			if button.name == "Stock" then
				myveh.mods[8].mod = button.mod
				myveh.mods[9].mod = button.mod
				SetVehicleMod(veh,9,button.mod)
				SetVehicleMod(veh,8,button.mod)
			else
				myveh.mods[button.modtype].mod = button.mod
				SetVehicleMod(veh,button.modtype,button.mod)
			end
		end
	elseif mname == "turbo" or mname == "headlights" then
		if button.name == "None" or button.name == "Stock Lights" or button.purchased or CanPurchase(price, canpurchase) then
			myveh.mods[button.modtype].mod = button.mod
			ToggleVehicleMod(veh, button.modtype, button.mod)
		end
	elseif mname == "neon layout" then
		if button.name == "None"  then
			SetVehicleNeonLightEnabled(veh,0,false)
			SetVehicleNeonLightEnabled(veh,1,false)
			SetVehicleNeonLightEnabled(veh,2,false)
			SetVehicleNeonLightEnabled(veh,3,false)
			myveh.neoncolor[1] = 255
			myveh.neoncolor[2] = 255
			myveh.neoncolor[3] = 255
			SetVehicleNeonLightsColour(veh,255,255,255)
		elseif button.purchased or CanPurchase(price, canpurchase) then
			if not myveh.neoncolor[1] then
				myveh.neoncolor[1] = 255
				myveh.neoncolor[2] = 255
				myveh.neoncolor[3] = 255
			end
			SetVehicleNeonLightsColour(veh,myveh.neoncolor[1],myveh.neoncolor[2],myveh.neoncolor[3])
			SetVehicleNeonLightEnabled(veh,0,true)
			SetVehicleNeonLightEnabled(veh,1,true)
			SetVehicleNeonLightEnabled(veh,2,true)
			SetVehicleNeonLightEnabled(veh,3,true)
		end
	elseif mname == "neon color" then
		if button.purchased or CanPurchase(price, canpurchase) then
			myveh.neoncolor[1] = button.neon[1]
			myveh.neoncolor[2] = button.neon[2]
			myveh.neoncolor[3] = button.neon[3]
			SetVehicleNeonLightsColour(veh,button.neon[1],button.neon[2],button.neon[3])
		end
	elseif mname == "windows" then
		if button.name == "None" or button.purchased or CanPurchase(price, canpurchase) then
			myveh.windowtint = button.tint
			SetVehicleWindowTint(veh, button.tint)
		end
	elseif mname == "sport" or mname == "custom tires" or mname == "muscle" or mname == "lowrider" or mname == "back wheel" or mname == "front wheel" or mname == "highend" or mname == "suv" or mname == "offroad" or mname == "tuner" then
		if button.purchased or CanPurchase(price, canpurchase) then
			myveh.wheeltype = button.wtype
			myveh.mods[button.modtype].mod = button.mod
			SetVehicleWheelType(veh,button.wtype)
			SetVehicleMod(veh,button.modtype,button.mod)
		end
	elseif mname == "wheel color" then
		if button.purchased or CanPurchase(price, canpurchase) then
			myveh.extracolor[2] = button.colorindex
			SetVehicleExtraColours(veh, myveh.color[3], button.colorindex)
		end
	elseif mname == "wheel accessories" then
		if button.name == "Stock Tires" then
			SetVehicleModKit(veh,0)
			SetVehicleMod(veh,23,myveh.mods[23].mod,false)
			myveh.mods[23].variation = false
			if IsThisModelABike(GetEntityModel(veh)) then
				SetVehicleModKit(veh,0)
				SetVehicleMod(veh,24,myveh.mods[24].mod,false)
				myveh.mods[24].variation = false
			end
		elseif button.name == "Custom Tires" and  (button.purchased or CanPurchase(price, canpurchase)) then
			SetVehicleModKit(veh,0)
			SetVehicleMod(veh,23,myveh.mods[23].mod,true)
			myveh.mods[23].variation = true
			if IsThisModelABike(GetEntityModel(veh)) then
				SetVehicleModKit(veh,0)
				SetVehicleMod(veh,24,myveh.mods[24].mod,true)
				myveh.mods[24].variation = true
			end
		elseif button.name == "Bulletproof Tires" and  (button.purchased or CanPurchase(price, canpurchase)) then
			if GetVehicleTyresCanBurst(myveh.vehicle) then
				myveh.bulletProofTyres = false
				SetVehicleTyresCanBurst(veh,false)
			else
				myveh.bulletProofTyres = true
				SetVehicleTyresCanBurst(veh,true)
			end
		elseif button.smokecolor ~= nil  and  (button.purchased or CanPurchase(price, canpurchase)) then
			SetVehicleModKit(veh,0)
			myveh.mods[20].mod = true
			ToggleVehicleMod(veh,20,true)
			myveh.smokecolor = button.smokecolor
			SetVehicleTyreSmokeColor(veh,button.smokecolor[1],button.smokecolor[2],button.smokecolor[3])
		end
	elseif mname == "license" then
		if button.purchased or CanPurchase(price, canpurchase) then
			myveh.plateindex = button.plateindex
			SetVehicleNumberPlateTextIndex(veh,button.plateindex)
		end
	elseif mname == "main" then
		if name == "fix vehicle" then
			if CanPurchase(price, canpurchase) then 
				myveh.repair()
				LSCmenu:Changemenu("categories")
			end
		end
	end
	CheckPurchases(m)
end)

--This was perfect until I tried different vehicles
local function PointCamAtBone(bone,ox,oy,oz)
	SetCamActive(cam, true)
	local veh = myveh.vehicle
	local b = GetEntityBoneIndexByName(veh, bone)
	local bx,by,bz = table.unpack(GetWorldPositionOfEntityBone(veh, b))
	local ox2,oy2,oz2 = table.unpack(GetOffsetFromEntityGivenWorldCoords(veh, bx, by, bz))
	local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(veh, ox2 + f(ox), oy2 + f(oy), oz2 +f(oz)))
	SetCamCoord(cam, x, y, z)
	PointCamAtCoord(cam,GetOffsetFromEntityInWorldCoords(veh, 0, oy2, oz2))
	RenderScriptCams( 1, 1, 1000, 0, 0)
end

local function MoveVehCam(pos,x,y,z)
	SetCamActive(cam, true)
	local veh = myveh.vehicle
	local vx,vy,vz = table.unpack(GetEntityCoords(veh))
	local d = GetModelDimensions(GetEntityModel(veh))
	local length,width,height = d.y*-2, d.x*-2, d.z*-2
	local ox,oy,oz
	if pos == 'front' then
		ox,oy,oz= table.unpack(GetOffsetFromEntityInWorldCoords(veh, f(x), (length/2)+ f(y), f(z)))
	elseif pos == "front-top" then
		ox,oy,oz= table.unpack(GetOffsetFromEntityInWorldCoords(veh, f(x), (length/2) + f(y),(height) + f(z)))
	elseif pos == "back" then
		ox,oy,oz= table.unpack(GetOffsetFromEntityInWorldCoords(veh, f(x), -(length/2) + f(y),f(z)))
	elseif pos == "back-top" then
		ox,oy,oz= table.unpack(GetOffsetFromEntityInWorldCoords(veh, f(x), -(length/2) + f(y),(height/2) + f(z)))
	elseif pos == "left" then
		ox,oy,oz= table.unpack(GetOffsetFromEntityInWorldCoords(veh, -(width/2) + f(x), f(y), f(z)))
	elseif pos == "right" then
		ox,oy,oz= table.unpack(GetOffsetFromEntityInWorldCoords(veh, (width/2) + f(x), f(y), f(z)))
	elseif pos == "middle" then
		ox,oy,oz= table.unpack(GetOffsetFromEntityInWorldCoords(veh, f(x), f(y), (height/2) + f(z)))
	end
	SetCamCoord(cam, ox, oy, oz)
	PointCamAtCoord(cam,GetOffsetFromEntityInWorldCoords(veh, 0, 0, f(0)))
	RenderScriptCams( 1, 1, 1000, 0, 0)
end

function LSCmenu:OnmenuChange(last,current)
	UnfakeVeh()
	if last == "main" then
		last = self
	end
	if last.name == "categories" and current.name == "main" then
		LSCmenu:Close()
	end	
	c = current.name:lower()
	--Camera,door stuff 
	if c == "front bumpers" then
		--MoveVehCam('front',-0.6,1.5,0.4)
	elseif  c == "rear bumpers" then
		--MoveVehCam('back',-0.5,-1.5,0.2)
	elseif c == "Engine Tunes" then
		--PointCamAtBone('engine',0,-1.5,1.5)
	elseif c == "exhausts" then
		--PointCamAtBone("exhaust",0,-1.5,0)
	elseif c == "hood" then
		--MoveVehCam('front-top',-0.5,1.3,1.0)
	elseif c == "headlights" then
		--MoveVehCam('front',-0.6,1.3,0.6)
	elseif c == "license" or c == "plate holder" then
		--MoveVehCam('back',0,-1,0.2)
	elseif c == "vanity plates" then
		--MoveVehCam('front',-0.3,0.8,0.3)
	elseif c == "roof" then
		--MoveVehCam('middle',-1.2,2,1.5)
	elseif c == "fenders" then
		--MoveVehCam('left',-1.8,-1.3,0.7)
	elseif c == "grille" then
		--MoveVehCam('front',-0.3,0.8,0.6)
	elseif c == "skirts" then
		--MoveVehCam('left',-1.8,-1.3,0.7)
	elseif c == "spoiler" then
		--MoveVehCam('back',0.5,-1.6,1.3)
	elseif c == "back wheel" then
		--PointCamAtBone("wheel_lr",-1.4,0,0.3)
	elseif c == "front wheel" or c == "wheel accessories" or  c == "wheel color" or c == "sport" or c == "custom tires" or c == "muscle" or c == "lowrider"  or c == "highend" or c == "suv" or c == "offroad" or c == "tuner" then
		--PointCamAtBone("wheel_lf",-1.4,0,0.3)
	--[[elseif c == "windows" then
		if not IsThisModelABike(GetEntityModel(myveh.vehicle)) then
		PointCamAtBone("window_lf",-2.0,0,0.3)
		end]]
	elseif c == "neon color" then
		--PointCamAtBone("neon_l",-2.0,2.0,0.4)
	elseif c == "shifter leavers" or c == "trim design" or c == "ornaments" or c == "dashboard" or c == "dials" or c == "seats" or c =="steering wheels" then
		--Set view mode to first person
		--SetFollowVehicleCamViewMode(4)
	elseif c == "doors" and last.name:lower() == "interior" then
		--Open both front doors
		SetVehicleDoorOpen(myveh.vehicle, 0, 0, 0)
		SetVehicleDoorOpen(myveh.vehicle, 1, 0, 0)
	elseif c == "trunk" then
		--- doorIndex:
		-- 0 = Front Left Door
		-- 1 = Front Right Door
		-- 2 = Back Left Door
		-- 3 = Back Right Door
		-- 4 = Hood
		-- 5 = Trunk
		-- 6 = Back
		-- 7 = Back2
		SetVehicleDoorOpen(myveh.vehicle, 5, 0, 0)
	elseif c == "speakers" or  c == "engine block" or c == "air filter" or c == "strut brace" or c == "cam cover" then
		--Open hood and trunk
		SetVehicleDoorOpen(myveh.vehicle, 5, 0, 0)
		SetVehicleDoorOpen(myveh.vehicle, 4, 0, 0)
	elseif IsCamActive(cam) then

	else
		--Close all doors
		SetVehicleDoorShut(myveh.vehicle, 0, 0)
		SetVehicleDoorShut(myveh.vehicle, 1, 0)
		SetVehicleDoorShut(myveh.vehicle, 4, 0)
		SetVehicleDoorShut(myveh.vehicle, 5, 0)
		--SetFollowVehicleCamViewMode(0)
	end
end


--Bunch of checks
function CheckPurchases(m)
	name = m.name:lower()
	if name == "chrome" or name ==  "classic" or name ==  "matte" or name ==  "metals" then
		if m.parent == "Primary color" then
			for i,b in pairs(m.buttons) do
				if b.purchased and b.colorindex ~= myveh.color[1] then
					if b.purchased ~= nil then b.purchased = false end
					b.sprite = nil
				elseif b.purchased == false and b.colorindex == myveh.color[1] then
					if b.purchased ~= nil then b.purchased = true end
					b.sprite = "garage"
				end
			end
		elseif m.parent == "Secondary color" then
			for i,b in pairs(m.buttons) do
				if b.purchased and (b.colorindex ~= myveh.color[2]) then
					if b.purchased ~= nil then b.purchased = false end
					b.sprite = nil
				elseif b.purchased == false and b.colorindex == myveh.color[2] then
					if b.purchased ~= nil then b.purchased = true end
					b.sprite = "garage"
				end
			end
		else
			for i,b in pairs(m.buttons) do
				if b.purchased and (b.colorindex ~= myveh.color[3]) then
					if b.purchased ~= nil then b.purchased = false end
					b.sprite = nil
				elseif b.purchased == false and b.colorindex == myveh.color[3] then
					if b.purchased ~= nil then b.purchased = true end
					b.sprite = "garage"
				end
			end
		end
	elseif name == "metallic" then
		if m.parent == "Primary color" then
			for i,b in pairs(m.buttons) do
				if b.purchased and b.colorindex ~= myveh.color[1] then
					if b.purchased ~= nil then b.purchased = false end
					b.sprite = nil
				elseif b.purchased == false and b.colorindex == myveh.color[1] then
					if b.purchased ~= nil then b.purchased = true end
					b.sprite = "garage"
				end
			end
		elseif m.parent == "Secondary color" then
			for i,b in pairs(m.buttons) do
				if b.purchased and (b.colorindex ~= myveh.color[2]) then
					if b.purchased ~= nil then b.purchased = false end
					b.sprite = nil
				elseif b.purchased == false and b.colorindex == myveh.color[2] then
					if b.purchased ~= nil then b.purchased = true end
					b.sprite = "garage"
				end
			end
		else
			for i,b in pairs(m.buttons) do
				if b.purchased and (b.colorindex ~= myveh.color[3]) then
					if b.purchased ~= nil then b.purchased = false end
					b.sprite = nil
				elseif b.purchased == false and b.colorindex == myveh.color[3] then
					if b.purchased ~= nil then b.purchased = true end
					b.sprite = "garage"
				end
			end
		end
	elseif name == "armor" or name == "suspension" or name == "turbo" or name == "transmission" or name == "brakes" or name == "engine tunes" or name == "roof" or name == "fenders" or name == "hood" or name == "grille" or name == "roll cage" or name == "exhausts" or name == "skirts" or name == "rear bumpers" or name == "front bumpers" or name == "spoiler" then
		for i,b in pairs(m.buttons) do
			if b.mod == -1  then
				if myveh.mods[b.modtype].mod == -1 then
					if b.purchased ~= nil then b.purchased = true end
					b.sprite = "garage"
				else
					if b.purchased ~= nil then b.purchased = false end
					b.sprite = nil
				end
			elseif b.mod == 0 or b.mod == false then
				if myveh.mods[b.modtype].mod == false or myveh.mods[b.modtype].mod == 0 then
					if b.purchased ~= nil then b.purchased = true end
					b.sprite = "garage"
				else
					if b.purchased ~= nil then b.purchased = false end
					b.sprite = nil
				end
			else
				if myveh.mods[b.modtype].mod == b.mod then
					if b.purchased ~= nil then b.purchased = true end
					b.sprite = "garage"
				else
					if b.purchased ~= nil then b.purchased = false end
					b.sprite = nil
				end
			end
		end
	elseif name == "neon layout" then
		for i,b in pairs(m.buttons) do
			if b.name == "None" then
				if IsVehicleNeonLightEnabled(myveh.vehicle, 0) == false and IsVehicleNeonLightEnabled(myveh.vehicle, 1) == false  and IsVehicleNeonLightEnabled(myveh.vehicle, 2) == false and IsVehicleNeonLightEnabled(myveh.vehicle, 3) == false then
					b.sprite = "garage"
				else
					b.sprite =  nil
				end
			elseif b.name == "Front,Back and Sides" then
				if IsVehicleNeonLightEnabled(myveh.vehicle, 0)  and IsVehicleNeonLightEnabled(myveh.vehicle, 1)  and IsVehicleNeonLightEnabled(myveh.vehicle, 2)  and IsVehicleNeonLightEnabled(myveh.vehicle, 3)  then
					b.sprite = "garage"
				else
					b.sprite =  nil
				end
			end		
		end
	elseif name == "neon color" then
		for i,b in pairs(m.buttons) do
			if b.neon[1] == myveh.neoncolor[1] and b.neon[2] == myveh.neoncolor[2] and b.neon[3] == myveh.neoncolor[3] then
				b.sprite = "garage"
			else
				b.sprite = nil
			end
		end
	elseif name == "windows" then
		for i,b in pairs(m.buttons) do
			if myveh.windowtint == b.tint then
				b.sprite = "garage"
			else
				b.sprite = nil
			end
		end
	elseif name == "sport" or name == "custom tires" or name == "muscle" or name == "lowrider" or name == "back wheel" or name == "front wheel" or name == "highend" or name == "suv" or name == "offroad" or name == "tuner" then
		for i,b in pairs(m.buttons) do
			if myveh.mods[b.modtype].mod == b.mod and myveh.wheeltype == b.wtype then
				b.sprite = "garage"
			else
				b.sprite = nil
			end
		end
	elseif name == "wheel color" then
		for i,b in pairs(m.buttons) do
			if b.colorindex == myveh.extracolor[2] then
				b.sprite = "garage"
			else
				b.sprite = nil
			end
		end
	elseif name == "wheel accessories" then
		for i,b in pairs(m.buttons) do
			if b.name == "Stock Tires" then
				if GetVehicleModVariation(myveh.vehicle,23) == false then
					b.sprite = "garage"
				else
					b.sprite = nil
				end
			elseif b.name == "Custom Tires" then
				if GetVehicleModVariation(myveh.vehicle,23) then
					b.sprite = "garage"
				else
					b.sprite = nil
				end
			elseif b.name == "Bulletproof Tires" then
				if GetVehicleTyresCanBurst(myveh.vehicle) == false then
					b.sprite = "garage"
				else
					b.sprite = nil
				end
			elseif b.smokecolor ~= nil then
				local col = table.pack(GetVehicleTyreSmokeColor(myveh.vehicle))
				if col[1] == b.smokecolor[1] and col[2] == b.smokecolor[2] and col[3] == b.smokecolor[3] then
					b.sprite = "garage"
				else
					b.sprite = nil
				end
			end
		end
	elseif name == "license" then
		for i,b in pairs(m.buttons) do
			if myveh.plateindex == b.plateindex then
				if b.purchased ~= nil then b.purchased = true end
				b.sprite = "garage"
			else
				b.purchased = false
				b.sprite = nil
			end
		end
	elseif name == "tank" or name == "ornaments" or name == "arch cover" or name == "aerials" or name == "roof scoops" or name == "doors" or name == "roll cage" or name == "engine block" or name == "cam cover" or name == "strut brace" or name == "trim design" or name == "ornametns" or name == "dashboard" or name == "dials" or name == "seats" or name == "steering wheels" or name == "plate holder" or name == "vanity plates" or name == "shifter leavers" or name == "plaques" or name == "speakers" or name == "trunk" or name == "headlights" or name == "turbo" or  name == "hydraulics" or name == "liveries" or name == "horn" then
		for i,b in pairs(m.buttons) do
			if myveh.mods[b.modtype].mod == b.mod then
				b.sprite = "garage"
			else
				b.sprite = nil
			end
		end
	end
end

--Show notifications and return if item can be purchased
function CanPurchase(price, canpurchase)
	if canpurchase then
		if LSCmenu.currentmenu == "main" then
			LSCmenu:showNotification("Your vehicle has been repaired")
		else
			LSCmenu:showNotification("Purchased")
		end
		TriggerServerEvent("InteractSound_SV:PlayOnSource", "airwrench", 0.1)
		editCount = editCount + 1
		return true
	else
		LSCmenu:showNotification("~r~You cannot afford this purchase")
		return false
	end
end

--Unfake vehicle, or in other words reset vehicle stuff to real so all the preview stuff would be gone
function UnfakeVeh()
	local veh = myveh.vehicle
	SetVehicleModKit(veh,0)
	SetVehicleWheelType(veh, myveh.wheeltype)
	for i,m in pairs(myveh.mods) do
		if i == 22 or i == 18 then
			ToggleVehicleMod(veh,i,m.mod)
		elseif i == 23 or i == 24 then
			SetVehicleMod(veh,i,m.mod,m.variation)
		else
			SetVehicleMod(veh,i,m.mod)
		end
	end
	SetVehicleColours(veh,myveh.color[1], myveh.color[2])
	SetVehicleExtraColours(veh,myveh.color[3], myveh.extracolor[2])
	SetVehicleNeonLightsColour(veh,myveh.neoncolor[1],myveh.neoncolor[2],myveh.neoncolor[3])
	SetVehicleNumberPlateTextIndex(veh, myveh.plateindex)
	SetVehicleWindowTint(veh, myveh.windowtint)
end



--This is something new o_O, just some things to draw instructional buttons 
local Ibuttons = nil
--Set up scaleform
function SetIbuttons(buttons, layout)
	Citizen.CreateThread(function()
		if not HasScaleformMovieLoaded(Ibuttons) then
			Ibuttons = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
			while not HasScaleformMovieLoaded(Ibuttons) do
				Citizen.Wait(0)
			end
		else
			Ibuttons = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
			while not HasScaleformMovieLoaded(Ibuttons) do
				Citizen.Wait(0)
			end
		end
		local sf = Ibuttons
		local w,h = GetScreenResolution()
		PushScaleformMovieFunction(sf,"CLEAR_ALL")
		PopScaleformMovieFunction()
		PushScaleformMovieFunction(sf,"SET_DISPLAY_CONFIG")
		PushScaleformMovieFunctionParameterInt(w)
		PushScaleformMovieFunctionParameterInt(h)
		PushScaleformMovieFunctionParameterFloat(0.03)
		PushScaleformMovieFunctionParameterFloat(0.98)
		PushScaleformMovieFunctionParameterFloat(0.01)
		PushScaleformMovieFunctionParameterFloat(0.95)
		PushScaleformMovieFunctionParameterBool(true)
		PushScaleformMovieFunctionParameterBool(false)
		PushScaleformMovieFunctionParameterBool(false)
		PushScaleformMovieFunctionParameterInt(w)
		PushScaleformMovieFunctionParameterInt(h)
		PopScaleformMovieFunction()
		PushScaleformMovieFunction(sf,"SET_MAX_WIDTH")
		PushScaleformMovieFunctionParameterInt(1)
		PopScaleformMovieFunction()
		
		for i,btn in pairs(buttons) do
			PushScaleformMovieFunction(sf,"SET_DATA_SLOT")
			PushScaleformMovieFunctionParameterInt(i-1)
			PushScaleformMovieFunctionParameterString(btn[1])
			PushScaleformMovieFunctionParameterString(btn[2])
			PopScaleformMovieFunction()
			
		end
		if layout ~= 1 then
			PushScaleformMovieFunction(sf,"SET_PADDING")
			PushScaleformMovieFunctionParameterInt(10)
			PopScaleformMovieFunction()
		end
		PushScaleformMovieFunction(sf,"DRAW_INSTRUCTIONAL_BUTTONS")
		PushScaleformMovieFunctionParameterInt(layout)
		PopScaleformMovieFunction()
	end)
end

function RoofNotAllowed(vehicle)
	local retval = false
	for k, v in pairs(LSC_Config.NoRoofAllowed) do
		if GetEntityModel(vehicle) == GetHashKey(v) then
			retval = true
		end
	end
	return retval
end

--Draw the scaleform
function DrawIbuttons()
	if HasScaleformMovieLoaded(Ibuttons) then
		DrawScaleformMovie(Ibuttons, 0.5, 0.5, 1.0, 1.0, 255, 255, 255, 255)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3)
		if inside then
			SetLocalPlayerVisibleLocally(1)
		end
		if LSCmenu:isVisible() then
			DrawIbuttons()--Draw the scaleform if menu is visible
		end
	end
end)


function GetClosestPlayer()
    local closestPlayers = scCore.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))
	for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end