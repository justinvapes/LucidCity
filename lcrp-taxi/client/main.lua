scCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if scCore == nil then
            TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

local sToggle = false
local isLoggedIn = false
local PlayerData = {}
local onDuty = false

local meterIsOpen = false

local meterActive = false
local currentTaxi = nil

local lastLocation = nil
local kmsDone = 0
local meterData = {
    fareAmount = 3,
    currentFare = 0,
    distanceTraveled = 0,
}

local dutyPlate = nil

local NpcData = {
    Active = false,
    CurrentNpc = nil,
    LastNpc = nil,
    CurrentDeliver = nil,
    LastDeliver = nil,
    Npc = nil,
    NpcBlip = nil,
    DeliveryBlip = nil,
    NpcTaken = false,
    NpcDelivered = false,
    CountDown = 15
}

function TimeoutNpc()
    Citizen.CreateThread(function()
        while NpcData.CountDown ~= 0 do
            NpcData.CountDown = NpcData.CountDown - 1
            Citizen.Wait(1000)
        end
        NpcData.CountDown = 15
    end)
end

RegisterNetEvent('lcrp-taxi:client:DoTaxiNpc')
AddEventHandler('lcrp-taxi:client:DoTaxiNpc', function()
    if whitelistedVehicle() then
        -- if NpcData.CountDown == 15 then
            if not NpcData.Active then
                NpcData.CurrentNpc = math.random(1, #Config.NPCLocations.TakeLocations)
                if NpcData.LastNpc ~= nil then
                    while NpcData.LastNpc ~= NpcData.CurrentNpc do
                        NpcData.CurrentNpc = math.random(1, #Config.NPCLocations.TakeLocations)
                    end
                end

                local Gender = math.random(1, #Config.NpcSkins)
                local PedSkin = math.random(1, #Config.NpcSkins[Gender])
                local model = GetHashKey(Config.NpcSkins[Gender][PedSkin])
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Citizen.Wait(0)
                end
                NpcData.Npc = CreatePed(3, model, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].z - 0.98, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].h, false, true)
                PlaceObjectOnGroundProperly(NpcData.Npc)
                FreezeEntityPosition(NpcData.Npc, true)
                if NpcData.NpcBlip ~= nil then
                    RemoveBlip(NpcData.NpcBlip)
                end
                scCore.Notification('The NPC is indicated on your navigation!', 'success')
                NpcData.NpcBlip = AddBlipForCoord(Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].z)
                SetBlipColour(NpcData.NpcBlip, 3)
                SetBlipRoute(NpcData.NpcBlip, true)
                SetBlipRouteColour(NpcData.NpcBlip, 3)
                Citizen.Wait(1000)
                NpcData.LastNpc = NpcData.CurrentNpc
                NpcData.Active = true
                kmsDone = kmsDone + GetGpsBlipRouteLength()

                Citizen.CreateThread(function()
                    while not NpcData.NpcTaken do

                        local ped = GetPlayerPed(-1)
                        local pos = GetEntityCoords(ped)
                        local dist = GetDistanceBetweenCoords(pos, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].z, true)

                        if dist < 20 then
                            --DrawMarker(2, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                        
                            if dist < 5 then
                                local npccoords = GetEntityCoords(NpcData.Npc)
                                DrawText3D(Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].x, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].y, Config.NPCLocations.TakeLocations[NpcData.CurrentNpc].z, '[E] Pick up client')
                                if IsControlJustPressed(0, Keys["E"]) then
                                    local veh = GetVehiclePedIsIn(ped, 0)
                                    local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

                                    for i=maxSeats - 1, 0, -1 do
                                        if IsVehicleSeatFree(vehicle, i) then
                                            freeSeat = i
                                            break
                                        end
                                    end

                                    meterIsOpen = true
                                    meterActive = true
                                    lastLocation = GetEntityCoords(GetPlayerPed(-1))
                                    SendNUIMessage({
                                        action = "openMeter",
                                        toggle = true,
                                        meterData = Config.Meter
                                    })
                                    SendNUIMessage({
                                        action = "toggleMeter"
                                    })

                                    ClearPedTasksImmediately(NpcData.Npc)
                                    FreezeEntityPosition(NpcData.Npc, false)
                                    TaskEnterVehicle(NpcData.Npc, veh, -1, freeSeat, 1.0, 0)
                                    scCore.Notification('Bring the client to the marked location.')
                                    if NpcData.NpcBlip ~= nil then
                                        RemoveBlip(NpcData.NpcBlip)
                                    end
                                    GetDeliveryLocation()
                                    NpcData.NpcTaken = true
                                end
                            end
                        end

                        Citizen.Wait(1)
                    end
                end)
            else
                scCore.Notification('You are already doing an NPC mission')
            end
        -- else
        --     scCore.Notification('No clients are available')
        -- end
    else
        scCore.Notification('You are not in a Taxi')
    end
