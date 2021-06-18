scCore = nil

inInventory = false
hotbarOpen = false

local inventoryTest = {}
local currentWeapon = nil
local currentWeaponKey = nil
local CurrentWeaponData = {}
local currentOtherInventory = nil
local isInputOpened = false

local Drops = {}
local CurrentDrop = 0
local DropsNear = {}

local CurrentVehicle = nil
local CurrentGlovebox = nil
local CurrentStash = nil
local isCrafting = false

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    scCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        onDuty = PlayerJob.onduty
        PlayerGrade = PlayerData.job.grade
    end)
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = JobInfo.onduty
    PlayerGrade = JobInfo.grade
end)

RegisterNetEvent('inventory:client:CheckOpenState')
AddEventHandler('inventory:client:CheckOpenState', function(type, id, label)
    local name = scCore.Shared.SplitStr(label, "-")[2]
    if type == "stash" then
        if name ~= CurrentStash or CurrentStash == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "trunk" then
        if name ~= CurrentVehicle or CurrentVehicle == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "glovebox" then
        if name ~= CurrentGlovebox or CurrentGlovebox == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    end
end)

RegisterNetEvent('weapons:client:SetCurrentWeapon')
AddEventHandler('weapons:client:SetCurrentWeapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
end)



function HasPickableItem(items)
    for i=1, #items,1 do -- Checks if player has Pickable item
            if items[i] ~= nil then
                if Config.PickableItems[items[i]["name"]] then --will need change
                    return true,items[i]["name"]
                end
            end
    end
    return false,nil
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        DisableControlAction(0, Keys["TAB"], true)
        DisableControlAction(0, Keys["1"], true)
        DisableControlAction(0, Keys["2"], true)
        DisableControlAction(0, Keys["3"], true)
        DisableControlAction(0, Keys["4"], true)
        DisableControlAction(0, Keys["5"], true)
        if IsDisabledControlJustPressed(0, Keys["TAB"]) and not isCrafting then
            scCore.Functions.GetPlayerData(function(PlayerData)
                if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                    local curVeh = nil
                    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        CurrentGlovebox = GetVehicleNumberPlateText(vehicle)
                        curVeh = vehicle
                        CurrentVehicle = nil
                    else
                        local vehicle = scCore.Functions.GetClosestVehicle()
                        if vehicle ~= 0 and vehicle ~= nil then
                            local pos = GetEntityCoords(GetPlayerPed(-1))
                            local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            end
                            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, trunkpos) < 2.0) and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                                if GetVehicleDoorLockStatus(vehicle) < 2 then
                                    CurrentVehicle = GetVehicleNumberPlateText(vehicle)
                                    curVeh = vehicle
                                    CurrentGlovebox = nil
                                else
                                    scCore.Notification("Vehicle is locked", "error")
                                    return
                                end
                            else
                                CurrentVehicle = nil
                            end
                        else
                            CurrentVehicle = nil
                        end
                    end

                    if CurrentVehicle ~= nil then
                        local maxweight = 0
                        local slots = 0
                        if GetVehicleClass(curVeh) == 0 then
                            maxweight = 38000
                            slots = 30
                        elseif GetVehicleClass(curVeh) == 1 then
                            maxweight = 50000
                            slots = 40
                        elseif GetVehicleClass(curVeh) == 2 then
                            maxweight = 75000
                            slots = 50
                        elseif GetVehicleClass(curVeh) == 3 then
                            maxweight = 42000
                            slots = 35
                        elseif GetVehicleClass(curVeh) == 4 then
                            maxweight = 38000
                            slots = 30
                        elseif GetVehicleClass(curVeh) == 5 then
                            maxweight = 30000
                            slots = 25
                        elseif GetVehicleClass(curVeh) == 6 then
                            maxweight = 30000
                            slots = 25
                        elseif GetVehicleClass(curVeh) == 7 then
                            maxweight = 30000
                            slots = 25
                        elseif GetVehicleClass(curVeh) == 8 then
                            maxweight = 15000
                            slots = 15
                        elseif GetVehicleClass(curVeh) == 9 then
                            maxweight = 60000
                            slots = 35
                        elseif GetVehicleClass(curVeh) == 12 then
                            maxweight = 120000
                            slots = 35
                        else
                            maxweight = 60000
                            slots = 35
                        end
                        local other = {
                            maxweight = maxweight,
                            slots = slots,
                        }
                        TriggerServerEvent("inventory:server:OpenInventory", "trunk", CurrentVehicle, other)
                        OpenTrunk()
                    elseif CurrentGlovebox ~= nil then
                        TriggerServerEvent("inventory:server:OpenInventory", "glovebox", CurrentGlovebox)
                    elseif CurrentDrop ~= 0 then
                        --print("LOG: dropping logging: ".. CurrentDrop)
                        --TriggerServerEvent("inventory:server:OpenInventory", "drop", CurrentDrop)
                    else
                        TriggerServerEvent("inventory:server:OpenInventory")
                    end
                end
            end)
        end

        if IsControlJustPressed(0, Keys["CAPS"]) then
            ToggleHotbar(true)
        end

        if IsControlJustReleased(0, Keys["CAPS"]) then
            ToggleHotbar(false)
        end
        local canUseItem = true
        
        if IsDisabledControlJustReleased(0, Keys["1"]) then
            isInputOpened = exports["lcrp-core"]:isPlayer("isinputopened")
            scCore.Functions.GetPlayerData(function(PlayerData)
                local hasPickableItem = HasPickableItem(PlayerData.items)
                if not hasPickableItem then
                    if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] and not isInputOpened then
                        TriggerServerEvent("inventory:server:UseItemSlot", 1)
                    end
                end
            end)
        end

        if IsDisabledControlJustReleased(0, Keys["2"]) then
            isInputOpened = exports["lcrp-core"]:isPlayer("isinputopened")
            scCore.Functions.GetPlayerData(function(PlayerData)
                local hasPickableItem = HasPickableItem(PlayerData.items)
                if not hasPickableItem then
                    if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] and not isInputOpened then
                        TriggerServerEvent("inventory:server:UseItemSlot", 2)
                    end
                end
            end)
        end

        if IsDisabledControlJustReleased(0, Keys["3"]) then
            isInputOpened = exports["lcrp-core"]:isPlayer("isinputopened")
            scCore.Functions.GetPlayerData(function(PlayerData)
                local hasPickableItem = HasPickableItem(PlayerData.items)
                if not hasPickableItem then
                    if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] and not isInputOpened then
                        TriggerServerEvent("inventory:server:UseItemSlot", 3)
                    end
                end
            end)
        end

        if IsDisabledControlJustReleased(0, Keys["4"]) then
            isInputOpened = exports["lcrp-core"]:isPlayer("isinputopened")
            scCore.Functions.GetPlayerData(function(PlayerData)
                local hasPickableItem = HasPickableItem(PlayerData.items)
                if not hasPickableItem then
                    if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] and not isInputOpened then
                        TriggerServerEvent("inventory:server:UseItemSlot", 4)
                    end
                end
            end)
        end

        if IsDisabledControlJustReleased(0, Keys["5"]) then
            isInputOpened = exports["lcrp-core"]:isPlayer("isinputopened")
            scCore.Functions.GetPlayerData(function(PlayerData)
                local hasPickableItem = HasPickableItem(PlayerData.items)
                if not hasPickableItem then
                    if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] and not isInputOpened then
                        TriggerServerEvent("inventory:server:UseItemSlot", 5)
                    end
                end
            end)
        end

        --[[if IsDisabledControlJustReleased(0, Keys["6"]) then
            scCore.Functions.GetPlayerData(function(PlayerData)
                if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] then
                    TriggerServerEvent("inventory:server:UseItemSlot", 41)
                end
            end)
        end--]]
    end
