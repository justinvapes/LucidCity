Config              = {}
LCRPHud               = {}

LCRPHud.Show = true

LCRPHud.Money = {}
LCRPHud.Money.ShowConstant = false -- Show money constantly

LCRPHud.Radar = {}
LCRPHud.Radar.NoRadarVehicles = {
    "bmx",
    "cruiser",
    "fixter",
    "scorcher",
    "tribike",
    "tribike2",
    "tribike3",
}

-- Variables (HUD)
Config.hideArmor    = false
Config.hideOxygen   = false

Config.pulseHud     = true -- Pulse Effect when status is below the configured amount.
Config.pulseStart   = 35 -- Minimal value for pulse to start.

-- Wait times
Config.waitTime     = 420  -- Set to 100 so the hud is more fluid. However, performance will be affected.
Config.waitSpawn    = 5000 -- Time to set elements back to saved on spawn
Config.waitResource = 2000 -- Time to set elements back to saved after resource start

-- Variables (Controls)
Config.voiceKey     = 'f11' -- Cycles through modes (has to match your voip script key)
Config.openKey      = 'f7' -- Key for opening the customizing menu
Config.oxygenMax    = 10 -- Set to 10 / 4 if using vMenu

Stress = {}

Stress.Intensity = {
    ["shake"] = {
        [1] = {
            min = 50,
            max = 60,
            intensity = 0.12,
        },
        [2] = {
            min = 60,
            max = 70,
            intensity = 0.17,
        },
        [3] = {
            min = 70,
            max = 80,
            intensity = 0.22,
        },
        [4] = {
            min = 80,
            max = 90,
            intensity = 0.28,
        },
        [5] = {
            min = 90,
            max = 100,
            intensity = 0.32,
        },
    }
}

Stress.MinimumStress = 50
Stress.MinimumSpeed = 115

Stress.EffectInterval = {
    [1] = {
        min = 50,
        max = 60,
        timeout = math.random(50000, 60000)
    },
    [2] = {
        min = 60,
        max = 70,
        timeout = math.random(40000, 50000)
    },
    [3] = {
        min = 70,
        max = 80,
        timeout = math.random(30000, 40000)
    },
    [4] = {
        min = 80,
        max = 90,
        timeout = math.random(20000, 30000)
    },
    [5] = {
        min = 90,
        max = 100,
        timeout = math.random(15000, 20000)
    }
}
