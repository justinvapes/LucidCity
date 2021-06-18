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


Config = {}

Config.DepositPrice = 100 -- Vehicle deposit price
Config.PaymentTax = 7 -- Tax %

-- BUS JOB CONFIG --
Config.BusVehicle = "bus" -- Work vehicle model name
Config.BusDriverPayment = 525 -- Payment per finished route

Config.BusJobBlip = 513
Config.BusJobScale = 0.8
Config.BusJobColour = 26
Config.BusJobBlipName = "Bus station"
Config.BusJobText = {
    pickup = "Let People In",
    finishRoute = "Finish Route",
}

Config.BusJobPositions = {
    MarkerLocations = {
        ["spawnvehicle"] = {
            text = "Press ~g~[E]~w~ To Return Bus",
            coords = {x = 452.52, y = -585.37, z = 28.5, h = 266.547, r = 1.0},
            markerColor = {
                ["red"] = 92,
                ["green"] = 100,
                ["blue"] = 224,
            },
        },

        ["duty"] = {
            coords = {x = 438.74, y = -635.38, z = 28.63, h = 85.11, r = 1.0},
            markerColor = {
                ["red"] = 92,
                ["green"] = 100,
                ["blue"] = 224,
            },
        },

        ["boss"] = {
            text = "Press ~g~[E]~w~ To open owner\'s actions",
            coords = {x = 442.30, y = -597.69, z = 28.63, h = 351.39, r = 1.0},
            markerColor = {
                ["red"] = 92,
                ["green"] = 100,
                ["blue"] = 224,
            },
        },

        ["takeoutvehicle"] = {
            text = "Press ~g~[E]~w~ Take out bus (~r~100$ Deposit~w~)",
            coords = {x = 445.98, y = -646.66, z = 28.63, h = 84.966, r = 1.0},
            markerColor = {
                ["red"] = 92,
                ["green"] = 100,
                ["blue"] = 224,
            },
        },
    },
    busStopPositions = {
        [1] = {
            ped = {
                [1] = {x = 304.2782, y = -766.5727, z = 29.3097, h = 250.5608520, r = 1.0},
                [2] = {x = 304.2782, y = -766.5727, z = 29.3097, h = 250.5608520, r = 1.0},
                [3] = {x = 822.73, y = -1640.07, z = 30.30, h = 122.86211, r = 1.0},
            },
            coords = {
                [1] = {x = 307.4194, y = -766.1259, z = 29.24512, h = 163.924, r = 1.0},
                [2] = {x = 307.4194, y = -766.1259, z = 29.24512, h = 163.924, r = 1.0},
                [3] = {x = 825.68, y = -1639.196, z = 30.26, h = 174.20, r = 1.0},
            }, 
        }, 
        [2] = {
            ped = {
                [1] = {x = 357.3299, y = -1066.567, z = 29.55, h = 359.6299, r = 1.0},
                [2] = {x = 114.1437, y = 114.1437, z = 31.4087, h = 161.316299, r = 1.0},
                [3] = {x = -140.30, y = -2043.90, z = 22.95, h = 27.86211, r = 1.0},
            },
            coords = {
                [1] = {x = 356.0312, y = -1064.442, z = 29.394, h = 268.2011, r = 1.0},
                [2] = {x = 114.7494, y = -783.5089, z = 31.27081, h = 67.86211, r = 1.0},
                [3] = {x = -149.58, y = -2036.60, z = 22.89, h = 341.50, r = 1.0},
            }, 
        }, 
        [3] = {
            ped = {
                [1] = {x = 809.6035, y = -1351.332, z = 26.31854, h = 86.42, r = 1.0},
                [2] = {x = -175.4517, y = -820.2314, z = 31.09471, h = 248.880, r = 1.0},
                [3] = {x = 57.24, y = -1538.48, z = 29.29, h = 127.52, r = 1.0},
            },
            coords = {
                [1] = {x = 808.7094, y = -1352.276, z = 26.189, h = 356.432, r = 1.0},
                [2] = {x = -173.2606, y = -820.3528, z = 31.024, h = 160.1255, r = 1.0},
                [3] = {x = 51.34, y = -1535.398, z = 29.18, h = 317.52, r = 1.0},
            }, 
        }, 
        [4] = {
            ped = {
                [1] = {x = 787.7133, y = -775.1575, z = 26.42381, h = 87.845, r = 1.0},
                [2] = {x = -268.3008, y = -822.1886, z = 31.88078, h = 72.54, r = 1.0},
                [3] = {x = -205.38, y = -1004.28, z = 29.14, h = 22.54, r = 1.0},
            },
            coords = {
                [1] = {x = 786.2402, y = -775.9745, z = 26.29775, h = 357.22, r = 1.0},
                [2] = {x = -270.6449, y = -822.5668, z = 31.71911, h = 339.59, r = 1.0},
                [3] = {x = -212.83, y = -999.86, z = 29.16, h = 337.69, r = 1.0},
            }, 
        }, 
        [5] = {
            ped = {
                [1] = {x = -506.813, y = 22.8016, z = 44.77659, h = 192.81, r = 1.0},
                [2] = {x = -528.895, y = -266.6897, z = 35.41333, h = 198.692, r = 1.0},
                [3] = {x = -267.95, y = -822.58, z = 31.86, h = 122.692, r = 1.0},
            },
            coords = {
                [1] = {x = -504.9207, y = 20.90159, z = 44.67445, h = 91.255, r = 1.0},
                [2] = {x = -525.1201, y = -267.2997, z = 35.28671, h = 113.404, r = 1.0},
                [3] = {x = -270.97, y = -823.10, z = 31.72, h = 339.97, r = 1.0},
            }, 
        }, 
        [6] = {
            ped = {
                [1] = {x = -528.895, y = -266.6897, z = 35.41333, h = 198.692, r = 1.0},
                [2] = {x = -503.8438, y = -670.1882, z = 33.08115, h = 8.789, r = 1.0},
                [3] = {x = -176.12, y = -820.32, z = 31.07, h = 249.72, r = 1.0},
            },
            coords = {
                [1] = {x = -504.9207, y = 20.90159, z = 44.67445, h = 91.255, r = 1.0},
                [2] = {x = -504.8359, y = -668.6182, z = 32.956, h = 268.177, r = 1.0},
                [3] = {x = -173.47, y = -820.30, z = 31.01, h = 160.86, r = 1.0},
            }, 
        }, 
        [7] = {
            ped = {
                [1] = {x = 239.57, y = -864.96, z = 29.73, h = 337.08, r = 1.0},
                [2] = {x = 239.57, y = -864.96, z = 29.73, h = 337.08, r = 1.0},
                [3] = {x = 239.57, y = -864.96, z = 29.73, h = 337.08, r = 1.0},
            },
            coords = {
                [1] = {x = 241.9231, y = -859.96, z = 29.57, h = 249.68, r = 1.0},
                [2] = {x = 241.9231, y = -859.96, z = 29.57, h = 249.68, r = 1.0},
                [3] = {x = 241.9231, y = -859.96, z = 29.57, h = 249.68, r = 1.0},
            }, 
        }, 
        [8] = {
            coords = {
                [1] = {x = 460.7625, y = -655.0394, z = 27.78355, h = 352.7162, r = 1.0},
                [2] = {x = 460.7625, y = -655.0394, z = 27.78355, h = 352.7162, r = 1.0},
                [3] = {x = 460.7625, y = -655.0394, z = 27.78355, h = 352.7162, r = 1.0},
            }, 
        }, 

    }
}

