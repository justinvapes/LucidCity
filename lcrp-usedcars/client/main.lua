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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if scCore == nil then
            TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
            Citizen.Wait(200)
        end
    end
end)



local occasionVehicles = {}
local inRange
local vehiclesSpawned = false
local isConfirming = false
local contract = false
local takeBack = false

Citizen.CreateThread(function()
    while true do
        inRange = false
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        if scCore ~= nil then
            for _,slot in pairs(Config.OccasionSlots) do
                local dist = GetDistanceBetweenCoords(pos, slot["x"], slot["y"], slot["z"])
                if dist <= 40 then
                    inRange = true
                    if not vehiclesSpawned then
                        vehiclesSpawned = true
                        scCore.TriggerServerCallback('lcrp-usedcars:server:getVehicles', function(vehicles)
                            occasionVehicles = vehicles
                            despawnOccasionsVehicles()
                            spawnOccasionsVehicles(vehicles)
                        end)
                    end
                end
            end
            if inRange then
                for i = 1, #Config.OccasionSlots, 1 do
                    local vehPos = GetEntityCoords(Config.OccasionSlots[i]["occasionId"])
                    local dstCheck = GetDistanceBetweenCoords(pos, vehPos)
                    
                    if dstCheck <= 2.5 then
                        if not IsPedInAnyVehicle(ped) then
                            local isOwner = false
                            if Config.OccasionSlots[i]["owner"] == scCore.Functions.GetPlayerData().citizenid then
                               isOwner = true
                            end
                            TriggerEvent('lcrp-interact:client:usedCars', true, isOwner)
                            if contract then
                                currentVehicle = i
                                scCore.TriggerServerCallback('lcrp-usedcars:server:getSellerInformation', function(info)
                                    if info ~= nil then 
                                        info.charinfo = json.decode(info.charinfo)
                                    else
                                        info = {}
                                        info.charinfo = {
                                            firstname = "Unknown",
                                            lastname = "Unknown..",
                                            account = "Account unknown",
                                            phone = "Phone number Unknown"
                                        }
                                    end
                                    openBuyContract(info, Config.OccasionSlots[currentVehicle])
                                    contract = false
                                end, Config.OccasionSlots[currentVehicle]["owner"])
                            elseif takeBack then
                                currentVehicle = i
                                TriggerServerEvent("lcrp-usedcars:server:ReturnVehicle", Config.OccasionSlots[i])
                                takeBack = false
                            end
                        end
                    end
                end

                
            end

            if not inRange then
                if vehiclesSpawned then
                    vehiclesSpawned = false
                    despawnOccasionsVehicles()
                    TriggerEvent('lcrp-interact:client:usedCars', false, false)
                end
                Citizen.Wait(1000)
            end
        end

        Citizen.Wait(5)
    end
end) 

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddBoxZone("sellUsedCar", vector3(1235.53, 2730.59, 38.01), 5.8, 5.2, {
        name="sellUsedCar",
        heading=0,
        --debugPoly=true,
        minZ=35.41,
        maxZ=39.41 }, {
        options = {
            {
            event = "lcrp-usedcars:client:sellUsedCar",
            icon = "fas fa-file-contract",
            label = "Add vehicle for sale",
            duty = false,
            onlyInVeh = true,
            },
        },
        job = {"all"}, distance = 4 })
end)


RegisterNetEvent("lcrp-usedcars:client:openCarInfo")
AddEventHandler("lcrp-usedcars:client:openCarInfo", function()
    contract = true
end)

RegisterNetEvent("lcrp-usedcars:client:takeBack")
AddEventHandler("lcrp-usedcars:client:takeBack", function()
    takeBack = true
end)

RegisterNetEvent("lcrp-usedcars:client:sellUsedCar")
AddEventHandler("lcrp-usedcars:client:sellUsedCar", function()
    local VehiclePlate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId()))
    local parsedPlate = string.gsub(VehiclePlate, '%s+', '') 
    scCore.TriggerServerCallback('lcrp-usedcars:server:checkVehicleOwner', function(data)
        if data[1] then
            if GetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId())) > 800 then
                openSellContract(true, data[2])
            else
                scCore.Notification('You can\'t put a damaged car up for sale', 'error', 3500)
            end
        else
            scCore.Notification('You don\'t own this vehicle!', 'error', 3500)
        end
    end, parsedPlate)
end)

function spawnOccasionsVehicles(vehicles)
    local oSlot = Config.OccasionSlots

    if vehicles ~= nil then
        for i = 1, #vehicles, 1 do
            local model = GetHashKey(vehicles[i].model)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end

            oSlot[i]["occasionId"] = CreateVehicle(model, oSlot[i]["x"], oSlot[i]["y"], oSlot[i]["z"], false, false)

            oSlot[i]["price"] = vehicles[i].price
            oSlot[i]["owner"] = vehicles[i].seller
            oSlot[i]["model"] = vehicles[i].model
            oSlot[i]["plate"] = vehicles[i].plate
            oSlot[i]["oid"]   = vehicles[i].occasionId
            oSlot[i]["desc"]  = vehicles[i].description
            oSlot[i]["mods"]  = vehicles[i].mods

            scCore.Functions.SetVehicleProperties(oSlot[i]["occasionId"], json.decode(oSlot[i]["mods"]))

            SetModelAsNoLongerNeeded(model)
            SetVehicleOnGroundProperly(oSlot[i]["occasionId"])
            SetEntityInvincible(oSlot[i]["occasionId"],true)
            SetEntityHeading(oSlot[i]["occasionId"], oSlot[i]["h"])
            SetVehicleDoorsLocked(oSlot[i]["occasionId"], 2)

            SetVehicleNumberPlateText(oSlot[i]["occasionId"], vehicles[i].plate)
            FreezeEntityPosition(oSlot[i]["occasionId"],true)
        end
    end
