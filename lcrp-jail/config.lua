Config = {}

Config.Jobs = {
    [1] = {label = "Janitor"},
    [2] = {label = "Launder"},
    [3] = {label = "Cook"},
}

Config.Locations = {
    jobs = {
        ["Janitor"] = {
            [1] = {coords = {x = 1777.37, y = 2579.61, z = 45.79, h = 357.450}},
            [2] = {coords = {x = 1785.74, y = 2585.47, z = 45.79, h = 272.249}},
            [3] = {coords = {x = 1779.86, y = 2587.74, z = 45.79, h = 358.199}},
            [4] = {coords = {x = 1775.48, y = 2587.44, z = 45.79, h = 272.249}},
            [5] = {coords = {x = 1777.39, y = 2583.76, z = 45.79, h = 272.249}},
            [6] = {coords = {x = 1779.55, y = 2569.18, z = 45.79, h = 272.249}},
            [7] = {coords = {x = 1785.43, y = 2569.00, z = 45.79, h = 272.249}},
            [8] = {coords = {x = 1788.59, y = 2592.55, z = 45.79, h = 272.249}},
            [9] = {coords = {x = 1785.69, y = 2594.64, z = 45.79, h = 272.249}},
        },
        ["Cook"] = {
            [1] = {coords = {x = 1781.35, y = 2599.20, z = 45.79, h = 3.4600, lY = 1.6, lZ = 1.8, dist = 1.5}},
            [2] = {coords = {x = 1776.23, y = 2597.88, z = 45.79, h = 88.880, lY = 2.2, lZ = 1.5, dist = 1.0}},
            [3] = {coords = {x = 1777.92, y = 2597.54, z = 45.79, h = 266.18, lY = 2.2, lZ = 1.5, dist = 1.0}},
            [4] = {coords = {x = 1780.29, y = 2593.61, z = 45.79, h = 179.27, lY = 1.7, lZ = 2.0, dist = 1.0}},
        },
        ["Launder"] = {
            [1] = {
                coords = {
                    [1] = {x = 1766.37, y = 2612.56, z = 50.55, h = 172.90, lY = 1.2, lZ = 2.0},
                },
                action = "pickuplaundry",
                label = "Pick Up Laundry",
                icon = "fad fa-tshirt",
                distance = 2.0,
            },
            [2] = {
                coords = {
                    [1] = {x = 1767.67, y = 2615.1, z = 50.54, h = 262.31, lY = 1.0, lZ = 1.5},
                },
                action = "pickuplaundrydetergent",
                label = "Pickup Laundry Detergent",
                icon = "far fa-box-open",
                distance = 1.5,
            },
            [3] = {
                coords = {
                    [1] = {x = 1769.51, y = 2616.26, z = 50.55, h = 177.05, lY = 1.2, lZ = 1.2},
                    [2] = {x = 1770.87, y = 2616.30, z = 50.54, h = 179.60, lY = 1.2, lZ = 1.2},
                    [3] = {x = 1772.25, y = 2616.32, z = 50.54, h = 179.60, lY = 1.2, lZ = 1.2},
                    [4] = {x = 1773.58, y = 2616.23, z = 50.54, h = 179.60, lY = 1.2, lZ = 1.2},
                    [5] = {x = 1769.57, y = 2612.81, z = 50.54, h = 358.57, lY = 1.2, lZ = 1.2},
                    [6] = {x = 1770.87, y = 2612.78, z = 50.54, h = 358.57, lY = 1.2, lZ = 1.2},
                    [7] = {x = 1772.27, y = 2612.77, z = 50.54, h = 358.57, lY = 1.2, lZ = 1.2},
                    [8] = {x = 1773.60, y = 2612.76, z = 50.54, h = 358.57, lY = 1.2, lZ = 1.2},
                },
                action = "washclothes",
                label = "Wash Clothes",
                icon = "fad fa-washer",
                distance = 1.0,
            },
            [4] = {
                coords = {
                    [1] = {x = 1784.28, y = 2612.03, z = 50.54, h = 1.75, lY = 1.0, lZ = 2.0},
                    [2] = {x = 1784.07, y = 2613.51, z = 50.54, h = 0.01, lY = 1.0, lZ = 2.0},
                    [3] = {x = 1784.27, y = 2614.82, z = 50.54, h = 2.30, lY = 1.0, lZ = 2.0},
                    [4] = {x = 1784.18, y = 2616.10, z = 50.54, h = 355.85, lY = 1.0, lZ = 2.0},
                },
                action = "ironclothes",
                label = "Iron Clothes",
                icon = "fad fa-tshirt",
                distance = 2.0,
            },
            [5] = {
                coords = {
                    [1] = {x = 1768.33, y = 2619.45, z = 50.55, h = 358.80, lY = 2.0, lZ = 2.0},
                    [2] = {x = 1769.19, y = 2611.37, z = 50.55, h = 176.85, lY = 1.0, lZ = 2.2},
                    [3] = {x = 1776.85, y = 2618.88, z = 50.55, h = 4.0588, lY = 1.2, lZ = 2.2},
                },
                action = "placecleanclothes",
                label = "Place Clean Clothes",
                icon = "fal fa-tshirt",
                distance = 1.5,
            },
        },
    },
    spawns = {
        [1] = {
            animation = "chair2",
            coords = {x = 1768.76, y = 2593.57, z = 50.55015, h = 265.42},
        },
        [2] = {
            animation = "chair4",
            coords = {x = 1769.523, y = 2580.781, z = 50.55011, h = 358.83},
        },
        [3] = {
            animation = "lean4",
            coords = {x = 1774.971, y = 2567.248, z = 50.55017, h = 355.28},
        },
        [4] = {
            animation = "sleep",
            coords = {x = 1789.381, y = 2572.567, z = 52.02425, h = 345.78},
        },
        [5] = {
            animation = "sit7",
            coords = {x = 1791.072, y = 2584.476, z = 50.55015, h = 2.55},
        },
        [6] = {
            animation = "sit4",
            coords = {x = 1787.239, y = 2601.586, z = 52.00962, h = 95.60},
        },
        [7] = {
            animation = "chair",
            coords = {x = 1768.92, y = 2584.72, z = 45.79, h = 2.73},
        },
        [8] = {
            animation = "sleep",
            coords = {x = 1769.273, y = 2579.415, z = 47.27129, h = 172.61},
        },
        [9] = {
            animation = "chair2",
            coords = {x = 1790.512, y = 2574.216, z = 45.7984, h = 85.26, r = 1.0}, 
        },
        [10] = {
            animation = "chair4",
            coords = {x = 1789.812, y = 2582.96, z = 45.79845, h = 180.31, r = 1.0}, 
        },
    },
    ["freedom"] = {
        coords = {x = 1788.83, y = 2596.44, z = 45.8, h = 0, r = 1.0}, 
    },
    ["outside"] = {
        coords = {x = 1846.30, y = 2585.83, z = 45.67, h = 269.5}, 
    },
    ["yard"] = {
        coords = {x = 1723.92, y = 2535.21, z = 45.56, h = 1.5}, 
    },
    ["middle"] = {
        coords = {x = 1779.62, y = 2581.03, z = 45.79, h = 1.077},
    },
    ["shop"] = {
        coords = {x = 1779.549, y = 2589.75, z = 45.79, h = 0.5},
    },
    ["changeJob"] = {
        coords = {x = 1763.77, y = 2604.6, z = 50.55, h = 40.0,},
    },
    ["guardArmory"] = {
        coords = {x = 1776.77, y = 2543.52, z = 45.8, h = 40.0},
    },
    ["guardDuty"] = {
        coords = {x = 1782.99, y = 2543.34, z = 45.8, h = 0.0},
    },
    ["guardStash"] = {
        coords = {x = 1785.35, y = 2541.6, z = 45.8, h = 0.0},
    },
    ["guardClothing"] = {
        coords = {x = 1778.46, y = 2547.8, z = 45.8, h = 0.0},
    },
    ["guardAlarm"] = {
        coords = {x = 1777.13, y = 2592.69, z = 50.55, h = 0.0},
    },
}

Config.CanteenItems = {
    [1] = {
        name = "sandwich",
        price = 4,
        amount = 50,
        info = {},
        type = "item",
        slot = 1,
    },
    [2] = {
        name = "water_bottle",
        price = 4,
        amount = 50,
        info = {},
        type = "item",
        slot = 2,
    },
}