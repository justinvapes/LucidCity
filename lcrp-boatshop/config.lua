Boatshop = Boatshop or {}
Diving = Diving or {}

Boatshop.PoliceBoat = {
    x = -800.67, 
    y = -1494.54, 
    z = 1.59,
}

Boatshop.PoliceBoatSpawn = {
    x = -793.58, 
    y = -1501.4, 
    z = 0.12,
    h = 111.5,
}

Boatshop.PoliceBoatSpawn2 = {
    x = -293.10, 
    y = 6642.69, 
    z = 0.15,
    h = 65.5,
}

Boatshop.Docks = {
    ["lsymc"] = {
        label = "Boat Garage",
        coords = {
            take = {
                x = -794.66, 
                y = -1510.83, 
                z = 1.59,
            },
            put = {
                x = -793.58, 
                y = -1501.4, 
                z = 0.12,
                h = 111.5,
            }
        }
    },
    ["paletto"] = {
        label = "Paleto Boats",
        coords = {
            take = {
                x = -277.46, 
                y = 6637.2, 
                z = 7.48,
            },
            put = {
                x = -289.2, 
                y = 6637.96, 
                z = 1.01,
                h = 45.5,
            }
        }
    },    
    ["millars"] = {
        label = "Millars Boats",
        coords = {
            take = {
                x = 1299.24, 
                y = 4216.69, 
                z = 33.9, 
            },
            put = {
                x = 1297.82, 
                y = 4209.61, 
                z = 30.12, 
                h = 253.5,
            }
        }
    },
}

Boatshop.Depots = {
    ["lsymc"] = {
        label = "Boat Impound",
        coords = {
            take = {
                x = -772.98, 
                y = -1430.76, 
                z = 1.59, 
            },
            put = {
                x = -729.77, 
                y = -1355.49, 
                z = 1.19, 
                h = 142.5,
            }
        }
    },
}

Boatshop.Locations = {
    ["berths"] = {
        [1] = {
            ["boatModel"] = "marquis",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -725.05,
                    ["y"] = -1328.25,
                    ["z"] = 1.06,
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -723.3,
                    ["y"] = -1323.61,
                    ["z"] = 1.59,
                }
            },
            ["inUse"] = false
        },
        [2] = {
            ["boatModel"] = "toro",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -732.84, 
                    ["y"] = -1333.5, 
                    ["z"] = 1.59, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -729.19, 
                    ["y"] = -1330.58, 
                    ["z"] = 1.67, 
                },
            },
            ["inUse"] = false
        },
        [3] = {
            ["boatModel"] = "speeder",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -738.80,  
                    ["y"] = -1340.44, 
                    ["z"] = 0.69, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -734.98, 
                    ["y"] = -1337.42, 
                    ["z"] = 1.67, 
                },
            },
            ["inUse"] = false
        },
        [4] = {
            ["boatModel"] = "jetmax",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -743.53, 
                    ["y"] = -1347.7, 
                    ["z"] = 0.79, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -740.62, 
                    ["y"] = -1344.28, 
                    ["z"] = 1.67, 
                },
            },
            ["inUse"] = false
        },
        [5] = {
            ["boatModel"] = "tropic",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -749.59, 
                    ["y"] = -1354.88, 
                    ["z"] = 0.79, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -746.6, 
                    ["y"] = -1351.36, 
                    ["z"] = 1.59, 
                },
            },
            ["inUse"] = false
        },
        [6] = {
            ["boatModel"] = "suntrap",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -755.39, 
                    ["y"] = -1361.76, 
                    ["z"] = 0.79, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -752.49,
                    ["y"] = -1358.28,
                    ["z"] = 1.59,
                },
            },
            ["inUse"] = false
        },
        [7] = {
            ["boatModel"] = "dinghy",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -769.06, 
                    ["y"] = -1377.97, 
                    ["z"] = 0.79, 
                    ["h"] = 229.5
                },
                ["buy"] = {
                    ["x"] = -723.3,
                    ["y"] = -1323.61,
                    ["z"] = 1.59,
            }
            },
            ["inUse"] = false
        },
        [8] = {
            ["boatModel"] = "seashark",
            ["coords"] = {
                ["boat"] = {
                    ["x"] = -774.99, 
                    ["y"] = -1385.0, 
                    ["z"] = 0.79, 
                    ["h"] = 229.5
            },
            ["buy"] = {
                    ["x"] = -723.3,
                    ["y"] = -1323.61,
                    ["z"] = 1.59,
                }
            },
            ["inUse"] = false
        },
        -- [9] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -780.66, 
        --             ["y"] = -1391.73, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [10] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -786.47, 
        --             ["y"] = -1398.6, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [11] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -792.27, 
        --             ["y"] = -1405.48, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
        -- [12] = {
        --     ["boatModel"] = "dinghy",
        --     ["coords"] = {
        --         ["boat"] = {
        --             ["x"] = -798.33, 
        --             ["y"] = -1412.67, 
        --             ["z"] = 0.79, 
        --             ["h"] = 229.5
        --         },
        --         ["buy"] = {
        --             ["x"] = -723.3,
        --             ["y"] = -1323.61,
        --             ["z"] = 1.59,
        --         }
        --     },
        --     ["inUse"] = false
        -- },
    }
}

-- NEEDS ECONOMY CHANGES
Boatshop.ShopBoats = {
    ["dinghy"] = {
        ["model"] = "dinghy",
        ["label"] = "Dinghy",
        ["price"] = 25000
    },
    ["speeder"] = {
        ["model"] = "speeder",
        ["label"] = "Speeder",
        ["price"] = 50000
    },
    ["marquis"] = {
        ["model"] = "marquis",
        ["label"] = "Marquis",
        ["price"] = 150000
    },
    ["jetmax"] = {
        ["model"] = "jetmax",
        ["label"] = "Jetmax",
        ["price"] = 75000
    },
    ["tropic"] = {
        ["model"] = "tropic",
        ["label"] = "Tropic",
        ["price"] = 40000
    },
    ["seashark"] = {
        ["model"] = "seashark",
        ["label"] = "Seashark",
        ["price"] = 10000
    },
    ["toro"] = {
        ["model"] = "toro",
        ["label"] = "Toro",
        ["price"] = 150000
    },
    ["suntrap"] = {
        ["model"] = "suntrap",
        ["label"] = "Suntrap",
        ["price"] = 35000
    }
}

Boatshop.SpawnVehicle = {
    x = -729.77, 
    y = -1355.49, 
    z = 1.19, 
    h = 142.5,
}

Diving.CoralTypes = {
    [1] = {
        item = "dendrogyra_coral",
        maxAmount = math.random(2, 7),
        price = math.random(20, 60),
    },
    [2] = {
        item = "antipatharia_coral",
        maxAmount = math.random(2, 7),
        price = math.random(20, 50),
    }
}

Diving.SellLocations = {
    [1] = {
        ["coords"] = {
            ["x"] = -1686.9, 
            ["y"] = -1072.23, 
            ["z"] = 13.15
        }
    }
}