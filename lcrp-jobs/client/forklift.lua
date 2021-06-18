local call = {x = 146.82814025879, y = -3210.5979003906, z = 5.8575}
local orderDist = {x = 152.90745544434, y = -3211.7609863281, z = 5.901}
local pickBus = { x = 133.22, y = -3213.33, z = 5.85}
local packageDeliveryTruck = {x = -482.71, y = -2897.38, z = 6.00}
local vehicleExhausted = 0
local vehicleExhausted2 = 0
local packages = 0
local hasBox = false
local isWorking = false
local myId = nil
local truck
local benson
local hasProducts = false
local packageSpots = {
    [1] = {
        coords = {x = 161.97207641602, y = -3142.4104003906, z = 5.959},
        model = 'prop_boxpile_06a',
    },
    [2] = {
        coords = {x = 161.18479919434, y = -3041.7497558594, z = 5.974014},
        model = 'prop_boxpile_02b',
    },
    [3] = {
        coords = {x = 166.7626953125, y = -3258.3393554688, z = 5.86072},
        model = 'prop_boxpile_09a',
    },
    [4] = {
        coords = {x = 116.09323120117, y = -3164.1032714844, z = 6.0136},
        model = 'prop_boxpile_04a',
    },
    [5] = {
        coords = {x = 117.36480712891, y = -2989.3310546875, z = 6.020},
        model = 'prop_boxpile_06b',
    },
    [6] = {
        coords = {x = 161.97207641602, y = -3142.4104003906, z = 5.959},
        model = 'prop_boxpile_10a',
    },
    [7] = {
        coords = {x = 161.97207641602, y = -3142.4104003906, z = 5.959},
        model = 'prop_boxpile_02b',
    },
    [8] = {
        coords = {x = 161.97207641602, y = -3142.4104003906, z = 5.959},
        model = 'prop_boxpile_04a',
    },
    [9] = {
        coords = {x = 161.97207641602, y = -3142.4104003906, z = 5.959},
        model = 'prop_boxpile_06a',
    },
    [10] = {
        coords = {x = 161.97207641602, y = -3142.4104003906, z = 5.959},
        model = 'prop_boxpile_08a',
    },
}
local truckSpots = {
    [1] = {
        coords = { x = 140.51, y = -3186.595, z = 5.83},
        trunk = {x = 140.63, y = -3192.72, z = 4.85}
    },
    [2] = {
        coords = { x = 146.79, y = -3186.581, z = 5.83},
        trunk = {x = 146.85, y = -3192.78, z = 4.85}
    }
}


