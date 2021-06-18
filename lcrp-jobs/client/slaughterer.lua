local doingTask = false
local inOutfit = false


-- BLIP
Citizen.CreateThread(function()
    ChickenFactory = AddBlipForCoord(-72.507, 6240.047, 31.076)
    SetBlipSprite(ChickenFactory, Config.SlaughterBlip)
    SetBlipDisplay(ChickenFactory, 4)
    SetBlipScale(ChickenFactory, Config.SlaughterScale)
    SetBlipAsShortRange(ChickenFactory, true)
    SetBlipColour(ChickenFactory, Config.SlaughterColour)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.SlaughterBlipName)
    EndTextCommandSetBlipName(ChickenFactory)
end)

RegisterNetEvent("dpclothing:ResetClothing")
AddEventHandler("dpclothing:ResetClothing", function()
    inOutfit = false -- prevent people from resetting outfit
end)

function PickChicken()
    doingTask = true
    scCore.TaskBar("pick_chicken", "Picking Chicken", 1000 * Config.PickChickenTime, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = Config.SlaughtererPositions.MarkerLocations["chickens"].animDict,
        anim = Config.SlaughtererPositions.MarkerLocations["chickens"].anim,
        flags = 16,
    }, {}, {}, function() -- Done
        ClearPedTasksImmediately(PlayerPedId())
        TriggerServerEvent("lcrp-jobs:server:ReceiveItem", "chicken")
        doingTask = false
    end, function() -- Cancel
        ClearPedTasksImmediately(PlayerPedId())
        scCore.Notification("Canceled", "error")
        doingTask = false
    end)
end

function SlaughterChicken()
    scCore.TriggerServerCallback('scCore:HasItem', function(hasChicken)
        if hasChicken then
            doingTask = true
            scCore.TaskBar("slaughter_chicken", "Slaughtering Chicken", 1000 * Config.SlaughterTime, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = Config.SlaughtererPositions.MarkerLocations["slaughter"].animDict,
                anim = Config.SlaughtererPositions.MarkerLocations["slaughter"].anim,
                flags = 16,
            }, {}, {}, function() -- Done
                ClearPedTasksImmediately(PlayerPedId())
                TriggerServerEvent('lcrp-jobs:server:ProcessItem', "chicken", 1)
                doingTask = false
            end, function() -- Cancel
                ClearPedTasksImmediately(PlayerPedId())
                scCore.Notification("Canceled", "error")
                doingTask = false
            end)
        else
            scCore.Notification("You don\'t have chicken!", "error")
        end
    end, "chicken")    
end

function PackChicken()
    scCore.TriggerServerCallback('scCore:HasItem', function(hasSlaughteredChicken)
        if hasSlaughteredChicken then
            doingTask = true
            scCore.TaskBar("slaughter_chicken", "Packing Chicken", 1000 * Config.PackChickenTime, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = Config.SlaughtererPositions.MarkerLocations["pack"].animDict,
                anim = Config.SlaughtererPositions.MarkerLocations["pack"].anim,
                flags = 16,
            }, {}, {}, function() -- Done
                ClearPedTasksImmediately(PlayerPedId())
                TriggerServerEvent('lcrp-jobs:server:ProcessItem', "slaughtered_chicken", 1)
                doingTask = false
            end, function() -- Cancel
                ClearPedTasksImmediately(PlayerPedId())
                scCore.Notification("Canceled", "error")
                doingTask = false
            end)
        else
            scCore.Notification("You don\'t have slaughtered chicken!", "error")
        end
    end, "slaughtered_chicken") 
end

function PlaceChickenForDelivery()
    scCore.TriggerServerCallback('scCore:HasItem', function(hasSlaughteredChicken)
        if hasSlaughteredChicken then
            local chickenCount = scCore.KeyboardInput("Enter how much chicken you want to place for delivery:", "", 10)
            TriggerServerEvent("lcrp-jobs:server:CheckAmount", "packaged_chicken", chickenCount)
        else
            scCore.Notification("You don\'t have packaged chicken!", "error")
        end
    end, "packaged_chicken") 
end

