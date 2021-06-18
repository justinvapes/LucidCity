Config = Config or {}
QBWeed = {}
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

QBWeed.HarvestTime = 40 * 1000

QBWeed.Plants = {
    ["og-kush"] = {
        ["label"] = "OG Kush",
        ["item"] = "ogkush",
        ["stages"] = {
            ["stage-a"] = "bkr_prop_weed_01_small_01c",
            ["stage-b"] = "bkr_prop_weed_lrg_01a",
            ["stage-c"] = "bkr_prop_weed_lrg_01b",
        },
        ["highestStage"] = "stage-c"
    },
    ["amnesia"] = {
        ["label"] = "Amnesia",
        ["item"] = "amnesia",
        ["stages"] = {
            ["stage-a"] = "bkr_prop_weed_01_small_01a",
            ["stage-b"] = "bkr_prop_weed_lrg_01a",
            ["stage-c"] = "bkr_prop_weed_lrg_01b",
        },
        ["highestStage"] = "stage-c"
    },
    ["skunk"] = {
        ["label"] = "Skunk",
        ["item"] = "skunk",
        ["stages"] = {
            ["stage-a"] = "bkr_prop_weed_01_small_01a",
            ["stage-b"] = "bkr_prop_weed_lrg_01a",
            ["stage-c"] = "bkr_prop_weed_lrg_01b",
            ["stage-d"] = "bkr_prop_weed_lrg_01b",
        },
        ["highestStage"] = "stage-d"
    },
    ["ak47"] = {
        ["label"] = "AK 47",
        ["item"] = "ak47",
        ["stages"] = {
            ["stage-a"] = "bkr_prop_weed_01_small_01c",
            ["stage-b"] = "bkr_prop_weed_01_small_01b",
            ["stage-c"] = "bkr_prop_weed_01_small_01a",
            ["stage-d"] = "bkr_prop_weed_med_01b",
            ["stage-e"] = "bkr_prop_weed_lrg_01b",
        },
        ["highestStage"] = "stage-e"
    },
    ["purple-haze"] = {
        ["label"] = "Purple Haze",
        ["item"] = "purplehaze",
        ["stages"] = {
            ["stage-a"] = "bkr_prop_weed_01_small_01c",
            ["stage-b"] = "bkr_prop_weed_01_small_01b",
            ["stage-c"] = "bkr_prop_weed_01_small_01a",
            ["stage-d"] = "bkr_prop_weed_med_01b",
            ["stage-e"] = "bkr_prop_weed_lrg_01a",
        },
        ["highestStage"] = "stage-e"
    },
    ["white-widow"] = {
        ["label"] = "White Widow",
        ["item"] = "whitewidow",
        ["stages"] = {
            ["stage-a"] = "bkr_prop_weed_01_small_01c",
            ["stage-b"] = "bkr_prop_weed_01_small_01b",
            ["stage-c"] = "bkr_prop_weed_01_small_01a",
            ["stage-d"] = "bkr_prop_weed_med_01b",
            ["stage-e"] = "bkr_prop_weed_lrg_01a",
        },
        ["highestStage"] = "stage-e"
    },
}

Config.policeMessage = {
    "Suspicious person",
    "Possible drug sale",
}

QBWeed.Props = {
    ["stage-a"] = "bkr_prop_weed_01_small_01c",
    ["stage-b"] = "bkr_prop_weed_01_small_01b",
    ["stage-c"] = "bkr_prop_weed_01_small_01a",
    ["stage-d"] = "bkr_prop_weed_med_01b",
    ["stage-e"] = "bkr_prop_weed_lrg_01a",
    ["stage-f"] = "bkr_prop_weed_lrg_01b",
    ["stage-g"] = "bkr_prop_weed_lrg_01b",
}

Config.CornerSellingDrugsList = {
    "weed_white-widow",
    "weed_skunk",
    "weed_purple-haze",
    "weed_og-kush",
    "weed_amnesia",
    "weed_ak47",
    "cokebaggy",
    "crack_baggy",
    "meth_baggy",
    "xtcbaggy",
    "lsd",
    "heroin",
}

