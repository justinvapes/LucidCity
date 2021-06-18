local islandVec = vector3(4840.571, -5174.425, 2.0)
local oldVehicle = nil
local onIsland = false

function isOnIsland()
	return onIsland
end

Citizen.CreateThread(function()
    while true do
		local ped = PlayerPedId()
		local pCoords = GetEntityCoords(ped)
		local vehicle = GetVehiclePedIsIn(ped)	
		local class = nil
		if vehicle ~= 0 then
			oldVehicle = vehicle 
			class = GetVehicleClass(vehicle)
		end	
		local distance1 = #(pCoords - islandVec)
		if distance1 < 2000.0 then
			if class ~= nil and (class == 15 or class == 16) and not onIsland then
				onIsland = true
				Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", true)  -- load the map and removes the city
				Citizen.InvokeNative("0x5E1460624D194A38", true) -- load the minimap/pause map and removes the city minimap/pause map
				Citizen.InvokeNative(0xF74B1FFA4A15FBEA, true)
				Citizen.InvokeNative(0x53797676AD34A9AA, false)    
				SetScenarioGroupEnabled('Heist_Island_Peds', true)
			
				-- audio stuff
				SetAudioFlag('PlayerOnDLCHeist4Island', true)
				SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', true, true)
				SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', false, true)
			
				RequestIpl("int_cayo_bung")
				RequestIpl("int_cayo_bung_01_milo_")
				RequestIpl("int_cayo_bung_02_milo_")
				RequestIpl("int_cayo_bung_03_milo_")
				RequestIpl("int_cayo_bung_04_milo_")
				RequestIpl("int_cayo_bung_05_milo_")
				RequestIpl("int_cayo_bung_06_milo_")
				RequestIpl("int_cayo_bung_07_milo_")
				RequestIpl("uj_cayo_jungle_01")
				RequestIpl("uj_cayo_jungle_02")
				RequestIpl("uj_cayo_water_01")
				RequestIpl("uj_cayo_light_01")
				RequestIpl("uj_cayo_shops")
			
				RequestIpl("int_cayo_base2_milo_")
				RequestIpl("int_cayo_base3_milo_")
				RequestIpl("int_cayo_base_milo_")
			
				RequestIpl("int_cayo_barracks_01_milo_")
				RequestIpl("int_cayo_barracks_02_milo_")
				RequestIpl("int_cayo_stock_01_milo_")
				RequestIpl("int_cayo_stock_02_milo_")
				RequestIpl("int_cayo_stock_03_milo_")
				RequestIpl("int_cayo_stock_04_milo_")
				RequestIpl("int_cayo_stock_05_milo_")
				RequestIpl("uj_cayo_barracs")
			
				RequestIpl("uj_cayo_med2_milo_")
				RequestIpl("uj_cayo_med_milo_")
				RequestIpl("uj_cayo_med3_milo_")
				RequestIpl("uj_cayo_med_build")
				RemoveIpl("hei_carrier")
				RemoveIpl("hei_carrier_int1")
				RemoveIpl("hei_carrier_int1_lod")
				RemoveIpl("hei_carrier_int2")
				RemoveIpl("hei_carrier_int2_lod")
				RemoveIpl("hei_carrier_int3")
				RemoveIpl("hei_carrier_int3_lod")
				RemoveIpl("hei_carrier_int4")
				RemoveIpl("hei_carrier_int4_lod")
				RemoveIpl("hei_carrier_int5")
				RemoveIpl("hei_carrier_int5_lod")
				RemoveIpl("hei_carrier_int6")
				RemoveIpl("hei_carrier_int6_lod")
				RemoveIpl("hei_carrier_lod")
				RemoveIpl("hei_carrier_slod")
			
				RequestIpl("uj_ipl_cayom_pool_door")
			
				local int_barracks = GetInteriorAtCoordsWithType(4969.689, -5286.237, 6.293,"uj_cayo_barracks")
				EnableInteriorProp(int_barracks, "box")
				RefreshInterior(int_barracks)
				
				local int_stock1 = GetInteriorAtCoordsWithType(5130.676, -4611.803, -4.666,"int_stock")
				EnableInteriorProp(int_stock1, "light_stock")
				EnableInteriorProp(int_stock1, "meth_app")
				EnableInteriorProp(int_stock1, "meth_staff_01")
				EnableInteriorProp(int_stock1, "meth_staff_02")
				EnableInteriorProp(int_stock1, "meth_update_lab_01")
				EnableInteriorProp(int_stock1, "meth_update_lab_02")
				EnableInteriorProp(int_stock1, "meth_update_lab_01_2")
				EnableInteriorProp(int_stock1, "meth_update_lab_02_2")
				EnableInteriorProp(int_stock1, "meth_stock")
				RefreshInterior(int_stock1)
				
				local int_stock2 = GetInteriorAtCoordsWithType(5134.326, -5190.307, -4.675,"int_stock")
				EnableInteriorProp(int_stock2, "weed_app")
				EnableInteriorProp(int_stock2, "weed_staff_01")
				EnableInteriorProp(int_stock2, "weed_staff_02")
				EnableInteriorProp(int_stock2, "weed_update_lamp")
				EnableInteriorProp(int_stock2, "weed_fan_update")
				EnableInteriorProp(int_stock2, "weed_stock")
				EnableInteriorProp(int_stock2, "weed_plant_v7")
				RefreshInterior(int_stock2)
				
				local int_stock3 = GetInteriorAtCoordsWithType(4983.767, -5133.899, -4.474,"int_stock")
				EnableInteriorProp(int_stock3, "light_stock")
				EnableInteriorProp(int_stock3, "coke_app")
				EnableInteriorProp(int_stock3, "coke_staff_01")
				EnableInteriorProp(int_stock3, "coke_staff_02")
				EnableInteriorProp(int_stock3, "coke_stock")
				RefreshInterior(int_stock3)
				
				local int_stock4 = GetInteriorAtCoordsWithType(4906.630, -5279.436, -1.376,"int_stock")
				EnableInteriorProp(int_stock4, "light_stock")
				EnableInteriorProp(int_stock4, "money_app")
				EnableInteriorProp(int_stock4, "money_staff_02")
				EnableInteriorProp(int_stock4, "money_stock")
				RefreshInterior(int_stock4)
				
				local int_stock5 = GetInteriorAtCoordsWithType(4986.189, -5295.240, -0.818,"int_stock")
				EnableInteriorProp(int_stock5, "light_stock")
				EnableInteriorProp(int_stock5, "weapon_app")
				EnableInteriorProp(int_stock5, "weapon_staff_01")
				EnableInteriorProp(int_stock5, "weapon_stock")
				RefreshInterior(int_stock5)
			end
		elseif distance1 >= 2000 and onIsland then
			onIsland = false
			Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", false)
			Citizen.InvokeNative("0x5E1460624D194A38", false)
			Citizen.InvokeNative(0xF74B1FFA4A15FBEA, false) -- misc natives
			Citizen.InvokeNative(0x53797676AD34A9AA, true) -- misc natives  
			SetScenarioGroupEnabled('Heist_Island_Peds', false) -- misc natives
	
			-- audio stuff
			SetAudioFlag('PlayerOnDLCHeist4Island', false)
			SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', false, false)
			SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', true, false)
	
			RemoveIpl("int_cayo_bung")
			RemoveIpl("int_cayo_bung_01_milo_")
			RemoveIpl("int_cayo_bung_02_milo_")
			RemoveIpl("int_cayo_bung_03_milo_")
			RemoveIpl("int_cayo_bung_04_milo_")
			RemoveIpl("int_cayo_bung_05_milo_")
			RemoveIpl("int_cayo_bung_06_milo_")
			RemoveIpl("int_cayo_bung_07_milo_")
			RemoveIpl("uj_cayo_jungle_01")
			RemoveIpl("uj_cayo_jungle_02")
			RemoveIpl("uj_cayo_water_01")
			RemoveIpl("uj_cayo_light_01")
			RemoveIpl("uj_cayo_shops")
	
			RemoveIpl("int_cayo_base2_milo_")
			RemoveIpl("int_cayo_base3_milo_")
			RemoveIpl("int_cayo_base_milo_")
	
			RemoveIpl("int_cayo_barracks_01_milo_")
			RemoveIpl("int_cayo_barracks_02_milo_")
			RemoveIpl("int_cayo_stock_01_milo_")
			RemoveIpl("int_cayo_stock_02_milo_")
			RemoveIpl("int_cayo_stock_03_milo_")
			RemoveIpl("int_cayo_stock_04_milo_")
			RemoveIpl("int_cayo_stock_05_milo_")
			RemoveIpl("uj_cayo_barracs")
	
			RemoveIpl("uj_cayo_med2_milo_")
			RemoveIpl("uj_cayo_med_milo_")
			RemoveIpl("uj_cayo_med3_milo_")
			RemoveIpl("uj_cayo_med_build")
		end
		Citizen.Wait(5000)
		justLoggedIn = false
    end
end)

