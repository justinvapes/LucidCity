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

local CurrentPlate = nil
-- scCore shit --

RegisterNetEvent("lcrp-airlines:client:deleteVehicle")
AddEventHandler("lcrp-airlines:client:deleteVehicle", function()
    DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
    CurrentPlate = nil
end)


Citizen.CreateThread(function()
    Citizen.Wait(1000)
    local blip = AddBlipForCoord(-961.011, -2989.87, 13.55)
    SetBlipSprite(blip, 90)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 7)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Lucid Airlines")
    EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent("lcrp-airlines:client:detector")
AddEventHandler("lcrp-airlines:client:detector", function(isFucked)
    local plyCoords = GetEntityCoords(PlayerPedId())
    local metalDist = GetDistanceBetweenCoords(plyCoords, Config.AirlinePositions['metalDetector'].x, Config.AirlinePositions['metalDetector'].y, Config.AirlinePositions['metalDetector'].z)
    if metalDist < 15 then
        local sid = GetSoundId()
        if isFucked then
            PlaySoundFromCoord(sid, "scanner_alarm_os", Config.AirlinePositions['metalDetector'].x, Config.AirlinePositions['metalDetector'].y, Config.AirlinePositions['metalDetector'].z + 0.5 , "dlc_xm_iaa_player_facility_sounds", 1, 100, 0)
        else
            PlaySoundFromCoord(sid, "TIMER_STOP", Config.AirlinePositions['metalDetector'].x, Config.AirlinePositions['metalDetector'].y, Config.AirlinePositions['metalDetector'].z + 0.5 , "HUD_MINI_GAME_SOUNDSET", 1, 100, 0)
        end
    end
end)

RegisterNetEvent("lcrp-airlines:client:spawnPlane")
AddEventHandler("lcrp-airlines:client:spawnPlane", function(plane)
    if PlayerJob.name == "airlines" then
        local heading = Config.AirlinePositions['takePlane'].h
        local plyPos = GetEntityCoords(PlayerPedId())
        local coords = {x = plyPos.x , y = plyPos.y, z = plyPos.z, a = 0.0}
        if coords.y < -3784.612 then
            heading = Config.AirlinePositions['takePlaneCayo'].h
        end

        scCore.Functions.SpawnVehicle(plane, function(veh)
            SetVehicleNumberPlateText(veh, "PLANE"..tostring(math.random(1000, 9999)))
            SetEntityHeading(veh, heading)
            exports['LegacyFuel']:SetFuel(veh, 100.0)
            SetEntityAsMissionEntity(veh, true, true)
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
            SetVehicleEngineOn(veh, true, true)
            CurrentPlate = GetVehicleNumberPlateText(veh)
            TriggerServerEvent("lcrp-jobs:server:AddPlates", CurrentPlate, plane)
        end, coords, true)
    end
end)



function spawnPlane(plane)
    ClearMenu()
    closeMenuFull()
    TriggerServerEvent('lcrp-jobs:server:CheckDepositMoney', true, "airlines", plane)
end