Config.NpcSkins = {
    [1] = {
        'a_f_m_skidrow_01',
        'a_f_m_soucentmc_01',
        'a_f_m_soucent_01',
        'a_f_m_soucent_02',
        'a_f_m_tourist_01',
        'a_f_m_trampbeac_01',
        'a_f_m_tramp_01',
        'a_f_o_genstreet_01',
        'a_f_o_indian_01',
        'a_f_o_ktown_01',
        'a_f_o_salton_01',
        'a_f_o_soucent_01',
        'a_f_o_soucent_02',
        'a_f_y_beach_01',
        'a_f_y_bevhills_01',
        'a_f_y_business_01',
        'a_f_y_eastsa_01',
        'a_f_y_eastsa_02',
        'a_f_y_eastsa_03',
        'a_f_y_epsilon_01',
        'a_f_y_fitness_01',
        'a_f_y_fitness_02',
        'a_f_y_genhot_01',
        'a_f_y_golfer_01',
        'a_f_y_hiker_01',
        'a_f_y_indian_01',
        'a_f_y_juggalo_01',
        'a_f_y_runner_01',
        'a_f_y_rurmeth_01',
        'a_f_y_scdressy_01',
        'a_f_y_skater_01',
        'a_f_y_soucent_01',
        'a_f_y_soucent_02',
        'a_f_y_soucent_03',
        'a_f_y_tennis_01',
        'a_f_y_tourist_01',
        'a_f_y_tourist_02',
        'g_f_y_ballas_01',
    },
    [2] = {
        's_m_m_paramedic_01',
        'a_m_m_afriamer_01',
        'a_m_m_beach_01',
        'a_m_m_beach_02',
        'a_m_m_bevhills_01',
        'a_m_m_bevhills_02',
        'a_m_m_business_01',
        'a_m_m_eastsa_01',
        'a_m_m_eastsa_02',
        'a_m_m_farmer_01',
        'a_m_m_fatlatin_01',
        'a_m_m_genfat_01',
        'a_m_m_genfat_02',
        'a_m_m_golfer_01',
        'a_m_m_hasjew_01',
        'a_m_m_hillbilly_01',
        'a_m_m_hillbilly_02',
        'a_m_m_indian_01',
        'a_m_m_ktown_01',
        'a_m_m_malibu_01',
        'a_m_m_mexcntry_01',
        'a_m_m_mexlabor_01',
        'a_m_m_og_boss_01',
        'a_m_m_paparazzi_01',
        'a_m_m_polynesian_01',
        'a_m_m_prolhost_01',
        'a_m_m_rurmeth_01',
    }
}