-- NEEDS ECONOMY CHANGES
Config.DrugsPrice = {
    ["weed_white-widow"] = {
        min = 30,
        max = 40,
    },
    ["weed_og-kush"] = {
        min = 40,
        max = 80,
    },
    ["weed_skunk"] = {
        min = 30,
        max = 45,
    },
    ["weed_amnesia"] = {
        min = 50,
        max = 60,
    },
    ["weed_purple-haze"] = {
        min = 60,
        max = 70,
    },
    ["weed_ak47"] = {
        min = 65,
        max = 80,
    },
    ["cokebaggy"] = {
        min = 450,
        max = 550,
    },
    ["crack_baggy"] = {
        min = 202,
        max = 210,
    },
    ["meth_baggy"] = {
        min = 350,
        max = 450,
    },
    ["lsd"] = {
        min = 170,
        max = 185,
    },
    ["heroin"] = {
        min = 700,
        max = 750,
    },
    ["xtcbaggy"] = {
        min = 320,
        max = 350,
    },
}

-- NEEDS ECONOMY CHANGES (DELIVERY DEPOSIT GETS BACK)
Config.DeliveryPrice = 3000 -- Delivery price for deposit (Player gets cash back when delivery is finished)
Config.DeliveryTimeout = 600000 -- (CURRENT 10MINS, 600 SECONDS) Timeout till you can do another drug delivery. (In miliseconds)

Config.DeliveryLocations = {
    [1] = {
        ["label"] = "Stripclub",
        ["coords"] = vector3(106.24, -1280.32, 29.24)
    },
    [2] = {
        ["label"] = "Vinewood Video",
        ["coords"] = vector3(223.98, 121.53, 102.76)
    },
    [3] = {
        ["label"] = "Resort",
        ["coords"] = vector3(-1245.63, 376.21, 75.34)
    },
    [4] = {
        ["label"] = "Bahama Mamas",
        ["coords"] = vector3(-1383.1, -639.99, 28.67)
    },
}

Config.DeliveryItems = {
    [1] = {
        ["item"] = "weed_brick",
        ["minrep"] = 0,
    },
}

--[[ COKE CONFIG ]]--

-- TIME FOR TASKBAR --
Config.CocaLeafTime = math.random(4000, 6000)

-- ANIMATIONS --
Config.CocaLeafDict = "amb@prop_human_bbq@male@idle_b"
Config.CocaLeafAnim = "idle_d"
Config.CrackCocaineDict = "anim@amb@business@coc@coc_unpack_cut_left@"
Config.CrackCocaineAnim = "coke_cut_v5_coccutter"
Config.CocaPasteDict = "anim@amb@business@coc@coc_unpack_cut_left@"
Config.CocaPasteAnim = "coke_cut_v5_coccutter"

-- Weed Farm

Config.WeedPickupAmount = 1

-- TIME
Config.PickWeedTime = math.random(4000, 6000)
Config.ProcessWeedTime = 4000

-- Animations
Config.PickWeedDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@"
Config.PickWeedAnim = "weed_spraybottle_crouch_spraying_02_inspector"
Config.ProcessWeedDict = "amb@medic@standing@timeofdeath@enter"
Config.ProcessWeedAnim = "enter"

Config.WeedFarmLocation = vector3(2215.183, 5575.268, 53.69429)

-- LOCATIONS --
Config.WeedFarm = {
    Locations = {
        Processing = {
            vector3(2196.166, 5594.621, 53.77545),
            vector3(2196.503, 5596.517, 53.78388)
        }
    }
}

-- WeedFarm Plant locations
Config.SpawnLocations = 
{
    [1] = {x = 2215.183, y = 5575.268, z = 53.69429, h = 264.52},
    [2] = {x = 2215.787, y = 5577.601, z = 53.83409, h = 264.52},
    [3] = {x = 2218.063, y = 5577.368, z = 53.83409, h = 264.52},
    [4] = {x = 2217.87, y = 5575.187, z = 53.83409, h = 264.52},
    [5] = {x = 2218.548, y = 5579.55, z = 53.83409, h = 264.52},
    [6] = {x = 2220.159, y = 5577.161, z = 53.84409, h = 264.52},
    [7] = {x = 2220.54, y = 5575.017, z = 53.84409, h = 264.52},
    [8] = {x = 2223.746, y = 5578.863, z = 53.84409, h = 358.01},
    [9] = {x = 2227.229, y = 5576.723, z = 53.84409, h = 264.52},
    [10] = {x = 2229.678, y = 5576.626, z = 53.94123, h = 264.52},
    [11] = {x = 2233.101, y = 5576.397, z = 53.94123, h = 83.12},
    [12] = {x = 2234.312, y = 5578.533, z = 53.94123, h = 83.46},
}

