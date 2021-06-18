Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

Config = Config or {}

Config.DurabilityBlockedWeapons = {
    "weapon_unarmed",
}

Config.DurabilityMultiplier = {
    -- WEAPONS
    ["weapon_unarmed"] 				 = 0.15,
    ["weapon_flashlight"] 			 = 0.05,
    ["weapon_knife"] 				 = 0.15,
    ["weapon_nightstick"] 			 = 0.15,
    ["weapon_hammer"] 				 = 0.15,
    ["weapon_bat"] 					 = 0.15,
    ["weapon_golfclub"] 			 = 0.15,
    ["weapon_crowbar"] 				 = 0.15,
    ["weapon_pistol"] 				 = 0.15,
    ["weapon_pistol_mk2"] 			 = 0.15,
    ["weapon_combatpistol"] 		 = 0.15,
    ["weapon_appistol"] 			 = 0.15,
    ["weapon_pistol50"] 			 = 0.15,
    ["weapon_microsmg"] 			 = 0.15,
    ["weapon_smg"] 				 	 = 0.15,
    ["weapon_assaultsmg"] 			 = 0.15,
    ["weapon_assaultrifle"] 		 = 0.15,
    ["weapon_carbinerifle"] 		 = 0.15,
    ["weapon_carbinerifle_mk2"] 	 = 0.15,
    ["weapon_advancedrifle"] 		 = 0.15,
    ["weapon_mg"] 					 = 0.15,
    ["weapon_combatmg"] 			 = 0.15,
    ["weapon_pumpshotgun"] 			 = 0.15,
    ["weapon_pumpshotgun_mk2"] 		 = 0.15,
    ["weapon_sawnoffshotgun"] 		 = 0.15,
    ["weapon_assaultshotgun"] 		 = 0.15,
    ["weapon_bullpupshotgun"] 		 = 0.15,
    ["weapon_stungun"] 				 = 0.10,
    ["weapon_sniperrifle"] 			 = 0.15,
    ["weapon_heavysniper"] 			 = 0.15,
    ["weapon_remotesniper"] 		 = 0.15,
    ["weapon_grenadelauncher"] 		 = 0.15,
    ["weapon_grenadelauncher_smoke"] = 0.15,
    ["weapon_rpg"] 					 = 0.15,
    ["weapon_minigun"] 				 = 0.15,
    ["weapon_grenade"] 				 = 0.15,
    ["weapon_stickybomb"] 			 = 0.15,
    ["weapon_smokegrenade"] 		 = 0.15,
    ["weapon_bzgas"] 				 = 0.15,
    ["weapon_molotov"] 				 = 0.15,
    ["weapon_fireextinguisher"] 	 = 0.15,
    ["weapon_petrolcan"] 			 = 0.15,
    ["weapon_briefcase"] 			 = 0.15,
    ["weapon_briefcase_02"] 		 = 0.15,
    ["weapon_ball"] 				 = 0.15,
    ["weapon_flare"] 				 = 0.15,
    ["weapon_snspistol"] 			 = 0.15,
    ["weapon_bottle"] 				 = 0.15,
    ["weapon_gusenberg"] 			 = 0.15,
    ["weapon_specialcarbine"] 		 = 0.15,
    ["weapon_heavypistol"] 			 = 0.15,
    ["weapon_bullpuprifle"] 		 = 0.15,
    ["weapon_dagger"] 				 = 0.15,
    ["weapon_vintagepistol"] 		 = 0.15,
    ["weapon_firework"] 			 = 0.15,
    ["weapon_musket"] 			     = 0.15,
    ["weapon_heavyshotgun"] 		 = 0.15,
    ["weapon_marksmanrifle"] 		 = 0.15,
    ["weapon_hominglauncher"] 		 = 0.15,
    ["weapon_proxmine"] 			 = 0.15,
    ["weapon_snowball"] 		     = 0.15,
    ["weapon_flaregun"] 			 = 0.15,
    ["weapon_garbagebag"] 			 = 0.15,
    ["weapon_handcuffs"] 			 = 0.15,
    ["weapon_combatpdw"] 			 = 0.15,
    ["weapon_marksmanpistol"] 		 = 0.15,
    ["weapon_knuckle"] 				 = 0.15,
    ["weapon_hatchet"] 				 = 0.15,
    ["weapon_railgun"] 				 = 0.15,
    ["weapon_machete"] 				 = 0.15,
    ["weapon_machinepistol"] 		 = 0.15,
    ["weapon_switchblade"] 			 = 0.15,
    ["weapon_revolver"] 			 = 0.15,
    ["weapon_dbshotgun"] 			 = 0.15,
    ["weapon_compactrifle"] 		 = 0.15,
    ["weapon_autoshotgun"] 			 = 0.15,
    ["weapon_battleaxe"] 			 = 0.15,
    ["weapon_compactlauncher"] 		 = 0.15,
    ["weapon_minismg"] 				 = 0.15,
    ["weapon_pipebomb"] 			 = 0.15,
    ["weapon_poolcue"] 				 = 0.15,
    ["weapon_wrench"] 				 = 0.15,
    ["weapon_autoshotgun"] 		 	 = 0.15,
    ["weapon_bread"] 				 = 0.15,
}

