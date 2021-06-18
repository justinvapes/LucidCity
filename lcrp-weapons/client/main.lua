-- big spaghetti code for ammo functions.
-- blame max
-- yes I dont know how to do maths properly




local isLoggedIn = true
local CurrentWeaponData = {}
local PlayerData = {}
local CanShoot = true
local hasStock = false
local assembledWeapon = nil
local storeStock = {}

scCore = nil
Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)   
        Citizen.Wait(200)
    end
end)

Citizen.CreateThread(function()
    Wait(1000)
    for store,_ in pairs(Config.Locations) do
        StoreBlip = AddBlipForCoord(Config.Locations[store]["weapon"].x, Config.Locations[store]["weapon"].y, Config.Locations[store]["weapon"].z)
        SetBlipColour(StoreBlip, 0)
        SetBlipSprite(StoreBlip, 110)
        SetBlipScale(StoreBlip, 0.85)
        SetBlipAsShortRange(StoreBlip, true)
    end
end)

local MultiplierAmount = 0

Citizen.CreateThread(function()
    while true do
        if isLoggedIn then
            if CurrentWeaponData ~= nil and next(CurrentWeaponData) ~= nil then
                if IsPedShooting(GetPlayerPed(-1)) or IsControlJustPressed(0, 24) then
                    if CanShoot then
                        local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
                        local ammo = GetAmmoInPedWeapon(GetPlayerPed(-1), weapon)
                        if scCore.Shared.Weapons[weapon]["name"] == "weapon_snowball" then
                            TriggerServerEvent('scCore:Server:RemoveItem', "snowball", 1)
                        end
                    else
                        scCore.Notification("This weapon is broken and cannot be used", "error")
                        local currWeapon = GetSelectedPedWeapon(PlayerPedId())

                        --TriggerEvent('weapons:ResetHolster')
                        --SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
                        TriggerEvent('weapons:client:SetCurrentWeapon', nil)
                        RemoveAllPedWeapons(GetPlayerPed(-1), true)
                        currentWeapon = nil
                    end
                end
            end
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local player = PlayerId()
        local weapon = GetSelectedPedWeapon(ped)
        local ammo = GetAmmoInPedWeapon(ped, weapon)

        if ammo == 1 then
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            if IsPedInAnyVehicle(ped, true) then
                SetPlayerCanDoDriveBy(player, false)
            end
        else
            EnableControlAction(0, 24, true) -- Attack
			EnableControlAction(0, 257, true) -- Attack 2
            if IsPedInAnyVehicle(ped, true) then
                SetPlayerCanDoDriveBy(player, true)
            end
        end

        if IsPedShooting(ped) then
            if ammo - 1 < 1 then
                SetAmmoInClip(GetPlayerPed(-1), GetHashKey(scCore.Shared.Weapons[weapon]["name"]), 1)
            end
        end
        
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        if GetSelectedPedWeapon(GetPlayerPed(-1)) ~= -1569615261 then
            if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) then
                TriggerServerEvent("weapons:server:UpdateWeaponQuality", CurrentWeaponData, 2)   
            end
        end
        Citizen.Wait(1000)
    end
end)


