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

-- NEEDS ECONOMY CHANGES
Config.BailPrice = 100

Config.DropPrice = math.random(50, 70)

Config.Vehicles = {
    ["pony"] = "Delivery vehicle",
}

Config.Locations = {
    ["pickup"] = {x = -523.33, y =  -2897.449, z =  6.0},
    ["pickupcayo"] = {x = 5118.51, y = -5179.15, z = 2.26},
    ["pickupbar"] = {x = -1922.82, y = 2047.298, z = 140.73},

    ["stores"] ={
        ["ltdgasoline"] = {
            name = "ltdgasoline",
            coords = {x = -41.07, y = -1747.91, z = 29.4, h = 137.5},
            vehicle = {x = -43.42, y = -1743.126, z = 29.24, h = 46.23},
            paycheck = {x = -44.18, y =  -1749.38, z = 29.42},
            owner = {x = -42.21, y = -1749.07, z = 29.42},
            duty = {x =  -45.59, y = -1750.71, z = 29.42}                                         
        },
        ["247supermarket"] = {
            name = "247supermarket",
            coords = {x = 31.62, y = -1315.87, z = 29.52, h = 179.5},
            vehicle = {x = 26.46, y = -1314.68, z = 29.62, h = 0.95},
            paycheck = {x = 29.156 , y = -1339.52, z = 29.49},
            owner = {x = 31.02 , y = -1340.033 , z = 29.47},
            duty = {x =   31.04, y = -1339.16, z = 29.49}    
        },
        ["robsliquor"] = {
            name = "robsliquor",
            coords = {x = -1226.48, y = -907.58, z = 12.32, h = 119.5},
            vehicle = {x = -43.42, y = -1743.126, z = 29.24, h = 46.23},
            paycheck = {x = -44.18, y =  -1749.38, z = 29.42},
            owner = {x = -42.21, y = -1749.07, z = 29.42}
        },
        ["ltdgasoline2"] = {
            name = "ltdgasoline2",
            coords = {x = -714.13, y = -909.13, z = 19.21, h = 0.5},
            vehicle = {x = -723.36, y = -913.22, z = 19.01, h = 86.23},
            paycheck = {x = -709.55, y =  -905.55, z = 19.21},
            owner = {x = -708.16, y = -903.65 , z = 19.21},
            duty = {x = -709.82, y = -907.32, z =  19.21}   
        },
        ["robsliquor2"] = {
            name = "robsliquor2",
            coords = {x = -1469.78, y = -366.72, z = 40.2, h = 138.5},
            vehicle = {x = -43.42, y = -1743.126, z = 29.24, h = 46.23},
            paycheck = {x = -44.18, y =  -1749.38, z = 29.42},
            owner = {x = -42.21, y = -1749.07, z = 29.42}
        },
        ["ltdgasoline3"] = {
            name = "ltdgasoline3",
            coords = {x = -1829.15, y = 791.99, z = 138.26, h = 46.5},
            vehicle = {x = -1815.902, y = 798.40, z = 138.17, h = 222.23},  
            paycheck = {x = -1828.302, y = 797.87, z = 138.18},  
            owner = {x = -1828.56, y = 800.25, z = 138.16},  
            duty = {x = -1827.11, y =  796.372, z =  138.18}   
        },
        ["robsliquor3"] = {
            name = "robsliquor3",
            coords = {x = -2959.92, y = 396.77, z = 15.02, h = 178.5},
            vehicle = {x = -43.42, y = -1743.126, z = 29.24, h = 46.23},
            paycheck = {x = -44.18, y =  -1749.38, z = 29.42},
            owner = {x = -42.21, y = -1749.07, z = 29.42}
        },
        ["247supermarket2"] = {
            name = "247supermarket2",
            coords = {x = -3047.58, y = 589.89, z = 7.78, h = 199.5},
            vehicle = {x = -3051.988, y = 592.34, z = 7.5, h = 20.27},   
            paycheck = {x = -3047.88, y =  586.267, z = 7.9},  
            owner = {x = -3047.823, y = 588.78, z = 7.9},
            duty = {x = -3048.31, y =   588.03, z =  7.91}     
        },
        ["247supermarket3"] = {
            name = "247supermarket3",
            coords = {x = -3245.85, y = 1008.25, z = 12.83, h = 90.5},
            vehicle = {x = -3252.031, y = 994.3383, z = 12.47, h = 265.23},   
            paycheck = {x = -3249.834, y = 1004.989, z = 12.83},  
            owner = {x = -3248.83, y = 1007.24, z = 12.83},
            duty = {x = -3249.431, y = 1006.92, z = 12.83}  
        },
        ["247supermarket4"] = {
            name = "247supermarket4",
            coords = {x = 1735.54, y = 6416.28, z = 35.03, h = 332.5},
            vehicle = {x = 1722.97, y = 6425.43, z = 33.75, h = 150.54},   
            paycheck = {x = 1735.18, y =  6420.48, z = 35.03},  
            owner = {x = 1737.11, y = 6418.69, z = 35.03},
            duty = {x =  1736.77, y = 6419.77, z = 35.03}   
        },
        ["247supermarket5"] = {
            name = "247supermarket5",
            coords = {x = 1702.84, y = 4917.28, z = 42.22, h = 323.5},  
            vehicle = {x =  1696.24, y = 4917.04, z =  42.07, h = 54.25},  
            paycheck = {x = 1706.926, y = 4920.97, z = 42.06},
            owner = {x = 1707.60, y = 4918.89, z = 42.06},
            duty = {x =   1705.34, y = 4922.327, z =42.06 }   
        },
        ["247supermarket6"] = {
            name = "247supermarket6",
            coords = {x = 1960.47, y = 3753.59, z = 32.26, h = 127.5},
            vehicle = {x = 1967.40, y =  3754.62, z = 32.22, h = 46.23},   
            paycheck = {x = 1959.89, y = 3749.09, z = 32.34},   
            owner = {x = 1962.87, y = 3749.17, z = 32.34},
            duty = {x =  1961.24, y = 3749.88, z = 32.34 }    
        },
        ["robsliquor4"] = {
            name = "robsliquor4",
            coords = {x = 1169.27, y = 2707.7, z = 38.15, h = 267.5},
            vehicle = {x = -43.42, y = -1743.126, z = 29.24, h = 46.23},
            paycheck = {x = -44.18, y =  -1749.38, z = 29.42},
            owner = {x = -42.21, y = -1749.07, z = 29.42}
        },
        ["247supermarket7"] = {
            name = "247supermarket7",
            coords = {x = 543.47, y = 2658.81, z = 42.17, h = 277.5},
            vehicle = {x = 541.41, y =2658.69, z = 42.16, h =  95.50},    
            paycheck = {x = 545.89, y =  2662.87, z =  42.15},
            owner = {x = 542.99, y = 2663.72, z =  42.15}, 
            duty = {x =  543.75, y = 2662.82, z = 42.15 }   
        },
        ["247supermarket8"] = {
            name = "247supermarket8",
            coords = {x = 2678.09, y = 3288.43, z = 55.24, h = 61.5},
            vehicle = {x = 2659.23, y = 3261.76, z =  55.24, h = 147.81},  
            paycheck = {x = 2673.16, y = 3287.21, z =  55.24},  
            owner = {x = 2675.79, y =  3288.68, z = 55.24},
            duty = {x =  2673.94, y =3288.50, z = 55.24 }   
        },
        ["ltdgasoline4"] = {
            name = "ltdgasoline4",
            coords = {x = 1155.97, y = -319.76, z = 69.2, h = 17.5},
            vehicle = {x =  1153.72, y = -331.27, z = 68.90, h = 182.96},  
            paycheck = {x = 1159.73, y = -314.99, z = 69.20},   
            owner = {x = 1160.93, y =  -313.04, z = 69.20},
            duty = {x = 1159.97, y = -317.17, z = 69.20}  
        },
        ["robsliquor5"] = {
            name = "robsliquor5",
            coords = {x = 1119.78, y = -983.99, z = 46.29, h = 287.5},
            vehicle = {x = -43.42, y = -1743.126, z = 29.24, h = 46.23},
            paycheck = {x = -44.18, y =  -1749.38, z = 29.42},
            owner = {x = -42.21, y = -1749.07, z = 29.42}
        },
        ["247supermarket9"] = {
            name = "247supermarket9",
            coords = {x = 382.13, y = 326.2, z = 103.56, h = 253.5},
            vehicle = {x = 368.20, y =  340.94, z =103.20, h = 161.48},   
            paycheck = {x = 378.73, y =   333.07, z =  103.56}, 
            owner = {x = 380.78, y =  331.08, z = 103.56},
            duty = {x =  2549.42, y =387.10, z =  108.62}   
        },
        ["247supermarketcayo"] = {
            name = "247supermarketcayo",
            coords = {x = 4487.316, y = -4465.25, z = 4.2, h = 253.5},
            vehicle = {x = 4471.99, y = -4466.05, z = 4.24, h = 196.48},   
            paycheck = {x = 4480.39, y = -4461.37, z = 4.25}, 
            owner = {x = 4483.33, y = -4461.77, z = 4.25},
            duty = {x =  4476.68, y = -4462.54, z = 4.2}  
        },
        ["galaxy"] = {
            name = "galaxy",
            coords = {x = 383.5327, y = 257.67, z = 92.04, h = 253.5},
            vehicle = {x = 397.52, y =  263.52, z = 92.05, h = 157.26},   
            paycheck = {x = 389.258, y = 272.62, z = 94.99}, 
            owner = {x = 390.82, y = 269.79, z = 94.99},
            duty = {x = 379.19, y = 258.67, z = 92.18},
            blips = {
                inside = {x = 403.21, y = 244.70 , z = 92.74 },
                outside = {x = 323.06, y = 264.26, z = 104.37 },
            }
        },
        ["bahamas"] = {
            name = "bahamas",
            coords = {x =-1394.425, y =  -628.09, z = 30.31, h = 253.5},
            vehicle = {x = -1390.36, y = -633.44, z = 28.69, h = 157.26},   
            paycheck = {x = -1366.88, y = -621.189, z = 30.329}, 
            owner = {x = -1365.17, y = -623.52, z = 30.32},
            duty = {x = -1367.77, y = -613.15, z = 30.31}  
        },
        ["cockatoos"] = {
            name = "cockatoos",
            coords = {x = -434.51, y = -35.92, z = 40.87},
            vehicle = {x = -455.31, y = -51.28, z = 44.51, h = 83.19},   
            paycheck = {x = -450.04, y = -48.64, z = 44.52}, 
            owner = {x = -442.94, y = -37.24, z = 40.87},
            duty = {x=-443.16, y = -35.27, z = 40.867}  
        },
        ["vanilla"] = {
            name = "vanilla",
            coords = {x = 135.66, y = -1279.12, z = 29.31},
            vehicle = {x = 147.36, y = -1279.18, z = 29.04, h = 207.11},
            paycheck = {x = -450.04, y = -48.64, z = 44.52}, 
            owner = {x = -442.94, y = -37.24, z = 40.87},
            duty = {x=-443.16, y = -35.27, z = 40.867}  
        },
        [18] = {
            name = "hardware",
            coords = {x = 89.33, y = -1745.44, z = 30.08, h = 143.5},
        },
        [19] = {
            name = "hardware2",
            coords = {x = 2704.09, y = 3457.55, z = 55.53, h = 339.5},
        },
    },
}

-- BestWay Deliveries