Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

scCore = nil
isLoggedIn = false
PlayerJob = {}

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

RegisterNetEvent("scCore:Client:OnPlayerLoaded")
AddEventHandler("scCore:Client:OnPlayerLoaded", function()
    scCore.TriggerServerCallback('lcrp-boatshop:server:GetBusyDocks', function(Docks)
        Boatshop.Locations["berths"] = Docks
    end)

    scCore.TriggerServerCallback('lcrp-boatshop:server:GetDivingConfig', function(Config, Area)
        Diving.Locations = Config
        TriggerEvent('lcrp-boatshop:client:SetDivingLocation', Area)
    end)

    PlayerJob = scCore.Functions.GetPlayerData().job

    isLoggedIn = true

    if PlayerJob.name == "police" or PlayerJob.name == "statepolice" then
        if PoliceBlip ~= nil then
            RemoveBlip(PoliceBlip)
        end
        PoliceBlip = AddBlipForCoord(Boatshop.PoliceBoat.x, Boatshop.PoliceBoat.y, Boatshop.PoliceBoat.z)
        SetBlipSprite(PoliceBlip, 410)
        SetBlipDisplay(PoliceBlip, 4)
        SetBlipScale(PoliceBlip, 0.8)
        SetBlipAsShortRange(PoliceBlip, true)
        SetBlipColour(PoliceBlip, 29)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Police boat")
        EndTextCommandSetBlipName(PoliceBlip)
    end
end)

RegisterNetEvent('lcrp-boatshop:client:UseJerrycan')
AddEventHandler('lcrp-boatshop:client:UseJerrycan', function()
    local ped = GetPlayerPed(-1)
    local boat = IsPedInAnyBoat(ped)
    if boat then
        local curVeh = GetVehiclePedIsIn(ped, false)
        scCore.TaskBar("reful_boat", "Refueling boat", 20000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            exports['LegacyFuel']:SetFuel(curVeh, 100)
            scCore.Notification('The boat has been refueled', 'success')
            TriggerServerEvent('lcrp-boatshop:server:RemoveItem', 'jerry_can', 1)
            TriggerEvent('inventory:client:ItemBox', scCore.Shared.Items['jerry_can'], "remove")
        end, function() -- Cancel
            scCore.Notification('Refueling has been canceled!', 'error')
        end)
    else
        scCore.Notification('You are not in a boat', 'error')
    end
end)