QB = {}

QB.Doors = {
	--
	-- Mission Row First Floor
	--
	-- Entrance Doors
	{
		textCoords = vector3(434.81, -981.93, 30.89),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = -1547307588,
				objYaw = -90.0,
				objCoords = vector3(434.7, -980.6, 30.8)
			},

			{
				objName = -1547307588,
				objYaw = 90.0,
				objCoords = vector3(434.7, -983.2, 30.8)
			}
		}
	},
	--Front pd Left side door
	{
		objName = -1406685646,
		objYaw = 0.0,
		objCoords  = vector3(441.4162, -977.6589, 30.79034),
		textCoords = vector3(441.4162, -977.6589, 30.79034),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
		--Front pd Right side door
	{
		objName = -96679321,
		objYaw = -180.0,
		objCoords  = vector3(441.4162, -986.2417, 30.79034),
		textCoords = vector3(441.4162, -986.2417, 30.79034),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	-- Top floor meeting room

	{
		objName = -96679321,
		objYaw = 0.0,
		objCoords  = vector3(459.15, -990.70, 35.07),
		textCoords = vector3(459.15, -990.70, 35.07),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = -1406685646,
		objYaw = -180.0,
		objCoords  = vector3(459.1599, -981.0156, 35.07),
		textCoords = vector3(459.1599, -981.0156, 35.07),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	-- Double outside doors
		{
			textCoords = vector3(441.8671, -998.8323, 30.47),
			authorizedJobs = { 'police', 'fib' },
			locking = false,
			locked = true,
			pickable = false,
			distance = 2.5,
			doors = {
				{
					objName = -1547307588,
					objYaw = 0.0,
					objCoords = vector3(441.8671, -998.8323, 30.47)
				},
	
				{
					objName = -1547307588,
					objYaw = 180.0,
					objCoords = vector3(442.651, -998.7361, 30.47)
				}
			}
		},

		-- Double door to meeting room first floor
		{
			textCoords = vector3(438.244, -994.98, 30.5337),
			authorizedJobs = { 'police', 'fib' },
			locking = false,
			locked = true,
			pickable = false,
			distance = 2.5,
			doors = {
				{
					objName = -288803980,
					objYaw = -90.0,
					objCoords = vector3(438.291, -994.2292, 30.53)
				},
	
				{
					objName = -288803980,
					objYaw = 90.0,
					objCoords = vector3(438.0794, -995.72, 30.53)
				}
			}
		},

			-- Double outside doors (left)
			{
				textCoords = vector3(457.11, -972.23, 30.45),
				authorizedJobs = { 'police', 'fib' },
				locking = false,
				locked = true,
				pickable = false,
				distance = 2.5,
				doors = {
					{
						objName = -1547307588,
						objYaw = 0.0,
						objCoords = vector3(456.45, -972.10, 30.71)
					},
		
					{
						objName = -1547307588,
						objYaw = 180.0,
						objCoords = vector3(457.60, -972.09, 30.75)
					}
				}
			},

	-- Cells
	{
		objName = -53345114,
		objYaw = 180.0,
		objCoords  = vector3(482.0214, -1004.099, 26.27317),
		textCoords = vector3(482.0214, -1004.099, 26.27317),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = -53345114,
		objYaw = 0.0,
		objCoords  = vector3(485.7786, -1012.171, 26.29817),
		textCoords = vector3(485.7786, -1012.171, 26.29817),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},

	{
		objName = -53345114,
		objYaw = 0.0,
		objCoords  = vector3(482.845, -1012.167, 26.29817),
		textCoords = vector3(482.845, -1012.167, 26.29817),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},

	{
		objName = -53345114,
		objYaw = 0.0,
		objCoords  = vector3(479.907, -1012.158, 26.29817),
		textCoords = vector3(479.907, -1012.158, 26.29817),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},

	{
		objName = -53345114,
		objYaw = 0.0,
		objCoords  = vector3(476.9177, -1012.177, 26.29817),
		textCoords = vector3(476.9177, -1012.177, 26.29817),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},

	-- Roof door top
	{
		objName = -692649124,
		objYaw = 90.0,
		objCoords  = vector3(464.38, -983.73, 43.77),  
		textCoords = vector3(464.38, -983.73, 43.77),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 7,
		size = 2
	},

	--- Garage doors
	{
		objName =2130672747,
		objCoords  = vector3(431.504, -1001.301,25.77955),  
		textCoords = vector3(431.48, -1002.741, 26.00),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 7,
		size = 2
	},

	{
		objName = 2130672747,
		objCoords  = vector3(452.5063,  -1002.614, 25.9763), 
		textCoords = vector3(452.5063,  -1002.614, 25.9763),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 7,
		size = 2
	},

	{
		textCoords = vector3(468.722, -1000.654, 26.42),   
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		doors = {
			{
				objName = -288803980,
				objYaw = 180.0,
				objCoords = vector3(469.3384, -1000.617, 26.373)  
			},

			{
				objName = -288803980,
				objYaw = 0.0,
				objCoords = vector3(467.94, -1000.58, 26.37)  
			}
		}
	},

	{
		textCoords = vector3(471.2744, -1008.995, 26.37),   
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		doors = {
			{
				objName = 149284793,
				objYaw = -90.0,
				objCoords = vector3(471.43, -1008.214, 26.37)  
			},

			{
				objName = 149284793,
				objYaw = 90.0,
				objCoords = vector3(471.39, -1009.77, 26.37)  
			}
		}
	},

	-- Back door to outside
	{
		textCoords = vector3(468.5216, -1014.399, 26.42),   
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		doors = {
			{
				objName = -692649124,
				objYaw = 0.0,
				objCoords = vector3(468.12, -1014.65, 26.38)  
			},

			{
				objName = -692649124,
				objYaw = 180.0,
				objCoords = vector3(469.2274, -1014.273, 26.425)  
			}
		}
	},
	

	-- vehicle garage
	{
		objName = 1830360419,
		objYaw = -90.0,
		objCoords  = vector3(464.0935, -975.6019, 26.27294),
		textCoords = vector3(464.0935, -975.6019, 26.27294),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = 1830360419,
		objYaw = 90.0,
		objCoords  = vector3(464.1355, -996.5471, 26.27294),
		textCoords = vector3(464.1355, -996.5471, 26.27294),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	-- Back Gate
	{
		objName = 'hei_prop_station_gate',
		objYaw = 90.0,
		objCoords  = vector3(488.8, -1017.2, 27.1),
		textCoords = vector3(488.8, -1020.2, 30.0),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 7,
		size = 2
	},



	--
	-- Bolingbroke Penitentiary
	--
	-- Entrance (Two big gates)
	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1844.9, 2604.8, 44.6),
		textCoords = vector3(1844.9, 2608.5, 48.0),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 8,
		size = 2
	},
	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1818.5, 2604.8, 44.6),
		textCoords = vector3(1818.5, 2608.4, 48.0),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 8,
		size = 2
	},
	{
		objName = 'prop_gate_prison_01',
		objCoords = vector3(1799.237, 2616.303, 44.6),
		textCoords = vector3(1795.941, 2616.969, 48.0),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 8,
		size = 2
	},

	--inside gates

	{	
		
		textCoords = vector3(1831.71,2695.51,48.00), 
		authorizedJobs = {'police', 'fib'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		doors = {
			{
				objName = 741314661,
				objCoords = vector3( 1834.526, 2689.619,45.43349)   
			},
			{
				objName = 741314661, 
				objCoords = vector3(1829.71, 2702.36,  45.43)  
			},
			
		}
	},
	{	
		
		textCoords = vector3(1768.97 ,2748.66,48.00),  
		authorizedJobs = {'police', 'fib'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		doors = {
			{
				objName = 741314661,
				objCoords = vector3(  1775.621, 2747.018, 45.42)    
			},
			{
				objName = 741314661, 
				objCoords = vector3( 1762.88,2751.681, 45.42)   
			},
			
		}
	},

	{	
	
		textCoords = vector3(1655.70, 2744.02,48.00),    
		authorizedJobs = {'police', 'fib'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		doors = {
			{
				objName = 741314661,
				objCoords = vector3(1661.41, 2747.96,  45.44115)  
			},
			{
				objName = 741314661,
				objCoords = vector3(  1649.343, 2741.482, 45.44606)  
			},
			
		}
	},
	{	
	
		textCoords = vector3(1581.72,2672.58,48.00),     
		authorizedJobs = {'police', 'fib'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		doors = {
			{
				
				objName = 741314661,
				objCoords = vector3(1584.59, 2678.56, 45.48)   
			},
			{
				objName = 741314661,
				objCoords = vector3( 1576.83,2667.52, 45.48)
			},
			
		}
	},
	{	
	
		textCoords = vector3(1549.12,2583.57,48.00),      
		authorizedJobs = {'police', 'fib'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		doors = {
			{
				
				objName = 741314661,
				objCoords = vector3( 1548.29,  2590.51, 45.39)   
			},
			{
				objName = 741314661,
				objCoords = vector3( 1547.69,2576.84, 45.39)   
			},
			
		}
	},
	{	
	
		textCoords = vector3(1556.57,2477.337,48.00),       
		authorizedJobs = {'police', 'fib'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		doors = {
			{
				
				objName = 741314661,
				objCoords = vector3(  1551.929,2482.15, 45.39)   
			},
			{
				objName = 741314661,
				objCoords = vector3( 1558.543,2470.2, 45.39)    
			},
			
		}
	},
	{	
	
		textCoords = vector3(1660.46, 2409.40,48.00),       
		authorizedJobs = {'police', 'fib'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		doors = {
			{
				
				objName = 741314661,
				objCoords = vector3( 1653.99,2410.17, 45.40)     
			},
			{
				objName = 741314661,
				objCoords = vector3( 1667.20 ,2408.26,  45.40)    
			},
			
		}
	}, 
	{	
	
		textCoords = vector3( 1755.383,2423.92,48.00),       
		authorizedJobs = {'police', 'fib'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		doors = {
			{
				
				objName = 741314661,
				objCoords = vector3( 1749.41,2420.46, 45.42)       
			},
			{
				objName = 741314661,
				objCoords = vector3( 1761.61 ,2426.63,  45.42)      
			},
			
		}
	}, 
	{	
	
		textCoords = vector3( 1810.58, 2481.92,48.00),     
		authorizedJobs = {'police', 'fib'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		doors = {
			{
				
				objName = 741314661,
				objCoords = vector3( 1808.669,2475.25,  45.44 )        
			},
			{
				objName = 741314661,
				objCoords = vector3(1813.124 ,2488.46,  45.44)         
			},
			
		}
	},                   
	--1692.581, 2468.84, 45.73
	{	
	
		textCoords = vector3(1692.581, 2468.84, 45.73),     
		authorizedJobs = {'police', 'fib'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		doors = {
			{
				
				objName = 458025182,
				objYaw = 2.0,
				objCoords = vector3(1691.901, 2468.761, 45.73)        
			},
			{
				objName = 458025182,
				objYaw = 178.0,
				objCoords = vector3(1693.313, 2468.798, 45.73)         
			},
		}
	},
	----------------
	-- Pacific Bank
	----------------
	-- First Door
	{
		objName = 'hei_v_ilev_bk_gate_pris',
		objCoords  = vector3(257.41, 220.25, 106.4),
		textCoords = vector3(257.41, 220.25, 106.4),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Second Door
	{
		objName = 'hei_v_ilev_bk_gate2_pris',
		objCoords  = vector3(261.83, 221.39, 106.41),
		textCoords = vector3(261.83, 221.39, 106.41),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	-- Office to gate door
	{
		objName = 'v_ilev_bk_door',
		objCoords  = vector3(265.19, 217.84, 110.28),
		textCoords = vector3(265.19, 217.84, 110.28),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},

	-- First safe Door
	{
		objName = 'hei_v_ilev_bk_safegate_pris',
		objCoords  = vector3(252.98, 220.65, 101.8),
		textCoords = vector3(252.98, 220.65, 101.8),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Second safe Door
	{
		objName = 'hei_v_ilev_bk_safegate_pris',
		objCoords  = vector3(261.68, 215.62, 101.81),
		textCoords = vector3(261.68, 215.62, 101.81),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},

	----------------
	-- Fleeca Banks
	----------------
	-- Door 1
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(314.61, -285.82, 54.49),
		textCoords = vector3(313.3, -285.45, 54.49),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Door 2
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(148.96, -1047.12, 29.7),
		textCoords = vector3(148.96, -1047.12, 29.7),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Door 3
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(-351.7, -56.28, 49.38),
		textCoords = vector3(-351.7, -56.28, 49.38),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Door 4
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(-2956.18, -335.76, 38.11),
		textCoords = vector3(-2956.18, -335.76, 38.11),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Door 5
	{
		objName = 'v_ilev_gb_vaubar',
		objCoords  = vector3(-2956.18, 483.96, 16.02),
		textCoords = vector3(-2956.18, 483.96, 16.02),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	-- Paleto Door 1
	{
		objName = 'v_ilev_cbankvaulgate01',
		objCoords  = vector3(-105.77, 6472.59, 31.81),
		textCoords = vector3(-105.77, 6472.59, 31.81),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	-- Paleto Door 2
	{
		objName = 'v_ilev_cbankvaulgate02',
		objCoords  = vector3(-106.26, 6476.01, 31.98),
		textCoords = vector3(-105.5, 6475.08, 31.99),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.5,
		size = 2
	},
	
	-----
	-- Police front gate
	-----
	{
		objName = 'prop_facgate_07b',
		objYaw = -90.0,
		objCoords  = vector3(419.99, -1025.0, 28.99),
		textCoords = vector3(419.9, -1021.04, 30.5),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 20,
		size = 2
	},
	---------------------------
	---- Pillbox Hospital -----
	---------------------------
	{
		objName = 854291622,
		objYaw = -20.0,
		objCoords  = vector3(308.2473, -569.98, 43.284),
		textCoords = vector3(308.2473, -569.98, 43.284),
		authorizedJobs = { 'ambulance', 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.0,
		size = 2
	},

	{
		objName = 854291622,
		objYaw = 70.0,
		objCoords  = vector3(304.3592, -571.437, 43.284),
		textCoords = vector3(304.3592, -571.437, 43.284),
		authorizedJobs = { 'ambulance', 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.0,
		size = 2
	},

	{
		textCoords = vector3(313.2112, -571.7566, 43.284),
		authorizedJobs = { 'ambulance', 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = "gabz_pillbox_doubledoor_r",
				objYaw = -20.0,
				objCoords = vector3(314.2841, -572.3365, 43.284)
			},

			{
				objName = "gabz_pillbox_doubledoor_l",
				objYaw = -20.0,
				objCoords = vector3(312.10, -571.41, 43.284)
			}
		}
	},

	{
		textCoords = vector3(319.17, -573.97, 43.28),
		authorizedJobs = { 'ambulance', 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = "gabz_pillbox_doubledoor_r",
				objYaw = -20.0,
				objCoords = vector3(320.0, -574.01, 43.75)
			},

			{
				objName = "gabz_pillbox_doubledoor_l",
				objYaw = -20.0,
				objCoords = vector3(318.02, -573.60, 43.86)
			}
		}
	},

	{
		textCoords = vector3(324.45, -575.91, 43.28),
		authorizedJobs = { 'ambulance', 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = "gabz_pillbox_doubledoor_l",
				objYaw = -20.0,
				objCoords = vector3(323.40, -575.34, 43.75)
			},

			{
				objName = "gabz_pillbox_doubledoor_r",
				objYaw = -20.0,
				objCoords = vector3(325.23, -575.91, 43.75)
			}
		}
	},

	{
		textCoords = vector3(326.24, -579.27, 43.35),
		authorizedJobs = { 'ambulance', 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = "gabz_pillbox_doubledoor_l",
				objYaw = 250.0,
				objCoords = vector3(326.50, -578.30, 43.73)
			},

			{
				objName = "gabz_pillbox_doubledoor_r",
				objYaw = 250.0,
				objCoords = vector3(326.01, -580.35, 43.75)
			}
		}
	},

	-- Jewellry store

	{
		textCoords = vector3(-631.16, -237.35, 38.07),
		authorizedJobs = { 'ambulance', 'police', 'fib' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 1425919976,
				objYaw = 305.0,
				objCoords = vector3(-631.63, -236.43, 38.070)
			},

			{
				objName = 9467943,
				objYaw = 307.0,
				objCoords = vector3(-630.6583, -238.259, 38.07)
			}
		}
	},

	-- check in place
	{
		objName = 854291622,
		objYaw = -110.0,
		objCoords  = vector3(313.04, -596.45, 43.284),
		textCoords = vector3(313.04, -596.45, 43.284),
		authorizedJobs = { 'ambulance', 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.0,
		size = 2
	},
	{
		objName = 854291622,
		objYaw = 160.0,
		objCoords  = vector3(308.11, -597.35, 43.284),
		textCoords = vector3(308.11, -597.35, 43.284),
		authorizedJobs = { 'ambulance', 'police', 'fib' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 1.0,
		size = 2
	},

	---------------------------
	-- Import car dealership --
	---------------------------
	-----
	-- Dealership garage door
	-----
	{
		objName = -969412534,
		objCoords  = vector3(147.35, -133.56, 54.85),
		textCoords = vector3(147.11, -133.56, 55.85),
		authorizedJobs = { 'cardealer', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 15,
		size = 2
	},
	-----
	-- Dealership front six door
	-----
	{
		textCoords = vector3(111.27, -152.165, 54.85),
		authorizedJobs = {'cardealer', 'police'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 5.0,
		doors = {
			{
				objName = -1038027614,
				objCoords = vector3(110.263, -150.1284, 54.84995)
			},
			{
				objName = -1038027614,
				objCoords = vector3(110.3545, -151.1052, 54.84995)
			},
			{
				objName = -1038027614,
				objCoords = vector3(111.06, -151.71, 54.85)
			},
			{
				objName = -1038027614,
				objCoords = vector3(111.48, -152.56, 54.85)
			},
			{
				objName = -1038027614,
				objCoords = vector3(111.56, -153.426, 54.85)
			},
			{
				objName = -1038027614,
				objCoords = vector3(112.34, -154.25, 54.85)
			}
		}
	},
	---------------------------
	-- Pilbox EMS Hospital --
	---------------------------

	---------------------------
	-------  FIB  -------------
	---------------------------

	{
		objName = -2023754432,
		objYaw = -45.0,
		objCoords  = vector3(2502.87, -422.55, 94.58),  
		textCoords = vector3(2502.87, -422.55, 94.58),
		authorizedJobs = { 'fib', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = 1055151324,
		objYaw = -45.0,
		objCoords  = vector3(2510.36, -415.35, 99.11),  
		textCoords = vector3(2510.36, -415.35, 99.11),
		authorizedJobs = { 'fib', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = 203184370,
		objYaw = 135.0,
		objCoords  = vector3(2495.09, -421.49, 99.11),  
		textCoords = vector3(2495.09, -421.49, 99.11),
		authorizedJobs = { 'fib', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = 203184370,
		objYaw = 135.0,
		objCoords  = vector3(2489.54, -416.028, 99.11),  
		textCoords = vector3(2489.54, -416.028, 99.11),
		authorizedJobs = { 'fib', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = 203184370,
		objYaw = 45.0,
		objCoords  = vector3(2491.33, -409.82, 99.11),  
		textCoords = vector3(2491.33, -409.82, 99.11),
		authorizedJobs = { 'fib', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = 203184370,
		objYaw = 45.0,
		objCoords  = vector3(2496.153, -405.00, 99.11),  
		textCoords = vector3(2496.153, -405.00, 99.11),
		authorizedJobs = { 'fib', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = 203184370,
		objYaw = -45.0,
		objCoords  = vector3(2501.022, -406.26, 99.11),  
		textCoords = vector3(2501.022, -406.26, 99.11),
		authorizedJobs = { 'fib', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = 203184370,
		objYaw = 135.0,
		objCoords  = vector3(2513.755, -440.5024, 99.11),  
		textCoords = vector3(2513.755, -440.5024, 99.11),
		authorizedJobs = { 'fib', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = 203184370,
		objYaw = -45.0,
		objCoords  = vector3(2516.361, -435.70, 99.11),  
		textCoords = vector3(2516.361, -435.70, 99.11),
		authorizedJobs = { 'fib', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		textCoords = vector3(2500.15, -423.0823, 99.11),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 3.5,
		doors = {
			{
				objName = 1055151324,
				objYaw = 45.0,
				objCoords = vector3(2500.66, -422.57, 99.11)
			},

			{
				objName = 1055151324,
				objYaw = 225.0,
				objCoords = vector3(2499.516, -423.63, 99.11)
			}
		}
	},

	{
		textCoords = vector3(2511.81, -434.811, 99.11),
		authorizedJobs = { 'police', 'fib' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 3.5,
		doors = {
			{
				objName = 1055151324,
				objYaw = 225.0,
				objCoords = vector3(2511.266, -435.38, 99.11)
			},

			{
				objName = 1055151324,
				objYaw = 45.0,
				objCoords = vector3(2512.391, -434.26, 99.11)
			}
		}
	},

	{
		objName = 1055151324,
		objYaw = 45.0,
		objCoords  = vector3(2510.347, -413.75, 106.91),  
		textCoords = vector3(2510.347, -413.75, 106.91),
		authorizedJobs = { 'fib', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = 203184370,
		objYaw = 45.0,
		objCoords  = vector3(2511.419, -418.18, 106.91),  
		textCoords = vector3(2511.419, -418.18, 106.91),
		authorizedJobs = { 'fib', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = 203184370,
		objYaw = 45.0,
		objCoords  = vector3(2502.995, -427.09, 106.91),  
		textCoords = vector3(2502.995, -427.09, 106.91),
		authorizedJobs = { 'fib', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = 203184370,
		objYaw = 45.0,
		objCoords  = vector3(2507.665, -416.64, 106.91),  
		textCoords = vector3(2507.665, -416.64, 106.91),
		authorizedJobs = { 'fib', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = 203184370,
		objYaw = -135.0,
		objCoords  = vector3(2501.40, -422.81, 106.91),  
		textCoords = vector3(2501.40, -422.81, 106.91),
		authorizedJobs = { 'fib', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = 1055151324,
		objYaw = -45.0,
		objCoords  = vector3(2505.55, -425.69, 106.91),  
		textCoords = vector3(2505.55, -425.69, 106.91),
		authorizedJobs = { 'fib', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = 203184370,
		objYaw = 45.0,
		objCoords  = vector3(2510.25, -434.22, 106.91),  
		textCoords = vector3(2510.25, -434.22, 106.91),
		authorizedJobs = { 'fib', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = 203184370,
		objYaw = 135.0,
		objCoords  = vector3(2512.20, -438.95, 106.91),  
		textCoords = vector3(2512.20, -438.95, 106.91),
		authorizedJobs = { 'fib', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = 1055151324,
		objYaw = -45.0,
		objCoords  = vector3(2514.73, -434.89, 106.91),  
		textCoords = vector3(2514.73, -434.89, 106.91),
		authorizedJobs = { 'fib', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	---------------------------
	-------- Sandy Police Station ---------
	---------------------------
	{
		objName = -1765048490,
		objYaw = 30.0,
		objCoords  = vector3(1854.877, 3683.442, 34.26),  
		textCoords = vector3(1854.877, 3683.442, 34.26),
		authorizedJobs = { 'police' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = -2023754432,
		objYaw = 210.0,
		objCoords  = vector3(1856.405, 3689.884, 34.26),  
		textCoords = vector3(1856.405, 3689.884, 34.26),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = -1765048490,
		objYaw = 30.0,
		objCoords  = vector3(1859.923, 3691.966, 34.26),  
		textCoords = vector3(1859.923, 3691.966, 34.26),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = -2023754432,
		objYaw = 120.0,
		objCoords  = vector3(1852.042, 3694.998, 34.26),  
		textCoords = vector3(1852.042, 3694.998, 34.26),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = -2023754432,
		objYaw = 300.0,
		objCoords  = vector3(1849.014, 3692.563, 34.26),  
		textCoords = vector3(1849.014, 3692.563, 34.26),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
		size = 2
	},

	{
		textCoords = vector3(1848.298, 3690.694, 34.267),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = -2023754432,
				objYaw = 28.0,
				objCoords = vector3(1847.69, 3690.022, 34.26)
			},

			{
				objName = -2023754432,
				objYaw = 210.0,
				objCoords = vector3(1849.052, 3690.955, 34.26)
			}
		}
	},

	{
		textCoords = vector3(1850.349, 3682.801, 34.26),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = -2023754432,
				objYaw = -60.0,
				objCoords = vector3(1850.063, 3683.58, 34.26)
			},

			{
				objName = -2023754432,
				objYaw = 120.0,
				objCoords = vector3(1850.981, 3682.285, 34.267)
			}
		}
	},

	{
		textCoords = vector3(1847.509, 3683.409, 30.25),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = -2023754432,
				objYaw = 210.0,
				objCoords = vector3(1848.195, 3683.689, 30.25)
			},

			{
				objName = -2023754432,
				objYaw = 30.0,
				objCoords = vector3(1846.853, 3682.921, 30.259)
			}
		}
	},

	{
		objName = "v_ilev_ph_cellgate1",
		objYaw = -60.0,
		objCoords  = vector3(1858.555, 3695.735, 30.25921),  
		textCoords = vector3(1858.555, 3695.735, 30.25921),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	-- big ass cell
	{
		objName = -53345114,
		objYaw = 180.0,
		objCoords  = vector3(485.00, -1007.752, 26.32),  
		textCoords = vector3(485.00, -1007.752, 26.32),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = "v_ilev_ph_cellgate1",
		objYaw = -60.0,
		objCoords  = vector3(1860.467, 3692.487, 30.25),  
		textCoords = vector3(1860.467, 3692.487, 30.25),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = "v_ilev_ph_cellgate1",
		objYaw = -60.0,
		objCoords  = vector3(1862.217, 3689.302, 30.25),  
		textCoords = vector3(1862.217, 3689.302, 30.25),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	{
		objName = "v_ilev_ph_cellgate1",
		objYaw = -60.0,
		objCoords  = vector3(1859.172, 3687.432, 30.25),  
		textCoords = vector3(1859.172, 3687.432, 30.25),
		authorizedJobs = { 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2,
		size = 2
	},

	---------------------------
	-------- Pizzeria ---------
	---------------------------
	{
		objName = 757543979,
		objCoords  = vector3(296.39, -993.75, 29.43),  
		textCoords = vector3(296.39, -993.75, 29.43),
		authorizedJobs = { 'pizza', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 5,
		size = 2
	},

	{
		objName = -950166942,
		objYaw = 0.00,
		objCoords  = vector3(287.50, -964.30, 29.41),  
		textCoords = vector3(287.50, -964.30, 29.41),
		authorizedJobs = { 'pizza', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 5,
		size = 2
	},

	{
		objName = 1289778077,
		objYaw = 269.82,
		objCoords  = vector3(285.19,  -978.12, 29.43),   
		textCoords = vector3(285.19, -978.12,  29.43),
		authorizedJobs = { 'pizza', 'police' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1,
		size = 2
	},

	{
		objName = 2035930085,
		objCoords  = vector3(  297.76, -985.23,  29.56),    
		textCoords = vector3( 297.76,  -985.23, 29.56),
		authorizedJobs = {},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1,
		size = 2
	},
	---------------------------
	---------- GYM ------------
	---------------------------
	{
		objName = 452874391,
		objCoords  = vector3( -45.87, -1289.99,  29.60),    
		textCoords = vector3( -45.87, -1289.99, 29.60),
		authorizedJobs = {'gym'},
		locking = false,
		locked = false,
		pickable = false,
		distance = 5,
		size = 2
	},
	
	---------------------------
	------ DIAMOND CASINO -----
	---------------------------

	---Six casino front doors
	{
		textCoords = vector3( 925.08,46.49, 81.10),  
		authorizedJobs = {'casino'},
		locking = false,
		locked = false,
		pickable = false,
		distance = 5.0,
		doors = {
			{
				objName = 21324050,
				objCoords = vector3(927.42, 49.58493, 81.10638)   
			},
			{
				objName = 21324050,
				objCoords = vector3(926.2316, 47.82007, 81.10638)   
			},
			{
				objName = 21324050,
				objCoords = vector3(925.7616, 47.10228,81.10638)   
			},
			{
				objName = 21324050,
				objCoords = vector3(924.7728, 45.46212, 81.10638)   
			}, 
			{
				objName =21324050,
				objCoords = vector3(924.2845, 44.60535, 81.10638)   
			},
			{
				objName = 21324050,
				objCoords = vector3(923.3648, 43.12742,81.10638)   
			}
		}
	},
	--- casino garage door
	{
		objName = 901693952,
		objCoords  = vector3( 930.8574, 30.20035, 81.15639),      
		textCoords = vector3(  930.8574, 30.20035, 81.15639),
		authorizedJobs = {'casino'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 5,
		size = 2
	},
	--- casino Management door 
	{
		textCoords = vector3(978.2996, 68.07584, 70.23),   
		authorizedJobs = {'casino'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		doors = {
			{
				objName = 680601509,
				objCoords = vector3(977.6346,67.79201,  70.23318)  
			},

			{
				objName = 680601509,
				objCoords = vector3( 978.4402,68.61892,   70.23309 )  
			}
		}
	},
	--- double door management
	{
		textCoords = vector3(985.39, 35.13, 70.23),   
		authorizedJobs = {'casino'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		doors = {
			{
				objName = 680601509,
				objCoords = vector3(984.3, 36.01, 70.23)  
			},

			{
				objName = 680601509,
				objCoords = vector3(985.66, 34.86, 70.23)  
			}
		}
	},
	--- casino Penthouse up door
	{
		objName = -1691719897,
		objCoords  = vector3( 968.2664, 63.93, 112.553 ),       
		textCoords = vector3(  968.2664, 63.93, 112.553),
		authorizedJobs = {'casino'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 5,
		size = 2
	},
	--- casino Staff door
	{
		objName = 1266543998,
		objCoords  = vector3( 950.1844, 26.89514, 71.8337 ),       
		textCoords = vector3(  950.1844, 26.89514, 71.8337),
		authorizedJobs = {'casino'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 5,
		size = 2
	},
	---Mechanic Door
	{
		objName = -427498890,
		objCoords  = vector3( -205.70,-1309.55,  31.28734 ),       
		textCoords = vector3(  -205.70, -1309.55,31.28734),
		authorizedJobs = {'mechanic'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		size = 2
	},
	---------------------------
	-------- COCKATOOS --------
	---------------------------
	{
		objName = 634417522,
		objCoords  = vector3(-443.67, -29.46, 40.87),      
		textCoords = vector3(-443.67, -29.46, 40.87),
		authorizedJobs = {'cockatoos'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 5,
		size = 2
	},
	{
		textCoords =  vector3(-437.16, -22.25, 46.19),
		objName = -768779561,
		objCoords = vector3(-428.37, -20.12, 46.22),
		displayName = 'Left Gate',
		authorizedJobs = {'cockatoos'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 2
	},
	{
		textCoords = vector3(-433.78, -22.42, 46.19),
		objName = -768779561,
		objCoords = vector3(-410.24, -34.30, 46.40),
		displayName = 'Right Gate',
		authorizedJobs = {'cockatoos'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 2
	},
	{
		textCoords = vector3(-431.84, -24.16, 46.19),   
		authorizedJobs = {'cockatoos'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		doors = {
			{
				objName = -1119680854,
				objCoords = vector3(-431.78, -24.73, 46.23)  
			},

			{
				objName = -1119680854,
				objCoords = vector3(-431.64, -23.45, 46.23)  
			}
		}
	},

	---------------------------
	-------- Taxi -------------
	---------------------------
	{
		textCoords = vector3(894.70, -178.95, 74.70),   
		authorizedJobs = {'taxi'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		doors = {
			{
				objName = -2023754432,
				objYaw = -122.0,
				objCoords = vector3(895.00, -178.28, 74.70)  
			},

			{
				objName = -2023754432,
				objYaw = 58.0,
				objCoords = vector3(894.22, -179.72, 74.70)  
			}
		}
	},
	{
		textCoords = vector3(907.04, -160.71, 74.15),   
		authorizedJobs = {'taxi'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		doors = {
			{
				objName = "prop_taxidoorl",
				objYaw = -122.0,
				objCoords = vector3(906.64, -161.39, 74.16)  
			},

			{
				objName = "prop_taxidoorr",
				objYaw = -122.0,
				objCoords = vector3(907.48, -159.95, 74.15)  
			}
		}
	},
	{
		textCoords = {
			[1] = vector3(902.41, -176.13, 74.01),
			[2] = vector3(918.85, -177.325, 74.361)
		},
		objName = -1483471451,
		objCoords = vector3(916.62, -177.772, 74.281),
		displayName = 'Gate',
		authorizedJobs = {'taxi'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 3
	},
	{
		textCoords = vector3(900.57, -162.55, 74.14),   
		authorizedJobs = {'taxi'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		doors = {
			{
				objName = "V_ILev_SS_Door7",
				objYaw = 148.0,
				objCoords = vector3(900.06, -162.33, 74.14)  
			},

			{
				objName = "V_ILev_SS_Door8",
				objYaw = -31.8,
				objCoords = vector3(901.26, -163.09, 74.14)  
			}
		}
	},
	{
		textCoords = vector3(896.26, -145.02, 76.91),
		authorizedJobs = {'taxi'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		doors = {
			{
				objName = -2023754432,
				objYaw = -31.8,
				objCoords = vector3(896.26, -145.02, 76.91)
			}
		}
	},
	{
		textCoords = vector3(892.77, -155.49, 76.94),
		displayName = 'Garage Door',
		authorizedJobs = {'taxi'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 3,
		doors = {
			{
				objName = 2064385778,
				objCoords = vector3(899.57, -148.30, 76.75)
			}
		}
	},
	{
		objName = "V_ILev_RC_Door2",
		objYaw = 148.0,
		objCoords  = vector3(896.43, -168.93, 74.68),      
		textCoords = vector3(896.43, -168.93, 74.68),
		authorizedJobs = {'taxi'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	{
		objName = "V_ILev_RC_Door2",
		objYaw = 148.0,
		objCoords  = vector3(894.88, -174.35, 74.68),      
		textCoords = vector3(894.88, -174.35, 74.68),
		authorizedJobs = {'taxi'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	{
		objName = 426403179,
		objYaw = 58.0,
		objCoords  = vector3(888.70, -160.59, 76.94),      
		textCoords = vector3(888.70, -160.59, 76.94),
		authorizedJobs = {'taxi'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	---------------------------
	-------- AIRLINE GATES --------
	---------------------------
	{
		objName = 'prop_gate_airport_01',
		objCoords = vector3(-977.5174, -2837.2644, 12.954859),      
		textCoords = vector3(-980.33, -2834.311, 13.96454),
		authorizedJobs = {'airlines'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		size = 2
	},
	{
		objName = 'prop_gate_airport_01',
		objCoords = vector3(-990.2963, -2829.8872, 12.949859),        
		textCoords = vector3(-985.64, -2829.91, 13.96),
		authorizedJobs = {'airlines'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		size = 2
	},

	{
		objName = 'prop_gate_airport_01',
		objCoords = vector3(-1138.4724, -2730.4458, 12.949859),      
		textCoords = vector3(-1141.478, -2727.1, 139555),
		authorizedJobs = {'airlines'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		size = 2
	},
	{
		objName = 'prop_gate_airport_01',
		objCoords = vector3(-1151.2069, -2723.0928, 12.949859),
		textCoords = vector3(-1147.268, -2724.49, 13.9543),
		authorizedJobs = {'airlines'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		size = 2
	},
	{
		objName = 'prop_gate_airport_01',
		objCoords = vector3(-1015.48535, -2419.5828, 12.958631),      
		textCoords = vector3(-1011.827, -2417.32, 13.9555),
		authorizedJobs = {'airlines'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		size = 2
	},
	{
		objName = 'prop_gate_airport_01',
		objCoords = vector3(-1008.0708, -2406.751, 12.977007),        
		textCoords = vector3(-1008.739, -2410.768, 13.9445),
		authorizedJobs = {'airlines'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 13,
		size = 2
	},
	---------------------------
	------- CAYO GATES --------
	---------------------------

	-- FRONT GATES, ONLY 2 ARE WORKING BUT I DONT GIVE A FUCK; IT'S GOOD ACTUALLY
	{
		textCoords = vector3(4982.88, -5711.07, 19.88),   
		authorizedJobs = {},
		locking = false,
		locked = false,
		pickable = false,
		distance = 1.5,
		doors = {
			{
				objName = -1574151574,
				objYaw = 0.0,
				objCoords = vector3(4983.7, -5709.26, 19.88)  
			},

			{
				objName = -1574151574,
				objYaw = 0.0,
				objCoords = vector3(4981.196, -5712.54, 19.88)  
			},
			{
				objName = -1574151574,
				objYaw = 0.0,
				objCoords = vector3(4987.92, -5718.68, 19.88)  
			},

			{
				objName = -1574151574,
				objYaw = 0.0,
				objCoords = vector3(4990.36, -5715.26, 19.88)  
			}
		}
	},
	---------------------------
	----- REAL ESTATE ---------
	---------------------------

	{
		textCoords = vector3(-699.18, 270.89, 83.14),
		authorizedJobs = {'realestate'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = -1922281023,
				objYaw = 115.0,
				objCoords = vector3(-699.44, 271.1, 83.14)
			},

			{
				objName = -1922281023,
				objYaw = -65.0,
				objCoords = vector3(-698.92, 270.42, 83.14)
			}
		}
	},

	{
		objName = 1901183774,
		objYaw = -65.0,
		objCoords = vector3(-716.55, 271.14, 84.70),        
		textCoords = vector3(-716.55, 271.14, 84.70),
		authorizedJobs = {'realestate'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},

	{
		objName = 1901183774,
		objYaw = -65.0,
		objCoords = vector3(-714.38, 265.34, 84.10),        
		textCoords = vector3(-714.38, 265.34, 84.10),
		authorizedJobs = {'realestate'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},

	---------------------------
	------ CASINO UNDER -------
	---------------------------

	-- OFFICE

	{
		objName = -88942360,
		objCoords = vector3(-376.95, 210.23, 81.32),        
		textCoords = vector3(-376.72, 209.4, 81.31),
		objYaw = 90.0,
		authorizedJobs = {'casinounderground'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	{
		objName = 1804626822,
		objCoords = vector3(-372.70, 194.60, 84.06),        
		textCoords = vector3(-372.29, 194.65, 84.0),
		objYaw = 180.0,
		authorizedJobs = {'casinounderground'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},

	---------------------------
	------- MECHANICS 2 -------
	---------------------------
	{
		objName = -190780785,
		objCoords = vector3(-356.20, -134.6, 38.99),        
		textCoords = vector3(-356.20, -134.6, 38.99),
		objYaw = -110.0,
		authorizedJobs = {'mechanic2'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 10,
		size = 2
	},

	---------------------------
	------ GYM 2 -------
	---------------------------

	{
		textCoords = vector3(-756.73, 241.15, 75.64),
		authorizedJobs = {"gym2"},
		locking = false,
		locked = false,
		pickable = false,
		distance = 1.5,
		doors = {
			{
				objName = -1821777087,
				objYaw = 10.0,
				objCoords = vector3(-755.79, 241.45, 75.65)  
			},
	
			{
				objName = -1821777087,
				objYaw = 190.0,
				objCoords = vector3(-757.95, 241.00, 75.65)  
			},
		}
	},

	---------------------------
	------ ARCADE BAR -------
	---------------------------

	{
		objName = 'patoche_cyber_door5',
		objCoords = vector3(341.4532, -939.6378, 29.56765),        
		textCoords = vector3(341.4532, -939.6378, 29.56765),
		objYaw = 0.0,
		authorizedJobs = {'arcadebar'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	{
		objName = 'patoche_cyber_door4',
		objCoords = vector3(324.4915, -925.0674, 29.49783),        
		textCoords = vector3(324.4915, -925.0674, 29.49783),
		objYaw = 0.0,
		authorizedJobs = {'arcadebar'},
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
		size = 2
	},
	{
		textCoords = vector3(310.07, -907.21, 29.31944),
		authorizedJobs = { 'arcadebar' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 3.0,
		doors = {
			{
				objName = 1250772920,
				objYaw = 89.999977111816,
				objCoords = vector3(310.248, -906.0159, 28.31944),
			},
	
			{
				objName = -956579645,
				objYaw = 270.0,
				objCoords = vector3(310.2527, -907.9799, 28.31944),
			},
		}
	},

	---------------------------
	------ State Police -------
	---------------------------

	{
		textCoords = vector3(1536.80, 819.80, 77.65),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.0,
		doors = {
			{
				objName = -584365942,
				objYaw = 59.75,
				objCoords = vector3(1537.418, 820.8973, 77.80643),
			},
	
			{
				objName = -584365942,
				objYaw = 240.0,
				objCoords = vector3(1536.117, 818.6437, 77.80643),
			},
		}
	},

	{
		objName = 1040797377,
		objYaw = 59.923282623291,
		objCoords = vector3(1545.882, 820.5397, 77.7927),
		textCoords = vector3(1546.37, 821.4397, 77.7927),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = 1040797377,
		objYaw = 329.92138671875,
		objCoords = vector3(1539.245, 822.1432, 77.7927),
		textCoords = vector3(1540.13, 821.57, 77.7927),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = 1040797377,
		objYaw = 60.026363372803,
		objCoords = vector3(1541.449, 812.185, 77.7927),
		textCoords = vector3(1541.92, 812.99, 77.65),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = 1040797377,
		objYaw = 240.00003051758,
		objCoords = vector3(1542.14, 809.8223, 77.7927),
		textCoords = vector3(1541.60, 809.04, 77.65),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = 1040797377,
		objYaw = 239.95834350586,
		objCoords = vector3(1546.051, 816.5969, 77.7927),
		textCoords = vector3(1545.54, 815.79, 77.65),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = -344890090,
		objYaw = 240.13511657715,
		objCoords = vector3(1547.711, 814.136, 77.7927),
		textCoords = vector3(1548.14, 814.96, 77.7927),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = -344890090,
		objYaw = 240.00003051758,
		objCoords = vector3(1551.01, 819.8503, 77.78793),
		textCoords = vector3(1551.46, 820.67, 77.78793),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	-- Cells

	{
		objName = -1671593055,
		objYaw = 60.165588378906,
		objCoords = vector3(1559.062, 833.1785, 76.65674),
		textCoords = vector3(1558.64, 832.32, 77.65),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 0.8,
	},
	
	{
		objName = -1671593055,
		objYaw = 330.04992675781,
		objCoords = vector3(1559.925, 830.4579, 76.65674),
		textCoords = vector3(1559.164, 830.8634, 77.65554),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 0.8,
	},

	{
		objName = -1671593055,
		objYaw = 330.02093505859,
		objCoords = vector3(1563.922, 828.1503, 76.65674),
		textCoords = vector3(1562.976, 828.5979, 77.65565),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 0.8,
	},

	{
		objName = -1671593055,
		objYaw = 330.13250732422,
		objCoords = vector3(1565.422, 830.743, 76.65674),
		textCoords = vector3(1564.473, 831.1975, 77.65565),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 0.8,
	},

	{
		objName = -1671593055,
		objYaw = 329.61047363281,
		objCoords = vector3(1561.424, 833.051, 76.65674),
		textCoords = vector3(1560.509, 833.5515, 77.65574),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = -1671593055,
		objYaw = 238.94255065918,
		objCoords = vector3(1552.332, 833.4189, 76.65674),
		textCoords = vector3(1552.669, 834.1738, 77.65583),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = 1040797377,
		objYaw = 329.94854736328,
		objCoords = vector3(1547.084, 820.6359, 82.27543),
		textCoords = vector3(1547.766, 820.1155, 82.13046),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = 1040797377,
		objYaw = 150.15586853027,
		objCoords = vector3(1544.804, 821.9525, 82.27543),
		textCoords = vector3(1543.93, 822.426, 82.13053),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	{
		objName = 1040797377,
		objYaw = 330.02947998047,
		objCoords = vector3(1544.375, 826.8131, 82.27543),
		textCoords = vector3(1545.131, 826.4286, 82.13053),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = 1028191914,
		objYaw = 90.287101745605,
		objCoords = vector3(1783.137, 2549.27, 45.97809),
		textCoords = vector3(1783.14, 2547.32, 45.97809),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	
	{
		objName = 262839150,
		objYaw = 272.13787841797,
		objCoords = vector3(1791.683, 2551.347, 46.08823),
		textCoords = vector3(1791.642, 2552.43, 46.08819),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},

	{
		objName = 1645000677,
		objYaw = 269.99914550781,
		objCoords = vector3(1776.112, 2551.352, 46.08823),
		textCoords = vector3(1776.112, 2552.435, 46.08823),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},

	{
		objName = 1028191914,
		objYaw = 180.31484985352,
		objCoords = vector3(1784.653, 2550.299, 45.98037),
		textCoords = vector3(1785.736, 2550.305, 45.98037),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},

	{
		objName = 262839150,
		objYaw = 179.9263458252,
		objCoords = vector3(1764.996, 2566.574, 45.96848),
		textCoords = vector3(1766.079, 2566.572, 45.96848),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	
	{
		objName = 1028191914,
		objYaw = 89.931480407715,
		objCoords = vector3(1774.917, 2593.757, 45.97295),
		textCoords = vector3(1774.915, 2592.673, 45.97295),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.0,
	},
	
	{
		objName = 1645000677,
		objYaw = 179.77598571777,
		objCoords = vector3(1785.082, 2600.229, 46.08249),
		textCoords = vector3(1786.165, 2600.225, 46.08249),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	
	{
		objName = 1028191914,
		objYaw = 89.687858581543,
		objCoords = vector3(1783.89, 2599.207, 45.97709),
		textCoords = vector3(1783.884, 2598.123, 45.97709),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.0,
	},
	
	{
		objName = 1028191914,
		objYaw = 0.12177975475788,
		objCoords = vector3(1782.371, 2595.814, 45.97295),
		textCoords = vector3(1781.288, 2595.812, 45.97295),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.0,
	},
	
	{
		objName = -1033001619,
		objYaw = 90.258079528809,
		objCoords = vector3(1845.198, 2585.24, 46.09929),
		textCoords = vector3(1845.32, 2586.14, 46.09928),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	
	{
		objName = -1033001619,
		objYaw = 89.81591796875,
		objCoords = vector3(1819.129, 2593.64, 46.09929),
		textCoords = vector3(1819.12, 2594.58, 46.09929),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	
	{
		objName = 1028191914,
		objYaw = 90.11190032959,
		objCoords = vector3(1771.568, 2571.673, 50.72936),
		textCoords = vector3(1771.57, 2570.59, 50.72936),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.0,
	},

	{
		textCoords = vector3(1790.977, 2593.72, 46.14),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 262839150,
				objYaw = 270.02551269531,
				objCoords = vector3(1791.118, 2592.505, 46.30194)
			},

			{
				objName = 1645000677,
				objYaw = 89.783164978027,
				objCoords = vector3(1791.121, 2595.102, 46.30194),
			}
		}
	},

	{
		objName = 1028191914,
		objYaw = 358.97525024414,
		objCoords = vector3(1785.977, 2566.896, 45.98976),
		textCoords = vector3(1784.894, 2566.916, 45.98972),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = 1028191914,
		objYaw = 1.4478982686996,
		objCoords = vector3(1780.352, 2596.023, 50.83891),
		textCoords = vector3(1779.269, 2595.996, 50.83891),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = 1028191914,
		objYaw = 269.83978271484,
		objCoords = vector3(1787.711, 2606, 50.73208),
		textCoords = vector3(1787.714, 2607.084, 50.73208),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	

	{
		objName = 262839150,
		objYaw = 0.083212785422802,
		objCoords = vector3(1787.067, 2621.013, 45.97227),
		textCoords = vector3(1785.983, 2621.012, 45.97225),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = 1645000677,
		objYaw = 270.15054321289,
		objCoords = vector3(1759.927, 2614.645, 45.9342),
		textCoords = vector3(1759.924, 2615.728, 45.9342),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = 1028191914,
		objYaw = 89.863960266113,
		objCoords = vector3(1763.447, 2617.448, 46.1502),
		textCoords = vector3(1763.444, 2616.365, 46.1502),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = 1028191914,
		objYaw = 359.42999267578,
		objCoords = vector3(1766.897, 2615.484, 46.15419),
		textCoords = vector3(1765.814, 2615.495, 46.15423),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = 1028191914,
		objYaw = 270.19021606445,
		objCoords = vector3(1769.17, 2613.576, 46.1502),
		textCoords = vector3(1769.167, 2614.659, 46.1502),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = 1028191914,
		objYaw = 270.1467590332,
		objCoords = vector3(1781.95, 2613.576, 46.1502),
		textCoords = vector3(1781.947, 2614.659, 46.15023),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = 1028191914,
		objYaw = 90.233940124512,
		objCoords = vector3(1781.85, 2619.262, 46.1502),
		textCoords = vector3(1781.854, 2618.179, 46.15021),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = 1028191914,
		objYaw = 90.173873901367,
		objCoords = vector3(1769.167, 2619.262, 46.1502),
		textCoords = vector3(1769.17, 2618.179, 46.15014),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = 1028191914,
		objYaw = 90.14769744873,
		objCoords = vector3(1786.276, 2551.773, 49.75458),
		textCoords = vector3(1786.279, 2550.69, 49.75458),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = 1028191914,
		objYaw = 90.173873901367,
		objCoords = vector3(1769.167, 2619.262, 46.1502),
		textCoords = vector3(1769.17, 2618.179, 46.15014),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		textCoords = vector3(1785.74, 2609.68, 46.11),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 262839150,
				objYaw = 180.21047973633,
				objCoords = vector3(1784.523, 2609.675, 46.29966)
			},

			{
				objName = 1645000677,
				objYaw = 359.88800048828,
				objCoords = vector3(1787.123, 2609.666, 46.29966),
			}
		}
	},

	{
		objName = 1028191914,
		objYaw = 89.803565979004,
		objCoords = vector3(1764.964, 2608.425, 50.73208),
		textCoords = vector3(1764.961, 2607.341, 50.73208),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	
	{
		objName = 871712474,
		objYaw = 89.522239685059,
		objCoords = vector3(1765.192, 2588.867, 50.67069),
		textCoords = vector3(1765.183, 2587.874, 50.6707),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	
	{
		objName = 871712474,
		objYaw = 89.511619567871,
		objCoords = vector3(1765.19, 2591.819, 50.67069),
		textCoords = vector3(1765.181, 2590.825, 50.67075),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	
	{
		objName = 871712474,
		objYaw = 89.497993469238,
		objCoords = vector3(1765.19, 2594.759, 50.67069),
		textCoords = vector3(1765.181, 2593.765, 50.67072),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	
	{
		objName = 871712474,
		objYaw = 89.682914733887,
		objCoords = vector3(1765.197, 2597.699, 50.67069),
		textCoords = vector3(1765.191, 2596.706, 50.67062),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	
	{
		objName = 871712474,
		objYaw = 270.12359619141,
		objCoords = vector3(1762.774, 2596.512, 50.67069),
		textCoords = vector3(1762.771, 2597.506, 50.67075),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	
	{
		objName = 871712474,
		objYaw = 270.44827270508,
		objCoords = vector3(1762.78, 2593.568, 50.67069),
		textCoords = vector3(1762.772, 2594.561, 50.67069),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	
	{
		objName = 871712474,
		objYaw = 270.44827270508,
		objCoords = vector3(1762.779, 2590.629, 50.67069),
		textCoords = vector3(1762.771, 2591.622, 50.67069),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},
	
	{
		objName = 871712474,
		objYaw = 270.44827270508,
		objCoords = vector3(1762.766, 2587.677, 50.67069),
		textCoords = vector3(1762.759, 2588.671, 50.67069),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.0,
	},

	{
		textCoords = vector3(1781.78, 2552.04, 49.58),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 1028191914,
				objYaw = 90.227363586426,
				objCoords = vector3(1781.756, 2553.373, 49.75458)
			},

			{
				objName = 1028191914,
				objYaw = 269.37939453125,
				objCoords = vector3(1781.805, 2550.773, 49.75458),
			}
		}
	},

	{
		objName = -2051651622,
		objYaw = 175.36155700684,
		objCoords = vector3(438.9442, -629.0037, 28.78124),
		textCoords = vector3(440.0323, -629.092, 28.78125),
		authorizedJobs = { 'busdriver', 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	
	{
		objName = -2051651622,
		objYaw = 175.37232971191,
		objCoords = vector3(437.8836, -641.5185, 28.78795),
		textCoords = vector3(438.9717, -641.6066, 28.78796),
		authorizedJobs = { 'busdriver', 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	
	{
		objName = -131296141,
		objYaw = 265.04272460938,
		objCoords = vector3(443.4396, -660.1833, 29.39646),
		textCoords = vector3(443.5334, -659.1024, 29.39646),
		authorizedJobs = { 'busdriver', 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	
	{
		objName = -2051651622,
		objYaw = 354.59375,
		objCoords = vector3(442.6441, -600.1064, 28.7733),
		textCoords = vector3(441.5573, -600.0036, 28.7733),
		authorizedJobs = { 'busdriver', 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},
	
	{
		objName = -2051651622,
		objYaw = 264.79489135742,
		objCoords = vector3(449.0542, -602.5834, 28.7733),
		textCoords = vector3(449.1532, -601.4962, 28.7733),
		authorizedJobs = { 'busdriver', 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},

	-- FIB --

	{
		objName = 906126164,
		objYaw = 24.999971389771,
		objCoords = vector3(18.53987, -917.66, 30.06354),
		textCoords = vector3(17.55708, -918.1183, 30.06354),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},

	{
		objName = 906126164,
		objYaw = 24.999971389771,
		objCoords = vector3(24.18781, -915.0003, 30.06354),
		textCoords = vector3(23.20502, -915.4586, 30.06354),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},

	{
		objName = 906126164,
		objYaw = 205.0,
		objCoords = vector3(12.63817, -920.439, 30.06354),
		textCoords = vector3(13.62096, -919.9807, 30.06354),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.0,
	},	

	{
		objName = 1065280144,
		objYaw = 294.76251220703,
		objCoords = vector3(36.51368, -907.7147, 30.06354),
		textCoords = vector3(36.98, -908.54, 29.90),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = 1054027861,
		objYaw = 204.76057434082,
		objCoords = vector3(15.4656, -923.3293, 30.05311),
		textCoords = vector3(16.45061, -922.8749, 30.05311),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = 1054027861,
		objYaw = 205.0,
		objCoords = vector3(16.59064, -925.7419, 30.05102),
		textCoords = vector3(17.57374, -925.2834, 30.05102),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = 1054027861,
		objYaw = 204.79469299316,
		objCoords = vector3(18.98099, -930.8681, 30.05086),
		textCoords = vector3(19.96572, -930.4132, 30.05087),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = 1054027861,
		objYaw = 204.82159423828,
		objCoords = vector3(20.08891, -933.2441, 30.05112),
		textCoords = vector3(21.07343, -932.7888, 30.05112),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		textCoords = vector3(15.55, -934.92, 29.90),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 906126164,
				objYaw = 204.85847473145,
				objCoords = vector3(14.28485, -935.3792, 30.062),
			},

			{
				objName = 906126164,
				objYaw = 25.023338317871,
				objCoords = vector3(16.63872, -934.2819, 30.062),
			}
		}
	},

	{
		textCoords = vector3(11.25, -925.73, 29.90),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 906126164,
				objYaw = 205.07247924805,
				objCoords = vector3(10.13, -926.4529, 30.062),
			},

			{
				objName = 906126164,
				objYaw = 25.140375137329,
				objCoords = vector3(12.48223, -925.356, 30.062),
			}
		}
	},

	{
		textCoords = vector3(27.95, -908.86, 29.90),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 906126164,
				objYaw = 25.177934646606,
				objCoords = vector3(29.04273, -908.1453, 30.06347),
			},

			{
				objName = 906126164,
				objYaw = 204.5007019043,
				objCoords = vector3(26.68238, -909.246, 30.06347),
			}
		}
	},

	{
		objName = 362516170,
		objYaw = 24.999971389771,
		objCoords = vector3(35.2908, -923.8991, 30.05293),
		textCoords = vector3(34.29509, -924.3634, 30.05293),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = 362516170,
		objYaw = 204.99993896484,
		objCoords = vector3(30.60168, -926.1356, 30.05293),
		textCoords = vector3(31.59739, -925.6713, 30.05293),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = 362516170,
		objYaw = 204.99993896484,
		objCoords = vector3(28.8849, -922.7091, 30.05293),
		textCoords = vector3(29.88061, -922.2448, 30.05293),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = 362516170,
		objYaw = 24.999971389771,
		objCoords = vector3(33.74396, -920.5818, 30.05293),
		textCoords = vector3(32.74825, -921.0461, 30.05293),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = 362516170,
		objYaw = 295.17422485352,
		objCoords = vector3(29.5794, -924.998, 30.05293),
		textCoords = vector3(29.11207, -924.0038, 30.05292),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	{
		objName = 906126164,
		objYaw = 205.0,
		objCoords = vector3(12.63817, -920.439, 34.06482),
		textCoords = vector3(13.62096, -919.9807, 34.06482),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = 906126164,
		objYaw = 205.0,
		objCoords = vector3(17.2431, -918.2791, 34.06482),
		textCoords = vector3(18.22589, -917.8208, 34.06482),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = 906126164,
		objYaw = 114.99996948242,
		objCoords = vector3(20.56999, -917.9918, 34.06471),
		textCoords = vector3(21.02827, -918.9746, 34.06471),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = 1054027861,
		objYaw = 205.27491760254,
		objCoords = vector3(14.09566, -923.9555, 34.05298),
		textCoords = vector3(15.07655, -923.4924, 34.05298),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = 1054027861,
		objYaw = 294.99996948242,
		objCoords = vector3(22.83896, -928.7393, 34.05151),
		textCoords = vector3(22.38053, -927.7562, 34.05151),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = 1054027861,
		objYaw = 205.0,
		objCoords = vector3(18.42486, -933.0167, 34.05151),
		textCoords = vector3(19.40796, -932.5582, 34.05151),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = 1054027861,
		objYaw = 205.0,
		objCoords = vector3(11.45682, -936.266, 34.05151),
		textCoords = vector3(12.43993, -935.8076, 34.05151),
		authorizedJobs = { 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},

	-- court

	{
		objName = -2023754432,
		objYaw = 229.83039855957,
		objCoords = vector3(326.3828, -1622.954, 85.74091),
		textCoords = vector3(325.77, -1623.68, 85.74086),
		authorizedJobs = { 'lawyer', 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = -2023754432,
		objYaw = 49.999984741211,
		objCoords = vector3(330.5425, -1617.997, 85.74091),
		textCoords = vector3(331.15, -1617.28, 85.74091),
		authorizedJobs = { 'lawyer', 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = -109356459,
		objYaw = 139.99998474121,
		objCoords = vector3(337.0434, -1635.892, 84.57885),
		textCoords = vector3(337.4794, -1636.258, 84.57885),
		authorizedJobs = { 'lawyer', 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = -607530290,
		objYaw = 230.0,
		objCoords = vector3(329.3083, -1646.511, 85.73518),
		textCoords = vector3(330.0047, -1645.681, 85.73518),
		authorizedJobs = { 'lawyer', 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = -607530290,
		objYaw = 49.999984741211,
		objCoords = vector3(327.9925, -1648.079, 85.73518),
		textCoords = vector3(327.2961, -1648.909, 85.73518),
		authorizedJobs = { 'lawyer', 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	
	{
		objName = -2023754432,
		objYaw = 230.0,
		objCoords = vector3(326.4348, -1643.292, 85.73518),
		textCoords = vector3(325.82, -1644.03, 85.73518),
		authorizedJobs = { 'lawyer', 'police', 'fib', 'statepolice' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	{
		objName = -1591004109,
		objYaw = 206.61888122559,
		objCoords = vector3(-1207.328, -335.1289, 38.07925),
		textCoords = vector3(-1208.125, -335.526, 38.07925),
		authorizedJobs = { 'police','fib' },
		locking = false,
		locked = true,
		pickable = true,
		distance = 2.0,
	},
	{
		objName = -1300743830,
		objYaw = 124.13794708252,
		objCoords = vector3(-1179.221, -891.5005, 14.094),
		textCoords = vector3(-1178.682, -892.2959, 14.09396),
		authorizedJobs = { 'burgershot' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	{
		objName = -1300743830,
		objYaw = 303.77676391602,
		objCoords = vector3(-1199.357, -903.8741, 14.07984),
		textCoords = vector3(-1199.891, -903.0753, 14.07984),
		authorizedJobs = { 'burgershot' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	{
		objName = -1448591934,
		objYaw = 34.000019073486,
		objCoords = vector3(-1201.111, -892.9651, 14.24448),
		textCoords = vector3(-1200.149, -892.6647, 14.24448),
		authorizedJobs = { 'burgershot' },
		locking = false,
		locked = true,
		pickable = false,
		distance = 1.5,
	},
	{
		textCoords = vector3(-1197.503, -884.7878, 14.24046),
		authorizedJobs = { 'burgershot' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = 1934064671,
				objYaw = 213.99996948242,
				objCoords = vector3(-1196.543, -883.4891, 14.24046),
			},

			{
				objName = -186646702,
				objYaw = 213.99996948242,
				objCoords = vector3(-1199.029, -885.1664, 14.24046),
			}
		}
	},
	{
		textCoords = vector3(-1184.52, -884.4, 14.24046),
		authorizedJobs = { 'burgershot' },
		locking = false,
		locked = false,
		pickable = false,
		distance = 2.5,
		doors = {
			{
				objName = -186646702,
				objYaw = 123.99998474121,
				objCoords = vector3(-1184.902, -883.2943, 14.24046),
			},

			{
				objName = 1934064671,
				objYaw = 123.99998474121,
				objCoords = vector3(-1183.221, -885.7863, 14.24046),
			}
		}
	},
}