Config.WeaponRepairPoints = {
    ["ammunation1"] = {
        coords = {x = 6.69 , y = -1100.08, z =  29.79, h = 35.5, r = 1.0},
        IsRepairing = false,
        RepairingData = {},
    },
    ["ammunation2"] = {
        coords = {x = -659.78 , y = -933.12, z = 21.82, h = 35.5, r = 1.0},  
        IsRepairing = false,
        RepairingData = {},
    },
    ["ammunation3"] = {
        coords = {x = 827.07 , y = -2158.58 , z = 29.61, h = 35.5, r = 1.0},  
        IsRepairing = false,
        RepairingData = {},
    },
    ["ammunation4"] = {
        coords = {x = -330.29 , y = 6087.07 , z = 31.45, h = 35.5, r = 1.0},    
        IsRepairing = false,
        RepairingData = {},
    },
    ["ammunation5"] = {
        coords = {x = 253.38 , y = -53.04 , z = 69.94, h = 35.5, r = 1.0},      
        IsRepairing = false,
        RepairingData = {},
    }

}

Config.WeaponRepairCosts = {
    ["pistol"] = 1000,
    ["smg"] = 3000,
    ["rifle"] = 5000,
    ["shotgun"] = 3000
}

Config.WeaponAttachments = {
    ["WEAPON_SNSPISTOL"] = {
        ["pistol_extendedclip"] = {
            component = "COMPONENT_SNSPISTOL_CLIP_02",
            label = "Extended Clip",
            item = "pistol_extendedclip",
        },
    },
    ["WEAPON_VINTAGEPISTOL"] = {
        ["pistol_suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP",
            label = "Suppresor",
            item = "pistol_suppressor",
        },
        ["pistol_extendedclip"] = {
            component = "COMPONENT_VINTAGEPISTOL_CLIP_02",
            label = "Extended Clip",
            item = "pistol_extendedclip",
        },
    },
    ["WEAPON_PISTOL"] = {
        ["pistol_suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP_02",
            label = "Suppresor",
            item = "pistol_suppressor",
        },   
        ["pistol_extendedclip"] = {
            component = "COMPONENT_PISTOL_CLIP_02",
            label = "Extended Clip",
            item = "pistol_extendedclip",
        },                                                  
    },
    ["WEAPON_COMBATPISTOL"] = {
        ["pistol_suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP",
            label = "Suppresor",
            item = "pistol_suppressor",
        },   
        ["pistol_extendedclip"] = {
            component = "COMPONENT_COMBATPISTOL_CLIP_02",
            label = "Extended Clip",
            item = "pistol_extendedclip",
        },                                                  
    },
    ["WEAPON_MICROSMG"] = {
        ["smg_suppressor"] = {
            component = "COMPONENT_AT_AR_SUPP_02",
            label = "Suppresor",
            item = "smg_suppressor",
        },
        ["smg_extendedclip"] = {
            component = "COMPONENT_MICROSMG_CLIP_02",
            label = "Extended Clip",
            item = "smg_extendedclip",
        },
        ["flashlight"] = {
            component = "COMPONENT_AT_PI_FLSH",
            label = "Flashlight",
            item = "wep_flashlight",
        },
        ["scope"] = {
            component = "COMPONENT_AT_SCOPE_MACRO",
            label = "Scope",
            item = "dot_scope",
        },
    },
    ["WEAPON_MINISMG"] = {
        ["smg_extendedclip"] = {
            component = "COMPONENT_MINISMG_CLIP_02",
            label = "Extended Clip",
            item = "smg_extendedclip",
        },
    },
    ["WEAPON_COMPACTRIFLE"] = {
        ["rifle_extendedclip"] = {
            component = "COMPONENT_COMPACTRIFLE_CLIP_02",
            label = "Extended Clip",
            item = "rifle_extendedclip",
        },
        ["rifle_drummag"] = {
            component = "COMPONENT_COMPACTRIFLE_CLIP_03",
            label = "Drum Mag",
            item = "rifle_drummag",
        },
    },
    ["WEAPON_CARBINERIFLE"] = {
        ["rifle_extendedclip"] = {
            component = "COMPONENT_CARBINERIFLE_CLIP_02",
            label = "Extended Clip",
            item = "rifle_extendedclip",
        },
        ["scope"] = {
            component = "COMPONENT_AT_SCOPE_MEDIUM",
            label = "Scope",
            item = "dot_scope",
        },
        ["rifle_suppressor"] = {
            component = "COMPONENT_AT_AR_SUPP",
            label = "Suppresor",
            item = "rifle_suppressor",
        },
        ["grip"] = {
            component = "COMPONENT_AT_AR_AFGRIP",
            label = "Grip",
            item = "rifle_comp_grip",
        },
        ["flashlight"] = {
            component = "COMPONENT_AT_AR_FLSH",
            label = "Flashlight",
            item = "weapon_flashlight",
        },
    },
    ["WEAPON_ASSAULTRIFLE"] = {
        ["rifle_extendedclip"] = {
            component = "COMPONENT_ASSAULTRIFLE_CLIP_02",
            label = "Extended Clip",
            item = "rifle_extendedclip",
        },
        ["rifle_drummag"] = {
            component = "COMPONENT_ASSAULTRIFLE_CLIP_03",
            label = "Drum Mag",
            item = "rifle_drummag",
        },
        ["scope"] = {
            component = "COMPONENT_AT_SCOPE_MACRO",
            label = "Scope",
            item = "dot_scope",
        },
        ["rifle_suppressor"] = {
            component = "COMPONENT_AT_AR_SUPP_02",
            label = "Suppresor",
            item = "rifle_suppressor",
        },
        ["grip"] = {
            component = "COMPONENT_AT_AR_AFGRIP",
            label = "Grip",
            item = "rifle_comp_grip",
        },
    },
}

