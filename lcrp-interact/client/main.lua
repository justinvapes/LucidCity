scCore = nil
PlayerJob = {}
local PlayerData
local Models = {}
local Zones = {}
local usedCars = false
local isOwner = false
local sellingDrugs = false
local drugOffers = false
local mugged = false
local mugger = nil
local offerEntity = nil
local isWaiting = false
local sellHouseOpts = false
local isSelling = false
local inHouse = false
local plantData = {}
local weedProps = {GetHashKey('bkr_prop_weed_01_small_01c'), GetHashKey('bkr_prop_weed_lrg_01a'), GetHashKey('bkr_prop_weed_lrg_01b'), GetHashKey('bkr_prop_weed_01_small_01a'), GetHashKey('bkr_prop_weed_01_small_01b'), GetHashKey('bkr_prop_weed_med_01b')}


Citizen.CreateThread(function()
    RegisterCommand('+control_playerTarget', playerTargetEnable, false)
    RegisterCommand('-control_playerTarget', playerTargetDisable, false)
    RegisterCommand('update', function()
        TriggerEvent('scCore:Client:OnPlayerLoaded')
    end)
end)

Citizen.CreateThread(function()
    while scCore == nil do
        TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
        Citizen.Wait(200)
    end
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData =  scCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent("lcrp-interact:client:Duty")
AddEventHandler("lcrp-interact:client:Duty", function(duty)
    onDuty = duty
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = false
end)

RegisterNetEvent("lcrp-interact:client:updateInteraction")
AddEventHandler("lcrp-interact:client:updateInteraction", function(type, name, option, val)
    if type == 'zone' then
        for k,v in pairs(Zones[name].targetoptions.options) do
            v[option] = val
        end
    else
        for k,v in pairs(Models[name].options) do
            v[option] = val
        end
    end
end)


RegisterNetEvent("lcrp-interact:client:updateInteractionOptions")
AddEventHandler("lcrp-interact:client:updateInteractionOptions", function(type, name, options)
    if type == 'zone' then
        Zones[name].targetoptions.options = options
    else
        Models[name].targetoptions.options = options
    end
end)


RegisterNetEvent("lcrp-interact:client:usedCars")
AddEventHandler("lcrp-interact:client:usedCars", function(toggle, owner) 
    usedCars = toggle
    isOwner = owner
end)


RegisterNetEvent("lcrp-interact:client:waitOffer")
AddEventHandler("lcrp-interact:client:waitOffer", function() 
    isWaiting = not isWaiting
end)

RegisterNetEvent('lcrp-interact:client:sellingDrugs')
AddEventHandler('lcrp-interact:client:sellingDrugs', function()
    sellingDrugs = not sellingDrugs
    if sellingDrugs then
        TriggerEvent('scCore:Notification', "Actively looking for customers...")
    else
        TriggerEvent('scCore:Notification', "Stopped looking for customers.")
    end
end)

RegisterNetEvent('lcrp-interact:client:sendDrugOptions')
AddEventHandler('lcrp-interact:client:sendDrugOptions', function(reOpen, ped)
    drugOffers = reOpen
    offerEntity = ped
    if reOpen then
        SendNUIMessage({response = "leftTarget"})
        success = false
        playerTargetEnable()
    end
end)

RegisterNetEvent('lcrp-interact:client:sendMugged')
AddEventHandler('lcrp-interact:client:sendMugged', function(ped)
    if ped ~= nil then
        mugger = ped
        mugged = true
    else
        mugger = nil
        mugged = false
    end
    SendNUIMessage({response = "leftTarget"})
    playerTargetEnable()
end)

AddEventHandler('lcrp-houses-new:hasEnteredMarker', function(house)
	currentHouse = house
end)

AddEventHandler('lcrp-houses-new:hasExitedMarker', function()
    if not inHouse then
	    currentHouse = nil
    end
    sellHouseOpts = false
end)

RegisterNetEvent('lcrp-houses-interact:client:VerifySell')
AddEventHandler('lcrp-houses-interact:client:VerifySell',function(enable)
	sellHouseOpts = not sellHouseOpts
    SendNUIMessage({response = "leftTarget"})
    success = false
    playerTargetEnable()
end)

AddEventHandler('lcrp-houses-interact:client:SelectPrice',function()
	isSelling = true
    Citizen.Wait(5000)
    isSelling = false
    sellHouseOpts = false
end)

AddEventHandler('lcrp-houses-interact:client:AttemptBuyBack',function()
	isSelling = true
    Citizen.Wait(5000)
    isSelling = false
    sellHouseOpts = false
end)

RegisterNetEvent('lcrp-houses-new:spawnHome')
AddEventHandler('lcrp-houses-new:spawnHome',function(house)
	inHouse = true
    currentHouse = house
end)

AddEventHandler('lcrp-houses-interact:client:lockHouseDoor',function()
    if currentHouse.locked == 'false' then
		currentHouse.locked = 'true'
	else
		currentHouse.locked = 'false'
	end
	SendNUIMessage({response = "leftTarget"})
    success = false
    playerTargetEnable()
end)

AddEventHandler('lcrp-houses-interact:client:exitHouse',function(house)
	inHouse = false
end)

function playerTargetEnable()
    if success then return end

    SetPlayerLockon(PlayerId(), false)

    targetActive = true

    SendNUIMessage({response = "openTarget"})

    while targetActive do
        local weaponBuyData = exports["lcrp-weapons"]:IsWeaponBeingShowcasedToBuy()
        local plyCoords = GetEntityCoords(GetPlayerPed(-1))
        local inVehicle = IsPedInAnyVehicle(GetPlayerPed(-1), false)
        stopPunch()
        local distance = 20.0
        if inVehicle then distance = 60.0 end
        local hit, coords, entity = RayCastGamePlayCamera(distance)
        if hit == 1 then
            if (currentHouse ~= nil or inHouse) and #(plyCoords - coords) <= 2 and not isSelling and ((inHouse and exports["lcrp-houses"]:CanLeave()) or (not inHouse)) or (exports["lcrp-garages"]:IsInGarage() and #(plyCoords - coords) <= 2) then
                success = true
                local options = {}

                if sellHouseOpts then
                    table.insert(options, {
                        event = "lcrp-houses-interact:client:SelectPrice",
                        icon = "fas fa-house-user",
                        label = "Sell on the market",
                        duty = false,
                        parameters = currentHouse
                    })
                    table.insert(options, {
                        event = "lcrp-houses-interact:client:AttemptBuyBack",
                        icon = "fas fa-house-user",
                        label = "Bank buy-back",
                        duty = false,
                        parameters = currentHouse
                    })
                    table.insert(options, {
                        event = "lcrp-houses-interact:client:VerifySell",
                        icon = "fal fa-arrow-to-left",
                        label = "Cancel",
                        duty = false,
                        parameters = false
                    })
                elseif exports["lcrp-garages"]:IsInGarage() then
                    table.insert(options, {
                        event = "lcrp-garages:client:checkVehiclesGarageHouse",
                        icon = "fas fa-parking",
                        label = "My parked vehicles",
                        duty = false,
                        parameters = "false",
                    })
                    table.insert(options, {
                        event = "lcrp-garages:client:checkVehiclesGarageHouse",
                        icon = "fad fa-key",
                        label = "Park current vehicle",
                        duty = false,
                        onlyInVeh = true,
                        parameters = "true",
            
                    })
                elseif inHouse and exports["lcrp-houses"]:CanLeave() then
                    local door = currentHouse.door
                    local lockText = "Unlock the door"
                    local lockIcon = "fas fa-lock-open-alt"
                    local vec = vector3(door.x, door.y, door.z)
                    local keyOptions = {
                        Furnish = true,
                        Unfurnish = false,
                        LetIn = true,
                        SetLock = true,
                        GiveKeys = false,
                        Inventory = true
                    }
                    if exports["lcrp-houses"]:IsUnlocked(currentHouse) then
                        lockText = "Lock the door"
                        lockIcon = "fas fa-lock-alt"
                    end
                    if PlayerData.citizenid == currentHouse.owner or exports["lcrp-houses"]:HasKeys(currentHouse) then
                        table.insert(options, {
                            event = "lcrp-houses-interact:client:letInHouse",
                            icon = "fas fa-user-unlock",
                            label = "Let in",
                            duty = false,
                            parameters = currentHouse
                        })
                        table.insert(options, {
                            event = "lcrp-houses-interact:client:lockHouseDoor",
                            icon = lockIcon,
                            label = lockText,
                            duty = false,
                            parameters = currentHouse
                        })
                        table.insert(options, {
                            event = "lcrp-houses-interact:client:FurnishHome",
                            icon = "fas fa-couch",
                            label = "Furnish",
                            duty = false,
                            parameters = currentHouse
                        })
                        if PlayerData.citizenid == currentHouse.owner then
                            table.insert(options, {
                                event = "lcrp-houses-interact:client:UnFurnishHome",
                                icon = "far fa-couch",
                                label = "Unfurnish",
                                duty = false,
                                parameters = currentHouse
                            })
                        end
                    end
                    table.insert(options, {
                        event = "lcrp-houses-interact:client:exitHouse",
                        icon = "far fa-portal-exit",
                        label = "Exit",
                        duty = false,
                        parameters = currentHouse
                    })
                else
                    if not inHouse then
                        if currentHouse.owner == 'nil' then
                            local isMLO = currentHouse.shell == 'mlo'
                            if currentHouse.isSpec < 2 then
                                if PlayerData.citizenid == currentHouse.prevowner then
                                    label = "Remove house sale listing ($"..currentHouse.price..")"
                                else
                                    label = "Buy house for $"..currentHouse.price
                                end
                                table.insert(options, {
                                    event = "lcrp-houses-interact:client:buyHouse",
                                    icon = "fas fa-house-user",
                                    label = label,
                                    duty = false,
                                    parameters = currentHouse
                                })
                            end
                            if not isMLO then
                                table.insert(options, {
                                    event = "lcrp-houses-interact:client:viewHouse",
                                    icon = "fas fa-house-return",
                                    label = "View house",
                                    duty = false,
                                    parameters = currentHouse
                                })
                            end
                        elseif PlayerData.citizenid == currentHouse.owner then
                            if not isMLO then
                                table.insert(options, {
                                    event = "lcrp-houses-interact:client:enterHouse",
                                    icon = "fas fa-house-return",
                                    label = "Enter house",
                                    duty = false,
                                    parameters = currentHouse
                                })
                            end
                            table.insert(options, {
                                event = "lcrp-houses-interact:client:VerifySell",
                                icon = "fas fa-hands-usd",
                                label = "Sell house",
                                duty = false,
                                parameters = true
                            })
                            table.insert(options, {
                                event = "lcrp-houses-interact:client:giveHouseKeyMenu",
                                icon = "fas fa-key-skeleton",
                                label = "Give house keys",
                                duty = false,
                                parameters = currentHouse
                            })
                            table.insert(options, {
                                event = "lcrp-houses-interact:client:takeHouseKeyMenu",
                                icon = "fal fa-key-skeleton",
                                label = "Take house keys",
                                duty = false,
                                parameters = currentHouse
                            })
                        elseif (exports["lcrp-houses"]:HasKeys(currentHouse) or exports["lcrp-houses"]:IsUnlocked(currentHouse)) and not isMLO then
                            table.insert(options, {
                                event = "lcrp-houses-interact:client:useHouseKey",
                                icon = "fas fa-house-return",
                                label = "Enter house",
                                duty = false,
                                parameters = currentHouse
                            })
                            table.insert(options, {
                                event = "lcrp-houses-interact:client:knockHouseDoor",
                                icon = "fas fa-door-closed",
                                label = "Knock on the door",
                                duty = false,
                                parameters = currentHouse
                            })
                        elseif exports["lcrp-houses"]:CanRaid() and not isMLO then
                            table.insert(options, {
                                event = "lcrp-houses-interact:client:useHouseKey",
                                icon = "fas fa-house-return",
                                label = "Enter house",
                                duty = false,
                                parameters = currentHouse
                            })
                            table.insert(options, {
                                event = "lcrp-houses-interact:client:knockHouseDoor",
                                icon = "fas fa-door-closed",
                                label = "Knock on the door",
                                duty = false,
                                parameters = currentHouse
                            })
                        else
                            if not isMLO then
                                table.insert(options, {
                                    event = "lcrp-houses-interact:client:knockHouseDoor",
                                    icon = "fas fa-door-closed",
                                    label = "Knock on the door",
                                    duty = false,
                                    parameters = currentHouse
                                })
                            end
                        end
                    end
                end

                SendNUIMessage({response = "validTarget", inVehicle = inVehicle, plyDuty = onDuty, data = options})
                while success and targetActive do
                    local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                    local distance = 10.0
                    local hit, coords, entity = RayCastGamePlayCamera(distance)

                    if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) or IsControlJustReleased(0, 25) or IsDisabledControlJustReleased(0, 25) then                                        
                        SetNuiFocus(true, true)
                        SetCursorLocation(0.5, 0.5)
                    end
                    if (#(plyCoords - coords) > 2 and hit == 1) or (not exports["lcrp-houses"]:CanLeave() and inHouse) or (currentHouse == nil and not exports["lcrp-garages"]:IsInGarage()) then
                        success = false
                    end

                    Citizen.Wait(1)
                end
                SendNUIMessage({response = "leftTarget"})
            elseif exports["lcrp-robberies"]:IsInOpenBankRobbery() then
                success = true
                
                local data = exports["lcrp-robberies"]:CanOpenLockerAtBankRobbery()
                local options = { }

                if data.retval then
                    table.insert(options,{
                        event = "lcrp-robberies:client:openLocker",
                        icon = "fas fa-lock",
                        label = "Break safe",
                        duty = false,
                        parameters = {closestBank = data.closestBank, locker = data.locker}
                    })
                else
                    success = false
                end


                SendNUIMessage({response = "validTarget", plyDuty = onDuty, data = options})
                while success and targetActive do
                    local plyCoords = GetEntityCoords(GetPlayerPed(-1))




                    if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) or IsControlJustReleased(0, 25) or IsDisabledControlJustReleased(0, 25) then                                        
                        SetNuiFocus(true, true)
                        SetCursorLocation(0.5, 0.5)
                    end

                    if #(plyCoords - vector3(data.lockerPos.x, data.lockerPos.y, data.lockerPos.z)) > 0.5 then
                        success = false
                    end

                    Citizen.Wait(1)
                end
                SendNUIMessage({response = "leftTarget"})
            elseif exports["lcrp-robberies"]:IsNearJewelleryStore() then

                success = true
                local data = exports["lcrp-robberies"]:IsNearJewelleryVitrine()
                local options = { }

                if data.retval then
                    table.insert(options,{
                        event = "lcrp-robberies:client:breakVitrine",
                        icon = "fas fa-fragile",
                        label = "Break vitrine",
                        duty = false,
                        parameters = {vitrine = data.vitrine}
                    })
                    
                    
                elseif data.reason ~= nil then
                    table.insert(options,{
                        event = "",
                        icon = "",
                        label = "Not enough police",
                        duty = false,
                    })
                else
                    success = false
                end
                


                SendNUIMessage({response = "validTarget", plyDuty = onDuty, data = options})
                while success and targetActive do
                    local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                    local hit, coords, entity = RayCastGamePlayCamera(distance)


                    if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) or IsControlJustReleased(0, 25) or IsDisabledControlJustReleased(0, 25) then                                        
                        SetNuiFocus(true, true)
                        SetCursorLocation(0.5, 0.5)
                    end
                    
                    if #(plyCoords - vector3(data.vitrinePos.x, data.vitrinePos.y, data.vitrinePos.z)) > 1 then
                        success = false
                    end
                    
                    Citizen.Wait(1)
                end
                SendNUIMessage({response = "leftTarget"})
            elseif weaponBuyData.retval and not (string.match(PlayerJob.name,"ammunation") and onDuty) then

                success = true
            
                local options = { }

                table.insert(options,{
                    event = "lcrp-weapons:client:buyWeapon",
                    icon = "fas fa-times",
                    label = "Buy "..weaponBuyData.weapon.." | $"..weaponBuyData.weaponPrice,
                    duty = false,
                    parameters = weaponBuyData
                })
                


                SendNUIMessage({response = "validTarget", plyDuty = onDuty, data = options})
                while success and targetActive do
                    local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                    local hit, coords, entity = RayCastGamePlayCamera(distance)


                    if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) or IsControlJustReleased(0, 25) or IsDisabledControlJustReleased(0, 25) then                                        
                        SetNuiFocus(true, true)
                        SetCursorLocation(0.5, 0.5)
                    end
                    
                    if #(plyCoords - vector3(weaponBuyData.weaponPos.x, weaponBuyData.weaponPos.y, weaponBuyData.weaponPos.z)) > 1 then
                        success = false
                    end
                    
                    Citizen.Wait(1)
                end
                SendNUIMessage({response = "leftTarget"})
            end
            if GetEntityType(entity) ~= 0 then
                for _, model in pairs(Models) do
                    if _ == GetEntityModel(entity) then
                        for k , v in ipairs(Models[_]["job"]) do 
                            if v == "all" or v == PlayerJob.name then
                                if _ == GetEntityModel(entity) then
                                    local shouldReturn = false
                                    if #(plyCoords - coords) <= Models[_]["distance"] then
                                        if Models[_]["options"][1] ~= nil and Models[_]["options"][1].isFueling then
                                            Models[_]["options"][1].label = 'Stop fueling'
                                        elseif Models[_]["options"][1] ~= nil and Models[_]["options"][1].isFueling == false then
                                            Models[_]["options"][1].label = 'Refuel vehicle'
                                        elseif inHouse then
                                            for k, v in pairs(weedProps) do
                                                if _ == v then
                                                    Models[_]["options"] = {}
                                                    plantData = exports['lcrp-drugs']:GetPlantData()
                                                    if plantData["plantCoords"] ~= nil then 
                                                        local entityC = GetEntityCoords(entity)
                                                        if GetDistanceBetweenCoords(entityC.x, entityC.y, entityC.z, plantData["plantCoords"].x, plantData["plantCoords"].y, plantData["plantCoords"].z) == 0 then
                                                            if plantData["plantStage"] == plantData["plantStats"]["highestStage"] and plantData["plantStats"]["health"] > 0 then
                                                                table.insert(Models[_]["options"], {
                                                                    event = "lcrp-drugs:client:harvestPlant",
                                                                    icon = "fal fa-cut",
                                                                    label = "Harvest the plant",
                                                                    duty = false,
                                                                    parameters = plantData
                                                                })
                                                            elseif plantData["plantStats"]["health"] == 0 then
                                                                table.insert(Models[_]["options"], {
                                                                    event = "lcrp-drugs:client:removeDeadPlant",
                                                                    icon = "fal fa-cut",
                                                                    label = "Remove the dead plant",
                                                                    duty = false,
                                                                    parameters = plantData
                                                                })
                                                            end
                                                            table.insert(Models[_]["options"], {
                                                                event = "",
                                                                icon = "far fa-cannabis",
                                                                label = plantData["plantSort"]["label"] .. " " .. plantData["plantStats"]["gender"] .. " | Nutrition: " ..  plantData["plantStats"]["food"] .. " | Health: "..plantData["plantStats"]["health"],
                                                                duty = false,
                                                            }) 
                                                        else
                                                            shouldReturn = true
                                                        end
                                                    else
                                                        shouldReturn = true
                                                    end
                                                end
                                            end
                                        end
                                        if not shouldReturn then
                                            success = true

         
                                            SendNUIMessage({response = "validTarget", inVehicle = inVehicle, plyDuty = onDuty, data = Models[_]["options"]})
                                        end
                                        while success and targetActive do
                                            local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                                            local inVehicle = IsPedInAnyVehicle(GetPlayerPed(-1), false)
                                            local distance = 20.0
                                            if inVehicle then distance = 60.0 end
                                            local hit, coords, entity = RayCastGamePlayCamera(distance)
                                            plantData = exports['lcrp-drugs']:GetPlantData()


                                            if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) or IsControlJustReleased(0, 25) or IsDisabledControlJustReleased(0, 25) then
                                                SetNuiFocus(true, true)
                                                SetCursorLocation(0.5, 0.5)
                                            end
                                              
                                            if GetEntityType(entity) == 0 or GetEntityModel(entity) ~= _ or #(plyCoords - coords) > Models[_]["distance"] then
                                                success = false
                                            end

                                            Citizen.Wait(1)
                                        end
                                        SendNUIMessage({response = "leftTarget"})
                                    end
                                end
                            end
                        end
                    end
                end
                if usedCars then
                    if GetEntityType(entity) == 2 then
                        success = true
                        local options = {
                            {
                              event = "lcrp-usedcars:client:takeBack",
                              icon = "fad fa-key",
                              label = "Take vehicle back",
                              duty = false,
                              usedCar = true,
                              owner = isOwner,
                            },
                            {
                                event = "lcrp-usedcars:client:openCarInfo",
                                icon = "fas fa-file-signature",
                                label = "Check sale contract",
                                duty = false,
                                usedCar = true
                            },
                        }

                        SendNUIMessage({response = "validTarget", data = options})
                        while success and targetActive do
                            local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                            local inVehicle = IsPedInAnyVehicle(GetPlayerPed(-1), false)
                            local distance = 10.0
                            local hit, coords, entity = RayCastGamePlayCamera(distance)



                            if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) or IsControlJustReleased(0, 25) or IsDisabledControlJustReleased(0, 25) then
                                SetNuiFocus(true, true)
                                SetCursorLocation(0.5, 0.5)
                            end

                            if GetEntityType(entity) == 0 or #(plyCoords - coords) > 2 then
                                success = false
                                usedCars = false
                            end

                            Citizen.Wait(1)
                        end
                        SendNUIMessage({response = "leftTarget"})
                    end
                elseif exports["lcrp-jobs"]:CanLoadProducts(entity) or exports["lcrp-deliveries"]:CanPickupProducts(entity) or exports["lcrp-machinerestock"]:CanPickupProducts(entity) then
                    
                    success = true
                    local options = {}
                    if exports["lcrp-jobs"]:CanLoadProducts(entity) then
                        table.insert(options,{
                            event = "lcrp-jobs:client:loadToTrunk",
                            icon = "fas fa-box",
                            label = "Store Products",
                            duty = true,
                            })
                    else
                        if string.match(PlayerJob.name,"supermarket") or string.match(PlayerJob.name,"ltdgasoline") or string.match(PlayerJob.name,"cockatoos") or string.match(PlayerJob.name,"bahamas") or string.match(PlayerJob.name,"galaxy") or string.match(PlayerJob.name,"vanilla") and onDuty then
                            table.insert(options,{
                                event = "deliveries:client:pickupFromTrunk",
                                icon = "fas fa-box",
                                label = "Pick up Products",
                                duty = true,
                            })
                        else
                            table.insert(options,{
                                event = "lcrp-machinerestock:client:pickupFromTrunk",
                                icon = "fas fa-box",
                                label = "Pick up Products",
                                duty = false,
                            }) 
                        end
                    end
        
                    SendNUIMessage({response = "validTarget", plyDuty = onDuty, data = options})
                    while success and targetActive do
                        local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                        local distance = 10.0
                        local hit, coords, entity = RayCastGamePlayCamera(distance)



                        if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) or IsControlJustReleased(0, 25) or IsDisabledControlJustReleased(0, 25) then                                        
                            SetNuiFocus(true, true)
                            SetCursorLocation(0.5, 0.5)
                        end

                        if GetEntityType(entity) == 0 or #(plyCoords - GetOffsetFromEntityInWorldCoords(entity, 0, -2.5, 0)) > 1.5 then
                            success = false
                        end

                        Citizen.Wait(1)
                    end
                    SendNUIMessage({response = "leftTarget"})
                    return
                elseif exports["lcrp-jobs"]:CanSlaughter(entity) then
                    success = true
                    local options = {}
                    
                    table.insert(options,{
                        event = "lcrp-jobs:client:SlaughterAnimal",
                        icon = "fas fa-knife-kitchen",
                        label = "Slaughter Animal",
                        duty = true,
                        parameters = entity
                    })

  
                    SendNUIMessage({response = "validTarget", plyDuty = onDuty, data = options})
                    while success and targetActive do
                        local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                        local distance = 10.0
                        local hit, coords, entity = RayCastGamePlayCamera(distance)


                        if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) or IsControlJustReleased(0, 25) or IsDisabledControlJustReleased(0, 25) then                                        
                            SetNuiFocus(true, true)
                            SetCursorLocation(0.5, 0.5)
                        end

                        if GetEntityType(entity) == 0 or #(plyCoords - coords) > 2 then
                            success = false
                        end

                        Citizen.Wait(1)
                    end
                    SendNUIMessage({response = "leftTarget"})
                    
                elseif sellingDrugs then
         
                    if GetEntityType(entity) == 1 and GetPedType(entity) ~= 28 and not IsPedAPlayer(entity) then
         
                        if  #(plyCoords - GetEntityCoords(entity)) <= 5.0 then

                            success = true
                            local options = {}
                            if mugged and entity == mugger and IsEntityDead(mugger) then
                                options = {
                                    {
                                    event = "lcrp-drugs:client:takeBack",
                                    icon = "fas fa-cannabis",
                                    label = "Take drugs back",
                                    duty = false,
                                    },
                                }
                            elseif drugOffers and not IsEntityDead(entity) and entity == offerEntity then
                                local data = exports["lcrp-drugs"]:drugData()
                                options = {
                                    {
                                        event = "lcrp-drugs:client:offerAnswer",
                                        icon = "fas fa-check",
                                        label = "Accept offer ("..data.amount.."x "..data.drug.." for $"..data.price..")",
                                        duty = false,
                                        parameters = {true, entity}
                                    },
                                    {
                                        event = "lcrp-drugs:client:offerAnswer",
                                        icon = "fas fa-times",
                                        label = "Deny offer",
                                        duty = false,
                                        parameters = {false, entity}
                                    },
                                }
                            else
                                if not IsEntityDead(entity) and entity ~= mugger and not isWaiting then
                                    options = {
                                        {
                                        event = "lcrp-drugs:client:SellDrugs",
                                        icon = "fas fa-cannabis",
                                        label = "Offer drugs",
                                        duty = false,
                                        parameters = entity
                                        },
                                    }
                                end
                            end

     
                            SendNUIMessage({response = "validTarget", data = options})
                            while success and targetActive do
                                local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                                local inVehicle = IsPedInAnyVehicle(GetPlayerPed(-1), false)
                                local distance = 15.0
                                local hit, coords, entity2 = RayCastGamePlayCamera(distance)

                                if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) or IsControlJustReleased(0, 25) or IsDisabledControlJustReleased(0, 25) then
                                    SetNuiFocus(true, true)
                                    SetCursorLocation(0.5, 0.5)
                                end
                                if GetEntityType(entity2) == 0 or #(plyCoords - GetEntityCoords(entity2)) > 5.0 then
                                    success = false
                                end

                                Citizen.Wait(1)
                            end
                            SendNUIMessage({response = "leftTarget"})
                        end
                    end
                elseif exports['lcrp-radialmenu']:IsInTrunkAndNotKidnapped() then
                    success = true
                    local options = { }
                    if exports['lcrp-radialmenu']:IsTrunkOpened() then
                        table.insert(options,{
                            event = "lcrp-radialmenu:client:toggleTrunk",
                            icon = "fas fa-times",
                            label = "Close Trunk",
                            duty = false,
                        })
                    else
                        table.insert(options,{
                            event = "lcrp-radialmenu:client:toggleTrunk",
                            icon = "fas fa-times",
                            label = "Open Trunk",
                            duty = false,
                        })
                    end

                    table.insert(options,{
                        event = "lcrp-radialmenu:client:leaveTrunk",
                        icon = "fas fa-times",
                        label = "Leave Trunk",
                        duty = false,
                    })

  
                    SendNUIMessage({response = "validTarget", plyDuty = onDuty, data = options})
                    while success and targetActive do
                        local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                        local distance = 10.0
                        local hit, coords, entity = RayCastGamePlayCamera(distance)


                        if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) or IsControlJustReleased(0, 25) or IsDisabledControlJustReleased(0, 25) then                                        
                            SetNuiFocus(true, true)
                            SetCursorLocation(0.5, 0.5)
                        end

                        if not exports['lcrp-radialmenu']:IsInTrunk() then
                            success = false
                        end

                        Citizen.Wait(1)
                    end
                    SendNUIMessage({response = "leftTarget"})
                elseif exports['lcrp-jobs']:IsOnBusJobRoute() then
                    success = true
                    local options = { }

                    local data = exports['lcrp-jobs']:IsEndOfRoute()

                    if data.retval then
                        table.insert(options,{
                            event = "lcrp-radialmenu:client:goToNextStop",
                            icon = "fas fa-bus",
                            label = data.text,
                            duty = true,
                        })
                    else
                        table.insert(options,{
                            event = "lcrp-radialmenu:client:goToNextStop",
                            icon = "fas fa-bus",
                            label = data.text,
                            duty = true,
                        })
                    end


                    SendNUIMessage({response = "validTarget", plyDuty = onDuty, data = options})
                    while success and targetActive do
                        local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                        local distance = 10.0
                        local hit, coords, entity = RayCastGamePlayCamera(distance)


                        if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) or IsControlJustReleased(0, 25) or IsDisabledControlJustReleased(0, 25) then                                        
                            SetNuiFocus(true, true)
                            SetCursorLocation(0.5, 0.5)
                        end

                        if not exports['lcrp-jobs']:IsOnBusJobRoute() then
                            success = false
                        end

                        Citizen.Wait(1)
                    end
                    SendNUIMessage({response = "leftTarget"})
                elseif exports["lcrp-boatshop"]:CanPickupCoral(entity) then
                    success = true
                    local data = exports["lcrp-boatshop"]:IsCorrectCoral(entity)
                    local options = {}
                    if data.retval then
                        table.insert(options,{
                            event = "lcrp-boatshop:client:PickupCoral",
                            icon = "fas fa-water",
                            label = "Pick Coral",
                            duty = false,
                            parameters = entity
                        })
                    else
                        table.insert(options,{
                            event = "lcrp-boatshop:client:BadCoral",
                            icon = "fas fa-water",
                            label = "Pick Coral",
                            duty = false,
                            parameters = entity
                        })
                    end


                    SendNUIMessage({response = "validTarget", plyDuty = onDuty, data = options})
                    while success and targetActive do
                        local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                        local distance = 10.0
                        local hit, coords, entity = RayCastGamePlayCamera(distance)



                        if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) or IsControlJustReleased(0, 25) or IsDisabledControlJustReleased(0, 25) then                                        
                            SetNuiFocus(true, true)
                            SetCursorLocation(0.5, 0.5)
                        end

                        if GetEntityType(entity) == 0 or #(plyCoords - coords) > 3 then
                            success = false
                        end

                        Citizen.Wait(1)
                    end
                    SendNUIMessage({response = "leftTarget"})
                elseif exports["lcrp-scripts"]:CanVehicleBePushed(entity) then
                    success = true
                    local options = {{
                        event = "lcrp-scripts:client:PushVehicle",
                        icon = "fas fa-baby-carriage",
                        label = "Push Vehicle",
                        duty = false,
                        parameters = entity
                    }}

  
                    SendNUIMessage({response = "validTarget", plyDuty = onDuty, data = options})
                    while success and targetActive do
                        local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                        local distance = 10.0
                        local hit, coords, entity = RayCastGamePlayCamera(distance)


                        if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) or IsControlJustReleased(0, 25) or IsDisabledControlJustReleased(0, 25) then                                        
                            SetNuiFocus(true, true)
                            SetCursorLocation(0.5, 0.5)
                        end

                        if GetEntityType(entity) == 0 or #(plyCoords - GetEntityCoords(entity)) > 2.8 then
                            success = false
                        end

                        Citizen.Wait(1)
                    end
                    SendNUIMessage({response = "leftTarget"})
                end
            end

            for _, zone in pairs(Zones) do
                if Zones[_]:isPointInside(coords) then
                    for k , v in ipairs(Zones[_]["targetoptions"]["job"]) do 
                        if v == "all" or v == PlayerJob.name then
                            if #(plyCoords - Zones[_].center) <= zone["targetoptions"]["distance"] then
                                
                                if Zones[_].name:sub(-4) == "Boss" then
                                    if PlayerJob.grade == #scCore.Shared.Jobs[Zones[_]["targetoptions"]["job"][1]].roles and onDuty then else return end
                                elseif Zones[_].targetoptions.options[1]['canRestock'] ~= nil and not Zones[_].targetoptions.options[1]['canRestock'] then return
                                elseif Zones[_].targetoptions.options[1]['stolen'] ~= nil and Zones[_].targetoptions.options[1]['stolen'] then return-- for robbery items and searches
                                elseif Zones[_].targetoptions.options[1]['canHarvestWeed'] ~= nil and not Zones[_].targetoptions.options[1]['canHarvestWeed'] then return
                                elseif Zones[_].targetoptions.options[1]['hasDrugDelivery'] ~= nil and not Zones[_].targetoptions.options[1]['hasDrugDelivery'] then return
                                elseif Zones[_].targetoptions.options[1]['hasHospitalMission'] ~= nil and not Zones[_].targetoptions.options[1]['hasHospitalMission'] then return
                                elseif Zones[_].targetoptions.options[1]['gymLicenseRequired'] ~= nil and Zones[_].targetoptions.options[1]['gymLicenseRequired'] ~= exports["lcrp-activities"]:MyGym() then return
                                elseif Zones[_].targetoptions.options[1]['djGrade'] ~= nil and Zones[_].targetoptions.options[1]['djGrade'] ~= PlayerJob.grade then return
                                elseif Zones[_].targetoptions.options[1]['stripperGrade'] ~= nil and Zones[_].targetoptions.options[1]['stripperGrade'] ~= PlayerJob.grade then return
                                elseif Zones[_].targetoptions.options[1]['pacificRobberyStarted'] ~= nil and not Zones[_].targetoptions.options[1]['pacificRobberyStarted'] then return
                                elseif Zones[_].targetoptions.options[1]['paletoRobberyStarted'] ~= nil and not Zones[_].targetoptions.options[1]['paletoRobberyStarted'] then return end
                                
                                success = true
         
                                SendNUIMessage({response = "validTarget", inVehicle = inVehicle, plyDuty = onDuty, data = Zones[_]["targetoptions"]["options"]})
                                while success and targetActive do
                                    local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                                    local inVehicle = IsPedInAnyVehicle(GetPlayerPed(-1), false)
                                    local distance = 20.0
                                    if inVehicle then distance = 60.0 end
                                    local hit, coords, entity = RayCastGamePlayCamera(distance)

                                    
         

                                    if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) or IsControlJustReleased(0, 25) or IsDisabledControlJustReleased(0, 25) then                                        
                                        SetNuiFocus(true, true)
                                        SetCursorLocation(0.5, 0.5)
                                    elseif not Zones[_]:isPointInside(coords) or #(vector3(Zones[_].center.x, Zones[_].center.y, Zones[_].center.z) - plyCoords) > zone.targetoptions.distance then
                                    end
        
                                    if not Zones[_]:isPointInside(coords) or #(plyCoords - Zones[_].center) > zone.targetoptions.distance then
                                        success = false
                                    end
        

                                    Citizen.Wait(1)
                                end
                                SendNUIMessage({response = "leftTarget"})
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(250)
    end
    SetPlayerLockon(PlayerId(), true)