function SelectSlaughterOutfit(outfit)
    
    if outfit == "civilian" then
        inOutfit = false
        TriggerServerEvent('lcrp-clothes:get_character_current')
        TriggerServerEvent("lcrp-clothes:retrieve_tats")
    end

    if outfit == "slaughterfemale" then
        inOutfit = true
        ClothingDataName = {
            outfitData = {
                ["hat"]         = { item = -1, texture = 0},  
                ["torso2"]      = { item = 118, texture = 0},  
                ["pants"]       = { item = 37, texture = 5},
                ["arms"]        = { item = 102, texture = 0}, 
                ["t-shirt"]     = { item = 15, texture = 0},  
                ["shoes"]       = { item = 27, texture = 0},  
                ["decals"]      = { item = -1, texture = 0}, 
                ["mask"]        = { item = -1, texture = 0},  
                ["accessory"]   = { item = -1, texture = 0},  
                ["vest"]        = { item = 0, texture = 0}, 
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "slaughtermale" then
        inOutfit = true
        ClothingDataName = {
            outfitData = {
                ["hat"]         = { item = -1, texture = 0},  
                ["torso2"]      = { item = 273, texture = 0},  
                ["pants"]       = { item = 20, texture = 0},
                ["arms"]        = { item = 85, texture = 0}, 
                ["t-shirt"]     = { item = 15, texture = 0},  
                ["shoes"]       = { item = 24, texture = 0},  
                ["decals"]      = { item = -1, texture = 0}, 
                ["mask"]        = { item = -1, texture = 0},  
                ["accessory"]   = { item = -1, texture = 0},  
                ["vest"]        = { item = 0, texture = 0}, 
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end
    closeMenuFull()
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

RegisterNetEvent("lcrp-jobs:client:PickChicken")
AddEventHandler("lcrp-jobs:client:PickChicken", function()
    if not doingTask and inOutfit then
        local playerPosition = GetEntityCoords(GetPlayerPed(-1))
        local plyHeading = GetEntityHeading(PlayerPedId())
        local plyID = PlayerPedId()
        ClearPedTasksImmediately(PlayerPedId())
        if not (GetDistanceBetweenCoords(playerPosition.x, playerPosition.y, playerPosition.z, -62.32627, 6241.807, 31.0900, true) < 0.1) then
            TaskGoStraightToCoord(plyID, -62.32627, 6241.807, 31.0900, 1.0, -1, plyHeading, 0.0)
            Citizen.Wait(700)
            SetEntityHeading(PlayerPedId(), 300.8529)
            SetEntityCoords(PlayerPedId(), -62.32627, 6241.807, 31.0900 - 1.0)
        end
        PickChicken()
    else
        scCore.Notification("Put work clothes first!", "error")
    end
end)

RegisterNetEvent("lcrp-jobs:client:Slaughter")
AddEventHandler("lcrp-jobs:client:Slaughter", function()
    if not doingTask and inOutfit then
        local playerPosition = GetEntityCoords(GetPlayerPed(-1))
        local plyHeading = GetEntityHeading(PlayerPedId())
        local plyID = PlayerPedId()

        ClearPedTasksImmediately(PlayerPedId())
        if not (GetDistanceBetweenCoords(playerPosition.x, playerPosition.y, playerPosition.z, -78.12799, 6229.381, 31.09182, true) < 0.1) then
            TaskGoStraightToCoord(plyID, -78.12799, 6229.381, 31.09182, 1.0, -1, plyHeading, 0.0)
            Citizen.Wait(700)
            SetEntityHeading(PlayerPedId(), 119.0328)
            SetEntityCoords(PlayerPedId(), -78.12799, 6229.381, 31.09182 - 1.0)
        end
        SlaughterChicken()
    else
        scCore.Notification("Put work clothes first!", "error")
    end
end)

RegisterNetEvent("lcrp-jobs:client:SlaughterDelivery")
AddEventHandler("lcrp-jobs:client:SlaughterDelivery", function()
    if not doingTask and inOutfit then
        local playerPosition = GetEntityCoords(GetPlayerPed(-1))
        local plyHeading = GetEntityHeading(PlayerPedId())
        local plyID = PlayerPedId()

        ClearPedTasksImmediately(PlayerPedId())
        if not (GetDistanceBetweenCoords(playerPosition.x, playerPosition.y, playerPosition.z, -75.56506, 6238.527, 31.0845, true) < 0.1) then
            TaskGoStraightToCoord(plyID, -75.56506, 6238.527, 31.0845, 1.0, -1, plyHeading, 0.0)
            Citizen.Wait(700)
            SetEntityHeading(PlayerPedId(), 87.019)
            SetEntityCoords(PlayerPedId(), -75.56506, 6238.527, 31.0845 - 1.0)
        end
        PlaceChickenForDelivery()
    else
        scCore.Notification("Put work clothes first!", "error")
    end
end)

RegisterNetEvent("lcrp-jobs:client:PackChicken")
AddEventHandler("lcrp-jobs:client:PackChicken", function()
    if not doingTask and inOutfit then
        local playerPosition = GetEntityCoords(GetPlayerPed(-1))
        local plyHeading = GetEntityHeading(PlayerPedId())
        local plyID = PlayerPedId()

        ClearPedTasksImmediately(PlayerPedId())
        if not (GetDistanceBetweenCoords(playerPosition.x, playerPosition.y, playerPosition.z, -99.8044, 6210.938, 31.02505, true) < 0.1) then
            TaskGoStraightToCoord(plyID, -99.8044, 6210.938, 31.02505, 1.0, -1, plyHeading, 0.0)
            Citizen.Wait(700)
            SetEntityHeading(PlayerPedId(), 46.27)
            SetEntityCoords(PlayerPedId(), -99.8044, 6210.938, 31.02505 - 1.0)
        end
        PackChicken()
    else
        scCore.Notification("Put work clothes first!", "error")
    end
end)

RegisterNetEvent("lcrp-jobs:client:SlaughterOutfit")
AddEventHandler("lcrp-jobs:client:SlaughterOutfit", function(outfit)
    local playerPosition = GetEntityCoords(GetPlayerPed(-1))
    if (GetDistanceBetweenCoords(playerPosition, -74.43, 6251.55, 31.09, true) < 3.5) then
        local plyHeading = GetEntityHeading(PlayerPedId())
        local plyID = PlayerPedId()

        if scCore.Functions.GetPlayerData().charinfo.gender == 1 then
            if outfit == 1 then
                SelectSlaughterOutfit("civilian")
            elseif outfit == 2 then
                SelectSlaughterOutfit("slaughterfemale")
            end
        else
            if outfit == 1 then
                SelectSlaughterOutfit("civilian")
            elseif outfit == 2 then
                SelectSlaughterOutfit("slaughtermale")
            end
        end
    end
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddBoxZone("slaughterPickup", vector3(-62.12, 6241.89, 31.09), 2.0, 2.2, {
        name="slaughterPickup",
        heading=33,
        --debugPoly=true,
        minZ=30.09,
        maxZ=32.49 }, {
        options = {
            {
                event = "lcrp-jobs:client:PickChicken",
                icon = "far fa-clipboard",
                label = Config.SlaughtererPositions.MarkerLocations["chickens"].text,
                duty = false,
            },
        },
    job = {"slaughterer"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("slaughterPlaceDelivery", vector3(-75.95, 6238.77, 31.08), 3.8, 3.0, {
        name="slaughterPlaceDelivery",
        heading=305,
        --debugPoly=true,
        minZ=30.08,
        maxZ=32.88 }, {
        options = {
            {
                event = "lcrp-jobs:client:SlaughterDelivery",
                icon = "far fa-clipboard",
                label = Config.SlaughtererPositions.MarkerLocations["placefordelivery"].text,
                duty = false,
            },
        },
    job = {"slaughterer"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("slaughterChicken", vector3(-77.82, 6229.25, 31.09), 3.6, 3.4, {
        name="slaughterChicken",
        heading=35,
        --debugPoly=true,
        minZ=30.09,
        maxZ=33.69 }, {
        options = {
            {
                event = "lcrp-jobs:client:Slaughter",
                icon = "far fa-clipboard",
                label = Config.SlaughtererPositions.MarkerLocations["slaughter"].text,
                duty = false,
            },
        },
    job = {"slaughterer"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("packChicken", vector3(-100.68, 6211.65, 31.03), 2.0, 3.0, {
        name="packChicken",
        heading=48,
        --debugPoly=true,
        minZ=30.03,
        maxZ=32.43 }, {
        options = {
            {
                event = "lcrp-jobs:client:PackChicken",
                icon = "far fa-clipboard",
                label = Config.SlaughtererPositions.MarkerLocations["pack"].text,
                duty = false,
            },
        },
    job = {"slaughterer"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("slaughterClothes", vector3(-75.05, 6251.06, 31.09), 2.4, 5.4, {
        name="slaughterClothes",
        heading=301,
        --debugPoly=true,
        minZ=30.09,
        maxZ=32.69 }, {
        options = {
            {
                event = "lcrp-jobs:client:SlaughterOutfit",
                icon = "far fa-clipboard",
                label = "Civilian Clothes",
                duty = false,
                parameters = 1,
            },
            {
                event = "lcrp-jobs:client:SlaughterOutfit",
                icon = "far fa-clipboard",
                label = "Slaughterer Outfit",
                duty = false,
                parameters = 2,
            },
        },
    job = {"slaughterer"}, distance = 2.0 })
end)