Config.Locations = {
    ["ammunation1"] = {
        ["counter"] = {x = 21.65, y=  -1105.18, z =  29.79},
        ["weapon"] = {x = 21.43 , y = -1105.753 , z = 29.79, canBuy = false, price = 0, weapon = nil, shop = "ammunation1"},
        ["duty"] = {x = 4.93, y =  -1104.861, z =  29.79},
        ["chiefactions"] = {x = 23.89, y =  -1107.667, z =  29.79},
        ["stockup"] = {x = 13.88, y =  -1106.204, z =  29.79},
        ["assemble"] = {x = 16.77, y =  -1110.58, z =  29.79},
        ["shop"] = {x = 22.29, y = -1107.32, z = 29.79}
    },
    ["ammunation2"] = {
        ["counter"] = {x = -663.2574, y=  -933.45, z = 21.82},
        ["weapon"] = {x = -663.2836 , y = -934.201 , z = 21.82, canBuy = false, price = 0, weapon = nil, shop = "ammunation2"},
        ["duty"] = {x = -666.58, y =  -933.59, z = 21.82},  
        ["chiefactions"] = {x = -659.70, y =  -935.45, z = 21.8},  
        ["stockup"] = {x = -660.95, y =  -942.89, z = 21.82},
        ["assemble"] = {x = -666.11, y = -940.33, z = 21.82},
        ["shop"] = {x = -661.92, y = -935.24, z = 21.82}
    },
    ["ammunation3"] = {
        ["counter"] = {x = 811.34, y= -2159.134, z = 29.61},
        ["weapon"] = {x = 810.89 , y = -2158.4 , z = 29.61, canBuy = false, price = 0, weapon = nil, shop = "ammunation3"},    
        ["duty"] = {x = 826.916, y =  -2153.36, z =  29.61},  
        ["chiefactions"] = {x = 808.20, y = -2157.21, z = 29.61}, 
        ["stockup"] = {x = 818.0, y =  -2155.64, z = 29.61},  
        ["assemble"] = {x = 813.96, y =  -2152.32, z =  29.61},
        ["shop"] = {x = 809.75, y = -2157.19, z = 29.61}      
    },
    ["ammunation4"] = {
        ["counter"] = {x = -332.31, y=  6084.27, z =  31.45},  
        ["weapon"] = {x = -331.77 , y = 6083.92 , z = 31.45, canBuy = false, price = 0, weapon = nil, shop = "ammunation4"},  
        ["duty"] = {x = -334.55, y = 6081.812, z = 31.45},  
        ["chiefactions"] = {x = -328.32, y =  6085.28, z =  31.45},  
        ["stockup"] = {x = -323.98, y = 6079.03, z = 31.45},  
        ["assemble"] = {x = -329.59, y =  6077.52, z =  31.45},
        ["shop"] = {x = -330.13, y = 6084.26, z = 31.45}
    },
    ["ammunation5"] = {
        ["counter"] = {x = 254.19, y=  -49.61, z =  69.94},  
        ["weapon"] = {x = 253.47 , y = -49.66, z = 69.94, canBuy = false, price = 0, weapon = nil, shop = "ammunation5"},  
        ["duty"] = {x = 255.20, y =  -46.55, z =  69.94},  
        ["chiefactions"] = {x = 251.05, y =  -52.04, z =  69.94}, 
        ["stockup"] = {x = 244.31, y =  -48.41, z = 69.94},
        ["assemble"] = {x = 248.64, y = -44.66, z =  69.94},
        ["shop"] = {x = 251.94 , y = -50.37, z = 69.94}   
    }
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