RegisterNetEvent('weapon:client:AddAmmo')
AddEventHandler('weapon:client:AddAmmo', function(type, amount, itemData)
    local ped = GetPlayerPed(-1)
    local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
    if CurrentWeaponData ~= nil then
        if scCore.Shared.Weapons[weapon]["name"] ~= "weapon_unarmed" and scCore.Shared.Weapons[weapon]["ammotype"] == type:upper() then
            local total = (GetAmmoInPedWeapon(GetPlayerPed(-1), weapon))
            --local Skillbar = exports['lcrp-skillbar']:GetSkillbarObject()
            local retval = (3 * GetMaxAmmoInClip(ped, weapon, 1)) -- EVERY WEAPON CAN HAVE 3 MAGS
            retval = tonumber(retval)
            retvalMaxAmmo = GetMaxAmmoInClip(ped, weapon, 1)

            if not (total >= retval) and not (total >= 100) then
                if type == "AMMO_RIFLE" then
                    retvalAmmo = (total + 30)
                elseif type == "AMMO_SMG" then
                    retvalAmmo = (total + 30)
                elseif type == "AMMO_PISTOL" then
                    retvalAmmo = (total + 12)
                elseif type == "AMMO_SHOTGUN" then
                    retvalAmmo = (total + 10)
                else
                    retvalAmmo = (total + 10)
                end
                    scCore.TaskBar("taking_bullets", "Loading bullets", math.random(1000, 3000), false, true, {
                        disableMovement = false,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, function() -- Done
                        if scCore.Shared.Weapons[weapon] ~= nil then
                            TriggerServerEvent("weapons:server:AddWeaponAmmo", CurrentWeaponData, retvalAmmo)
                            TriggerServerEvent('scCore:Server:RemoveItem', itemData.name, 1)
                            TriggerEvent('inventory:client:ItemBox', scCore.Shared.Items[itemData.name], "remove")
                            TriggerEvent('scCore:Notification', "Bullets loaded!", "primary")
                            if (total > 100) then -- EXTRA CHECK SO IT DOESNT GO OVER 100 AMMO
                                SetAmmoInClip(ped, weapon, 100)
                                SetPedAmmo(ped, weapon, 100)
                            else
                                SetAmmoInClip(ped, weapon, retvalAmmo)
                                SetPedAmmo(ped, weapon, retvalAmmo)
                                if (total > retval) then
                                    SetAmmoInClip(ped, weapon, retval)
                                    SetPedAmmo(ped, weapon, retval)
                                end
                            end
                        end
                    end, function()
                        scCore.Notification("Canceled", "error")
                    end)
            else
                scCore.Notification("Your weapon is already loaded", "error")
            end
        else
            scCore.Notification("You don't have a weapon", "error")
        end
    else
        scCore.Notification("You don't have a weapon", "error")
    end
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("weapons:server:LoadWeaponAmmo")
    isLoggedIn = true
    PlayerData = scCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
    onDuty = PlayerJob.onduty
    grade = PlayerJob.grade
    myShop = PlayerJob.name
    if string.match(myShop, 'ammunation') then
        TriggerServerEvent('lcrp-weapon:server:getStock', myShop)
    end
    scCore.TriggerServerCallback("weapons:server:GetConfig", function(RepairPoints)
        for k, data in pairs(RepairPoints) do
            Config.WeaponRepairPoints[k].IsRepairing = data.IsRepairing
            Config.WeaponRepairPoints[k].RepairingData = data.RepairingData
        end
    end)
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
    grade = PlayerJob.grade
    myShop = PlayerJob.name
    if string.match(myShop, 'ammunation') then
        TriggerServerEvent('lcrp-weapon:server:getStock', myShop)
    end
end)

RegisterNetEvent('lcrp-weapon:client:updateStock')
AddEventHandler('lcrp-weapon:client:updateStock', function(stock)
    storeStock = stock
    options = {
        {
            event = "",
            icon = "",
            label = "Showcase weapon",
            duty = true,
        },
        {
            event = "weapons:client:showcase",
            icon = "fas fa-times",
            label = "Pistol | Amount: "..storeStock["pistol"],
            duty = true,
            parameters = 'pistol'
        },
        {
            event = "weapons:client:showcase",
            icon = "fas fa-times",
            label = "Shotgun | Amount: "..storeStock["shotgun"],
            duty = true,
            parameters = 'shotgun'
        },
        {
            event = "weapons:client:storeWeapon",
            icon = "fas fa-times",
            label = "Store weapon",
            duty = true,
        },
    }
    TriggerEvent('lcrp-interact:client:updateInteractionOptions','zone',myShop.."Showcase",options)
    --Pistol | Amount: 0"..storeStock["pistol"]
end)

RegisterNetEvent('weapons:client:SetCurrentWeapon')
AddEventHandler('weapons:client:SetCurrentWeapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
    setRepairInteraction(data)
    CanShoot = bool
end)

RegisterNetEvent('scCore:Client:OnPlayerUnload')
AddEventHandler('scCore:Client:OnPlayerUnload', function()
    isLoggedIn = false

    for k, v in pairs(Config.WeaponRepairPoints) do
        Config.WeaponRepairPoints[k].IsRepairing = false
        Config.WeaponRepairPoints[k].RepairingData = {}
    end
end)

RegisterNetEvent('weapons:client:SetWeaponQuality')
AddEventHandler('weapons:client:SetWeaponQuality', function(amount)
    if CurrentWeaponData ~= nil and next(CurrentWeaponData) ~= nil then
        TriggerServerEvent("weapons:server:SetWeaponQuality", CurrentWeaponData, amount)
    end
end)


function IsWeaponBeingShowcasedToBuy()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    for k,v in pairs(Config.Locations) do
        local weaponPos = vector3(v.weapon.x,v.weapon.y,v.weapon.z)
        if GetDistanceBetweenCoords(pos, weaponPos, true) < 1 and v.weapon.canBuy then
            return {retval = true, weapon = v.weapon.weapon, weaponPrice = v.weapon.price, shop = k, weaponPos = weaponPos} 
        end
    end
    return {retval = false}
end

RegisterNetEvent('lcrp-weapons:client:buyWeapon')
AddEventHandler('lcrp-weapons:client:buyWeapon', function(weaponData)
    storeWeapon()
    TriggerServerEvent('lcrp-weapon:server:buyWeapon', weaponData.weapon, weaponData.weaponPrice, weaponData.shop)
end)

RegisterNetEvent("weapons:client:TakeBackWeapon")
AddEventHandler("weapons:client:TakeBackWeapon", function(option)
    TriggerServerEvent('weapons:server:TakeBackWeapon', option.myShop, option.data)
end)

RegisterNetEvent("weapons:client:SyncRepairShops")
AddEventHandler("weapons:client:SyncRepairShops", function(NewData, key)
    Config.WeaponRepairPoints[key].IsRepairing = NewData.IsRepairing
    Config.WeaponRepairPoints[key].RepairingData = NewData.RepairingData
    data = Config.WeaponRepairPoints[key]
    option = {
        {
            event = "",
            icon = "",
            label = "No weapon in hand",
            duty = true,
            parameters = ""
        },
    }
    
    if data.IsRepairing then
        if data.RepairingData.CitizenId ~= PlayerData.citizenid then
            option[1].label = "Repairing is currently not available"
        else
            if not data.RepairingData.Ready then
                option[1].label = "Your weapon is being repaired"
            else
                option[1].event = "weapons:client:TakeBackWeapon"
                option[1].icon = "fas fa-times"
                option[1].label = "Take your weapon back"
                option[1].parameters = {myShop = myShop, data = data}
            end
        end
    else
        if CurrentWeaponData ~= nil and next(CurrentWeaponData) ~= nil then
            if not data.RepairingData.Ready then
                setRepairInteraction(CurrentWeaponData)
            else
                if data.RepairingData.CitizenId ~= PlayerData.citizenid then
                    option[1].label = "Repairing is currently not available"
                else
                    option[1].event = "weapons:client:TakeBackWeapon"
                    option[1].icon = "fas fa-times"
                    option[1].label = "Take your weapon back"
                    option[1].parameters = {myShop = myShop, data = data}
                end
            end
        else
            if data.RepairingData.CitizenId == nil then
            elseif data.RepairingData.CitizenId == PlayerData.citizenid then
                option[1].event = "weapons:client:TakeBackWeapon"
                option[1].icon = "fas fa-times"
                option[1].label = "Take your weapon back"
                option[1].parameters = {myShop = myShop, data = data}
            end
        end
    end

    if string.match(myShop, 'ammunation') then
        TriggerEvent("lcrp-interact:client:updateInteractionOptions","zone",myShop.."Repair",option)
    end
end)

RegisterNetEvent("weapons:client:EquipAttachment")
AddEventHandler("weapons:client:EquipAttachment", function(ItemData, attachment)
    local ped = GetPlayerPed(-1)
    local weapon = GetSelectedPedWeapon(ped)
    local WeaponData = scCore.Shared.Weapons[weapon]
    if weapon ~= GetHashKey("WEAPON_UNARMED") then
        WeaponData.name = WeaponData.name:upper()
        if Config.WeaponAttachments[WeaponData.name] ~= nil then
            if Config.WeaponAttachments[WeaponData.name][attachment] ~= nil then
                TriggerServerEvent("weapons:server:EquipAttachment", ItemData, CurrentWeaponData, Config.WeaponAttachments[WeaponData.name][attachment])
            else
                scCore.Notification("This weapon doesn\'t support this attachment", "error")
            end
        end
    else
        scCore.Notification("You have no weapon in your hand", "error")
    end
end)

RegisterNetEvent("addAttachment")
AddEventHandler("addAttachment", function(component)
    local ped = GetPlayerPed(-1)
    local weapon = GetSelectedPedWeapon(ped)
    local WeaponData = scCore.Shared.Weapons[weapon]
    GiveWeaponComponentToPed(ped, GetHashKey(WeaponData.name), GetHashKey(component))
end)

RegisterNetEvent("weapons:client:setDetails")
AddEventHandler("weapons:client:setDetails", function(weapon, shop, price, status)
    Config.Locations[shop]["weapon"].weapon = weapon
    Config.Locations[shop]["weapon"].price = price
    Config.Locations[shop]["weapon"].canBuy = status
end)

function closeMenuFull()
    Menu.hidden = true
    ClearMenu()
end

function close()
    Menu.hidden = true
end


function openShowcaseWeapon()
    MenuTitle = "Showcase weapons"
    ClearMenu()
    Menu.addButton("Pistol ["..storeStock["pistol"].."]", "showWeapon", "pistol")
    Menu.addButton("Shotgun ["..storeStock["shotgun"].."]", "showWeapon", "shotgun")
    Menu.addButton("Store weapon", "storeWeapon", nil)
    Menu.addButton("Close Menu", "close", nil)
end

function grabGunparts()
    MenuTitle = "Grab parts"
    ClearMenu()
    Menu.addButton("Pistol", "chooseParts", "pistol")
    Menu.addButton("Shotgun", "chooseParts", "shotgun")
    Menu.addButton("Close Menu", "close", nil)
end

function chooseParts(weapon)
    TriggerEvent('animations:client:EmoteCommandStart', {"bumbin"})
    scCore.TaskBar("work_carrybox", "Picking up gun parts", 15000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
 
    }, {}, {}, function() -- Done
        hasStock = true
        assembledWeapon = weapon
        ClearPedTasks(GetPlayerPed(-1))
        TriggerEvent('animations:client:EmoteCommandStart', {"box"})
    end, function() -- Cancel
        ClearPedTasks(GetPlayerPed(-1))
        scCore.Notification("Canceled", "error")
    end)
    closeMenuFull()