end)

RegisterNetEvent('inventory:client:ItemBox')
AddEventHandler('inventory:client:ItemBox', function(itemData, type)
    SendNUIMessage({
        action = "itemBox",
        item = itemData,
        type = type
    })
end)

RegisterNetEvent('inventory:client:requiredItems')
AddEventHandler('inventory:client:requiredItems', function(items, bool)
    local itemTable = {}
    if bool then
        for k, v in pairs(items) do
            table.insert(itemTable, {
                item = items[k].name,
                label = scCore.Shared.Items[items[k].name]["label"],
                image = items[k].image,
            })
        end
    end
    
    SendNUIMessage({
        action = "requiredItem",
        items = itemTable,
        toggle = bool
    })
end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(1)
--         if DropsNear ~= nil then
--             for k, v in pairs(DropsNear) do
--                 if DropsNear[k] ~= nil then
--                     DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 200, 200, 200, 155, false, false, false, 1, false, false, false)
--                 end
--             end
--         end
--     end
-- end)

-- Citizen.CreateThread(function()
--     while true do
--         if Drops ~= nil and next(Drops) ~= nil then
--             local pos = GetEntityCoords(GetPlayerPed(-1), true)
--             for k, v in pairs(Drops) do
--                 if Drops[k] ~= nil then 
--                     if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 5.0 then
--                         DropsNear[k] = v
--                         if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 2.0 then
--                             CurrentDrop = k
--                         else
--                             CurrentDrop = nil
--                         end
--                     else
--                         DropsNear[k] = nil
--                     end
--                 end
--             end
--         else
--             DropsNear = {}
--         end
--         Citizen.Wait(500)
--     end
-- end)

