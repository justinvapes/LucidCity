local isLoggedIn = true
local housePlants = {}
local insideHouse = false
local currentHouse = nil
local closestPlantData = {}

scCore = nil

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("lcrp-drugs:server:FetchDrugLocations")
end)



RegisterNetEvent('lcrp-drugs:client:getHousePlants')
AddEventHandler('lcrp-drugs:client:getHousePlants', function(house)    
    SetTimeout(500, function()
        scCore.TriggerServerCallback('lcrp-drugs:server:getBuildingPlants', function(plants)
            currentHouse = house
            housePlants[currentHouse] = plants
            insideHouse = true
            spawnHousePlants()
        end, house)
    end)
end)

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)


local uniquePropList = {GetHashKey('bkr_prop_weed_01_small_01c'), GetHashKey('bkr_prop_weed_lrg_01a'), GetHashKey('bkr_prop_weed_lrg_01b'), GetHashKey('bkr_prop_weed_01_small_01a'), GetHashKey('bkr_prop_weed_01_small_01b'), GetHashKey('bkr_prop_weed_med_01b'), GetHashKey('bkr_prop_weed_lrg_01b')}
RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddTargetModel(uniquePropList, {
        options = {
            {
                event = "",
                icon = "far fa-cannabis",
                label = "Don't care",
                duty = false,
            },
        },
      job = {"all"}, distance = 1.5}) 
end)


function spawnHousePlants()
    Citizen.CreateThread(function()
        if not plantSpawned then
            for k, v in pairs(housePlants[currentHouse]) do
                local plantData = {
                    ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][k].coords).x, ["y"] = json.decode(housePlants[currentHouse][k].coords).y, ["z"] = json.decode(housePlants[currentHouse][k].coords).z},
                    ["plantProp"] = GetHashKey(QBWeed.Plants[housePlants[currentHouse][k].sort]["stages"][housePlants[currentHouse][k].stage]),
                }
                plantProp = CreateObjectNoOffset(plantData["plantProp"], plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], false, false, false)
                FreezeEntityPosition(plantProp, true)
                SetEntityAsMissionEntity(plantProp, false, false)
                PlaceObjectOnGroundProperly(plantProp)
            end
            plantSpawned = true
        end
    end)
end

function despawnHousePlants()
    Citizen.CreateThread(function()
        if plantSpawned then
            if currentHouse ~= nil then
                for k, v in pairs(housePlants[currentHouse]) do
                    local plantData = {
                        ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][k].coords).x, ["y"] = json.decode(housePlants[currentHouse][k].coords).y, ["z"] = json.decode(housePlants[currentHouse][k].coords).z},
                    }

                    for _, stage in pairs(QBWeed.Plants[housePlants[currentHouse][k].sort]["stages"]) do
                        local closestPlant = GetClosestObjectOfType(plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], 100.0, GetHashKey(stage), false, false, false)
                        if closestPlant ~= 0 then            
                            DeleteObject(closestPlant)
                        end
                    end
                end
                plantSpawned = false
            end
        end
    end)
end

local ClosestTarget = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if insideHouse then
            if plantSpawned then
                local ped = PlayerPedId()
                for k, v in pairs(housePlants[currentHouse]) do
                    local gender = "M"
                    if housePlants[currentHouse][k].gender == "woman" then gender = "F" end
                    local plantData = {
                        ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][k].coords).x, ["y"] = json.decode(housePlants[currentHouse][k].coords).y, ["z"] = json.decode(housePlants[currentHouse][k].coords).z},
                        ["plantStage"] = housePlants[currentHouse][k].stage,
                        ["plantProp"] = GetHashKey(QBWeed.Plants[housePlants[currentHouse][k].sort]["stages"][housePlants[currentHouse][k].stage]),
                        ["plantSort"] = {
                            ["name"] = housePlants[currentHouse][k].sort,
                            ["label"] = QBWeed.Plants[housePlants[currentHouse][k].sort]["label"],
                        },
                        ["plantStats"] = {
                            ["food"] = housePlants[currentHouse][k].food,
                            ["health"] = housePlants[currentHouse][k].health,
                            ["progress"] = housePlants[currentHouse][k].progress,
                            ["stage"] = housePlants[currentHouse][k].stage,
                            ["highestStage"] = QBWeed.Plants[housePlants[currentHouse][k].sort]["highestStage"],
                            ["gender"] = gender,
                            ["plantId"] = housePlants[currentHouse][k].plantid,
                        }
                    }    
                    local plyDistance = GetDistanceBetweenCoords(GetEntityCoords(ped), plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], false)
                    if plyDistance < 0.8 then
                        closestPlantData = plantData
                        ClosestTarget = k
                    end
                end
            end
        end

        if not insideHouse then
            Citizen.Wait(5000)
        end
    end
