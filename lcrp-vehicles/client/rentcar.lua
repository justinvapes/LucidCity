scCore = nil

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

local selectedVeh = nil
local CurrentPlate = nil
local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)

Citizen.CreateThread(function()
    DeliveriesBlip = AddBlipForCoord(986.04, -214.90, 70.55)
    SetBlipSprite(DeliveriesBlip, 225)
    SetBlipDisplay(DeliveriesBlip, 4)
    SetBlipScale(DeliveriesBlip, 0.8)
    SetBlipAsShortRange(DeliveriesBlip, true)
    SetBlipColour(DeliveriesBlip, 11)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Rent Vehicles")
    EndTextCommandSetBlipName(DeliveriesBlip)
end)

RegisterNetEvent("lcrp-vehicles:client:RentCar")
AddEventHandler("lcrp-vehicles:client:RentCar", function(vehicleInfo)
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)

    if vehicle ~= 0 and vehicle ~= nil then
        if isRentVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
            if CurrentPlate == GetVehicleNumberPlateText(vehicle) then
                DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                TriggerServerEvent('lcrp-vehicles:server:Deposit', false) -- Give back deposit
            else
                scCore.Notification("Vehicle plate doesn\'t match the rented one!", "error")
            end
        end
    else
        print(vehicleInfo)
        if vehicleInfo == "Pigalle" then
            rentPrice = 120
        elseif vehicleInfo == "Mesa" then
            rentPrice = 150
        else
            rentPrice = 100
        end
    
        TriggerServerEvent('lcrp-vehicles:server:Deposit', true, vehicleInfo, rentPrice)
        selectedVeh = vehicleInfo
    end
end)

RegisterNetEvent('lcrp-vehicles:client:SpawnVehicle')
AddEventHandler('lcrp-vehicles:client:SpawnVehicle', function()
    local vehicleInfo = selectedVeh
    local coords = {x = 986.04, y = -214.90, z = 70.55, h = 236.97}

    scCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "RENT"..tostring(math.random(100, 999)))
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        CurrentPlate = GetVehicleNumberPlateText(veh)

    end, coords, true)
end)

function isRentVehicle(vehicle)
    local retval = false
    for k, v in pairs(Config.RentingVehicles) do
        if GetEntityModel(vehicle) == GetHashKey(k) then
            retval = true
        end
    end
    return retval
end

function closeMenuFull()
    Menu.hidden = true
    renderGUI = false
    currentGarage = nil
    ClearMenu()
end

function RentVehicle()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Rent Vehicles", "VehicleList", nil)
    Menu.addButton("Close Menu", "closeMenuFull", nil) 
end