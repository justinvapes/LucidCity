--------------------------------------
------Created By Whit3Xlightning------
--https://github.com/Whit3XLightning--
---- IMPROVED BY THE ONE AND ONLY ----
---------------- MBRO ----------------
--------------------------------------

RegisterNetEvent("wld:delallveh")
AddEventHandler("wld:delallveh", function ()
    for vehicle in EnumerateVehicles() do
        local isEmpty = true;
        local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
        for i = -1, maxSeats - 1 do
            if IsPedAPlayer(GetPedInVehicleSeat(vehicle, i)) then
                isEmpty = false
                break
            end
        end
        if (isEmpty) then
            if GetVehicleDoorLockStatus(vehicle) ~= 2 then
                SetVehicleHasBeenOwnedByPlayer(vehicle, false) 
                SetEntityAsMissionEntity(vehicle, false, false) 
                DeleteVehicle(vehicle)
                if (DoesEntityExist(vehicle)) then 
                    DeleteVehicle(vehicle) 
                end
            end
        end
    end
end)

RegisterNetEvent("wld:delallped")
AddEventHandler("wld:delallped", function ()
    for ped in EnumeratePeds() do
        if not IsPedAPlayer(ped) then
            if DoesEntityExist(ped) then
                DeleteEntity(ped)
            end
        end
    end
end)