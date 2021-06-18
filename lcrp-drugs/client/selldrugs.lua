availableDrugs = {}
lastPed = {}
hasTarget = false
randomPrice = 0
bagAmount = 0
currentOfferDrug = {}
drugItem = nil
drugLabel = nil
local isDealing = false

RegisterNetEvent('lcrp-drugs:client:SellDrugs')
AddEventHandler('lcrp-drugs:client:SellDrugs', function(ped)
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    local PlayerPeds = {}
    if next(PlayerPeds) == nil then
        for _, player in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(player)
            table.insert(PlayerPeds, ped)
        end
    end
    
    local closestPed, closestDistance = scCore.Functions.GetClosestPed(coords, PlayerPeds)

    scCore.TriggerServerCallback('lcrp-drugs:server:getAvailableDrugs', function(result)
        if result ~= nil then
            availableDrugs = result
            if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                if isDealing then
                    scCore.Notification("You have unfinished business with another person", "error")
                else
                    local playerPed = GetPlayerPed(-1)
                    hasTarget = true
                    for i = 1, #lastPed, 1 do
                        if lastPed[i] == ped then
                            scCore.Notification("You already offered drugs to this customer!", "error")
                            hasTarget = false
                            return
                        end
                    end
                    TriggerEvent('lcrp-interact:client:waitOffer')
                    if #availableDrugs > 0 then
                        local drugType = math.random(1, #availableDrugs)
                        drugItem = availableDrugs[drugType].item
                        drugLabel = availableDrugs[drugType].label
                        bagAmount = math.random(1, availableDrugs[drugType].amount)
                        local scamChance = math.random(1, 5)
                        local getRobbed = math.random(1, 20)
                        if bagAmount > 15 then
                            bagAmount = math.random(9, 15)
                        end
                        currentOfferDrug = availableDrugs[drugType]
                        local ddata = Config.DrugsPrice[currentOfferDrug.item]
                        randomPrice = math.random(ddata.min, ddata.max) * bagAmount
                        if scamChance == 5 then
                            randomPrice = math.random(3, 50) * bagAmount
                        end
                        SetEntityAsNoLongerNeeded(ped)
                        ClearPedTasks(ped)
                        scCore.Notification("Offering drugs to the closest person")
                        local coords = GetEntityCoords(PlayerPedId(), true)
                        local pedCoords = GetEntityCoords(ped)
                        local pedDist = GetDistanceBetweenCoords(coords, pedCoords)
            
                        if getRobbed == 20 then
                            TaskGoStraightToCoord(ped, coords, 15.0, -1, 0.0, 0.0)
                        else
                            TaskGoStraightToCoord(ped, coords, 1.2, -1, 0.0, 0.0)
                        end
            
                        while pedDist > 1.5 do
                            coords = GetEntityCoords(PlayerPedId(), true)
                            pedCoords = GetEntityCoords(ped)    
                            if getRobbed == 20 then
                                TaskGoStraightToCoord(ped, coords, 15.0, -1, 0.0, 0.0)
                            else
                                TaskGoStraightToCoord(ped, coords, 1.2, -1, 0.0, 0.0)
                            end
                            TaskGoStraightToCoord(ped, coords, 1.2, -1, 0.0, 0.0)
                            pedDist = GetDistanceBetweenCoords(coords, pedCoords)
                            Citizen.Wait(100)
                        end
                        TaskLookAtEntity(ped, PlayerPedId(), 5500.0, 2048, 3)
                        TaskTurnPedToFaceEntity(ped, PlayerPedId(), 5500)
                        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", 0, false)
            
                        if hasTarget then
                            isDealing = true
                            TriggerEvent('lcrp-interact:client:waitOffer')
                            while pedDist < 1.5 do
                                coords = GetEntityCoords(PlayerPedId(), true)
                                pedCoords = GetEntityCoords(ped)
                                pedDist = GetDistanceBetweenCoords(coords, pedCoords)
            
                                if getRobbed == 18 or getRobbed == 9 then
                                    TriggerServerEvent('lcrp-drugs:server:npcRobDrugs', drugItem, bagAmount)
                                    isDealing = false
                                    scCore.Notification('You have been mugged: '..bagAmount..'x  '..availableDrugs[drugType].label, 'error')
                                    stealingPed = ped
                                    
                                    stealData = {
                                        item = drugItem,
                                        amount = bagAmount,
                                    }
            
                                    hasTarget = false
                            
                                    local moveto = GetEntityCoords(PlayerPedId())
                                    local movetoCoords = {x = moveto.x + math.random(100, 500), y = moveto.y + math.random(100, 500), z = moveto.z, }
            
                                    ClearPedTasksImmediately(ped)
                                    TaskGoStraightToCoord(ped, movetoCoords.x, movetoCoords.y, movetoCoords.z, 15.0, -1, 0.0, 0.0)
                                    TriggerEvent('lcrp-interact:client:sendMugged', stealingPed)
                                    table.insert(lastPed, ped)
                                    break
                                else
                                    TriggerEvent('lcrp-interact:client:sendDrugOptions', true, ped)
                                    break
                                end
                                Citizen.Wait(3)
                            end
                            Citizen.Wait(math.random(4000, 7000))
                        end
                    end
                end
            else
                scCore.Notification('Exit vehicle first!', 'error')
            end
        else
            scCore.Notification('You have no drugs on you', 'error')
        end
    end)
end)

RegisterNetEvent('lcrp-drugs:client:refreshAvailableDrugs')
AddEventHandler('lcrp-drugs:client:refreshAvailableDrugs', function(items)
    availableDrugs = items
end)


function loadAnimDict(dict)
    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
end

function callPolice(coords)
    local msg = Config.policeMessage[math.random(1, #Config.policeMessage)]
    local pCoords = GetEntityCoords(PlayerPedId())
    local street1, street2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
	local streetLabel = GetStreetNameFromHashKey(street1)

    if street2 ~= 0 then 
		streetLabel = streetLabel .. " | " .. GetStreetNameFromHashKey(street2)
	end

    TriggerServerEvent('police:server:PoliceAlertMessage', msg, streetLabel, coords)

    hasTarget = false
end


RegisterNetEvent('lcrp-drugs:client:offerAnswer')
AddEventHandler('lcrp-drugs:client:offerAnswer', function(data)
    isDealing = false
    TriggerEvent('lcrp-interact:client:sendDrugOptions', false)
    local answer = data[1]
    local ped = data[2]
    if answer then
        local randomReport = math.random(1, 5)
        scCore.Notification('Offer accepted!', 'primary')

        TriggerServerEvent('lcrp-drugs:server:sellCornerDrugs', drugItem, bagAmount, randomPrice)
        hasTarget = false

        if randomReport > 3 then
            callPolice(GetEntityCoords(PlayerPedId()))
        end

        loadAnimDict("gestures@f@standing@casual")
        TaskPlayAnim(PlayerPedId(), "gestures@f@standing@casual", "gesture_point", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
        Citizen.Wait(650)
        ClearPedTasks(PlayerPedId())
        SetPedKeepTask(ped, false)
        SetEntityAsNoLongerNeeded(ped)
        ClearPedTasksImmediately(ped)
        table.insert(lastPed, ped)
    else
        scCore.Notification('Offer declined!', 'error')
        hasTarget = false
        SetPedKeepTask(ped, false)
        SetEntityAsNoLongerNeeded(ped)
        ClearPedTasksImmediately(ped)
        table.insert(lastPed, ped)
    end
end)

RegisterNetEvent('lcrp-drugs:client:takeBack')
AddEventHandler('lcrp-drugs:client:takeBack', function()
    if stealData ~= nil then
        RequestAnimDict("pickup_object")
        while not HasAnimDictLoaded("pickup_object") do
            Citizen.Wait(7)
        end
        TaskPlayAnim(PlayerPedId(), "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
        Citizen.Wait(2000)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent("lcrp-drugs:server:TakeDrugsBack", stealData.item, stealData.amount)
        stealingPed = nil
        stealData = {}
        TriggerEvent('lcrp-interact:client:sendMugged')
    end
end)

function drugData()
    data = {
        price = randomPrice,
        amount = bagAmount,
        drug = drugLabel
    }
    return data
end