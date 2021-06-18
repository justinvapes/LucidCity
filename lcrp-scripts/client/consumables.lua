local alcoholCount = 0
local addictions = {
    ["alcohol"] = {enabled = false, phase = 1, name = "alcohol", hardcore = true, need = false},
    ["cigars"] = {enabled = false, phase = 1, name = "cigars", hardcore = false, need = false},
    ["drugs"] = {enabled = false, phase = 1, name = "drugs", hardcore = true, need = false},
}
local hasSatisfied = true

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(600000 * 3)
        TriggerServerEvent("player:UpdateSkill", "remove", "lung_capacity", 1)
        TriggerServerEvent("player:UpdateSkill", "remove", "mental_state", 1)
        TriggerServerEvent("player:UpdateSkill", "remove", "stamina", 1)
        TriggerServerEvent("player:UpdateSkill", "remove", "strength", 1)
        TriggerServerEvent("player:UpdateSkill", "remove", "driving", 1)
        TriggerServerEvent("player:UpdateSkill", "remove", "flying", 1)
        TriggerServerEvent("player:UpdateSkill", "remove", "stealth", 1)
        TriggerServerEvent("player:UpdateSkill", "remove", "shooting", 1)
    end
end)


RegisterNetEvent("consumables:client:UseLSD")
AddEventHandler("consumables:client:UseLSD", function()
    local ped = PlayerPedId()

    scCore.TaskBar("lsd_tab", "Placing LSD Strip on 👅", 1500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", scCore.Shared.Items["lsd"], "remove")
        TriggerServerEvent("player:UpdateSkill", "add", "mental_state", 1)
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            TriggerEvent('animations:client:EmoteCommandStart', {"fallover3"})
        else
            RequestAnimDict("mp_suicide")
            while not HasAnimDictLoaded("mp_suicide") do Citizen.Wait(0) end
            TaskPlayAnim(ped, "mp_suicide", "pill", 8.0, 8.0, 1.0, 48, -1, 0, 0, 0)
            Citizen.Wait(2800)
            ClearPedTasks(PlayerPedId())
            Citizen.Wait(3000)
            StopAnimTask(GetPlayerPed(-1), "mp_suicide", "pill", 1.0)
        end
        LSDTime = math.random(100, 120)
        TriggerServerEvent('lcrp-hud:Server:RelieveStress', math.random(20, 35))
        TriggerEvent("evidence:client:SetStatus", "dazed", 600)
        TriggerEvent("evidence:client:SetStatus", "dilated", 600)
        TriggerEvent("fx:run", "lsd", LSDTime, nil, true)
        if addictions["drugs"].need then
            addictions["drugs"].need = false
        else
            TriggerServerEvent('player:UpdateAddiction', "drugs", 1)
        end
    end)
end)


local bodySweat = 0
local swimmingTime = 0
local cooldown = false

Citizen.CreateThread(function()
    while true do
        local speed = GetEntitySpeed(PlayerPedId())
        Citizen.Wait(500)
        if IsPedSwimming(PlayerPedId()) then
            swimmingTime = swimmingTime + 3000
            if speed > 0 and speed < 5 then
                TriggerEvent("evidence:client:SetStatus", "saturatedclothing", 300)
            elseif speed >= 5 then
                TriggerEvent("evidence:client:SetStatus", "saturatedclothing", 600)
            end

            if swimmingTime > 400000 and speed > 3 then
                TriggerServerEvent("player:UpdateSkill", "add", "lung_capacity", 1)
                swimmingTime = 0
            end
        end

        -- START ADDING BODY SWEAT (3000)
        if IsPedRunning(PlayerPedId()) then
            bodySweat = bodySweat + 3000
        end

        -- EVIDENCE BODY SWEAT FUNCTIONS
        if bodySweat > 200000 and bodySweat < 300000 and not IsPedSwimming(PlayerPedId()) then
            TriggerEvent("evidence:client:SetStatus", "sweat", 300)
            if not cooldown then
                TriggerServerEvent("player:UpdateSkill", "add", "stamina", 1) 
                cooldown = true
            end
        elseif bodySweat >= 300000 and bodySweat < 800000 and not IsPedSwimming(PlayerPedId()) then
            TriggerEvent("evidence:client:SetStatus", "sweat", 450)
            if not cooldown then
                TriggerServerEvent("player:UpdateSkill", "add", "stamina", 1) 
                cooldown = true
            end
        elseif bodySweat >= 800000 and not IsPedSwimming(PlayerPedId()) then
            TriggerEvent("evidence:client:SetStatus", "sweat", 600)
            if not cooldown then
                TriggerServerEvent("player:UpdateSkill", "add", "stamina", 1) 
                cooldown = true
            end
        end

        -- START REMOVING BODY SWEAT (1000)
        if bodySweat >= 4500 and not IsPedSwimming(PlayerPedId()) and not IsPedRunning(PlayerPedId()) then
            bodySweat = bodySweat - 4500
        end
    end
end)


Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(5)
        if cooldown then
            Citizen.Wait(60000)
            cooldown = false
        end
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function EquipParachuteAnim()
    loadAnimDict("clothingshirt")        
    TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

local ParachuteEquiped = false

RegisterNetEvent("consumables:client:UseParachute")
AddEventHandler("consumables:client:UseParachute", function()
    EquipParachuteAnim()
    scCore.TaskBar("use_parachute", "Using parachute", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        local ped = GetPlayerPed(-1)
        TriggerEvent("inventory:client:ItemBox", scCore.Shared.Items["parachute"], "remove")
        GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 1, false)
        local ParachuteData = {
            outfitData = {
                ["bag"]   = { item = 7, texture = 0},  -- Nek / Das
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ParachuteData)
        ParachuteEquiped = true
        TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    end)
end)

RegisterNetEvent("consumables:client:ResetParachute")
AddEventHandler("consumables:client:ResetParachute", function()
    if ParachuteEquiped then 
        EquipParachuteAnim()
        scCore.TaskBar("reset_parachute", "Packing parachute", 20000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            local ped = GetPlayerPed(-1)
            TriggerEvent("inventory:client:ItemBox", scCore.Shared.Items["parachute"], "add")
            local ParachuteRemoveData = { 
                outfitData = { 
                    ["bag"] = { item = -1, texture = 0} -- Nek / Das
                }
            }
            TriggerEvent('lcrp-clothes:client:loadJobOutfit', ParachuteRemoveData)
            TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
            TriggerServerEvent("lcrp-scripts:server:AddParachute")
            ParachuteEquiped = false
        end)
    else
        scCore.Notification("You don't have a parachute!", "error")
    end
end)