end)

function GetDeliveryLocation()
    NpcData.CurrentDeliver = math.random(1, #Config.NPCLocations.DeliverLocations)
    if NpcData.LastDeliver ~= nil then
        while NpcData.LastDeliver ~= NpcData.CurrentDeliver do
            NpcData.CurrentDeliver = math.random(1, #Config.NPCLocations.DeliverLocations)
        end
    end

    if NpcData.DeliveryBlip ~= nil then
        RemoveBlip(NpcData.DeliveryBlip)
    end
    NpcData.DeliveryBlip = AddBlipForCoord(Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].x, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].y, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].z)
    SetBlipColour(NpcData.DeliveryBlip, 3)
    SetBlipRoute(NpcData.DeliveryBlip, true)
    SetBlipRouteColour(NpcData.DeliveryBlip, 3)
    NpcData.LastDeliver = NpcData.CurrentDeliver
    Citizen.Wait(2000)
    kmsDone = kmsDone + GetGpsBlipRouteLength()
    Citizen.Wait(2000)
    TriggerServerEvent("lcrp-taxi:server:JobToggle", kmsDone)

    Citizen.CreateThread(function()
        while true do

            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)
            local dist = GetDistanceBetweenCoords(pos, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].x, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].y, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].z, true)

            if dist < 20 then
                DrawMarker(2, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].x, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].y, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
            
                if dist < 5 then
                    local npccoords = GetEntityCoords(NpcData.Npc)
                    scCore.ShowHelpNotification("[E] Drop off client")
                    --DrawText3D(Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].x, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].y, Config.NPCLocations.DeliverLocations[NpcData.CurrentDeliver].z, '[E] Deliver NPC')
                    if IsControlJustPressed(0, Keys["E"]) then
                        sToggle = false
                        local veh = GetVehiclePedIsIn(ped, 0)
                        TaskLeaveVehicle(NpcData.Npc, veh, 0)
                        SetEntityAsMissionEntity(NpcData.Npc, false, true)
                        SetEntityAsNoLongerNeeded(NpcData.Npc)
                        local targetCoords = Config.NPCLocations.TakeLocations[NpcData.LastNpc]
                        TaskGoStraightToCoord(NpcData.Npc, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
                        SendNUIMessage({
                            action = "toggleMeter"
                        })
                        TriggerServerEvent('lcrp-taxi:server:NpcPay')
                        Citizen.Wait(1000)
                        TriggerServerEvent("lcrp-taxi:server:JobToggle", 0)
                        kmsDone = 0
                        if NpcData.DeliveryBlip ~= nil then
                            RemoveBlip(NpcData.DeliveryBlip)
                        end
                        local RemovePed = function(ped)
                            SetTimeout(60000, function()
                                DeletePed(ped)
                            end)
                        end
                        -- TimeoutNpc()
                        RemovePed(NpcData.Npc)
                        ResetNpcTask()
                        break
                    end
                end
            end

            Citizen.Wait(1)
        end
    end)
end

function ResetNpcTask()
    NpcData = {
        Active = false,
        CurrentNpc = nil,
        LastNpc = nil,
        CurrentDeliver = nil,
        LastDeliver = nil,
        Npc = nil,
        NpcBlip = nil,
        DeliveryBlip = nil,
        NpcTaken = false,
        NpcDelivered = false,
    }
