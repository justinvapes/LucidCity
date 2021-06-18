Config = {}

local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

Config.RandomStr = function(length)
	if length > 0 then
		return Config.RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

Config.RandomInt = function(length)
	if length > 0 then
		return Config.RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

Config.Objects = {
    ["cone"] = {model = `prop_roadcone02a`, freeze = false},
    ["barier"] = {model = `prop_barrier_work06a`, freeze = true},
    ["snowsign"] = {model = `prop_snow_sign_road_06g`, freeze = true},
    ["tent"] = {model = `prop_gazebo_03`, freeze = true},
    ["light"] = {model = `prop_worklight_03b`, freeze = true},
    ["spikestrip"] = {model = `P_ld_stinger_s`, freeze = true},
}

Config.Locations = {
   ["duty"] = {
       [1] = {x = 460.2222, y = -999.0289, z = 30.689, h = 90.654},
       [2] = {x = -449.811, y = 6012.909, z = 31.815, h = 90.654},
       [3] = {x = 1851.021, y = 3690.669, z = 34.267, h = 90.654},
   },    
   ["vehicle"] = {
       [1] = {x = 452.1538, y = -986.3939, z = 25.69981, h = 90.654},
       [2] = {x = 431.4477, y = -985.9798, z = 25.69981, h = 274.5},
       [3] = {x = 1869.035, y = 3695.502, z = 33.57391, h = 212.47},
   },
   ["outfits"] = {
        [1] = {x = 463.2715, y = -996.5043, z = 30.689, h = 90.654},
        [2] = {x = 1850.21, y = 3695.177, z = 34.267, h = 301.76},
   },     
   ["stash"] = {
       [1] = {x = 453.075, y = -980.124, z = 30.889, h = 90.654},
       [2] = {x = -434.63, y = 6001.63, z = 31.71, h = 316.5, r = 1.0},
   },     
   ["helicopter"] = {
       [1] = {x = 449.168, y = -981.325, z = 43.691, h = 87.234},
       [2] = {x = -475.43, y = 5988.353, z = 31.716, h = 31.34},
   }, 
   ["armory"] = {
       [1] = {x = 485.4757, y = -995.4771, z = 30.68965, h = 90.654},
       [2] = {x = -436.82, y = 5996.98, z = 31.716, h = 90.654},
       [3] = {x = 1842.267, y = 3690.758, z = 34.26, h = 90.654},
   },         
   ["fingerprint"] = {
       [1] = {x = 483.9258, y = -987.8893, z = 30.68962, h = 358.5},
   },
   ["chiefactions"] = {
        [1] = {x = 463.1996, y = -985.2174, z = 30.72808, h = 358.5},
        [2] = {x = 1861.756, y = 3688.669, z = 34.267, h = 202.77},
   },
   ["evidence"] = {
       [1] = {x = 474.5908, y = -996.8489, z = 26.27328, h = 358.5},
       --[2] = {x = -439.09, y = 6003.12, z = 31.84, h = 90.654},
   },    
   ["evidence2"] = {
       [1] = {x = 472.5944, y = -993.6813, z = 26.27328, h = 358.5},
       --[2] = {x = -439.54, y = 6011.42, z = 27.98, h = 44.5, r = 1.0},
   },   
   ["evidence3"] = {
       [1] = {x = 1855.19, y = 3698.991, z = 34.267, h = 27.73},
       --[2] = {x = -439.43, y = 6009.45, z = 27.98, h = 134.5, r = 1.0},
   },        
   ["stations"] = {
       [1] = {label = "Police Station", sprite = 60, color = 29, coords = {x = 428.23, y = -984.28, z = 29.76, h = 3.5}},
       [2] = {label = "Paleto Police Station", sprite = 60, color = 29, coords = {x = -451.55, y = 6014.25, z = 31.716, h = 223.81}},
       [3] = {label = "Sandy Police Station", sprite = 60, color = 29, coords = {x = 1857.71, y = 3688.117, z = 34.26704, h = 303.45}},
       [4] = {label = "FIB", sprite = 472, color = 77, coords = {x = 22.73, y = -925.83, z = 29.90, h = 112.97}},
       [5] = {label = "State Police Station", sprite = 60, color = 47, coords = {x = 1546.99, y = 820.63, z = 77.65, h = 62.55}},
   },
   ["evidenceLabs"] = {
        [1] = {x = 487.36, y = -993.26, z = 30.68, h = 230.27},
   },
}