-- Chicken Slaughterer Job

-- Time for tasks (seconds)
Config.PickChickenTime = 2
Config.SlaughterTime = 5
Config.PackChickenTime = 5
Config.ChickenForDelivery = 2

Config.ChickenPayment = 21 -- $ per 1 packaged chicken

Config.SlaughterBlip = 473
Config.SlaughterScale = 0.8
Config.SlaughterColour = 37
Config.SlaughterBlipName = "Chicken Factory"

Config.SlaughtererPositions = {
    MarkerLocations = {
        markerColor = {
            ["red"] = 120,
            ["green"] = 120,
            ["blue"] = 120,
        },
        ["chickens"] = {
            text = "Pick Alive Chicken",
            animDict = "amb@prop_human_parking_meter@male@idle_a",
            anim = "idle_a",
        },
        ["slaughter"] = {
            text = "Slaughter Chicken",
            animDict = "amb@prop_human_movie_studio_light@idle_a",
            anim = "idle_b",
        },
        ["pack"] = {
            text = "Pack Slaughtered Chicken",
            animDict = "amb@prop_human_parking_meter@male@idle_a",
            anim = "idle_a",
        },
        ["placefordelivery"] = {
            text = "Place Packaged Chicken For Delivery",
            animDict = "amb@prop_human_bum_bin@idle_a",
            anim = "idle_a",
        },
    }
}

Config.PizzaPayment = 1200

Config.OutfitReminderPositions = {
    MarkerLocations = {
        {x = -69.04, y = 6242.17, z = 31.07, h = 127.24, r = 1.0}
    }
}

Config.Ingredients = {
    "mozzarella", 
    "olive",
    "mushrooms",
    "onion",
    "pineapple",
    "tomatosauce",
    "dough",
}

