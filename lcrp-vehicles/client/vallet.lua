PlayerData = nil
RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    scCore.Functions.GetPlayerData(function(PlayerData)
        PlayerData = PlayerData
    end)
    isLoggedIn = true
end)

local offsets = {
    {x = 0.0, y = 300.0},
    {x = 0.0, y = -300.0},
    {x = 300.0, y = 0.0},
    {x = -300.0, y = 0.0},
}

RegisterNetEvent('lcrp-valet:client:requestService')
AddEventHandler('lcrp-valet:client:requestService', function(vehicle)
    local pos = GetEntityCoords(PlayerPedId())
    local r1, r2, r3 = GetClosestRoad(pos.x, pos.y, pos.z, 1.0, 1, false)
    if #(r2 - pos) < 50 then
        local closestPDist = vector3(5000.0, 5000.0, 5000.0)
        local closestP
        for i = 1, #offsets, 1 do
            local b, s, s1 = GetClosestRoad(pos.x + offsets[i].x, pos.y + offsets[i].y, pos.z, 1.0, 1, false)
            local curDist = #(pos - s1)
            local oldDist = #(pos - closestPDist)
            if curDist < oldDist and curDist >= 100 then
                closestP = s1
                closestPDist = curDist
            end
        end	
        closestP = {x = closestP[1], y = closestP[2], z = closestP[3], a = 100}
        scCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
            scCore.TriggerServerCallback('lcrp-garages:server:GetVehicleProperties', function(properties)
                scCore.Functions.SetVehicleProperties(veh, properties)


                if vehicle.status ~= nil and next(vehicle.status) ~= nil then
                    TriggerServerEvent('lcrp-tuning:server:LoadStatus', vehicle.status, vehicle.plate)
                end

                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, 100.0)
                exports['LegacyFuel']:SetFuel(veh, 100)
                SetEntityAsMissionEntity(veh, true, true)
                TriggerServerEvent('lcrp-garages:server:updateVehicleState', 0, vehicle.plate)
                scCore.Notification("The valet is on his way! Wait here for his arrival", "primary", 4500)
                closeMenuFull()
                SetVehicleEngineOn(veh, true, true)
                local hashKey = `s_m_y_valet_01`
                local pedType = GetPedType(hashKey)
                RequestModel(hashKey)
                while not HasModelLoaded(hashKey) do
                    RequestModel(hashKey)
                    Citizen.Wait(100)
                end
                local valet = CreatePed(pedType, hashKey, closestP.x, closestP.y, closestP.z, true, true) 
                SetPedDefaultComponentVariation(valet)
                TaskWarpPedIntoVehicle(valet, veh, -1)
                Citizen.Wait(1000)
                local a, sidewalk = GetPointOnRoadSide(pos.x, pos.y, pos.z)
                local b, v1, v2 = GetClosestRoad(sidewalk.x, sidewalk.y, sidewalk.z, 1.0)
                local xScuffed = (sidewalk.x + v2.x) / 2
                local yScuffed = (sidewalk.y + v2.y) / 2
                local zScuffed = (sidewalk.z + v2.z) / 2
                TaskVehicleDriveToCoord(valet, veh, xScuffed, yScuffed, zScuffed, 20.0, 8388614, 15.0, true)
                local isArriving = false
                while #(GetEntityCoords(veh) - vector3(xScuffed, yScuffed, zScuffed)) > 15.0 do
                    local carDist = #(GetEntityCoords(veh) - vector3(xScuffed, yScuffed, zScuffed))
                    if carDist < 20 and not isArriving then
                        SetDriveTaskCruiseSpeed(valet, 5.0)
                        TriggerEvent('animations:client:EmoteCommandStart', {"whistle"})
                        isArriving = true
                    end
                    Citizen.Wait(0)
                end
                local carhead = GetEntityHeading(veh)
                local xScuffed2 = (sidewalk.x + xScuffed) / 2
                local yScuffed2 = (sidewalk.y + yScuffed) / 2
                local zScuffed2 = (sidewalk.z + zScuffed) / 2
                TaskVehiclePark(valet, veh, xScuffed2, yScuffed2, zScuffed2, carhead, 1, 20.0, false)
                while GetIsVehicleEngineRunning(veh) do
                    if GetEntitySpeed(veh) < 1 and #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(veh)) < 5 then
                        SetVehicleEngineOn(veh, false, false, false)
                    end
                    Citizen.Wait(0)
                end
                TaskLeaveVehicle(valet, veh, 256)
                Citizen.Wait(1000)
                TaskGoToEntity(valet, PlayerPedId(), -1, 4.0, 20.0, 1073741824, 0)
                while #(GetEntityCoords(valet) - GetEntityCoords(PlayerPedId())) > 2 do
                    Citizen.Wait(0)
                end
                local giveDict = "pickup_object"
                local giveAnim = "putdown_low"
                RequestAnimDict(giveDict)
                while not HasAnimDictLoaded(giveDict) do
                    Citizen.Wait(0)
                end
                TaskPlayAnim(valet, giveDict, giveAnim, 8.0, 8.0, -1, 48, 1, false, false, false)
                Citizen.Wait(1000)
                ClearPedTasksImmediately(valet)
                TaskWanderStandard(valet, 10.0, 10.0)
                Citizen.Wait(60000)
                DeletePed(valet)
            end, vehicle.plate)
            TriggerEvent("vehiclekeys:client:SetOwner", vehicle.plate)
        end, closestP, true) 
    else
        scCore.Notification("You need to be near a suitable road for the valet to reach you.", "error")
    end