Config.StatePDLocations = {
    ["fingerprint"] = {
        [1] = {x = 1541.08, y = 824.79, z = 77.65, h = 328.44},
    },
    ["directoractions"] = {
        [1] = {x = 1540.41, y = 814.15, z = 82.13, h = 137.692},
    },
    ["evidence"] = {
        [1] = {x = 1548.78, y = 826.74, z = 82.13, h = 135.68},
    },  
    ["evidence2"] = {
        [1] = {x = 1546.207, y = 829.82, z = 82.13, h = 135.68},
    },   
    ["stash"] = {
        [1] = {x = 1544.70, y = 833.61, z = 77.65, h = 315.488},
    }, 
    ["armory"] = {
        [1] = {x = 1550.55, y = 841.84, z = 77.65, h = 331.43},
    }, 
    ["duty"] = {
        [1] = {x = 1549.26, y = 837.26, z = 77.65, h = 332.08},
    }, 
    ["garage"] = {
        [1] = {x = 1545.71, y = 794.32, z = 77.14, h = 57.80},
    },
    ["outfits"] = {
        [1] = {x = 1539.75, y = 810.84, z = 77.65, h = 22.0},
    }, 
}

Config.ArmoryWhitelist = {
    "TSN95869",
}

Config.Helicopter = "frogger"