--[[ Meth CONFIG ]]--
-- TIME
Config.MethLiquidTime = 6000
Config.MethTime = 7000
Config.MethBagsTime = 4000

-- Animations
Config.MethLiquidDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@"
Config.MethLiquidAnim = "weed_spraybottle_crouch_spraying_02_inspector"
Config.MethDict = "amb@prop_human_parking_meter@male@idle_a"
Config.MethAnim = "idle_a"
Config.MethBagsDict = "amb@world_human_gardener_plant@male@idle_a"
Config.MethBagsAnim = "idle_b"

--[[ LSD CONFIG ]]--
Config.LSDProcessAmount = 1

Config.LSD = {
    Messages = {
        [1] = {
            taskBar = "Mixing LSA with ethyl alcohol",
            taskBarTime = 8000,
            animDict = "amb@prop_human_movie_studio_light@idle_a",
            anim = "idle_b",
        },
        [2] = {
            taskBar = "Adding hydrogen peroxide",
            taskBarTime = 6000,
            animDict = "amb@prop_human_movie_studio_light@idle_a",
            anim = "idle_b",
        },
        [3] = {
            taskBar = "Adding ammonia and finishing up",
            taskBarTime = 9000,
            animDict = "amb@prop_human_bbq@male@idle_a",
            anim = "idle_b",
        },
    }
}

--[[ Heroin CONFIG ]]--
Config.HeroinProcessAmount = 1

Config.Heroin = {
    Messages = {
        [1] = {
            taskBar = "Adding acetic anhydride to morphine",
            taskBarTime = 2500,
            animDict = "amb@prop_human_movie_studio_light@idle_a",
            anim = "idle_b",
        },
        [2] = {
            taskBar = "Boiling the mixture",
            taskBarTime = 9500,
            animDict = "amb@prop_human_movie_studio_light@idle_a",
            anim = "idle_b",
        },
        [3] = {
            taskBar = "Adding water and draining mixture",
            taskBarTime = 6000,
            animDict = "amb@prop_human_bbq@male@idle_a",
            anim = "idle_b",
        },
        [4] = {
            taskBar = "Adding sodium carbonate",
            taskBarTime = 5500,
            animDict = "amb@prop_human_bbq@male@idle_a",
            anim = "idle_b",
        },
        [5] = {
            taskBar = "Filtering heroin",
            taskBarTime = 7000,
            animDict = "amb@prop_human_bbq@male@idle_a",
            anim = "idle_b",
        },
        [6] = {
            taskBar = "Adding Hydrochloric acid",
            taskBarTime = 5500,
            animDict = "amb@prop_human_bbq@male@idle_a",
            anim = "idle_b",
        },
    }
}

--[[ Ecstasy CONFIG ]]--
Config.EcstasyProcessAmount = 1

Config.Ecstasy = {
    Messages = {
        [1] = {
            taskBar = "Distillating Sassafras Oil",
            taskBarTime = 2500,
            animDict = "amb@prop_human_movie_studio_light@idle_a",
            anim = "idle_b",
        },
        [2] = {
            taskBar = "Adding Dihydrogen monoxide",
            taskBarTime = 5500,
            animDict = "amb@prop_human_movie_studio_light@idle_a",
            anim = "idle_b",
        },
        [3] = {
            taskBar = "Adding riboflavin",
            taskBarTime = 5500,
            animDict = "amb@prop_human_bbq@male@idle_a",
            anim = "idle_b",
        },
        [4] = {
            taskBar = "Distilling mixture",
            taskBarTime = 8000,
            animDict = "amb@prop_human_bbq@male@idle_a",
            anim = "idle_b",
        },
        [5] = {
            taskBar = "Distilling down to MMPI oil",
            taskBarTime = 8000,
            animDict = "amb@prop_human_bbq@male@idle_a",
            anim = "idle_b",
        },
        [6] = {
            taskBar = "Crystalizing mixture",
            taskBarTime = 6000,
            animDict = "amb@prop_human_bbq@male@idle_a",
            anim = "idle_b",
        },
        [7] = {
            taskBar = "Filtering and scraping crystals",
            taskBarTime = 5500,
            animDict = "amb@prop_human_bbq@male@idle_a",
            anim = "idle_b",
        },
        Packing = {
            taskBar = "Packing ecstasy pills",
            taskBarTime = 4000,
            animDict = "amb@prop_human_parking_meter@male@idle_a",
            anim = "idle_a",
        }
    }
}