local loadin = true
RegisterNetEvent("spawnIsland")
AddEventHandler("spawnIsland", function(pos)
	Citizen.CreateThread(function()
		while loadin do
			if not IsScreenFadedOut() then
				DoScreenFadeOut(100)
			end
			Citizen.Wait(1)
		end
	end)
	local ped = PlayerPedId()
	onIsland = true
	SetEntityCoords(ped, 3734.125, -4496.744, 97.31)
	FreezeEntityPosition(ped, true)
	Citizen.Wait(1000)
	Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", true)  -- load the map and removes the city
	Citizen.InvokeNative("0x5E1460624D194A38", true) -- load the minimap/pause map and removes the city minimap/pause map
	Citizen.Wait(5000)
	Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", false)  -- load the map and removes the city
	Citizen.InvokeNative("0x5E1460624D194A38", false) -- load the minimap/pause map and removes the city minimap/pause map
	Citizen.Wait(2000)
	Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", true)  -- load the map and removes the city
	Citizen.InvokeNative("0x5E1460624D194A38", true) -- load the minimap/pause map and removes the city minimap/pause map
	
	Citizen.InvokeNative(0xF74B1FFA4A15FBEA, true)
	Citizen.InvokeNative(0x53797676AD34A9AA, false)    
	SetScenarioGroupEnabled('Heist_Island_Peds', true)

	-- audio stuff
	SetAudioFlag('PlayerOnDLCHeist4Island', true)
	SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', true, true)
	SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', false, true)

	RequestIpl("int_cayo_bung")
	RequestIpl("int_cayo_bung_01_milo_")
	RequestIpl("int_cayo_bung_02_milo_")
	RequestIpl("int_cayo_bung_03_milo_")
	RequestIpl("int_cayo_bung_04_milo_")
	RequestIpl("int_cayo_bung_05_milo_")
	RequestIpl("int_cayo_bung_06_milo_")
	RequestIpl("int_cayo_bung_07_milo_")
	RequestIpl("uj_cayo_jungle_01")
	RequestIpl("uj_cayo_jungle_02")
	RequestIpl("uj_cayo_water_01")
	RequestIpl("uj_cayo_light_01")
	RequestIpl("uj_cayo_shops")

	RequestIpl("int_cayo_base2_milo_")
	RequestIpl("int_cayo_base3_milo_")
	RequestIpl("int_cayo_base_milo_")

	RequestIpl("int_cayo_barracks_01_milo_")
	RequestIpl("int_cayo_barracks_02_milo_")
	RequestIpl("int_cayo_stock_01_milo_")
	RequestIpl("int_cayo_stock_02_milo_")
	RequestIpl("int_cayo_stock_03_milo_")
	RequestIpl("int_cayo_stock_04_milo_")
	RequestIpl("int_cayo_stock_05_milo_")
	RequestIpl("uj_cayo_barracs")

	RequestIpl("uj_cayo_med2_milo_")
	RequestIpl("uj_cayo_med_milo_")
	RequestIpl("uj_cayo_med3_milo_")
	RequestIpl("uj_cayo_med_build")
	RemoveIpl("hei_carrier")
	RemoveIpl("hei_carrier_int1")
	RemoveIpl("hei_carrier_int1_lod")
	RemoveIpl("hei_carrier_int2")
	RemoveIpl("hei_carrier_int2_lod")
	RemoveIpl("hei_carrier_int3")
	RemoveIpl("hei_carrier_int3_lod")
	RemoveIpl("hei_carrier_int4")
	RemoveIpl("hei_carrier_int4_lod")
	RemoveIpl("hei_carrier_int5")
	RemoveIpl("hei_carrier_int5_lod")
	RemoveIpl("hei_carrier_int6")
	RemoveIpl("hei_carrier_int6_lod")
	RemoveIpl("hei_carrier_lod")
	RemoveIpl("hei_carrier_slod")

	RequestIpl("uj_ipl_cayom_pool_door")

	local int_barracks = GetInteriorAtCoordsWithType(4969.689, -5286.237, 6.293,"uj_cayo_barracks")
	EnableInteriorProp(int_barracks, "box")
	RefreshInterior(int_barracks)
	
	local int_stock1 = GetInteriorAtCoordsWithType(5130.676, -4611.803, -4.666,"int_stock")
	EnableInteriorProp(int_stock1, "light_stock")
	EnableInteriorProp(int_stock1, "meth_app")
	EnableInteriorProp(int_stock1, "meth_staff_01")
	EnableInteriorProp(int_stock1, "meth_staff_02")
	EnableInteriorProp(int_stock1, "meth_update_lab_01")
	EnableInteriorProp(int_stock1, "meth_update_lab_02")
	EnableInteriorProp(int_stock1, "meth_update_lab_01_2")
	EnableInteriorProp(int_stock1, "meth_update_lab_02_2")
	EnableInteriorProp(int_stock1, "meth_stock")
	RefreshInterior(int_stock1)
	
	local int_stock2 = GetInteriorAtCoordsWithType(5134.326, -5190.307, -4.675,"int_stock")
	EnableInteriorProp(int_stock2, "weed_app")
	EnableInteriorProp(int_stock2, "weed_staff_01")
	EnableInteriorProp(int_stock2, "weed_staff_02")
	EnableInteriorProp(int_stock2, "weed_update_lamp")
	EnableInteriorProp(int_stock2, "weed_fan_update")
	EnableInteriorProp(int_stock2, "weed_stock")
	EnableInteriorProp(int_stock2, "weed_plant_v7")
	RefreshInterior(int_stock2)
	
	local int_stock3 = GetInteriorAtCoordsWithType(4983.767, -5133.899, -4.474,"int_stock")
	EnableInteriorProp(int_stock3, "light_stock")
	EnableInteriorProp(int_stock3, "coke_app")
	EnableInteriorProp(int_stock3, "coke_staff_01")
	EnableInteriorProp(int_stock3, "coke_staff_02")
	EnableInteriorProp(int_stock3, "coke_stock")
	RefreshInterior(int_stock3)
	
	local int_stock4 = GetInteriorAtCoordsWithType(4906.630, -5279.436, -1.376,"int_stock")
	EnableInteriorProp(int_stock4, "light_stock")
	EnableInteriorProp(int_stock4, "money_app")
	EnableInteriorProp(int_stock4, "money_staff_02")
	EnableInteriorProp(int_stock4, "money_stock")
	RefreshInterior(int_stock4)
	
	local int_stock5 = GetInteriorAtCoordsWithType(4986.189, -5295.240, -0.818,"int_stock")
	EnableInteriorProp(int_stock5, "light_stock")
	EnableInteriorProp(int_stock5, "weapon_app")
	EnableInteriorProp(int_stock5, "weapon_staff_01")
	EnableInteriorProp(int_stock5, "weapon_stock")
	RefreshInterior(int_stock5)
	
	FreezeEntityPosition(PlayerPedId(), false)
	SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z+1.5)
	SetEntityHeading(PlayerPedId(), pos.a)
	FreezeEntityPosition(PlayerPedId(), true)
	Citizen.Wait(500)
	FreezeEntityPosition(PlayerPedId(), false)
	loadin = false
	DoScreenFadeIn(500)
end)