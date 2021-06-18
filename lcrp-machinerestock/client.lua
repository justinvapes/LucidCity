scCore = nil

local atJob,hasProducts = false, false
local vendingMachine = 1
local route
local vehicle, vendingMachineBlip, CurrentPlate = nil, nil, nil

Citizen.CreateThread(function()
	while scCore == nil do
		TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    local blipCoords = vector3(Config.StartLocation.x, Config.StartLocation.y, Config.StartLocation.z)
    jobBlip = AddBlipForCoord(blipCoords)
    
    SetBlipColour(jobBlip, 0)
    SetBlipSprite(jobBlip, 318)
    SetBlipScale(jobBlip, 0.6)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName('Vending Machine Restock')
    EndTextCommandSetBlipName(jobBlip)

end)

function SpawnVehicle() 
    scCore.Functions.SpawnVehicle(Config.Vehicle.model, function(veh)
        SetVehicleNumberPlateText(veh, "VENMCH"..tostring(math.random(10, 99)))
        SetEntityHeading(veh, Config.StartLocation.a)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)
        vehicle = veh
    end, Config.StartLocation, true)
end

function isCorrectVehicle(vehicle,plate)
    local retval = false
    if GetEntityModel(vehicle) == GetHashKey(Config.Vehicle.model) and CurrentPlate == plate then
        retval = true
    end
    return retval