end)

--[[ RegisterCommand("valet", function()
    local pos = GetEntityCoords(PlayerPedId())
    local r1, r2, r3 = GetClosestRoad(pos.x, pos.y, pos.z, 1.0, 1, false)
    if #(r2 - pos) < 50 then
        local closestPDist = vector3(5000.0, 5000.0, 5000.0)
        local closestP
        for i = 1, #offsets, 1 do
            local b, s, s1 = GetClosestRoad(pos.x + offsets[i].x, pos.y + offsets[i].y, pos.z, 1.0, 1, false)
            local curDist = #(pos - s1)
            local oldDist = #(pos - closestPDist)
            if curDist < oldDist and curDist >= 100 then
                closestP = s1
                closestPDist = curDist
            end
        end	
        closestP = {x = closestP[1], y = closestP[2], z = closestP[3], a = 100}
        -- HARDCODED FOR TESTING

        vehicle = {}
        vehicle.vehicle = "svj63"
        vehicle.plate = "04CJE486"
        scCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
            scCore.TriggerServerCallback('lcrp-garages:server:GetVehicleProperties', function(properties)
                scCore.Functions.SetVehicleProperties(veh, properties)


                if vehicle.status ~= nil and next(vehicle.status) ~= nil then
                    TriggerServerEvent('lcrp-tuning:server:LoadStatus', vehicle.status, vehicle.plate)
                end

                SetVehicleNumberPlateText(veh, vehicle.plate)
                SetEntityHeading(veh, 100.0)
                exports['LegacyFuel']:SetFuel(veh, 100)
                SetEntityAsMissionEntity(veh, true, true)
                TriggerServerEvent('lcrp-garages:server:updateVehicleState', 0, vehicle.plate)
                scCore.Notification("The valet is on his way! Wait here for his arrival", "primary", 4500)
                closeMenuFull()
                SetVehicleEngineOn(veh, true, true)
                local hashKey = `s_m_y_valet_01`
                local pedType = GetPedType(hashKey)
                RequestModel(hashKey)
                while not HasModelLoaded(hashKey) do
                    RequestModel(hashKey)
                    Citizen.Wait(100)
                end
                local valet = CreatePed(pedType, hashKey, closestP.x, closestP.y, closestP.z, true, true) 
                SetPedDefaultComponentVariation(valet)
                TaskWarpPedIntoVehicle(valet, veh, -1)
                Citizen.Wait(1000)
                local a, sidewalk = GetPointOnRoadSide(pos.x, pos.y, pos.z)
                local b, v1, v2 = GetClosestRoad(sidewalk.x, sidewalk.y, sidewalk.z, 1.0)
                local xScuffed = (sidewalk.x + v2.x) / 2
                local yScuffed = (sidewalk.y + v2.y) / 2
                local zScuffed = (sidewalk.z + v2.z) / 2
                TaskVehicleDriveToCoord(valet, veh, xScuffed, yScuffed, zScuffed, 20.0, 8388614, 15.0, true)
                local isArriving = false
                while #(GetEntityCoords(veh) - vector3(xScuffed, yScuffed, zScuffed)) > 15.0 do
                    local carDist = #(GetEntityCoords(veh) - vector3(xScuffed, yScuffed, zScuffed))
                    if carDist < 20 and not isArriving then
                        SetDriveTaskCruiseSpeed(valet, 5.0)
                        TriggerEvent('animations:client:EmoteCommandStart', {"whistle"})
                        isArriving = true
                    end
                    Citizen.Wait(0)
                end
                local carhead = GetEntityHeading(veh)
                local xScuffed2 = (sidewalk.x + xScuffed) / 2
                local yScuffed2 = (sidewalk.y + yScuffed) / 2
                local zScuffed2 = (sidewalk.z + zScuffed) / 2
                TaskVehiclePark(valet, veh, xScuffed2, yScuffed2, zScuffed2, carhead, 1, 20.0, false)
                while GetIsVehicleEngineRunning(veh) do
                    if GetEntitySpeed(veh) < 1 and #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(veh)) < 5 then
                        SetVehicleEngineOn(veh, false, false, false)
                    end
                    Citizen.Wait(0)
                end
                TaskLeaveVehicle(valet, veh, 256)
                Citizen.Wait(1000)
                TaskGoToEntity(valet, PlayerPedId(), -1, 4.0, 20.0, 1073741824, 0)
                while #(GetEntityCoords(valet) - GetEntityCoords(PlayerPedId())) > 2 do
                    Citizen.Wait(0)
                end
                local giveDict = "pickup_object"
                local giveAnim = "putdown_low"
                RequestAnimDict(giveDict)
                while not HasAnimDictLoaded(giveDict) do
                    Citizen.Wait(0)
                end
                TaskPlayAnim(valet, giveDict, giveAnim, 8.0, 8.0, -1, 48, 1, false, false, false)
                Citizen.Wait(1000)
                ClearPedTasksImmediately(valet)
                TaskWanderStandard(valet, 10.0, 10.0)
                Citizen.Wait(60000)
                DeletePed(valet)
            end, vehicle.plate)
            TriggerEvent("vehiclekeys:client:SetOwner", vehicle.plate)
        end, closestP, true) 
    else
        scCore.Notification("You need to be near a suitable road for the valet to reach you.", "error")
    end
end) ]]