Config.SecurityCameras = {
    hideradar = false,
    cameras = {
         [1] = {label = "Pacific Bank CAM#1", x = 257.45, y = 210.07, z = 109.08, r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = false, isOnline = true},
        [2] = {label = "Pacific Bank CAM#2", x = 232.86, y = 221.46, z = 107.83, r = {x = -25.0, y = 0.0, z = -140.91}, canRotate = false, isOnline = true},
        [3] = {label = "Pacific Bank CAM#3", x = 252.27, y = 225.52, z = 103.99, r = {x = -35.0, y = 0.0, z = -74.87}, canRotate = false, isOnline = true},
        [4] = {label = "Limited Ltd Grove St. CAM#1", x = -53.1433, y = -1746.714, z = 31.546, r = {x = -35.0, y = 0.0, z = -168.9182}, canRotate = false, isOnline = true},
        [5] = {label = "Rob's Liqour Prosperity St. CAM#1", x = -1482.9, y = -380.463, z = 42.363, r = {x = -35.0, y = 0.0, z = 79.53281}, canRotate = false, isOnline = true},
        [6] = {label = "Rob's Liqour San Andreas Ave. CAM#1", x = -1224.874, y = -911.094, z = 14.401, r = {x = -35.0, y = 0.0, z = -6.778894}, canRotate = false, isOnline = true},
        [7] = {label = "Limited Ltd Ginger St. CAM#1", x = -718.153, y = -909.211, z = 21.49, r = {x = -35.0, y = 0.0, z = -137.1431}, canRotate = false, isOnline = true},
        [8] = {label = "24/7 Supermarkt Innocence Blvd. CAM#1", x = 23.885, y = -1342.441, z = 31.672, r = {x = -35.0, y = 0.0, z = -142.9191}, canRotate = false, isOnline = true},
        [9] = {label = "Rob's Liqour El Rancho Blvd. CAM#1", x = 1133.024, y = -978.712, z = 48.515, r = {x = -35.0, y = 0.0, z = -137.302}, canRotate = false, isOnline = true},
        [10] = {label = "Limited Ltd West Mirror Drive CAM#1", x = 1151.93, y = -320.389, z = 71.33, r = {x = -35.0, y = 0.0, z = -119.4468}, canRotate = false, isOnline = true},
        [11] = {label = "24/7 Supermarkt Clinton Ave CAM#1", x = 383.402, y = 328.915, z = 105.541, r = {x = -35.0, y = 0.0, z = 118.585}, canRotate = false, isOnline = true},
        [12] = {label = "Limited Ltd Banham Canyon Dr CAM#1", x = -1832.057, y = 789.389, z = 140.436, r = {x = -35.0, y = 0.0, z = -91.481}, canRotate = false, isOnline = true},
        [13] = {label = "Rob's Liqour Great Ocean Hwy CAM#1", x = -2966.15, y = 387.067, z = 17.393, r = {x = -35.0, y = 0.0, z = 32.92229}, canRotate = false, isOnline = true},
        [14] = {label = "24/7 Supermarkt Ineseno Road CAM#1", x = -3046.749, y = 592.491, z = 9.808, r = {x = -35.0, y = 0.0, z = -116.673}, canRotate = false, isOnline = true},
        [15] = {label = "24/7 Supermarkt Barbareno Rd. CAM#1", x = -3246.489, y = 1010.408, z = 14.705, r = {x = -35.0, y = 0.0, z = -135.2151}, canRotate = false, isOnline = true},
        [16] = {label = "24/7 Supermarkt Route 68 CAM#1", x = 539.773, y = 2664.904, z = 44.056, r = {x = -35.0, y = 0.0, z = -42.947}, canRotate = false, isOnline = true},
        [17] = {label = "Rob's Liqour Route 68 CAM#1", x = 1169.855, y = 2711.493, z = 40.432, r = {x = -35.0, y = 0.0, z = 127.17}, canRotate = false, isOnline = true},
        [18] = {label = "24/7 Supermarkt Senora Fwy CAM#1", x = 2673.579, y = 3281.265, z = 57.541, r = {x = -35.0, y = 0.0, z = -80.242}, canRotate = false, isOnline = true},
        [19] = {label = "24/7 Supermarkt Alhambra Dr. CAM#1", x = 1966.24, y = 3749.545, z = 34.143, r = {x = -35.0, y = 0.0, z = 163.065}, canRotate = false, isOnline = true},
        [20] = {label = "24/7 Supermarkt Senora Fwy CAM#2", x = 1729.522, y = 6419.87, z = 37.262, r = {x = -35.0, y = 0.0, z = -160.089}, canRotate = false, isOnline = true},
        [21] = {label = "Fleeca Bank Hawick Ave CAM#1", x = 309.341, y = -281.439, z = 55.88, r = {x = -35.0, y = 0.0, z = -146.1595}, canRotate = false, isOnline = true},
        [22] = {label = "Fleeca Bank Legion Square CAM#1", x = 144.871, y = -1043.044, z = 31.017, r = {x = -35.0, y = 0.0, z = -143.9796}, canRotate = false, isOnline = true},
        [23] = {label = "Fleeca Bank Hawick Ave CAM#2", x = -355.7643, y = -52.506, z = 50.746, r = {x = -35.0, y = 0.0, z = -143.8711}, canRotate = false, isOnline = true},
        [24] = {label = "Fleeca Bank Del Perro Blvd CAM#1", x = -1214.226, y = -335.86, z = 39.515, r = {x = -35.0, y = 0.0, z = -97.862}, canRotate = false, isOnline = true},
        [25] = {label = "Fleeca Bank Great Ocean Hwy CAM#1", x = -2958.885, y = 478.983, z = 17.406, r = {x = -35.0, y = 0.0, z = -34.69595}, canRotate = false, isOnline = true},
        [26] = {label = "Paleto Bank CAM#1", x = -102.939, y = 6467.668, z = 33.424, r = {x = -35.0, y = 0.0, z = 24.66}, canRotate = false, isOnline = true},
        [27] = {label = "Del Vecchio Liquor Paleto Bay", x = -163.75, y = 6323.45, z = 33.424, r = {x = -35.0, y = 0.0, z = 260.00}, canRotate = false, isOnline = true},
        [28] = {label = "Don's Country Store Paleto Bay CAM#1", x = 166.42, y = 6634.4, z = 33.69, r = {x = -35.0, y = 0.0, z = 32.00}, canRotate = false, isOnline = true},
        [29] = {label = "Don's Country Store Paleto Bay CAM#2", x = 163.74, y = 6644.34, z = 33.69, r = {x = -35.0, y = 0.0, z = 168.00}, canRotate = false, isOnline = true},
        [30] = {label = "Don's Country Store Paleto Bay CAM#3", x = 169.54, y = 6640.89, z = 33.69, r = {x = -35.0, y = 0.0, z = 5.78}, canRotate = false, isOnline = true},
        [31] = {label = "Vangelico Jeweler CAM#1", x = -627.54, y = -239.74, z = 40.33, r = {x = -35.0, y = 0.0, z = 5.78}, canRotate = true, isOnline = true},
        [32] = {label = "Vangelico Jeweler CAM#2", x = -627.51, y = -229.51, z = 40.24, r = {x = -35.0, y = 0.0, z = -95.78}, canRotate = true, isOnline = true},
        [33] = {label = "Vangelico Jeweler CAM#3", x = -620.3, y = -224.31, z = 40.23, r = {x = -35.0, y = 0.0, z = 165.78}, canRotate = true, isOnline = true},
        [34] = {label = "Vangelico Jeweler CAM#4", x = -622.57, y = -236.3, z = 40.31, r = {x = -35.0, y = 0.0, z = 5.78}, canRotate = true, isOnline = true},
    },
}

