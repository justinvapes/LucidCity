local ClosestBerth = 1
local BoatsSpawned = false
local ModelLoaded = true
local SpawnedBoats = {}
local Buying = false
local notInteressted = false
local playerBoats = {}

Citizen.CreateThread(function()
    for k, v in pairs(Boatshop.Docks) do
        DockGarage = AddBlipForCoord(v.coords.put.x, v.coords.put.y, v.coords.put.z)

        SetBlipSprite (DockGarage, 410)
        SetBlipDisplay(DockGarage, 4)
        SetBlipScale  (DockGarage, 0.8)
        SetBlipAsShortRange(DockGarage, true)
        SetBlipColour(DockGarage, 3)
    
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.label)
        EndTextCommandSetBlipName(DockGarage)
    end

    for k, v in pairs(Boatshop.Depots) do
        BoatDepot = AddBlipForCoord(v.coords.take.x, v.coords.take.y, v.coords.take.z)

        SetBlipSprite (BoatDepot, 410)
        SetBlipDisplay(BoatDepot, 4)
        SetBlipScale  (BoatDepot, 0.8)
        SetBlipAsShortRange(BoatDepot, true)
        SetBlipColour(BoatDepot, 3)
    
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.label)
        EndTextCommandSetBlipName(BoatDepot)
    end
end)

-- Berth's Boatshop Loop

Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        local BerthDist = GetDistanceBetweenCoords(pos, Boatshop.Locations["berths"][1]["coords"]["boat"]["x"], Boatshop.Locations["berths"][1]["coords"]["boat"]["y"], Boatshop.Locations["berths"][1]["coords"]["boat"]["z"], false)

        if BerthDist < 100 then
            if not BoatsSpawned then
                SpawnBerthBoats()
            end
        elseif BerthDist > 110 then
            if BoatsSpawned then
                BoatsSpawned = false
            end
        end

        Citizen.Wait(3000)
    end
end)

function SpawnBerthBoats()
    for loc,_ in pairs(Boatshop.Locations["berths"]) do
        if SpawnedBoats[loc] ~= nil then
            scCore.Functions.DeleteVehicle(SpawnedBoats[loc])
        end
		local model = GetHashKey(Boatshop.Locations["berths"][loc]["boatModel"])
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local veh = CreateVehicle(model, Boatshop.Locations["berths"][loc]["coords"]["boat"]["x"], Boatshop.Locations["berths"][loc]["coords"]["boat"]["y"], Boatshop.Locations["berths"][loc]["coords"]["boat"]["z"], false, false)

        SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)
		SetEntityInvincible(veh,true)
        SetEntityHeading(veh, Boatshop.Locations["berths"][loc]["coords"]["boat"]["h"])
        SetVehicleDoorsLocked(veh, 2)

		FreezeEntityPosition(veh,true)     
        SpawnedBoats[loc] = veh
    end
    BoatsSpawned = true
