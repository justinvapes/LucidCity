local sleep
local currentlocation = 1
local busStopCount = #Config.BusJobPositions.busStopPositions
local onBusMission = false
local vehicle = nil

local NpcData = {
    CurrentNpc = nil,
    LastNpc = nil,
    Npc = nil,
    NpcBlip = nil,
    DeliveryBlip = nil
}

-- BLIP
Citizen.CreateThread(function()
    BusJobMapBlip = AddBlipForCoord(461.075, -654.4076, 27.7747)
    SetBlipSprite(BusJobMapBlip, Config.BusJobBlip)
    SetBlipDisplay(BusJobMapBlip, 4)
    SetBlipScale(BusJobMapBlip, Config.BusJobScale)
    SetBlipAsShortRange(BusJobMapBlip, true)
    SetBlipColour(BusJobMapBlip, Config.BusJobColour)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.BusJobBlipName)
    EndTextCommandSetBlipName(BusJobMapBlip)
end)


RegisterNetEvent("lcrp-jobs:client:TakeOutVehicle")
AddEventHandler("lcrp-jobs:client:TakeOutVehicle", function()
    local ped = GetPlayerPed(-1)

    if IsPedInAnyVehicle(ped) then
        if isBusVehicle(GetVehiclePedIsIn(ped)) then
            TriggerServerEvent("lcrp-jobs:server:CheckDepositMoney", false, "busdriver", nil, CurrentPlate)
            SetEntityAsNoLongerNeeded(NpcData.LastNpc)
            SetEntityAsNoLongerNeeded(NpcData.Npc)
            NpcData.LastNpc = nil
            NpcData.Npc = nil
            if NpcData.NpcBlip ~= nil then
                RemoveBlip(NpcData.NpcBlip)
            end
            DeleteVehicle(GetVehiclePedIsIn(ped))
        else
            scCore.Notification("This is not a bus vehicle!", "error")
        end
    else
        SetEntityAsNoLongerNeeded(NpcData.LastNpc)
        SetEntityAsNoLongerNeeded(NpcData.Npc)
        NpcData.LastNpc = nil
        NpcData.Npc = nil
        TriggerServerEvent("lcrp-jobs:server:CheckDepositMoney", true, "busdriver", nil, CurrentPlate)
    end
end)

RegisterNetEvent('lcrp-jobs:client:SpawnBus')
AddEventHandler('lcrp-jobs:client:SpawnBus', function()
    if PlayerJob.name == "busdriver" then
        local coords = Config.BusJobPositions.MarkerLocations["spawnvehicle"].coords

        scCore.Functions.SpawnVehicle(Config.BusVehicle, function(veh)
            SetVehicleNumberPlateText(veh, "LCJOB"..tostring(math.random(1000, 9999)))
            SetEntityHeading(veh, coords.h)
            exports['LegacyFuel']:SetFuel(veh, 100.0)
            SetEntityAsMissionEntity(veh, true, true)
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
            SetVehicleEngineOn(veh, true, true)
            startBusMission()
            vehicle = veh
            CurrentPlate = GetVehicleNumberPlateText(veh)
            TriggerServerEvent("lcrp-jobs:server:AddPlates", CurrentPlate, 0)
        end, coords, true)
    end
end)

RegisterNetEvent("busdriver:client:vehDeleted")
AddEventHandler("busdriver:client:vehDeleted", function()  
    onBusMission = false
    vehicle = nil
end)

function isBusVehicle(vehicle)
    local retval = false
    if GetEntityModel(vehicle) == GetHashKey(Config.BusVehicle) then
        retval = true
    end
    return retval
end