RegisterNetEvent("consumables:client:UseArmor")
AddEventHandler("consumables:client:UseArmor", function()
    local ped = GetPlayerPed(-1)
    local armor = GetPedArmour(ped)

    if armor < 75 then
        scCore.TaskBar("use_armor", "Putting armor on", 5000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerServerEvent("lcrp-scripts:removeItem", "armor")
            TriggerEvent("inventory:client:ItemBox", scCore.Shared.Items["armor"], "remove")
            TriggerServerEvent('hospital:server:SetArmor', 50)
            SetPedArmour(GetPlayerPed(-1), 50)
        end)
    else
        scCore.Notification("You already have armor on!", "error")
    end
end)
local currentVest = nil
local currentVestTexture = nil
RegisterNetEvent("consumables:client:UseHeavyArmor")
AddEventHandler("consumables:client:UseHeavyArmor", function()
    local ped = GetPlayerPed(-1)
    local armor = GetPedArmour(ped)

    if armor < 100 then
        scCore.TaskBar("use_heavyarmor", "Putting heavy armor on", 5000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerServerEvent('hospital:server:SetArmor', 100)
            TriggerServerEvent("lcrp-scripts:removeItem", "heavyarmor")
            TriggerEvent("inventory:client:ItemBox", scCore.Shared.Items["heavyarmor"], "remove")
            SetPedArmour(ped, 100)
        end)
    else
        scCore.Notification("You already have heavy armor on!", "error")
    end
end)

