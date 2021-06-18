local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddBoxZone("LawyerDuty", vector3(332.76, -1616.16, 85.59), 2.2, 1, {
        name="LawyerDuty",
        heading=320,
        minZ=85.49,
        maxZ=85.89 }, {
        options = {
            {
                event = "police:client:Duty",
                icon = "fas fa-address-card",
                label = "Clock in",
                duty = false,
                parameters = "duty",
            },
            {
                event = "police:client:Duty",
                icon = "fas fa-address-card",
                label = "Clock out",
                duty = true,
                parameters = "duty",
            },
        },
    job = {"lawyer"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("LawyerDuty2", vector3(324.88, -1625.4, 85.59), 2.4, 0.6, {
        name="LawyerDuty2",
        heading=320,
        minZ=85.44,
        maxZ=85.84 }, {
        options = {
            {
                event = "police:client:Duty",
                icon = "fas fa-address-card",
                label = "Clock in",
                duty = false,
                parameters = "duty",
            },
            {
                event = "police:client:Duty",
                icon = "fas fa-address-card",
                label = "Clock out",
                duty = true,
                parameters = "duty",
            },
        },
    job = {"lawyer"}, distance = 1.5 })
    
    exports["lcrp-interact"]:AddBoxZone("court10Elevator", vector3(341.1, -1650.08, 85.59), 2.8, 2.8, {
        name="court10Elevator",
        heading=319,
        minZ=84.59,
        maxZ=87.19 }, {
        options = {
            {
                event = "police:client:Elevator",
                icon = "fas fa-arrow-down",
                label = "Elevator 1th floor",
                duty = false,
                parameters = {x= 341.25, y=-1650.18, z=32.53},
            },
        },
    job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("court1Elevator", vector3(341.25, -1650.18, 32.53), 3.0, 3.0, {
        name="court1Elevator",
        heading=320,
        minZ=31.53,
        maxZ=34.13 }, {
        options = {
            {
                event = "police:client:Elevator",
                icon = "fas fa-arrow-up",
                label = "Elevator 10th floor",
                duty = false,
                parameters = {x= 341.1, y=-1650.08, z=85.59},
            },
        },
    job = {"all"}, distance = 1.5 })
end)