RegisterNetEvent('inventory:server:RobPlayer')
AddEventHandler('inventory:server:RobPlayer', function(TargetId)
    SendNUIMessage({
        action = "RobMoney",
        TargetId = TargetId,
    })
end)

RegisterNUICallback('RobMoney', function(data, cb)
    TriggerServerEvent("police:server:RobPlayer", data.TargetId)
end)

RegisterNUICallback('Notify', function(data, cb)
    scCore.Notification(data.message, data.type)
end)

RegisterNetEvent("inventory:client:OpenInventory")
AddEventHandler("inventory:client:OpenInventory", function(PlayerAmmo, inventory, strength, other)
    local playerId = GetPlayerServerId(PlayerId())

    statusCheckPed = GetPlayerPed(player)
    scCore.TriggerServerCallback('hospital:GetPlayerStatus', function(result)
        if not IsEntityDead(GetPlayerPed(-1)) then
            ToggleHotbar(false)
            SetNuiFocus(true, true)
            if other ~= nil then
                currentOtherInventory = other.name
            end
            SendNUIMessage({
                injuries = result,
                action = "open",
                health = GetEntityHealth(GetPlayerPed(-1)),
                inventory = inventory,
                slots = MaxInventorySlots,
                other = other,
                jobgrade = PlayerGrade,
                maxweight = scCore.Config.Player.MaxWeight + (scCore.Config.Player.StrengthScale * strength * 1000),
                Ammo = PlayerAmmo,
                maxammo = Config.MaximumAmmoValues,
            })
            inInventory = true
        end
    end, playerId)
end)

RegisterNetEvent("inventory:client:OpenTrunk")
AddEventHandler("inventory:client:OpenTrunk", function()
    local playerPed = GetPlayerPed(-1)

    if IsPedSittingInAnyVehicle(playerPed) then 
        local veh = GetVehiclePedIsUsing(playerPed)
        local isTrunkOpen = GetVehicleDoorAngleRatio(veh, 5)

        if isTrunkOpen == 0 then
            SetVehicleDoorOpen(veh, 5, 0, 0)
        else
            SetVehicleDoorShut(veh, 5, 0)
        end
    else
        local veh = scCore.Functions.GetClosestVehicle()
        local isTrunkOpen = GetVehicleDoorAngleRatio(veh, 5)
        local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(playerPed), GetEntityCoords(veh), 1)
        
        if GetVehicleDoorLockStatus(veh) < 2 then
            if distanceToVeh <= 4.0 then
                if (IsBackEngine(GetEntityModel(vehicle))) then
                    if isTrunkOpen == 0 then
                        SetVehicleDoorOpen(veh, 4, 0, 0)
                    else
                        SetVehicleDoorShut(veh, 4, 0)
                    end
                else
                    if isTrunkOpen == 0 then
                        SetVehicleDoorOpen(veh, 5, 0, 0)
                    else
                        SetVehicleDoorShut(veh, 5, 0)
                    end
                end
            else
                scCore.Notification("No vehicle close by!", "error")
            end
        else
            scCore.Notification("Vehicle is locked!", "error")
        end
    end
end)

RegisterNetEvent("inventory:client:UpdatePlayerInventory")
AddEventHandler("inventory:client:UpdatePlayerInventory", function(isError, strength)
    SendNUIMessage({
        action = "update",
        inventory = scCore.Functions.GetPlayerData().items,
        maxweight = scCore.Config.Player.MaxWeight + (scCore.Config.Player.StrengthScale * strength * 1000),
        slots = MaxInventorySlots,
        error = isError,
    })
end)