local emotableDrinks = {
    "wine", "whiskey", "beer",
}
RegisterNetEvent("consumables:client:DrinkAlcohol")
AddEventHandler("consumables:client:DrinkAlcohol", function(itemName)
    local played = false
    for k, v in pairs(emotableDrinks) do
        if v == itemName then
            played = true
            TriggerEvent('animations:client:EmoteCommandStart', {itemName})
        end
    end
    if not played then
        TriggerEvent('animations:client:EmoteCommandStart', {"drink"})
    end
    scCore.TaskBar("snort_coke", "Drinking alcohol", math.random(3000, 6000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerEvent("inventory:client:ItemBox", scCore.Shared.Items[itemName], "remove")
        TriggerServerEvent("scCore:Server:RemoveItem", itemName, 1)
        TriggerServerEvent("scCore:Server:SetMetaData", "thirst", scCore.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
        TriggerServerEvent("player:UpdateSkill", "add", "mental_state", 1)
        TriggerServerEvent('lcrp-hud:Server:RelieveStress', math.random(5, 10))
        if addictions["alcohol"].need then
            addictions["alcohol"].need = false
        else
            alcoholCount = alcoholCount + 1
            TriggerServerEvent('player:UpdateAddiction', "alcohol", 1)
        end   
        if alcoholCount > 2 and alcoholCount < 4 then
            TriggerEvent("evidence:client:SetStatus", "alcohol", 200)
            goDrunk(1)
        elseif alcoholCount >= 4 then
            TriggerEvent("evidence:client:SetStatus", "heavyalcohol", 200)
            goDrunk(2)
        end
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        scCore.Notification("Canceled", "error")
    end)
end)

RegisterNetEvent("consumables:client:Cokebaggy")
AddEventHandler("consumables:client:Cokebaggy", function()
    scCore.TaskBar("snort_coke", "Snorting coke", math.random(5000, 8000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "switch@trevor@trev_smoking_meth",
        anim = "trev_smoking_meth_loop",
        flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        TriggerServerEvent("scCore:Server:RemoveItem", "cokebaggy", 1)
        TriggerServerEvent("player:UpdateSkill", "remove", "mental_state", 1)
        TriggerEvent("inventory:client:ItemBox", scCore.Shared.Items["cokebaggy"], "remove")
        TriggerEvent("evidence:client:SetStatus", "widepupils", 200)
        if addictions["drugs"].need then
            addictions["drugs"].need = false
        else
            TriggerServerEvent('player:UpdateAddiction', "drugs", 1)   
        end   
        CokeBaggyEffect(addictions["drugs"].need)
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        scCore.Notification("Canceled", "error")
    end)
end)

RegisterNetEvent("consumables:client:Crackbaggy")
AddEventHandler("consumables:client:Crackbaggy", function()
    scCore.TaskBar("snort_coke", "Smoking crack", math.random(7000, 10000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "switch@trevor@trev_smoking_meth",
        anim = "trev_smoking_meth_loop",
        flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        TriggerServerEvent("scCore:Server:RemoveItem", "crack_baggy", 1)
        TriggerEvent("inventory:client:ItemBox", scCore.Shared.Items["crack_baggy"], "remove")
        TriggerEvent("evidence:client:SetStatus", "widepupils", 300)
        CrackBaggyEffect(addictions["drugs"].need)
        if addictions["drugs"].need then
            addictions["drugs"].need = false
        else
            TriggerServerEvent('player:UpdateAddiction', "drugs", 1)   
        end  
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "switch@trevor@trev_smoking_meth", "trev_smoking_meth_loop", 1.0)
        scCore.Notification("Canceled", "error")
    end)
end)

RegisterNetEvent('consumables:client:EcstasyBaggy')
AddEventHandler('consumables:client:EcstasyBaggy', function()
    scCore.TaskBar("use_ecstasy", "Using ecstasy", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "mp_suicide",
		anim = "pill",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "mp_suicide", "pill", 1.0)
        TriggerServerEvent("scCore:Server:RemoveItem", "xtcbaggy", 1)
        TriggerEvent("inventory:client:ItemBox", scCore.Shared.Items["xtcbaggy"], "remove")
        EcstasyEffect(addictions["drugs"].need)
        if addictions["drugs"].need then
            addictions["drugs"].need = false
        else
            TriggerServerEvent('player:UpdateAddiction', "drugs", 1)   
        end  
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "mp_suicide", "pill", 1.0)
        scCore.Notification("Failed", "error")
    end)
end)

RegisterNetEvent("consumables:client:Eat")
AddEventHandler("consumables:client:Eat", function(itemName)
    local hasAnimation, animation = hasEatAnimation(itemName)
    if hasAnimation then
        TriggerEvent('animations:client:EmoteCommandStart', {animation})
    else
        TriggerEvent('animations:client:EmoteCommandStart', {"eat"})
    end
    scCore.TaskBar("eat_something", "Eating", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("burgershot:client:IsBurgerShotItem",itemName)
        TriggerServerEvent('lcrp-hud:Server:RelieveStress', math.random(2, 5))
        TriggerEvent("inventory:client:ItemBox", scCore.Shared.Items[itemName], "remove")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent("scCore:Server:SetMetaData", "hunger", scCore.Functions.GetPlayerData().metadata["hunger"] + Consumeables[itemName])
    end)
end)

RegisterNetEvent("consumables:client:Drink")
AddEventHandler("consumables:client:Drink", function(itemName)
    if itemName == "sprite" or itemName == "applejuice" or itemName == "kurkakola" then
        TriggerEvent('animations:client:EmoteCommandStart', {"soda"})
    elseif itemName == "redbullock" or itemName == "mutant_energy" or itemName == "empire" then
        local ped = PlayerId()
        TriggerEvent('animations:client:EmoteCommandStart', {"soda"})
        SetRunSprintMultiplierForPlayer(ped, 1.25)
        SetSwimMultiplierForPlayer(ped, 1.25)

        Citizen.SetTimeout(10000, function()
            SetRunSprintMultiplierForPlayer(ped, 1.0)
            SetSwimMultiplierForPlayer(ped, 1.0)
        end)
    else
        TriggerEvent('animations:client:EmoteCommandStart', {"drink"})
    end
    scCore.TaskBar("drink_something", "Drinking", 2500, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done

        TriggerServerEvent('lcrp-hud:Server:RelieveStress', math.random(2, 5))
        TriggerEvent("inventory:client:ItemBox", scCore.Shared.Items[itemName], "remove")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent("scCore:Server:SetMetaData", "thirst", scCore.Functions.GetPlayerData().metadata["thirst"] + Consumeables[itemName])
    end)
end)

function EcstasyEffect(inNeed)
    local startStamina = 30
    SetFlash(0, 0, 500, 7000, 500)
    while startStamina > 0 do 
        Citizen.Wait(1000)
        startStamina = startStamina - 1
        if not inNeed then
            RestorePlayerStamina(PlayerId(), 1.0)
        end
        if math.random(1, 100) < 51 then
            SetFlash(0, 0, 500, 7000, 500)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
        end
    end
    if IsPedRunning(GetPlayerPed(-1)) then
        SetPedToRagdoll(GetPlayerPed(-1), math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
    end

    startStamina = 0
    --RevertToStressMultiplier()
end

function JointEffect(inNeed)
    local onWeed = true
    local weedTime = Config.JointEffectTime
    if not inNeed then
        Citizen.CreateThread(function()
            while onWeed do 
                SetPlayerHealthRechargeMultiplier(PlayerId(), 1.8)
                Citizen.Wait(1000)
                weedTime = weedTime - 1
                if weedTime <= 0 then
                    onWeed = false
                end
            end
        end)
    end
end

function CrackBaggyEffect(inNeed)
    local startStamina = 8
    AlienEffect()
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.3)
    while startStamina > 0 do 
        Citizen.Wait(1000)
        if math.random(1, 100) < 10 then
            RestorePlayerStamina(PlayerId(), 1.0)
        end
        startStamina = startStamina - 1
        if math.random(1, 100) < 60 and IsPedRunning(GetPlayerPed(-1)) then
            SetPedToRagdoll(GetPlayerPed(-1), math.random(1000, 2000), math.random(1000, 2000), 3, 0, 0, 0)
        end
        if math.random(1, 100) < 51 then
            AlienEffect()
        end
    end
    if IsPedRunning(GetPlayerPed(-1)) then
        SetPedToRagdoll(GetPlayerPed(-1), math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
    end

    startStamina = 0
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

function CokeBaggyEffect(inNeed)
    local startStamina = 20
    AlienEffect()
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.1)
    while startStamina > 0 do 
        Citizen.Wait(1000)
        if math.random(1, 100) < 20 then
            RestorePlayerStamina(PlayerId(), 1.0)
        end
        startStamina = startStamina - 1
        if math.random(1, 100) < 10 and IsPedRunning(GetPlayerPed(-1)) then
            SetPedToRagdoll(GetPlayerPed(-1), math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
        end
        if math.random(1, 300) < 10 then
            AlienEffect()
            Citizen.Wait(math.random(3000, 6000))
        end
    end
    if IsPedRunning(GetPlayerPed(-1)) then
        SetPedToRagdoll(GetPlayerPed(-1), math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
    end
    startStamina = 0
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
end

function AlienEffect()
    StartScreenEffect("DrugsMichaelAliensFightIn", 3.0, 0)
    Citizen.Wait(math.random(5000, 8000))
    StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
    Citizen.Wait(math.random(5000, 8000))    
    StartScreenEffect("DrugsMichaelAliensFightOut", 3.0, 0)
    StopScreenEffect("DrugsMichaelAliensFightIn")
    StopScreenEffect("DrugsMichaelAliensFight")
    StopScreenEffect("DrugsMichaelAliensFightOut")
end


--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
------------------------------------------------- ADDICTIONS -------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

RegisterNetEvent("lcrp-addiction:client:deployAddiction")
AddEventHandler("lcrp-addiction:client:deployAddiction", function(addiction, phase)
    addictions[addiction].enabled = true
    addictions[addiction].phase = phase
    if phase == 1 then
        phase1(addiction)
    elseif phase == 2 then
        phase2(addiction)
    else
        phase3(addiction)
    end
end)

RegisterNetEvent("lcrp-addiction:client:clearAddiction")
AddEventHandler("lcrp-addiction:client:clearAddiction", function(addiction)
    addictions[addiction].enabled = false
end)


phase1 = function(addiction)
    Citizen.CreateThread(function()
        local notification = 0
        local shake = math.random(0, 100)
        local shakeDur = 0
        local isShake = false
        local blur = math.random(0, 100)
        local blurDur = 0
        local isBlur = false
        local blackout = math.random(0, 100)
        local isBlackout = false
        local requestTimer = math.random(1800, 7200)
        while addictions[addiction].enabled and addictions[addiction].phase == 1 do
            if notification == 0 then
                scCore.Notification("You\'re starting to feel the urge for "..addictions[addiction].name)
                notification = 3600
            end
            if requestTimer == 0 then
                addictions[addiction].need = true
                controlDesire(addiction)
                requestTimer = math.random(1800, 7200)
            end
            if addictions[addiction].need or not hasSatisfied then
                if shake == 0 then
                    shakeDur = math.random(10, 60)
                    isShake = true
                    shake = math.random(600, 3600)
                    beDrunk(true)
                end
                if isShake then
                    shakeDur = shakeDur - 1
                    if shakeDur == 0 then
                        beDrunk(false)
                        isShake = false
                    end
                end
                if blur == 0 then
                    blurDur = math.random(1, 5)
                    isBlur = true
                    TriggerScreenblurFadeIn(100)
                    blur = math.random(600, 3600)
                end
                if isBlur then
                    blurDur = blurDur - 1
                    if blurDur == 0 then
                        TriggerScreenblurFadeOut(100)
                        isBlur = false
                    end
                end
                if isBlackout then
                    DoScreenFadeIn(500)
                    isBlackout = false
                end
                if blackout == 0 then
                    DoScreenFadeOut(100)
                    blackout = math.random(600, 1800)
                    isBlackout = true
                end
                shake = shake - 1
                blur = blur - 1
                blackout = blackout - 1
            end
            requestTimer = requestTimer - 1
            notification = notification - 1
            Citizen.Wait(1000)
        end
    end)
end

phase2 = function(addiction)
    Citizen.CreateThread(function()
        local notification = 0
        local shake = math.random(0, 100)
        local shakeDur = 0
        local isShake = false
        local blur = math.random(0, 100)
        local blurDur = 0
        local isBlur = false
        local blackout = math.random(0, 100)
        local isBlackout = false
        local bleed = math.random(0, 100)
        local coldSweat = 0
        local coldDur = 0
        local isCold = false
        local requestTimer = math.random(1800, 3600)
        while addictions[addiction].enabled and addictions[addiction].phase == 2 do
            if notification == 0 then
                scCore.Notification("You\'re addicted to "..addictions[addiction].name)
                notification = 3600
            end
            if requestTimer == 0 then
                addictions[addiction].need = true
                controlDesire(addiction)
                requestTimer = math.random(1800, 3600)
            end
            if addictions[addiction].need or not hasSatisfied then
                if shake == 0 then
                    shakeDur = math.random(10, 60)
                    isShake = true
                    shake = math.random(600, 3600)
                    beDrunk(true)
                end
                if isShake then
                    shakeDur = shakeDur - 1
                    if shakeDur == 0 then
                        beDrunk(false)
                        isShake = false
                    end
                end
                if blur == 0 then
                    blurDur = math.random(1, 5)
                    isBlur = true
                    TriggerScreenblurFadeIn(100)
                    blur = math.random(600, 3600)
                end
                if isBlur then
                    blurDur = blurDur - 1
                    if blurDur == 0 then
                        TriggerScreenblurFadeOut(100)
                        isBlur = false
                    end
                end
                if isBlackout then
                    DoScreenFadeIn(500)
                    isBlackout = false
                end
                if blackout == 0 then
                    DoScreenFadeOut(100)
                    blackout = math.random(600, 1800)
                    isBlackout = true
                end
                if bleed == 0 then
                    scCore.Notification("You felt a twinge in your torso likely due to  "..addictions[addiction].name.." addiction!")
                    SetEntityHealth(GetEntityHealth(PlayerPedId()) - 10)
                    SetPedToRagdoll(PlayerPedId(), 1000, 1000, 3, 0, 0, 0)
                    bleed = math.random(600, 1800)
                end
                if coldSweat == 0 then
                    scCore.Notification("You\'re having cold sweats likely due to "..addictions[addiction].name.." addiction!")
                    SetPedWetnessHeight(PlayerPedId(), 2.0)
                    SetPedWetnessEnabledThisFrame(PlayerPedId())
                    isCold = true
                    coldDur = math.random(300, 1200)
                    coldSweat = math.random(600, 1800)
                end
                if isCold then
                    coldDur = coldDur - 1
                    if coldDur == 0 then
                        ClearPedWetness(PlayerPedId())
                        isCold = false
                    end
                end
                shake = shake - 1
                blur = blur - 1
                blackout = blackout - 1
                bleed = bleed - 1
                coldSweat = coldSweat - 1
            end
            requestTimer = requestTimer - 1
            notification = notification - 1
            Citizen.Wait(1000)
        end
    end)
end

phase3 = function(addiction)
    Citizen.CreateThread(function()
        local notification = 0
        local shake = math.random(0, 60)
        local shakeDur = 0
        local isShake = false
        local blur = 50000
        local blurDur = math.random(0, 60)
        local isBlur = false
        local blackout = math.random(0, 60)
        local isBlackout = false
        local bleed = math.random(0, 100)
        local seizure = 0
        local seizDur = 0
        local hadSeizure = false
        local coldSweat = 0
        local coldDur = 0
        local isCold = false
        local requestTimer = math.random(1800, 2400)
        while addictions[addiction].enabled and addictions[addiction].phase == 3 do
            if notification == 0 then
                scCore.Notification("You\'re heavily dependant on "..addictions[addiction].name)
                notification = 3600
            end
            if requestTimer == 0 then
                addictions[addiction].need = true
                controlDesire(addiction)
                requestTimer = math.random(1800, 2400)
            end
            if addictions[addiction].need or not hasSatisfied then
                if shake == 0 then
                    shakeDur = math.random(10, 60)
                    isShake = true
                    shake = math.random(600, 1200)
                    beDrunk(true)
                end
                if isShake then
                    shakeDur = shakeDur - 1
                    if shakeDur == 0 then
                        beDrunk(false)
                        isShake = false
                    end
                end
                if blur == 0 then
                    blurDur = math.random(1, 5)
                    isBlur = true
                    TriggerScreenblurFadeIn(100)
                    blur = math.random(600, 1200)
                end
                if isBlur then
                    blurDur = blurDur - 1
                    if blurDur == 0 then
                        TriggerScreenblurFadeOut(100)
                        isBlur = false
                    end
                end
                if isBlackout then
                    DoScreenFadeIn(500)
                    isBlackout = false
                end
                if blackout == 0 then
                    DoScreenFadeOut(100)
                    blackout = math.random(600, 1200)
                    isBlackout = true
                end
                if bleed == 0 then
                    scCore.Notification("You felt a twinge in your torso likely due to  "..addictions[addiction].name.." dependency!")
                    SetEntityHealth(GetEntityHealth(PlayerPedId()) - 10)
                    SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
                    bleed = math.random(600, 1200)
                end
                if addictions[addiction].hardcore then
                    if seizure == 0 then
                        scCore.Notification("You\'re having a seizure likely due to  "..addictions[addiction].name.." dependency!")
                        hadSeizure = true
                        StartScreenEffect('Dont_tazeme_bro', 0, true)
                        StartScreenEffect('MP_race_crash', 0, true)
                        TriggerEvent('animations:client:EmoteCommandStart', {"stunned"})
                        Citizen.Wait(3000)
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        Citizen.Wait(100)
                        SetTimeScale(0.4)
                        SetPedToRagdoll(PlayerPedId(), 20000, 20000, 0, 0, 0, 0)
                        for blackouts = 1, 10 do
                            Citizen.Wait(1000)
                            DoScreenFadeOut(100)
                            Citizen.Wait(500)        
                            DoScreenFadeIn(100)
                        end
                        SetTimeScale(1.0)
                        StopScreenEffect('Dont_tazeme_bro')
                        StopScreenEffect('MP_race_crash')
                        seizDur = math.random(300, 900)
                        seizure = math.random(600, 1800)
                    end
                    if hadSeizure then
                        local ped = PlayerPedId()
                        seizDur = seizDur - 1
                        if IsPedSprinting(ped) or IsPedRunning(ped) then
                            SetPedToRagdoll(ped, 1000, 1000, 3, 0, 0, 0)
                        end
                        TriggerEvent('animations:client:WalkStart', "drunk3")
                        if seizDur == 0 then
                            hadSeizure = false
                        end
                    end
                end
                if coldSweat == 0 then
                    scCore.Notification("You\'re having cold sweats likely due to "..addictions[addiction].name.." dependency!")
                    SetPedWetnessHeight(PlayerPedId(), 2.0)
                    SetPedWetnessEnabledThisFrame(PlayerPedId())
                    isCold = true
                    coldDur = math.random(300, 1200)
                    coldSweat = math.random(600, 1800)
                end
                if isCold then
                    coldDur = coldDur - 1
                    if coldDur == 0 then
                        ClearPedWetness(PlayerPedId())
                        isCold = false
                    end
                end
                shake = shake - 1
                blur = blur - 1
                blackout = blackout - 1
                bleed = bleed - 1
                seizure = seizure - 1
                coldSweat = coldSweat - 1
            end
            requestTimer = requestTimer - 1
            notification = notification - 1
            Citizen.Wait(1000)
        end
    end)
end



function beDrunk(drunk)
    if drunk then
        ShakeGameplayCam("DRUNK_SHAKE", math.min(1.0, 3.0))
        TriggerEvent('animations:client:WalkStart', "drunk3")
    else 
        ShakeGameplayCam("DRUNK_SHAKE", 0.0)  
        TriggerEvent('AnimSet:default')
        alcoholCount = 0
    end 
end

local isImmune = false
function goDrunk(level)
    if level == 1 then
        ShakeGameplayCam("DRUNK_SHAKE", math.min(1.0, 3.0))
        startDrunkCount = true
        drunkTimer = math.random(600,900)
        SetEntityProofs(PlayerPedId(), false, false, false, false, true, false, 1, false)
        isImmune = true
    elseif level == 2 then
        ShakeGameplayCam("DRUNK_SHAKE", math.min(2.0, 5.0))
        startDrunkCount = true
        drunkTimer = math.random(1200,1800)
        SetEntityProofs(PlayerPedId(), true, true, false, false, true, false, 1, false)
        isImmune = true
    end
end

Citizen.CreateThread(function()
    local isDone = false
    while true do
        sleep = 10000
        if startDrunkCount then
            sleep = 1000
            drunkTimer = drunkTimer - 1
            blurCount = drunkTimer / 2 - 1
            if not isDone then
                TriggerScreenblurFadeIn(100)
            end
            local ped = PlayerPedId()
            if IsPedSprinting(ped) or IsPedRunning(ped) then
                SetPedToRagdoll(ped, 3000, 3000, 3, 0, 0, 0)
            end
            if blurCount <= 0 and not isDone then
                isDone = true
                TriggerScreenblurFadeOut(100)
            end
            if isImmune then
                if HasEntityBeenDamagedByWeapon(ped, 0, 2) then
                    SetEntityProofs(PlayerPedId(), false, false, false, false, false, false, 1, false)
                    isImmune = false
                end
            end
            TriggerEvent('animations:client:WalkStart', "drunk3")
            if drunkTimer == 0 then
                startDrunkCount = false
                beDrunk(false)
            end
        end
        Citizen.Wait(sleep)
    end
end)

function controlDesire(addiction)
    Citizen.CreateThread(function()
        scCore.Notification("Your body is asking for ".. addiction.." right now")
        Citizen.Wait(600000)
        if addictions[addiction].need then
            hasSatisfied = false
        end  
    end)
end

function hasEatAnimation(itemName)
    local hasAnimation = false
    local animation = "eat"
    for k,v in pairs(Config.HasEatAnimation) do
        if k == itemName then
            hasAnimation = true
            animation = v
            break
        end
    end
    return hasAnimation,animation
end

--//////////////DEV CORE SMOKING
isSmokeJointMouth = false
isSmokeJointHand = false
noeffectjoint = false
throwcigarette = false
effect = false

p_firejoint_particle = "ent_amb_torch_fire"
p_firejoint_particle_asset = "core" 

p_joint_particle = "exp_grd_bzgas_smoke"
p_joint_particle_asset = "core"


joint_name = joint_name or 'prop_sh_joint_01'
jointnolight_name = jointnolight_name or 'p_cs_joint_02'
lighterjoint_name = lighterjoint_name or 'ex_prop_exec_lighter_01'

RegisterNetEvent('consumables:client:UseJoint')
AddEventHandler('consumables:client:UseJoint', function(source)
    scCore.TriggerServerCallback('scCore:HasItem', function(result)
        if result then
            local playerPed = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(playerPed))
    if isSmokeJointHand == true or isSmokeHand == true or isSmokeCigarHand == true or isSmokeMouth == true or isSmokeCigarMouth == true or isSmokeJointMouth == true then
        scCore.Notification('You are already smoking!','error')
    else
        playAnim('amb@world_human_smoking@male@male_a@enter', 'enter', 1800)
        Citizen.Wait(1000)
        jointnolight = CreateObject(GetHashKey(jointnolight_name), x, y, z+0.9,  true,  true, true)
        AttachEntityToEntity(jointnolight, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
        Citizen.Wait(800)

        lighterjoint = CreateObject(GetHashKey(lighterjoint_name), x, y, z+0.9,  true,  true, true)
        AttachEntityToEntity(lighterjoint, playerPed, GetPedBoneIndex(playerPed, 4089), 0.020, -0.03, -0.010, 100.0, 0.0, 150.0, true, true, false, true, 1, true)

        playAnim('misscarsteal2peeing', 'peeing_loop', 2000)
        Citizen.Wait(800)
        TriggerServerEvent("devcore_smoke:eff_lighter_joint", ObjToNet(lighterjoint))
        Citizen.Wait(1000)
        DetachEntity(jointnolight, 1, 1)
        DeleteObject(jointnolight)

        joint = CreateObject(GetHashKey(joint_name), x, y, z+0.9,  true,  true, true)
        AttachEntityToEntity(joint, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)

        throwjoint = true
        isSmokeJointHand = true
        isSmokeJointMouth = false
        Citizen.Wait(1000)
        DetachEntity(lighterjoint, 1, 1)
        DeleteObject(lighterjoint)
        TriggerServerEvent("devcore_smoke:eff_joint", ObjToNet(joint))
        TriggerEvent("inventory:client:ItemBox", scCore.Shared.Items["joint"], "remove")
        TriggerServerEvent("player:UpdateSkill", "remove", "lung_capacity", 1)
        TriggerServerEvent('lcrp-hud:Server:RelieveStress', math.random(20, 35))
        TriggerEvent("evidence:client:SetStatus", "weedsmell", 300)
        JointEffect(addictions["drugs"].need)
        if addictions["drugs"].need then
            addictions["drugs"].need = false
        else
            TriggerServerEvent('player:UpdateAddiction', "drugs", 1)
        end   
    end
        else
            scCore.Notification("You dont have a lighter")
        end
    end, "lighter")
end)
  
RegisterNetEvent('devcore_smoke:JointMouth')
AddEventHandler('devcore_smoke:JointMouth', function(source)
    local playerPed = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(playerPed))

playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
Citizen.Wait(800)

AttachEntityToEntity(joint, playerPed, GetPedBoneIndex(playerPed, 47419), 0.010, 0.0, 0.0, 50.0, 0.0, 80.0, true, true, false, true, 1, true)
isSmokeJointHand = false
isSmokeJointMouth = true
end)
  
RegisterNetEvent('devcore_smoke:JointHand')
AddEventHandler('devcore_smoke:JointHand', function(source)
    local playerPed = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(playerPed))

    playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
    Citizen.Wait(1100)

    AttachEntityToEntity(joint, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
    isSmokeJointHand = true
    isSmokeJointMouth = false
end)
  
  
  
RegisterNetEvent("devcore_smoke:c_eff_lighter_joint")
AddEventHandler("devcore_smoke:c_eff_lighter_joint", function(lighterjoint)
    createdLighterJoint = UseParticleFxAssetNextCall(p_firejoint_particle_asset)
    createdPartLighterJoint = StartParticleFxLoopedOnEntity(p_firejoint_particle, NetToPed(lighterjoint), 0.0, 0.0, 0.050, 0.0, 0.0, 0.0, 0.03, 0.0, 0.0, 0.0)
    Wait(1200)
    while DoesParticleFxLoopedExist(createdLighterJoint) do
        StopParticleFxLooped(createdLighterJoint, 1)
        Wait(1)
    end
    while DoesParticleFxLoopedExist(createdPartLighterJoint) do
        StopParticleFxLooped(createdPartLighterJoint, 1)
        Wait(1)
    end
    while DoesParticleFxLoopedExist(p_firejoint_particle) do
        StopParticleFxLooped(p_firejoint_particle, 1)
        Wait(1)
    end
    while DoesParticleFxLoopedExist(p_firejoint_particle_asset) do
        StopParticleFxLooped(p_firejoint_particle_asset, 1)
        Wait(1)
    end 
    Wait(1900)
    RemoveParticleFxFromEntity(lighterjoint)
end)
  
RegisterNetEvent("devcore_smoke:c_eff_joint")
AddEventHandler("devcore_smoke:c_eff_joint", function(joint)
    createdSmokeJoint = UseParticleFxAssetNextCall(p_joint_particle_asset)
    createdPartJoint = StartParticleFxLoopedOnEntity(p_joint_particle, NetToPed(joint), -0.090, 0.0, 0.0, 0.0, 0.0, 0.0, Config.SmokeSizeJoint, 0.0, 0.0, 0.0)
    Wait(Config.JointSmokingTime)
    while DoesParticleFxLoopedExist(createdSmokeJoint) do
        StopParticleFxLooped(createdSmokeJoint, 1)
        Wait(1)
    end
    while DoesParticleFxLoopedExist(createdPartJoint) do
        StopParticleFxLooped(createdPartJoint, 1)
        Wait(1)
    end
    while DoesParticleFxLoopedExist(p_joint_particle) do
        StopParticleFxLooped(p_joint_particle, 1)
        Wait(1)
    end
    while DoesParticleFxLoopedExist(p_joint_particle_asset) do
        StopParticleFxLooped(p_joint_particle_asset, 1)
        Wait(1)
    end 
    if Config.CancelSmokeJoint then
        if throwjoint then
            Wait(1000)
            SmokeDoneJoint()
        end
    end
end)
  
p_smoke_location_joint = {
    20279,
}
p_effjoint_particle = "exp_grd_bzgas_smoke"
p_effjoint_particle_asset = "core" 

RegisterNetEvent("devcore_smoke:c_eff_smokes_joint")
AddEventHandler("devcore_smoke:c_eff_smokes_joint", function(c_ped)
    for _,bonesjoint in pairs(p_smoke_location_joint) do
        if DoesEntityExist(NetToPed(c_ped)) and not IsEntityDead(NetToPed(c_ped)) then
            createdeffjoint = UseParticleFxAssetNextCall(p_effjoint_particle_asset)
            createdParteffjoint = StartParticleFxLoopedOnEntityBone(p_effjoint_particle, NetToPed(c_ped), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(c_ped), bonesjoint), Config.SmokeJointMouth, 0.0, 0.0, 0.0)
            Wait(Config.JointHangTime)
            while DoesParticleFxLoopedExist(createdeffjoint) do
                StopParticleFxLooped(createdeffjoint, 1)
            Wait(1)
            end
            while DoesParticleFxLoopedExist(createdParteffjoint) do
                StopParticleFxLooped(createdParteffjoint, 1)
            Wait(1)
            end
            while DoesParticleFxLoopedExist(p_effjoint_particle) do
                StopParticleFxLooped(p_effjoint_particle, 1)
            Wait(1)
            end
            while DoesParticleFxLoopedExist(p_effjoint_particle_asset) do
                StopParticleFxLooped(p_effjoint_particle_asset, 1)
            Wait(1)
            end
            Wait(Config.JointHangTime)
            RemoveParticleFxFromEntity(NetToPed(c_ped))
            break
        end
    end
end)
  
function SmokeDoneJoint()
    local playerPed = PlayerPedId()
    if isSmokeJointMouth == true then
        Citizen.Wait(600)
        throwjoint = false
        playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
        Citizen.Wait(1000)
        AttachEntityToEntity(joint, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
        Citizen.Wait(1000)
        DetachEntity(joint, 1, 1)
        isSmokeJointHand = false
        Citizen.Wait(2000)
        DeleteObject(joint)
        RemoveParticleFxFromEntity(joint)
        isSmokeJointMouth = false
        noeffectjoint = true
        effect = false
    else
        throwjoint = false
        DetachEntity(joint, 1, 1)
        isSmokeJointHand = false
        Citizen.Wait(2000)
        DeleteObject(joint)
        RemoveParticleFxFromEntity(joint)
        isSmokeJointMouth = false
        noeffectjoint = true
        effect = false
    end
end
  
Citizen.CreateThread(function(source)
    while true do
        Wait(7)
        if isSmokeJointMouth then
            local playerPed = PlayerPedId()
            scCore.ShowHelpNotification('~INPUT_CONTEXT~ Smoke ~INPUT_VEH_DUCK~ Drop ~INPUT_SCRIPTED_FLY_ZDOWN~ Hand')
            
            if IsEntityInWater(playerPed) then
                Citizen.Wait(800)
                SmokeDoneJoint()
            else
                if IsControlJustPressed(0, Config.Smoke) then
                    local ped = GetPlayerPed(-1)
                    Citizen.Wait(2200)
                    TriggerServerEvent("devcore_smoke:eff_smokes_joint", PedToNet(ped))
                    Citizen.Wait(1200)
                elseif IsControlJustPressed(0, Config.Throw) then
                    if IsPedInAnyVehicle(playerPed, true) then
                        throwjoint = false
                        playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
                        Citizen.Wait(1000)
                        AttachEntityToEntity(joint, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
                        Citizen.Wait(250)
                        DetachEntity(joint, 1, 1)
                        isSmokeJointHand = false
                        DeleteObject(joint)
                        RemoveParticleFxFromEntity(joint)
                        isSmokeJointMouth = false

                        noeffectjoint = true
                        effect = false
                    else
                        SmokeDoneJoint()
                    end
                elseif IsControlJustPressed(0, Config.Mouth) then
                    TriggerEvent('devcore_smoke:JointHand')
                end
            end
        else
            Wait(500)
        end
    end
end)
  
  
Citizen.CreateThread(function(source)
    while true do
        Wait(7)
        if isSmokeJointHand then
            local playerPed = PlayerPedId()
            scCore.ShowHelpNotification('~INPUT_CONTEXT~ Smoke ~INPUT_VEH_DUCK~ Drop ~INPUT_SCRIPTED_FLY_ZUP~ Mouth')
            if IsPedInAnyVehicle(playerPed, true) then
                local playerVeh = GetVehiclePedIsIn(playerPed, false)
                RollDownWindow(playerVeh, 0)
                Citizen.Wait(1500)
                TriggerEvent('devcore_smoke:JointMouth')
            else
                if IsEntityInWater(playerPed) then
                    Citizen.Wait(800)
                    SmokeDoneJoint()
                else
                    if IsControlJustPressed(0, Config.Throw) then
                        SmokeDoneJoint()
                    elseif IsControlJustPressed(0, Config.inHand) then
                        TriggerEvent('devcore_smoke:JointMouth')
                    elseif IsControlJustPressed(0, Config.Smoke) then
                        playAnim('amb@world_human_aa_smoke@male@idle_a', 'idle_a',2800)
                        Citizen.Wait(4000)
                        TriggerServerEvent("devcore_smoke:eff_smokes_joint", PedToNet(playerPed))
                    end
                end
            end
        else
            Wait(500)
        end
    end
end)

isSmokeMouth = false
isSmokeHand = false
throwcigarette = false

p_smokecigarette_particle = "exp_grd_bzgas_smoke"
p_smokecigarette_particle_asset = "core" 

p_fire_particle = "ent_amb_torch_fire"
p_fire_particle_asset = "core" 

cigaratte_name = cigaratte_name or 'ng_proc_cigarette01a'
cigarettenolight_name = cigarettenolight_name or 'prop_amb_ciggy_01'
cigarettepack_name = cigarettepack_name or 'prop_cigar_pack_01'
light_name = light_name or 'ex_prop_exec_lighter_01'

RegisterNetEvent("consumables:client:UseCigarette")
AddEventHandler("consumables:client:UseCigarette", function()
    scCore.TriggerServerCallback('scCore:HasItem', function(result)
        if result then
            local playerPed = PlayerPedId()
            local x,y,z = table.unpack(GetEntityCoords(playerPed))
            if isSmokeJointHand == true or isSmokeHand == true or isSmokeCigarHand == true or isSmokeMouth == true or isSmokeCigarMouth == true or isSmokeJointMouth == true then
                scCore.Notification('You are already smoking!','error')
            else
                playAnim('amb@world_human_smoking@male@male_a@enter', 'enter', 1800)
                Citizen.Wait(1000)
                cigarettenolight = CreateObject(GetHashKey(cigarettenolight_name), x, y, z+0.9,  true,  true, true)
                AttachEntityToEntity(cigarettenolight, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
                    Citizen.Wait(800)

                light = CreateObject(GetHashKey(light_name), x, y, z+0.9,  true,  true, true)
                AttachEntityToEntity(light, playerPed, GetPedBoneIndex(playerPed, 4089), 0.020, -0.03, -0.010, 100.0, 0.0, 150.0, true, true, false, true, 1, true)

                playAnim('misscarsteal2peeing', 'peeing_loop', 2000)
                Citizen.Wait(800)
                TriggerServerEvent("devcore_smoke:eff_lighter", ObjToNet(light))
                Citizen.Wait(1000)
                DetachEntity(cigarettenolight, 1, 1)
                DeleteObject(cigarettenolight)

                cigaratte = CreateObject(GetHashKey(cigaratte_name), x, y, z+0.9,  true,  true, true)
                AttachEntityToEntity(cigaratte, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)

                throwcigarette = true
                isSmokeHand = true
                isSmokeMouth = false
                Citizen.Wait(1000)
                DetachEntity(light, 1, 1)
                DeleteObject(light)
                TriggerServerEvent("devcore_smoke:eff_cigarette", ObjToNet(cigaratte))

                TriggerEvent("inventory:client:ItemBox", scCore.Shared.Items["cigarette"], "remove")
                TriggerServerEvent("player:UpdateSkill", "remove", "lung_capacity", 1)
                TriggerServerEvent("lcrp-scripts:removeItem", "cigarette")

                if addictions["cigars"].need then
                    addictions["cigars"].need = false
                else
                    TriggerServerEvent('player:UpdateAddiction', "cigars", 1)   
                end   
                TriggerServerEvent('lcrp-hud:Server:RelieveStress', math.random(5, 20))

            end
        else
            scCore.Notification("You dont have a lighter")
        end
    end, "lighter")
end)

RegisterNetEvent('devcore_smoke:CigaretteMouth')
AddEventHandler('devcore_smoke:CigaretteMouth', function(source)
	local playerPed = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(playerPed))

    playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
    Citizen.Wait(800)

    AttachEntityToEntity(cigaratte, playerPed, GetPedBoneIndex(playerPed, 47419), 0.015, -0.009, 0.003, 55.0, 0.0, 110.0, true, true, false, true, 1, true)
    isSmokeHand = false
    isSmokeMouth = true
end)

RegisterNetEvent('devcore_smoke:CigaretteHand')
AddEventHandler('devcore_smoke:CigaretteHand', function(source)
	local playerPed = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(playerPed))

    playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
    Citizen.Wait(1100)

    AttachEntityToEntity(cigaratte, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
    isSmokeHand = true
    isSmokeMouth = false
end)



RegisterNetEvent("devcore_smoke:c_eff_lighter")
AddEventHandler("devcore_smoke:c_eff_lighter", function(light)
	createdLighter = UseParticleFxAssetNextCall(p_fire_particle_asset)
	createdPartLighter = StartParticleFxLoopedOnEntity(p_fire_particle, NetToPed(light), 0.0, 0.0, 0.050, 0.0, 0.0, 0.0, 0.03, 0.0, 0.0, 0.0)
	Wait(1200)
	while DoesParticleFxLoopedExist(createdLighter) do
		StopParticleFxLooped(createdLighter, 1)
	  Wait(1)
	end
	while DoesParticleFxLoopedExist(createdPartLighter) do
		StopParticleFxLooped(createdPartLighter, 1)
	  Wait(1)
	end
	while DoesParticleFxLoopedExist(p_fire_particle) do
		StopParticleFxLooped(p_fire_particle, 1)
	  Wait(1)
	end
	while DoesParticleFxLoopedExist(p_fire_particle_asset) do
		StopParticleFxLooped(p_fire_particle_asset, 1)
	  Wait(1)
	end 
	Wait(1900)
	RemoveParticleFxFromEntity(light)

end)

RegisterNetEvent("devcore_smoke:c_eff_cigarette")
AddEventHandler("devcore_smoke:c_eff_cigarette", function(cigaratte)
	createdCigarette = UseParticleFxAssetNextCall(p_smokecigarette_particle_asset)
	createdPartCigarette = StartParticleFxLoopedOnEntity(p_smokecigarette_particle, NetToPed(cigaratte), -0.050, 0.0, 0.0, 0.0, 0.0, 0.0, Config.SmokeSizeCigarette, 0.0, 0.0, 0.0)
	Wait(Config.CigaretteSmokingTime)
	while DoesParticleFxLoopedExist(createdCigarette) do
		StopParticleFxLooped(createdCigarette, 1)
	  Wait(1)
	end
	while DoesParticleFxLoopedExist(createdPartCigarette) do
		StopParticleFxLooped(createdPartCigarette, 1)
	  Wait(1)
	end
	while DoesParticleFxLoopedExist(p_smokecigarette_particle) do
		StopParticleFxLooped(p_smokecigarette_particle, 1)
	  Wait(1)
	end
	while DoesParticleFxLoopedExist(p_smokecigarette_particle_asset) do
		StopParticleFxLooped(p_smokecigarette_particle_asset, 1)
	  Wait(1)
	end 
	if Config.CancelSmoke then
		if throwcigarette then
	Wait(1000)
		SmokeDone()
		end
	end
end)

p_smoke_location = {
	20279,
}
p_smoke_particle = "exp_grd_bzgas_smoke"
p_smoke_particle_asset = "core" 
RegisterNetEvent("devcore_smoke:c_eff_smokes")
AddEventHandler("devcore_smoke:c_eff_smokes", function(c_ped)
	for _,bones in pairs(p_smoke_location) do
		if DoesEntityExist(NetToPed(c_ped)) and not IsEntityDead(NetToPed(c_ped)) then
		createdSmoke = UseParticleFxAssetNextCall(p_smoke_particle_asset)
		createdPart = StartParticleFxLoopedOnEntityBone(p_smoke_particle, NetToPed(c_ped), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(c_ped), bones), Config.SmokeMouth, 0.0, 0.0, 0.0)
		Wait(Config.CigaretteHangTime)
		while DoesParticleFxLoopedExist(createdSmoke) do
				StopParticleFxLooped(createdSmoke, 1)
			  Wait(0)
			end
			while DoesParticleFxLoopedExist(createdPart) do
				StopParticleFxLooped(createdPart, 1)
			  Wait(0)
			end
			while DoesParticleFxLoopedExist(p_smoke_particle) do
				StopParticleFxLooped(p_smoke_particle, 1)
			  Wait(0)
			end
			while DoesParticleFxLoopedExist(p_smoke_particle_asset) do
				StopParticleFxLooped(p_smoke_particle_asset, 1)
			  Wait(0)
			end
			Wait(Config.CigaretteHangTime)
			RemoveParticleFxFromEntity(NetToPed(c_ped))
			break
		end
	end
end)


function SmokeDone()
    local playerPed = PlayerPedId()
    if isSmokeMouth == true then
        Citizen.Wait(600)
        throwcigarette = false
        playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
        Citizen.Wait(1000)
        AttachEntityToEntity(cigaratte, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
        Citizen.Wait(1000)
        DetachEntity(cigaratte, 1, 1)
        isSmokeHand = false
        Citizen.Wait(2000)
        RemoveParticleFxFromEntity(cigaratte)
        DeleteObject(cigaratte)
        isSmokeMouth = false
    else
        Citizen.Wait(600)
        throwcigarette = false
        DetachEntity(cigaratte, 1, 1)
        isSmokeHand = false
        Citizen.Wait(2000)
        DeleteObject(cigaratte)
        RemoveParticleFxFromEntity(cigaratte)
        isSmokeMouth = false
    end
end

Citizen.CreateThread(function(source)
	while true do
		Citizen.Wait(7)
		 if isSmokeMouth then
			local playerPed = PlayerPedId()
			scCore.ShowHelpNotification('~INPUT_CONTEXT~ Smoke ~INPUT_VEH_DUCK~ Drop ~INPUT_SCRIPTED_FLY_ZDOWN~ Hand')
			if IsEntityInWater(playerPed) then
				Citizen.Wait(800)
				SmokeDone()
			else
			if IsControlJustPressed(0, Config.Smoke) then
				local ped = GetPlayerPed(-1)
				Citizen.Wait(2200)
				TriggerServerEvent("devcore_smoke:eff_smokes", PedToNet(ped))
			elseif IsControlJustPressed(0, Config.Throw) then
				if IsPedInAnyVehicle(playerPed, true) then
					throwcigarette = false
					playAnim('move_p_m_two_idles@generic', 'fidget_sniff_fingers', 1000)
					Citizen.Wait(1000)
						AttachEntityToEntity(cigaratte, playerPed, GetPedBoneIndex(playerPed, 64097), 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true)
						Citizen.Wait(250)
						DetachEntity(cigaratte, 1, 1)
						isSmokeHand = false
						DeleteObject(cigaratte)
						RemoveParticleFxFromEntity(cigaratte)
						isSmokeMouth = false
					else
					SmokeDone()
				end
			elseif IsControlJustPressed(0, Config.Mouth) then
					TriggerEvent('devcore_smoke:CigaretteHand')
				end
			end
		else
			Wait(500)
		end
	end
end)


Citizen.CreateThread(function(source)
	while true do
		Citizen.Wait(7)
		 if isSmokeHand then

			local playerPed = PlayerPedId()
			scCore.ShowHelpNotification('~INPUT_CONTEXT~ Smoke ~INPUT_VEH_DUCK~ Drop ~INPUT_SCRIPTED_FLY_ZUP~ Mouth')
			if IsPedInAnyVehicle(playerPed, true) then
				local playerVeh = GetVehiclePedIsIn(playerPed, false)
				RollDownWindow(playerVeh, 0)
				Citizen.Wait(1500)
			TriggerEvent('devcore_smoke:CigaretteMouth')
			else
				if IsEntityInWater(playerPed) then
					Citizen.Wait(800)
					SmokeDone()
				else
			if IsControlJustPressed(0, Config.Smoke) then
				local ped = GetPlayerPed(-1)
				playAnim('amb@world_human_aa_smoke@male@idle_a', 'idle_a', 2800)
				Citizen.Wait(4000)
				TriggerServerEvent("devcore_smoke:eff_smokes", PedToNet(ped))
			elseif IsControlJustPressed(0, Config.Throw) then
				SmokeDone()
			elseif IsControlJustPressed(0, Config.inHand) then
				TriggerEvent('devcore_smoke:CigaretteMouth')
				end
			end
		end
			else
				Wait(500)
		end
	end
end)

function playAnim(animDict, animName, duration)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
	TaskPlayAnim(GetPlayerPed(-1), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
	RemoveAnimDict(animDict)
end