end)

RegisterNetEvent('lcrp-drugs:client:harvestPlant')
AddEventHandler('lcrp-drugs:client:harvestPlant', function(plantData)
    scCore.TaskBar("remove_weed_plant", "Harvesting plant", 8000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "amb@world_human_gardener_plant@male@base",
        anim = "base",
        flags = 16,
    }, {}, {}, function() -- Done
        ClearPedTasks(PlayerPedId())
        if plantData["plantStats"]["gender"] == "M" then
            amount = math.random(1, 5)
        else
            amount = math.random(3, 8)
        end
        TriggerServerEvent('lcrp-drugs:server:harvestPlant', currentHouse, amount, plantData["plantSort"]["name"], plantData["plantStats"]["plantId"])
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        scCore.Notification("Process canceled", "error")
    end)
end)

RegisterNetEvent('lcrp-drugs:client:removeDeadPlant')
AddEventHandler('lcrp-drugs:client:removeDeadPlant', function(plantData)
    scCore.TaskBar("remove_weed_plant", "Removing the plant", 8000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "amb@world_human_gardener_plant@male@base",
        anim = "base",
        flags = 16,
    }, {}, {}, function() -- Done
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('lcrp-drugs:server:removeDeathPlant', currentHouse, plantData["plantStats"]["plantId"])
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        scCore.Notification("Process canceled", "error")
    end)
end)

RegisterNetEvent('lcrp-drugs:client:leaveHouse')
AddEventHandler('lcrp-drugs:client:leaveHouse', function()
    despawnHousePlants()
    SetTimeout(500, function()
        if currentHouse ~= nil then
            insideHouse = false
            housePlants[currentHouse] = nil
            currentHouse = nil
        end
    end)
end)

RegisterNetEvent('lcrp-drugs:client:refreshHousePlants')
AddEventHandler('lcrp-drugs:client:refreshHousePlants', function(house)
    if currentHouse ~= nil and currentHouse == house then
        despawnHousePlants()
        SetTimeout(500, function()
            scCore.TriggerServerCallback('lcrp-drugs:server:getBuildingPlants', function(plants)
                currentHouse = house
                housePlants[currentHouse] = plants
                spawnHousePlants()
            end, house)
        end)
    end
end)

RegisterNetEvent('lcrp-drugs:client:refreshPlantStats')
AddEventHandler('lcrp-drugs:client:refreshPlantStats', function()
    if insideHouse then
        despawnHousePlants()
        SetTimeout(500, function()
            scCore.TriggerServerCallback('lcrp-drugs:server:getBuildingPlants', function(plants)
                housePlants[currentHouse] = plants
                spawnHousePlants()
            end, currentHouse)
        end)
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(100)
    end
end

RegisterNetEvent('lcrp-drugs:client:placePlant')
AddEventHandler('lcrp-drugs:client:placePlant', function(type, item)
    local ped = PlayerPedId()
    local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.75, 0)
    local plantData = {
        ["plantCoords"] = {["x"] = plyCoords.x, ["y"] = plyCoords.y, ["z"] = plyCoords.z},
        ["plantModel"] = QBWeed.Plants[type]["stages"]["stage-a"],
        ["plantLabel"] = QBWeed.Plants[type]["label"]
    }
    local ClosestPlant = 0
    for k, v in pairs(QBWeed.Props) do
        if ClosestPlant == 0 then
            ClosestPlant = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 0.8, GetHashKey(v), false, false, false)
        end
    end

    if currentHouse ~= nil then
        if ClosestPlant == 0 then
            if #housePlants[currentHouse] < 15 then
                scCore.TaskBar("plant_weed_plant", "Planting", 8000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "amb@world_human_gardener_plant@male@base",
                    anim = "base",
                    flags = 16,
                }, {}, {}, function() -- Done
                    ClearPedTasks(ped)                
                    TriggerServerEvent('lcrp-drugs:server:placePlant', currentHouse, json.encode(plantData["plantCoords"]), type)
                    TriggerServerEvent('lcrp-drugs:server:removeSeed', item.slot, type)
                end, function() -- Cancel
                    ClearPedTasks(ped)
                    scCore.Notification("Process canceled", "error")
                end)
            else
                scCore.Notification('You can\'t have more than 15 plants at a time', 'error', 3500)
            end
        else
            scCore.Notification('Not a good place', 'error', 3500)
        end
    else
        scCore.Notification('It\'s not safe here', 'error', 3500)
    end