end

function assembleWeapon(weapon)
    if weapon == "pistol" then
        timer = 300000
    elseif weapon == "shotgun" then
        timer = 420000
    end
    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    scCore.TaskBar("work_carrybox", "Assembling weapon", timer, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@gangops@facility@servers@",
        anim = "hotwire",
        flags = 16,
    }, {}, {}, function() -- Done
        hasStock = false
        scCore.Notification("You assembled a "..weapon)
        TriggerServerEvent('lcrp-weapon:server:addStock', weapon, myShop)
        ClearPedTasks(GetPlayerPed(-1))
    end, function() -- Cancel
        ClearPedTasks(GetPlayerPed(-1))
        scCore.Notification("Canceled", "error")
    end)
end

local shownWeapon = nil

function showWeapon(weapon)
    storeWeapon()
    if setDetails(weapon) then 
        if weapon == 'pistol' then 
            SpawnObject(995074671, Config.Locations[myShop]['weapon'], function(obj)
                SetEntityHeading(obj, 156.34)
                FreezeEntityPosition(obj, true)
                shownWeapon = obj
            end)
        elseif weapon == 'shotgun' then
            SpawnObject(3194406291, Config.Locations[myShop]['weapon'], function(obj)
                SetEntityHeading(obj, 156.34)
                FreezeEntityPosition(obj, true)
                shownWeapon = obj
            end)
        end
    end
    closeMenuFull()
