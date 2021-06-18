scCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if scCore == nil then
            TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

isLoggedIn = true
local PlayerJob = {}
local JobsDone = 0
local LocationsDone = {}
local CurrentLocation = nil
local CurrentBlip = nil
local hasBox = false
local hasStock = false
local isWorking = false
local currentCount = 0
local CurrentPlate = nil
local CurrentTow = nil
local kmsDone = 0

local selectedVeh = nil
local TruckVehBlip = nil

local vehicle = nil


RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerJob = scCore.Functions.GetPlayerData().job
    CurrentLocation = nil
    CurrentBlip = nil
    hasBox = false
    isWorking = false
    JobsDone = 0
    myShop = PlayerJob.name
    onDuty = PlayerJob.onduty
    --setBlip(myShop)
end)

RegisterNetEvent('scCore:Client:OnPlayerUnload')
AddEventHandler('scCore:Client:OnPlayerUnload', function()
    RemoveTruckerBlips()
    CurrentLocation = nil
    CurrentBlip = nil
    hasBox = false
    isWorking = false
    JobsDone = 0
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    myShop = PlayerJob.name
    onDuty = PlayerJob.onduty
    --setBlip(myShop)
end)
RegisterNetEvent('scCore:Client:SetDuty')
AddEventHandler('scCore:Client:SetDuty', function(duty)
    onDuty = duty
end)
--[[ function setBlip(myShop)
        Citizen.CreateThread(function()
        DeliveriesBlip = AddBlipForCoord(Config.Locations["stores"][myShop].paycheck.x, Config.Locations["stores"][myShop].paycheck.y, Config.Locations["stores"][myShop].paycheck.z)
        SetBlipSprite(DeliveriesBlip, 478)
        SetBlipDisplay(DeliveriesBlip, 4)
        SetBlipScale(DeliveriesBlip, 0.8)
        SetBlipAsShortRange(DeliveriesBlip, true)
        SetBlipColour(DeliveriesBlip, 26)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(myShop)
        EndTextCommandSetBlipName(DeliveriesBlip)
        end)
end ]]


function getNewLocation()
    --local location = getNextClosestLocation()
    --if location ~= 0 then
    if hasStock then
        CurrentLocation = {}
        CurrentLocation.id = location
        CurrentLocation.dropcount = 1
        CurrentLocation.store = Config.Locations["stores"][myShop].name
        CurrentLocation.x = Config.Locations["stores"][myShop].coords.x
        CurrentLocation.y = Config.Locations["stores"][myShop].coords.y
        CurrentLocation.z = Config.Locations["stores"][myShop].coords.z

        CurrentBlip = AddBlipForCoord(CurrentLocation.x, CurrentLocation.y, CurrentLocation.z)
        SetBlipColour(CurrentBlip, 3)
        SetBlipRoute(CurrentBlip, true)
        SetBlipRouteColour(CurrentBlip, 3)
        
    else
        CurrentLocation = nil
        location = nil
        if myShop:sub(-4) == "cayo" then
            CurrentLocation = vector3(Config.Locations["pickupcayo"].x,Config.Locations["pickupcayo"].y,Config.Locations["pickupcayo"].z)
        elseif myShop == "cockatoos" or myShop == "galaxy" or myShop == "bahamas" or myShop == "vanilla" then
            CurrentLocation = vector3(Config.Locations["pickupbar"].x,Config.Locations["pickupbar"].y,Config.Locations["pickupbar"].z)
        else
            CurrentLocation = vector3(Config.Locations["pickup"].x,Config.Locations["pickup"].y,Config.Locations["pickup"].z)
        end
    
        CurrentBlip = AddBlipForCoord(CurrentLocation)
        SetBlipColour(CurrentBlip, 3)
        SetBlipRoute(CurrentBlip, true)
        SetBlipRouteColour(CurrentBlip, 3)
        Citizen.Wait(1500)
        if kmsDone == 0 then
            kmsDone = GetGpsBlipRouteLength()
        end
        
   -- else
        --scCore.Notification("You went to all the shops. Go back to get your paycheck!")
        --if CurrentBlip ~= nil then
            --RemoveBlip(CurrentBlip)
            --CurrentBlip = nil
        --end
    end
end

function isOwner()
    local retval = false
    local roles = scCore.Shared.Jobs[myShop].roles
    highestGrade = 0
    for k, v in pairs(roles) do
        if k > highestGrade then 
            highestGrade = k
        end
    end
    if (PlayerJob.grade == highestGrade and (string.match(PlayerJob.name, "247supermarket") or string.match(PlayerJob.name, "ltdgasoline") or string.match(PlayerJob.name, "robsliquor"))) then
        retval = true
    else
        retval = false
    end

    return retval
end

function getNextClosestLocation()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = 0
    local dist = nil

    for k, _ in pairs(Config.Locations["stores"]) do
        if current ~= 0 then
            if(GetDistanceBetweenCoords(pos, Config.Locations["stores"][k].coords.x, Config.Locations["stores"][k].coords.y, Config.Locations["stores"][k].coords.z, true) < dist)then
                if not hasDoneLocation(k) then
                    current = k
                    dist = GetDistanceBetweenCoords(pos, Config.Locations["stores"][k].coords.x, Config.Locations["stores"][k].coords.y, Config.Locations["stores"][k].coords.z, true)    
                end
            end
        else
            if not hasDoneLocation(k) then
                current = k
                dist = GetDistanceBetweenCoords(pos, Config.Locations["stores"][k].coords.x, Config.Locations["stores"][k].coords.y, Config.Locations["stores"][k].coords.z, true)    
            end
        end
    end

    return current
end

function hasDoneLocation(locationId)
    local retval = false
    if LocationsDone ~= nil and next(LocationsDone) ~= nil then 
        for k, v in pairs(LocationsDone) do
            if v == locationId then
                retval = true
            end
        end
    end
    return retval
end

function isTruckerVehicle(vehicle)
    local retval = false
    for k, v in pairs(Config.Vehicles) do
        if GetEntityModel(vehicle) == GetHashKey(k) then
            retval = true
        end
    end
    return retval
end

function MenuGarage()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Vehicles", "VehicleList", nil)
    Menu.addButton("Close Menu", "closeMenuFull", nil) 
end

function VehicleList(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Vehicles:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "TakeOutVehicle", k, "Garage", " Engine: 100%", " Body: 100%", " Fuel: 100%")
    end
        
    Menu.addButton("Back", "MenuGarage",nil)
end

function TakeOutVehicle(vehicleInfo)
    TriggerServerEvent('lcrp-deliveries:server:DoBail', true, vehicleInfo)
    selectedVeh = vehicleInfo