end)

RegisterNetEvent('lcrp-drugs:client:foodPlant')
AddEventHandler('lcrp-drugs:client:foodPlant', function(item)
    local plantData = {}
    if currentHouse ~= nil then
        if ClosestTarget ~= 0 then
            local ped = PlayerPedId()
            local gender = "M"
            if housePlants[currentHouse][ClosestTarget].gender == "woman" then 
                gender = "F" 
            end

            plantData = {
                ["plantCoords"] = {["x"] = json.decode(housePlants[currentHouse][ClosestTarget].coords).x, ["y"] = json.decode(housePlants[currentHouse][ClosestTarget].coords).y, ["z"] = json.decode(housePlants[currentHouse][ClosestTarget].coords).z},
                ["plantStage"] = housePlants[currentHouse][ClosestTarget].stage,
                ["plantProp"] = GetHashKey(QBWeed.Plants[housePlants[currentHouse][ClosestTarget].sort]["stages"][housePlants[currentHouse][ClosestTarget].stage]),
                ["plantSort"] = {
                    ["name"] = housePlants[currentHouse][ClosestTarget].sort,
                    ["label"] = QBWeed.Plants[housePlants[currentHouse][ClosestTarget].sort]["label"],
                },
                ["plantStats"] = {
                    ["food"] = housePlants[currentHouse][ClosestTarget].food,
                    ["health"] = housePlants[currentHouse][ClosestTarget].health,
                    ["progress"] = housePlants[currentHouse][ClosestTarget].progress,
                    ["stage"] = housePlants[currentHouse][ClosestTarget].stage,
                    ["highestStage"] = QBWeed.Plants[housePlants[currentHouse][ClosestTarget].sort]["highestStage"],
                    ["gender"] = gender,
                    ["plantId"] = housePlants[currentHouse][ClosestTarget].plantid,
                }
            }
            
            local plyDistance = GetDistanceBetweenCoords(GetEntityCoords(ped), plantData["plantCoords"]["x"], plantData["plantCoords"]["y"], plantData["plantCoords"]["z"], false)

            if plyDistance < 1.0 then
                if plantData["plantStats"]["food"] == 100 then
                    scCore.Notification('The plant does not need nutrition', 'error', 3500)
                else
                    scCore.TaskBar("plant_weed_plant", "Feeding plant", math.random(4000, 8000), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "timetable@gardener@filling_can",
                        anim = "gar_ig_5_filling_can",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        ClearPedTasks(ped)
                        local newFood = math.random(40, 60)
                        TriggerServerEvent('lcrp-drugs:server:foodPlant', currentHouse, newFood, plantData["plantSort"]["name"], plantData["plantStats"]["plantId"])
                    end, function() -- Cancel
                        ClearPedTasks(ped)
                        scCore.Notification("Process canceled", "error")
                    end)
                end
            else
                scCore.Notification("Not a plant", "error")
            end
        else
            scCore.Notification("Not a plant", "error")
        end
    end
end)

function GetPlantData()
    return closestPlantData
end



RegisterNetEvent('lcrp-drugs:AddWeapons')
AddEventHandler('lcrp-drugs:AddWeapons', function()
    table.insert(Config.Dealers[2]["products"], {
        name = "weapon_snspistol",
        price = 5000,
        amount = 1,
        info = {
            serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
        },
        type = "item",
        slot = 5,
        minrep = 200,
    })
    table.insert(Config.Dealers[3]["products"], {
        name = "weapon_snspistol",
        price = 5000,
        amount = 1,
        info = {
            serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
        },
        type = "item",
        slot = 5,
        minrep = 200,
    })
end)