end



function storeWeapon()
    if shownWeapon ~= nil then 
        DeleteObject(shownWeapon)
        shownWeapon = nil
        Config.Locations[myShop]["weapon"].canBuy = false
        Config.Locations[myShop]["weapon"].weapon = nil
        Config.Locations[myShop]["weapon"].price = 0
    end
end

function setDetails(weapon)
    if storeStock[weapon] > 0 then
        price = scCore.KeyboardInput("Enter "..weapon.." price", "", 100)
        if price ~= nil then 
            if tonumber(price) ~= nil then
                if tonumber(price) > 0 then 
                    if tonumber(price) <= 11499 and weapon == "pistol" then
                        price = 11500
                        scCore.Notification("Minimum price for this weapon is $10000", "error")
                    elseif tonumber(price) <= 25000 and weapon == "shotgun" then
                        price = 29500
                        scCore.Notification("Minimum price for this weapon is $25000", "error")
                    end
                    TriggerServerEvent('weapons:server:setDetails', weapon, myShop, math.floor(tonumber(price)), true)
                    return true
                end
            else
                return false
            end
        else
            return false
        end
    else
        scCore.Notification("You don't have any "..weapon.."s in stock.", "error")
    end
end

function SpawnObject(model, coords, cb)
    if tonumber(model) ~= nil then 
        model = tonumber(model)
    end
    if type(model) == 'string' then
        model = GetHashKey(model) 
    end
    
	Citizen.CreateThread(function()
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end

		local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)

        if cb ~= nil then
			cb(obj)
		end
	end)
end


RegisterNetEvent('lcrp-weapons:client:checkLicense')
AddEventHandler('lcrp-weapons:client:checkLicense', function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        if playerId ~= GetPlayerServerId(PlayerId()) then
            TriggerServerEvent("lcrp-weapons:server:checkLicense", playerId)
        end
    else
        scCore.Notification("No one around!", "error")
    end
end)

