-- SKILLS
-- Stamina
local skills = {
    ["mental_state"] = 0,
    ["stamina"] = 0,
    ["strength"] = 0,
    ["driving"] = 0,
    ["flying"] = 0,
    ["stealth"] = 0,
    ["shooting"] = 0,
    ["hacking"] = 0 -- In House Robbery, hack computers to transfer money to your bank account                -- hacking skill can decrease time to hack, sucess percentage
}

Citizen.CreateThread(function()
    local fetchSkills = 10 
    while true do
        Citizen.Wait(1000)
        if Player ~= nil then
            fetchSkills = fetchSkills-1
            if fetchSkills == 0 then
                scCore.TriggerServerCallback("player:CheckSkill", function(skills)
                    skills['stamina'] = skills.stamina
                    skills['driving'] = skills.driving
                    skills['hacking'] = skills.hacking
                    skills['stealth'] = skills.stealth
                end)
                fetchSkills = 10
            end
        end
    end
end)

Citizen.CreateThread(function()
    local check = false
    local staminaMultplier = 0.6
    local sprintingTimeAllowed
    local sprintingTime = 0
    -- STAMINA
    while true do
        if not check then
            if Player ~= nil then
                skills['stamina'] = 50--Player.metadata.skill.stamina
                sprintingTimeAllowed = skills['stamina'] * staminaMultplier
                check = true
            end
        else
            if sprintingTime + 10 <= sprintingTimeAllowed then
                ResetPlayerStamina(PlayerId())
            end
            if IsPedSprinting(PlayerPedId()) then
                sprintingTime = sprintingTime + 1
            elseif sprintingTime > 0 then
                sprintingTime = sprintingTime - 1 
            end
        end
        Citizen.Wait(1000)
    end
end)
-- Stamina END

-- DRIVING
Citizen.CreateThread(function()
    local check = false
    local incPerSkillPoint = 0.005
    local value = 1.0
    while true do
        if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1)), -1) == GetPlayerPed(-1) then
            if not check then
                if Player ~= nil then
                    skills['driving'] = Player.metadata.skill.driving
                    check = true
                end
            else
                if skills['driving'] > 0 then
                    value = 1.0 + skills['driving'] * incPerSkillPoint
                end
                SetVehicleCheatPowerIncrease(GetVehiclePedIsIn(GetPlayerPed(-1)), value)
            end
            Citizen.Wait(5)
        end
        Citizen.Wait(1000)
    end
end)
-- DRIVING END
--[=====[
-- HACKING BEGIN
Citizen.CreateThread(function()
    local sleep = 1000
    local check = false
    local decPerSkillPoint = 0.2 -- v_corp_desksetb
    SpawnObject(GetHashKey("v_corp_desksetb"), {x = 221.8791, y = 208.47, z = 105.50}, function(obj)
		-- SetEntityHeading(obj, Moneywash.view.h)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
    end) 
    while true do
        if scCore ~= nil then
            if not check then
                if Player ~= nil then
                    skills['hacking'] = 40--Player.metadata.skill.hacking
                    check = true
                end
                sleep = 1000
            else
                local plyCoords = GetEntityCoords(PlayerPedId())
                local laptopDist = GetDistanceBetweenCoords(plyCoords, 221.8791, 208.47, 105.50)
                if laptopDist < 10 then
                    sleep = 5
                    DrawMarker(25, 221.8791, 208.47, 105.50-0.96, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 200, 0, 0, 0, 0)
                    scCore.Draw3DText(221.8791, 208.47, 105.50, "~b~[H]~w~ - Hack Computer")
                    if IsControlJustReleased(0, Keys["H"]) then
                        -- time at skill 0 - 30s
                        -- time at skill 100 - 10s 
                        startHack(30000-(skills['hacking']*decPerSkillPoint*1000))
                    end
                else
                    sleep = 1000
                end                
            end
        end
        Citizen.Wait(sleep)
    end
end)

-- BEGIN HOUSE ROBBERY - TO BE MOVED

-- OBJECT SPAWN TEST
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

		local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, false)

        if cb ~= nil then
			cb(obj)
		end
	end)
end
--


-- PED SPAWN TEST
RegisterCommand('spawnPed', function()
    local ped = GetHashKey("mp_f_cocaine_01")
    RequestModel(ped)
    while not HasModelLoaded(ped) do
        Citizen.Wait(1)
    end
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
    newPed = CreatePed(5, ped,x,y,z,0.0,false,true)
    SetPedCombatAttributes(ped, 0, true)
    SetPedCombatAttributes(ped, 46, true)
    GiveWeaponToPed(newPed,GetHashKey("weapon_pumpshotgun",200,true,false))
    SetPedAccuracy(newPed, 100)
    SetAiWeaponDamageModifier(1000.0)

    -- Citizen.Wait(6000)
    
    --[[ loadAnimDict("timetable@tracy@sleep@")
    while noise<200 do
        TaskPlayAnim(newPed, "timetable@tracy@sleep@", "idle_c", 8.0, 8.0, -1, 1, 0, 0, 0, 0 )
        Citizen.Wait(5)
    end ]]
end)
-- ANIM TEST