Citizen.CreateThread(function()
    
    local blip = AddBlipForCoord(151.38, -3200.33, 5.86)
    SetBlipSprite(blip, 479)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 6)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Walker Logistics")
    EndTextCommandSetBlipName(blip)
    Citizen.Wait(1000)
    while true do
        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        local distCar = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, call.x, call.y, call.z)
        local zlecDist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, orderDist.x, orderDist.y, orderDist.z)
        local sleep = 1000
        if PlayerJob ~= nil then
            if PlayerJob.name == "logistics" then
                if isWorking then
                    sleep = 5
                    for k, v in pairs(truckSpots) do
                        --DrawMarker(1,v.trunk.x,v.trunk.y,v.trunk.z,0,0,0,0,0,0,1.7,1.7,1.7,135,31,35,150,1,0,0,0)
                        local g = GetEntityCoords(package)
                        local h = Vdist(v.trunk.x,v.trunk.y,v.trunk.z,g.x,g.y,g.z)
                        if h <= 2.0 then
                            DeleteEntity(package)
                            TriggerEvent('scCore:Notification','Package loaded! Go check for new orders!')
                            TriggerServerEvent('lcrp-forklift:server:loadTruck', myId)
                            isWorking = false
                        end
                    end
                end
                if DoesEntityExist(package) then
                    sleep = 5
                    local parcelCoord = GetEntityCoords(package)
                    if GetDistanceBetweenCoords(plyCoords, parcelCoord, true) > 10 then
                        DrawMarker(0, parcelCoord.x, parcelCoord.y, parcelCoord.z + 2.1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 135, 31, 35, 150, 1, 0, 0, 0)
                    end
                elseif Vdist(plyCoords.x, plyCoords.y, plyCoords.z, packageDeliveryTruck.x, packageDeliveryTruck.y, packageDeliveryTruck.z) < 20 then
                    sleep = 5
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
                    if not hasProducts and packages >= 5 then
                        if isCorrectVehicle(GetVehicleNumberPlateText(vehicle)) and not IsPedInAnyVehicle(ply,false) then
                            local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            local pos = GetEntityCoords(PlayerPedId())
                            if GetDistanceBetweenCoords(pos, trunkpos, true) < 2.0 then
                                inRange = true
                                DrawText3D(trunkpos.x, trunkpos.y, trunkpos.z + 1.3, "~r~[E]~w~ - Get products from trunk")
                                if IsControlJustReleased(0, Keys["E"]) then
                                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                    Citizen.Wait(500)
                                    TriggerEvent('animations:client:EmoteCommandStart', {"bumbin"})
                                    scCore.TaskBar("work_dropbox", "Picking up products", 2000, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {}, {}, {}, function() -- Done
                                        ClearPedTasks(PlayerPedId())
                                        hasProducts = true
                                        TriggerEvent('animations:client:EmoteCommandStart', {"box"})
                                        --[[ SetVehicleDoorShut(GetVehiclePedIsIn(ply, true), 3, false)
                                        SetVehicleDoorShut(GetVehiclePedIsIn(ply, true), 2, false) ]]
                                    end, function() -- Cancel
                                        ClearPedTasks(PlayerPedId())
                                        scCore.Notification("Canceled. Products not removed.", "error")
                                    end)
                                end
                            end
                        end
                    else
                        if hasProducts then
                            if Vdist(plyCoords.x, plyCoords.y, plyCoords.z, packageDeliveryTruck.x, packageDeliveryTruck.y, packageDeliveryTruck.z) < 5 then
                                DrawText3D(packageDeliveryTruck.x, packageDeliveryTruck.y, packageDeliveryTruck.z,  '~b~[E]~w~ Drop off packages')
                                if IsControlJustReleased(0, Keys["E"]) then
                                    scCore.TaskBar("work_carrybox", "Dropping off the packages", 5000, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {
                                        animDict = "anim@gangops@facility@servers@",
                                        anim = "hotwire",
                                        flags = 16,
                                    }, {}, {}, function() -- Done
                                        hasProducts = false
                                        ClearPedTasks(PlayerPedId())
                                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                                        packages = packages - 5
                                        if packages == 0 then
                                            SetNewWaypoint(pickBus.x, pickBus.y)
                                            scCore.Notification('You\'re done dropping off the packages! Go back to the headquarters.',"success")
                                            TriggerServerEvent('lcrp-forklift:server:finishRoute') 
                                        else
                                            scCore.Notification('Packages dropped! Go get more from the trunk',"success")
                                        end
                                    end, function() -- Cancel
                                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                                        scCore.Notification("Canceled", "error")
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function getForklift()
    if vehicleExhausted == 0 then
        RequestModel(GetHashKey('forklift'))
        while not HasModelLoaded(GetHashKey('forklift')) do
            Citizen.Wait(0)
        end
        ClearAreaOfVehicles(call.x, call.y, call.z, 15.0, false, false, false, false, false)
        truck = CreateVehicle(GetHashKey('forklift'), call.x, call.y, call.z, -2.436, 996.786, 25.1887, true, true)
        SetEntityHeading(truck, 52.00)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), truck, -1)
        SetVehicleColours(truck, 111, 111)
        vehicleExhausted = 1
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(truck))
    else
        vehicleExhausted = 0
        DeleteEntity(truck)
        TriggerEvent('scCore:Notification', 'Your previous vehicle has been deleted, you can retrieve a new one')
    end
end

function getBenson()
    if vehicleExhausted2 == 0 then
        RequestModel(GetHashKey('benson'))
        while not HasModelLoaded(GetHashKey('benson')) do
            Citizen.Wait(0)
        end
        ClearAreaOfVehicles(pickBus.x, pickBus.y, pickBus.z, 15.0, false, false, false, false, false)
        benson = CreateVehicle(GetHashKey('benson'), pickBus.x, pickBus.y, pickBus.z, -2.436, 996.786, 25.1887, true, true)
        SetEntityHeading(benson, 0.0)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), benson, -1)
        SetVehicleColours(benson, 111, 111)
        vehicleExhausted2 = 1
        local plate = GetVehicleNumberPlateText(benson)
        CurrentPlate = plate
        TriggerEvent("vehiclekeys:client:SetOwner", CurrentPlate)
    else
        vehicleExhausted2 = 0
        DeleteEntity(benson)
        TriggerEvent('scCore:Notification', 'Your previous vehicle has been deleted, you can retrieve a new one')
    end
end

function startDelivery()
    scCore.TriggerServerCallback('lcrp-forklift:server:checkStock', function(hasStock)
        if hasStock then
            packages = 50
            TriggerEvent('scCore:Notification','Your truck is full of packages. Deliver and drop them off at the marked location.') 
            goToDropoff()
        else
            TriggerEvent('scCore:Notification','There isn\'t enough stock. You don\'t have any task assigned.', 'error') 
        end
	end)
end

function goToDropoff()
    SetNewWaypoint(packageDeliveryTruck.x, packageDeliveryTruck.y)
end

function isCorrectVehicle(plate)
    local retval = false
    if CurrentPlate == plate then
        retval = true
    end
    return retval
