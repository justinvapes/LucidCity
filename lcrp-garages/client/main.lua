scCore = nil

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

local currentHouseGarage = nil
local hasGarageKey = nil
local currentGarage = nil
local OutsideVehicles = {}
local HouseGarages = {}

RegisterNetEvent('lcrp-garages:client:setHouseGarage')
AddEventHandler('lcrp-garages:client:setHouseGarage', function(house, hasKey)
    currentHouseGarage = house.id
    currentHouseData = house
    hasGarageKey = hasKey
end)

RegisterNetEvent('lcrp-garages:client:houseGarageConfig')
AddEventHandler('lcrp-garages:client:houseGarageConfig', function(key, value, allData)
    if allData ~= nil then
        HouseGarages = allData
    else
        HouseGarages[key] = {
            label = key,
            takeVehicle = value,
        }
    end
end)

RegisterNetEvent('lcrp-garages:client:addHouseGarage')
AddEventHandler('lcrp-garages:client:addHouseGarage', function(house, garageInfo)
    HouseGarages[house] = garageInfo
end)

-- function AddOutsideVehicle(plate, veh)
--     OutsideVehicles[plate] = veh
--     TriggerServerEvent('lcrp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
-- end

RegisterNetEvent('lcrp-garages:client:takeOutImpound')
AddEventHandler('lcrp-garages:client:takeOutImpound', function(vehicle)
    if OutsideVehicles ~= nil and next(OutsideVehicles) ~= nil then
        if OutsideVehicles[vehicle.plate] ~= nil then
            local VehExists = DoesEntityExist(OutsideVehicles[vehicle.plate])
            if not VehExists then
                scCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
                    scCore.TriggerServerCallback('lcrp-garages:server:GetVehicleProperties', function(properties)
                        scCore.Functions.SetVehicleProperties(veh, properties)
                        enginePercent = round(vehicle.engine / 10, 0)
                        bodyPercent = round(vehicle.body / 10, 0)
                        currentFuel = vehicle.fuel
                        if vehicle.plate ~= nil then
                            DeleteVehicle(OutsideVehicles[vehicle.plate])
                            OutsideVehicles[vehicle.plate] = veh
                            TriggerServerEvent('lcrp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                        end
                        if vehicle.status ~= nil and next(vehicle.status) ~= nil then
                            TriggerServerEvent('lcrp-tuning:server:LoadStatus', vehicle.status, vehicle.plate)
                        end
                        if vehicle.vehicle == "urus" then
                            SetVehicleExtra(veh, 1, false)
                            SetVehicleExtra(veh, 2, true)
                        end
                        SetVehicleDoorsLocked(veh, 2)
                        SetVehicleNumberPlateText(veh, vehicle.plate)
                        SetEntityHeading(veh, Impounds[currentGarage].takeVehicle.h)
                        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                        exports['LegacyFuel']:SetFuel(veh, 100)
                        SetEntityAsMissionEntity(veh, true, true)
                        TriggerServerEvent('lcrp-garages:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                        scCore.Notification("Vehicle out", "primary", 4500)
                        --TriggerServerEvent("lcrp-garages:server:PayImpoundPrice", vehicle)
                        closeMenuFull()
                        SetVehicleEngineOn(veh, true, true)
                        Citizen.Wait(500)
                        TriggerEvent("vehiclekeys:client:SetOwner")
                    end, vehicle.plate)
                end, Impounds[currentGarage].spawnPoint, true)
            else
                scCore.Notification('You cannot duplicate this vehicle', 'error')
                AddTemporaryBlip(OutsideVehicles[vehicle.plate])
            end
        else
            scCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
                scCore.TriggerServerCallback('lcrp-garages:server:GetVehicleProperties', function(properties)
                    scCore.Functions.SetVehicleProperties(veh, properties)
                    enginePercent = round(vehicle.engine / 10, 0)
                    bodyPercent = round(vehicle.body / 10, 0)
                    currentFuel = vehicle.fuel
                    if vehicle.plate ~= nil then
                        DeleteVehicle(OutsideVehicles[vehicle.plate])
                        OutsideVehicles[vehicle.plate] = veh
                        TriggerServerEvent('lcrp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                    end
                    if vehicle.status ~= nil and next(vehicle.status) ~= nil then
                        TriggerServerEvent('lcrp-tuning:server:LoadStatus', vehicle.status, vehicle.plate)
                    end
                    if vehicle.vehicle == "urus" then
                        SetVehicleExtra(veh, 1, false)
                        SetVehicleExtra(veh, 2, true)
                    end
                    SetVehicleDoorsLocked(veh, 2)
                    SetVehicleNumberPlateText(veh, vehicle.plate)
                    SetEntityHeading(veh, Impounds[currentGarage].takeVehicle.h)
                    TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                    exports['LegacyFuel']:SetFuel(veh, 100)
                    SetEntityAsMissionEntity(veh, true, true)
                    TriggerServerEvent('lcrp-garages:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                    scCore.Notification("Vehicle out", "primary", 4500)
                    --TriggerServerEvent("lcrp-garages:server:PayImpoundPrice", vehicle)
                    closeMenuFull()
                    SetVehicleEngineOn(veh, true, true)
                    Citizen.Wait(500)
                    TriggerEvent("vehiclekeys:client:SetOwner")
                end, vehicle.plate)
            end, Impounds[currentGarage].spawnPoint, true)
        end
    else
        scCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
            scCore.TriggerServerCallback('lcrp-garages:server:GetVehicleProperties', function(properties)
                scCore.Functions.SetVehicleProperties(veh, properties)
                enginePercent = round(vehicle.engine / 10, 0)
                bodyPercent = round(vehicle.body / 10, 0)
                currentFuel = vehicle.fuel
                doCarDamage(veh, vehicle)
                if vehicle.plate ~= nil then
                    OutsideVehicles[vehicle.plate] = veh
                    TriggerServerEvent('lcrp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                end

                if vehicle.status ~= nil and next(vehicle.status) ~= nil then
                    TriggerServerEvent('lcrp-tuning:server:LoadStatus', vehicle.status, vehicle.plate)
                end
                
                if vehicle.drivingdistance ~= nil then
                    local amount = round(vehicle.drivingdistance / 1000, -2)
                    TriggerEvent('lcrp-hud:client:UpdateDrivingMeters', true, amount)
                    TriggerServerEvent('lcrp-tuning:server:UpdateDrivingDistance', vehicle.drivingdistance, vehicle.plate)
                end

                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, Impounds[currentGarage].takeVehicle.h)
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                exports['LegacyFuel']:SetFuel(veh, 100)
                SetEntityAsMissionEntity(veh, true, true)
                TriggerServerEvent('lcrp-garages:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                scCore.Notification("Vehicle out", "primary", 4500)
                closeMenuFull()
                SetVehicleEngineOn(veh, true, true)
                Citizen.Wait(500)
                TriggerEvent("vehiclekeys:client:SetOwner")
            end, vehicle.plate)
        end, Impounds[currentGarage].spawnPoint, true)
    end
end)

function AddTemporaryBlip(vehicle)  
    local VehicleCoords = GetEntityCoords(vehicle)
    local TempBlip = AddBlipForCoord(VehicleCoords)
    local VehicleData = scCore.Shared.VehicleModels[GetEntityModel(vehicle)]

    SetBlipSprite (TempBlip, 225)
    SetBlipDisplay(TempBlip, 4)
    SetBlipScale  (TempBlip, 0.85)
    SetBlipAsShortRange(TempBlip, true)
    SetBlipColour(TempBlip, 0)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Temp Blip: "..VehicleData["name"])
    EndTextCommandSetBlipName(TempBlip)
    scCore.Notification("Your "..VehicleData["name"].." is temporarily (1min) indicated on the map!", "success", 10000)

    SetTimeout(60 * 1000, function()
        scCore.Notification('Your vehicle is NOT shown on the map anymore!', 'error')
        RemoveBlip(TempBlip)
    end)
end

Citizen.CreateThread(function()
    for k, v in pairs(Garages) do
        Garage = AddBlipForCoord(Garages[k].takeVehicle.x, Garages[k].takeVehicle.y, Garages[k].takeVehicle.z)

        SetBlipSprite (Garage, 357)
        SetBlipDisplay(Garage, 4)
        SetBlipScale  (Garage, 0.65)
        SetBlipAsShortRange(Garage, true)
        SetBlipColour(Garage, 3)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Garages[k].label)
        EndTextCommandSetBlipName(Garage)
    end

    for k, v in pairs(Impounds) do
        Impound = AddBlipForCoord(Impounds[k].takeVehicle.x, Impounds[k].takeVehicle.y, Impounds[k].takeVehicle.z)

        SetBlipSprite (Impound, 68)
        SetBlipDisplay(Impound, 4)
        SetBlipScale  (Impound, 0.7)
        SetBlipAsShortRange(Impound, true)
        SetBlipColour(Impound, 47)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Impounds[k].label)
        EndTextCommandSetBlipName(Impound)
    end
end)

function MenuGarage()
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("My vehicles", "VoertuigLijst", nil)
    Menu.addButton("Close Menu", "close", nil) 
end

function MenuImpound()
    MenuTitle = "Impound"
    ClearMenu()
    Menu.addButton("Impound", "ImpoundList", nil)
    Menu.addButton("Close Menu", "close", nil) 
end

function ImpoundList()
    scCore.TriggerServerCallback("lcrp-garages:server:GetImpoundVehicles", function(result)
        ped = GetPlayerPed(-1);
        MenuTitle = "Impounded Vehicles :"
        ClearMenu()

        if result == nil then
            scCore.Notification("There are no vehicles in the Impound", "error", 5000)
            closeMenuFull()
        else
            vehPerPage = 12
            if #result <= 12 then
                vehPerPage = #result
            else
                Menu.addButton("Next Page", "vehListNextPage", {veh = result, page = 1})
            end

            for k=1,vehPerPage do
                enginePercent = round(result[k].engine / 10, 0)
                bodyPercent = round(result[k].body / 10, 0)
                currentFuel = result[k].fuel

                if result[k].state == 0 then
                    result[k].state = "Impound"
                end

                local label = scCore.Shared.Vehicles[result[k].vehicle]["name"]
                if scCore.Shared.Vehicles[result[k].vehicle]["brand"] ~= nil then
                    label = scCore.Shared.Vehicles[result[k].vehicle]["brand"].." "..scCore.Shared.Vehicles[result[k].vehicle]["name"]
                end
                Menu.addButton(label, "TakeOutImpoundVehicle", result[k], result[k].state .. " ($"..result[k].Impoundprice..")", " Engine: " .. enginePercent.."%", " Body: " .. bodyPercent.."%", " Fuel: "..currentFuel.."%")
            end
        end
            
        Menu.addButton("Back", "MenuImpound",nil)
    end)
end

function vehListNextPage(data)
    ClearMenu()
    resultsPerPage = 12
    toShow = 1 + resultsPerPage * data.page
    
    if toShow + resultsPerPage < #data.veh then
        Menu.addButton("Next Page", "vehListNextPage", {veh = data.veh, page = data.page + 1})
    else
        resultsPerPage = #data.veh - toShow
    end    
    for k=toShow,toShow+resultsPerPage do
        enginePercent = round(data.veh[k].engine / 10, 0)
        bodyPercent = round(data.veh[k].body / 10, 0)
        currentFuel = data.veh[k].fuel

        if data.veh[k].state == 0 then
            data.veh[k].state = "Impound"
        end
        
        local label = scCore.Shared.Vehicles[data.veh[k].vehicle]["name"]
        if scCore.Shared.Vehicles[data.veh[k].vehicle]["brand"] ~= nil then
            label = scCore.Shared.Vehicles[data.veh[k].vehicle]["brand"].." "..scCore.Shared.Vehicles[data.veh[k].vehicle]["name"]
        end
        Menu.addButton(label, "TakeOutImpoundVehicle", data.veh[k], data.veh[k].state .. " ($"..data.veh[k].Impoundprice..")", " Engine: " .. enginePercent.."%", " Body: " .. bodyPercent.."%", " Fuel: "..currentFuel.."%")
    end
    if data.page == 0 then
        Menu.addButton("Back", "MenuImpound", nil)
    else
        Menu.addButton("Previous Page", "vehListNextPage", {veh = data.veh, page = data.page - 1})
    end
end

function MenuHouseGarage(house)
    MenuTitle = HouseGarages[house].label
    ClearMenu()
    Menu.addButton("My vehicles", "HouseGarage", house)
    Menu.addButton("Close Menu", "close", nil) 
end

function yeet(label)
    print(label)
end

function HouseGarage(house)
    scCore.TriggerServerCallback("lcrp-garages:server:GetHouseVehicles", function(result)
        MenuTitle = "Impound Vehicles :"
        ClearMenu()

        if result == nil then
            scCore.Notification("You have no vehicles in your garage", "error", 5000)
            closeMenuFull()
        else
            Menu.addButton(HouseGarages[house].label, "yeet", HouseGarages[house].label)

            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel
                curGarage = HouseGarages[house].label

                if v.state == 0 then
                    v.state = "Out"
                elseif v.state == 1 then
                    v.state = "Garage"
                elseif v.state == 2 then
                    v.state = "Impound"
                end
                
                local label = scCore.Shared.Vehicles[v.vehicle]["name"]
                if scCore.Shared.Vehicles[v.vehicle]["brand"] ~= nil then
                    label = scCore.Shared.Vehicles[v.vehicle]["brand"].." "..scCore.Shared.Vehicles[v.vehicle]["name"]
                end

                Menu.addButton(label, "TakeOutGarageVehicle", v, v.state, " Engine: " .. enginePercent.."%", " Body: " .. bodyPercent.."%", " Fuel: "..currentFuel.."%")
            end
        end
            
        Menu.addButton("Back", "MenuHouseGarage", house)
    end, house)
end

function getPlayerVehicles(garage)
    local vehicles = {}

    return vehicles
end

function VoertuigLijst()
    scCore.TriggerServerCallback("lcrp-garages:server:GetUserVehicles", function(result)
        ped = GetPlayerPed(-1);
        MenuTitle = "My Vehicles :"
        ClearMenu()

        if result == nil then
            scCore.Notification("You have no vehicles in this garage", "error", 5000)
            closeMenuFull()
        else
            Menu.addButton(Garages[currentGarage].label, "yeet", Garages[currentGarage].label)

            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel
                curGarage = Garages[v.garage].label
                
                if v.state == 0 then
                    v.state = "Out"
                elseif v.state == 1 then
                    v.state = "Garage"
                elseif v.state == 2 then
                    v.state = "In Beslag"
                end

                local label = scCore.Shared.Vehicles[v.vehicle]["name"]
                if scCore.Shared.Vehicles[v.vehicle]["brand"] ~= nil then
                    label = scCore.Shared.Vehicles[v.vehicle]["brand"].." "..scCore.Shared.Vehicles[v.vehicle]["name"]
                end

                Menu.addButton(label, "TakeOutVehicle", v, v.state, " Engine: " .. enginePercent .. "%", " Body: " .. bodyPercent.. "%", " Fuel: "..currentFuel.. "%")
            end
        end
            
        Menu.addButton("Back", "MenuGarage", nil)
    end, currentGarage)
end


function TakeOutVehicle(vehicle)
    if not IsPedInAnyVehicle(PlayerPedId()) then
        if vehicle.state == "Garage" then
            enginePercent = round(vehicle.engine / 10, 1)
            bodyPercent = round(vehicle.body / 10, 1)
            currentFuel = vehicle.fuel

            scCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
                scCore.TriggerServerCallback('lcrp-garages:server:GetVehicleProperties', function(properties)
                    doCarDamage(veh, vehicle)
                    if vehicle.plate ~= nil then
                        OutsideVehicles[vehicle.plate] = veh
                        TriggerServerEvent('lcrp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                    end

                    if vehicle.status ~= nil and next(vehicle.status) ~= nil then
                        TriggerServerEvent('lcrp-tuning:server:LoadStatus', vehicle.status, vehicle.plate)
                    end

                    if vehicle.vehicle == "urus" then
                        SetVehicleExtra(veh, 1, false)
                        SetVehicleExtra(veh, 2, true)
                    end
                    
                    if vehicle.drivingdistance ~= nil then
                        local amount = round(vehicle.drivingdistance / 1000, -2)
                        TriggerEvent('lcrp-hud:client:UpdateDrivingMeters', true, amount)
                        TriggerServerEvent('lcrp-tuning:server:UpdateDrivingDistance', vehicle.drivingdistance, vehicle.plate)
                    end
                    SetVehicleDoorsLocked(veh, 2)
                    scCore.Functions.SetVehicleProperties(veh, properties)
                    SetVehicleNumberPlateText(veh, vehicle.plate)
                    SetEntityHeading(veh, Garages[currentGarage].spawnPoint.h)
                    exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
                    SetVehicleEngineOn(veh, true, true)
                    SetEntityAsMissionEntity(veh, true, true)
                    TriggerServerEvent('lcrp-garages:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                    scCore.Notification("Vehicle out: Engine: " .. enginePercent .. "% Body: " .. bodyPercent.. "% Fuel: "..currentFuel.. "%", "primary", 4500)
                    closeMenuFull()
                    TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                    Citizen.Wait(500)
                    TriggerEvent("vehiclekeys:client:SetOwner")
                end, vehicle.plate)
                
            end, Garages[currentGarage].spawnPoint, true)
        elseif vehicle.state == "Out" then
            scCore.Notification("Vehicle is out, check impound", "error", 2500)
        elseif vehicle.state == "Impounded" then
            scCore.Notification("This vehicle has been seized by the Police", "error", 4000)
        end
    else
        scCore.Notification("You are already on a vehicle!", "error", 2500)
    end
end

function TakeOutImpoundVehicle(vehicle)
    if vehicle.state == "Impound" then
        TriggerServerEvent("lcrp-garages:server:PayImpoundPrice", vehicle)
    end
end

function TakeOutGarageVehicle(vehicle)
    if vehicle.state == "Garage" then
        scCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
            scCore.TriggerServerCallback('lcrp-garages:server:GetVehicleProperties', function(properties)
                scCore.Functions.SetVehicleProperties(veh, properties)
                enginePercent = round(vehicle.engine / 10, 1)
                bodyPercent = round(vehicle.body / 10, 1)
                currentFuel = vehicle.fuel
                doCarDamage(veh, vehicle)
                if vehicle.plate ~= nil then
                    OutsideVehicles[vehicle.plate] = veh
                    TriggerServerEvent('lcrp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                end
                
                
                if vehicle.drivingdistance ~= nil then
                    local amount = round(vehicle.drivingdistance / 1000, -2)
                    TriggerEvent('lcrp-hud:client:UpdateDrivingMeters', true, amount)
                    TriggerServerEvent('lcrp-tuning:server:UpdateDrivingDistance', vehicle.drivingdistance, vehicle.plate)
                end

                if vehicle.vehicle == "urus" then
                    SetVehicleExtra(veh, 1, false)
                    SetVehicleExtra(veh, 2, true)
                end

                if vehicle.status ~= nil and next(vehicle.status) ~= nil then
                    TriggerServerEvent('lcrp-tuning:server:LoadStatus', vehicle.status, vehicle.plate)
                end
                SetVehicleDoorsLocked(veh, 2)
                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, HouseGarages[currentHouseGarage].takeVehicle.h)
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
                SetVehicleEngineOn(veh, true, true)
                SetEntityAsMissionEntity(veh, true, true)
                TriggerServerEvent('lcrp-garages:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
                scCore.Notification("Vehicle out: Engine: " .. enginePercent .. "% Body: " .. bodyPercent.. "% Fuel: "..currentFuel.. "%", "primary", 4500)
                closeMenuFull()
                Citizen.Wait(500)
                TriggerEvent("vehiclekeys:client:SetOwner")
            end, vehicle.plate)
        end, HouseGarages[currentHouseGarage].takeVehicle, true)
    end
end

function doCarDamage(currentVehicle, veh)
	smash = false
	damageOutside = false
	damageOutside2 = false 
	local engine = veh.engine + 0.0
	local body = veh.body + 0.0
	if engine < 200.0 then
		engine = 200.0
    end
    
    if engine > 1000.0 then
        engine = 1000.0
    end

	if body < 150.0 then
		body = 150.0
	end
	if body < 900.0 then
		smash = true
	end

	if body < 800.0 then
		damageOutside = true
	end

	if body < 500.0 then
		damageOutside2 = true
	end

    Citizen.Wait(100)
    SetVehicleEngineHealth(currentVehicle, engine)
	if smash then
		SmashVehicleWindow(currentVehicle, 0)
		SmashVehicleWindow(currentVehicle, 1)
		SmashVehicleWindow(currentVehicle, 2)
		SmashVehicleWindow(currentVehicle, 3)
		SmashVehicleWindow(currentVehicle, 4)
	end
	if damageOutside then
		SetVehicleDoorBroken(currentVehicle, 1, true)
		SetVehicleDoorBroken(currentVehicle, 6, true)
		SetVehicleDoorBroken(currentVehicle, 4, true)
	end
	if damageOutside2 then
		SetVehicleTyreBurst(currentVehicle, 1, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 2, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 3, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 4, false, 990.0)
	end
	if body < 1000 then
		SetVehicleBodyHealth(currentVehicle, 985.1)
	end
end

function close()
    Menu.hidden = true
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function ClearMenu()
	--Menu = {}
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end


RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddBoxZone("garagea", vector3(275.58, -345.35, 44.92), 4.2, 3.2, {
        name="garagea",
        heading=340,
        --debugPoly=true,
        minZ=43.27,
        maxZ=47.27}, {
        options = {
            {
              event = "",
              icon = "",
              label = "Garage A",
              duty = false,
            },
            {
              event = "lcrp-garages:client:checkVehiclesGarage",
              icon = "fas fa-parking",
              label = "My parked vehicles",
              duty = false,
              parameters = "garagea"
            },
            {
              event = "lcrp-garages:client:parkVehicle",
              icon = "fad fa-key",
              label = "Park current vehicle",
              duty = false,
              onlyInVeh = true,
              parameters = "garagea",
    
            },
          },
        job = {"all"}, distance = 5 })

    exports["lcrp-interact"]:AddBoxZone("garageb", vector3(-330.13, -781.76, 33.96), 3.4, 1, {
        name="garageb",
        heading=130,
        --debugPoly=true,
        minZ=32.96,
        maxZ=34.96}, {
        options = {
            {
                event = "",
                icon = "",
                label = "Garage B",
                duty = false,
            },
            {
                event = "lcrp-garages:client:checkVehiclesGarage",
                icon = "fas fa-parking",
                label = "My parked vehicles",
                duty = false,
                parameters = "garageb"
            },
            {
                event = "lcrp-garages:client:parkVehicle",
                icon = "fad fa-key",
                label = "Park current vehicle",
                duty = false,
                onlyInVeh = true,
                parameters = "garageb",
    
            },
            },
        job = {"all"}, distance = 5 })
    
    
    exports["lcrp-interact"]:AddBoxZone("garagec", vector3(-1159.4, -739.74, 19.61), 4.0, 3.0, {
        name="garagec",
        heading=40,
        --debugPoly=true,
        minZ=18.61,
        maxZ=21.81}, {
        options = {
            {
                event = "",
                icon = "",
                label = "Garage C",
                duty = false,
            },
            {
                event = "lcrp-garages:client:checkVehiclesGarage",
                icon = "fas fa-parking",
                label = "My parked vehicles",
                duty = false,
                parameters = "garagec"
            },
            {
                event = "lcrp-garages:client:parkVehicle",
                icon = "fad fa-key",
                label = "Park current vehicle",
                duty = false,
                onlyInVeh = true,
                parameters = "garagec",
    
            },
            },
        job = {"all"}, distance = 5 })

    exports["lcrp-interact"]:AddBoxZone("garaged", vector3(67.89, 12.5, 68.92), 4.2, 3.0, {
        name="garaged",
        heading=340,
        --debugPoly=true,
        minZ=67.92,
        maxZ=71.12}, {
        options = {
            {
                event = "",
                icon = "",
                label = "Garage D",
                duty = false,
            },
            {
                event = "lcrp-garages:client:checkVehiclesGarage",
                icon = "fas fa-parking",
                label = "My parked vehicles",
                duty = false,
                parameters = "garaged"
            },
            {
                event = "lcrp-garages:client:parkVehicle",
                icon = "fad fa-key",
                label = "Park current vehicle",
                duty = false,
                onlyInVeh = true,
                parameters = "garaged",
    
            },
            },
        job = {"all"}, distance = 5 })

    exports["lcrp-interact"]:AddBoxZone("garagee", vector3(-477.41, -817.79, 30.47), 4.2, 3.2, {
        name="garagee",
        heading=0,
        --debugPoly=true,
        minZ=28.92,
        maxZ=33.12}, {
        options = {
            {
                event = "",
                icon = "",
                label = "Garage E",
                duty = false,
            },
            {
                event = "lcrp-garages:client:checkVehiclesGarage",
                icon = "fas fa-parking",
                label = "My parked vehicles",
                duty = false,
                parameters = "garagee"
            },
            {
                event = "lcrp-garages:client:parkVehicle",
                icon = "fad fa-key",
                label = "Park current vehicle",
                duty = false,
                onlyInVeh = true,
                parameters = "garagee",
    
            },
            },
        job = {"all"}, distance = 5 })

    exports["lcrp-interact"]:AddBoxZone("garagef", vector3(362.23, 298.17, 103.49), 4.0, 3.2, {
        name="garagef",
        heading=340,
        --debugPoly=true,
        minZ=102.49,
        maxZ=105.89}, {
        options = {
            {
                event = "",
                icon = "",
                label = "Garage F",
                duty = false,
            },
            {
                event = "lcrp-garages:client:checkVehiclesGarage",
                icon = "fas fa-parking",
                label = "My parked vehicles",
                duty = false,
                parameters = "garagef"
            },
            {
                event = "lcrp-garages:client:parkVehicle",
                icon = "fad fa-key",
                label = "Park current vehicle",
                duty = false,
                onlyInVeh = true,
                parameters = "garagef",
    
            },
            },
        job = {"all"}, distance = 5 })

    
    exports["lcrp-interact"]:AddBoxZone("garageg", vector3(-796.42, -2023.08, 8.87), 3.0, 4.2, {
        name="garageg",
        heading=330,
        --debugPoly=true,
        minZ=7.87,
        maxZ=11.07}, {
        options = {
            {
                event = "",
                icon = "",
                label = "Garage G",
                duty = false,
            },
            {
                event = "lcrp-garages:client:checkVehiclesGarage",
                icon = "fas fa-parking",
                label = "My parked vehicles",
                duty = false,
                parameters = "garageg"
            },
            {
                event = "lcrp-garages:client:parkVehicle",
                icon = "fad fa-key",
                label = "Park current vehicle",
                duty = false,
                onlyInVeh = true,
                parameters = "garageg",
    
            },
            },
        job = {"all"}, distance = 5 })


    exports["lcrp-interact"]:AddBoxZone("garageh", vector3(-1184.87, -1509.38, 4.35), 4.0, 3.6, {
        name="garageh",
        heading=307,
        minZ=3.4,
        maxZ=6.2 }, {
        options = {
            {
            event = "",
            icon = "",
            label = "Garage H",
            duty = false,
            },
            {
            event = "lcrp-garages:client:checkVehiclesGarage",
            icon = "fas fa-parking",
            label = "My parked vehicles",
            duty = false,
            parameters = "garageh"
            },
            {
            event = "lcrp-garages:client:parkVehicle",
            icon = "fad fa-key",
            label = "Park current vehicle",
            duty = false,
            onlyInVeh = true,
            parameters = "garageh",

            },
        },
        job = {"all"}, distance = 5 })

    exports["lcrp-interact"]:AddBoxZone("garagei", vector3(1137.69, 2663.97, 38.02), 6.4, 5.0, {
        name="garagei",
        heading=0,
        --debugPoly=true,
        minZ=30.02,
        maxZ=40.02}, {
        options = {
            {
                event = "",
                icon = "",
                label = "Garage I",
                duty = false,
            },
            {
                event = "lcrp-garages:client:checkVehiclesGarage",
                icon = "fas fa-parking",
                label = "My parked vehicles",
                duty = false,
                parameters = "garagei"
            },
            {
                event = "lcrp-garages:client:parkVehicle",
                icon = "fad fa-key",
                label = "Park current vehicle",
                duty = false,
                onlyInVeh = true,
                parameters = "garagei",
    
            },
            },
        job = {"all"}, distance = 10 })

    exports["lcrp-interact"]:AddBoxZone("garagej", vector3(940.03, 3617.31, 32.56), 11.8, 7.0, {
        name="garagej",
        heading=0,
        --debugPoly=true,
        minZ=29.36,
        maxZ=35.16}, {
        options = {
            {
                event = "",
                icon = "",
                label = "Garage J",
                duty = false,
            },
            {
                event = "lcrp-garages:client:checkVehiclesGarage",
                icon = "fas fa-parking",
                label = "My parked vehicles",
                duty = false,
                parameters = "garagej"
            },
            {
                event = "lcrp-garages:client:parkVehicle",
                icon = "fad fa-key",
                label = "Park current vehicle",
                duty = false,
                onlyInVeh = true,
                parameters = "garagej",
    
            },
            },
        job = {"all"}, distance = 10 })

    exports["lcrp-interact"]:AddBoxZone("garagek", vector3(1454.54, 3734.63, 33.47), 9.4, 7.8, {
        name="garagek",
        heading=25,
        --debugPoly=true,
        minZ=30.67,
        maxZ=34.67}, {
        options = {
            {
                event = "",
                icon = "",
                label = "Garage K",
                duty = false,
            },
            {
                event = "lcrp-garages:client:checkVehiclesGarage",
                icon = "fas fa-parking",
                label = "My parked vehicles",
                duty = false,
                parameters = "garagek"
            },
            {
                event = "lcrp-garages:client:parkVehicle",
                icon = "fad fa-key",
                label = "Park current vehicle",
                duty = false,
                onlyInVeh = true,
                parameters = "garagek",
    
            },
            },
        job = {"all"}, distance = 10 })

    exports["lcrp-interact"]:AddBoxZone("garagel", vector3(83.98, 6420.38, 31.33), 3.8, 2.0, {
        name="garagel",
        heading=45,
        --debugPoly=true,
        minZ=29.53,
        maxZ=33.53}, {
        options = {
            {
                event = "",
                icon = "",
                label = "Garage L",
                duty = false,
            },
            {
                event = "lcrp-garages:client:checkVehiclesGarage",
                icon = "fas fa-parking",
                label = "My parked vehicles",
                duty = false,
                parameters = "garagel"
            },
            {
                event = "lcrp-garages:client:parkVehicle",
                icon = "fad fa-key",
                label = "Park current vehicle",
                duty = false,
                onlyInVeh = true,
                parameters = "garagel",
    
            },
            },
        job = {"all"}, distance = 10 })

    exports["lcrp-interact"]:AddBoxZone("garagem", vector3(-766.83, 241.23, 75.69), 10.0, 1, {
        name="garagem",
        heading=280,
        --debugPoly=true,
        minZ=74.69,
        maxZ=78.69}, {
        options = {
            {
                event = "",
                icon = "",
                label = "Garage M",
                duty = false,
            },
            {
                event = "lcrp-garages:client:checkVehiclesGarage",
                icon = "fas fa-parking",
                label = "My parked vehicles",
                duty = false,
                parameters = "garagem"
            },
            {
                event = "lcrp-garages:client:parkVehicle",
                icon = "fad fa-key",
                label = "Park current vehicle",
                duty = false,
                onlyInVeh = true,
                parameters = "garagem",
    
            },
            },
        job = {"all"}, distance = 5 })

    exports["lcrp-interact"]:AddBoxZone("garagen", vector3(-33.92, -1254.6, 29.27), 4.2, 2.8, {
        name="garagen",
        heading=0,
        --debugPoly=true,
        minZ=28.03,
        maxZ=32.03}, {
        options = {
            {
                event = "",
                icon = "",
                label = "Garage N",
                duty = false,
            },
            {
                event = "lcrp-garages:client:checkVehiclesGarage",
                icon = "fas fa-parking",
                label = "My parked vehicles",
                duty = false,
                parameters = "garagen"
            },
            {
                event = "lcrp-garages:client:parkVehicle",
                icon = "fad fa-key",
                label = "Park current vehicle",
                duty = false,
                onlyInVeh = true,
                parameters = "garagen",
    
            },
            },
        job = {"all"}, distance = 5 })


    exports["lcrp-interact"]:AddBoxZone("airportGarage", vector3(-992.63, -2942.48, 13.96), 4.4, 9.6, {
        name="airportGarage",
        heading=60,
        --debugPoly=true,
        minZ=11.56,
        maxZ=15.56}, {
        options = {
            {
                event = "",
                icon = "",
                label = "Airport Garage",
                duty = false,
            },
            {
                event = "lcrp-garages:client:checkVehiclesGarage",
                icon = "fas fa-parking",
                label = "My parked vehicles",
                duty = false,
                parameters = "garageairport"
            },
            {
                event = "lcrp-garages:client:parkVehicle",
                icon = "fad fa-key",
                label = "Park current vehicle",
                duty = false,
                onlyInVeh = true,
                parameters = "garageairport",
    
            },
            },
        job = {"all"}, distance = 10 })


    exports["lcrp-interact"]:AddBoxZone("pdImpound", vector3(401.0, -1631.28, 29.29), 6.6, 7.4, {
        name="pdImpound",
        heading=50,
        --debugPoly=true,
        minZ=28.29,
        maxZ=31.49}, {
        options = {
            {
                event = "lcrp-garages:client:checkVehiclesImpounded",
                icon = "fas fa-parking",
                label = "My impounded cars",
                duty = false,
                parameters = "pdImpound"
            },
            },
        job = {"all"}, distance = 10 })

    exports["lcrp-interact"]:AddBoxZone("sandyImpound", vector3(1503.09, 3762.82, 33.98), 6.6, 8.4, {
        name="sandyImpound",
        heading=30,
        --debugPoly=true,
        minZ=32.98,
        maxZ=35.58}, {
        options = {
            {
                event = "lcrp-garages:client:checkVehiclesImpounded",
                icon = "fas fa-parking",
                label = "My impounded cars",
                duty = false,
                parameters = "sandyImpound"
            },
            },
        job = {"all"}, distance = 10 })
end)


renderMenu = false

RegisterNetEvent("lcrp-garages:client:checkVehiclesGarage")
AddEventHandler("lcrp-garages:client:checkVehiclesGarage", function(garage)
    MenuGarage()
    Menu.hidden = not Menu.hidden
    currentGarage = garage
    renderMenuFunc()
end)

RegisterNetEvent("lcrp-garages:client:checkVehiclesImpounded")
AddEventHandler("lcrp-garages:client:checkVehiclesImpounded", function(garage)
    MenuImpound()
    Menu.hidden = not Menu.hidden
    currentGarage = garage
    renderMenuFunc()
end)

RegisterNetEvent("lcrp-garages:client:parkVehicle")
AddEventHandler("lcrp-garages:client:parkVehicle", function(garage)
    local curVeh = GetVehiclePedIsIn(PlayerPedId())
    local plate = GetVehicleNumberPlateText(curVeh)
    local parsedPlate = string.gsub(plate, '%s+', '') 
    scCore.TriggerServerCallback('lcrp-garages:server:checkVehicleOwner', function(owned)
        if owned then
            local bodyDamage = math.ceil(GetVehicleBodyHealth(curVeh))
            local engineDamage = math.ceil(GetVehicleEngineHealth(curVeh))
            local totalFuel = exports['LegacyFuel']:GetFuel(curVeh)
            TriggerServerEvent('lcrp-garages:server:updateVehicleStatus', totalFuel, engineDamage, bodyDamage, parsedPlate, garage)
            TriggerServerEvent('lcrp-garages:server:updateVehicleState', 1, parsedPlate, garage)
            TriggerServerEvent('vehiclemod:server:saveStatus', parsedPlate)
            scCore.Functions.DeleteVehicle(curVeh)
            if plate ~= nil then
                OutsideVehicles[plate] = veh
                TriggerServerEvent('lcrp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
            end
            scCore.Notification("Vehicle stored in Garage " .. string.sub(garage, 7):upper(), "primary", 4500)
        else
            scCore.Notification("You don\'t own this vehicle", "error", 3500)
        end
    end, parsedPlate)
end)

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

local isInGarage = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local inGarageRange = false
        if HouseGarages ~= nil and currentHouseGarage ~= nil then
            if HouseGarages[currentHouseGarage] ~= nil then
                if HouseGarages[currentHouseGarage].takeVehicle.x ~= nil and hasGarageKey then
                    local gDist = vector3(HouseGarages[currentHouseGarage].takeVehicle.x, HouseGarages[currentHouseGarage].takeVehicle.y, HouseGarages[currentHouseGarage].takeVehicle.z)
                    local takeDist = #(pos.xy - gDist.xy)
                    isInGarage = false
                    if takeDist <= 10 then
                        inGarageRange = true
                        if takeDist < 2.0 then
                            isInGarage = true
                        end
                        if takeDist > 1.99 and not Menu.hidden then
                            closeMenuFull()
                            isInGarage = true
                        end
                    end
                end
            end
        end
        if not inGarageRange then
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent("lcrp-garages:client:checkVehiclesGarageHouse")
AddEventHandler("lcrp-garages:client:checkVehiclesGarageHouse", function(park)
    if park == "true" then
        local curVeh = GetVehiclePedIsIn(PlayerPedId())
        local plate = GetVehicleNumberPlateText(curVeh)
        plate = string.gsub(plate, '%s+', '')
        scCore.TriggerServerCallback('lcrp-garages:server:checkFull', function(cars)
            if cars + 1 <= 3 then
                scCore.TriggerServerCallback('lcrp-garages:server:checkVehicleHouseOwner', function(owned)
                    if owned then
                        local bodyDamage = round(GetVehicleBodyHealth(curVeh), 1)
                        local engineDamage = round(GetVehicleEngineHealth(curVeh), 1)
                        local totalFuel = exports['LegacyFuel']:GetFuel(curVeh)

                        TriggerServerEvent('lcrp-garages:server:updateVehicleStatus', totalFuel, engineDamage, bodyDamage, plate, currentHouseGarage)
                        TriggerServerEvent('lcrp-garages:server:updateVehicleState', 1, plate, currentHouseGarage)
                        scCore.Functions.DeleteVehicle(curVeh)
                        if plate ~= nil then
                            OutsideVehicles[plate] = veh
                            TriggerServerEvent('lcrp-garages:server:UpdateOutsideVehicles', OutsideVehicles)
                        end
                        scCore.Notification("Vehicle stored, "..HouseGarages[currentHouseGarage].label, "primary", 4500)
                    else
                        scCore.Notification("You don\'t own this vehicle", "error", 3500)
                    end
                end, plate, currentHouseData)
            else
                scCore.Notification("The garage is full!", "error", 3500)
            end
        end, currentHouseData.id)
    else
        MenuHouseGarage(currentHouseGarage)
        Menu.hidden = not Menu.hidden
        renderMenuFunc()
    end
end)


function IsInGarage()
    return isInGarage
end

--[[ Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        Citizen.Wait(5)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local inGarageRange = false

        for k, v in pairs(Impounds) do
            local takeDist = GetDistanceBetweenCoords(pos, Impounds[k].takeVehicle.x, Impounds[k].takeVehicle.y, Impounds[k].takeVehicle.z)
            if takeDist <= 10 then
                inGarageRange = true
                DrawMarker(2, Impounds[k].takeVehicle.x, Impounds[k].takeVehicle.y, Impounds[k].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, false, true, false, false, false)
                if takeDist <= 1.5 then
                    if not IsPedInAnyVehicle(ped) then
                        scCore.ShowHelpNotification("~r~[E]~w~ - To Open Impound")
                        if IsControlJustPressed(1, 177) and not Menu.hidden then
                            close()
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        end
                        if IsControlJustPressed(0, 38) then
                            MenuImpound()
                            Menu.hidden = not Menu.hidden
                            currentGarage = k
                        end
                    end
                end

                Menu.renderGUI()

                if takeDist >= 4 and not Menu.hidden then
                    closeMenuFull()
                end
            end
        end

        if not inGarageRange then
            Citizen.Wait(5000)
        end
    end
end) ]]

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function round(num, numDecimalPlaces)
    if numDecimalPlaces and numDecimalPlaces>0 then
      local mult = 10^numDecimalPlaces
      return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end