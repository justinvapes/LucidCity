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

Config.BinObjects = {
    "prop_bin_05a",
}

Config.PickableItems = {
    ["pc"] = true,
    ["tv1"] = true,
    ["tv2"] = true,
    ["painting1"] = true,
    ["painting2"] = true,
    ["painting3"] = true,
    ["bust"] = true,
}

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

MaxInventorySlots = 40

BackEngineVehicles = {
    'ninef',
    'adder',
    'vagner',
    't20',
    'infernus',
    'zentorno',
    'reaper',
    'comet2',
    'comet3',
    'jester',
    'jester2',
    'cheetah',
    'cheetah2',
    'prototipo',
    'turismor',
    'pfister811',
    'ardent',
    'nero',
    'nero2',
    'tempesta',
    'vacca',
    'bullet',
    'osiris',
    'entityxf',
    'turismo2',
    'fmj',
    're7b',
    'tyrus',
    'italigtb',
    'penetrator',
    'monroe',
    'ninef2',
    'stingergt',
    'surfer',
    'surfer2',
    'comet3',
}

Config.MaximumAmmoValues = {
    ["pistol"] = 250,
    ["smg"] = 250,
    ["shotgun"] = 200,
    ["rifle"] = 250,
}

--CRAFTING

Config.CraftingItems = {
    [1] = {
        name = "lockpick",
        amount = 1000,
        info = {},
        costs = {
            ["metalscrap"] = 5,
            ["plastic"] = 7,
        },
        type = "item",
        slot = 1,
        threshold = 0,
        points = 1,
        blueprintType = nil,
    },
    [2] = {
        name = "screwdriverset",
        amount = 1000,
        info = {},
        costs = {
            ["metalscrap"] = 3,
            ["plastic"] = 5,
        },
        type = "item",
        slot = 2,
        threshold = 0,
        points = 2,
        blueprintType = nil,
    },
    [3] = {
        name = "electronickit",
        amount = 1000,
        info = {},
        costs = {
            ["metalscrap"] = 30,
            ["plastic"] = 45,
            ["aluminum"] = 28,
        },
        type = "item",
        slot = 3,
        threshold = 0,
        points = 2,
        blueprintType = nil,
    },
    [4] = {
        name = "handcuffs",
        amount = 1000,
        info = {},
        costs = {
            ["metalscrap"] = 36,
            ["steel"] = 24,
            ["aluminum"] = 28,
        },
        type = "item",
        slot = 4,
        threshold = 50,
        points = 2,
        blueprintType = nil,
    },
    [5] = {
        name = "pistol_ammo",
        amount = 1000,
        info = {},
        costs = {
            ["metalscrap"] = 50,
            ["steel"] = 37,
            ["copper"] = 26,
        },
        type = "item",
        slot = 5,
        threshold = 250,
        points = 2,
        blueprintType = nil,
    },
    [6] = {
        name = "gun_trigger",
        amount = 1000,
        info = {},
        costs = {
            ["plastic"] = 90,
            ["aluminum"] = 2,
            ["metalscrap"] = 10,
        },
        type = "item",
        slot = 6,
        threshold = 300,
        points = 2,
        blueprintType = nil,
    },

    [7] = {
        name = "pistol_slide",
        amount = 1000,
        info = {},
        costs = {
            ["plastic"] = 80,
            ["aluminum"] = 3,
            ["metalscrap"] = 15,
        },
        type = "item",
        slot = 7,
        threshold = 300,
        points = 2,
        blueprintType = nil,
    },

    [8] = {
        name = "pistol_grip",
        amount = 1000,
        info = {},
        costs = {
            ["plastic"] = 60,
            ["aluminum"] = 5,
            ["metalscrap"] = 20,
        },
        type = "item",
        slot = 8,
        threshold = 300,
        points = 2,
        blueprintType = nil,
    },

    [9] = {
        name = "pistol_clip",
        amount = 1000,
        info = {},
        costs = {
            ["plastic"] = 100,
            ["aluminum"] = 5,
            ["metalscrap"] = 10,
        },
        type = "item",
        slot = 9,
        threshold = 300,
        points = 2,
        blueprintType = nil,
    },
    [10] = {
        name = "weapon_combatpistol",
        amount = 1000,
        info = {},
        costs = {
            ["pistol_clip"] = 1,
            ["pistol_grip"] = 1,
            ["pistol_slide"] = 1,
            ["gun_trigger"] = 1,
        },
        type = "item",
        slot = 10,
        threshold = 300,
        points = 5,
        blueprintType = nil,
    },
    [11] = {
        name = "ironoxide",
        amount = 1000,
        info = {},
        costs = {
            ["iron"] = 60,
            ["glass"] = 30,
        },
        type = "item",
        slot = 11,
        threshold = 300,
        points = 2,
        blueprintType = nil,
    },
    [12] = {
        name = "aluminumoxide",
        amount = 1000,
        info = {},
        costs = {
            ["aluminum"] = 60,
            ["glass"] = 30,
        },
        type = "item",
        slot = 12,
        threshold = 300,
        points = 2,
        blueprintType = nil,
    },
    [13] = {
        name = "pistol_extendedclip",
        amount = 1000,
        info = {},
        costs = {
            ["metalscrap"] = 140,
            ["steel"] = 190,
            ["rubber"] = 60,
        },
        type = "item",
        slot = 13,
        threshold = 350,
        points = 2,
        blueprintType = nil,
    },
    [14] = {
        name = "armor",
        amount = 1000,
        info = {},
        costs = {
            ["iron"] = 33,
            ["steel"] = 44,
            ["plastic"] = 55,
            ["aluminum"] = 22,
        },
        type = "item",
        slot = 14,
        threshold = 400,
        points = 2,
        blueprintType = nil,
    },
    [15] = {
        name = "pistol_suppressor",
        amount = 1000,
        info = {},
        costs = {
            ["metalscrap"] = 165,
            ["steel"] = 180,
            ["rubber"] = 75,
        },
        type = "item",
        slot = 15,
        threshold = 420,
        points = 2,
        blueprintType = nil,
    },
    [16] = {
        name = "smg_extendedclip",
        amount = 1000,
        info = {},
        costs = {
            ["metalscrap"] = 255,
            ["steel"] = 210,
            ["rubber"] = 145,
        },
        type = "item",
        slot = 16,
        threshold = 450,
        points = 3,
        blueprintType = nil,
    },
    [17] = {
        name = "wep_flashlight",
        amount = 1000,
        info = {},
        costs = {
            ["metalscrap"] = 230,
            ["steel"] = 110,
            ["rubber"] = 130,
        },
        type = "item",
        slot = 17,
        threshold = 460,
        points = 3,
        blueprintType = nil,
    },
    [18] = {
        name = "smg_suppressor",
        amount = 1000,
        info = {},
        costs = {
            ["metalscrap"] = 270,
            ["steel"] = 260,
            ["rubber"] = 155,
        },
        type = "item",
        slot = 18,
        threshold = 590,
        points = 3,
        blueprintType = nil,
    },
    [19] = {
        name = "dot_scope",
        amount = 1000,
        info = {},
        costs = {
            ["metalscrap"] = 300,
            ["steel"] = 150,
            ["rubber"] = 170,
        },
        type = "item",
        slot = 19,
        threshold = 600,
        points = 3,
        blueprintType = nil,
    },
    [20] = {
        name = "weapon_microsmg",
        amount = 1000,
        info = {},
        costs = {
            ["aluminum"] = 20,
            ["pistol_grip"] = 1,
            ["metal_spring"] = 2,
            ["gun_trigger"] = 1,
            ["bolt_assembly"] = 1,
            ["smg_magazine"] = 1,
            ["smg_extractor"] = 1,
            ["smg_barrel"] = 1,
        },
        type = "item",
        slot = 20,
        threshold = 600,
        points = 6,
        blueprintType = nil,
    },
    [21] = {
        name = "rifle_extendedclip",
        amount = 1000,
        info = {},
        costs = {
            ["metalscrap"] = 190,
            ["steel"] = 305,
            ["rubber"] = 85,
            ["smg_extendedclip"] = 1,
        },
        type = "item",
        slot = 21,
        threshold = 800,
        points = 8,
        blueprintType = nil,
    },
    [22] = {
        name = "rifle_drummag",
        amount = 1000,
        info = {},
        costs = {
            ["metalscrap"] = 85,
            ["steel"] = 44,
            ["rubber"] = 30,
        },
        type = "item",
        slot = 22,
        threshold = 950,
        points = 8,
        blueprintType = nil,
    },
    [23] = {
        name = "WEAPON_ASSAULTRIFLE",
        amount = 1000,
        info = {},
        costs = {
            ["aluminum"] = 40,
            ["gun_trigger"] = 1,
            ["metal_spring"] = 2,
            ["ak_barrel"] = 1,
            ["ak_magazine"] = 1,
            ["ak_stock"] = 1,
            ["plastic"] = 400,
            ["ak_bolt"] = 1,
            ["ak_barrel_pin"] = 1,
            ["ak_piston_pin"] = 1,
            ["ak_receiver_cover"] = 1,
        },
        type = "item",
        slot = 23,
        threshold = 2200,
        points = 9,
        blueprintType = nil,
    },
    -- Blueprint --
    [24] = {
        name = "WEAPON_SPECIALCARBINE",
        amount = 1000,
        info = {},
        costs = {
            ["aluminum"] = 20,
            ["gun_trigger"] = 1,
            ["metal_spring"] = 2,
            ["rifle_stock"] = 1,
            ["rifle_stock_tube"] = 1,
            ["rifle_grip"] = 1,
            ["plastic"] = 200,
        },
        type = "item",
        slot = 24,
        threshold = 99999999,
        points = 8,
        blueprintType = "SPECIALCARBINE",
    },
    [25] = {
        name = "WEAPON_COMBATMG",
        amount = 1000,
        info = {},
        costs = {
            ["aluminum"] = 20,
            ["gun_trigger"] = 1,
            ["metal_spring"] = 2,
            ["rifle_stock"] = 1,
            ["rifle_stock_tube"] = 1,
            ["rifle_grip"] = 1,
            ["plastic"] = 300,
        },
        type = "item",
        slot = 25,
        threshold = 99999999,
        points = 8,
        blueprintType = "COMBATMG",
    },
    [26] = {
        name = "WEAPON_GUSENBERG",
        amount = 1000,
        info = {},
        costs = {
            ["aluminum"] = 20,
            ["gun_trigger"] = 1,
            ["metal_spring"] = 2,
            ["rifle_stock"] = 1,
            ["rifle_stock_tube"] = 1,
            ["rifle_grip"] = 1,
            ["plastic"] = 420,
        },
        type = "item",
        slot = 26,
        threshold = 99999999,
        points = 8,
        blueprintType = "GUSENBERG",
    },
    [27] = {
        name = "WEAPON_BULLPUPRIFLE",
        amount = 1000,
        info = {},
        costs = {
            ["aluminum"] = 20,
            ["gun_trigger"] = 1,
            ["metal_spring"] = 2,
            ["rifle_stock"] = 1,
            ["rifle_stock_tube"] = 1,
            ["rifle_grip"] = 1,
            ["plastic"] = 300,
        },
        type = "item",
        slot = 27,
        threshold = 99999999,
        points = 8,
        blueprintType = "BULLPUPRIFLE",
    },
}