Config = {
    License = 'e58dbf0b613853ea4f9beb7560d2f274', -- Insert your rcore license
}

-- Recommended models
---- prop_arm_wrestle_01
---- bkr_prop_clubhouse_arm_wrestle_01a
---- bkr_prop_clubhouse_arm_wrestle_02a

TABLES = {
    {
        pos = vector3(-191.9174, 6273.261, 30.97095),
        model = 'prop_arm_wrestle_01',
        headingOffset = 90.0, -- sets player's relative heading to the object's heading
        blip = true, -- display blip on map
    },
    {
        pos = vector3(-2306.671, 4384.029, 8.857883),
        model = 'prop_arm_wrestle_01',
        headingOffset = 90.0,
        blip = false,
    },
    {
        pos = vector3(-2310.07, 4377.478, 8.988294),
        model = 'prop_arm_wrestle_01',
        headingOffset = 90.0,
        blip = false,
    },
    {
        pos = vector3(-2598.874, 3577.567, 3.974104),
        model = 'prop_arm_wrestle_01',
        headingOffset = 90.0,
        blip = false,
    },
    {
        pos = vector3(-82.4445, -1327.784, 28.75201),
        model = 'prop_arm_wrestle_01',
        headingOffset = 90.0,
        blip = true,
    },
    {
        pos = vector3(-828.2763, 5903.012, 5.790941),
        model = 'prop_arm_wrestle_01',
        headingOffset = 90.0,
        blip = false,
    },
    {
        pos = vector3(1051.675, 2663.61, 39.02627),
        model = 'prop_arm_wrestle_01',
        headingOffset = 90.0,
        blip = true,
    },
    {
        pos = vector3(1221.215, 2726.056, 37.50376),
        model = 'prop_arm_wrestle_01',
        headingOffset = 90.0,
        blip = false,
    },
    {
        pos = vector3(1443.34, -2219.01, 60.34895),
        model = 'prop_arm_wrestle_01',
        headingOffset = 90.0,
        blip = false,
    },
    {
        pos = vector3(1685.719, 4970.387, 42.09595),
        model = 'prop_arm_wrestle_01',
        headingOffset = 90.0,
        blip = true,
    },
    {
        pos = vector3(1980.815, 3058.477, 46.66528),
        model = 'prop_arm_wrestle_01',
        headingOffset = 90.0,
        blip = false,
    },
    {
        pos = vector3(2340.869, 3130.47, 47.68394),
        model = 'prop_arm_wrestle_01',
        headingOffset = 90.0,
        blip = false,
    },
    {
        pos = vector3(2512.31, -1217.473, 2.266815),
        model = 'prop_arm_wrestle_01',
        headingOffset = 90.0,
        blip = false,
    },
    {
        pos = vector3(270.2247, 2603.959, 44.23094),
        model = 'prop_arm_wrestle_01',
        headingOffset = 90.0,
        blip = false,
    },
    {
        pos = vector3(369.0918, -2445.448, 5.51899),
        model = 'prop_arm_wrestle_01',
        headingOffset = 90.0,
        blip = true,
    },
    {
        pos = vector3(4521.664, -4512.708, 3.982008),
        model = 'prop_arm_wrestle_01',
        headingOffset = 90.0,
        blip = false,
    },
    {
        pos = vector3(901.9729, -172.1309, 73.56619),
        model = 'prop_arm_wrestle_01',
        headingOffset = 90.0,
        blip = false,
    },
}

--[[
    How long after starting the match does the match timeout without setting a winner
]]
MATCH_TIMEOUT = 5 * 60 * 1000

--[[
    Determines how many keypresses from one player over another is required to win
    We've tested 10 to be fair difficulty, but you can make it lower to make games faster
]]
MATH_FINAL_WIN_COUNT = 10

--[[
    Color of countdown (3 - 2 - 1) background and color of GO background
]]
COUNTDOWN_COLOR = {r = 196, g = 158, b = 61}
GO_COLOR = {r = 94, g = 154, b = 89}

--[[
    Checkpoint color
]]
CHECKPOINT_COLOR = {r = 255, g = 0, b = 0, a = 100}

--[[
    Translation of end of countdown
    Blip/Control translation is configured in it's section
]]
LANGUAGE = {
    GO = 'GO'
}

--[[
    Blip settings
]]
BLIP_CONFIG = {
    sprite = 311,
    color = 0,
    label = 'Arm Wrestling',
    scale = 1.0,
}

--[[
    For control numbers and labels, see https://docs.fivem.net/docs/game-references/controls/
]]
CONTROLS = {
    PLAY = {
        CONTROL = 38,
        CONTROL_LABEL = 'INPUT_PICKUP',
        TEXT = 'Arm Wrestle',
    },
    QUIT = {
        CONTROL = 38,
        CONTROL_LABEL = 'INPUT_PICKUP',
        TEXT = 'Quit',
    },
    MASH_A = {
        CONTROL = 35,
        CONTROL_LABEL = 'INPUT_MOVE_RIGHT_ONLY',
        TEXT = 'Wrestle',
    },
    MASH_B = {
        CONTROL = 34,
        CONTROL_LABEL = 'INPUT_MOVE_LEFT_ONLY',
    },
}