end

function despawnOccasionsVehicles()
    local oSlot = Config.OccasionSlots
    for i = 1, #Config.OccasionSlots, 1 do
        local oldVehicle = GetClosestVehicle(Config.OccasionSlots[i]["x"], Config.OccasionSlots[i]["y"], Config.OccasionSlots[i]["z"], 1.3, 0, 70)
        if oldVehicle ~= 0 then
            scCore.Functions.DeleteVehicle(oldVehicle)
        end
    end
end

function openSellContract(bool, maxPrice)
    SetNuiFocus(bool, bool)
    local plate = GetVehicleNumberPlateText(GetVehiclePedIsUsing(PlayerPedId()))
    plate = string.gsub(plate, '%s+', '')
    SendNUIMessage({
        action = "sellVehicle",
        pData = scCore.Functions.GetPlayerData(),
        plate = plate,
        maxPrice = maxPrice
    })
end

function openBuyContract(sellerData, vehicleData)
    if contract then
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "buyVehicle",
            sellerData = sellerData,
            vehicleData = vehicleData
        })
    end
end

RegisterNUICallback('close', function()
    contract = false
    SetNuiFocus(false, false)
end)

RegisterNUICallback('error', function(data)
    scCore.Notification(data.message, 'error')
    contract = false
end)

RegisterNUICallback('buyVehicle', function()
    local vehData = Config.OccasionSlots[currentVehicle]
    TriggerServerEvent('lcrp-usedcars:server:buyVehicle', vehData)
    contract = false
end)

DoScreenFadeIn(250)

RegisterNetEvent('lcrp-usedcars:client:BuyFinished')
AddEventHandler('lcrp-usedcars:client:BuyFinished', function(model, plate, mods)
    local vehmods = json.decode(mods)

    DoScreenFadeOut(250)
    Citizen.Wait(500)
    scCore.Functions.SpawnVehicle(model, function(veh)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, Config.BuyVehicle.h)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        exports['LegacyFuel']:SetFuel(veh, 100)
        scCore.Notification("Vehicle purchased", "primary", 2500)
        TriggerEvent("vehiclekeys:client:SetOwner", plate)
        SetVehicleEngineOn(veh, true, true)
        Citizen.Wait(500)
        scCore.Functions.SetVehicleProperties(veh, vehmods)

    end, Config.BuyVehicle, true)
    Citizen.Wait(500)
    DoScreenFadeIn(250)
    currentVehicle = nil
end)

RegisterNetEvent('lcrp-usedcars:client:ReturnOwnedVehicle')
AddEventHandler('lcrp-usedcars:client:ReturnOwnedVehicle', function(vehdata)
    local vehmods = json.decode(vehdata.mods)
    DoScreenFadeOut(250)
    Citizen.Wait(500)
    scCore.Functions.SpawnVehicle(vehdata.model, function(veh)
        SetVehicleNumberPlateText(veh, vehdata.plate)
        SetEntityHeading(veh, Config.BuyVehicle.h)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        exports['LegacyFuel']:SetFuel(veh, 100)
        scCore.Notification("Vehicle returned")
        TriggerEvent("vehiclekeys:client:SetOwner", vehdata.plate)
        SetVehicleEngineOn(veh, true, true)
        Citizen.Wait(500)
        scCore.Functions.SetVehicleProperties(veh, vehmods)

    end, Config.BuyVehicle, true)
    Citizen.Wait(500)
    DoScreenFadeIn(250)
    currentVehicle = nil
end)

RegisterNUICallback('sellVehicle', function(data)
    local vehicleData = {}
    local PlayerData = scCore.Functions.GetPlayerData()
    vehicleData.ent = GetVehiclePedIsUsing(GetPlayerPed(-1))
    vehicleData.model = scCore.Shared.VehicleModels[GetEntityModel(vehicleData.ent)]["model"]
    vehicleData.plate = GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1)))
    vehicleData.mods = scCore.Functions.GetVehicleProperties(vehicleData.ent)
    vehicleData.desc = data.desc

    TriggerServerEvent('lcrp-usedcars:server:sellVehicle', data.price, vehicleData)
    sellVehicleWait(data.price)
end)

function sellVehicleWait(price)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    scCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
    Citizen.Wait(1500)
    DoScreenFadeIn(250)
    scCore.Notification('Your vehicle is now for sale, for $'..price.."", 'primary')
    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
end

RegisterNetEvent('lcrp-usedcars:client:refreshVehicles')
AddEventHandler('lcrp-usedcars:client:refreshVehicles', function()
    if inRange then
        scCore.TriggerServerCallback('lcrp-usedcars:server:getVehicles', function(vehicles)
            occasionVehicles = vehicles
            despawnOccasionsVehicles()
            spawnOccasionsVehicles(vehicles)
        end)
    end
end)

Citizen.CreateThread(function()
    OccasionBlip = AddBlipForCoord(Config.SellVehicle["x"], Config.SellVehicle["y"], Config.SellVehicle["z"])

    SetBlipSprite (OccasionBlip, 326)
    SetBlipDisplay(OccasionBlip, 4)
    SetBlipScale  (OccasionBlip, 0.75)
    SetBlipAsShortRange(OccasionBlip, true)
    SetBlipColour(OccasionBlip, 3)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Used Car Dealership")
    EndTextCommandSetBlipName(OccasionBlip)
end)