function startBusMission()
    onBusMission = true
    local ped = GetPlayerPed(-1)
    local Gender = math.random(1, #Config.NpcSkins)
    local PedSkin = math.random(1, #Config.NpcSkins[Gender])
    local model = GetHashKey(Config.NpcSkins[Gender][PedSkin])

    -- Set values to default
    LeaveVehiclePed()
    currentlocation = 1
    NpcData.LastNpc = nil
    NpcData.Npc = nil

    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end

    -- Generate random route and then create ped in first route location
    randomRouteLocation = math.random(1, #Config.BusJobPositions.busStopPositions[currentlocation].coords)
    NpcData.CurrentNpc = Config.BusJobPositions.busStopPositions[currentlocation].coords[randomRouteLocation]
    NpcData.Npc = CreatePed(3, model, Config.BusJobPositions.busStopPositions[currentlocation].ped[randomRouteLocation].x, Config.BusJobPositions.busStopPositions[currentlocation].ped[randomRouteLocation].y, Config.BusJobPositions.busStopPositions[currentlocation].ped[randomRouteLocation].z - 0.98, Config.BusJobPositions.busStopPositions[currentlocation].ped[randomRouteLocation].h, false, true)
    PlaceObjectOnGroundProperly(NpcData.Npc)
    FreezeEntityPosition(NpcData.Npc, true)
    ClearPedTasksImmediately(NpcData.Npc)
    
    if NpcData.NpcBlip ~= nil then
        RemoveBlip(NpcData.NpcBlip)
    end
    
    CreateBlip()
end

function CreateBlip()
    scCore.Notification('Bus stop is indicated on your navigation!')
    NpcData.NpcBlip = AddBlipForCoord(Config.BusJobPositions.busStopPositions[currentlocation].coords[randomRouteLocation].x, Config.BusJobPositions.busStopPositions[currentlocation].coords[randomRouteLocation].y, Config.BusJobPositions.busStopPositions[currentlocation].coords[randomRouteLocation].z)
    SetBlipColour(NpcData.NpcBlip, 3)
    SetBlipRoute(NpcData.NpcBlip, true)
    SetBlipRouteColour(NpcData.NpcBlip, 3)
end

function NextBusStop()
    local newBusStopLocation = currentlocation + 1
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, 0)
    local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(veh)

    for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(veh, i) then
            freeSeat = i
            break
        end
    end

    if currentlocation == 1 then

        ClearPedTasksImmediately(NpcData.Npc)
        FreezeEntityPosition(NpcData.Npc, false)
        TaskEnterVehicle(NpcData.Npc, veh, -1, freeSeat, 1.0, 0)
        NpcData.LastNpc = NpcData.Npc

        if NpcData.NpcBlip ~= nil then
            RemoveBlip(NpcData.NpcBlip)
        end

        currentlocation = newBusStopLocation

        local Gender = math.random(1, #Config.NpcSkins)
        local PedSkin = math.random(1, #Config.NpcSkins[Gender])
        local model = GetHashKey(Config.NpcSkins[Gender][PedSkin])

        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end

        FreezeEntityPosition(veh, true)
        Citizen.Wait(3000)
        FreezeEntityPosition(veh, false)

        NpcData.Npc = CreatePed(3, model, Config.BusJobPositions.busStopPositions[currentlocation].ped[randomRouteLocation].x, Config.BusJobPositions.busStopPositions[currentlocation].ped[randomRouteLocation].y, Config.BusJobPositions.busStopPositions[currentlocation].ped[randomRouteLocation].z - 0.98, Config.BusJobPositions.busStopPositions[currentlocation].ped[randomRouteLocation].h, false, true)
        PlaceObjectOnGroundProperly(NpcData.Npc)
        FreezeEntityPosition(NpcData.Npc, true)

        CreateBlip()
        return
    end

    if NpcData.DeliveryBlip ~= nil then
        RemoveBlip(NpcData.DeliveryBlip)
    end

    if NpcData.LastNpc then
        LeaveVehiclePed()
    end

    currentlocation = newBusStopLocation

    NpcData.CurrentNpc = Config.BusJobPositions.busStopPositions[currentlocation].coords[randomRouteLocation]

    local Gender = math.random(1, #Config.NpcSkins)
    local PedSkin = math.random(1, #Config.NpcSkins[Gender])
    local model = GetHashKey(Config.NpcSkins[Gender][PedSkin])

    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end

    ClearPedTasksImmediately(NpcData.Npc)
    FreezeEntityPosition(NpcData.Npc, false)
    TaskEnterVehicle(NpcData.Npc, veh, -1, freeSeat, 1.0, 0)

    FreezeEntityPosition(veh, true)
    Citizen.Wait(3000)
    FreezeEntityPosition(veh, false)

    -- create new ped Only if bus stop is not gonna be last one of the route
    if currentlocation < busStopCount then
        NpcData.LastNpc = NpcData.Npc
        NpcData.Npc = CreatePed(3, model, Config.BusJobPositions.busStopPositions[currentlocation].ped[randomRouteLocation].x, Config.BusJobPositions.busStopPositions[currentlocation].ped[randomRouteLocation].y, Config.BusJobPositions.busStopPositions[currentlocation].ped[randomRouteLocation].z - 0.98, Config.BusJobPositions.busStopPositions[currentlocation].ped[randomRouteLocation].h, false, true)
        PlaceObjectOnGroundProperly(NpcData.Npc)
        FreezeEntityPosition(NpcData.Npc, true)
    end

    if NpcData.NpcBlip ~= nil then
        RemoveBlip(NpcData.NpcBlip)
    end

    CreateBlip()
end

function LeaveVehiclePed()
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, 0)

    if NpcData.LastNpc or NpcData.Npc then 
        if currentlocation == busStopCount then
            TaskLeaveVehicle(NpcData.Npc, veh, 0)
            SetEntityAsMissionEntity(NpcData.Npc, false, true)
            local targetCoords = Config.BusJobPositions.busStopPositions[currentlocation].coords[randomRouteLocation]
            TaskGoStraightToCoord(NpcData.Npc, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
            SetEntityAsNoLongerNeeded(NpcData.Npc)
        else
            TaskLeaveVehicle(NpcData.LastNpc, veh, 0)
            SetEntityAsMissionEntity(NpcData.LastNpc, false, true)
            local targetCoords = Config.BusJobPositions.busStopPositions[currentlocation].coords[randomRouteLocation]
            TaskGoStraightToCoord(NpcData.LastNpc, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
            SetEntityAsNoLongerNeeded(NpcData.LastNpc)
        end
    end
end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddBoxZone("BusDriverDuty", vector3(437.92, -635.31, 28.63), 3.8, 0.6, {
        name="BusDriverDuty",
        heading=355,
        --debugPoly = true,
        minZ=28.83,
        maxZ=29.23 }, {
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
    job = {"busdriver"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("BusDriverBoss", vector3(445.22, -597.92, 28.63), 1.2, 3.0, {
        name="BusDriverBoss",
        heading=355,        
        minZ=28.48,
        maxZ=29.08,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-car-alt",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"busdriver"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("BusDriverStoreVeh", vector3(452.52, -585.37, 28.5), 10.4, 10, {
        name="BusDriverStoreVeh",
        heading=352,
        --debugPoly=true,
        minZ=26.5,
        maxZ=31.7 }, {
        options = {
            {
                event = "lcrp-jobs:client:TakeOutVehicle",
                icon = "fas fa-car-alt",
                label = "Take Out Vehicle",
                duty = true,
                storeVeh = true,
            },
        },
    job = {"busdriver"}, distance = 10 })
end)

RegisterNetEvent("lcrp-radialmenu:client:goToNextStop")
AddEventHandler("lcrp-radialmenu:client:goToNextStop", function()
    if currentlocation == busStopCount then
        scCore.Notification("Route finished")
        TriggerServerEvent("lcrp-jobs:server:BusDriverPayCheck")
        startBusMission()
    else
        TriggerServerEvent("lcrp-jobs:server:BusDriverFinished", randomRouteLocation)
        NextBusStop()
    end
end)

function IsOnBusJobRoute()
    local busStopPos = Config.BusJobPositions.busStopPositions[currentlocation].coords[randomRouteLocation]

    if onBusMission and GetVehiclePedIsIn(PlayerPedId(),false) == vehicle and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), busStopPos.x, busStopPos.y, busStopPos.z, true) < 8 and PlayerJob.name == "busdriver" and onDuty then
        return true
    end
    return false
end

function IsEndOfRoute()
    if currentlocation == busStopCount then
        return {retval = true, text = Config.BusJobText.finishRoute}
    end
    return {retval = false, text = Config.BusJobText.pickup}
end