Config.Vehicles = {
    categories = {
        [1] = {
            label = "SUVs",
            vehicles = {
                ["durango"] = "Dodge Durango",
                ["tahoepd"] = "Chevrolet Tahoe",
                ["tahoe13"] = "Chevrolet Tahoe 2013",
                ["tahoe06"] = "Chevrolet Tahoe 2006",
                ["explorer"] = "Ford Explorer 2016",
                ["2020explorer"] = "Ford Explorer 2020",
                ["21tahoek9rb"] = "Tahoe 2021",
            },
        },
        [2] = {
            label = "Pickup Trucks",
            vehicles = {
                ["20chevy"] = "Chevrolet Silverado 2020",
                ["GMC"] = "Sierra GMC 2500HD",
            },
        },
        [3] = {
            label = "Sedans",
            vehicles = {
                ["caprice"] = "Chevrolet Caprice",
                ["impala"] = "Chevrolet Impala",
                ["charger"] = "Dodge Charger",
                ["2014charger"] = "Dodge Charger 2014",
                ["crownvic"] = "Ford Crown Victoria",
                ["taurus"] = "Ford Taurus",
            },
        },
        [4] = {
            label = "Speed Enforcement",
            vehicles = {
                ["challenger18"] = "Dodge challenger 2018",
                ["hellcat"] = "Dodge Hellcat",
                ["camaropd"] = "Camaro 2016",
                ["camaropd2019"] = "Camaro 2019",
                ["corleo"] = "Corvette",
                ["pdmustang19"] = "Ford Mustang 2019",
            },
        },
        [5] = {
            label = "Motorcycles",
            vehicles = {
                ["bmwbike"] = "BMW Bike",
            },
        },
    }
}

Config.StatePDVehicles = { 
    categories = {
        [1] = {
            label = "SUVs",
            vehicles = {
                ["explorerSASP"] = "Ford Explorer 2016",
                ["durangoSASP"] = "Dodge Durango",
                ["tahoe06SASP"] = "Chevrolet Tahoe 2006",
                ["tahoe13SASP"] = "Chevrolet Tahoe 2013",
                ["tahoeSASP"] = "Chevrolet Tahoe",
            },
        },
        [2] = {
            label = "Pickup Trucks",
            vehicles = {
                ["gmcSASP"] = "Sierra GMC 2500HD",
            },
        },
        [3] = {
            label = "Sedans",
            vehicles = {
                ["2014chargerSASP"] = "Charger 2014",
                ["2020explorerSASP"] = "Explorer 2020",
                ["2021tahoeSASP"] = "Chevrolet Tahoe 2021",
                ["camaropd2019SASP"] = "Camaro 2019",
                ["camaropdSASP"] = "Camaro",
                ["challenger18SASP"] = "Challenger 2018",
                ["chargerSASP"] = "Charger",
                ["corleoSASP"] = "Corleo",
                ["crownvicSASP"] = "Ford Crown Victoria",
                ["hellcatSASP"] = "Dodge Hellcat",
                ["pdmustang19SASP"] = "Ford Mustang 2019",
                ["taurusSASP"] = "Ford Taurus",
            },
        },
        [4] = {
            label = "Motorcycles",
            vehicles = {
                ["bmwbikeSASP"] = "BMW Bike",
            },
        },
    }
}