function GetClosestPlayer()
    local closestPlayers = scCore.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))
	for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    -- ammunation1 --
    exports["lcrp-interact"]:AddBoxZone("ammunation1Duty", vector3(3.95, -1104.8, 29.79), 1.4, 0.6, {
        name="ammunation1Duty",
        heading=340,
       --debugPoly=true,
        minZ=28.39,
        maxZ=30.79 }, {
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
    job = {"ammunation1"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation1Boss", vector3(23.1, -1107.81, 29.8), 2.0, 1, {
        name="ammunation1Boss",
        heading=340,
        --debugPoly=true,
        minZ=28.8,
        maxZ=30.0,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"ammunation1"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation1Repair", vector3(6.0, -1099.93, 29.8), 1.4, 1.0, {
        name="ammunation1Repair",
        heading=340,
        --debugPoly=true,
        minZ=28.8,
        maxZ=30.2,
        }, {
        options = {
            {
                event = "",
                icon = "",
                label = "No weapon in hand",
                duty = true,
            },
        },
    job = {"ammunation1"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation1Assemble", vector3(17.34, -1110.9, 29.8), 4.2, 0.8, {
        name="ammunation1Assemble",
        heading=340,
        --debugPoly=true,
        minZ=28.4,
        maxZ=30.0,
        }, {
        options = {
            {
                event = "weapons:client:assemble",
                icon = "fas fa-pencil-ruler",
                label = "Assemble weapon",
                duty = true,
            },
        },
    job = {"ammunation1"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation1GrabParts", vector3(12.82, -1109.48, 29.8), 7.2, 1.6, {
        name="ammunation1GrabParts",
        heading=340,
        --debugPoly=true,
        minZ=28.4,
        maxZ=31.0,
        }, {
        options = {
            {
                event = "",
                icon = "",
                label = "Grab gun parts",
                duty = true,
            },
            {
                event = "weapons:client:grabParts",
                icon = "fas fa-times",
                label = "Pistol",
                duty = true,
                parameters = 'pistol'
            },
            {
                event = "weapons:client:grabParts",
                icon = "fas fa-times",
                label = "Shotgun",
                duty = true,
                parameters = 'shotgun'
            },
        },
    job = {"ammunation1"}, distance = 4 })

    exports["lcrp-interact"]:AddBoxZone("ammunation1Showcase", vector3(21.43, -1105.71, 29.79), 1.0, 1.8, {
        name="ammunation1Showcase",
        heading=340,
        --debugPoly=true,
        minZ=28.59,
        maxZ=29.99,
        }, {
        options = {
            {
                event = "",
                icon = "",
                label = "Showcase weapon",
                duty = true,
            },
            {
                event = "weapons:client:showcase",
                icon = "fas fa-times",
                label = "Pistol | Amount: 0",
                duty = true,
                parameters = 'pistol'
            },
            {
                event = "weapons:client:showcase",
                icon = "fas fa-times",
                label = "Shotgun | Amount: 0",
                duty = true,
                parameters = 'shotgun'
            },
            {
                event = "weapons:client:storeWeapon",
                icon = "fas fa-times",
                label = "Store weapon",
                duty = true,
            },
        },
    job = {"ammunation1"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation1Store", vector3(23.66, -1106.57, 29.8), 0.8, 0.8, {
        name="ammunation1Store",
        heading=340,
        --debugPoly=true,
        minZ=28.2,
        maxZ=30.4,
        }, {
        options = {
            {
                event = "weapons:server:openShop",
                icon = "fas fa-times",
                label = "Open shop",
                duty = false,
                serverEvent = true,
                parameters = "ammunation1"
            },
        },
    job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation2Repair", vector3(-659.91, -932.2, 21.83), 1, 1, {
        name="ammunation2Repair",
        heading=0,
        --debugPoly=true,
        minZ=20.23,
        maxZ=22.43,
        }, {
        options = {
            {
                event = "",
                icon = "",
                label = "No weapon in hand",
                duty = true,
            },
        },
    job = {"ammunation2"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation2Duty", vector3(-666.84, -933.69, 21.83), 1.2, 1, {
        name="ammunation2Duty",
        heading=0,
        --debugPoly=true,
        minZ=20.83,
        maxZ=23.23 }, {
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
    job = {"ammunation2"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation2Boss", vector3(-660.86, -935.62, 21.83), 1.8, 1.0, {
        name="ammunation2Boss",
        heading=0,
        --debugPoly=true,
        minZ=20.63,
        maxZ=22.23,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"ammunation2"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation2Assemble", vector3(-665.51, -940.46, 21.83), 2.2, 1.4, {
        name="ammunation2Assemble",
        heading=0,
        --debugPoly=true,
        minZ=19.63,
        maxZ=22.03,
        }, {
        options = {
            {
                event = "weapons:client:assemble",
                icon = "fas fa-pencil-ruler",
                label = "Assemble weapon",
                duty = true,
            },
        },
    job = {"ammunation2"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation2GrabParts", vector3(-662.5, -932.28, 21.83), 0.8, 3.2, {
        name="ammunation2GrabParts",
        heading=0,
        --debugPoly=true,
        minZ=20.83,
        maxZ=22.23,
        }, {
        options = {
            {
                event = "",
                icon = "",
                label = "Grab gun parts",
                duty = true,
            },
            {
                event = "weapons:client:grabParts",
                icon = "fas fa-times",
                label = "Pistol",
                duty = true,
                parameters = 'pistol'
            },
            {
                event = "weapons:client:grabParts",
                icon = "fas fa-times",
                label = "Shotgun",
                duty = true,
                parameters = 'shotgun'
            },
        },
    job = {"ammunation2"}, distance = 4 })

    exports["lcrp-interact"]:AddBoxZone("ammunation2Showcase", vector3(-663.29, -934.31, 21.83), 1.0, 2.0, {
        name="ammunation2Showcase",
        heading=0,
        --debugPoly=true,
        minZ=20.63,
        maxZ=22.03,
        }, {
        options = {
            {
                event = "",
                icon = "",
                label = "Showcase weapon",
                duty = true,
            },
            {
                event = "weapons:client:showcase",
                icon = "fas fa-times",
                label = "Pistol | Amount: 0",
                duty = true,
                parameters = 'pistol'
            },
            {
                event = "weapons:client:showcase",
                icon = "fas fa-times",
                label = "Shotgun | Amount: 0",
                duty = true,
                parameters = 'shotgun'
            },
            {
                event = "weapons:client:storeWeapon",
                icon = "fas fa-times",
                label = "Store weapon",
                duty = true,
            },
        },
    job = {"ammunation2"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation2Store", vector3(-660.92, -934.26, 21.83), 0.8, 0.8, {
        name="ammunation2Store",
        heading=0,
        --debugPoly=true,
        minZ=20.63,
        maxZ=22.43,
        }, {
        options = {
            {
                event = "weapons:server:openShop",
                icon = "fas fa-times",
                label = "Open shop",
                duty = false,
                serverEvent = true,
                parameters = "ammunation2"
            },
        },
    job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation3Repair", vector3(827.82, -2158.61, 29.62), 1.2, 1, {
        name="ammunation3Repair",
        heading=0,
        --debugPoly=true,
        minZ=28.22,
        maxZ=30.02,
        }, {
        options = {
            {
                event = "",
                icon = "",
                label = "No weapon in hand",
                duty = true,
            },
        },
    job = {"ammunation3"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation3Duty", vector3(828.11, -2153.15, 29.62), 1.8, 1, {
        name="ammunation3Duty",
        heading=0,
        --ebugPoly=true,
        minZ=28.42,
        maxZ=30.62 }, {
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
    job = {"ammunation3"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation3Boss", vector3(808.85, -2156.94, 29.62), 1.8, 1, {
        name="ammunation3Boss",
        heading=0,
        --debugPoly=true,
        minZ=28.62,
        maxZ=29.82,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"ammunation3"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation3Assemble", vector3(813.37, -2152.26, 29.62), 2.0, 1, {
        name="ammunation3Assemble",
        heading=0,
        --debugPoly=true,
        minZ=28.22,
        maxZ=29.82,
        }, {
        options = {
            {
                event = "weapons:client:assemble",
                icon = "fas fa-pencil-ruler",
                label = "Assemble weapon",
                duty = true,
            },
        },
    job = {"ammunation3"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation3GrabParts", vector3(818.06, -2154.53, 29.62), 1.6, 1.6, {
        name="ammunation3GrabParts",
        heading=0,
        --debugPoly=true,
        minZ=28.62,
        maxZ=31.02,
        }, {
        options = {
            {
                event = "",
                icon = "",
                label = "Grab gun parts",
                duty = true,
            },
            {
                event = "weapons:client:grabParts",
                icon = "fas fa-times",
                label = "Pistol",
                duty = true,
                parameters = 'pistol'
            },
            {
                event = "weapons:client:grabParts",
                icon = "fas fa-times",
                label = "Shotgun",
                duty = true,
                parameters = 'shotgun'
            },
        },
    job = {"ammunation3"}, distance = 4 })

    exports["lcrp-interact"]:AddBoxZone("ammunation3Showcase", vector3(811.2, -2158.41, 29.62), 1.0, 2.0, {
        name="ammunation3Showcase",
        heading=0,
        --debugPoly=true,
        minZ=28.62,
        maxZ=29.82,
        }, {
        options = {
            {
                event = "",
                icon = "",
                label = "Showcase weapon",
                duty = true,
            },
            {
                event = "weapons:client:showcase",
                icon = "fas fa-times",
                label = "Pistol | Amount: 0",
                duty = true,
                parameters = 'pistol'
            },
            {
                event = "weapons:client:showcase",
                icon = "fas fa-times",
                label = "Shotgun | Amount: 0",
                duty = true,
                parameters = 'shotgun'
            },
            {
                event = "weapons:client:storeWeapon",
                icon = "fas fa-times",
                label = "Store weapon",
                duty = true,
            },
        },
    job = {"ammunation3"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation3Store", vector3(808.86, -2158.38, 29.62), 0.8, 0.8, {
        name="ammunation3Store",
        heading=0,
        --debugPoly=true,
        minZ=28.42,
        maxZ=30.22,
        }, {
        options = {
            {
                event = "weapons:server:openShop",
                icon = "fas fa-times",
                label = "Open shop",
                duty = false,
                serverEvent = true,
                parameters = "ammunation3"
            },
        },
    job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation4Repair", vector3(-330.85, 6087.51, 31.45), 1, 1, {
        name="ammunation4Repair",
        heading=315,
        --debugPoly=true,
        minZ=30.05,
        maxZ=32.05,
        }, {
        options = {
            {
                event = "",
                icon = "",
                label = "No weapon in hand",
                duty = true,
            },
        },
    job = {"ammunation4"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation4Duty", vector3(-334.82, 6081.57, 31.45), 1.4, 1, {
        name="ammunation4Duty",
        heading=45,
        --debugPoly=true,
        minZ=30.25,
        maxZ=32.85 }, {
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
    job = {"ammunation4"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation4Boss", vector3(-329.27, 6084.52, 31.45), 1.0, 1.6, {
        name="ammunation4Boss",
        heading=315,
        --debugPoly=true,
        minZ=30.05,
        maxZ=31.65,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"ammunation4"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation4Assemble", vector3(-329.04, 6078.05, 31.45), 1.0, 2.6, {
        name="ammunation4Assemble",
        heading=315,
        --debugPoly=true,
        minZ=29.85,
        maxZ=31.65,
        }, {
        options = {
            {
                event = "weapons:client:assemble",
                icon = "fas fa-pencil-ruler",
                label = "Assemble weapon",
                duty = true,
            },
        },
    job = {"ammunation4"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation4GrabParts", vector3(-333.29, 6085.01, 31.45), 2.4, 1, {
        name="ammunation4GrabParts",
        heading=315,
        --debugPoly=true,
        minZ=29.85,
        maxZ=32.05,
        }, {
        options = {
            {
                event = "",
                icon = "",
                label = "Grab gun parts",
                duty = true,
            },
            {
                event = "weapons:client:grabParts",
                icon = "fas fa-times",
                label = "Pistol",
                duty = true,
                parameters = 'pistol'
            },
            {
                event = "weapons:client:grabParts",
                icon = "fas fa-times",
                label = "Shotgun",
                duty = true,
                parameters = 'shotgun'
            },
        },
    job = {"ammunation4"}, distance = 4 })

    exports["lcrp-interact"]:AddBoxZone("ammunation4Showcase", vector3(-331.96, 6083.78, 31.45), 2.2, 1, {
        name="ammunation4Showcase",
        heading=315,
        --debugPoly=true,
        minZ=30.05,
        maxZ=31.65,
        }, {
        options = {
            {
                event = "",
                icon = "",
                label = "Showcase weapon",
                duty = true,
            },
            {
                event = "weapons:client:showcase",
                icon = "fas fa-times",
                label = "Pistol | Amount: 0",
                duty = true,
                parameters = 'pistol'
            },
            {
                event = "weapons:client:showcase",
                icon = "fas fa-times",
                label = "Shotgun | Amount: 0",
                duty = true,
                parameters = 'shotgun'
            },
            {
                event = "weapons:client:storeWeapon",
                icon = "fas fa-times",
                label = "Store weapon",
                duty = true,
            },
        },
    job = {"ammunation4"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation4Store", vector3(-330.23, 6085.45, 31.45), 0.8, 0.8, {
        name="ammunation4Store",
        heading=315,
        --debugPoly=true,
        minZ=29.85,
        maxZ=32.05,
        }, {
        options = {
            {
                event = "weapons:server:openShop",
                icon = "fas fa-times",
                label = "Open shop",
                duty = false,
                serverEvent = true,
                parameters = "ammunation4"
            },
        },
    job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation5Repair", vector3(254.26, -53.17, 69.94), 1, 1, {
        name="ammunation5Repair",
        heading=340,
        --debugPoly=true,
        minZ=68.34,
        maxZ=70.54,
        }, {
        options = {
            {
                event = "",
                icon = "",
                label = "No weapon in hand",
                duty = true,
            },
        },
    job = {"ammunation5"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation5Duty", vector3(255.31, -46.11, 69.94), 1.0, 1.4, {
        name="ammunation5Duty",
        heading=340,
        --debugPoly=true,
        minZ=68.74,
        maxZ=71.34 }, {
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
    job = {"ammunation5"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation5Boss", vector3(251.39, -51.13, 69.94), 1.0, 1.6, {
        name="ammunation5Boss",
        heading=340,
        --debugPoly=true,
        minZ=68.34,
        maxZ=70.14,
        }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"ammunation5"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation5Assemble", vector3(248.52, -45.39, 69.94), 1.0, 2.4, {
        name="ammunation5Assemble",
        heading=340,
        --debugPoly=true,
        minZ=68.34,
        maxZ=70.14,
        }, {
        options = {
            {
                event = "weapons:client:assemble",
                icon = "fas fa-pencil-ruler",
                label = "Assemble weapon",
                duty = true,
            },
        },
    job = {"ammunation5"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation5GrabParts", vector3(255.34, -50.02, 69.94), 2.8, 1, {
        name="ammunation5GrabParts",
        heading=340,
        --debugPoly=true,
        minZ=68.74,
        maxZ=70.74,
        }, {
        options = {
            {
                event = "",
                icon = "",
                label = "Grab gun parts",
                duty = true,
            },
            {
                event = "weapons:client:grabParts",
                icon = "fas fa-times",
                label = "Pistol",
                duty = true,
                parameters = 'pistol'
            },
            {
                event = "weapons:client:grabParts",
                icon = "fas fa-times",
                label = "Shotgun",
                duty = true,
                parameters = 'shotgun'
            },
        },
    job = {"ammunation5"}, distance = 4 })

    exports["lcrp-interact"]:AddBoxZone("ammunation5Showcase", vector3(253.55, -49.49, 69.94), 2.2, 1, {
        name="ammunation5Showcase",
        heading=339,
        --debugPoly=true,
        minZ=68.34,
        maxZ=70.14,
        }, {
        options = {
            {
                event = "",
                icon = "",
                label = "Showcase weapon",
                duty = true,
            },
            {
                event = "weapons:client:showcase",
                icon = "fas fa-times",
                label = "Pistol | Amount: 0",
                duty = true,
                parameters = 'pistol'
            },
            {
                event = "weapons:client:showcase",
                icon = "fas fa-times",
                label = "Shotgun | Amount: 0",
                duty = true,
                parameters = 'shotgun'
            },
            {
                event = "weapons:client:storeWeapon",
                icon = "fas fa-times",
                label = "Store weapon",
                duty = true,
            },
        },
    job = {"ammunation5"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("ammunation5Store", vector3(252.72, -51.59, 69.94), 0.8, 0.8, {
        name="ammunation5Store",
        heading=340,
        --debugPoly=true,
        minZ=68.54,
        maxZ=70.54,
        }, {
        options = {
            {
                event = "weapons:server:openShop",
                icon = "fas fa-times",
                label = "Open shop",
                duty = false,
                serverEvent = true,
                parameters = "ammunation5"
            },
        },
    job = {"all"}, distance = 1.5 })
end)

RegisterNetEvent('weapons:client:grabParts')
AddEventHandler('weapons:client:grabParts', function(weapon)
    chooseParts(weapon)
end)

RegisterNetEvent('weapons:client:openShop')
AddEventHandler('weapons:client:openShop', function(data)
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_Ammunation", data)
end)

RegisterNetEvent('weapons:client:assemble')
AddEventHandler('weapons:client:assemble', function()
    if hasStock then
        assembleWeapon(assembledWeapon)
    else
        scCore.Notification("You don't have any gun parts!", 'error')
    end
    
end)

RegisterNetEvent('weapons:client:showcase')
AddEventHandler('weapons:client:showcase', function(weapon)
    showWeapon(weapon)
end)

RegisterNetEvent('weapons:client:storeWeapon')
AddEventHandler('weapons:client:storeWeapon', function()
    storeWeapon()
end)

RegisterNetEvent('weapons:client:RepairWeapon')
AddEventHandler('weapons:client:RepairWeapon', function()
    scCore.TriggerServerCallback('weapons:server:RepairWeapon', function(HasMoney)
        if HasMoney then
            CurrentWeaponData = {}
        end
    end, myShop, CurrentWeaponData)
end)



function setRepairInteraction(CurrentWeapon)
    option = {
                {
                    event = "",
                    icon = "",
                    label = "No weapon in hand",
                    duty = true,
                },
            }

    if CurrentWeapon ~= nil and CurrentWeapon ~= false then
        local WeaponData = scCore.Shared.Weapons[GetHashKey(CurrentWeapon.name)]
        if WeaponData.ammotype ~= nil then
            local WeaponClass = (scCore.Shared.SplitStr(WeaponData.ammotype, "_")[2]):lower()
            option[1].event = "weapons:client:RepairWeapon"
            option[1].icon = "fas fa-tools"
            option[1].label = "Repair weapon | $"..Config.WeaponRepairCosts[WeaponClass]
        else
            option[1].label = "Weapon cannot be repaired"
        end  
    end
    if string.match(myShop, 'ammunation') then
        TriggerEvent("lcrp-interact:client:updateInteractionOptions","zone",myShop.."Repair",option)
    end 
end