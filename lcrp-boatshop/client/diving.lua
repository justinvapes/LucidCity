local CurrentDivingLocation = {
    Area = 0,
    Blip = {
        Radius = nil,
        Label = nil
    }
}

Diving.Locations = { }

local coralModel = 'prop_coral_pillar_01'
local spawnedCorals = {}

RegisterNetEvent('lcrp-boatshop:client:NewLocations')
AddEventHandler('lcrp-boatshop:client:NewLocations', function()
    scCore.TriggerServerCallback('lcrp-boatshop:server:GetDivingConfig', function(Config, Area)

        Diving.Locations = Config
        TriggerEvent('lcrp-boatshop:client:SetDivingLocation', Area)
    end)
end)

function spawnCoralObjects()
    for k,v in pairs(Diving.Locations[CurrentDivingLocation.Area].coords.Coral) do
        SpawnObject(coralModel,
            {x = v.coords.x, y = v.coords.y, z = v.coords.z}, function(obj)
            SetEntityHeading(obj, math.random(2,359))
            PlaceObjectOnGroundProperly(obj)
            FreezeEntityPosition(obj, true)
            spawnedCorals[k] = obj
        end) 
    end
end

function SpawnObject(model, coords, cb)
    local modelName = model
    if tonumber(model) ~= nil then model = tonumber(model) end
    if type(model) == 'string' then model = GetHashKey(model) end

    Citizen.CreateThread(function()
        RequestModel(model)
        while not HasModelLoaded(model) do Citizen.Wait(0) end

        obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, false)

        if cb ~= nil then cb(obj) end
    end)
end

