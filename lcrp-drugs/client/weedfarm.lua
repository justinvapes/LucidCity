local newLocation = Config.SpawnLocations[math.random(1, #Config.SpawnLocations)]
-- max weed that can be harvest per zone
local maxWeed = 3
local weedHarvested = 0
local maxWeedZones = 4
local currWeedZone = 1
local isHarvesting = false

function PickWeed()

    RequestAnimDict(Config.PickWeedDict)
    while not HasAnimDictLoaded(Config.PickWeedDict) do
        Citizen.Wait(0)
    end

    TaskPlayAnim(PlayerPedId(), Config.PickWeedDict, Config.PickWeedAnim, 8.0, 8.0, -1, 48, 1, false, false, false)

    scCore.TaskBar("pick_weed", "Picking weed", Config.PickWeedTime, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("lcrp-drugs:server:WeedPickup")
        isHarvesting = false
        WeedHarvested()
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasksImmediately(playerPed)
        scCore.Notification("Canceled", "error")
        TriggerServerEvent("lcrp-drugs:server:WeedPickupStatus", false)
    end)

end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()

    exports["lcrp-interact"]:AddBoxZone("harvestWeed1", vector3(2217.14, 5577.34, 53.81), 5.0, 3.8, {
        name="harvestWeed1",
        heading=355,
        --debugPoly=true,
        minZ=53.01,
        maxZ=54.76 }, {
        options = {
            {
                event = "drugs:client:harvestWeed",
                icon = "fas fa-cannabis",
                label = "Harvest Weed",
                duty = false,
                canHarvestWeed = true,
                parameters = 1
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("harvestWeed2", vector3(2221.88, 5577.21, 53.84), 5.6, 3.4, {
        name="harvestWeed2",
        heading=345,
        --debugPoly=true,
        minZ=53.04,
        maxZ=54.64 }, {
        options = {
            {
                event = "drugs:client:harvestWeed",
                icon = "fas fa-cannabis",
                label = "Harvest Weed",
                duty = false,
                canHarvestWeed = false,
                parameters = 2
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("harvestWeed3", vector3(2226.47, 5577.05, 53.83), 5.2, 3.2, {
        name="harvestWeed3",
        heading=355,
        --debugPoly=true,
        minZ=52.88,
        maxZ=54.88 }, {
        options = {
            {
                event = "drugs:client:harvestWeed",
                icon = "fas fa-cannabis",
                label = "Harvest Weed",
                duty = false,
                canHarvestWeed = false,
                parameters = 3
            },
        },
        job = {"all"}, distance = 3.0})
    
    exports["lcrp-interact"]:AddBoxZone("harvestWeed4", vector3(2231.47, 5576.81, 53.98), 5.8, 5.2, {
        name="harvestWeed4",
        heading=335,
        --debugPoly=true,
        minZ=53.18,
        maxZ=54.98 }, {
        options = {
            {
                event = "drugs:client:harvestWeed",
                icon = "fas fa-cannabis",
                label = "Harvest Weed",
                duty = false,
                canHarvestWeed = false,
                parameters = 4
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("packOGKushWeed", vector3(2197.0, 5595.17, 53.78), 4.4, 1.2, {
        name="packOGKushWeed",
        heading=345,
        --debugPoly=true,
        minZ=52.78,
        maxZ=54.38 }, {
        options = {
            {
                event = "drugs:client:packOGKush",
                icon = "fas fa-box",
                label = "Pack OG-Kush",
                duty = false,
            },
        },
        job = {"all"}, distance = 3.0})

end)

RegisterNetEvent("drugs:client:packOGKush")
AddEventHandler("drugs:client:packOGKush", function()
    scCore.TriggerServerCallback('scCore:HasItem', function(OGKUSH)
        if OGKUSH then
            if not IsPedInAnyVehicle(PlayerPedId()) then
                TriggerServerEvent("lcrp-drugs:server:CheckAmount", "og-kush", 1, "empty_weed_bag")
            else
               scCore.Notification("Exit vehicle first", "error")
            end
        else
            scCore.Notification("You don\'t have any OG kush weed", "error")
        end
    end, "og-kush") 
end)

RegisterNetEvent("drugs:client:harvestWeed")
AddEventHandler("drugs:client:harvestWeed", function(weedZone)
    if weedZone == currWeedZone then
        if not isHarvesting then
            if not IsPedInAnyVehicle(PlayerPedId()) then
                -- Start picking weed
                TriggerServerEvent("lcrp-drugs:server:WeedPickupStatus", true)
                isHarvesting = true
                PickWeed()
            else
                scCore.Notification("I can't harvest inside a vehicle")
            end
        else
            scCore.Notification("Already Harvesting",'error')
        end
    else
        scCore.Notification("Can't harvest here",'error')
    end
    
end)

function WeedHarvested()
    scCore.Notification("Weed harvested")
    if weedHarvested == maxWeed then
        weedHarvested = 0
        TriggerEvent("lcrp-interact:client:updateInteraction", 'zone', "harvestWeed"..currWeedZone, "canHarvestWeed", false)
        if currWeedZone == maxWeedZones then
            currWeedZone = 1
        else
            currWeedZone = currWeedZone + 1
        end
        scCore.Notification("All weed harvested here, go forward")
        TriggerEvent("lcrp-interact:client:updateInteraction", 'zone', "harvestWeed"..currWeedZone, "canHarvestWeed", true)
    else
        weedHarvested = weedHarvested + 1
    end
end