Config = {}

Config.AttachedVehicle = nil

Config.Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}
-- Head mechanics
Config.AuthorizedIds = {
    "VUD42991",
}

Config.MaxStatusValues = {
    ["engine"] = 1000.0,
    ["body"] = 1000.0,
    ["radiator"] = 100,
    ["axle"] = 100,
    ["brakes"] = 100,
    ["clutch"] = 100,
    ["fuel"] = 100,
}

Config.ValuesLabels = {
    ["engine"] = "Engine",
    ["body"] = "Body",
    ["radiator"] = "Radiator",
    ["axle"] = "Axle",
    ["brakes"] = "Brakes",
    ["clutch"] = "Clutch",
    ["fuel"] = "Fuel",
}

Config.RepairCost = {
    ["body"] = "plastic",
    ["radiator"] = "plastic",
    ["axle"] = "steel",
    ["brakes"] = "iron",
    ["clutch"] = "aluminum",
    ["fuel"] = "plastic",
}

Config.RepairCostAmount = {
    ["engine"] = {
        item = "metalscrap",
        costs = 2,
    },
    ["body"] = {
        item = "plastic",
        costs = 3,
    },
    ["radiator"] = {
        item = "steel",
        costs = 5,
    },
    ["axle"] = {
        item = "aluminum",
        costs = 7,
    },
    ["brakes"] = {
        item = "copper",
        costs = 5,
    },
    ["clutch"] = {
        item = "copper",
        costs = 6,
    },
    ["fuel"] = {
        item = "plastic",
        costs = 5,
    },
}

Config.Businesses = {
    "cykarepairs",
}

Config.Plates = {
    [1] = {
        coords = {x = -211.93, y = -1324.73, z = 30.89, h = 271.5, r = 1.0},
        AttachedVehicle = nil,
    },
    [2] = {
        coords = {x = 922.37, y = -979.86, z = 39.49, h = 271.5, r = 1.0}, 
        AttachedVehicle = nil,
    },
    [3] = {
        coords = {x = 921.54, y = -962.17, z = 39.49, h = 274.5, r = 1.0}, 
        AttachedVehicle = nil,
    },
    [4] = {
        coords = {x = 949.89, y = -947.75, z = 39.49, h = 90.5, r = 1.0}, 
        AttachedVehicle = nil,
    },
}

Config.Blips = {
    {x = -212.368, y = -1325.486, z = 30.176, heading = 141.107},
    --{x = -212.368,y = -1325.486, z = 30.176, heading = 141.107}
}

Config.Locations = {
    ["mechanic"] = {
        ["mod"] = {
           [1] = { isBusy = false, locked = false, camera = {x = -215.518, y = -1329.135, z = 30.89, heading = 329.092}, driveout = {x = -205.935,y = -1316.642, z = 30.176, heading = 356.495}, drivein = {x = -205.626,y = -1314.99, z = 30.247, heading = 179.395}, outside = {x = -205.594,y = -1304.085, z = 30.614, heading = 359.792}, inside = {x = -212.368,y = -1325.486, z = 30.176, heading = 141.107} },
           [2] = { isBusy = false, locked = false, camera = {x = -215.518, y = -1329.135, z = 30.89, heading = 329.092}, driveout = {x = -205.935,y = -1316.642, z = 30.176, heading = 356.495}, drivein = {x = -205.626,y = -1314.99, z = 30.247, heading = 179.395}, outside = {x = -205.594,y = -1304.085, z = 30.614, heading = 268.97}, inside = {x = -224.69, y = -1330.03, z = 30.09, heading = 268.97} },
           [3] = { isBusy = false, locked = false, camera = {x = -215.518, y = -1329.135, z = 30.89, heading = 329.092}, driveout = {x = -205.935,y = -1316.642, z = 30.176, heading = 356.495}, drivein = {x = -205.626,y = -1314.99, z = 30.247, heading = 179.395}, outside = {x = -205.594,y = -1304.085, z = 30.614, heading = 270.45}, inside = {x = -198.61, y = -1324.32, z = 30.33, heading = 270.45} }
        },
    },
    ["mechanic2"] = {
        ["mod"] = {
           [1] = { isBusy = false, locked = false, camera = {x = -215.518, y = -1329.135, z = 38.86, heading = 329.092}, driveout = {x = -205.935,y = -1316.642, z = 38.86, heading = 356.495}, drivein = {x = -205.626,y = -1314.99, z = 38.86, heading = 179.395}, outside = {x = -205.594,y = -1304.085, z = 38.86, heading = 249.72}, inside = {x = -327.67, y =  -140.07, z = 38.86, heading = 249.72} },
           [2] = { isBusy = false, locked = false, camera = {x = -215.518, y = -1329.135, z = 38.86, heading = 329.092}, driveout = {x = -205.935,y = -1316.642, z = 38.86, heading = 356.495}, drivein = {x = -205.626,y = -1314.99, z = 38.86, heading = 179.395}, outside = {x = -205.594,y = -1304.085, z = 38.86, heading = 249.72}, inside = {x = -329.11, y = -144.21, z = 38.86, heading = 249.72} },
           [3] = { isBusy = false, locked = false, camera = {x = -215.518, y = -1329.135, z = 38.86, heading = 329.092}, driveout = {x = -205.935,y = -1316.642, z = 38.86, heading = 356.495}, drivein = {x = -205.626,y = -1314.99, z = 38.86, heading = 179.395}, outside = {x = -205.594,y = -1304.085, z = 38.86, heading = 270.45}, inside = {x = -339.67, y = -131.99, z = 39.01, heading = 67.72} }
        },
    },
}

Config.Vehicles = {
    ["towtruck"] = "Tow Truck",
    ["towtruck2"] = "Tow Truck small",
}

Config.MinimalMetersForDamage = {
    [1] = {
        min = 8000,
        max = 12000,
        multiplier = {
            min = 1,
            max = 8,
        }
    },
    [2] = {
        min = 12000,
        max = 16000,
        multiplier = {
            min = 8,
            max = 16,
        }
    },
    [3] = {
        min = 12000,
        max = 16000,
        multiplier = {
            min = 16,
            max = 24,
        }
    },
}

Config.Damages = {
    ["radiator"] = "Radiator",
    ["axle"] = "Axle",
    ["brakes"] = "Brakes",
    ["clutch"] = "Clutch",
    ["fuel"] = "Fuel",
}