end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()  
    exports["lcrp-interact"]:AddBoxZone("boat1", vector3(-725.74, -1327.61, 3.07), 16.0, 4.6, {
        name="boat1",
        heading=50,
        --debugPoly=true,
        minZ=-0.33,
        maxZ=3.47 }, {
        options = {
            {
                event = 'lcrp-boatshop:server:BuyBoat',
                serverEvent = true,
                icon = "fas fa-anchor",
                label = "Buy Marquis for $"..Boatshop.ShopBoats["marquis"]["price"],
                duty = false,
                parameters = "marquis"
            },
        },
    job = {"all"}, distance = 8.0 })  

    exports["lcrp-interact"]:AddBoxZone("boat2", vector3(-732.65, -1333.64, 1.28), 11.4, 3.6, {
        name="boat2",
        heading=50,
        --debugPoly=true,
        minZ=0.28,
        maxZ=1.88 }, {
        options = {
            {
                event = 'lcrp-boatshop:server:BuyBoat',
                serverEvent = true,
                icon = "fas fa-anchor",
                label = "Buy Toro for $"..Boatshop.ShopBoats["toro"]["price"],
                duty = false,
                parameters = "toro"
            },
        },
    job = {"all"}, distance = 5.0 })  

    exports["lcrp-interact"]:AddBoxZone("boat3", vector3(-737.81, -1340.95, 1.35), 9.6, 4.4, {
        name="boat3",
        heading=50,
        --debugPoly=true,
        minZ=-0.25,
        maxZ=2.55 }, {
        options = {
            {
                event = 'lcrp-boatshop:server:BuyBoat',
                serverEvent = true,
                icon = "fas fa-anchor",
                label = "Buy Speeder for $"..Boatshop.ShopBoats["speeder"]["price"],
                duty = false,
                parameters = "speeder"
            },
        },
    job = {"all"}, distance = 5.0 })  

    exports["lcrp-interact"]:AddBoxZone("boat4", vector3(-743.83, -1347.5, 1.35), 8.8, 3.8, {
        name="boat4",
        heading=230,
        --debugPoly=true,
        minZ=0.35,
        maxZ=2.55 }, {
        options = {
            {
                event = 'lcrp-boatshop:server:BuyBoat',
                serverEvent = true,
                icon = "fas fa-anchor",
                label = "Buy Jetmax for $"..Boatshop.ShopBoats["jetmax"]["price"],
                duty = false,
                parameters = "jetmax"
            },
        },
    job = {"all"}, distance = 5.0 })  

    exports["lcrp-interact"]:AddBoxZone("boat5", vector3(-749.77, -1354.77, 1.35), 8.4, 3.2, {
        name="boat5",
        heading=50,
        --debugPoly=true,
        minZ=0.35,
        maxZ=2.55 }, {
        options = {
            {
                event = 'lcrp-boatshop:server:BuyBoat',
                serverEvent = true,
                icon = "fas fa-anchor",
                label = "Buy Tropic for $"..Boatshop.ShopBoats["tropic"]["price"],
                duty = false,
                parameters = "tropic"
            },
        },
    job = {"all"}, distance = 5.0 })  

    exports["lcrp-interact"]:AddBoxZone("boat6", vector3(-755.0, -1362.12, 1.35), 9.2, 3.2, {
        name="boat6",
        heading=50,
        --debugPoly=true,
        minZ=0.35,
        maxZ=2.35 }, {
        options = {
            {
                event = 'lcrp-boatshop:server:BuyBoat',
                serverEvent = true,
                icon = "fas fa-anchor",
                label = "Buy Suntrap for $"..Boatshop.ShopBoats["suntrap"]["price"],
                duty = false,
                parameters = "suntrap"
            },
        },
    job = {"all"}, distance = 5.0 })  

    exports["lcrp-interact"]:AddBoxZone("boat7", vector3(-768.95, -1378.15, 1.41), 10.6, 4.0, {
        name="boat7",
        heading=50,
        --debugPoly=true,
        minZ=0.41,
        maxZ=2.01 }, {
        options = {
            {
                event = 'lcrp-boatshop:server:BuyBoat',
                serverEvent = true,
                icon = "fas fa-anchor",
                label = "Buy Dinghy for $"..Boatshop.ShopBoats["dinghy"]["price"],
                duty = false,
                parameters = "dinghy"
            },
        },
    job = {"all"}, distance = 5.0 })  

    exports["lcrp-interact"]:AddBoxZone("boat8", vector3(-775.02, -1384.91, 1.28), 3.6, 1.6, {
        name="boat8",
        heading=50,
        --debugPoly=true,
        minZ=-1.12,
        maxZ=1.08 }, {
        options = {
            {
                event = 'lcrp-boatshop:server:BuyBoat',
                serverEvent = true,
                icon = "fas fa-anchor",
                label = "Buy Seashark for $"..Boatshop.ShopBoats["seashark"]["price"],
                duty = false,
                parameters = "seashark"
            },
        },
    job = {"all"}, distance = 5.0 })  

    exports["lcrp-interact"]:AddBoxZone("boatImpound", vector3(-772.62, -1431.35, 1.6), 4.2, 3.4, {
        name="boatImpound",
        heading=320,
        --debugPoly=true,
        minZ=0.6,
        maxZ=4.6 }, {
        options = {
            {
                event = 'lcrp-boatshop:client:openBoatImpound',
                icon = "fas fa-anchor",
                label = "Check impounded boats",
                duty = false,
                parameters = "lsymc"
            },
        },
    job = {"all"}, distance = 5.0 })  

    exports["lcrp-interact"]:AddBoxZone("lsymcTake", vector3(-794.69, -1510.87, 1.6), 3.4, 8.4, {
        name="lsymcTake",
        heading=20,
        --debugPoly=true,
        minZ=0.6,
        maxZ=4.6 }, {
        options = {
            {
                event = 'lcrp-boatshop:client:openBoatGarage',
                icon = "fas fa-anchor",
                label = "My stored boats",
                duty = false,
                parameters = "lsymc"
            },
        },
    job = {"all"}, distance = 3.0 })  

    exports["lcrp-interact"]:AddBoxZone("lsymcPut", vector3(-788.4, -1500.01, -0.47), 8.0, 9.8, {
        name="lsymcPut",
        heading=20,
        --debugPoly=true,
        minZ=-4.67,
        maxZ=4.53 }, {
        options = {
            {
                event = 'lcrp-boatshop:client:storeBoat',
                icon = "fas fa-anchor",
                label = "Store boat",
                duty = false,
                parameters = "lsymc",
                onlyInVeh = true,
            },
        },
    job = {"all"}, distance = 8.0 })  
