Config = {}

Config.MinimalDoctors = 2
Config.MissionCooldown = 600000

Config.EMSOutfitsMale = {
    ["emsmale"]  = "EMS 1",
    ["emsmale2"] = "EMS 2",
    ["doctor"]   = "Doctor 1",
    ["nurse"]    = "Nurse",
}

Config.EMSOutfitsFemale = {
    ["emsfemale"]      = "EMS 1",
    ["emsfemale2"]     = "EMS 2",
    ["doctorfemale"]   = "Doctor",
    ["nursefemale"]    = "Nurse",
}

Config.Locations = {
    jobs = {
        ["makepills"] = {
            mapblip = 430,
            mapblipColour = 1,
            [1] = {
                coords = {
                    [1] = {x = 310.1736, y = -568.3447, z = 43.28407, h = 252.126},
                }, 
                taskbar = "Taking chemicals", 
                text = "Take chemicals",
                time = math.random(3000, 4000),
                animDict = "amb@prop_human_parking_meter@male@idle_a",
                anim = "idle_a",
            },
            [2] = {
                coords = {
                    [1] = {x = 309.3369, y = -560.9008, z = 43.28401, h = 30.36},
                }, 
                taskbar = "Mixing chemicals", 
                text = "Mix chemicals",
                time = math.random(10000, 12000),
                animDict = "amb@prop_human_movie_studio_light@idle_a",
                anim = "idle_b",
            },
            [3] = {
                coords = {
                    [1] = {x = 311.1936, y = -565.6649, z = 43.28401, h = 255.61},
                }, 
                taskbar = "Making pills", 
                text = "Make Pills",
                time = math.random(10000, 12000),
                animDict = "amb@prop_human_bbq@male@idle_a",
                anim = "idle_b",
            },
        },
        ["cleanbeds"] = {
            mapblip = 430,
            mapblipColour = 1,
            [1] = {
                coords = {
                    [1] = {x = 318.41, y = -580.813, z = 43.2840, h = 252.126},
                }, 
                taskbar = "Cleaning bed",
                text = "Clean Bed",
                time = math.random(8000, 10000),
                animDict = "amb@prop_human_bum_bin@idle_a",
                anim = "idle_a",
            },
            [2] = {
                coords = {
                    [1] = {x = 323.24, y = -582.5928, z = 43.284, h = 252.00},
                }, 
                taskbar = "Cleaning bed", 
                text = "Clean Bed",
                time = math.random(8000, 10000),
                animDict = "amb@prop_human_bum_bin@idle_a",
                anim = "idle_a",
            },
            [3] = {
                coords = {
                    [1] = {x = 314.6894, y = -579.4835, z = 43.28407, h = 65.83},
                }, 
                taskbar = "Cleaning bed", 
                text = "Clean Bed",
                time = math.random(8000, 10000),
                animDict = "amb@prop_human_bum_bin@idle_a",
                anim = "idle_a",
            },
            [4] = {
                coords = {
                    [1] = {x = 310.17, y = -577.8605, z = 43.284, h = 65.83},
                },
                taskbar = "Cleaning bed", 
                text = "Clean Bed",
                time = math.random(8000, 10000),
                animDict = "amb@prop_human_bum_bin@idle_a",
                anim = "idle_a",
            },
            [5] = {
                coords = {
                    [1] = {x = 308.70, y = -582.02, z = 43.284, h = 69.19},
                },
                taskbar = "Cleaning bed", 
                text = "Clean Bed",
                time = math.random(8000, 10000),
                animDict = "amb@prop_human_bum_bin@idle_a",
                anim = "idle_a",
            },
        },
        ["sterilize"] = {
            mapblip = 430,
            mapblipColour = 1,
            [1] = {
                coords = {
                    [1] = {x = 310.2453, y = -567.7874, z = 43.28402, h = 270.751},
                    [2] = {x = 315.9718, y = -569.7851, z = 43.28408, h = 251.1619},
                }, 
                taskbar = "Sterilizing Medical Equipment",
                text = "Sterilize Medical Equipment",
                time = math.random(8000, 10000),
                animDict = "amb@prop_human_bbq@male@idle_a",
                anim = "idle_b",
            },
            [2] = {
                coords = {
                    [1] = {x = 311.1481, y = -565.7424, z = 43.28402, h = 252.99},
                    [2] = {x = 316.5571, y = -564.6068, z = 43.2840, h = 152.89},
                }, 
                taskbar = "Sterilizing Medical Equipment",
                text = "Sterilize Medical Equipment",
                time = math.random(8000, 10000),
                animDict = "amb@prop_human_bbq@male@idle_a",
                anim = "idle_b",
            },
            [3] = {
                coords = {
                    [1] = {x = 309.3369, y = -560.9008, z = 43.28401, h = 30.36},
                    [2] = {x = 313.3288, y = -566.4998, z = 43.2840, h = 73.68},
                }, 
                taskbar = "Sterilizing Medical Equipment",
                text = "Sterilize Medical Equipment",
                time = math.random(8000, 10000),
                animDict = "amb@prop_human_bbq@male@idle_a",
                anim = "idle_b",
            },
        },
        ["consultpatient"] = {
            mapblip = 430,
            mapblipColour = 1,
            [1] = {
                coords = {
                    [1] = {x = 359.79, y = -599.09, z = 43.284, h = 292.126, pedX = 360.3133, pedY = -598.7917, pedZ = 43.284, pedH = 100.0},
                    [2] = {x = 354.2936, y = -595.6815, z = 43.28407, h = 148.28, pedX = 354.1165, pedY = -596.09, pedZ = 43.28407, pedH = 336.96},
                    [3] = {x = 343.7587, y = -591.225, z = 43.28407, h = 68.6309, pedX = 343.2893, pedY = -591.049, pedZ = 43.28407, pedH = 254.752},
                }, 
                taskbar = "Consulting patient", 
                text = "To consult patient",
                time = math.random(8000, 9000),
                animName = "clipboard",
                icon = "fas fa-user-md"
            },
            [2] = {
                coords = {
                    [1] = {x = 359.79, y = -599.09, z = 43.284, h = 292.126, pedX = 360.3133, pedY = -598.7917, pedZ = 43.284, pedH = 100.0},
                    [2] = {x = 354.2936, y = -595.6815, z = 43.28407, h = 148.28, pedX = 354.1165, pedY = -596.09, pedZ = 43.28407, pedH = 336.96},
                    [3] = {x = 343.7587, y = -591.225, z = 43.28407, h = 68.6309, pedX = 343.2893, pedY = -591.049, pedZ = 43.28407, pedH = 254.752},
                }, 
                taskbar = "Writing a prescription", 
                text = "Write a prescription",
                time = math.random(10000, 12000),
                animName = "notepad",
                icon = "fad fa-sticky-note"
            },
            [3] = {
                coords = {
                    [1] = {x = 359.79, y = -599.09, z = 43.284, h = 292.126, pedX = 360.3133, pedY = -598.7917, pedZ = 43.284, pedH = 100.0},
                    [2] = {x = 354.2936, y = -595.6815, z = 43.28407, h = 148.28, pedX = 354.1165, pedY = -596.09, pedZ = 43.28407, pedH = 336.96},
                    [3] = {x = 343.7587, y = -591.225, z = 43.28407, h = 68.6309, pedX = 343.2893, pedY = -591.049, pedZ = 43.28407, pedH = 254.752},
                }, 
                taskbar = "Giving prescription to a patient", 
                text = "Give prescription to a patient",
                time = math.random(1000, 2000),
                animName = "pointdown",
                icon = "fas fa-prescription-bottle-alt"
            },
        },
    },

    ["checking"] = {
       [1] = {x = 307.0954, y = -595.0888, z = 43.28407, h = 0.0},
       [2] = {x = 1830.91, y =  3675.21, z = 34.27, h = 0.0},  
       [3] = {x = -256.10, y =  6329.39, z = 32.40, h = 0.0},  
    },
    
    ["duty"] = {
        [1] = {x = 311.9939, y = -597.4506, z = 43.28407, h = 0.0},
        [2] = {x = 1831.203, y = 3677.483, z = 34.2748, h = 0.0},
    },
    ["owner"] = {
        [1] = {x = 334.90, y = -594.17, z = 43.28, h = 0.0},  
    },    
    ["outfits"] = {
        [1] = {x = 302.2114, y = -598.7358, z = 43.2840, h = 0.0},
        [2] = {x = 1836.671, y = 3685.261, z = 34.27488, h = 0.0},
    }, 
    ["vehicle"] = {
        [1] = {x = 326.81, y = -571.46, z = 28.79, h = 338.46},
        [2] = {x = -234.28, y = 6329.16, z = 32.15, h = 222.5},
        [3] = {x = 1842.758, y = 3708.26, z = 33.468, h = 21.72},
    },
    ["helicopter"] = {
        [1] = {x = 351.58, y = -587.45, z = 74.16, h = 160.5},
        [2] = {x = -475.43, y = 5988.353, z = 31.716, h = 31.34},
    },    
    ["armory"] = {
        [1] = {x = 311.6803, y = -592.6854, z = 43.2840, h = 90.654},
        [2] = {x = 1824.964, y = 3669.002, z = 34.27488, h = 90.654},
    },
    ["surgeryBeds"] = {
        [1] = {x = 326.84, y = -570.85, z = 43.45, h = 158.49},
        [2] = {x = 321.10, y = -568.13, z = 43.45, h = 168.09},
        [3] = {x = 315.25, y = -566.61, z = 43.45, h = 155.78},
    },
    ["roof"] = {
        [1] = {x = 338.5, y = -583.85, z = 74.16, h = 245.5},
    },
    ["main"] = {
        [1] = {x = 332.4131, y = -595.6936, z = 43.28402, h = 76.0},
    },   
    ["outside"] = {
        [1] = {x = 342.19, y = -585.54, z = 28.79, h = 248.48},
    },
    ["mainsecond"] = {
        [1] = {x = 330.2602, y = -601.1281, z = 43.284, h = 76.0},
    },      
    ["beds"] = {
        [1] = {x = 311.1684, y = -582.8666, z = 43.10397, h = 335.5, taken = false, model = 1631638868},
        [2] = {x = 314.5634, y = -584.069, z = 43.10397, h = 335.5, taken = false, model = 1631638868},
        [3] = {x = 317.721, y = -585.4333, z = 43.10397, h = 335.5, taken = false, model = 1631638868},
        [4] = {x = 322.5979, y = -587.163, z = 43.10397, h = 335.5, taken = false, model = 1631638868},
    },
    ["sandyBeds"] = {
        [1] = {x = 1820.202, y = 3669.533, z = 35.19, h = 298.30, taken = false, model = 2117668672},
        [2] = {x = 1823.229, y = 3672.328, z = 35.19, h = 119.13, taken = false, model = 2117668672},
        [3] = {x = 1822.256, y = 3674.124, z = 35.19, h = 124.14, taken = false, model = 2117668672},
        [4] = {x = 1819.118, y = 3671.242, z = 35.19, h = 296.35, taken = false, model = 2117668672},
        [5] = {x = 1818.152, y = 3673.00, z = 35.19, h = 297.53, taken = false, model = 2117668672},
    },
    ["paletoBeds"] = {
        [1] = {x = -260.25, y = 6319.38, z = 33.30, h = 42.33, taken = false, model = 1631638868},
        [2] = {x = -261.95, y = 6317.71, z = 33.30, h = 42.33, taken = false, model = 1631638868},
        [3] = {x = -265.89, y = 6319.62, z = 33.30, h = 222.53, taken = false, model = 1631638868},
        [4] = {x = -267.98, y = 6317.65, z = 33.30, h = 226.71, taken = false, model = 1631638868},
    },
    ["prisonbeds"] = {
        [1] = {x = 1777.81, y = 2565.31, z = 46.72, h = 1.17},
        [2] = {x = 1777.74, y = 2563.13, z = 46.72, h = 352.23},
        [3] = {x = 1777.92, y = 2561.20, z = 46.72, h = 12.08},
    }
}