RegisterNetEvent("inventory:client:CraftItems")
AddEventHandler("inventory:client:CraftItems", function(itemName, itemCosts, amount, toSlot, points)
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
    scCore.TaskBar("repair_vehicle", "Crafting", (math.random(2000, 5000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("inventory:server:CraftItems", itemName, itemCosts, amount, toSlot, points)
        TriggerEvent('inventory:client:ItemBox', scCore.Shared.Items[itemName], 'add')
        isCrafting = false
	end, function() -- Cancel
		StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
        scCore.Notification("Canceled!", "error")
        isCrafting = false
	end)
end)

RegisterNetEvent('inventory:client:CraftAttachment')
AddEventHandler('inventory:client:CraftAttachment', function(itemName, itemCosts, amount, toSlot, points)
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
    scCore.TaskBar("repair_vehicle", "Crafting..", (math.random(2000, 5000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
        TriggerServerEvent("inventory:server:CraftAttachment", itemName, itemCosts, amount, toSlot, points)
        TriggerEvent('inventory:client:ItemBox', scCore.Shared.Items[itemName], 'add')
        isCrafting = false
	end, function() -- Cancel
		StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 1.0)
        scCore.Notification("Canceled!", "error")
        isCrafting = false
	end)
end)

RegisterNetEvent("inventory:client:PickupSnowballs")
AddEventHandler("inventory:client:PickupSnowballs", function()
    LoadAnimDict('anim@mp_snowball')
    TaskPlayAnim(GetPlayerPed(-1), 'anim@mp_snowball', 'pickup_snowball', 3.0, 3.0, -1, 0, 1, 0, 0, 0)
    scCore.TaskBar("pickupsnowball", "Snowballin..", 1500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(GetPlayerPed(-1))
        TriggerEvent('inventory:client:ItemBox', scCore.Shared.Items["snowball"], "add")
    end, function() -- Cancel
        ClearPedTasks(GetPlayerPed(-1))
        scCore.Notification("Canceled", "error")
    end)
end)

RegisterNetEvent("inventory:client:UseSnowball")
AddEventHandler("inventory:client:UseSnowball", function(amount)
    GiveWeaponToPed(PlayerPedId(), GetHashKey("weapon_snowball"), amount, false, false)
    SetPedAmmo(PlayerPedId(), GetHashKey("weapon_snowball"), amount)
    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_snowball"), true)
end)

CurrentWeaponData = nil
RegisterNetEvent('weapons:client:SetCurrentWeapon')
AddEventHandler('weapons:client:SetCurrentWeapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
    CanShoot = bool
end)


RegisterNetEvent("inventory:client:UseWeapon")
AddEventHandler("inventory:client:UseWeapon", function(weaponData, shootbool)
    local weaponName = tostring(weaponData.name)    
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    if currentWeapon == weaponName then
        if currentWeaponKey == weapon then
            local ammo = GetAmmoInPedWeapon(ped, weapon)
            if ammo > 0 then
                TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, tonumber(ammo))
            else
                TriggerEvent('inventory:client:CheckWeapon')
                TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, 0)
            end
            TriggerServerEvent("weapons:server:UpdateWeaponQuality", CurrentWeaponData, 1)   
        end
        SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(ped, true)
        TriggerEvent('weapons:client:SetCurrentWeapon', nil, shootbool)
        currentWeapon = nil
    elseif weaponName == "weapon_stickybomb" then
        GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponName), ammo, false, false)
        SetPedAmmo(PlayerPedId(), GetHashKey(weaponName), 1)
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weaponName), true)
        TriggerServerEvent('scCore:Server:RemoveItem', weaponName, 1)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    elseif weaponName == "weapon_snowball" then
        GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponName), ammo, false, false)
        SetPedAmmo(PlayerPedId(), GetHashKey(weaponName), 10)
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weaponName), true)
        TriggerServerEvent('scCore:Server:RemoveItem', weaponName, 1)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    else
        if CurrentWeaponData ~= nil then
            if weapon ~= -1569615261 then
                local ammo = GetAmmoInPedWeapon(ped, weapon)
                if ammo > 0 then
                    TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, tonumber(ammo))
                else
                    TriggerEvent('inventory:client:CheckWeapon')
                    TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, 0)
                end
                TriggerServerEvent("weapons:server:UpdateWeaponQuality", CurrentWeaponData, 1)   
            end
        end
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        scCore.TriggerServerCallback("weapon:server:GetWeaponAmmo", function(result)
            local ped = PlayerPedId()
            local ammo = tonumber(result)
            if weaponName == "weapon_petrolcan" or weaponName == "weapon_fireextinguisher" then 
                ammo = 4000 
            end
            GiveWeaponToPed(ped, GetHashKey(weaponName), ammo, false, false)
            SetPedAmmo(ped, GetHashKey(weaponName), ammo)
            SetCurrentPedWeapon(ped, GetHashKey(weaponName), true)
            if weaponData.info.attachments ~= nil then
                for _, attachment in pairs(weaponData.info.attachments) do
                    GiveWeaponComponentToPed(ped, GetHashKey(weaponName), GetHashKey(attachment.component))
                end
            end
            currentWeapon = weaponName
            currentWeaponKey = GetSelectedPedWeapon(ped)
        end, CurrentWeaponData)
    end
end)

