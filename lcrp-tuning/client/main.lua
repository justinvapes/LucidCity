scCore = nil

Citizen.CreateThread(function()
    while scCore == nil do
        TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
        Citizen.Wait(200)
    end
end)

ModdedVehicles = {}
VehicleStatus = {}
ClosestPlate = nil
isLoggedIn = true
PlayerJob = nil
myShop = nil

local onDuty = false

Citizen.CreateThread(function()
    while true do
        --if isLoggedIn then
            SetClosestPlate()
        --end
        Citizen.Wait(1000)
    end
end)

function SetClosestPlate()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil
    for id,_ in pairs(Config.Plates) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, Config.Plates[id].coords.x, Config.Plates[id].coords.y, Config.Plates[id].coords.z, true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, Config.Plates[id].coords.x, Config.Plates[id].coords.y, Config.Plates[id].coords.z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, Config.Plates[id].coords.x, Config.Plates[id].coords.y, Config.Plates[id].coords.z, true)
            current = id
        end
    end
    ClosestPlate = current
end

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    scCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        onDuty = PlayerJob.onduty
        myShop = PlayerJob.name
        if PlayerData.job.onduty and string.match(myShop,"mechanic") then
            TriggerServerEvent('lscustoms:server:UpdateCurrentMechanic', 1)
        else
            TriggerServerEvent('lscustoms:server:UpdateCurrentMechanic', 0)
        end
        if string.match(myShop, "mechanic") then
            TriggerServerEvent('lscustoms:server:getPriceMultiplier', myShop)
        end
    end)
    isLoggedIn = true
    scCore.TriggerServerCallback('lcrp-tuning:server:GetAttachedVehicle', function(plates)
        for k, v in pairs(plates) do
            Config.Plates[k].AttachedVehicle = v.AttachedVehicle
        end
    end)

    scCore.TriggerServerCallback('lcrp-tuning:server:GetDrivingDistances', function(retval)
        DrivingDistance = retval
    end)
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = false
    myShop = PlayerJob.name
    if string.match(myShop, "mechanic") then
        TriggerServerEvent('lscustoms:server:getPriceMultiplier', myShop)
    end
end)

RegisterNetEvent('scCore:Client:SetDuty')
AddEventHandler('scCore:Client:SetDuty', function(duty)
    onDuty = duty
end)

function isOwner()
    local retval = false
    local roles = scCore.Shared.Jobs[myShop].roles
    highestGrade = 0
    for k, v in pairs(roles) do
        if k > highestGrade then 
            highestGrade = k
        end
    end
    if string.match(PlayerJob.name, "mechanic") and PlayerJob.grade == highestGrade then
        retval = true
    else
        retval = false
    end

    return retval
end

function changeMultiplier()
    newMult = scCore.KeyboardInput("Input new price multiplier. (current is x"..shopPercent, "", 100)
    if tonumber(newMult) ~= nil then 
        if tonumber(newMult) > 0 and myShop ~= nil then 
            TriggerServerEvent('lscustoms:server:setPriceMultiplier', newMult, myShop)
        end
    end
    closeMenuFull()
end


function OpenMenu()
    ClearMenu()
    Menu.addButton("Options", "VehicleOptions", nil)
    Menu.addButton("Close Menu", "CloseMenu", nil) 
end

function MenuChangeMultiplier()
    MenuTitle = "Change Prices Multiplier"
    ClearMenu()
	Menu.addButton("Price multiplier - x"..shopPercent, "changeMultiplier", nil)
    Menu.addButton("Close Menu", "close", nil)
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    renderGUI = false
    ClearMenu()
end

function close()
    Menu.hidden = true
end

function VehicleList()
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(v, "SpawnListVehicle", k) 
    end
    Menu.addButton("Close Menu", "CloseMenu", nil) 
end

function CheckStatus()
    local plate = GetVehicleNumberPlateText(Config.Plates[ClosestPlate].AttachedVehicle)
    SendStatusMessage(VehicleStatus[plate])
end

RegisterNetEvent('vehiclemod:client:setVehicleStatus')
AddEventHandler('vehiclemod:client:setVehicleStatus', function(plate, status)
    VehicleStatus[plate] = status
end)

RegisterNetEvent("lcrp-tuning:client:JobStash")
AddEventHandler("lcrp-tuning:client:JobStash", function()
    if PlayerJob.name ~= nil then
        TriggerEvent("inventory:client:SetCurrentStash", PlayerJob.name)
        TriggerServerEvent("inventory:server:OpenInventory", "stash", PlayerJob.name, {
            maxweight = 4000000,
            slots = 500,
        })
    end
end)