Config.FIBVehicles = { 
    categories = {
        [1] = {
            label = "SUVs",
            vehicles = {
                ["tahoe13fib"] = "FIB Tahoe 2013",
                ["tahoefib"]  = "FIB Tahoe",
            },
        },
        [2] = {
            label = "Sedans",
            vehicles = {
                ["chargerfib"] = "FIB Charger",
                ["taurusfib"] = "FIB Taurus",
            },
        },
    }
}

Config.WhitelistedVehicles = {
    --["pcharger"] = "Dodge Charger (UC)",
}

Config.AmmoLabels = {
    ["AMMO_PISTOL"] = "9x19mm Pistol bullet",
    ["AMMO_SMG"] = "9x19mm SMG bullet",
    ["AMMO_RIFLE"] = "7.62x39mm Rifle bullet",
    ["AMMO_MG"] = "7.92x57mm MG bullet",
    ["AMMO_SHOTGUN"] = "12-gauge bullet",
    ["AMMO_SNIPER"] = "Sniper caliber bullet",
}

Config.Radars = {
	{x = -623.44421386719, y = -823.08361816406, z = 25.25704574585, h = 145.0 },
	{x = -652.44421386719, y = -854.08361816406, z = 24.55704574585, h = 325.0 },
	{x = 1623.0114746094, y = 1068.9924316406, z = 80.903594970703, h = 84.0 },
	{x = -2604.8994140625, y = 2996.3391113281, z = 27.528566360474, h = 175.0 },
	{x = 2136.65234375, y = -591.81469726563, z = 94.272926330566, h = 318.0 },
	{x = 2117.5764160156, y = -558.51013183594, z = 95.683128356934, h = 158.0 },
	{x = 406.89505004883, y = -969.06286621094, z = 29.436267852783, h = 33.0 },
	{x = 657.315, y = -218.819, z = 44.06, h = 320.0 },
	{x = 2118.287, y = 6040.027, z = 50.928, h = 172.0 },
	{x = -106.304, y = -1127.5530, z = 30.778, h = 230.0 },
	{x = -823.3688, y = -1146.980, z = 8.0, h = 300.0 },
}

Config.CarItems = {
    [1] = {
        name = "heavyarmor",
        amount = 2,
        info = {},
        type = "item",
        slot = 1,
    },
    [2] = {
        name = "empty_evidence_bag",
        amount = 10,
        info = {},
        type = "item",
        slot = 2,
    },
    [3] = {
        name = "police_stormram",
        amount = 1,
        info = {},
        type = "item",
        slot = 3,
    },
}