WeaponAttachments = {
    ["WEAPON_SNSPISTOL"] = {
        ["extendedclip"] = {
            component = "COMPONENT_SNSPISTOL_CLIP_02",
            label = "Extended Clip",
            item = "pistol_extendedclip",
        },
    },
    ["WEAPON_VINTAGEPISTOL"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP",
            label = "Supressor",
            item = "pistol_suppressor",
        },
        ["extendedclip"] = {
            component = "COMPONENT_VINTAGEPISTOL_CLIP_02",
            label = "Extended Clip",
            item = "pistol_extendedclip",
        },
    },
    ["WEAPON_MICROSMG"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_AR_SUPP_02",
            label = "Supressor",
            item = "smg_suppressor",
        },
        ["extendedclip"] = {
            component = "COMPONENT_MICROSMG_CLIP_02",
            label = "Extended Clip",
            item = "smg_extendedclip",
        },
        ["flashlight"] = {
            component = "COMPONENT_AT_PI_FLSH",
            label = "Flashlight",
            item = "wep_flashlight",
        },
        ["scope"] = {
            component = "COMPONENT_AT_SCOPE_MACRO",
            label = "Scope",
            item = "dot_scope",
        },
    },
    ["WEAPON_MINISMG"] = {
        ["extendedclip"] = {
            component = "COMPONENT_MINISMG_CLIP_02",
            label = "Extended Clip",
            item = "smg_extendedclip",
        },
    },
    ["WEAPON_COMPACTRIFLE"] = {
        ["extendedclip"] = {
            component = "COMPONENT_COMPACTRIFLE_CLIP_02",
            label = "Extended Clip",
            item = "rifle_extendedclip",
        },
        ["drummag"] = {
            component = "COMPONENT_COMPACTRIFLE_CLIP_03",
            label = "Drum Mag",
            item = "rifle_drummag",
        },
    },
}

function FormatWeaponAttachments(itemdata)
    local attachments = {}
    itemdata.name = itemdata.name:upper()
    if itemdata.info.attachments ~= nil and next(itemdata.info.attachments) ~= nil then
        for k, v in pairs(itemdata.info.attachments) do
            if WeaponAttachments[itemdata.name] ~= nil then
                for key, value in pairs(WeaponAttachments[itemdata.name]) do
                    if value.component == v.component then
                        table.insert(attachments, {
                            attachment = key,
                            label = value.label
                        })
                    end
                end
            end
        end
    end
    return attachments
end

RegisterNUICallback('GetWeaponData', function(data, cb)
    local data = {
        WeaponData = scCore.Shared.Items[data.weapon],
        AttachmentData = FormatWeaponAttachments(data.ItemData)
    }
    cb(data)
end)

RegisterNUICallback('GetPlayerData', function(data, cb)
    local player = scCore.Functions.GetPlayerData()
    local dirtymoneyz = 0
    for k, v in pairs(player["items"]) do
        if v.name == "dirtymoney" then
            dirtymoneyz = v.amount
            break
        end
    end
    local pldata = {
        gender = player["charinfo"]["gender"],
        bank = player["money"]["bank"],
        cash = player["money"]["cash"],
        name = player["name"],
        hunger = player["metadata"]["hunger"],
        thirst = player["metadata"]["thirst"],
        dirtymoney = dirtymoneyz
    }
    cb(json.encode(pldata))
end)

RegisterNUICallback('RemoveAttachment', function(data, cb)
    local WeaponData = scCore.Shared.Items[data.WeaponData.name]
    local Attachment = WeaponAttachments[WeaponData.name:upper()][data.AttachmentData.attachment]
    
    scCore.TriggerServerCallback('weapons:server:RemoveAttachment', function(NewAttachments)
        if NewAttachments ~= false then
            local Attachies = {}
            RemoveWeaponComponentFromPed(GetPlayerPed(-1), GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            for k, v in pairs(NewAttachments) do
                for wep, pew in pairs(WeaponAttachments[WeaponData.name:upper()]) do
                    if v.component == pew.component then
                        table.insert(Attachies, {
                            attachment = pew.item,
                            label = pew.label,
                        })
                    end
                end
            end
            local DJATA = {
                Attachments = Attachies,
                WeaponData = WeaponData,
            }
            cb(DJATA)
        else
            RemoveWeaponComponentFromPed(GetPlayerPed(-1), GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            cb({})
        end
    end, data.AttachmentData, data.WeaponData)
end)

RegisterNetEvent("inventory:client:CheckWeapon")
AddEventHandler("inventory:client:CheckWeapon", function(weaponName)
    if currentWeapon == weaponName then 
        TriggerEvent('weapons:ResetHolster')
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(GetPlayerPed(-1), true)
        currentWeapon = nil
    end
end)

--[=====[ 
RegisterNetEvent("inventory:client:AddDropItem")
AddEventHandler("inventory:client:AddDropItem", function(dropId, player)
    --print("LOG: Adding dropped item")
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player)))
    local forward = GetEntityForwardVector(GetPlayerPed(GetPlayerFromServerId(player)))
	local x, y, z = table.unpack(coords + forward * 0.5)
    Drops[dropId] = {
        id = dropId,
        coords = {
            x = x,
            y = y,
            z = z - 0.3,
        },
    }
end)

RegisterNetEvent("inventory:client:RemoveDropItem")
AddEventHandler("inventory:client:RemoveDropItem", function(dropId)
    --print("LOG: Removing drop item")
    Drops[dropId] = nil
end)

RegisterNetEvent("inventory:client:DropItemAnim")
AddEventHandler("inventory:client:DropItemAnim", function()
    --print("LOG: Playing drop item animation")
    SendNUIMessage({
        action = "close",
    })
    RequestAnimDict("pickup_object")
    while not HasAnimDictLoaded("pickup_object") do
        Citizen.Wait(7)
    end
    TaskPlayAnim(GetPlayerPed(-1), "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
    Citizen.Wait(2000)
    ClearPedTasks(GetPlayerPed(-1))
end)
--]=====]
local isDisplay = false
RegisterNUICallback('hideMugshot', function(data, cb)
    isDisplay = false
    cb("ok")
end)

