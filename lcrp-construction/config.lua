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

Config = Config or {}

Config.CurrentProject = 1
-- NEEDS ECONOMY CHANGES (PRICE PER ONE TASK)
Config.TaskPrice = 50

Config.Projects = {
    [1] = {
        IsActive = false,
        ProjectLocations = {
            ["main"] = {
                label = "Loc 1",
                coords = {x = 141.46, y = -379.73, z = 43.25, h = 92.5, r = 1.0},
            },
            ["tasks"] = {
                -- HAMMERING
                [1] = {
                    coords = {x = 96.34, y = -415.27, z = 37.55, h = 248.92, r = 1.0},
                    type = "hammer",
                    completed = false,
                    label = "Hammering",
                    IsBusy = false,
                },
                [2] = {
                    coords = {x = 86.41, y = -442.61, z = 37.55, h = 11.5, r = 1.0},
                    type = "hammer",
                    completed = false,
                    label = "Hammering",
                    IsBusy = false,
                },
                [3] = {
                    coords = {x = 82.62, y = -457.00, z = 37.55, h = 11.5, r = 1.0},
                    type = "hammer",
                    completed = false,
                    label = "Hammering",
                    IsBusy = false,
                },
                -- WELDING
                [4] = {
                    coords = {x = 105.29, y = -357.02, z = 55.49, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [5] = {
                    coords = {x = 101.58, y = -366.93, z = 55.49, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [6] = {
                    coords = {x = 98.75, y = -376.44, z = 55.49, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [7] = {
                    coords = {x = 115.96, y = -360.92, z = 55.49, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [8] = {
                    coords = {x = 119.52, y = -351.14, z = 55.92, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [9] = {
                    coords = {x = 108.80, y = -347.37, z = 55.49, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [10] = {
                    coords = {x = 80.12, y = -342.66, z = 55.50, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [11] = {
                    coords = {x = 72.04, y = -339.81, z = 55.50, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [12] = {
                    coords = {x = 51.13, y = -346.32, z = 55.50, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [13] = {
                    coords = {x = 92.08, y = -361.24, z = 67.14, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [14] = {
                    coords = {x = 88.22, y = -371.87, z = 67.14, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [15] = {
                    coords = {x = 109.51, y = -379.69, z = 67.31, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [16] = {
                    coords = {x = 60.52, y = -319.89, z = 67.14, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [17] = {
                    coords = {x = 45.16, y = -424.38, z = 45.50, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [18] = {
                    coords = {x = 39.39, y = -440.27, z = 45.50, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [19] = {
                    coords = {x = 19.66, y = -449.59, z = 45.50, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [20] = {
                    coords = {x = 29.40, y = -418.57, z = 45.55, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [21] = {
                    coords = {x = 15.73, y = -413.62, z = 45.50, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [22] = {
                    coords = {x = 21.99, y = -396.36, z = 45.50, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [23] = {
                    coords = {x = 29.59, y = -398.61, z = 45.50, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [24] = {
                    coords = {x = 35.94, y = -400.82, z = 45.50, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [25] = {
                    coords = {x = 33.83, y = -388.57, z = 45.50, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [26] = {
                    coords = {x = 36.37, y = -377.59, z = 45.50, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [27] = {
                    coords = {x = 44.13, y = -380.33, z = 45.50, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [28] = {
                    coords = {x = 47.70, y = -393.74, z = 45.50, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [29] = {
                    coords = {x = 44.84, y = -404.16, z = 45.50, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
                [30] = {
                    coords = {x = 53.00, y = -383.70, z = 45.50, h = 11.5, r = 1.0},
                    type = "weld",
                    completed = false,
                    label = "Welding",
                    IsBusy = false,
                },
            }
        }
    },
}