end

stopPunch = function()
    Citizen.CreateThread(function()
        while targetActive do
            Citizen.Wait(5)
            DisablePlayerFiring(PlayerPedId(), true)
        end
    end)
end

function playerTargetDisable()
    if success then return end

    targetActive = false

    SendNUIMessage({response = "closeTarget"})
end

--NUI CALL BACKS

RegisterNUICallback('selectTarget', function(data, cb)
    local event = data.event
    local parameters = data.parameters or {}

    SetNuiFocus(false, false)

    success = false
    targetActive = false

    if data.serverEvent then
        TriggerServerEvent(event, parameters)
    else
        TriggerEvent(event, parameters)
    end
end)

RegisterNUICallback('closeTarget', function(data, cb)
    SetNuiFocus(false, false)

    success = false

    targetActive = false
end)

function RotationToDirection(rotation)
    local adjustedRotation =
    {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction =
    {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination =
    {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
    return b, c, e
end

--Exports

function AddCircleZone(name, center, radius, options, targetoptions)
    Zones[name] = CircleZone:Create(center, radius, options)
    Zones[name].targetoptions = targetoptions
end

function AddBoxZone(name, center, length, width, options, targetoptions)
    Zones[name] = BoxZone:Create(center, length, width, options)
    Zones[name].targetoptions = targetoptions
end

function AddPolyzone(name, points, options, targetoptions)
    Zones[name] = PolyZone:Create(points, options)
    Zones[name].targetoptions = targetoptions
end

function AddTargetModel(models, parameteres)
    for _, model in pairs(models) do
        Models[model] = parameteres
    end
end

function RemoveZone(name)
    if not Zones[name] then return end
    if Zones[name].destroy then
        Zones[name]:destroy()
    end

    Zones[name] = nil
end

exports("AddCircleZone", AddCircleZone)
exports("AddBoxZone", AddBoxZone)
exports("AddPolyzone", AddPolyzone)
exports("AddTargetModel", AddTargetModel)
exports("RemoveZone", RemoveZone)