local isLicense = false
RegisterNUICallback('hideLicense', function(data, cb)
    isLicense = false
    cb("ok")
end)

RegisterNetEvent("inventory:client:ShowBadge")
AddEventHandler("inventory:client:ShowBadge", function(sourceId, character)
    -- local playerIdx = GetPlayerFromServerId(sourceId)
    local ped = GetPlayerPed()
    -- local sourcePos = GetEntityCoords(ped, false)
    -- local pos = GetEntityCoords(GetPlayerPed(-1), false)
    local isPlayerInVeh = IsPedInAnyVehicle(ped, false)
    local badgeProp = "police_badge"

    if character.job == nil then 
        return scCore.Notification("Badge is invalid!", "error") 
    elseif isPlayerInVeh then
        return scCore.Notification("Exit vehicle first!", "error") 
    end

    if character.job == "FIB" then
        badgeProp = "fib_badge"
    elseif character.job == "State police" then
        badgeProp = "statepd_badge"
    end

    while not HasAnimDictLoaded('paper_1_rcm_alt1-7') do
        RequestAnimDict('paper_1_rcm_alt1-7')
        Citizen.Wait(5)
    end

    TaskPlayAnim(ped, 'paper_1_rcm_alt1-7', 'player_one_dual-7', -8.0, -8.0, -1, 63, 0.0, 0, 0, 0)
    Citizen.Wait(2000)
    TriggerEvent("attachItem", badgeProp)
    Citizen.Wait(7000)
    StopAnimTask(ped, 'paper_1_rcm_alt1-7', 'player_one_dual-7', 3.0)
    TriggerEvent("destroyProp")

    -- if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0 and GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) ~= 0) or GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) == 0 and sourceId == GetPlayerServerId(PlayerId()) then
        -- SendNUIMessage({
        --     action = "showId",
        --     callsign = badge,
        --     firstname = character.firstname,
        --     lastname = character.lastname,
        --     gender = character.gender,
        --     birthdate = character.birthdate,
        --     nationality = character.nationality,
        -- })
    -- end
end)

RegisterNetEvent("inventory:client:ShowId")
AddEventHandler("inventory:client:ShowId", function(sourceId, citizenid, character)
    local playerIdx = GetPlayerFromServerId(sourceId)
    local ped = GetPlayerPed(playerIdx)
    local sourcePos = GetEntityCoords(ped, false)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0 and GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) ~= 0) or GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) == 0 and sourceId == GetPlayerServerId(PlayerId()) then
        local gender = "Man"
        if character.gender == 1 then
            gender = "Women"
        end
        SendNUIMessage({
            action = "showId",
            ssn = character.citizenid,
            firstname = character.firstname,
            lastname = character.lastname,
            gender = character.gender,
            birthdate = character.birthdate,
            nationality = character.nationality,
        })
        ssHandle = RegisterPedheadshot(ped)
        while IsPedheadshotReady(ssHandle) == false do
            Citizen.Wait(0)
        end
        txdString = GetPedheadshotTxdString(ssHandle)
        isDisplay = true
        while isDisplay do
            DrawSprite (txdString, txdString, 0.4356, 0.86, 0.07, 0.14, 0.0, 255, 255, 255, 1000)
            Citizen.Wait(5)
        end
        UnregisterPedheadshot(ssHandle)
    end
end)