RegisterNetEvent("lcrp-drugs:client:Process")
AddEventHandler("lcrp-drugs:client:Process", function(Processitem, ProcessitemAmount, ProcessedItem, ProcessedItemAmount)
    local playerPed = PlayerPedId()

    if ProcessedItem == "coca_paste" then
        ProcessTime = ProcessitemAmount * 2000
        Dict = Config.CocaPasteDict
        Anim = Config.CocaPasteAnim
        Text = "Mixing diesel fuel to make coca paste"
    elseif ProcessedItem == "crack_baggy" then
        ProcessedItemAmount = ProcessedItemAmount
        ProcessTime = ProcessitemAmount * 5000
        Dict = Config.CrackCocaineDict
        Anim = Config.CrackCocaineAnim
        Text = "Mixing chemicals to make Crack Cocaine"
    elseif ProcessedItem == "meth_liquid" then
        ProcessedItemAmount = ProcessedItemAmount
        ProcessTime = Config.MethLiquidTime
        Dict = Config.MethLiquidDict
        Anim = Config.MethLiquidAnim
        Text = "Mixing chemicals to make meth liquid"
    elseif ProcessedItem == "meth" then
        ProcessedItemAmount = ProcessedItemAmount
        ProcessTime = Config.MethTime
        Dict = Config.MethDict
        Anim = Config.MethAnim
        Text = "Mixing Meth Liquid and Iodine Crystals"
    elseif ProcessedItem == "meth_baggy" then
        ProcessedItemAmount = ProcessedItemAmount
        ProcessTime = Config.MethBagsTime
        Dict = Config.MethBagsDict
        Anim = Config.MethBagsAnim
        Text = "Packing Meth into bags"
    elseif ProcessedItem == "weed_og-kush" then
        ProcessedItemAmount = ProcessedItemAmount
        ProcessTime = Config.ProcessWeedTime
        Dict = Config.ProcessWeedDict
        Anim = Config.ProcessWeedAnim
        Text = "Packing OG Kush Weed"
    elseif Processitem == "lsd" then
        lastAmount = #Config.LSD.Messages
        ProcessedItemAmount = ProcessitemAmount
        ProcessTime = Config.LSD.Messages[lastAmount].taskBarTime
        Dict = Config.LSD.Messages[lastAmount].animDict
        Anim = Config.LSD.Messages[lastAmount].anim
        Text = Config.LSD.Messages[lastAmount].taskBar
    elseif Processitem == "chloroform" then
        lastAmount = #Config.Heroin.Messages
        ProcessedItemAmount = ProcessitemAmount
        ProcessTime = Config.Heroin.Messages[lastAmount].taskBarTime
        Dict = Config.Heroin.Messages[lastAmount].animDict
        Anim = Config.Heroin.Messages[lastAmount].anim
        Text = Config.Heroin.Messages[lastAmount].taskBar
    elseif ProcessedItem == "ecstasy" then
        lastAmount = #Config.Ecstasy.Messages
        ProcessedItemAmount = ProcessitemAmount
        ProcessTime = Config.Ecstasy.Messages[lastAmount].taskBarTime
        Dict = Config.Ecstasy.Messages[lastAmount].animDict
        Anim = Config.Ecstasy.Messages[lastAmount].anim
        Text = Config.Ecstasy.Messages[lastAmount].taskBar
    elseif ProcessedItem == "xtcbaggy" then
        ProcessedItemAmount = ProcessitemAmount
        ProcessTime = Config.Ecstasy.Messages.Packing.taskBarTime
        Dict = Config.Ecstasy.Messages.Packing.animDict
        Anim = Config.Ecstasy.Messages.Packing.anim
        Text = Config.Ecstasy.Messages.Packing.taskBar
    end
    
    RequestAnimDict(Dict)
    while not HasAnimDictLoaded(Dict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(playerPed, Dict, Anim, 8.0, 8.0, -1, 48, 1, false, false, false)

    scCore.TaskBar("drug_processing", Text, ProcessTime, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done

        TriggerServerEvent("lcrp-drugs:server:ProcessItem", Processitem, ProcessitemAmount, ProcessedItem, ProcessedItemAmount)

        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasksImmediately(playerPed)
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasksImmediately(playerPed)
        scCore.Notification("Canceled", "error")
    end)

end)