RegisterNetEvent('vehiclemod:client:getVehicleStatus')
AddEventHandler('vehiclemod:client:getVehicleStatus', function(plate, status)
    if not (IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
        local veh = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        if veh ~= nil and veh ~= 0 then
            local vehpos = GetEntityCoords(veh)
            local pos = GetEntityCoords(GetPlayerPed(-1))
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 5.0 then
                if not IsThisModelABicycle(GetEntityModel(veh)) then
                    local plate = GetVehicleNumberPlateText(veh)
                    if VehicleStatus[plate] ~= nil then 
                        SendStatusMessage(VehicleStatus[plate])
                    else
                        scCore.Notification("No status known", "error")
                    end
                else
                    scCore.Notification("Not a valid vehicle", "error")
                end
            else
                scCore.Notification("You are not close enough to the vehicle", "error")
            end
        else
            scCore.Notification("You must be in the vehicle first", "error")
        end
    else
        scCore.Notification("You must be outside the vehicle", "error")
    end
end)

RegisterNetEvent("lcrp-tuning:client:PricesMultiplier")
AddEventHandler("lcrp-tuning:client:PricesMultiplier", function()
    if isOwner() and string.match(PlayerJob.name, "mechanic") or string.match(PlayerJob.name, "mechanic2") then
        MenuChangeMultiplier()
        Menu.hidden = not Menu.hidden
        renderGUI = true
    
        while renderGUI do
            Wait(5)
            Menu.renderGUI()
        end
    end
end)

RegisterNetEvent('vehiclemod:client:fixEverything')
AddEventHandler('vehiclemod:client:fixEverything', function()
    if (IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
        local veh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
        if not IsThisModelABicycle(GetEntityModel(veh)) and GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
            local plate = GetVehicleNumberPlateText(veh)
            TriggerServerEvent("vehiclemod:server:fixEverything", plate)
        else
            scCore.Notification("You are not a driver or on a bicycle", "error")
        end
    else
        scCore.Notification("You are not in a vehicle", "error")
    end
end)

RegisterNetEvent('vehiclemod:client:setPartLevel')
AddEventHandler('vehiclemod:client:setPartLevel', function(part, level)
    if (IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
        local veh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
        if not IsThisModelABicycle(GetEntityModel(veh)) and GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
            local plate = GetVehicleNumberPlateText(veh)
            if part == "engine" then
                SetVehicleEngineHealth(veh, level)
                TriggerServerEvent("vehiclemod:server:updatePart", plate, "engine", GetVehicleEngineHealth(veh))
            elseif part == "body" then
                SetVehicleBodyHealth(veh, level)
                TriggerServerEvent("vehiclemod:server:updatePart", plate, "body", GetVehicleBodyHealth(veh))
            else
                TriggerServerEvent("vehiclemod:server:updatePart", plate, part, level)
            end
        else
            scCore.Notification("You are not a driver or on a bicycle", "error")
        end
    else
        scCore.Notification("You are not in a vehicle", "error")
    end
end)
local openingDoor = false

RegisterNetEvent('vehiclemod:client:repairPart')
AddEventHandler('vehiclemod:client:repairPart', function(part, level, needAmount)
    -- if CanReapair() then
        if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            local veh = GetVehiclePedIsIn(GetPlayerPed(-1), true)
            if veh ~= nil and veh ~= 0 then
                local vehpos = GetEntityCoords(veh)
                local pos = GetEntityCoords(GetPlayerPed(-1))
                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 5.0 then
                    if not IsThisModelABicycle(GetEntityModel(veh)) then
                        local plate = GetVehicleNumberPlateText(veh)
                        if VehicleStatus[plate] ~= nil and VehicleStatus[plate][part] ~= nil then
                            local lockpickTime = (1000 * level)
                            if part == "body" then
                                lockpickTime = lockpickTime / 10
                            end
                            ScrapAnim(lockpickTime)
                            scCore.TaskBar("repair_advanced", "Repairing", lockpickTime, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                animDict = "mp_car_bomb",
                                anim = "car_bomb_mechanic",
                                flags = 16,
                            }, {}, {}, function() -- Done
                                openingDoor = false
                                ClearPedTasks(GetPlayerPed(-1))
                                if part == "body" then
                                    SetVehicleBodyHealth(veh, GetVehicleBodyHealth(veh) + level)
                                    SetVehicleFixed(veh)
                                    TriggerServerEvent("vehiclemod:server:updatePart", plate, part, GetVehicleBodyHealth(veh))
                                    TriggerServerEvent("scCore:Server:RemoveItem", Config.RepairCost[part], needAmount)
                                    TriggerEvent("inventory:client:ItemBox", scCore.Shared.Items[Config.RepairCost[part]], "remove")
                                elseif part ~= "engine" then
                                    TriggerServerEvent("vehiclemod:server:updatePart", plate, part, GetVehicleStatus(plate, part) + level)
                                    TriggerServerEvent("scCore:Server:RemoveItem", Config.RepairCost[part], level)
                                    TriggerEvent("inventory:client:ItemBox", scCore.Shared.Items[Config.RepairCost[part]], "remove")
                                end
                            end, function() -- Cancel
                                openingDoor = false
                                ClearPedTasks(GetPlayerPed(-1))
                                scCore.Notification("Canceled", "error")
                            end)
                        else
                            scCore.Notification("Not a valid part", "error")
                        end
                    else
                        scCore.Notification("Not a valid vehicle", "error")
                    end
                else
                    scCore.Notification("You are not close enough to the vehicle..", "error")
                end
            else
                scCore.Notification("You must be in the vehicle first", "error")
            end
        else
            scCore.Notification("You are not in a vehicle", "error")
        end
    -- end
end)

function ScrapAnim(time)
    local time = time / 1000
    loadAnimDict("mp_car_bomb")
    TaskPlayAnim(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(2000)
            time = time - 2
            if time <= 0 then
                openingDoor = false
                StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
            end
        end
    end)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function GetVehicleStatusList(plate)
    local retval = nil
    if VehicleStatus[plate] ~= nil then 
        retval = VehicleStatus[plate]
    end
    return retval
end

function GetVehicleStatus(plate, part)
    local retval = nil
    if VehicleStatus[plate] ~= nil then 
        retval = VehicleStatus[plate][part]
    end
    return retval
end

function SetVehicleStatus(plate, part, level)
    TriggerServerEvent("vehiclemod:server:updatePart", plate, part, level)
end

function SendStatusMessage(statusList)
    if statusList ~= nil then 
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message normal"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>'.. Config.ValuesLabels["engine"] ..' (engine):</strong> {1} <br><strong>'.. Config.ValuesLabels["body"] ..' (body):</strong> {2} <br><strong>'.. Config.ValuesLabels["radiator"] ..' (radiator):</strong> {3} <br><strong>'.. Config.ValuesLabels["axle"] ..' (axle):</strong> {4}<br><strong>'.. Config.ValuesLabels["brakes"] ..' (brakes):</strong> {5}<br><strong>'.. Config.ValuesLabels["clutch"] ..' (clutch):</strong> {6}<br><strong>'.. Config.ValuesLabels["fuel"] ..' (fuel):</strong> {7}</div></div>',
            args = {'Vehicle Status', round(statusList["engine"]) .. "/" .. Config.MaxStatusValues["engine"] .. " ("..scCore.Shared.Items["advancedrepairkit"]["label"]..")", round(statusList["body"]) .. "/" .. Config.MaxStatusValues["body"] .. " ("..scCore.Shared.Items[Config.RepairCost["body"]]["label"]..")", round(statusList["radiator"]) .. "/" .. Config.MaxStatusValues["radiator"] .. ".0 ("..scCore.Shared.Items[Config.RepairCost["radiator"]]["label"]..")", round(statusList["axle"]) .. "/" .. Config.MaxStatusValues["axle"] .. ".0 ("..scCore.Shared.Items[Config.RepairCost["axle"]]["label"]..")", round(statusList["brakes"]) .. "/" .. Config.MaxStatusValues["brakes"] .. ".0 ("..scCore.Shared.Items[Config.RepairCost["brakes"]]["label"]..")", round(statusList["clutch"]) .. "/" .. Config.MaxStatusValues["clutch"] .. ".0 ("..scCore.Shared.Items[Config.RepairCost["clutch"]]["label"]..")", round(statusList["fuel"]) .. "/" .. Config.MaxStatusValues["fuel"] .. ".0 ("..scCore.Shared.Items[Config.RepairCost["fuel"]]["label"]..")"}
        })
    end