Citizen.CreateThread(function()
    while true do
        if isDisplay then
            SetTimeout(5000, function()
                isDisplay = false
            end)
        end
        Citizen.Wait(5000)
    end
end)

RegisterNetEvent("inventory:client:ShowDriverLicense")
AddEventHandler("inventory:client:ShowDriverLicense", function(sourceId, citizenid, character, licenses)
    local playerIdx = GetPlayerFromServerId(sourceId)
    local ped = GetPlayerPed(playerIdx)
    local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(sourceId)), false)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 2.0 and GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) ~= 0) or GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) == 0 and sourceId == GetPlayerServerId(PlayerId()) then
        local gender = "Man"
        if character.gender == 1 then
            gender = "Woman"
        end
        if(licenses == nil) then
            licenses = ""
        end
        SendNUIMessage({
            action = "showLicense",
            ssn = citizenid,
            firstname = character.firstname,
            lastname = character.lastname,
            gender = character.gender,
            birthdate = character.birthdate,
            code = licenses,
        })
        ssHandle = RegisterPedheadshot(ped)
        while IsPedheadshotReady(ssHandle) == false do
            Citizen.Wait(0)
        end
        txdString = GetPedheadshotTxdString(ssHandle)
        isLicense = true
        while isLicense do
            DrawSprite (txdString, txdString, 0.437, 0.875, 0.07, 0.14, 0.0, 255, 255, 255, 1000)
            Citizen.Wait(5)
        end
        UnregisterPedheadshot(ssHandle)
    end
end)

RegisterNetEvent("inventory:client:SetCurrentStash")
AddEventHandler("inventory:client:SetCurrentStash", function(stash)
    CurrentStash = stash
end)

RegisterNUICallback('getCombineItem', function(data, cb)
    cb(scCore.Shared.Items[data.item])
end)

RegisterNUICallback("CloseInventory", function(data, cb)
    if currentOtherInventory == "none-inv" then
        CurrentDrop = 0
        CurrentVehicle = nil
        CurrentGlovebox = nil
        CurrentStash = nil
        SetNuiFocus(false, false)
        inInventory = false
        ClearPedTasks(GetPlayerPed(-1))
        return
    end
    if CurrentVehicle ~= nil then
        CloseTrunk()
        TriggerServerEvent("inventory:server:SaveInventory", "trunk", CurrentVehicle)
        CurrentVehicle = nil
    elseif CurrentGlovebox ~= nil then
        TriggerServerEvent("inventory:server:SaveInventory", "glovebox", CurrentGlovebox)
        CurrentGlovebox = nil
    elseif CurrentStash ~= nil then
        TriggerServerEvent("inventory:server:SaveInventory", "stash", CurrentStash)
        CurrentStash = nil
    else
        TriggerServerEvent("inventory:server:SaveInventory", "drop", CurrentDrop)
        CurrentDrop = 0
    end
    SetNuiFocus(false, false)
    inInventory = false
end)
RegisterNUICallback("UseItem", function(data, cb)
    TriggerServerEvent("inventory:server:UseItem", data.inventory, data.item)
end)

RegisterNUICallback("GiveItem", function(data, cb)
    openGiveMenu(data)
end)

RegisterNUICallback("combineItem", function(data)
    Citizen.Wait(150)
    TriggerServerEvent('inventory:server:combineItem', data.reward, data.fromItem, data.toItem)
    TriggerEvent('inventory:client:ItemBox', scCore.Shared.Items[data.reward], 'add')
end)