RegisterCommand('playAnim',function()
    openHouseAnim()
end)
function openHouseAnim()
    loadAnimDict("missah_2_ext_altleadinout")
    while true do
        TaskPlayAnim(GetPlayerPed(-1), "missah_2_ext_altleadinout", "hack_loop", 2.0, 2.0, -1, 1, 0, false, false, false )
        Citizen.Wait(5)
    end
    
    Citizen.Wait(400)
    ClearPedTasks(GetPlayerPed(-1))
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

-- HACK TASKBAR AND 
-- SUCCESS FUNCTION <- MOVE TO SERVER SIDE?

local isHacking
function startHack(taskTime)
    
    local Skillbar = exports['lcrp-skillbar']:GetSkillbarObject()
    local playerPed = GetPlayerPed(-1)
    local PlayerData = scCore.Functions.GetPlayerData()
    isHacking = true
    
    Citizen.CreateThread(function()
        loadAnimDict("missah_2_ext_altleadinout")
        while isHacking do
            TaskPlayAnim(GetPlayerPed(), "missah_2_ext_altleadinout", "hack_loop", 8.0, 8.0, -1, 1, 0, 0, 0, 0 )
            Citizen.Wait(5)
        end
        StopEntityAnim(GetPlayerPed(), "hack_loop", "missah_2_ext_altleadinout", true)
    end)
    
    Skillbar.Start({
        duration = math.random(7500, 10000),
        pos = math.random(10, 30),
        width = math.random(10, 20),
    }, function()
        
        print('hello')
        SetTimeout(500)
        -- TaskStartScenarioInPlace(playerPed, "amb@prop_human_seat_computer@male", 0, true) -- NEEDS PROPER ANIMATION
        scCore.TaskBar("hack_pc", "Hacking bank details and transfering funds", taskTime, false, true, {}, {}, {}, {}, function()
            -- min chance at skill 0 - 50%
            -- max chance at skill 100 - 90%
            local chanceIncrement = 0.4
            local baseChance = 50
            local chance = baseChance + (chanceIncrement * skills['hacking'])
            local succeed = math.random(100)
            if chance > succeed then
                TriggerServerEvent("player:UpdateSkill", "add", "hacking", 1) -- Increases skill if hacking is successfull
                -- Player.Functions.AddMoney("bank", 2000) -- Adds money to Players bank acc <- Most likely needs to be server sided
                scCore.Notification('Funds Transfered!')
            else
                scCore.Notification('Hacking Failed!','error')
            end
            isHacking = false
        end, function()
            scCore.Notification("Hacking cancelled!")
            isHacking = false
        end)
        -- ClearPedTasks(GetPlayerPed(-1))
        -- FreezeEntityPosition(ped, false)
    end, function()
       --[[  -- Fail
        ClearPedTasks(GetPlayerPed(-1))
        -- TriggerServerEvent('lcrp-houserobbery:server:SetBusyState', cabin, currentHouse, false)
        scCore.Notification("Canceled", "error")
        FreezeEntityPosition(ped, false) ]]
    end)
    
end
-- END


-- HACKING END

-- STEALTH BEGIN

-- IsPedRunning IsPedSprinting GetPedStealthMovement GetPlayerCurrentStealthNoise
local inRobbery
local noise = 0


RegisterNetEvent('lcrp-scripts:client:resetNoise')
AddEventHandler('lcrp-scripts:client:resetNoise', function()
    noise = 0
    inRobbery = false
    print(inRobbery)
end)

RegisterNetEvent('lcrp-scripts:client:robberNoise')
AddEventHandler('lcrp-scripts:client:robberNoise', function()
        inRobbery = true
        Citizen.Wait(3000)
        noise = 0
        print('YEET- '..tostring(inRobbery))
        maxNoise = 100 + skills['stealth']
        local playerPed = GetPlayerPed(-1)
        while inRobbery do
            Citizen.Wait(1000)
            if scCore ~= nil then
                if not IsPedWalking(playerPed) and not IsPedRunning(playerPed) and not IsPedSprinting(playerPed) then
                    if noise > 2 then
                        noise = noise - 2
                    else
                        noise = 0
                    end
                end
                noise = noise + GetPlayerCurrentStealthNoise() * 0.8
                scCore.Notification(noise..'-'..tostring(inRobbery)..'-'..maxNoise)
                if noise > maxNoise then
                    TriggerEvent('lcrp-houserobbery:client:wakePed')
                    -- TriggerServerEvent("police:server:HouseRobberyCall", pos, msg, gender, streetLabel) -- Alert Police needs tweak
                end
            end
        end
end)

-- STEALTH END

--]=====]