end)

RegisterNetEvent('lcrp-boatshop:client:openBoatImpound')
AddEventHandler('lcrp-boatshop:client:openBoatImpound', function(dock)
    MenuBoatDepot()
    Menu.hidden = not Menu.hidden
    ClosestDock = dock
    renderMenuFunc()
end)

RegisterNetEvent('lcrp-boatshop:client:openBoatGarage')
AddEventHandler('lcrp-boatshop:client:openBoatGarage', function(dock)
    MenuGarage()
    Menu.hidden = not Menu.hidden
    ClosestDock = dock
    renderMenuFunc()
end)

RegisterNetEvent('lcrp-boatshop:client:storeBoat')
AddEventHandler('lcrp-boatshop:client:storeBoat', function(dock)
    ClosestDock = dock
    RemoveVehicle()
end)

function RemoveVehicle()
    local ped = GetPlayerPed(-1)
    local Boat = IsPedInAnyBoat(ped)

    if Boat then
        local CurVeh = GetVehiclePedIsIn(ped)
        local plate = GetVehicleNumberPlateText(CurVeh)
        playerBoats[plate] = nil
        TriggerServerEvent('lcrp-boatshop:server:SetBoatState', plate, 1, ClosestDock)
        scCore.Functions.DeleteVehicle(CurVeh)
        SetEntityCoords(ped, Boatshop.Docks[ClosestDock].coords.take.x, Boatshop.Docks[ClosestDock].coords.take.y, Boatshop.Docks[ClosestDock].coords.take.z)
    end
end

renderMenuFunc = function()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5)
            if not Menu.hidden then
                Menu.renderGUI()
            else
                break
            end
        end
    end)
end

RegisterNetEvent('lcrp-boatshop:client:BuyBoat')
AddEventHandler('lcrp-boatshop:client:BuyBoat', function(boatModel, plate)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    scCore.Functions.SpawnVehicle(boatModel, function(veh)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        exports['LegacyFuel']:SetFuel(veh, 100)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, Boatshop.SpawnVehicle.h)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
    end, Boatshop.SpawnVehicle, false)
    SetTimeout(1000, function()
        DoScreenFadeIn(250)
    end)
end)

Citizen.CreateThread(function()
    BoatShop = AddBlipForCoord(Boatshop.Locations["berths"][1]["coords"]["boat"]["x"], Boatshop.Locations["berths"][1]["coords"]["boat"]["y"], Boatshop.Locations["berths"][1]["coords"]["boat"]["z"])

    SetBlipSprite (BoatShop, 410)
    SetBlipDisplay(BoatShop, 4)
    SetBlipScale  (BoatShop, 0.8)
    SetBlipAsShortRange(BoatShop, true)
    SetBlipColour(BoatShop, 3)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Boat shop")
    EndTextCommandSetBlipName(BoatShop)
end)

