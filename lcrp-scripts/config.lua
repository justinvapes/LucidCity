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

Consumeables = {
    ["sandwich"] = math.random(35, 54),
    ["water_bottle"] = math.random(35, 54),
    ["bs_drink"] = math.random(20, 30),
    ["redbullock"] = math.random(15, 25),
    ["mutant_energy"] = math.random(15, 25),
    ["empire"] = math.random(15, 25),
    ["sprite"] = math.random(35, 54),
    ["applejuice"] = math.random(30, 40),
    ["tosti"] = math.random(40, 50),
    ["burger"] = math.random(50, 55),
    ["donut"] = math.random(10, 20),
    ["muffin"] = math.random(10, 20),
    ["creampie"] = math.random(10, 20),
    ["bs_fries"] = math.random(10, 20),
    ["bs_bleeder"] = math.random(60, 65),
    ["bs_heartstopper"] = math.random(60, 80),
    ["bs_chickensandwich"] = math.random(40, 50),
    ["bs_torpedo"] = math.random(50, 60),
    ["bs_meat_free"] = math.random(30, 40),
    ["bs_moneyshot"] = math.random(50, 60),
    ["bs_cosmoburger"] = math.random(30, 40),
    ["cookedmeat"] = math.random(30, 45),
    ["eggsbacon"] = math.random(50, 70),
    ["spaghetti"] = math.random(35, 50),
    ["pancakes"] = math.random(20, 30),
    ["popcorn"] = math.random(10, 25),
    ["mnm"] = math.random(12, 25),
    ["skittles"] = math.random(10, 25),
    ["kurkakola"] = math.random(35, 54),
    ["doritos"] = math.random(25, 30),
    ["hotcheetos"] = math.random(25, 30),
    ["twerks_candy"] = math.random(25, 30),
    ["snikkel_candy"] = math.random(25, 30),
    ["kfc_fries"] = math.random(20, 35),
    ["kfc_nuggets"] = math.random(40, 50),
    ["kfc_bucket"] = math.random(60, 80),
    ["coffee"] = math.random(40, 50),
    ["whiskey"] = math.random(20, 30),
    ["beer"] = math.random(30, 40),
    ["vodka"] = math.random(20, 40),
    ["pizza"] = math.random(30,50),
    ["vegan_pizza"] = math.random(60,80)
}

Config = {}

Config.HasEatAnimation = {
    burger = 'burger',
    sandwich = "sandwich",
    bs_torpedo = 'burger',
    bs_chickensandwich = 'burger',
    bs_heartstopper = 'burger',
    bs_bleeder = 'burger',
    bs_meat_free = 'burger',
    bs_moneyshot = 'burger',
    bs_cosmoburger = 'burger',
}

Config.RemoveWeaponDrops = true
Config.RemoveWeaponDropsTimer = 25

--DevCORE SMOKE
--Base
Config.LighterItem = 'lighter' -- Lighter item
Config.Smoke = 38 -- draw smoke from a cigarette, cigar, joint  -- https://docs.fivem.net/docs/game-references/controls/
Config.Throw = 105 -- throw away a cigarette, cigar, joint
Config.Mouth = 11 -- from hand to mouth
Config.inHand = 10 -- From mouth to hands

----------------------------------------

--Ciggarate
Config.SmokeMouth = 0.1 -- The size of the smoke from the mouth
Config.SmokeSizeCigarette = 0.03 -- The size of cigarette smoke

Config.CigaretteHangTime = 1000 -- smoke exhalation time
Config.CigaretteSmokingTime = 180000 -- After 3 minutes, the character discards the cigarette
Config.CancelSmoke = true  -- If it is false, smoking will last indefinitely; if it is true, it will end after the Config.CigaretteSmokingTime


--Joint
Config.SmokeJointMouth = 0.1 -- The size of the smoke from the mouth
Config.SmokeSizeJoint = 0.04 -- The size of joint smoke

Config.CancelSmokeJoint = true -- If it is false, smoking will last indefinitely; if it is true, it will end after the Config.JointSmokingTime 

Config.JointHangTime = 1000 -- smoke exhalation time
Config.JointSmokingTime = 180000-- After 3 minutes, the character discards the Joint

Config.JointEffectTime = 120

Config.DamageNeeded = 800.0 -- 100.0 being broken and 1000.0 being fixed a lower value than 100.0 will break it
Config.MaxWidth = 5.0
Config.MaxHeight = 5.0
Config.MaxLength = 5.0

Config.BlacklistedScenarios = {
    ['TYPES'] = {
        "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
        "WORLD_VEHICLE_MILITARY_PLANES_BIG",
    },
    ['GROUPS'] = {
        2017590552,
        2141866469,
        1409640232,
        `ng_planes`,
    }
}

Config.BlacklistedVehs = {
    [`SHAMAL`] = true,
    [`LUXOR`] = false,
    [`LUXOR2`] = false,
    [`JET`] = true,
    [`LAZER`] = true,
    [`BUZZARD`] = true,
    [`BUZZARD2`] = true,
    [`ANNIHILATOR`] = true,
    [`SAVAGE`] = true,
    [`TITAN`] = true,
    [`RHINO`] = true,
    [`FIRETRUK`] = true,
    [`MULE`] = true,
    [`POLMAV`] = true,
    [`BLIMP`] = true,
    [`AIRTUG`] = false,
}

Config.BlacklistedPeds = {
    [`s_m_y_ranger_01`] = true,
    [`s_m_y_sheriff_01`] = true,
    [`s_m_y_cop_01`] = true,
    [`s_f_y_sheriff_01`] = true,
    [`s_f_y_cop_01`] = true,
    [`s_m_y_hwaycop_01`] = true,
}

Config.AvailableCoins = {
    'LC',
    'MBC',
    'PPC'
}

Config.regCrypt = vector3(1275.65, -1710.36, 54.77)
Config.BruteForce = vector3(948.05, -1463.95, 33.612)
--{['x'] = 1299.19, ['y'] = -1728.39, ['z'] = 53.85} - DEBUG, NEAR LESTER HOUSE