Config.GuardItems = {
    label = "Prison Guard Armory",
    slots = 30,
    items = {
        [1] = {
            name = "weapon_pistol",
            price = 0,
            amount = 1,
            info = {
                serie = "",                
                attachments = {
                    {component = "COMPONENT_AT_PI_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 1,
        },
        [2] = {
            name = "weapon_stungun",
            price = 0,
            amount = 1,
            info = {
                serie = "",            
            },
            type = "weapon",
            slot = 2,
        },
        [3] = {
            name = "weapon_nightstick",
            price = 0,
            amount = 1,
            info = {},
            type = "weapon",
            slot = 3,
        },
        [4] = {
            name = "pistol_ammo",
            price = 0,
            amount = 10,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "handcuffs",
            price = 0,
            amount = 1,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "weapon_flashlight",
            price = 0,
            amount = 1,
            info = {},
            type = "weapon",
            slot = 6,
        },
        [7] = {
            name = "empty_evidence_bag",
            price = 0,
            amount = 350,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "radio",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 8,
        },
        [9] = {
            name = "heavyarmor",
            price = 0,
            amount = 300,
            info = {},
            type = "item",
            slot = 9,
        },
        [10] = {
            name = "bandage",
            price = 0,
            amount = 55000,
            info = {},
            type = "item",
            slot = 10,
        },
    },
}

Config.Items = {
    label = "Police Weapons Locker",
    slots = 30,
    items = {
        [1] = {
            name = "weapon_pistol",
            price = 0,
            amount = 1,
            info = {
                serie = "",                
                attachments = {
                    {component = "COMPONENT_AT_PI_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 1,
        },
        [2] = {
            name = "weapon_stungun",
            price = 0,
            amount = 1,
            info = {
                serie = "",            
            },
            type = "weapon",
            slot = 2,
        },
        [3] = {
            name = "weapon_pumpshotgun",
            price = 0,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 3,
        },
        [4] = {
            name = "weapon_smg",
            price = 0,
            amount = 1,
            info = {
                serie = "",                
                attachments = {
                    {component = "COMPONENT_AT_SCOPE_MACRO_02", label = "1x Scope"},
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 4,
        },
        [5] = {
            name = "weapon_carbinerifle",
            price = 0,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                    {component = "COMPONENT_AT_SCOPE_MEDIUM", label = "3x Scope"},
                    {component = "COMPONENT_AT_AR_AFGRIP", label = "Grip"},
                }
            },
            type = "weapon",
            slot = 5,
        },
        [6] = {
            name = "weapon_nightstick",
            price = 0,
            amount = 1,
            info = {},
            type = "weapon",
            slot = 6,
        },
        [7] = {
            name = "pistol_ammo",
            price = 0,
            amount = 10,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "smg_ammo",
            price = 0,
            amount = 10,
            info = {},
            type = "item",
            slot = 8,
        },
        [9] = {
            name = "shotgun_ammo",
            price = 0,
            amount = 10,
            info = {},
            type = "item",
            slot = 9,
        },
        [10] = {
            name = "rifle_ammo",
            price = 0,
            amount = 10,
            info = {},
            type = "item",
            slot = 10,
        },
        [11] = {
            name = "handcuffs",
            price = 0,
            amount = 1,
            info = {},
            type = "item",
            slot = 11,
        },
        [12] = {
            name = "weapon_flashlight",
            price = 0,
            amount = 1,
            info = {},
            type = "weapon",
            slot = 12,
        },
        [13] = {
            name = "empty_evidence_bag",
            price = 0,
            amount = 350,
            info = {},
            type = "item",
            slot = 13,
        },
        [14] = {
            name = "police_stormram",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 14,
        },
        [15] = {
            name = "armor",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 15,
        },
        [16] = {
            name = "radio",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 16,
        },
        [17] = {
            name = "heavyarmor",
            price = 0,
            amount = 300,
            info = {},
            type = "item",
            slot = 17,
        },
        [18] = {
            name = "bandage",
            price = 0,
            amount = 55000,
            info = {},
            type = "item",
            slot = 18,
        },
        [19] = {
            name = "diving_gear",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 19,
        },
        [20] = {
            name = "parachute",
            price = 0,
            amount = 5,
            info = {},
            type = "item",
            slot = 20,
        },
        [21] = {
            name = "badge",
            price = 0,
            amount = 1,
            info = {},
            type = "item",
            slot = 21,
        },
    }
}

Config.StatePDItems = {
    label = "State Police Armory",
    slots = 30,
    items = {
        [1] = {
            name = "weapon_pistol",
            price = 0,
            amount = 1,
            info = {
                serie = "",                
                attachments = {
                    {component = "COMPONENT_AT_PI_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 1,
        },
        [2] = {
            name = "weapon_stungun",
            price = 0,
            amount = 1,
            info = {
                serie = "",            
            },
            type = "weapon",
            slot = 2,
        },
        [3] = {
            name = "weapon_pumpshotgun",
            price = 0,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 3,
        },
        [4] = {
            name = "weapon_smg",
            price = 0,
            amount = 1,
            info = {
                serie = "",                
                attachments = {
                    {component = "COMPONENT_AT_SCOPE_MACRO_02", label = "1x Scope"},
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 4,
        },
        [5] = {
            name = "weapon_carbinerifle",
            price = 0,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                    {component = "COMPONENT_AT_SCOPE_MEDIUM", label = "3x Scope"},
                    {component = "COMPONENT_AT_AR_AFGRIP", label = "Grip"},
                }
            },
            type = "weapon",
            slot = 5,
        },
        [6] = {
            name = "weapon_nightstick",
            price = 0,
            amount = 1,
            info = {},
            type = "weapon",
            slot = 6,
        },
        [7] = {
            name = "pistol_ammo",
            price = 0,
            amount = 10,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "smg_ammo",
            price = 0,
            amount = 10,
            info = {},
            type = "item",
            slot = 8,
        },
        [9] = {
            name = "shotgun_ammo",
            price = 0,
            amount = 10,
            info = {},
            type = "item",
            slot = 9,
        },
        [10] = {
            name = "rifle_ammo",
            price = 0,
            amount = 10,
            info = {},
            type = "item",
            slot = 10,
        },
        [11] = {
            name = "handcuffs",
            price = 0,
            amount = 1,
            info = {},
            type = "item",
            slot = 11,
        },
        [12] = {
            name = "weapon_flashlight",
            price = 0,
            amount = 1,
            info = {},
            type = "weapon",
            slot = 12,
        },
        [13] = {
            name = "empty_evidence_bag",
            price = 0,
            amount = 350,
            info = {},
            type = "item",
            slot = 13,
        },
        [14] = {
            name = "police_stormram",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 14,
        },
        [15] = {
            name = "armor",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 15,
        },
        [16] = {
            name = "radio",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 16,
        },
        [17] = {
            name = "heavyarmor",
            price = 0,
            amount = 300,
            info = {},
            type = "item",
            slot = 17,
        },
        [18] = {
            name = "bandage",
            price = 0,
            amount = 55000,
            info = {},
            type = "item",
            slot = 18,
        },
        [19] = {
            name = "diving_gear",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 19,
        },
        [20] = {
            name = "parachute",
            price = 0,
            amount = 5,
            info = {},
            type = "item",
            slot = 20,
        },
        [21] = {
            name = "badge",
            price = 0,
            amount = 1,
            info = {},
            type = "item",
            slot = 21,
        },
    }
}

Config.FIBItems = {
    label = "FIB Weapons Locker",
    slots = 30,
    items = {
        [1] = {
            name = "weapon_pistol_mk2",
            price = 0,
            amount = 1,
            info = {
                serie = "",    
                attachments = {
                    {component = "COMPONENT_AT_PI_COMP", label = "Compensator"},
                    {component = "COMPONENT_AT_PI_FLSH_02", label = "Flashlight"},
                    {component = "COMPONENT_AT_PI_RAIL", label = "Scope"},
                    {component = "COMPONENT_PISTOL_MK2_CAMO_02", label = "Digital Camo"},
                }            
            },
            type = "weapon",
            slot = 1,
        },
        [2] = {
            name = "weapon_stungun",
            price = 0,
            amount = 1,
            info = {
                serie = "",            
            },
            type = "weapon",
            slot = 2,
        },
        [3] = {
            name = "weapon_carbinerifle_mk2",
            price = 0,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    {component = "COMPONENT_AT_AR_AFGRIP_02", label = "Grip"},
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                    {component = "COMPONENT_AT_MUZZLE_02", label = "Tactical Muzzle Brake"},
                    {component = "COMPONENT_AT_SCOPE_MACRO_MK2", label = "Small scope"},
                    {component = "COMPONENT_CARBINERIFLE_MK2_CLIP_02", label = "Extended Clip"},
                    {component = "COMPONENT_CARBINERIFLE_MK2_CAMO_02", label = "Digital Camo"},
                }
            },
            type = "weapon",
            slot = 3,
        },
        [4] = {
            name = "weapon_pumpshotgun_mk2",
            price = 0,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                    {component = "COMPONENT_AT_SIGHTS", label = "Scope"},
                    {component = "COMPONENT_PUMPSHOTGUN_MK2_CAMO_02", label = "Camo"},
                }
            },
            type = "weapon",
            slot = 4,
        },
        [5] = {
            name = "shotgun_ammo",
            price = 0,
            amount = 20,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "pistol_ammo",
            price = 0,
            amount = 20,
            info = {},
            type = "item",
            slot = 6,
        },
        [7] = {
            name = "rifle_ammo",
            price = 0,
            amount = 20,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "handcuffs",
            price = 0,
            amount = 1,
            info = {},
            type = "item",
            slot = 8,
        },
        [9] = {
            name = "weapon_flashlight",
            price = 0,
            amount = 1,
            info = {},
            type = "weapon",
            slot = 9,
        },
        [10] = {
            name = "empty_evidence_bag",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 10,
        },
        [11] = {
            name = "police_stormram",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 11,
        },
        [12] = {
            name = "radio",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 12,
        },
        [13] = {
            name = "heavyarmor",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 13,
        },
        [14] = {
            name = "badge",
            price = 0,
            amount = 1,
            info = {},
            type = "item",
            slot = 14,
        },
    }
}