function openGiveMenu(data)
    local itemName = json.encode(data.item.name)
    local itemLabel = json.encode(data.item.label)
    local playerId = scCore.KeyboardInput("Enter Player ID", "", 10)
    playerId = tonumber(playerId)
    local otherPlayerInVeh = IsPedInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(playerId)))
    local amount = scCore.KeyboardInput("Enter ".. itemLabel .. " Amount", "", 10)
    amount = tonumber(amount)
    local playerPed = GetPlayerPed(-1)
    local closestPlayerId = GetPlayerFromServerId(playerId)
    if closestPlayerId ~= -1 then
        local closestPlayerPed = GetPlayerPed(closestPlayerId)
        local closestPlayerCoords = GetEntityCoords(closestPlayerPed)
        local coords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(closestPlayerCoords.x, closestPlayerCoords.y, closestPlayerCoords.z, coords.x, coords.y, coords.z, true)
        if closestPlayerPed ~= nil then
            if distance <= 2.0 then
                if playerId and playerId > 0 then
                    if amount and amount > 0 then
                        if string.match(itemName, "weapon") then 
                            TriggerEvent('weapons:ResetHolster')
                            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
                            RemoveAllPedWeapons(GetPlayerPed(-1), true)
                        end
                        TriggerServerEvent("inventory:server:GiveItem", playerId, amount, data.item,otherPlayerInVeh)
                    elseif amount == 0 then
                        if string.match(itemName, "weapon") then 
                            local duration = 22147483647
                            local reason = "Weapon dupe exploit - NON APPEALABLE"
                            local src = GetPlayerServerId(PlayerId())
                            scCore.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`, `bannedby`) VALUES ('"..GetPlayerName(src).."', '"..GetPlayerIdentifiers(src)[1].."', '"..GetPlayerIdentifiers(src)[2].."', '"..GetPlayerIdentifiers(src)[3].."', '"..GetPlayerIdentifiers(src)[4].."', '"..reason.."', '"..duration.."', '"..GetPlayerName(src).."')")
                            DropPlayer(src, reason)  
                        end
                    else
                        scCore.Notification('Invalid amount', 'error')
                    end
                else
                    scCore.Notification('Player ID is Invalid!', 'error')
                end
            else
                scCore.Notification("Player is too far away!", "error")
            end
        else
            scCore.Notification("Player doesn\'t exist!", "error")
        end
    else
        scCore.Notification("Player is too far away!", "error")
    end
end

RegisterNetEvent("lcrp-inventory:client:PlayGiveAnimation")
AddEventHandler("lcrp-inventory:client:PlayGiveAnimation", function()
    local InVehicle = IsPedInAnyVehicle(GetPlayerPed(-1))
    local giveDict = "pickup_object"
    local giveAnim = "putdown_low"

    if not InVehicle then
        RequestAnimDict(giveDict)
        while not HasAnimDictLoaded(giveDict) do
            Citizen.Wait(0)
        end
        TaskPlayAnim(playerPed, giveDict, giveAnim, 8.0, 8.0, -1, 48, 1, false, false, false)
    
        Citizen.Wait(1000)
        ClearPedTasksImmediately(playerPed)
    end
end)

RegisterNUICallback('combineWithAnim', function(data)
    local combineData = data.combineData
    local aDict = combineData.anim.dict
    local aLib = combineData.anim.lib
    local animText = combineData.anim.text
    local animTimeout = combineData.anim.timeOut

    scCore.TaskBar("combine_anim", animText, animTimeout, false, true, {
        disableMovement = false,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = aDict,
        anim = aLib,
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), aDict, aLib, 1.0)
        TriggerServerEvent('inventory:server:combineItem', combineData.reward, data.requiredItem, data.usedItem)
        TriggerEvent('inventory:client:ItemBox', scCore.Shared.Items[combineData.reward], 'add')
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), aDict, aLib, 1.0)
        scCore.Notification("Canceled!", "error")
    end)
end)

RegisterNUICallback("SetInventoryData", function(data, cb)
    TriggerServerEvent("inventory:server:SetInventoryData", data.fromInventory, data.toInventory, data.fromSlot, data.toSlot, data.fromAmount, data.toAmount)
end)

RegisterNUICallback("PlayDropSound", function(data, cb)
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback("PlayDropFail", function(data, cb)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

function OpenTrunk()
    TriggerEvent('animations:client:EmoteCommandStop') -- Disables HoldObjAnim
    local vehicle = scCore.Functions.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "idle_d", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorOpen(vehicle, 4, false, false)
    else
        SetVehicleDoorOpen(vehicle, 5, false, false)
    end
end

function CloseTrunk()
    local vehicle = scCore.Functions.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "exit", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorShut(vehicle, 4, false)
    else
        SetVehicleDoorShut(vehicle, 5, false)
    end
    
    scCore.Functions.GetPlayerData(function(PlayerData)
        local hasPickableItem,item = HasPickableItem(PlayerData.items)
        if hasPickableItem then
            TriggerEvent('lcrp-robberies:client:HoldObjAnim', item)
        end
    end)
end

function IsBackEngine(vehModel)
    for _, model in pairs(BackEngineVehicles) do
        if GetHashKey(model) == vehModel then
            return true
        end
    end
    return false
end

function ToggleHotbar(toggle)
    local HotbarItems = {
        [1] = scCore.Functions.GetPlayerData().items[1],
        [2] = scCore.Functions.GetPlayerData().items[2],
        [3] = scCore.Functions.GetPlayerData().items[3],
        [4] = scCore.Functions.GetPlayerData().items[4],
        [5] = scCore.Functions.GetPlayerData().items[5],
    } 

    if toggle then
        SendNUIMessage({
            action = "toggleHotbar",
            open = true,
            items = HotbarItems
        })
    else
        SendNUIMessage({
            action = "toggleHotbar",
            open = false,
        })
    end
end

function LoadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end