end

function RemoveTruckerBlips()
    if TruckVehBlip ~= nil then
        RemoveBlip(TruckVehBlip)
        TruckVehBlip = nil
    end

    if CurrentBlip ~= nil then
        RemoveBlip(CurrentBlip)
        CurrentBlip = nil
    end
end

RegisterNetEvent('lcrp-deliveries:client:SpawnVehicle')
AddEventHandler('lcrp-deliveries:client:SpawnVehicle', function()
    local vehicleInfo = selectedVeh
    local coords = Config.Locations["stores"][myShop].vehicle
    scCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        --SetVehicleNumberPlateText(veh, myShop..tostring(math.random(10, 99)))
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
        getNewLocation()
        vehicle = veh
    end, coords, true)
end)

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    -- ltdgasoline --
    exports["lcrp-interact"]:AddBoxZone("ltdgasolineDuty", vector3(-45.28, -1751.61, 29.42), 0.6, 1.4, {
        name="ltdgasolineDuty",
        heading=320,
        --debugPoly=true,
        minZ=29.22,
        maxZ=30.42 }, {
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
    job = {"ltdgasoline"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ltdgasolinePaycheck", vector3(-44.77, -1748.95, 29.42), 1.8, 1, {
        name="ltdgasolinePaycheck",
        heading=320,
        --debugPoly=true,
        minZ=28.02,
        maxZ=29.82,
        }, {
        options = {
            {
                event = "deliveries:client:getPaycheck",
                icon = "fas fa-money-bill-wave",
                label = "Receive Paycheck",
                duty = true,
            },
        },
    job = {"ltdgasoline"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ltdgasolineBoss", vector3(-45.99, -1750.07, 29.42), 1.4, 1.2, {
        name="ltdgasolineBoss",
        heading=319,
        --debugPoly=true,
        minZ=27.82,
        maxZ=30.42,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"ltdgasoline"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ltdgasolineVehicle", vector3(-43.45, -1741.27, 29.12), 7.0, 7.0, {
        name="ltdgasolineVehicle",
        heading=320,
        --debugPoly=true,
        minZ=26.72,
        maxZ=30.92,
        }, {
        options = setInteractVehicles(),
    job = {"ltdgasoline"}, distance = 6 })

    exports["lcrp-interact"]:AddBoxZone("ltdgasolineDeliver", vector3(-41.34, -1748.34, 29.21), 0.8, 1.4, {
        name="ltdgasolineDeliver",
        heading=321,
        --debugPoly=true,
        minZ=27.01,
        maxZ=31.21,
        }, {
        options = {
            {
                event = "deliveries:client:deliverProducts",
                icon = "fas fa-apple-crate",
                label = "Deliver Products",
                duty = true,
            },
        },
    job = {"ltdgasoline"}, distance = 1.5 })

    -- 247supermarket --
    exports["lcrp-interact"]:AddBoxZone("247supermarketDuty", vector3(27.14, -1341.73, 29.5), 0.4, 1.4, {
        name="247supermarketDuty",
        heading=0,
        --debugPoly=true,
        minZ=29.3,
        maxZ=30.3 }, {
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
    job = {"247supermarket"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarketPaycheck", vector3(29.43, -1338.4, 29.5), 1.8, 1.8, {
        name="247supermarketPaycheck",
        heading=0,
        --debugPoly=true,
        minZ=27.5,
        maxZ=30.1,
        }, {
        options = {
            {
                event = "deliveries:client:getPaycheck",
                icon = "fas fa-money-bill-wave",
                label = "Receive Paycheck",
                duty = true,
            },
        },
    job = {"247supermarket"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarketBoss", vector3(30.76, -1338.36, 29.5), 1.2, 0.8, {
        name="247supermarketBoss",
        heading=0,
        --debugPoly=true,
        minZ=27.7,
        maxZ=30.5,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"247supermarket"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarkertVehicle", vector3(26.34, -1310.5, 29.24), 16.6, 3.8, {
        name="247supermarkertVehicle",
        heading=0,
        --debugPoly=true,
        minZ=27.44,
        maxZ=31.84,
        }, {
        options = setInteractVehicles(),
    job = {"247supermarket"}, distance = 6 })

    exports["lcrp-interact"]:AddBoxZone("247supermarketDeliver", vector3(31.7, -1316.56, 29.35), 2.2, 3.6, {
        name="247supermarketDeliver",
        heading=0,
        --debugPoly=true,
        minZ=26.75,
        maxZ=31.55,
        }, {
        options = {
            {
                event = "deliveries:client:deliverProducts",
                icon = "fas fa-apple-crate",
                label = "Deliver Products",
                duty = true,
            },
        },
    job = {"247supermarket"}, distance = 1.5 })
  
    -- ltdgasoline2 --
    exports["lcrp-interact"]:AddBoxZone("ltdgasoline2Duty", vector3(-709.05, -907.96, 19.22), 1.0, 1.2, {
        name="ltdgasoline2Duty",
        heading=0,
        --debugPoly=true,
        minZ=19.02,
        maxZ=20.02 }, {
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
    job = {"ltdgasoline2"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ltdgasoline2Paycheck", vector3(-710.47, -905.46, 19.22), 1.8, 1.2, {
        name="ltdgasoline2Paycheck",
        heading=0,
        --debugPoly=true,
        minZ=16.02,
        maxZ=19.62,
        }, {
        options = {
            {
                event = "deliveries:client:getPaycheck",
                icon = "fas fa-money-bill-wave",
                label = "Receive Paycheck",
                duty = true,
            },
        },
    job = {"ltdgasoline2"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ltdgasoline2Boss", vector3(-710.46, -907.47, 19.22), 1, 1, {
        name="ltdgasoline2Boss",
        heading=0,
        --debugPoly=true,
        minZ=16.42,
        maxZ=20.22,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"ltdgasoline2"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ltdgasoline2Vehicle", vector3(-722.85, -913.92, 19.01), 4.8, 5.6, {
        name="ltdgasoline2Vehicle",
        heading=0,
        --debugPoly=true,
        minZ=17.41,
        maxZ=22.01,
        }, {
        options = setInteractVehicles(),
    job = {"ltdgasoline2"}, distance = 6 })

    exports["lcrp-interact"]:AddBoxZone("ltdgasoline2Deliver", vector3(-714.22, -908.33, 19.22), 1.6, 1.6, {
        name="ltdgasoline2Deliver",
        heading=0,
        --debugPoly=true,
        minZ=17.22,
        maxZ=20.42,
        }, {
        options = {
            {
                event = "deliveries:client:deliverProducts",
                icon = "fas fa-apple-crate",
                label = "Deliver Products",
                duty = true,
            },
        },
    job = {"ltdgasoline2"}, distance = 1.5 })

    -- ltdgasoline3 --
    exports["lcrp-interact"]:AddBoxZone("ltdgasoline3Duty", vector3(-1826.16, 796.51, 138.16), 1.2, 1, {
        name="ltdgasoline3Duty",
        heading=315,
        --debugPoly=true,
        minZ=137.96,
        maxZ=139.16 }, {
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
    job = {"ltdgasoline3"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ltdgasoline3Paycheck", vector3(-1829.04, 797.16, 138.16), 1.8, 1.8, {
        name="ltdgasoline3Paycheck",
        heading=310,
        --debugPoly=true,
        minZ=136.16,
        maxZ=138.56,
        }, {
        options = {
            {
                event = "deliveries:client:getPaycheck",
                icon = "fas fa-money-bill-wave",
                label = "Receive Paycheck",
                duty = true,
            },
        },
    job = {"ltdgasoline3"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ltdgasoline3Boss", vector3(-1827.57, 795.88, 138.17), 1, 1, {
        name="ltdgasoline3Boss",
        heading=315,
        --debugPoly=true,
        minZ=135.77,
        maxZ=139.17,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"ltdgasoline3"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ltdgasoline3Vehicle", vector3(-1814.36, 797.41, 138.24), 5.6, 7.8, {
        name="ltdgasoline3Vehicle",
        heading=310,
        --debugPoly=true,
        minZ=134.84,
        maxZ=140.84,
        }, {
        options = setInteractVehicles(),
    job = {"ltdgasoline3"}, distance = 6 })

    exports["lcrp-interact"]:AddBoxZone("ltdgasoline3Deliver", vector3(-1829.47, 792.35, 138.26), 1.6, 1, {
        name="ltdgasoline3Deliver",
        heading=312,
        --debugPoly=true,
        minZ=136.46,
        maxZ=139.66,
        }, {
        options = {
            {
                event = "deliveries:client:deliverProducts",
                icon = "fas fa-apple-crate",
                label = "Deliver Products",
                duty = true,
            },
        },
    job = {"ltdgasoline3"}, distance = 1.5 })

    -- ltdgasoline4 --
    exports["lcrp-interact"]:AddBoxZone("ltdgasoline4Duty", vector3(1160.76, -317.41, 69.21), 0.8, 1.4, {
        name="ltdgasoline4Duty",
        heading=10,
        --debugPoly=true,
        minZ=69.01,
        maxZ=70.01 }, {
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
    job = {"ltdgasoline4"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ltdgasoline4Paycheck", vector3(1159.0, -315.46, 69.21), 1.8, 1.2, {
        name="ltdgasoline4Paycheck",
        heading=10,
        --debugPoly=true,
        minZ=67.21,
        maxZ=69.61,
        }, {
        options = {
            {
                event = "deliveries:client:getPaycheck",
                icon = "fas fa-money-bill-wave",
                label = "Receive Paycheck",
                duty = true,
            },
        },
    job = {"ltdgasoline4"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ltdgasoline4Boss", vector3(1159.3, -317.4, 69.21), 1, 1, {
        name="ltdgasoline4Boss",
        heading=10,
        --debugPoly=true,
        minZ=66.61,
        maxZ=70.21,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"ltdgasoline4"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ltdgasoline4Vehicle", vector3(1153.7, -331.26, 68.9), 4.4, 6.0, {
        name="ltdgasoline4Vehicle",
        heading=10,
        --debugPoly=true,
        minZ=66.7,
        maxZ=70.3,
        }, {
        options = setInteractVehicles(),
    job = {"ltdgasoline4"}, distance = 6 })

    exports["lcrp-interact"]:AddBoxZone("ltdgasoline4Deliver", vector3(1155.86, -319.22, 69.2), 1.2, 1.6, {
        name="ltdgasoline4Deliver",
        heading=10,
        --debugPoly=true,
        minZ=67.2,
        maxZ=70.4,
        }, {
        options = {
            {
                event = "deliveries:client:deliverProducts",
                icon = "fas fa-apple-crate",
                label = "Deliver Products",
                duty = true,
            },
        },
    job = {"ltdgasoline4"}, distance = 1.5 })

    -- 247supermarket2 --
    exports["lcrp-interact"]:AddBoxZone("247supermarket2Duty", vector3(-3045.26, 585.35, 7.91), 1.2, 0.6, {
        name="247supermarket2Duty",
        heading=18,
        --debugPoly=true,
        minZ=7.71,
        maxZ=8.91 }, {
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
    job = {"247supermarket2"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket2Paycheck", vector3(-3048.84, 586.65, 7.91), 1.8, 1.4, {
        name="247supermarket2Paycheck",
        heading=17,
        --debugPoly=true,
        minZ=5.91,
        maxZ=8.51,
        }, {
        options = {
            {
                event = "deliveries:client:getPaycheck",
                icon = "fas fa-money-bill-wave",
                label = "Receive Paycheck",
                duty = true,
            },
        },
    job = {"247supermarket2"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket2Boss", vector3(-3049.4, 587.82, 7.91), 0.8, 1, {
        name="247supermarket2Boss",
        heading=21,
        --debugPoly=true,
        minZ=5.91,
        maxZ=8.91,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"247supermarket2"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket2Vehicle", vector3(-3051.38, 593.59, 7.48), 7.4, 4.8, {
        name="247supermarket2Vehicle",
        heading=20,
        --debugPoly=true,
        minZ=3.98,
        maxZ=9.38,
        }, {
        options = setInteractVehicles(),
    job = {"247supermarket2"}, distance = 6 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket2Deliver", vector3(-3047.45, 589.58, 7.58), 0.8, 1.6, {
        name="247supermarket2Deliver",
        heading=20,
        --debugPoly=true,
        minZ=3.98,
        maxZ=9.38,
        }, {
        options = {
            {
                event = "deliveries:client:deliverProducts",
                icon = "fas fa-apple-crate",
                label = "Deliver Products",
                duty = true,
            },
        },
    job = {"247supermarket2"}, distance = 1.5 })

    -- 247supermarket3 --
    exports["lcrp-interact"]:AddBoxZone("247supermarket3Duty", vector3(-3247.76, 1003.16, 12.83), 1.2, 0.6, {
        name="247supermarket3Duty",
        heading=356,
        --debugPoly=true,
        minZ=12.63,
        maxZ=13.63 }, {
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
    job = {"247supermarket3"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket3Paycheck", vector3(-3250.54, 1005.72, 12.83), 1.8, 1, {
        name="247supermarket3Paycheck",
        heading=355,
        --debugPoly=true,
        minZ=11.03,
        maxZ=13.43,
        }, {
        options = {
            {
                event = "deliveries:client:getPaycheck",
                icon = "fas fa-money-bill-wave",
                label = "Receive Paycheck",
                duty = true,
            },
        },
    job = {"247supermarket3"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket3Boss", vector3(-3250.63, 1007.04, 12.83), 0.8, 1, {
        name="247supermarket3Boss",
        heading=355,
        --debugPoly=true,
        minZ=11.83,
        maxZ=13.83,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"247supermarket3"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket3Vehicle", vector3(-3250.93, 992.49, 12.47), 6.4, 7.6, {
        name="247supermarket3Vehicle",
        heading=0,
        --debugPoly=true,
        minZ=10.27,
        maxZ=14.47,
        }, {
        options = setInteractVehicles(),
    job = {"247supermarket3"}, distance = 6 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket3Deliver", vector3(-3246.27, 1008.31, 12.82), 1.8, 1.6, {
        name="247supermarket3Deliver",
        heading=355,
        --debugPoly=true,
        minZ=11.02,
        maxZ=14.02,
        }, {
        options = {
            {
                event = "deliveries:client:deliverProducts",
                icon = "fas fa-apple-crate",
                label = "Deliver Products",
                duty = true,
            },
        },
    job = {"247supermarket3"}, distance = 1.5 })

    -- 247supermarket4 --
    exports["lcrp-interact"]:AddBoxZone("247supermarket4Duty", vector3(1732.79, 6419.16, 35.04), 0.6, 1.2, {
        name="247supermarket4Duty",
        heading=334,
        --debugPoly=true,
        minZ=34.84,
        maxZ=35.84 }, {
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
    job = {"247supermarket4"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket4Paycheck", vector3(1736.27, 6420.92, 35.04), 1.4, 1.8, {
        name="247supermarket4Paycheck",
        heading=333,
        --debugPoly=true,
        minZ=32.64,
        maxZ=35.64,
        }, {
        options = {
            {
                event = "deliveries:client:getPaycheck",
                icon = "fas fa-money-bill-wave",
                label = "Receive Paycheck",
                duty = true,
            },
        },
    job = {"247supermarket4"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket4Boss", vector3(1737.39, 6420.38, 35.04), 1.2, 0.8, {
        name="247supermarket4Boss",
        heading=335,
        --debugPoly=true,
        minZ=33.24,
        maxZ=36.04,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"247supermarket4"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket4Vehicle", vector3(1720.81, 6425.82, 33.75), 6.6, 8.2, {
        name="247supermarket4Vehicle",
        heading=335,
        --debugPoly=true,
        minZ=29.75,
        maxZ=35.95,
        }, {
        options = setInteractVehicles(),
    job = {"247supermarket4"}, distance = 6 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket4Deliver", vector3(1735.73, 6416.81, 35.03), 1.2, 1.6, {
        name="247supermarket4Deliver",
        heading=333,
        --debugPoly=true,
        minZ=33.43,
        maxZ=36.43,
        }, {
        options = {
            {
                event = "deliveries:client:deliverProducts",
                icon = "fas fa-apple-crate",
                label = "Deliver Products",
                duty = true,
            },
        },
    job = {"247supermarket4"}, distance = 1.5 })

    -- 247supermarket5 --
    exports["lcrp-interact"]:AddBoxZone("247supermarket5Duty", vector3(1704.65, 4921.84, 42.06), 1.2, 0.6, {
        name="247supermarket5Duty",
        heading=325,
        --debugPoly=true,
        minZ=41.86,
        maxZ=42.86 }, {
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
    job = {"247supermarket5"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket5Paycheck", vector3(1707.24, 4921.68, 42.06), 1.2, 1.8, {
        name="247supermarket5Paycheck",
        heading=325,
        --debugPoly=true,
        minZ=39.66,
        maxZ=42.46,
        }, {
        options = {
            {
                event = "deliveries:client:getPaycheck",
                icon = "fas fa-money-bill-wave",
                label = "Receive Paycheck",
                duty = true,
            },
        },
    job = {"247supermarket5"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket5Boss", vector3(1705.64, 4922.89, 42.06), 0.8, 0.8, {
        name="247supermarket5Boss",
        heading=325,
        --debugPoly=true,
        minZ=39.86,
        maxZ=43.06,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"247supermarket5"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket5Vehicle", vector3(1695.47, 4915.73, 42.07), 6.8, 8.8, {
        name="247supermarket5Vehicle",
        heading=326,
        --debugPoly=true,
        minZ=40.28,
        maxZ=43.68,
        }, {
        options = setInteractVehicles(),
    job = {"247supermarket5"}, distance = 6 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket5Deliver", vector3(1702.93, 4917.32, 42.08), 1.2, 1.4, {
        name="247supermarket5Deliver",
        heading=324,
        --debugPoly=true,
        minZ=40.28,
        maxZ=43.68,
        }, {
        options = {
            {
                event = "deliveries:client:deliverProducts",
                icon = "fas fa-apple-crate",
                label = "Deliver Products",
                duty = true,
            },
        },
    job = {"247supermarket5"}, distance = 1.5 })

    -- 247supermarket6 --
    exports["lcrp-interact"]:AddBoxZone("247supermarket6Duty", vector3(1959.63, 3746.24, 32.34), 1.2, 0.4, {
        name="247supermarket6Duty",
        heading=300,
        --debugPoly=true,
        minZ=32.14,
        maxZ=33.14 }, {
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
    job = {"247supermarket6"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket6Paycheck", vector3(1960.04, 3750.01, 32.34), 1.4, 1.8, {
        name="247supermarket6Paycheck",
        heading=30,
        --debugPoly=true,
        minZ=29.54,
        maxZ=32.94,
        }, {
        options = {
            {
                event = "deliveries:client:getPaycheck",
                icon = "fas fa-money-bill-wave",
                label = "Receive Paycheck",
                duty = true,
            },
        },
    job = {"247supermarket6"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket6Boss", vector3(1961.09, 3750.9, 32.34), 1.0, 0.8, {
        name="247supermarket6Boss",
        heading=31,
        --debugPoly=true,
        minZ=30.14,
        maxZ=33.34,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"247supermarket6"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket6Vehicle", vector3(1966.41, 3754.35, 32.22), 4.6, 4.4, {
        name="247supermarket6Vehicle",
        heading=30,
        --debugPoly=true,
        minZ=30.44,
        maxZ=34.04,
        }, {
        options = setInteractVehicles(),
    job = {"247supermarket6"}, distance = 6 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket6Deliver", vector3(1960.28, 3753.52, 32.24), 1.0, 3.2, {
        name="247supermarket6Deliver",
        heading=300,
        --debugPoly=true,
        minZ=30.44,
        maxZ=34.04,
        }, {
        options = {
            {
                event = "deliveries:client:deliverProducts",
                icon = "fas fa-apple-crate",
                label = "Deliver Products",
                duty = true,
            },
        },
    job = {"247supermarket6"}, distance = 1.5 })

    -- 247supermarket7 --
    exports["lcrp-interact"]:AddBoxZone("247supermarket7Duty", vector3(547.18, 2665.37, 42.16), 0.6, 1.2, {
        name="247supermarket7Duty",
        heading=8,
        --debugPoly=true,
        minZ=41.96,
        maxZ=42.96 }, {
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
    job = {"247supermarket7"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket7Paycheck", vector3(545.25, 2661.98, 42.16), 1.2, 1.8, {
        name="247supermarket7Paycheck",
        heading=10,
        --debugPoly=true,
        minZ=39.96,
        maxZ=42.76,
        }, {
        options = {
            {
                event = "deliveries:client:getPaycheck",
                icon = "fas fa-money-bill-wave",
                label = "Receive Paycheck",
                duty = true,
            },
        },
    job = {"247supermarket7"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket7Boss", vector3(544.0, 2661.55, 42.16), 1, 0.8, {
        name="247supermarket7Boss",
        heading=6,
        --debugPoly=true,
        minZ=39.36,
        maxZ=43.16,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"247supermarket7"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket7Vehicle", vector3(537.78, 2657.48, 42.37), 6.2, 6.6, {
        name="247supermarket7Vehicle",
        heading=10,
        --debugPoly=true,
        minZ=39.17,
        maxZ=44.37,
        }, {
        options = setInteractVehicles(),
    job = {"247supermarket7"}, distance = 6 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket7Deliver", vector3(543.83, 2658.92, 42.31), 3.0, 1, {
        name="247supermarket7Deliver",
        heading=5,
        --debugPoly=true,
        minZ=40.91,
        maxZ=44.11,
        }, {
        options = {
            {
                event = "deliveries:client:deliverProducts",
                icon = "fas fa-apple-crate",
                label = "Deliver Products",
                duty = true,
            },
        },
    job = {"247supermarket7"}, distance = 1.5 })
  

    -- 247supermarket8 --
    exports["lcrp-interact"]:AddBoxZone("247supermarket8Duty", vector3(2674.3, 3284.57, 55.24), 1.2, 0.6, {
        name="247supermarket8Duty",
        heading=330,
        --debugPoly=true,
        minZ=55.04,
        maxZ=56.04 }, {
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
    job = {"247supermarket8"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket8Paycheck", vector3(2672.83, 3288.03, 55.24), 1.8, 1.2, {
        name="247supermarket8Paycheck",
        heading=330,
        --debugPoly=true,
        minZ=53.44,
        maxZ=55.84,
        }, {
        options = {
            {
                event = "deliveries:client:getPaycheck",
                icon = "fas fa-money-bill-wave",
                label = "Receive Paycheck",
                duty = true,
            },
        },
    job = {"247supermarket8"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket8Boss", vector3(2673.27, 3289.28, 55.24), 0.8, 1, {
        name="247supermarket8Boss",
        heading=330,
        --debugPoly=true,
        minZ=52.84,
        maxZ=56.24,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"247supermarket8"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket8Vehicle", vector3(2659.23, 3261.76, 55.24), 6.0, 5.6, {
        name="247supermarket8Vehicle",
        heading=333,
        --debugPoly=true,
        minZ=53.24,
        maxZ=56.44,
        }, {
        options = setInteractVehicles(),
    job = {"247supermarket8"}, distance = 6 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket8Deliver", vector3(2677.55, 3288.78, 55.24), 1.6, 1, {
        name="247supermarket8Deliver",
        heading=330,
        --debugPoly=true,
        minZ=53.24,
        maxZ=56.64,
        }, {
        options = {
            {
                event = "deliveries:client:deliverProducts",
                icon = "fas fa-apple-crate",
                label = "Deliver Products",
                duty = true,
            },
        },
    job = {"247supermarket8"}, distance = 1.5 })

    -- 247supermarket9 --
    exports["lcrp-interact"]:AddBoxZone("247supermarket9Duty", vector3(376.56, 331.31, 103.57), 0.6, 1.2, {
        name="247supermarket9Duty",
        heading=345,
        --debugPoly=true,
        minZ=103.37,
        maxZ=104.37 }, {
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
    job = {"247supermarket9"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket9Paycheck", vector3(379.59, 333.78, 103.57), 1.6, 1.8, {
        name="247supermarket9Paycheck",
        heading=345,
        --debugPoly=true,
        minZ=101.57,
        maxZ=104.17,
        }, {
        options = {
            {
                event = "deliveries:client:getPaycheck",
                icon = "fas fa-money-bill-wave",
                label = "Receive Paycheck",
                duty = true,
            },
        },
    job = {"247supermarket9"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket9Boss", vector3(380.9, 333.52, 103.57), 0.8, 0.8, {
        name="247supermarket9Boss",
        heading=346,
        --debugPoly=true,
        minZ=101.17,
        maxZ=104.57,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"247supermarket9"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket9Vehicle", vector3(368.2, 340.94, 103.2), 6.8, 7.0, {
        name="247supermarket9Vehicle",
        heading=345,
        --debugPoly=true,
        minZ=100.6,
        maxZ=104.0,
        }, {
        options = setInteractVehicles(),
    job = {"247supermarket9"}, distance = 6 })

    exports["lcrp-interact"]:AddBoxZone("247supermarket9Deliver", vector3(382.77, 326.05, 103.56), 1.6, 1.4, {
        name="247supermarket9Deliver",
        heading=345,
        --debugPoly=true,
        minZ=101.56,
        maxZ=104.96,
        }, {
        options = {
            {
                event = "deliveries:client:deliverProducts",
                icon = "fas fa-apple-crate",
                label = "Deliver Products",
                duty = true,
            },
        },
    job = {"247supermarket9"}, distance = 1.5 })

    -- 247supermarketcayo --
    exports["lcrp-interact"]:AddBoxZone("247supermarketcayoDuty", vector3(4479.91, -4464.09, 4.26), 0.6, 1.2, {
        name="247supermarketcayoDuty",
        heading=20,
        --debugPoly=true,
        minZ=4.06,
        maxZ=5.06 }, {
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
    job = {"247supermarketcayo"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarketcayoPaycheck", vector3(4480.95, -4460.43, 4.26), 1.4, 1.8, {
        name="247supermarketcayoPaycheck",
        heading=20,
        --debugPoly=true,
        minZ=2.26,
        maxZ=4.86,
        }, {
        options = {
            {
                event = "deliveries:client:getPaycheck",
                icon = "fas fa-money-bill-wave",
                label = "Receive Paycheck",
                duty = true,
            },
        },
    job = {"247supermarketcayo"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarketcayoBoss", vector3(4482.18, -4459.85, 4.26), 1.0, 0.8, {
        name="247supermarketcayoBoss",
        heading=20,
        --debugPoly=true,
        minZ=3.26,
        maxZ=5.26,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"247supermarketcayo"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("247supermarketcayoVehicle", vector3(4471.99, -4466.05, 4.24), 5.6, 5.6, {
        name="247supermarketcayoVehicle",
        heading=20,
        --debugPoly=true,
        minZ=2.64,
        maxZ=5.64,
        }, {
        options = setInteractVehicles(),
    job = {"247supermarketcayo"}, distance = 6 })

    exports["lcrp-interact"]:AddBoxZone("247supermarketcayoDeliver", vector3(4487.66, -4465.02, 4.25), 1.6, 1.2, {
        name="247supermarketcayoDeliver",
        heading=20,
        --debugPoly=true,
        minZ=2.85,
        maxZ=5.65,
        }, {
        options = {
            {
                event = "deliveries:client:deliverProducts",
                icon = "fas fa-apple-crate",
                label = "Deliver Products",
                duty = true,
            },
        },
    job = {"247supermarketcayo"}, distance = 1.5 })

    -- galaxy --
    exports["lcrp-interact"]:AddBoxZone("galaxyDuty", vector3(345.02, 284.99, 95.79), 2.2, 1, {
        name="galaxyDuty",
        heading=345,
        --debugPoly=true,
        minZ=94.39,
        maxZ=96.39 }, {
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
    job = {"galaxy"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("galaxyPaycheck", vector3(389.48, 273.44, 94.99), 1.2, 2.4, {
        name="galaxyPaycheck",
        heading=30,
        --debugPoly=true,
        minZ=93.19,
        maxZ=95.39,
        }, {
        options = {
            {
                event = "deliveries:client:getPaycheck",
                icon = "fas fa-money-bill-wave",
                label = "Receive Paycheck",
                duty = true,
            },
        },
    job = {"galaxy"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("galaxyBoss", vector3(391.24, 269.35, 94.99), 1.4, 3.0, {
        name="galaxyBoss",
        heading=35,
        --debugPoly=true,
        minZ=92.99,
        maxZ=95.59,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"galaxy"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("galaxyVehicle", vector3(397.01, 263.71, 92.05), 6.0, 7.2, {
        name="galaxyVehicle",
        heading=345,
        --debugPoly=true,
        minZ=91.05,
        maxZ=93.65,
        }, {
        options = setInteractVehicles(),
    job = {"galaxy"}, distance = 6 })

    exports["lcrp-interact"]:AddBoxZone("galaxyDeliver", vector3(381.96, 257.32, 92.05), 1.8, 2.4, {
        name="galaxyDeliver",
        heading=345,
        --debugPoly=true,
        minZ=89.65,
        maxZ=92.65,
        }, {
        options = {
            {
                event = "deliveries:client:deliverProducts",
                icon = "fas fa-apple-crate",
                label = "Deliver Products",
                duty = true,
            },
        },
    job = {"galaxy"}, distance = 1.5 })
  
    -- bahamas --
    exports["lcrp-interact"]:AddBoxZone("bahamasDuty", vector3(-1367.85, -613.26, 30.31), 3.6, 3.0, {
        name="bahamasDuty",
        heading=303,
        --debugPoly=true,
        minZ=29.31,
        maxZ=31.71 }, {
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
    job = {"bahamas"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("bahamasPaycheck", vector3(-1366.31, -621.93, 30.32), 2, 1.0, {
        name="bahamasPaycheck",
        heading=303,
        --debugPoly=true,
        minZ=28.72,
        maxZ=30.72,
        }, {
        options = {
            {
                event = "deliveries:client:getPaycheck",
                icon = "fas fa-money-bill-wave",
                label = "Receive Paycheck",
                duty = true,
            },
        },
    job = {"bahamas"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("bahamasBoss", vector3(-1365.69, -622.8, 30.32), 1.6, 1.2, {
        name="bahamasBoss",
        heading=303,
        --debugPoly=true,
        minZ=28.72,
        maxZ=30.72,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"bahamas"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("bahamasVehicle", vector3(-1391.49, -634.28, 28.69), 4.2, 4.2, {
        name="bahamasVehicle",
        heading=30,
        --debugPoly=true,
        minZ=26.49,
        maxZ=29.69,
        }, {
        options = setInteractVehicles(),
    job = {"bahamas"}, distance = 6 })

    exports["lcrp-interact"]:AddBoxZone("bahamasDeliver", vector3(-1394.05, -629.56, 30.32), 2.8, 7.4, {
        name="bahamasDeliver",
        heading=32,
        --debugPoly=true,
        minZ=27.32,
        maxZ=30.72,
        }, {
        options = {
            {
                event = "deliveries:client:deliverProducts",
                icon = "fas fa-apple-crate",
                label = "Deliver Products",
                duty = true,
            },
        },
    job = {"bahamas"}, distance = 6 })

    -- cockatoos --
    exports["lcrp-interact"]:AddBoxZone("cockatoosDuty", vector3(-442.14, -31.31, 40.88), 1, 1, {
        name="cockatoosDuty",
        heading=0,
        --debugPoly=true,
        minZ=39.88,
        maxZ=41.28 }, {
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
    job = {"cockatoos"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("cockatoosPaycheck", vector3(-443.97, -36.23, 40.88), 1.4, 1.4, {
        name="cockatoosPaycheck",
        heading=0,
        --debugPoly=true,
        minZ=39.68,
        maxZ=41.28,
        }, {
        options = {
            {
                event = "deliveries:client:getPaycheck",
                icon = "fas fa-money-bill-wave",
                label = "Receive Paycheck",
                duty = true,
            },
        },
    job = {"cockatoos"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("cockatoosBoss", vector3(-442.0, -36.4, 40.88), 1.4, 1.4, {
        name="cockatoosBoss",
        heading=355,
        --debugPoly=true,
        minZ=39.08,
        maxZ=41.28,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"cockatoos"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("cockatoosVehicle", vector3(-455.21, -51.63, 44.52), 5.0, 4.0, {
        name="cockatoosVehicle",
        heading=0,
        --debugPoly=true,
        minZ=41.92,
        maxZ=46.12,
        }, {
        options = setInteractVehicles(),
    job = {"cockatoos"}, distance = 6 })

    exports["lcrp-interact"]:AddBoxZone("cockatoosDeliver", vector3(-434.88, -36.61, 40.88), 1.2, 7.4, {
        name="cockatoosDeliver",
        heading=357,
        --debugPoly=true,
        minZ=39.88,
        maxZ=42.28,
        }, {
        options = {
            {
                event = "deliveries:client:deliverProducts",
                icon = "fas fa-apple-crate",
                label = "Deliver Products",
                duty = true,
            },
        },
    job = {"cockatoos"}, distance = 1.5 })

    pickupJobs = {"ltdgasoline","ltdgasoline2",
                "ltdgasoline3","ltdgasoline4",
                "247supermarket","247supermarket2",
                "247supermarket3","247supermarket4",
                "247supermarket5","247supermarket6",
                "247supermarket7","247supermarket8", 
                "247supermarket9", "247supermarket10"}

    exports["lcrp-interact"]:AddBoxZone("PickupLocation", vector3(-524.2, -2901.86, 6.0), 15.2, 11.8, {
        name="PickupLocation",
        heading=25,
        --debugPoly=true,
        minZ=4.2,
        maxZ=10.2,
        }, {
        options = {
            {
                event = "deliveries:client:pickupProducts",
                icon = "fas fa-truck-loading",
                label = "Pickup Products",
                duty = true,
				onlyInVeh = true
            },
        },
    job = pickupJobs, distance = 20.0 })

    exports["lcrp-interact"]:AddBoxZone("PickupLocationCayo", vector3(5118.51, -5179.15, 2.26), 6.4, 5.2, {
        name="PickupLocationCayo",
        heading=0,
        --debugPoly=true,
        minZ=-0.74,
        maxZ=6.86,
        }, {
        options = {
            {
                event = "deliveries:client:pickupProducts",
                icon = "fas fa-truck-loading",
                label = "Pickup Products",
                duty = true,
                onlyInVeh = true
            },
        },
    job = {"247supermarketcayo"}, distance = 20.0 })

    exports["lcrp-interact"]:AddBoxZone("PickupLocationBar", vector3(-1924.22, 2047.97, 140.74), 17.0, 13.0, {
        name="PickupLocationBar",
        heading=346,
        --debugPoly=true,
        minZ=138.54,
        maxZ=143.94,
        }, {
        options = {
            {
                event = "deliveries:client:pickupProducts",
                icon = "fas fa-truck-loading",
                label = "Pickup Products",
                duty = true,
                onlyInVeh = true
            },
        },
    job = {"bahamas","galaxy","cockatoos", "vanilla"}, distance = 20.0 })

    exports["lcrp-interact"]:AddBoxZone("vanillaDeliver", vector3(135.66, -1279.12, 29.31), 1.4, 1, {
        name="vanillaDeliver",
        heading=30,
        --debugPoly=true,
        minZ=28.11,
        maxZ=30.91,
        }, {
        options = {
            {
                event = "deliveries:client:deliverProducts",
                icon = "fas fa-apple-crate",
                label = "Deliver Products",
                duty = true,
            },
        },
    job = {"vanilla"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("vanillaVehicle", vector3(147.36, -1279.18, 29.04), 5, 5, {
        name="vanillaVehicle",
        heading=300,
        --debugPoly=true,
        minZ=27.04,
        maxZ=30.84,
        }, {
        options = setInteractVehicles(),
    job = {"vanilla"}, distance = 6 })

    exports["lcrp-interact"]:AddBoxZone("vanillaPaycheck", vector3(93.72, -1294.54, 29.26), 1.0, 1.2, {
        name="vanillaPaycheck",
        heading=30,
        --debugPoly=true,
        minZ=28.26,
        maxZ=29.86,
        }, {
        options = {
            {
                event = "deliveries:client:getPaycheck",
                icon = "fas fa-money-bill-wave",
                label = "Receive Paycheck",
                duty = true,
            },
        },
    job = {"vanilla"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("galaxyInsideBlip", vector3(410.11, 242.7, 93.41), 5.0, 1, {
        name="galaxyInsideBlip",
        heading=345,
        --debugPoly=true,
        minZ=92.01,
        maxZ=98.01,
        }, {
        options = {
            {
                event = "deliveries:client:galaxyBlipToggle",
                icon = "fas fa-portal-exit",
                label = "Go outside",
                duty = true,
                parameters = "outside"
            },
        },
    job = {"galaxy"}, distance = 7 })

    exports["lcrp-interact"]:AddBoxZone("galaxyOutsideBlip", vector3(323.36, 266.3, 104.33), 6.8, 5.2, {
        name="galaxyOutsideBlip",
        heading=5,
        --debugPoly=true,
        minZ=102.53,
        maxZ=107.13,
        }, {
        options = {
            {
                event = "deliveries:client:galaxyBlipToggle",
                icon = "fas fa-portal-enter",
                label = "Go inside",
                duty = true,
                parameters = "inside"
            },
        },
    job = {"galaxy"}, distance = 7 })

end)

RegisterNetEvent("deliveries:client:galaxyBlipToggle")
AddEventHandler("deliveries:client:galaxyBlipToggle", function(loc)
    local blip = Config.Locations.stores.galaxy.blips[loc]
    local entity = PlayerPedId()
    if IsPedInAnyVehicle(entity, false) then
        entity = GetVehiclePedIsUsing(entity)
    end
    
    if loc == "outside" then
        SetEntityCoords(entity, blip.x, blip.y, blip.z)
        SetEntityHeading(entity, 74.52)
    else
        SetEntityCoords(entity, blip.x, blip.y, blip.z)
        SetEntityHeading(entity, 275.13)
    end
end)

function setInteractVehicles()
    vehicles = {{
        event = "deliveries:client:storeVehicle",
        icon = "",
        label = "",
        duty = true,
        storeVeh = true
    }}

    for k,v in pairs(Config.Vehicles) do
        table.insert(vehicles, {
            event = "deliveries:client:takeVehicle",
            icon = "fas fa-truck",
            label = v.." | Deposit : ".."$"..Config.BailPrice,
            duty = true,
            parameters = k
        })
    end

    return vehicles
end


RegisterNetEvent("deliveries:client:storeVehicle")
AddEventHandler("deliveries:client:storeVehicle", function(vehicle)
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1)), -1) == GetPlayerPed(-1) then
            if isTruckerVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
                DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                RemoveBlip(CurrentBlip)
                TriggerServerEvent('lcrp-deliveries:server:DoBail', false)
            else
                scCore.Notification('This is not the delivery vehicle!', 'error')
            end
        else
            scCore.Notification('You must be a driver','error')
        end
    end
end)

RegisterNetEvent("deliveries:client:takeVehicle")
AddEventHandler("deliveries:client:takeVehicle", function(veh)
    if vehicle ~= nil then
        DeleteVehicle(vehicle)
    end
    if CurrentBlip ~= nil then
        RemoveBlip(CurrentBlip)
        CurrentBlip = nil
    end
    vehicle = nil
    TakeOutVehicle(veh)
end)

RegisterNetEvent("deliveries:client:pickupFromTrunk")
AddEventHandler("deliveries:client:pickupFromTrunk", function()
    if hasStock and not hasBox then
        if not isWorking then
            isWorking = true
            TriggerEvent('animations:client:EmoteCommandStart', {"bumbin"})
            scCore.TaskBar("work_carrybox", "Picking up products", 2000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
                SetVehicleDoorOpen(vehicle, 3, false, false),
                SetVehicleDoorOpen(vehicle, 2, false, false),
            }, {}, {}, {}, function() -- Done
                isWorking = false
                TriggerEvent('animations:client:EmoteCommandStart', {"box"})
                hasBox = true
            end, function() -- Cancel
                isWorking = false
                scCore.Notification("Canceled", "error")
            end)
        end
    end
end)

RegisterNetEvent("deliveries:client:getPaycheck")
AddEventHandler("deliveries:client:getPaycheck", function()
    RemoveTruckerBlips() -- Removes blip if stuck
    if JobsDone > 0 then
        TriggerServerEvent("lcrp-deliveries:server:FuckYouFluxPAYMENT", JobsDone)
        JobsDone = 0
        if #LocationsDone == #Config.Locations["stores"] then
            LocationsDone = {}
        end
        if CurrentBlip ~= nil then
            RemoveBlip(CurrentBlip)
            CurrentBlip = nil
        end
    else
        scCore.Notification("You haven't done any work yet", "error")
    end
end)


RegisterNetEvent("deliveries:client:deliverProducts")
AddEventHandler("deliveries:client:deliverProducts", function()
    if hasBox then
        isWorking = true
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        Citizen.Wait(500)
        TriggerEvent('animations:client:EmoteCommandStart', {"bumbin"})
        scCore.TaskBar("work_dropbox", "Delivering products", 2000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            isWorking = false
            ClearPedTasks(GetPlayerPed(-1))
            hasBox = false
            currentCount = currentCount + 1
            if currentCount == CurrentLocation.dropcount then
                TriggerServerEvent("lcrp-shops:server:RestockShopItems", CurrentLocation.store)
                scCore.Notification("You have delivered all products, you may go restock or collect your bonus.")
                SetVehicleDoorShut(vehicle, 3, false)
                SetVehicleDoorShut(vehicle, 2, false)
                if CurrentBlip ~= nil then
                    RemoveBlip(CurrentBlip)
                    CurrentBlip = nil
                end
                CurrentLocation = nil
                currentCount = 0
                JobsDone = JobsDone + 1
                TriggerServerEvent('police:server:BusinessTransaction', myShop, math.floor(0.5 * kmsDone))
                hasStock = false
                getNewLocation()
            end
        end, function() -- Cancel
            isWorking = false
            ClearPedTasks(GetPlayerPed(-1))
            scCore.Notification("Canceled", "error")
        end)
    else
        if hasStock then
            scCore.Notification('You left the products in the trunk!','error')
        else
            scCore.Notification('Pickup products on your GPS!','error')
        end
    end
end)

RegisterNetEvent("deliveries:client:pickupProducts")
AddEventHandler("deliveries:client:pickupProducts", function()
    if not hasStock then
        if isTruckerVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), true)) and CurrentPlate == GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), true)) then
            scCore.TaskBar("work_dropbox", "Getting trunk stocked up with products", 30000, false, true, { 
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
                SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), true), 3, false, false),
                SetVehicleDoorOpen(GetVehiclePedIsIn(GetPlayerPed(-1), true), 2, false, false),
            }, {}, {}, {}, function() -- Done
                RemoveBlip(CurrentBlip)
                hasStock = true
                SetVehicleDoorShut(GetVehiclePedIsIn(GetPlayerPed(-1), true), 3, false)
                SetVehicleDoorShut(GetVehiclePedIsIn(GetPlayerPed(-1), true), 2, false)
                ClearPedTasks(GetPlayerPed(-1))
                scCore.Notification("Your trunk is full. You're ready to go.")
                getNewLocation()
            end, function() -- Cancel
                isWorking = false
                SetVehicleDoorShut(GetVehiclePedIsIn(GetPlayerPed(-1), true), 3, false)
                SetVehicleDoorShut(GetVehiclePedIsIn(GetPlayerPed(-1), true), 2, false)
                ClearPedTasks(GetPlayerPed(-1))
                scCore.Notification("Canceled", "error")
            end)
        end
    else
        scCore.Notification("Your trunk is full. You're ready to go.")
    end
end)

function CanPickupProducts(entity)
    if hasJob() and onDuty and GetEntityType(entity) == 2 and hasStock and not hasBox and vehicle ~= nil and GetVehicleNumberPlateText(entity) == GetVehicleNumberPlateText(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetOffsetFromEntityInWorldCoords(entity, 0, -2.5, 0), true) < 1.5 then
        return true  
    else
        return false
    end
end

function hasJob()
    if string.match(PlayerJob.name,"supermarket") or string.match(PlayerJob.name,"ltdgasoline") or string.match(PlayerJob.name,"cockatoos") or string.match(PlayerJob.name,"bahamas") or string.match(PlayerJob.name,"galaxy") or string.match(PlayerJob.name,"vanilla") and onDuty then
        return true
    else
        return false
    end
end
--[[ 
    <i class="fas fa-truck"></i> 
    <i class="fas fa-truck-loading"></i>
    <i class="fas fa-apple-crate"></i>
]]