Config.PizzaPositions = {
    ['StartHunting'] = { ['hint'] = '[E] Start Hunting', ['x'] = -769.23773193359, ['y'] = 5595.6215820313, ['z'] = 33.48571395874 },
    ['grabProducts'] = {['hint'] = '[E] Grab products', ['x'] = -2508.85, ['y'] =3614.799, ['z'] =13.76},
    ["vehicle"] = {['x'] = 298.83, ['y'] = -997.12, ['z'] = 29.19}, 
    ['cookMeat'] = {['hint'] = '[E] Process Meat', ['x'] = 288.38, ['y'] = -985.32, ['z'] = 29.43},  
    ['setupPizza'] = { ['x'] = 285.83, ['y'] = -983.70, ['z'] = 29.43},
    ['pizzaOven'] = { ['x'] = 282.79, ['y'] = -974.90, ['z'] = 29.43},
    ['sellPizza'] = { ['x'] = 290.70, ['y'] = -978.00, ['z'] = 29.43},     
    ["duty"] = {['x'] = 282.94 , ['y'] =  -978.04, ['z'] = 29.43}, 
    ["owner"] = {['x'] = 289.03 , ['y'] = -989.72, ['z'] = 29.43},
    ["changePrice"] = {['x'] = 290.77  , ['y'] = -977.98, ['z'] = 29.43},
    ["stash"] = {['x'] = 288.03  , ['y'] = -981.36, ['z'] = 29.43},
}


----------------------------------------------------------------------------------

Config.AirlinePositions = {
    ['metalDetector'] = {x = -966.74, y = -2798.511, z = 13.96},
    ['metalDetector2'] = {x = -960.52, y = -2798.38, z = 13.96},
    ['takePlane'] = {x = -971.17, y =  -3001.245, z = 13.55, h = 57.27},
    ['takeHeli'] = {x = -953.11, y =  -2969.29, z = 13.55, h = 57.27},
    ['takePlaneCayo'] = {x = 4485.349, y =  -4493.646, z = 4.196173, h = 108.56},
    ['takeHeliCayo'] = {x = 4449.111, y =  -4486.357, z = 4.22, h = 108.56},
    ["owner"] = {['x'] = -929.32 , ['y'] = -2994.66, ['z'] = 19.84},
    ["outfits"] = {['x'] = -928.0803 , ['y'] = -2936.962, ['z'] = 13.94508},
    ["onDuty"] = {['x'] = -930.61 , ['y'] = -2957.70, ['z'] = 13.94},
}

Config.DepositPricePlane = {
    ["miljet"] = {name = 'Miljet' ,price = 150000,type = 'plane'},
    ["luxor"] = {name = 'Luxor Black' ,price = 750000,type = 'plane'},
    ["luxor2"] = {name = 'Luxor Gold' ,price = 1000000,type = 'plane'},
    ["maverick"] = {name = 'Maverick' ,price = 75000,type = 'heli'},
    ["swift"] = {name = 'Swift' ,price = 130000,type = 'heli'},
    ["swift2"] = {name = 'Swift Gold' ,price = 250000,type = 'heli'}
}


-------------------------- LUMBERJACK ---------------

Config.textDel = 'Press (~g~[E]~w~) to cut wood. Press (~g~[Backspace]~w~) to quit cutting wood. '

Config.Lumber = {
    ChanceToGetItem = 20, -- if math.random(0, 100) <= ChanceToGetItem then give item
    Items = {'wood_cut','wood_cut','wood_cut','wood_cut','wood_cut'},
    Process = vector3(-584.66, 5285.63, 70.26),
    Objects = {
        ['pickaxe'] = 'w_me_hatchet',
    },
    WoodPosition = {
        {coords = vector3(-554.017, 5369.98, 70.37), heading = 255.49},
        {coords = vector3(-532.02, 5372.40, 70.43), heading = 165.62},
     --[[    {coords = vector3(-456.85, 5397.37, 79.49-0.97), heading = 29.92},
        {coords = vector3(-457.42, 5409.05, 78.78-0.97), heading = 209.65} ]]
    },
}

Config.Debug = false
Config.JobBusy = false

Config.WoodShop = {
    ["name"] = "Wood Shop",
    ["blip"] = {
        ["sprite"] = 434,
        ["color"] = 25
    },
    ["ped"] = {
        ["model"] = 0xED0CE4C6,
        ["position"] = vector3(-552.35, 5348.43, 73.74),
        ["heading"] = 75.0
    }
}

Config.WoodItems = {
    ["wood_proc"] = {
        ["price"] = 8
    },
}

Strings = {
   
    ['someone_close'] = 'There is a player too close to you!',
    ['wood'] = 'Woodcutter',
    ['process'] = 'Process Wood',
    ['sell_wood'] = 'Sell Wood',
}