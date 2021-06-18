Config = {}

Config.Keys = {
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

-- NEEDS ECONOMY CHANGES (SHOP PRICES)
Config.Products = {
    ["normal"] = {
        [1] = {
            name = "water_bottle",
            price = 2,
            amount = 50,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "kurkakola",
            price = 4,
            amount = 50,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "twerks_candy",
            price = 3,
            amount = 50,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "snikkel_candy",
            price = 3,
            amount = 50,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "sandwich",
            price = 5,
            amount = 50,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "beer",
            price = 7,
            amount = 50,
            info = {},
            type = "item",
            slot = 6,
        },
        [7] = {
            name = "whiskey",
            price = 10,
            amount = 50,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "vodka",
            price = 12,
            amount = 50,
            info = {},
            type = "item",
            slot = 8,
        },
        [9] = {
            name = "bandage",
            price = 50,
            amount = 50,
            info = {},
            type = "item",
            slot = 9,
        },
        [10] = {
            name = "lighter",
            price = 2,
            amount = 50,
            info = {},
            type = "item",
            slot = 10,
        },
        [11] = {
            name = "cigarette",
            price = 2,
            amount = 300,
            info = {},
            type = "item",
            slot = 11,
        },
        [12] = {
            name = "popcorn",
            price = 8,
            amount = 50,
            info = {},
            type = "item",
            slot = 12,
        },
        [13] = {
            name = "notepad",
            price = 5,
            amount = 300,
            info = {},
            type = "item",
            slot = 13,
        },
        [14] = {
            name = "lime",
            price = 2,
            amount = 300,
            info = {},
            type = "item",
            slot = 14,
        },
        [15] = {
            name = "empty_weed_bag",
            price = 1,
            amount = 300,
            info = {},
            type = "item",
            slot = 15,
        },
        [16] = {
            name = "sprite",
            price = 3,
            amount = 300,
            info = {},
            type = "item",
            slot = 16,
        },
        [17] = {
            name = "applejuice",
            price = 3,
            amount = 300,
            info = {},
            type = "item",
            slot = 17,
        },
        [18] = {
            name = "mnm",
            price = 2,
            amount = 300,
            info = {},
            type = "item",
            slot = 18,
        },
        [19] = {
            name = "skittles",
            price = 2,
            amount = 300,
            info = {},
            type = "item",
            slot = 19,
        },
        [20] = {
            name = "doritos",
            price = 4,
            amount = 300,
            info = {},
            type = "item",
            slot = 20,
        },
        [21] = {
            name = "hotcheetos",
            price = 4,
            amount = 300,
            info = {},
            type = "item",
            slot = 21,
        },
        [22] = {
            name = "rolling_paper",
            price = 4,
            amount = 300,
            info = {},
            type = "item",
            slot = 22,
        },
    },
    ["stripclub"] = {
        [1] = {
            name = "beer",
            price = 12,
            amount = 300,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "whiskey",
            price = 15,
            amount = 300,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "vodka",
            price = 17,
            amount = 300,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "cigarette",
            price = 2,
            amount = 300,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "rolling_paper",
            price = 4,
            amount = 300,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "lighter",
            price = 2,
            amount = 50,
            info = {},
            type = "item",
            slot = 6,
        }
    },
    ["hardware"] = {
        [1] = {
            name = "weapon_bat",
            price = 100,
            amount = 250,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "weapon_wrench",
            price = 50,
            amount = 250,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "weapon_hammer",
            price = 50,
            amount = 250,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "repairkit",
            price = 300,
            amount = 50,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "screwdriverset",
            price = 400,
            amount = 50,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "binoculars",
            price = 25,
            amount = 50,
            info = {},
            type = "item",
            slot = 6,
        },
        [7] = {
            name = "cleaningkit",
            price = 15,
            amount = 150,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "firework1",
            price = 50,
            amount = 50,
            info = {},
            type = "item",
            slot = 8,
        },
        [9] = {
            name = "firework2",
            price = 50,
            amount = 50,
            info = {},
            type = "item",
            slot = 9,
        },
        [10] = {
            name = "firework3",
            price = 50,
            amount = 50,
            info = {},
            type = "item",
            slot = 10,
        },
        [11] = {
            name = "firework4",
            price = 50,
            amount = 50,
            info = {},
            type = "item",
            slot = 11,
        },
        [12] = {
            name = "fishingrod",
            price = 300,
            amount = 50,
            info = {},
            type = "item",
            slot = 12,
        },
        [13] = {
            name = "bait",
            price = 2,
            amount = 500,
            info = {},
            type = "item",
            slot = 13,
        },
        [14] = {
            name = "metalscrap",
            price = 5,
            amount = 10000,
            info = {},
            type = "item",
            slot = 14,
        },
        [15] = {
            name = "screwdriverset",
            price = 100,
            amount = 10000,
            info = {},
            type = "item",
            slot = 15,
        },
        [16] = {
            name = "detector",
            price = 1600,
            amount = 9000,
            info = {},
            type = "item",
            slot = 16,
        },
        [17] = {
            name = "lockpick",
            price = 320,
            amount = 9000,
            info = {},
            type = "item",
            slot = 17,
        },
        [18] = {
            name = "drill",
            price = 5000,
            amount = 9000,
            info = {},
            type = "item",
            slot = 18,
        },
        [19] = {
            name = "metal_spring",
            price = 500,
            amount = 9000,
            info = {},
            type = "item",
            slot = 19,
        },
    },
    ["gearshop"] = {
        [1] = {
            name = "diving_gear",
            price = 1000,
            amount = 10,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "jerry_can",
            price = 70,
            amount = 50,
            info = {},
            type = "item",
            slot = 2,
        },
    },
    ["leisureshop"] = {
        [1] = {
            name = "binoculars",
            price = 25,
            amount = 50,
            info = {},
            type = "item",
            slot = 1,
        },    
        [2] = {
            name = "diving_gear",
            price = 1000,
            amount = 10,
            info = {},
            type = "item",
            slot = 2,
        },
        -- [4] = {
        --     name = "smoketrailred",
        --     price = 250,
        --     amount = 50,
        --     info = {},
        --     type = "item",
        --     slot = 4,
        -- },
    },
    ["airlines"] = {
        [1] = {
            name = "parachute",
            price = 500,
            amount = 100000,
            info = {},
            type = "item",
            slot = 1,
        },
    },
    ["burgershot"] = {
        [1] = {
            name = "raw_meat_patty",
            price = 5,
            amount = 100000,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "raw_vegan_patty",
            price = 5,
            amount = 100000,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "tomatosauce",
            price = 5,
            amount = 100000,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "lettuce",
            price = 5,
            amount = 100000,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "cheddar",
            price = 5,
            amount = 100000,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "burger_bun",
            price = 5,
            amount = 100000,
            info = {},
            type = "item",
            slot = 6,
        },
        [7] = {
            name = "tomato",
            price = 5,
            amount = 100000,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "sliced_mushroom",
            price = 5,
            amount = 100000,
            info = {},
            type = "item",
            slot = 8,
        },
        [9] = {
            name = "bs_drink_empty",
            price = 5,
            amount = 100000,
            info = {},
            type = "item",
            slot = 9,
        },
        [10] = {
            name = "potato",
            price = 5,
            amount = 100000,
            info = {},
            type = "item",
            slot = 10,
        },
        [11] = {
            name = "bs_fries_empty",
            price = 5,
            amount = 100000,
            info = {},
            type = "item",
            slot = 11,
        },
    },
    ["arcadebar"] = {
        [1] = {
            name = "kurkakola",
            price = 4,
            amount = 100000,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "water_bottle",
            price = 2,
            amount = 100000,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "beer",
            price = 12,
            amount = 100000,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "mutant_energy",
            price = 30,
            amount = 100000,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "redbullock",
            price = 30,
            amount = 100000,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "empire",
            price = 30,
            amount = 100000,
            info = {},
            type = "item",
            slot = 6,
        },
        [7] = {
            name = "coffee",
            price = 10,
            amount = 100000,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "twerks_candy",
            price = 3,
            amount = 100000,
            info = {},
            type = "item",
            slot = 8,
        },
    },   
    ["cinema"] = {
        [1] = {
            name = "water_bottle",
            price = 2,
            amount = 50,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "kurkakola",
            price = 4,
            amount = 50,
            info = {},
            type = "item",
            slot = 2,
        },  
        [3] = {
            name = "popcorn",
            price = 8,
            amount = 50,
            info = {},
            type = "item",
            slot = 3,
        },
    },
    ["digitalden"] = {
        [1] = {
            name = "phone",
            price = 300,
            amount = 50,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "radio",
            price = 150,
            amount = 50,
            info = {},
            type = "item",
            slot = 2,
        },
    },    
    ["casinochips"] = {
        [1] = {
            name = "casinochips",
            price = 1,
            amount = 1000000000,
            info = {},
            type = "item",
            slot = 1,
        }
    },
    ["casinochips2"] = {
        [1] = {
            name = "casinochips2",
            price = 1,
            amount = 1000000000,
            info = {},
            type = "item",
            slot = 1,
        }
    },
    ["casino"] = {
        [1] = {
            name = "cigarette",
            price = 4,
            amount = 200,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "lighter",
            price = 6,
            amount = 50,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "beer",
            price = 12,
            amount = 200,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "whiskey",
            price = 15,
            amount = 200,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "vodka",
            price = 20,
            amount = 200,
            info = {},
            type = "item",
            slot = 5,
        },
    },
    ["diner"] = {
        [1] = {
            name = "water_bottle",
            price = 2,
            amount = 50,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "kurkakola",
            price = 4,
            amount = 50,
            info = {},
            type = "item",
            slot = 2,
        },  
        [3] = {
            name = "spaghetti",
            price = 10,
            amount = 50,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "pancakes",
            price = 8,
            amount = 50,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "eggsbacon",
            price = 14,
            amount = 50,
            info = {},
            type = "item",
            slot = 5,
        },
    },
    ["labchemicals"] = {
        [1] = {
            name = "permanganate",
            price = 13,
            amount = 20000,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "sulfuricacid",
            price = 44,
            amount = 20000,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "iodine_crystals",
            price = 5,
            amount = 20000,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "acetone_ethyl",
            price = 66,
            amount = 20000,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "redphosphorus",
            price = 20,
            amount = 20000,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "hydriodicacid",
            price = 117,
            amount = 20000,
            info = {},
            type = "item",
            slot = 6,
        },
        [7] = {
            name = "pseudoephedrine",
            price = 5,
            amount = 20000,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "ethyl_alcohol",
            price = 5,
            amount = 20000,
            info = {},
            type = "item",
            slot = 8,
        },
        [9] = {
            name = "hydrogen_peroxide",
            price = 14,
            amount = 20000,
            info = {},
            type = "item",
            slot = 9,
        },
        [10] = {
            name = "pure_ammonia",
            price = 5,
            amount = 20000,
            info = {},
            type = "item",
            slot = 10,
        },
        [11] = {
            name = "dihydrogen_monoxide",
            price = 40,
            amount = 20000,
            info = {},
            type = "item",
            slot = 11,
        },
        [12] = {
            name = "sassafras_oil",
            price = 125,
            amount = 20000,
            info = {},
            type = "item",
            slot = 12,
        },
        [13] = {
            name = "riboflavin",
            price = 30,
            amount = 20000,
            info = {},
            type = "item",
            slot = 13,
        },
        [14] = {
            name = "chloroform",
            price = 15,
            amount = 20000,
            info = {},
            type = "item",
            slot = 14,
        },
        [15] = {
            name = "sodium_carbonate",
            price = 26,
            amount = 20000,
            info = {},
            type = "item",
            slot = 15,
        },
        [16] = {
            name = "hydrochloric_acid",
            price = 40,
            amount = 20000,
            info = {},
            type = "item",
            slot = 16,
        },
    },   
    ["weapons"] = {
        [1] = {
            name = "weapon_knife",
            price = 200,
            amount = 900,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "weapon_switchblade",
            price = 300,
            amount = 900,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "weapon_hatchet",
            price = 100,
            amount = 900,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "pistol_ammo",
            price = 500,
            amount = 2500000,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "shotgun_ammo",
            price = 900,
            amount = 2500000,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "smg_ammo",
            price = 800,
            amount = 2500000,
            info = {},
            type = "item",
            slot = 6,
        },
    },
    ["freshmarket"] = {
        [1] = {
            name = "mozzarella",
            price = 8,
            amount = 2500000,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "pineapple",
            price = 15,
            amount = 2500000,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "olive",
            price = 6,
            amount = 2500000,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "onion",
            price = 10,
            amount = 2500000,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "mushrooms",
            price = 25,
            amount = 2500000,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "tomatosauce",
            price = 16,
            amount = 2500000,
            info = {},
            type = "item",
            slot = 6,
        },
        [7] = {
            name = "dough",
            price = 30,
            amount = 2500000,
            info = {},
            type = "item",
            slot = 7,
        },
    },
}

Config.Locations = {
    ["arcadebar"] = {
        ["label"] = "Arcade Bar",
        ["type"] = "arcadebar",
        ["coords"] = {
            [1] = {
                ["x"] = 339.17 ,   
                ["y"] = -909.97,
                ["z"] = 29.25,
            },
            [2] = {
                ["x"] = 333.67 ,   
                ["y"] = -916.09,
                ["z"] = 29.25,
            },
            [3] = {
                ["x"] = 332.86 ,   
                ["y"] = -909.68,
                ["z"] = 29.25,
            }
        },
        ["products"] = Config.Products["arcadebar"],
    },
    ["airlines"] = {
        ["label"] = "Arlines",
        ["type"] = "airlines",
        ["coords"] = {
            [1] = {
                ["x"] = -941.12 ,   
                ["y"] = -2954.14,
                ["z"] = 13.94,
            }
        },
        ["products"] = Config.Products["airlines"],
    },
    ["burgershot"] = {
        ["label"] = "Burgershot",
        ["type"] = "burgershot",
        ["coords"] = {
            [1] = {
                ["x"] = -1204.172 ,   
                ["y"] = -892.37,
                ["z"] = 13.99,
            }
        },
        ["products"] = Config.Products["burgershot"],
    },
    ["casino"] = {
        ["label"] = "Casino",
        ["type"] = "casino",
        ["coords"] = {
            [1] = {
                ["x"] = 938.21 ,   
                ["y"] = 27.43,
                ["z"] = 71.83,
            },
            [2] = {
                ["x"] = 939.75,   
                ["y"] = 24.64,
                ["z"] =  71.83,
            },
        },
        ["products"] = Config.Products["casino"],
    },
    ["casinochips"] = {
    
        ["label"] = "Casino Shop",
        ["type"] = "casinochips",
        ["coords"] = {
            [1] = {
                ["x"] = 948.13, 
                ["y"] = 32.38, 
                ["z"] = 71.83,
                ["minZ"] = 71.03,
                ["maxZ"] = 73.63,
                ["heading"] = 325,
            }
        },
        ["products"] = Config.Products["casinochips"],
    },
    ["casinochips2"] = {
    
        ["label"] = "Underground Casino Shop",
        ["type"] = "casinochips2",
        ["coords"] = {
            [1] = {
                ["x"] = -371.59, 
                ["y"] = 195.60, 
                ["z"] = 84.05,
                ["minZ"] = 83.08,
                ["maxZ"] = 85.88,  
                ["heading"] = 0,
            }
        },
        ["products"] = Config.Products["casinochips2"],
    },
    ["freshmarket"] = {
    
        ["label"] = "Fresh Market",
        ["type"] = "freshmarket",
        ["coords"] = {
            [1] = {
                ["x"] = -2507.96,   
                ["y"] = 3615.144, 
                ["z"] = 13.78
            }
        },
        ["products"] = Config.Products["freshmarket"],
    },
    ["labchemicals"] = {
        ["label"] = "Lab Chemicals",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 489.4,
                ["y"] = -921.69,
                ["z"] = 26.41,
                ["minZ"] = 25.41,
                ["maxZ"] = 28.21,  
                ["heading"] = 358,
            },
        },
        ["products"] = Config.Products["labchemicals"],
    },
    ["beancoffee"] = {
        ["label"] = "Bean Machine Coffee",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = -633.72,
                ["y"] = 236.15,
                ["z"] = 81.88,
            },
        },
        ["products"] = Config.Products["coffeeplace"],
    },
    ["cinema"] = {
        ["label"] = "Cinema",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 341.47,
                ["y"] = 186.16,
                ["z"] = 102.99,
            },
        },
        ["products"] = Config.Products["cinema"],
    },
    ["ltdgasoline"] = {
        ["label"] = "LTD Gasoline",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = -48.44,
                ["y"] = -1757.86,
                ["z"] = 29.42,
            },
            [2] = {
                ["x"] = -47.23,
                ["y"] = -1756.58,
                ["z"] = 29.42,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["247supermarket"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 25.7,
                ["y"] = -1347.3,
                ["z"] = 29.49,
            },
            [2] = {
                ["x"] = 25.7,
                ["y"] = -1344.99,
                ["z"] = 29.49,
            }
        },
        ["products"] = Config.Products["normal"],
    }--[[ ,
    ["robsliquor"] = {
        ["label"] = "Rob's Liqour",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = -1222.77,
                ["y"] = -907.19,
                ["z"] = 12.32,
            },
        },
        ["products"] = Config.Products["normal"],
    } ]],
    ["ltdgasoline2"] = {
        ["label"] = "LTD Gasoline",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = -707.41,
                ["y"] = -912.83,
                ["z"] = 19.21,
            },
            [2] = {
                ["x"] = -707.32,
                ["y"] = -914.65,
                ["z"] = 19.21,
            }
        },
        ["products"] = Config.Products["normal"],
    }--[[ ,
    ["robsliquor2"] = {
        ["label"] = "Rob's Liqour",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = -1487.7,
                ["y"] = -378.53,
                ["z"] = 40.16,
            },
        },
        ["products"] = Config.Products["normal"],
    } ]],
    ["ltdgasoline3"] = {
        ["label"] = "LTD Gasoline",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = -1820.33,
                ["y"] = 792.66,
                ["z"] = 138.1,
            },
            [2] = {
                ["x"] = -1821.55,
                ["y"] = 793.98,
                ["z"] = 138.1,
            }
        },
        ["products"] = Config.Products["normal"],
    }--[[ ,
    ["robsliquor3"] = {
        ["label"] = "Rob's Liqour",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = -2967.79,
                ["y"] = 391.64,
                ["z"] = 15.04,
            },
        },
        ["products"] = Config.Products["normal"],
    } ]],
    ["247supermarket2"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = -3038.71,
                ["y"] = 585.9,
                ["z"] = 7.9,
            },
            [2] = {
                ["x"] = -3041.04,
                ["y"] = 585.11,
                ["z"] = 7.9,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["247supermarket3"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = -3241.47,
                ["y"] = 1001.14,
                ["z"] = 12.83,
            },
            [2] = {
                ["x"] = -3243.98,
                ["y"] = 1001.35,
                ["z"] = 12.83,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["247supermarket4"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 1728.66,
                ["y"] = 6414.16,
                ["z"] = 35.03,
            },
            [2] = {
                ["x"] = 1729.72,
                ["y"] = 6416.27,
                ["z"] = 35.03,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["247supermarket5"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 1697.99,
                ["y"] = 4924.4,
                ["z"] = 42.06,
            },
            [2] = {
                ["x"] = 1699.44,
                ["y"] = 4923.47,
                ["z"] = 42.06,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["247supermarket6"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 1961.48,
                ["y"] = 3739.96,
                ["z"] = 32.34,
            },
            [2] = {
                ["x"] = 1960.22,
                ["y"] = 3742.12,
                ["z"] = 32.34,
            }
        },
        ["products"] = Config.Products["normal"],
    }--[[ ,
    ["robsliquor4"] = {
        ["label"] = "Rob's Liqour",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 1165.28,
                ["y"] = 2709.4,
                ["z"] = 38.15,
            },
        },
        ["products"] = Config.Products["normal"],
    } ]],
    ["247supermarket7"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 547.79,
                ["y"] = 2671.79,
                ["z"] = 42.15,
            },
            [2] = {
                ["x"] = 548.1,
                ["y"] = 2669.38,
                ["z"] = 42.15,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["247supermarket8"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 2679.25,
                ["y"] = 3280.12,
                ["z"] = 55.24,
            },
            [2] = {
                ["x"] = 2677.13,
                ["y"] = 3281.38,
                ["z"] = 55.24,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["247supermarket9"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 2557.94,
                ["y"] = 382.05,
                ["z"] = 108.62,
            },
            [2] = {
                ["x"] = 2555.53,
                ["y"] = 382.18,
                ["z"] = 108.62,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["247supermarketcayo"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 4480.06,  
                ["y"] = -4468.16,
                ["z"] = 4.25,
            },
        },
        ["products"] = Config.Products["normal"],
    },
    ["delvecchioliquor"] = {
        ["label"] = "Del Vecchio Liquor",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = -159.36,
                ["y"] = 6321.59,
                ["z"] = 31.58,
            },
            [2] = {
                ["x"] = -160.66,
                ["y"] = 6322.85,
                ["z"] = 31.58,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["donscountrystore"] = {
        ["label"] = "Don's Country Store",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 161.41,
                ["y"] = 6640.78,
                ["z"] = 31.69,
            },
            [2] = {
                ["x"] = 163.04,
                ["y"] = 6642.45,
                ["z"] = 31.70,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["ltdgasoline4"] = {
        ["label"] = "LTD Gasoline",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 1163.7,
                ["y"] = -323.92,
                ["z"] = 69.2,
            },
            [2] = {
                ["x"] = 1163.4,
                ["y"] = -322.24,
                ["z"] = 69.2,
            }
        },
        ["products"] = Config.Products["normal"],
    }--[[ ,
    ["robsliquor5"] = {
        ["label"] = "Rob's Liqour",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 1135.66,
                ["y"] = -982.76,
                ["z"] = 46.41,
            },
        },
        ["products"] = Config.Products["normal"],
    } ]],
    ["247supermarket9"] = {
        ["label"] = "24/7 Supermarket",
        ["type"] = "normal",
        ["coords"] = {
            [1] = {
                ["x"] = 373.55,
                ["y"] = 325.56,
                ["z"] = 103.56,
            },
            [2] = {
                ["x"] = 374.29,
                ["y"] = 327.9,
                ["z"] = 103.56,
            }
        },
        ["products"] = Config.Products["normal"],
    },
    ["stripclub"] = {
        ["label"] = "Strip club",
        ["type"] = "stripclub",
        ["coords"] = {
            [1] = {
                ["x"] = 129.76 , 
                ["y"] = -1285.12,
                ["z"] = 29.25,
            }
        },
        ["products"] = Config.Products["stripclub"],
    },
    ["diner"] = {
        ["label"] = "Casey's diner",
        ["type"] = "diner",
        ["coords"] = {
            [1] = {
                ["x"] = 798.46,
                ["y"] = -736.34,
                ["z"] = 27.99,
                ["minZ"] = 26.99,
                ["maxZ"] = 29.39,
                ["heading"] = 0,
            }
        },
        ["products"] = Config.Products["diner"],
    },
    ["digitalden"] = {
        ["label"] = "Digital Den",
        ["type"] = "digitalden",
        ["coords"] = {
            [1] = {
                ["x"] = -657.18,
                ["y"] = -857.42,
                ["z"] = 24.49,
            }
        },
        ["products"] = Config.Products["digitalden"],
    },
    ["hardware"] = {
        ["label"] = "Mega Mall",
        ["type"] = "hardware",
        ["coords"] = {
            [1] = {
                ["x"] = 45.55,
                ["y"] = -1749.01,
                ["z"] = 29.6,
            }
        },
        ["products"] = Config.Products["hardware"],
    },
    ["hardware2"] = {
        ["label"] = "Mega Mall",
        ["type"] = "hardware",
        ["coords"] = {
            [1] = {
                ["x"] = 2747.8,
                ["y"] = 3472.86,
                ["z"] = 55.67,
            },
        },
        ["products"] = Config.Products["hardware"],
    },
    ["hardware3"] = {
        ["label"] = "Mega Mall",
        ["type"] = "hardware",
        ["coords"] = {
            [1] = {
                ["x"] = -421.84,
                ["y"] = 6136.09,
                ["z"] = 31.78,
            },
        },
        ["products"] = Config.Products["hardware"],
    },   
    ["seaword1"] = {
        ["label"] = "Sea Word",
        ["type"] = "sea",
        ["coords"] = {
            [1] = {
                ["x"] = -1686.9, 
                ["y"] = -1072.23, 
                ["z"] = 13.15
            }
        },
        ["products"] = Config.Products["gearshop"],
    },
    --[[["mustapha"] = {
        ["label"] = "Rent vehicles",
        ["type"] = "leisure",
        ["coords"] = {
            [1] = {
                ["x"] = -31.18, 
                ["y"] = -1397.537, 
                ["z"] = 29.50
            }
        },
        ["products"] = Config.Products["mustapha"],
    },    --]]
}