
-----------------------------------------LOCAL KEYS------------------------------------------------------------------------------------------------------------------------------
local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------LOCAL COORDS----------------
local First = vector3(0.0, 0.0, 0.0)
local Second = vector3(5.0, 5.0, 5.0)
--------------------------------------------
local ped = PlayerPedId()
-----------------LOCAL VEHICLE-------------------------------------------------------------------
local Vehicle = {Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil}
--------------------------------------------------------------------------------------------------
local shouldCheck = true
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    Citizen.Wait(200)
    while true do
        if shouldCheck then
            local ped = PlayerPedId()
        
            local vehicle = GetVehiclePedIsIn(ped, true)
            
            local vehicleCoordsa = GetEntityCoords(vehicle)

            local closestVehicle = scCore.Functions.GetClosestVehicle()

            local Distance = closestVehicle

            local vehicleCoords = GetEntityCoords(vehicle)

            local dimension = GetModelDimensions(GetEntityModel(closestVehicle), First, Second)
        
            if DoesEntityExist(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(ped), vehicleCoordsa) < 3 then

                Vehicle.Coords = vehicleCoords

                Vehicle.Dimensions = dimension

                Vehicle.Vehicle = closestVehicle

                Vehicle.Distance = Distance

                Vehicle.IsInFront = true

                if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), GetEntityCoords(ped), true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, GetEntityCoords(ped), true) then
                    Vehicle.IsInFront = false
                end
            else
                Vehicle = {Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false, Distance = nil}
            end
        end
        Citizen.Wait(1000)
    end
end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------


----TEXT 3D-------------------------------------------------------------------
function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

---------------------------------------------END TEXT-----------------------------------------------------------------

-----------------------------------------------------------------PUSH VEHICLE----------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function CanVehicleBePushed(entity)
    if Vehicle.Vehicle ~= nil and GetEntityType(entity) == 2 and GetVehicleEngineHealth(Vehicle.Vehicle) <= Config.DamageNeeded and not IsEntityAttachedToEntity(PlayerPedId(), Vehicle.Vehicle) and IsVehicleSeatFree(Vehicle.Vehicle, -1) then
        return true
    end
    return false
end

RegisterNetEvent("lcrp-scripts:client:PushVehicle")
AddEventHandler("lcrp-scripts:client:PushVehicle", function()
    if Vehicle.Vehicle ~= nil then
        local ped = PlayerPedId()
        shouldCheck = false
        NetworkRequestControlOfEntity(Vehicle.Vehicle)
        local coords = GetEntityCoords(ped)
        if Vehicle.IsInFront then    
            AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y * -1 + 0.1 , Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true)
        else
            AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y - 0.3, Vehicle.Dimensions.z  + 1.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, true)
        end

        RequestAnimDict('missfinale_c2ig_11')
        TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
        scCore.Notification("Pushing vehicle, press [E] to cancel")
        Citizen.Wait(200)

        Citizen.CreateThread(function()
            local currentVehicle = Vehicle.Vehicle
            while true do
                Citizen.Wait(5)
                if IsDisabledControlPressed(0, Keys["A"]) then
                    TaskVehicleTempAction(PlayerPedId(), currentVehicle, 11, 1000)
                end

                if IsDisabledControlPressed(0, Keys["D"]) then
                    TaskVehicleTempAction(PlayerPedId(), currentVehicle, 10, 1000)
                end
                if Vehicle.IsInFront then
                    SetVehicleForwardSpeed(currentVehicle, -1.0)
                else
                    SetVehicleForwardSpeed(currentVehicle, 1.0)
                end

                if HasEntityCollidedWithAnything(currentVehicle) then
                    SetVehicleOnGroundProperly(currentVehicle)
                end

                if IsDisabledControlPressed(0, Keys["E"]) then
                    DetachEntity(ped, false, false)
                    StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
                    FreezeEntityPosition(ped, false)
                    shouldCheck = true
                    break
                end
            end
        end)
    end
end)