end


function spawnPackages()
    scCore.TriggerServerCallback('lcrp-forklift:server:checkFree', function(data)
        if data[1] then
            myId = data[2]
            package = CreateObject(GetHashKey(packageSpots[data[2]].model), packageSpots[data[2]].coords.x, packageSpots[data[2]].coords.y,
            packageSpots[data[2]].coords.z - 0.95, true, true, true)
            SetEntityAsMissionEntity(package)
            SetEntityDynamic(package, true)
            FreezeEntityPosition(package, false)
            SetNewWaypoint(packageSpots[data[2]].coords.x, packageSpots[data[2]].coords.y)
            TriggerEvent('scCore:Notification','The package to pick up is marked on the GPS. Use a forklift.') 
            isWorking = true
        else
            TriggerEvent('scCore:Notification','There are no orders', 'error') 
        end
	end)
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.37, 0.37)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 33, 33, 33, 133)
end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()

    exports["lcrp-interact"]:AddBoxZone("logisticsDuty", vector3(120.09, -3214.94, 5.97), 1.55, 1.4, {
        name="logisticsDuty",
        heading=0,
        --debugPoly=true,
        minZ=4.77,
        maxZ=6.97
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
        job = {"logistics"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("logisticsBoss", vector3(153.69, -3211.77, 5.89), 1.4, 1, {
        name="logisticsBoss",
        heading=0,
        --debugPoly=true,
        minZ=4.89,
        maxZ=6.29 }, {
        options = {
            {
                event = "police:server:OpenSocietyMenu",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
                parameters = 'logistics'
            },
        },
        job = {"logistics"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("logisticsForklift", vector3(144.67, -3210.33, 5.86), 4.6, 8.4, {
        name="logisticsForklift",
        heading=0,
        --debugPoly=true,
        minZ=4.46,
        maxZ=6.86 }, {
        options = {
            {
                event = "logistics:client:takeForklift",
                icon = "fas fa-forklift",
                label = "Take/Store forklift",
                duty = true,
                parameters = 'logistics'
            },
        },
        job = {"logistics"}, distance = 6.0})

    exports["lcrp-interact"]:AddBoxZone("logisticsNewOrder", vector3(154.35, -3208.95, 5.91), 2.4, 2.0, {
        name="logisticsNewOrder",
        heading=0,
        --debugPoly=true,
        minZ=4.51,
        maxZ=6.91 }, {
        options = {
            {
                event = "logistics:client:takeNewOrder",
                icon = "fas fa-user-secret",
                label = "Take order",
                duty = true,
                parameters = 'logistics'
            },
        },
        job = {"logistics"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("logisticsVehicle", vector3(133.2, -3210.35, 5.86), 4.6, 8.4, {
        name="logisticsVehicle",
        heading=0,
        --debugPoly=true,
        minZ=4.06,
        maxZ=7.66 }, {
        options = {
            {
                event = "logistics:client:takeTruck",
                icon = "fas fa-truck",
                label = "Take/Store truck",
                duty = true,
                parameters = 'logistics'
            },
        },
        job = {"logistics"}, distance = 6.0})
    
 
end)

RegisterNetEvent("logistics:client:takeForklift")
AddEventHandler("logistics:client:takeForklift", function()
    getForklift()
    local vehicle = scCore.Functions.GetClosestVehicle(vector3(146.85, -3192.78, 4.85))
    local model = GetEntityModel(vehicle)
    local displaytext = GetDisplayNameFromVehicleModel(model)
    if displaytext ~= "BENSON" then
        for k, v in pairs(truckSpots) do
            RequestModel(GetHashKey('benson'))
            while not HasModelLoaded(GetHashKey('benson')) do Citizen.Wait(0) end
            local transport = CreateVehicle(GetHashKey('benson'), v.coords.x, v.coords.y, v.coords.z, 1.00, true, true)
            SetEntityAsMissionEntity(transport)
            SetEntityHeading(transport, 1.00)
            SetVehicleDoorsLocked(transport, 2)
            SetVehicleDoorsLockedForAllPlayers(transport, true)
            SetVehicleDoorOpen(transport, 5, false, true)
            FreezeEntityPosition(transport, true)
        end
    end
end)

RegisterNetEvent("logistics:client:takeNewOrder")
AddEventHandler("logistics:client:takeNewOrder", function()
    TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CLIPBOARD", 0, false)
    Citizen.Wait(2000)
    ClearPedTasks(GetPlayerPed(-1))
    spawnPackages()
end)

RegisterNetEvent("logistics:client:takeTruck")
AddEventHandler("logistics:client:takeTruck", function()
    if vehicleExhausted2 == 0 then
        getBenson()
        startDelivery()
    else
        if packages == 0 then
            getBenson()
        else
            scCore.Notification("You\'re already on a job!", "error")
        end
    end
end)