end

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = scCore.Functions.GetPlayerData()
    if PlayerData.job.grade == nil then PlayerData.job.grade = 0 end
    onDuty = PlayerData.job.onduty
end)

RegisterNetEvent('scCore:Client:OnPlayerUnload')
AddEventHandler('scCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    isLoggedIn = true
    onDuty = PlayerData.job.onduty
    if PlayerData.job.grade == nil then PlayerData.job.grade = 0 end
    if PlayerData.job.name == 'taxi' then
        updateInteractClothes()
        updateInteractVehicles()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        calculateFareAmount()
    end
end)

function calculateFareAmount()
    if meterIsOpen and meterActive then
        start = lastLocation
  
        if start then
            current = GetEntityCoords(GetPlayerPed(-1))
            distance = (CalculateTravelDistanceBetweenPoints(start, current) / 10)
            meterData['distanceTraveled'] = distance

    
            fareAmount = (meterData['distanceTraveled'] / 400.00) * meterData['fareAmount']
    
            meterData['currentFare'] = math.ceil(fareAmount)

            SendNUIMessage({
                action = "updateMeter",
                meterData = meterData
            })
        end
    end
end

RegisterNetEvent('lcrp-taxi:client:toggleMeter')
AddEventHandler('lcrp-taxi:client:toggleMeter', function()
    local ped = GetPlayerPed(-1)
    
    if IsPedInAnyVehicle(ped, false) then
        if whitelistedVehicle() then
            if not meterIsOpen then
                SendNUIMessage({
                    action = "openMeter",
                    toggle = true,
                    meterData = Config.Meter
                })
                meterIsOpen = true
            else
                SendNUIMessage({
                    action = "openMeter",
                    toggle = false
                })
                meterIsOpen = false
            end
        else
            scCore.Notification('This vehicle has no Taxi Meter', 'error')
        end
    else
        scCore.Notification('You are not in a vehicle', 'error')
    end
end)

RegisterNetEvent('lcrp-taxi:client:enableMeter')
AddEventHandler('lcrp-taxi:client:enableMeter', function()
    local ped = GetPlayerPed(-1)

    if meterIsOpen then
        SendNUIMessage({
            action = "toggleMeter"
        })
    else
        scCore.Notification('Taxi Meter is not active', 'error')
    end
end)

RegisterNUICallback('enableMeter', function(data)
    meterActive = data.enabled

    if not data.enabled then
        SendNUIMessage({
            action = "resetMeter"
        })
    end
    lastLocation = GetEntityCoords(GetPlayerPed(-1))
end)

RegisterNetEvent('lcrp-taxi:client:toggleMuis')
AddEventHandler('lcrp-taxi:client:toggleMuis', function()
    Citizen.Wait(400)
    if meterIsOpen then
        if not mouseActive then
            SetNuiFocus(true, true)
            mouseActive = true
        end
    else
        scCore.Notification('No Taxi Meter in sight..', 'error')
    end
end)

RegisterNUICallback('hideMouse', function()
    SetNuiFocus(false, false)
    mouseActive = false
end)

function whitelistedVehicle()
    local ped = GetPlayerPed(-1)
    local veh = GetEntityModel(GetVehiclePedIsIn(ped))
    local retval = false

    for i = 1, #Config.AllowedVehicles, 1 do
        if veh == GetHashKey(Config.AllowedVehicles[i].model) then
            retval = true
        end
    end
    return retval
end

function TakeVehicle(vehicleModel)
    TriggerServerEvent('lcrp-taxi:server:Deposit', true, vehicleModel) -- Pay deposit
end

function StoreVehicle(vehicleModel)
    TriggerServerEvent('lcrp-taxi:server:Deposit', false, vehicleModel) -- Pay deposit
end

