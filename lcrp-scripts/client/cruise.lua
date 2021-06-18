local cruiseOn = false
local Speed = 0.0
local cruiseSpeed = 0.0
local lastVehicle = nil

Citizen.CreateThread(function()
    while true do
        sleep = 500
        if IsPedInAnyVehicle(GetPlayerPed(-1)) then
            sleep = 5
            Speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1)))

            if IsControlJustReleased(0, Keys["U"]) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1)), -1) == GetPlayerPed(-1) then 
                if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                    cruiseSpeed = Speed
                    if cruiseOn then
                        scCore.Notification("Cruise turned off")
                    else
                        scCore.Notification("Limiter set to "..tostring(math.floor(cruiseSpeed * 2.23694)).." mph")
                    end
                    TriggerEvent("seatbelt:client:ToggleCruise")
                end
            end
        elseif lastVehicle ~= nil then
            local maxSpeed = GetVehicleHandlingFloat(lastVehicle,"CHandlingData","fInitialDriveMaxFlatVel")
            SetEntityMaxSpeed(lastVehicle, maxSpeed)
            lastVehicle = nil
            Citizen.Wait(1500)
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent("seatbelt:client:ToggleCruise")
AddEventHandler("seatbelt:client:ToggleCruise", function()
    cruiseOn = not cruiseOn
    local maxSpeed = cruiseOn and cruiseSpeed or GetVehicleHandlingFloat(GetVehiclePedIsIn(GetPlayerPed(-1), false),"CHandlingData","fInitialDriveMaxFlatVel")
    SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false), maxSpeed)
    lastVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
end)