end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function() 
    exports["lcrp-interact"]:AddBoxZone("MachineRestockStart", vector3(751.89, -1849.86, 29.29), 20.0, 11.4, {
        name="MachineRestockStart",
        heading=355,
        --debugPoly=true,
        minZ=20.49,
        maxZ=34.49
        }, {
		options = {
			{
				event = "machinerestock:client:checkDepositMoney",
				icon = "far fa-clipboard",
				label = "Start Job | Deposit : "..Config.Vehicle.deposit.."$",
				duty = false,
                storeVeh = true
			},
		},
	job = {"all"}, distance = 20.0 })

    exports["lcrp-interact"]:AddBoxZone("1VendingMachine1", vector3(-542.72, -196.78, 47.42), 1, 1, {
        name="1VendingMachine1",
        heading=30,
        --debugPoly=true,
        minZ=44.02,
        maxZ=48.42
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=1,machine=1}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("1VendingMachine2", vector3(451.05, -633.08, 28.52), 1.2, 1, {
        name="1VendingMachine2",
        heading=0,
        --debugPoly=true,
        minZ=26.92,
        maxZ=29.52
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=1,machine=2}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("1VendingMachine3", vector3(-1696.55, -1126.76, 13.15), 1.2, 1.2, {
        name="1VendingMachine3",
        heading=330,
        --debugPoly=true,
        minZ=11.95,
        maxZ=14.15
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=1,machine=3}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("1VendingMachine4", vector3(-46.01, -1752.15, 29.42), 1.8, 1.1, {
        name="1VendingMachine4",
        heading=317,
        --debugPoly=true,
        minZ=28.22,
        maxZ=30.42
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=1,machine=4}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("1VendingMachine5", vector3(-1062.88, -243.99, 39.73), 1.2, 1.2, {
        name="1VendingMachine5",
        heading=295,
        --debugPoly=true,
        minZ=37.73,
        maxZ=40.73
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=1,machine=5}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("1VendingMachine6", vector3(-270.47, -2022.17, 30.15), 1.2, 1.4, {
        name="1VendingMachine6",
        heading=320,
        --debugPoly=true,
        minZ=28.75,
        maxZ=31.15
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=1,machine=6}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("2VendingMachine1", vector3(-1075.19, -2736.65, 0.81), 1.8, 0.8, {
        name="2VendingMachine1",
        heading=320,
        --debugPoly=true,
        minZ=-0.79,
        maxZ=1.81
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=2,machine=1}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("2VendingMachine2", vector3(1135.08, -978.13, 46.42), 1.2, 1.8, {
        name="2VendingMachine2",
        heading=10,
        --debugPoly=true,
        minZ=45.02,
        maxZ=47.6
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=2,machine=2}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("2VendingMachine3", vector3(112.6, -138.96, 60.49), 1, 1, {
        name="2VendingMachine3",
        heading=345,
        --debugPoly=true,
        minZ=58.69,
        maxZ=61.49
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=2,machine=3}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("2VendingMachine4", vector3(309.02, -584.23, 43.28), 1.8, 1.05, {
        name="2VendingMachine4",
        heading=340,
        --debugPoly=true,
        minZ=41.88,
        maxZ=44.28
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=2,machine=4}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("2VendingMachine5", vector3(-276.72, -2042.18, 30.15), 1.4, 1.2, {
        name="2VendingMachine5",
        heading=290,
        --debugPoly=true,
        minZ=28.75,
        maxZ=31.15
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=2,machine=5}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })
  
    exports["lcrp-interact"]:AddBoxZone("2VendingMachine6", vector3(2559.63, 379.08, 108.62), 1.05, 1.45, {
        name="2VendingMachine6",
        heading=0,
        --debugPoly=true,
        minZ=107.22,
        maxZ=109.62
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=2,machine=6}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("3VendingMachine1", vector3(470.38, -996.77, 26.27), 1, 1, {
        name="3VendingMachine1",
        heading=0,
        --debugPoly=true,
        minZ=24.87,
        maxZ=27.07
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=3,machine=1}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("3VendingMachine2", vector3(23.77, -1342.36, 29.5), 1, 1, {
        name="3VendingMachine2",
        heading=0,
        --debugPoly=true,
        minZ=27.9,
        maxZ=30.3
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=3,machine=2}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("3VendingMachine3", vector3(-709.28, -908.82, 19.22), 1.8, 1.1, {
        name="3VendingMachine3",
        heading=0,
        --debugPoly=true,
        minZ=17.42,
        maxZ=20.22
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=3,machine=3}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("3VendingMachine4", vector3(-72.25, -1278.48, 23.15), 1.4, 1.4, {
        name="3VendingMachine4",
        heading=0,
        --debugPoly=true,
        minZ=21.75,
        maxZ=24.15
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=3,machine=4}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("3VendingMachine5", vector3(-1268.99, -1426.45, 4.35), 2.0, 1.2, {
        name="3VendingMachine5",
        heading=305,
        --debugPoly=true,
        minZ=2.95,
        maxZ=5.35
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=3,machine=5}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })
  
    exports["lcrp-interact"]:AddBoxZone("3VendingMachine6", vector3(-1825.62, 795.54, 138.16), 1.2, 1.6, {
        name="3VendingMachine6",
        heading=310,
        --debugPoly=true,
        minZ=136.56,
        maxZ=139.16
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=3,machine=6}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("4VendingMachine1", vector3(-2073.47, -330.68, 13.17), 1.0, 1.0, {
        name="4VendingMachine1",
        heading=355,
        --debugPoly=true,
        minZ=11.37,
        maxZ=13.97
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=4,machine=1}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("4VendingMachine2", vector3(-246.29, -2002.06, 30.14), 1.4, 1.2, {
        name="4VendingMachine2",
        heading=345,
        --debugPoly=true,
        minZ=28.34,
        maxZ=31.14
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=4,machine=2}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("4VendingMachine3", vector3(-208.02, -1343.14, 34.89), 1.6, 1.2, {
        name="4VendingMachine3",
        heading=0,
        --debugPoly=true,
        minZ=32.89,
        maxZ=35.89
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=4,machine=3}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("4VendingMachine4", vector3(110.56, -141.12, 54.86), 1.2, 1.4, {
        name="4VendingMachine4",
        heading=340,
        --debugPoly=true,
        minZ=53.26,
        maxZ=55.86
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=4,machine=4}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("4VendingMachine5", vector3(439.36, -977.92, 30.69), 1, 1, {
        name="4VendingMachine5",
        heading=0,
        --debugPoly=true,
        minZ=29.09,
        maxZ=31.49
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=4,machine=5}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("4VendingMachine6", vector3(-2968.2, 386.63, 15.04), 1.8, 1.8, {
        name="4VendingMachine6",
        heading=355,
        --debugPoly=true,
        minZ=13.04,
        maxZ=16.24
        }, {
		options = {
			{
				event = "machinerestock:client:restockMachine",
				icon = "fas fa-apple-crate",
				label = "Restock Machine",
				duty = false,
                parameters = json.encode({route=4,machine=6}),
                canRestock = false
			},
		},
	job = {"all"}, distance = 2.0 })

end)

RegisterNetEvent("machinerestock:client:checkDepositMoney")
AddEventHandler("machinerestock:client:checkDepositMoney", function()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local vehicle = GetVehiclePedIsIn(PlayerPedId())
        if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
            local plate = GetVehicleNumberPlateText(vehicle)
            if isCorrectVehicle(vehicle, plate) then
                TriggerServerEvent("lcrp-machinerestock:server:CheckDepositMoney", false)
            else
                scCore.Notification('This is not the delivery vehicle!', 'error')
            end
        else
            scCore.Notification('You must be the driver', 'error')
        end
    else
        TriggerServerEvent("lcrp-machinerestock:server:CheckDepositMoney", true)
    end
end)

RegisterNetEvent('lcrp-machinerestock:client:SpawnVehicle')
AddEventHandler('lcrp-machinerestock:client:SpawnVehicle', function()
    if vehicle ~= nil then
        DeleteVehicle(vehicle)
    end
    if vendingMachineBlip ~= nil then
        RemoveBlip(vendingMachineBlip)
    end
    SpawnVehicle()

    route = math.random(1,#Config.Routes)
    vendingMachine = 1

    vendingMachineBlip = AddBlipForCoord(Config.Routes[route][vendingMachine])
    SetBlipColour(vendingMachineBlip, 2)
    SetBlipRoute(vendingMachineBlip, true)
    SetBlipScale(vendingMachineBlip, 0.7)

    atJob = true

    setMachineInteractions(route)
end)

RegisterNetEvent('machinerestock:client:restockMachine')
AddEventHandler('machinerestock:client:restockMachine', function(data)
    data = json.decode(data)
    if atJob then
        if data.route == route and data.machine == vendingMachine then
            if hasProducts then
                restockMachine()
            else
                scCore.Notification('You left the products in the trunk!', 'error')
            end
        else
            scCore.Notification('This machine doesn\'t need restocking!', 'error')
        end
    end
end)

RegisterNetEvent('lcrp-machinerestock:client:DeleteVehicle')
AddEventHandler('lcrp-machinerestock:client:DeleteVehicle', function()
    DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
    atJob = false
    CurrentPlate = nil
    route = nil
    vendingMachine = 1
    vehicle = nil
    RemoveBlip(vendingMachineBlip)
end)

RegisterNetEvent('lcrp-machinerestock:client:pickupFromTrunk')
AddEventHandler('lcrp-machinerestock:client:pickupFromTrunk', function()
    if CanPickupProducts(vehicle) then
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        Citizen.Wait(500)
        TriggerEvent('animations:client:EmoteCommandStart', {"bumbin"})
        scCore.TaskBar("work_dropbox", "Removing products", 2000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
            SetVehicleDoorOpen(vehicle, 3, false, false),
            SetVehicleDoorOpen(vehicle, 2, false, false),
        }, {}, {}, {}, function() -- Done
            ClearPedTasks(PlayerPedId())
            hasProducts = true
            TriggerEvent('animations:client:EmoteCommandStart', {"box"})
            SetVehicleDoorShut(vehicle, 3, false)
            SetVehicleDoorShut(vehicle, 2, false)
        end, function() -- Cancel
            ClearPedTasks(PlayerPedId())
            scCore.Notification("Canceled. Products not removed.", "error")
        end)
    else
        scCore.Notification("You already have the necessary products","error")
    end
end)

function restockMachine()
    
    scCore.TaskBar("work_carrybox", "Refilling Vending Machine", 2000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@gangops@facility@servers@",
        anim = "bumbin",
        flags = 16,
    }, {}, {}, function() -- Done
        hasProducts = false
        ClearPedTasks(PlayerPedId())
        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "bumbin", 1.0)
        TriggerServerEvent('lcrp-machinerestock:server:MachineRefilled')
        if Config.Routes[route][vendingMachine + 1] ~= nil then
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            TriggerEvent("lcrp-interact:client:updateInteraction", 'zone', route..'VendingMachine'..vendingMachine, 'canRestock', false)
            vendingMachine = vendingMachine + 1
            scCore.Notification('Machine Refilled! Proceed to the next one','success')
            SetBlipCoords(vendingMachineBlip, Config.Routes[route][vendingMachine])
            SetBlipRoute(vendingMachineBlip,true)
        else
            local blipCoords = vector3(Config.StartLocation.x, Config.StartLocation.y, Config.StartLocation.z)
            scCore.Notification('Route completed! Return to receive your payment','success')
            SetBlipCoords(vendingMachineBlip, blipCoords)
            SetBlipRoute(vendingMachineBlip,true)
        end
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "bumbin", 1.0)
        scCore.Notification("Canceled", "error")
    end)
end

function setMachineInteractions(route)
    for k in pairs(Config.Routes[route]) do
        TriggerEvent("lcrp-interact:client:updateInteraction", 'zone', route..'VendingMachine'..k, 'canRestock', true)
    end
end

function CanPickupProducts(entity)
    if atJob and GetEntityType(entity) == 2 and not hasProducts and vehicle ~= nil and GetVehicleNumberPlateText(entity) == GetVehicleNumberPlateText(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetOffsetFromEntityInWorldCoords(entity, 0, -2.5, 0), true) < 1.5 then
        return true  
    else
        return false
    end
end