function ClearTimeOut()
    notInteressted = not notInteressted
end

function MenuBoatDepot()
    ClearMenu()
    scCore.TriggerServerCallback("lcrp-boatshop:server:GetDepotBoats", function(result)
        MenuTitle = "Vehicles :"

        if result == nil then
            scCore.Notification("You have no boats in impound", "error", 5000)
            CloseMenu()
        else
            for k, v in pairs(result) do
                currentFuel = v.fuel
                state = "Garage"
                if v.state == 0 then
                    state = "Storage"
                end

                Menu.addButton(Boatshop.ShopBoats[v.model]["label"], "TakeOutDepotBoat", v, state, "Fuel: "..currentFuel.. "%")
            end
        end
        Menu.addButton("Close Menu", "CloseMenu", nil) 
    end)
end

function VehicleList()
    ClearMenu()
    scCore.TriggerServerCallback("lcrp-boatshop:server:GetMyBoats", function(result)
        MenuTitle = "My Vehicles :"
        if result == nil then
            scCore.Notification("You have no vehicles in boat garage", "error", 5000)
            CloseMenu()
        else
            Menu.addButton(Boatshop.Docks[ClosestDock].label, "yessir", Boatshop.Docks[ClosestDock].label)

            for k, v in pairs(result) do
                currentFuel = v.fuel
                state = "Garage"
                if v.state == 0 then
                    state = "Out"
                end

                Menu.addButton(Boatshop.ShopBoats[v.model]["label"], "TakeOutVehicle", v, state, "Fuel: "..currentFuel.. "%")
            end
        end
            
        Menu.addButton("Back", "MenuGarage", nil)
    end, ClosestDock)
end

function TakeOutVehicle(vehicle)
    if vehicle.state == 1 then
        if playerBoats[vehicle.plate] ~= nil then
            scCore.Notification("The boat is already out!", "error", 4500)
        else
            scCore.Functions.SpawnVehicle(vehicle.model, function(veh)
                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, Boatshop.Docks[ClosestDock].coords.put.h)
                exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
                scCore.Notification("Vehicle Out: Fuel: "..currentFuel.. "%", "primary", 4500)
                CloseMenu()
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                SetVehicleEngineOn(veh, true, true)
                TriggerServerEvent('lcrp-boatshop:server:SetBoatState', GetVehicleNumberPlateText(veh), 0, ClosestDock)
                playerBoats[vehicle.plate] = veh
            end, Boatshop.Docks[ClosestDock].coords.put, true)
        end
    else
        scCore.Notification("The boat is not in garage", "error", 4500)
    end
end

function TakeOutDepotBoat(vehicle)
    if playerBoats[vehicle.plate] ~= nil and DoesEntityExist(playerBoats[vehicle.plate]) then
        scCore.Notification("The boat is already out!", "error", 4500)
    else
        scCore.Functions.SpawnVehicle(vehicle.model, function(veh)
            SetVehicleNumberPlateText(veh, vehicle.plate)
            SetEntityHeading(veh, Boatshop.Depots[ClosestDock].coords.put.h)
            exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
            scCore.Notification("Vehicle out: Fuel: "..currentFuel.. "%", "primary", 4500)
            CloseMenu()
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
            SetVehicleEngineOn(veh, true, true)
            playerBoats[vehicle.plate] = veh
        end, Boatshop.Depots[ClosestDock].coords.put, true)
    end
end

function MenuGarage()
    ClearMenu()
    MenuTitle = "Garage"
    Menu.addButton("My vehicles", "VehicleList", nil)
    Menu.addButton("Close Menu", "CloseMenu", nil) 
end

function CloseMenu()
    Menu.hidden = true
    ClearMenu()
end

function ClearMenu()
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end