RegisterNetEvent("lcrp-taxi:client:SpawnVehicle")
AddEventHandler("lcrp-taxi:client:SpawnVehicle", function(vehiclemodel)
    local coords = {x = Config.Locations["vehicle"]["x"], y = Config.Locations["vehicle"]["y"], z = Config.Locations["vehicle"]["z"]}
    scCore.Functions.SpawnVehicle(vehiclemodel, function(veh)
        SetVehicleNumberPlateText(veh, "TAXI"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, Config.Locations["vehicle"]["h"])
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        dutyPlate = GetVehicleNumberPlateText(veh)
    end, coords, true)

end)

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    TaxiBlip = AddBlipForCoord(Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"])

    SetBlipSprite (TaxiBlip, 198)
    SetBlipDisplay(TaxiBlip, 4)
    SetBlipScale  (TaxiBlip, 0.6)
    SetBlipAsShortRange(TaxiBlip, true)
    SetBlipColour(TaxiBlip, 5)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Lucid Taxi Cab")
    EndTextCommandSetBlipName(TaxiBlip)
end)

function SelectOutfit(outfit)
    
    if outfit == "civillian" then
        TriggerServerEvent('lcrp-clothes:get_character_current')
        TriggerServerEvent("lcrp-clothes:retrieve_tats")
    end

    if outfit == "junior" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 26, texture = 4},
                ["arms"]        = { item = 0, texture = 0}, 
                ["t-shirt"]     = { item = 15, texture = 0},  
                ["vest"]        = { item = 0, texture = 0},  
                ["torso2"]      = { item = 22, texture = 1},  
                ["shoes"]       = { item = 42, texture = 1},  
                ["hat"]         = { item = -1, texture = 0},
                ["accessory"]   = { item = -1, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "driver" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 28, texture = 7},
                ["arms"]        = { item = 0, texture = 0}, 
                ["t-shirt"]     = { item = 15, texture = 0},  
                ["vest"]        = { item = 0, texture = 0},  
                ["torso2"]      = { item = 26, texture = 9},  
                ["shoes"]       = { item = 20, texture = 0},  
                ["hat"]         = { item = -1, texture = 0},
                ["accessory"]   = { item = 22, texture = 1},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "senior" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 49, texture = 1},
                ["arms"]        = { item = 0, texture = 0}, 
                ["t-shirt"]     = { item = 18, texture = 0},  
                ["vest"]        = { item = 0, texture = 0},  
                ["torso2"]      = { item = 37, texture = 2},  
                ["shoes"]       = { item = 20, texture = 0},  
                ["hat"]         = { item = -1, texture = 0},
                ["accessory"]   = { item = -1, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "vip" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 28, texture = 0},
                ["arms"]        = { item = 86, texture = 1}, 
                ["t-shirt"]     = { item = 10, texture = 0},  
                ["vest"]        = { item = 0, texture = 0},  
                ["torso2"]      = { item = 28, texture = 0},  
                ["shoes"]       = { item = 10, texture = 0},  
                ["hat"]         = { item = -1, texture = 0},
                ["accessory"]   = { item = 12, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end


    TriggerEvent('InteractSound_CL:PlayOnOne','Clothes1', 0.6)
    closeMenuFull()
end

function close()
    Menu.hidden = true
    showMenu = false
end

function closeMenuFull()
    Menu.hidden = true
    showMenu = false
    ClearMenu()
end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()

	exports["lcrp-interact"]:AddBoxZone("TaxiDuty", vector3(891.2, -175.67, 74.68), 1.2, 3.2, {
		name="TaxiDuty",
        heading=328,
        --debugPoly=true,
        minZ=73.68,
        maxZ=75.08
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
	job = {"taxi"}, distance = 2.0 })

	exports["lcrp-interact"]:AddBoxZone("TaxiBoss", vector3(903.59, -161.16, 78.16), 1.4, 1.6, {
        name="TaxiBoss",
        heading=330,
        --debugPoly=true,
        minZ=77.16,
        maxZ=78.36 }, {
        options = {
            {
                event = "police:server:OpenSocietyMenu",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
                parameters = 'taxi'
            },
        },
    job = {"taxi"}, distance = 2.0})

    

    exports["lcrp-interact"]:AddBoxZone("TaxiOutfits", vector3(893.57, -171.26, 74.68), 3.4, 1, {
        name="TaxiOutfits",
        heading=328,
        --debugPoly=true,
        minZ=73.68,
        maxZ=75.88 }, {
        options = setInteractClothes(),
    job = {"taxi"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("TaxiOutfits2", vector3(898.43, -171.77, 74.68), 2.2, 1, {
        name="TaxiOutfits2",
        heading=328,
        --debugPoly=true,
        minZ=73.68,
        maxZ=75.88 }, {
        options = setInteractClothes(),
    job = {"taxi"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("TaxiVehicle", vector3(909.78, -177.54, 74.11), 4.4, 4.2, {
        name="TaxiVehicle",
        heading=240,
        --debugPoly=true,
        minZ=72.76,
        maxZ=77.56 }, {
        options = setInteractVehicles(),
    job = {"taxi"}, distance = 5.0})

end)

RegisterNetEvent('taxi:client:selectedOutfit')
AddEventHandler('taxi:client:selectedOutfit', function(selection)
    SelectOutfit(selection)
end)

RegisterNetEvent('taxi:client:takeVehicle')
AddEventHandler('taxi:client:takeVehicle', function(model)
    TakeVehicle(model)
end) 

RegisterNetEvent('taxi:client:storeVehicle')
AddEventHandler('taxi:client:storeVehicle', function()
    local ped = PlayerPedId()
    
    if IsPedInAnyVehicle(ped, false) then
        found = false
        local veh = GetVehiclePedIsIn(ped, false)
        local model = GetEntityModel(veh)
        for k,v in pairs(Config.AllowedVehicles) do
            if model == GetHashKey(v.model) then
                DeleteVehicle(veh)
                StoreVehicle(v.model)
                found = true
            end
        end
        if not found then
            scCore.Notification('Vehicle cannot be stored here', 'error')
        end
    end
end)

function setInteractVehicles()
    taxis = {{
        event = "taxi:client:storeVehicle",
        icon = "",
        label = "Taxis",
        duty = true,
        storeVeh = true
    }}
    PlayerData = scCore.Functions.GetPlayerData()
    if PlayerData.job.grade == nil then PlayerData.job.grade = 0 end
    for k,v in pairs(Config.AllowedVehicles)do
        if PlayerData.job.grade >= k  then
            table.insert(taxis, {
                event = "taxi:client:takeVehicle",
                icon = "far fa-taxi",
                label = v.label.." | Deposit : "..v.depositPrice.."$",
                duty = true,
                parameters = v.model,
                storeVeh = true
            })
        end
    end

    return taxis
end

function setInteractClothes()
    outfits = {
        {
            event = "",
            icon = "",
            label = "Taxi Outfits",
            duty = true,
        },
        {
            event = "taxi:client:selectedOutfit",
            icon = "far fa-tshirt",
            label = "Civillian",
            duty = true,
            parameters = "civillian"
        },
    }
    PlayerData = scCore.Functions.GetPlayerData()
    if PlayerData.job.grade == nil then PlayerData.job.grade = 0 end
    for k,v in pairs(Config.Outfits) do
        if PlayerData.job.grade >= k  then
            table.insert(outfits, {
                event = "taxi:client:selectedOutfit",
                icon = "far fa-tshirt",
                label = v.label,
                duty = true,
                parameters = v.name
            })
        end
    end

    return outfits
end

function updateInteractClothes()
    outfits = setInteractClothes()
    TriggerEvent("lcrp-interact:client:updateInteractionOptions",'zone',"TaxiOutfits",outfits)
    TriggerEvent("lcrp-interact:client:updateInteractionOptions",'zone',"TaxiOutfits2",outfits)
end

function updateInteractVehicles()
    taxis = setInteractVehicles()
    TriggerEvent("lcrp-interact:client:updateInteractionOptions",'zone',"TaxiVehicle",taxis)
end