function SelectOutfit(outfit)
    print(outfit)
    if outfit == "civillian" then
        TriggerServerEvent('lcrp-clothes:get_character_current')
        TriggerServerEvent("lcrp-clothes:retrieve_tats")
    end

    if outfit == "pilot" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 10, texture = 0},
                ["arms"]        = { item = 0, texture = 0}, 
                ["t-shirt"]     = { item = -1, texture = 0},  
                ["vest"]        = { item = -1, texture = 0},  
                ["torso2"]      = { item = 13, texture = 0},  
                ["shoes"]       = { item = 36, texture = 3},  
                ["hat"]         = { item = 149, texture = 0},
                ["accessory"]   = { item = -1, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    TriggerEvent('InteractSound_CL:PlayOnOne','Clothes1', 0.6)
    closeMenuFull()
end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()

	exports["lcrp-interact"]:AddBoxZone("AirlinesDuty", vector3(-931.53, -2957.12, 13.95), 3.2, 1, {
        name="AirlinesDuty",
        heading=330,
        --debugPoly=true,
        minZ=13.95,
        maxZ=14.95
        }, {
		options = {
			{
				event = "police:client:Duty",
				icon = "far fa-clipboard",
				label = "Clock in",
				duty = false,
				parameters = "duty",
			},
			{
				event = "police:client:Duty",
				icon = "far fa-clipboard",
				label = "Clock out",
				duty = true,
				parameters = "duty",
			},
		},
	job = {"airlines"}, distance = 2.0 })

	exports["lcrp-interact"]:AddBoxZone("AirlinesBoss", vector3(-930.1, -2993.73, 19.85), 2.2, 2, {
        name="AirlinesBoss",
        heading=330,
        --debugPoly=true,
        minZ=18.65,
        maxZ=20.65 }, {
        options = {
            {
                event = "police:server:OpenSocietyMenu",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
                parameters = 'airlines'
            },
        },
    job = {"airlines"}, distance = 2.0})

    planes = {{
        event = "airlines:client:storePlane",
        icon = "",
        label = 'Available Planes',
        duty = true,
        storeVeh = true,
    }}
    helis = {{
        event = "airlines:client:storePlane",
        icon = "",
        label = 'Available Helis',
        duty = true,
        storeVeh = true,
    }}
    for k,v in pairs(Config.DepositPricePlane) do
        if v.type == 'plane'then
            table.insert(planes, {
                event = "airlines:client:selectedPlane",
                icon = "far fa-plane-departure",
                label = v.name.." | Deposit : "..v.price.."$",
                duty = true,
                parameters = k
            })
        else
            table.insert(helis, {
                event = "airlines:client:selectedPlane",
                icon = "far fa-helicopter",
                label = v.name.." | Deposit : "..v.price,
                duty = true,
                parameters = k
            })
        end
    end

    exports["lcrp-interact"]:AddBoxZone("AirlinesPlane", vector3(-979.8, -2996.04, 13.95), 15.4, 11.0, {
        name="AirlinesPlane",
        heading=330,
        --debugPoly=true,
        minZ=-14.4,
        maxZ=17.75 }, {
        options = planes,
    job = {"airlines"}, distance = 10.0})

    exports["lcrp-interact"]:AddBoxZone("AirlinesHeli", vector3(-961.87, -2965.0, 13.95), 15.2, 10.8, {
        name="AirlinesHeli",
        heading=330,
        --debugPoly=true,
        minZ=-14.4,
        maxZ=16.95 }, {
        options = helis,
    job = {"airlines"}, distance = 10.0})

    exports["lcrp-interact"]:AddBoxZone("AirlinesCayoPlane", vector3(4485.13, -4493.73, 4.2), 20.0, 25.2, {
        name="AirlinesCayoPlane",
        heading=20,
        --debugPoly=true,
        minZ=-14.4,
        maxZ=10.4 }, {
        options = planes,
    job = {"airlines"}, distance = 20.0})

    exports["lcrp-interact"]:AddBoxZone("AirlinesCayoHeli", vector3(4448.56, -4484.29, 4.22), 12.6, 19.4, {
        name="AirlinesCayoHeli",
        heading=20,
        --debugPoly=true,
        minZ=-14.4,
        maxZ=10.4 }, {
        options = helis,
    job = {"airlines"}, distance = 20.0})
  

    exports["lcrp-interact"]:AddBoxZone("AirlinesOutfits", vector3(-928.7, -2939.53, 13.95), 2.4, 3.8, {
        name="AirlinesOutfits",
        heading=330,
        --debugPoly=true,
        minZ=12.95,
        maxZ=14.95 }, {
        options = {
            {
                event = "",
                icon = "",
                label = "Airlines Outfits",
                duty = true,
            },
            {
                event = "airlines:client:selectedOutfit",
                icon = "fad fa-tshirt",
                label = "Civillian",
                duty = true,
                parameters = "civillian"
            },
            {
                event = "airlines:client:selectedOutfit",
                icon = "fad fa-tshirt",
                label = "Pilot",
                duty = true,
                parameters = "pilot"
            },
        },
    job = {"airlines"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("AirlinesOutfits2", vector3(-931.92, -2937.24, 13.95), 1.8, 3.8, {
        name="AirlinesOutfits2",
        heading=330,
        --debugPoly=true,
        minZ=12.95,
        maxZ=14.95 }, {
        options = {
            {
                event = "",
                icon = "",
                label = "Airlines Outfits",
                duty = true,
            },
            {
                event = "airlines:client:selectedOutfit",
                icon = "far fa-tshirt",
                label = "Civillian",
                duty = true,
                parameters = "civillian"
            },
            {
                event = "airlines:client:selectedOutfit",
                icon = "far fa-tshirt",
                label = "Pilot",
                duty = true,
                parameters = "pilot"
            },
        },
    job = {"airlines"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("AirlinesMetalDetector", vector3(-966.92, -2798.6, 13.96), 1.4, 1.6, {
        name="AirlinesMetalDetector",
        heading=331,
        --debugPoly=true,
        minZ=12.76,
        maxZ=15.76 }, {
        options = {
            {
                event = "airlines:client:passMetalDetector",
                icon = "far fa-sensor-on",
                label = "Pass Metal Detector",
                duty = true,
            },
        },
    job = {"airlines"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("AirlinesMetalDetector2", vector3(-960.52, -2798.28, 13.96), 1.4, 1.6, {
        name="AirlinesMetalDetector2",
        heading=330,
        --debugPoly=true,
        minZ=12.36,
        maxZ=15.56 }, {
        options = {
            {
                event = "airlines:client:passMetalDetector",
                icon = "far fa-sensor-on",
                label = "Pass Metal Detector",
                duty = true,
            },
        },
    job = {"airlines"}, distance = 2.0})

end)

RegisterNetEvent('airlines:client:selectedPlane')
AddEventHandler('airlines:client:selectedPlane', function(selection)
    spawnPlane(selection)
end)

RegisterNetEvent('airlines:client:storePlane')
AddEventHandler('airlines:client:storePlane', function()
    local isPedInVehicle = IsPedInAnyVehicle(GetPlayerPed(-1), false)
    if isPedInVehicle then
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
        if GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1) then
            local CurrentPlate = GetVehicleNumberPlateText(vehicle)
            TriggerServerEvent("lcrp-jobs:server:CheckDepositMoney", false, "airlines", true, CurrentPlate)
        else
            scCore.Notification('You must be a driver')
        end        
    end
end)

RegisterNetEvent('airlines:client:selectedOutfit')
AddEventHandler('airlines:client:selectedOutfit', function(selection)
    SelectOutfit(selection)
end)

RegisterNetEvent('airlines:client:passMetalDetector')
AddEventHandler('airlines:client:passMetalDetector', function()
    local sid = GetSoundId()
    TriggerServerEvent('lcrp-airlines:server:detector')
end)