Config.patientAIs = {
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
        'a_f_y_bevhills_02',
        'a_f_y_bevhills_03',
        'a_f_y_bevhills_04',
        'a_f_y_business_01',
        'a_f_y_business_02',
        'a_f_y_business_03',
        'a_f_y_business_04',
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
    },
    [2] = {
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

Config.DoctorJobs = {
    doctor = {
        [1] = {job = "makepills", label = "Laboratory Tasks"},
        [2] = {job = "consultpatient", label = "Consult Patients"},
    },
    nurse = {
        [1] = {job = "cleanbeds", label = "Clean Beds"},
        [2] = {job = "sterilize", label = "Sterilize Equipment"},
    }
}

Config.Vehicles = {
    ["ambulance"] = "EMS Ambulance",
    ["qrv"] = "Ford Explorer QRV 2016",
}

Config.Helicopter = { ["maverick"] = "Maverick" }

-- NEEDS ECONOMY CHANGES (Hospital shop prices for EMS)
Config.Items = {
    label = "EMS Shop",
    slots = 30,
    items = {
        [1] = {
            name = "radio",
            price = 100,
            amount = 50,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "bandage",
            price = 15,
            amount = 1000,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "walkingstick",
            price = 0,
            amount = 100,
            info = {},
            type = "item",
            slot = 3,
        },
    }
}

Config.BillCost = 300
Config.DeathTime = 300
Config.CheckTime = 10

Config.PainkillerInterval = 60 -- seconds

--[[
    GENERAL SETTINGS | THESE WILL AFFECT YOUR ENTIRE SERVER SO BE SURE TO SET THESE CORRECTLY
    MaxHp : Maximum HP Allowed, set to -1 if you want to disable mythic_hospital from setting this
        NOTE: Anything under 100 and you are dead
    RegenRate : 
]]
Config.MaxHp = 200
Config.RegenRate = 0.0

--[[
    HealthDamage : How Much Damage To Direct HP Must Be Applied Before Checks For Damage Happens
    ArmorDamage : How Much Damage To Armor Must Be Applied Before Checks For Damage Happens | NOTE: This will in turn make stagger effect with armor happen only after that damage occurs
]]
Config.HealthDamage = 5
Config.ArmorDamage = 5

--[[
    MaxInjuryChanceMulti : How many times the HealthDamage value above can divide into damage taken before damage is forced to be applied
    ForceInjury : Maximum amount of damage a player can take before limb damage & effects are forced to occur
]]
Config.MaxInjuryChanceMulti = 3
Config.ForceInjury = 35
Config.AlwaysBleedChance = 70

--[[
    Message Timer : How long it will take to display limb/bleed message
]]
Config.MessageTimer = 12

--[[
    AIHealTimer : How long it will take to be healed after checking in, in seconds
]]
Config.AIHealTimer = 20

--[[ 
    BleedTickRate : How much time, in seconds, between bleed ticks
]]
Config.BleedTickRate = 30

--[[
    BleedMovementTick : How many seconds is taken away from the bleed tick rate if the player is walking, jogging, or sprinting
    BleedMovementAdvance : How Much Time Moving While Bleeding Adds (This Adds This Value To The Tick Count, Meaing The Above BleedTickRate Will Be Reached Faster)
]]
Config.BleedMovementTick = 10
Config.BleedMovementAdvance = 3

--[[
    The Base Damage That Is Multiplied By Bleed Level Every Time A Bleed Tick Occurs
]]
Config.BleedTickDamage = 8

--[[
    FadeOutTimer : How many bleed ticks occur before fadeout happens
    BlackoutTimer : How many bleed ticks occur before blacking out
    AdvanceBleedTimer : How many bleed ticks occur before bleed level increases
]]
Config.FadeOutTimer = 2
Config.BlackoutTimer = 10
Config.AdvanceBleedTimer = 10

--[[
    HeadInjuryTimer : How much time, in seconds, do head injury effects chance occur
    ArmInjuryTimer : How much time, in seconds, do arm injury effects chance occur
    LegInjuryTimer : How much time, in seconds, do leg injury effects chance occur
]]
Config.HeadInjuryTimer = 30
Config.ArmInjuryTimer = 30
Config.LegInjuryTimer = 15

--[[
    The Chance, In Percent, That Certain Injury Side-Effects Get Applied
]]
Config.HeadInjuryChance = 25
Config.ArmInjuryChance = 25
Config.LegInjuryChance = {
    Running = 50,
    Walking = 15
}

--[[
    MajorArmoredBleedChance : The % Chance Someone Gets A Bleed Effect Applied When Taking Major Damage With Armor
    MajorDoubleBleed : % Chance You Have To Receive Double Bleed Effect From Major Damage, This % is halved if the player has armor
]]
Config.MajorArmoredBleedChance = 45

--[[
    DamgeMinorToMajor : How much damage would have to be applied for a minor weapon to be considered a major damage event. Put this at 100 if you want to disable it
]]
Config.DamageMinorToMajor = 35

--[[
    AlertShowInfo : 
]]
Config.AlertShowInfo = 2

--[[
    These following lists uses tables defined in definitions.lua, you can technically use the hardcoded values but for sake
    of ensuring future updates doesn't break it I'd highly suggest you check that file for the index you're wanting to use.

    MinorInjurWeapons : Damage From These Weapons Will Apply Only Minor Injuries
    MajorInjurWeapons : Damage From These Weapons Will Apply Only Major Injuries
    AlwaysBleedChanceWeapons : Weapons that're in the included weapon classes will roll for a chance to apply a bleed effect if the damage wasn't enough to trigger an injury chance
    CriticalAreas : 
    StaggerAreas : These are the body areas that would cause a stagger is hit by firearms,
        Table Values: Armored = Can This Cause Stagger If Wearing Armor, Major = % Chance You Get Staggered By Major Damage, Minor = % Chance You Get Staggered By Minor Damage
]]

Config.WeaponClasses = {
    ['SMALL_CALIBER'] = 1,
    ['MEDIUM_CALIBER'] = 2,
    ['HIGH_CALIBER'] = 3,
    ['SHOTGUN'] = 4,
    ['CUTTING'] = 5,
    ['LIGHT_IMPACT'] = 6,
    ['HEAVY_IMPACT'] = 7,
    ['EXPLOSIVE'] = 8,
    ['FIRE'] = 9,
    ['SUFFOCATING'] = 10,
    ['OTHER'] = 11,
    ['WILDLIFE'] = 12,
    ['NOTHING'] = 13
}

Config.MinorInjurWeapons = {
    [Config.WeaponClasses['SMALL_CALIBER']] = true,
    [Config.WeaponClasses['MEDIUM_CALIBER']] = true,
    [Config.WeaponClasses['CUTTING']] = true,
    [Config.WeaponClasses['WILDLIFE']] = true,
    [Config.WeaponClasses['OTHER']] = true,
    [Config.WeaponClasses['LIGHT_IMPACT']] = true,
}

Config.MajorInjurWeapons = {
    [Config.WeaponClasses['HIGH_CALIBER']] = true,
    [Config.WeaponClasses['HEAVY_IMPACT']] = true,
    [Config.WeaponClasses['SHOTGUN']] = true,
    [Config.WeaponClasses['EXPLOSIVE']] = true,
}

Config.AlwaysBleedChanceWeapons = {
    [Config.WeaponClasses['SMALL_CALIBER']] = true,
    [Config.WeaponClasses['MEDIUM_CALIBER']] = true,
    [Config.WeaponClasses['CUTTING']] = true,
    [Config.WeaponClasses['WILDLIFE']] = false,
}

Config.ForceInjuryWeapons = {
    [Config.WeaponClasses['HIGH_CALIBER']] = true,
    [Config.WeaponClasses['HEAVY_IMPACT']] = true,
    [Config.WeaponClasses['EXPLOSIVE']] = true,
}

Config.CriticalAreas = {
    ['UPPER_BODY'] = { armored = false },
    ['LOWER_BODY'] = { armored = true },
    ['SPINE'] = { armored = true },
}

Config.StaggerAreas = {
    ['SPINE'] = { armored = true, major = 60, minor = 30 },
    ['UPPER_BODY'] = { armored = false, major = 60, minor = 30 },
    ['LLEG'] = { armored = true, major = 100, minor = 85 },
    ['RLEG'] = { armored = true, major = 100, minor = 85 },
    ['LFOOT'] = { armored = true, major = 100, minor = 100 },
    ['RFOOT'] = { armored = true, major = 100, minor = 100 },
}

Config.WoundStates = {
    'irritated',
    'irritated',
    'painful',
    'very painful',
}

Config.BleedingStates = {
    [1] = {label = 'bleeding', damage = 10, chance = 50},
    [2] = {label = 'bleeding reasonably', damage = 15, chance = 65},
    [3] = {label = 'bleeding a lot', damage = 20, chance = 65},
    [4] = {label = 'bleeding heavily', damage = 25, chance = 75},
}

Config.MovementRate = {
    0.98,
    0.96,
    0.94,
    0.92,
}

Config.Bones = {
    [0]     = 'NONE',
    [31085] = 'HEAD',
    [31086] = 'HEAD',
    [39317] = 'NECK',
    [57597] = 'SPINE',
    [23553] = 'SPINE',
    [24816] = 'SPINE',
    [24817] = 'SPINE',
    [24818] = 'SPINE',
    [10706] = 'UPPER_BODY',
    [64729] = 'UPPER_BODY',
    [11816] = 'LOWER_BODY',
    [45509] = 'LARM',
    [61163] = 'LARM',
    [18905] = 'LHAND',
    [4089] = 'LFINGER',
    [4090] = 'LFINGER',
    [4137] = 'LFINGER',
    [4138] = 'LFINGER',
    [4153] = 'LFINGER',
    [4154] = 'LFINGER',
    [4169] = 'LFINGER',
    [4170] = 'LFINGER',
    [4185] = 'LFINGER',
    [4186] = 'LFINGER',
    [26610] = 'LFINGER',
    [26611] = 'LFINGER',
    [26612] = 'LFINGER',
    [26613] = 'LFINGER',
    [26614] = 'LFINGER',
    [58271] = 'LLEG',
    [63931] = 'LLEG',
    [2108] = 'LFOOT',
    [14201] = 'LFOOT',
    [40269] = 'RARM',
    [28252] = 'RARM',
    [57005] = 'RHAND',
    [58866] = 'RFINGER',
    [58867] = 'RFINGER',
    [58868] = 'RFINGER',
    [58869] = 'RFINGER',
    [58870] = 'RFINGER',
    [64016] = 'RFINGER',
    [64017] = 'RFINGER',
    [64064] = 'RFINGER',
    [64065] = 'RFINGER',
    [64080] = 'RFINGER',
    [64081] = 'RFINGER',
    [64096] = 'RFINGER',
    [64097] = 'RFINGER',
    [64112] = 'RFINGER',
    [64113] = 'RFINGER',
    [36864] = 'RLEG',
    [51826] = 'RLEG',
    [20781] = 'RFOOT',
    [52301] = 'RFOOT',
}

Config.BoneIndexes = {
    ['NONE'] = 0,
    ['HEAD'] = 31085,
    ['HEAD'] = 31086,
    ['NECK'] = 39317, 
    ['SPINE'] = 57597,
    ['SPINE'] = 23553,
    ['SPINE'] = 24816,
    ['SPINE'] = 24817,
    ['SPINE'] = 24818,
    ['UPPER_BODY'] = 10706,
    ['UPPER_BODY'] = 64729,
    ['LOWER_BODY'] = 11816,
    ['LARM'] = 45509,
    ['LARM'] = 61163,
    ['LHAND'] = 18905,
    ['LFINGER'] = 4089,
    ['LFINGER'] = 4090,
    ['LFINGER'] = 4137,
    ['LFINGER'] = 4138,
    ['LFINGER'] = 4153,
    ['LFINGER'] = 4154,
    ['LFINGER'] = 4169,
    ['LFINGER'] = 4170,
    ['LFINGER'] = 4185,
    ['LFINGER'] = 4186,
    ['LFINGER'] = 26610,
    ['LFINGER'] = 26611,
    ['LFINGER'] = 26612,
    ['LFINGER'] = 26613,
    ['LFINGER'] = 26614,
    ['LLEG'] = 58271,
    ['LLEG'] = 63931,
    ['LFOOT'] = 2108,
    ['LFOOT'] = 14201,
    ['RARM'] = 40269,
    ['RARM'] = 28252,
    ['RHAND'] = 57005,
    ['RFINGER'] = 58866,
    ['RFINGER'] = 58867,
    ['RFINGER'] = 58868,
    ['RFINGER'] = 58869,
    ['RFINGER'] = 58870,
    ['RFINGER'] = 64016,
    ['RFINGER'] = 64017,
    ['RFINGER'] = 64064,
    ['RFINGER'] = 64065,
    ['RFINGER'] = 64080,
    ['RFINGER'] = 64081,
    ['RFINGER'] = 64096,
    ['RFINGER'] = 64097,
    ['RFINGER'] = 64112,
    ['RFINGER'] = 64113,
    ['RLEG'] = 36864,
    ['RLEG'] = 51826,
    ['RFOOT'] = 20781,
    ['RFOOT'] = 52301,
}

Config.Weapons = {
    [`WEAPON_STUNGUN`] = Config.WeaponClasses['NONE'],
    --[[ Small Caliber ]]--
    [`WEAPON_PISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_COMBATPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_APPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_COMBATPDW`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_MACHINEPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_MICROSMG`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_MINISMG`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_PISTOL_MK2`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_SNSPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_SNSPISTOL_MK2`] = Config.WeaponClasses['SMALL_CALIBER'],
    [`WEAPON_VINTAGEPISTOL`] = Config.WeaponClasses['SMALL_CALIBER'],

    --[[ Medium Caliber ]]--
    [`WEAPON_ADVANCEDRIFLE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_ASSAULTSMG`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_BULLPUPRIFLE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_BULLPUPRIFLE_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_CARBINERIFLE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_CARBINERIFLE_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_COMPACTRIFLE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_DOUBLEACTION`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_GUSENBERG`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_HEAVYPISTOL`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_MARKSMANPISTOL`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_PISTOL50`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_REVOLVER`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_REVOLVER_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SMG`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SMG_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SPECIALCARBINE`] = Config.WeaponClasses['MEDIUM_CALIBER'],
    [`WEAPON_SPECIALCARBINE_MK2`] = Config.WeaponClasses['MEDIUM_CALIBER'],

    --[[ High Caliber ]]--
    [`WEAPON_ASSAULTRIFLE`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_ASSAULTRIFLE_MK2`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_COMBATMG`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_COMBATMG_MK2`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_HEAVYSNIPER`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_HEAVYSNIPER_MK2`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MARKSMANRIFLE`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MARKSMANRIFLE_MK2`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MG`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MINIGUN`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_MUSKET`] = Config.WeaponClasses['HIGH_CALIBER'],
    [`WEAPON_RAILGUN`] = Config.WeaponClasses['HIGH_CALIBER'],

    --[[ Shotguns ]]--
    [`WEAPON_ASSAULTSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_BULLUPSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_DBSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_HEAVYSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_PUMPSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_PUMPSHOTGUN_MK2`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_SAWNOFFSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],
    [`WEAPON_SWEEPERSHOTGUN`] = Config.WeaponClasses['SHOTGUN'],

    --[[ Animals ]]--
    [`WEAPON_ANIMAL`] = Config.WeaponClasses['WILDLIFE'], -- Animal
    [`WEAPON_COUGAR`] = Config.WeaponClasses['WILDLIFE'], -- Cougar
    [`WEAPON_BARBED_WIRE`] = Config.WeaponClasses['WILDLIFE'], -- Barbed Wire
    
    --[[ Cutting Weapons ]]--
    [`WEAPON_BATTLEAXE`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_BOTTLE`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_DAGGER`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_HATCHET`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_KNIFE`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_MACHETE`] = Config.WeaponClasses['CUTTING'],
    [`WEAPON_SWITCHBLADE`] = Config.WeaponClasses['CUTTING'],

    --[[ Light Impact ]]--
    [`WEAPON_KNUCKLE`] = Config.WeaponClasses['LIGHT_IMPACT'],
    
    --[[ Heavy Impact ]]--
    [`WEAPON_BAT`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_CROWBAR`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_FIREEXTINGUISHER`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_FIRWORK`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_GOLFLCUB`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_HAMMER`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_PETROLCAN`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_POOLCUE`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_WRENCH`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_RAMMED_BY_CAR`] = Config.WeaponClasses['HEAVY_IMPACT'],
    [`WEAPON_RUN_OVER_BY_CAR`] = Config.WeaponClasses['HEAVY_IMPACT'],
    
    --[[ Explosives ]]--
    [`WEAPON_EXPLOSION`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_GRENADE`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_COMPACTLAUNCHER`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_HOMINGLAUNCHER`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_PIPEBOMB`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_PROXMINE`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_RPG`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_STICKYBOMB`] = Config.WeaponClasses['EXPLOSIVE'],
    [`WEAPON_HELI_CRASH`] = Config.WeaponClasses['EXPLOSIVE'],
    
    --[[ Other ]]--
    [`WEAPON_FALL`] = Config.WeaponClasses['OTHER'], -- Fall
    [`WEAPON_HIT_BY_WATER_CANNON`] = Config.WeaponClasses['OTHER'], -- Water Cannon
    
    --[[ Fire ]]--
    [`WEAPON_ELECTRIC_FENCE`] = Config.WeaponClasses['FIRE'],
    [`WEAPON_FIRE`] = Config.WeaponClasses['FIRE'],
    [`WEAPON_MOLOTOV`] = Config.WeaponClasses['FIRE'],
    [`WEAPON_FLARE`] = Config.WeaponClasses['FIRE'],
    [`WEAPON_FLAREGUN`] = Config.WeaponClasses['FIRE'],

    --[[ Suffocate ]]--
    [`WEAPON_DROWNING`] = Config.WeaponClasses['SUFFOCATING'], -- Drowning
    [`WEAPON_DROWNING_IN_VEHICLE`] = Config.WeaponClasses['SUFFOCATING'], -- Drowning Veh
    [`WEAPON_EXHAUSTION`] = Config.WeaponClasses['SUFFOCATING'], -- Exhaust
    [`WEAPON_BZGAS`] = Config.WeaponClasses['SUFFOCATING'],
    [`WEAPON_SMOKEGRENADE`] = Config.WeaponClasses['SUFFOCATING'],
}