RegisterNetEvent('lcrp-boatshop:client:SetDivingLocation')
AddEventHandler('lcrp-boatshop:client:SetDivingLocation', function(DivingLocation)
    CurrentDivingLocation.Area = DivingLocation
    spawnCoralObjects()

    for _,Blip in pairs(CurrentDivingLocation.Blip) do
        if Blip ~= nil then
            RemoveBlip(Blip)
        end
    end
    
    Citizen.CreateThread(function()
        RadiusBlip = AddBlipForRadius(Diving.Locations[CurrentDivingLocation.Area].coords.Area.x, Diving.Locations[CurrentDivingLocation.Area].coords.Area.y, Diving.Locations[CurrentDivingLocation.Area].coords.Area.z, 100.0)
        
        SetBlipRotation(RadiusBlip, 0)
        SetBlipColour(RadiusBlip, 42)

        CurrentDivingLocation.Blip.Radius = RadiusBlip

        LabelBlip = AddBlipForCoord(Diving.Locations[CurrentDivingLocation.Area].coords.Area.x, Diving.Locations[CurrentDivingLocation.Area].coords.Area.y, Diving.Locations[CurrentDivingLocation.Area].coords.Area.z)

        SetBlipSprite (LabelBlip, 597)
        SetBlipDisplay(LabelBlip, 4)
        SetBlipScale  (LabelBlip, 0.7)
        SetBlipColour(LabelBlip, 0)
        SetBlipAsShortRange(LabelBlip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Diving area')
        EndTextCommandSetBlipName(LabelBlip)

        CurrentDivingLocation.Blip.Label = LabelBlip
    end)
end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end

function TakeCoral(coral)
    Diving.Locations[CurrentDivingLocation.Area].coords.Coral[coral].PickedUp = true
    if spawnedCorals[coral] ~= nil then
        DeleteObject(spawnedCorals[coral])
        spawnedCorals[coral] = nil
    end
    TriggerServerEvent('lcrp-boatshop:server:TakeCoral', CurrentDivingLocation.Area, coral, true)
end

RegisterNetEvent('lcrp-boatshop:client:UpdateCoral')
AddEventHandler('lcrp-boatshop:client:UpdateCoral', function(Area, Coral, Bool)
    if spawnedCorals[coral] ~= nil then
        DeleteObject(spawnedCorals[coral])
        spawnedCorals[coral] = nil
    end
    Diving.Locations[Area].coords.Coral[Coral].PickedUp = Bool
end)

local currentGear = {
    mask = 0,
    tank = 0,
    enabled = false
}

function DeleteGear()
	if currentGear.mask ~= 0 then
        DetachEntity(currentGear.mask, 0, 1)
        DeleteEntity(currentGear.mask)
		currentGear.mask = 0
    end
    
	if currentGear.tank ~= 0 then
        DetachEntity(currentGear.tank, 0, 1)
        DeleteEntity(currentGear.tank)
		currentGear.tank = 0
	end
end

RegisterNetEvent('lcrp-boatshop:client:UseGear')
AddEventHandler('lcrp-boatshop:client:UseGear', function(bool)
    if bool then
        GearAnim()
        scCore.TaskBar("equip_gear", "Putting diving gear on", 5000, false, true, {}, {}, {}, {}, function() -- Done
            DeleteGear()
            local maskModel = GetHashKey("p_d_scuba_mask_s")
            local tankModel = GetHashKey("p_s_scuba_tank_s")
    
            RequestModel(tankModel)
            while not HasModelLoaded(tankModel) do
                Citizen.Wait(1)
            end
            TankObject = CreateObject(tankModel, 1.0, 1.0, 1.0, 1, 1, 0)
            local bone1 = GetPedBoneIndex(GetPlayerPed(-1), 24818)
            AttachEntityToEntity(TankObject, GetPlayerPed(-1), bone1, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
            currentGear.tank = TankObject
    
            RequestModel(maskModel)
            while not HasModelLoaded(maskModel) do
                Citizen.Wait(1)
            end
            
            MaskObject = CreateObject(maskModel, 1.0, 1.0, 1.0, 1, 1, 0)
            local bone2 = GetPedBoneIndex(GetPlayerPed(-1), 12844)
            AttachEntityToEntity(MaskObject, GetPlayerPed(-1), bone2, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
            currentGear.mask = MaskObject
    
            SetEnableScuba(GetPlayerPed(-1), true)
            SetPedMaxTimeUnderwater(GetPlayerPed(-1), 2000.00)
            currentGear.enabled = true
            TriggerServerEvent('lcrp-boatshop:server:RemoveGear')
            ClearPedTasks(GetPlayerPed(-1))
            TriggerEvent('chatMessage', "SYSTEM", "error", "Use command /divingsuit to take off your wetsuit!")
        end)
    else
        if currentGear.enabled then
            GearAnim()
            scCore.TaskBar("remove_gear", "Taking diving gear off", 5000, false, true, {}, {}, {}, {}, function() -- Done
                DeleteGear()

                SetEnableScuba(GetPlayerPed(-1), false)
                SetPedMaxTimeUnderwater(GetPlayerPed(-1), 1.00)
                currentGear.enabled = false
                TriggerServerEvent('lcrp-boatshop:server:GiveBackGear')
                ClearPedTasks(GetPlayerPed(-1))
                scCore.Notification('You took your Diving gear off')
            end)
        else
            scCore.Notification('You are not wearing a diving gear', 'error')
        end
    end
end)



RegisterNetEvent('llcrp-boatshop:client:BadCoral')
AddEventHandler('lcrp-boatshop:client:BadCoral', function(coral)
    scCore.Notification("This coral sucks! Look for another")
end)

RegisterNetEvent('lcrp-boatshop:client:PickupCoral')
AddEventHandler('lcrp-boatshop:client:PickupCoral', function(coral)
    local data = IsCorrectCoral(coral)
    
    if data.retval then
        local Ped = GetPlayerPed(-1)
        local times = math.random(2, 5)
        FreezeEntityPosition(Ped, true)
        scCore.TaskBar("take_coral", "Collecting coral", times * 1000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
            anim = "plant_floor",
            flags = 16,
        }, {}, {}, function() -- Done
            TakeCoral(data.coralID)
            ClearPedTasks(Ped)
            FreezeEntityPosition(Ped, false)
        end, function() -- Cancel
            ClearPedTasks(Ped)
            FreezeEntityPosition(Ped, false)
        end)
    else
        scCore.Notification("This coral cannot be extracted!","error")
    end
end)

function GearAnim()
    loadAnimDict("clothingshirt")    	
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

function CanPickupCoral(entity)
    local divingArea = Diving.Locations[CurrentDivingLocation.Area].coords.Area
    if GetEntityType(entity) == 3 and GetEntityModel(entity) == GetHashKey(coralModel) and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), divingArea.x, divingArea.y, divingArea.z, true) < 200 and currentGear.enabled then
        return true
    else
        return false
    end
end

function IsCorrectCoral(entity)
    for k,v in pairs(spawnedCorals) do
        if v == entity then
            return {retval = true, coralID = k}
        end
    end
    return {retval = false, coralID = 0}
end