end

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 1) .. "f", num))
end

-- Menu Functions

CloseMenu = function()
    --UnattachVehicle()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

ClearMenu = function()
	--Menu = {}
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

function noSpace(str)
    local normalisedString = string.gsub(str, "%s+", "")
    return normalisedString
end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddBoxZone("bennysMod", vector3(-211.82, -1324.16, 30.88), 10.0, 8.2, {
        name="bennysMod",
		heading=0,
		minZ=29.88,
		maxZ=36.28 }, {
        options = {
            {
                event = "lcrp-tuning:client:OpenLSCustoms",
                icon = "far fa-tools",
                label = "Mod Vehicle",
                duty = true,   
				onlyInVeh = true,
            },
        },
    job = {"mechanic"}, distance = 8.5 })

    exports["lcrp-interact"]:AddBoxZone("bennysMod2", vector3(-198.78, -1324.46, 30.98), 5.8, 7.6, {
        name="bennysMod2",
        heading=359,
        minZ=29.98,
        maxZ=33.78 }, {
        options = {
            {
                event = "lcrp-tuning:client:OpenLSCustoms",
                icon = "far fa-tools",
                label = "Mod Vehicle",
                duty = true,   
				onlyInVeh = true,
            },
        },
    job = {"mechanic"}, distance = 8.5 })

    exports["lcrp-interact"]:AddBoxZone("bennysMod3", vector3(-223.46, -1326.36, 30.89), 11.0, 8, {
        name="bennysMod3",
		heading=0,
		minZ=29.88,
		maxZ=36.28 }, {
        options = {
            {
                event = "lcrp-tuning:client:OpenLSCustoms",
                icon = "far fa-tools",
                label = "Mod Vehicle",
                duty = true,   
				onlyInVeh = true,
            },
        },
    job = {"mechanic"}, distance = 8.5 })

    exports["lcrp-interact"]:AddBoxZone("mechanicDuty", vector3(-203.9, -1330.48, 34.89), 2.8, 2, {
        name="mechanicDuty",
        heading=0,
        minZ=33.89,
        maxZ=37.09 }, {
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
            {
                event = "lcrp-tuning:client:JobStash",
                icon = "far fa-clipboard",
                label = "Mechanic\'s Stash",
                duty = true,
                parameters = "duty",
            },
        },
    job = {"mechanic"}, distance = 2.5 })

    exports["lcrp-interact"]:AddBoxZone("mechanicBoss", vector3(-205.03, -1342.03, 30.89), 0.6, 3.2, {
        name="mechanicBoss",
        heading=0,
        minZ=30.64,
        maxZ=31.24,
     }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-car-alt",
                label = "Boss Actions",
                duty = true,
            },
            {
                event = "lcrp-tuning:client:PricesMultiplier",
                icon = "fas fa-car-alt",
                label = "Prices Multiplier",
                duty = true,
            },
        },
    job = {"mechanic"}, distance = 2.0 })

    -- Lucid motors

    exports["lcrp-interact"]:AddBoxZone("mechanic2Boss", vector3(-330.37, -120.11, 39.01), 0.8, 3.2, {
        name="mechanic2Boss",
        heading=340,
        minZ=38.71,
        maxZ=39.51,
     }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-car-alt",
                label = "Boss Actions",
                duty = true,
            },
            {
                event = "lcrp-tuning:client:PricesMultiplier",
                icon = "fas fa-car-alt",
                label = "Prices Multiplier",
                duty = true,
            },
        },
    job = {"mechanic2"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("mechanicDuty2", vector3(-333.73, -118.11, 39.01), 2.8, 0.6, {
        name="mechanicDuty2",
        heading=342,
        minZ=38.01,
        maxZ=40.01,
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
    job = {"mechanic2"}, distance = 2.5 })

    exports["lcrp-interact"]:AddBoxZone("bennysMod5", vector3(-328.22, -140.18, 39.02), 4.0, 9.2, {
        name="bennysMod5",
        heading=340,
        minZ=38.02,
        maxZ=41.82 }, {
        options = {
            {
                event = "lcrp-tuning:client:OpenLSCustoms",
                icon = "far fa-tools",
                label = "Mod Vehicle",
                duty = true,   
				onlyInVeh = true,
            },
        },
    job = {"mechanic2"}, distance = 8.5 })

    exports["lcrp-interact"]:AddBoxZone("bennysMod6", vector3(-329.88, -144.03, 39.01), 8, 3, {
        name="bennysMod6",
        heading=250,
        minZ=38.02,
        maxZ=41.82 }, {
        options = {
            {
                event = "lcrp-tuning:client:OpenLSCustoms",
                icon = "far fa-tools",
                label = "Mod Vehicle",
                duty = true,   
				onlyInVeh = true,
            },
        },
    job = {"mechanic2"}, distance = 8.5 })

    exports["lcrp-interact"]:AddBoxZone("bennysMod7", vector3(-339.91, -132.16, 39.01), 9.6, 10.4, {
        name="bennysMod7",
        heading=339,
        minZ=38.01,
        maxZ=43.61 }, {
        options = {
            {
                event = "lcrp-tuning:client:OpenLSCustoms",
                icon = "far fa-tools",
                label = "Mod Vehicle",
                duty = true,   
				onlyInVeh = true,
            },
        },
    job = {"mechanic2"}, distance = 8.5 })
end)