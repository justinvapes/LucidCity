Keys = {
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

DoScreenFadeIn(100)

inBedDict = "misslamar1dead_body"
inBedAnim = "dead_idle"

getOutDict = 'switch@franklin@bed'
getOutAnim = 'sleep_getup_rubeyes'

isLoggedIn = false

isInHospitalBed = false
canLeaveBed = true
currentHospital = 1

bedOccupying = nil
bedObject = nil
bedOccupyingData = nil
currentTp = nil
usedHiddenRev = false

isBleeding = 0
bleedTickTimer, advanceBleedTimer = 0, 0
fadeOutTimer, blackoutTimer = 0, 0

legCount = 0
armcount = 0
headCount = 0

playerHealth = nil
playerArmour = nil

isDead = false

closestBed = nil

isStatusChecking = false
statusChecks = {}
statusCheckPed = nil
statusCheckTime = 0

isHealingPerson = false
healAnimDict = "mini@cpr@char_a@cpr_str"
healAnim = "cpr_pumpchest"

doctorsSet = false
doctorCount = 0

PlayerJob = {}
onDuty = false

BodyParts = {
    ['HEAD'] = { label = 'head', causeLimp = false, isDamaged = false, severity = 0 },
    ['NECK'] = { label = 'neck', causeLimp = false, isDamaged = false, severity = 0 },
    ['SPINE'] = { label = 'spine', causeLimp = true, isDamaged = false, severity = 0 },
    ['UPPER_BODY'] = { label = 'upper body', causeLimp = false, isDamaged = false, severity = 0 },
    ['LOWER_BODY'] = { label = 'lower body', causeLimp = true, isDamaged = false, severity = 0 },
    ['LARM'] = { label = 'left arm', causeLimp = false, isDamaged = false, severity = 0 },
    ['LHAND'] = { label = 'left hand', causeLimp = false, isDamaged = false, severity = 0 },
    ['LFINGER'] = { label = 'left finger', causeLimp = false, isDamaged = false, severity = 0 },
    ['LLEG'] = { label = 'left leg', causeLimp = true, isDamaged = false, severity = 0 },
    ['LFOOT'] = { label = 'left foot', causeLimp = true, isDamaged = false, severity = 0 },
    ['RARM'] = { label = 'right arm', causeLimp = false, isDamaged = false, severity = 0 },
    ['RHAND'] = { label = 'right hand', causeLimp = false, isDamaged = false, severity = 0 },
    ['RFINGER'] = { label = 'right finger', causeLimp = false, isDamaged = false, severity = 0 },
    ['RLEG'] = { label = 'right leg', causeLimp = true, isDamaged = false, severity = 0 },
    ['RFOOT'] = { label = 'right foot', causeLimp = true, isDamaged = false, severity = 0 },
}

injured = {}

scCore = nil
Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        local armor = GetPedArmour(ped)

        if not playerHealth then
            playerHealth = health
        end

        if not playerArmor then
            playerArmor = armor
        end

        local armorDamaged = (playerArmor ~= armor and armor < (playerArmor - Config.ArmorDamage) and armor > 0) -- Players armor was damaged
        local healthDamaged = (playerHealth ~= health) -- Players health was damaged

        local damageDone = (playerHealth - health)

        if armorDamaged or healthDamaged then
            local hit, bone = GetPedLastDamageBone(ped)
            local bodypart = Config.Bones[bone]
            local weapon = GetDamagingWeapon(ped)

            if hit and bodypart ~= 'NONE' then
                local checkDamage = true
                if damageDone >= Config.HealthDamage then
                    if weapon ~= nil then
                        if armorDamaged and (bodypart == 'SPINE' or bodypart == 'UPPER_BODY') or weapon == Config.WeaponClasses['NOTHING'] then
                            checkDamage = false -- Don't check damage if the it was a body shot and the weapon class isn't that strong
                            if armorDamaged then
                                TriggerServerEvent("hospital:server:SetArmor", GetPedArmour(GetPlayerPed(-1)))
                            end
                        end
    
                        if checkDamage then
    
                            if IsDamagingEvent(damageDone, weapon) then
                                CheckDamage(ped, bone, weapon, damageDone)
                            end
                        end
                    end
                elseif Config.AlwaysBleedChanceWeapons[weapon] then
                    if armorDamaged and (bodypart == 'SPINE' or bodypart == 'UPPER_BODY') or weapon == Config.WeaponClasses['NOTHING'] then
                        checkDamage = false -- Don't check damage if the it was a body shot and the weapon class isn't that strong
                    end
                    if math.random(100) < Config.AlwaysBleedChance and checkDamage then
                        ApplyBleed(1)
                    end
                end
            end

            CheckWeaponDamage(ped)
        end

        playerHealth = health
        playerArmor = armor

        if not isInHospitalBed then
            ProcessDamage(ped)
        end
        Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait((1000 * Config.MessageTimer))
        DoLimbAlert()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        SetClosestBed()
        if isStatusChecking then
            statusCheckTime = statusCheckTime - 1
            if statusCheckTime <= 0 then
                statusChecks = {}
                isStatusChecking = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    local PaletoBlip = AddBlipForCoord(-254.88, 6324.5, 32.58)
    SetBlipSprite(PaletoBlip, 61)
    SetBlipAsShortRange(PaletoBlip, true)
    SetBlipScale(PaletoBlip, 0.8)
    SetBlipColour(PaletoBlip, 69)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Paleto Hospital")
    EndTextCommandSetBlipName(PaletoBlip)

    local PillboxBlip = AddBlipForCoord(304.27, -600.33, 43.28)
    SetBlipSprite(PillboxBlip, 61)
    SetBlipAsShortRange(PillboxBlip, true)
    SetBlipScale(PillboxBlip, 0.8)
    SetBlipColour(PillboxBlip, 69)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Pillbox Hospital")
    EndTextCommandSetBlipName(PillboxBlip)

    local SandyBlip = AddBlipForCoord(1836.462, 3677.506, 34.27)
    SetBlipSprite(SandyBlip, 61)
    SetBlipAsShortRange(SandyBlip, true)
    SetBlipScale(SandyBlip, 0.8)
    SetBlipColour(SandyBlip, 69)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Sandy Hospital")
    EndTextCommandSetBlipName(SandyBlip)

   --[[  while true do
        Citizen.Wait(1)
        if scCore ~= nil then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            for k, v in pairs(Config.Locations["checking"]) do 
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.x,v.y,v.z, true) < 1.5) then
                    if doctorCount >= Config.MinimalDoctors then
                        scCore.Draw3DText(v.x, v.y, v.z, "~r~[E]~w~ - Call a doctor")
                    else
                        scCore.Draw3DText(v.x, v.y, v.z, "~r~[E]~w~ - Check in")
                    end
                    if IsControlJustReleased(0, Keys["E"]) then
                        TriggerEvent("police:client:DeEscort") -- stop escort
                        currentHospital = k
                        -- Only call for doctor if player is at pillbox
                        if doctorCount >= Config.MinimalDoctors and currentHospital == 1 then
                            TriggerServerEvent("hospital:server:SendDoctorAlert")
                        else
                            TriggerEvent('animations:client:EmoteCommandStart', {"notepad"})
                            scCore.TaskBar("hospital_checkin", "Checking in", 2000, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                local bedId = GetAvailableBed(currentHospital)
                                if bedId ~= nil then 
                                    TriggerServerEvent("hospital:server:SendToBed", bedId, true, currentHospital)
                                else
                                    scCore.Notification("Beds occupied", "error")
                                end
                            end, function() -- Cancel
                                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                scCore.Notification("Canceled!", "error")
                            end)
                        end
                    end
                elseif (GetDistanceBetweenCoords(pos.x, pos.y, pos.z,v.x, v.y, v.z, true) < 4.5) then
                    if doctorCount >= Config.MinimalDoctors then
                        scCore.Draw3DText(v.x, v.y, v.z, "Calling")
                    else
                        scCore.Draw3DText(v.x, v.y, v.z, "Check in")
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end ]]
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()

	exports["lcrp-interact"]:AddBoxZone("checkin", vector3(307.62, -595.29, 43.28), 1.6, 1, {
        name="checkin",
        heading=340,
        --debugPoly=true,
        minZ=42.08,
        maxZ=43.48
        }, {
		options = {
			{
				event = "hospital:client:checkin",
				icon = "far fa-clipboard",
				label = "Check in",
				duty = false,
                parameters = 1
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("checkin2", vector3(1831.03, 3675.93, 34.27), 0.8, 1.6, {
        name="checkin2",
        heading=30,
        --debugPoly=true,
        minZ=32.67,
        maxZ=34.87
        }, {
		options = {
			{
				event = "hospital:client:checkin",
				icon = "far fa-clipboard",
				label = "Check in",
				duty = false,
                parameters = 2
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("checkin3", vector3(-256.1, 6328.55, 32.4), 1.2, 2.0, {
        name="checkin3",
        heading=0,
        --debugPoly=true,
        minZ=31.0,
        maxZ=33.0
        }, {
		options = {
			{
				event = "hospital:client:checkin",
				icon = "far fa-clipboard",
				label = "Check in",
				duty = false,
                parameters = 3
			},
		},
	job = {"all"}, distance = 2.0 })

    -- pillbox second check in

    exports["lcrp-interact"]:AddBoxZone("checkin4", vector3(350.13, -587.92, 28.8), 2.6, 0.8, {
        name="checkin4",
        heading=340,
        --debugPoly=true,
        minZ=28.55,
        maxZ=28.95
        }, {
		options = {
			{
				event = "hospital:client:checkin",
				icon = "far fa-clipboard",
				label = "Check in",
				duty = false,
                parameters = 1
			},
		},
	job = {"all"}, distance = 2.0 })
    
end)

RegisterNetEvent("hospital:client:checkin")
AddEventHandler("hospital:client:checkin", function(hospital)
    TriggerEvent("police:client:DeEscort")
    currentHospital = hospital

    if doctorCount >= Config.MinimalDoctors and currentHospital == 1 then
        TriggerServerEvent("hospital:server:SendDoctorAlert")
    else
        TriggerEvent('animations:client:EmoteCommandStart', {"notepad"})
        scCore.TaskBar("hospital_checkin", "Checking in", 2000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            local bedId = GetAvailableBed(currentHospital)
            if bedId ~= nil then 
                TriggerServerEvent("hospital:server:SendToBed", bedId, true, currentHospital)
            else
                scCore.Notification("Beds occupied", "error")
            end
        end, function() -- Cancel
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            scCore.Notification("Canceled!", "error")
        end)
    end
end)

function GetAvailableBed(hospital)
    local retval = nil

    -- Pillbox
    if hospital == 1 then
        if bedId == nil then 
            for k, v in pairs(Config.Locations["beds"]) do
                if not Config.Locations["beds"][k].taken then
                    retval = k
                end
            end
        else
            if not Config.Locations["beds"][bedId].taken then
                retval = bedId
            end
        end
    -- Sandy
    elseif hospital == 2 then
        if bedId == nil then 
            for k, v in pairs(Config.Locations["sandyBeds"]) do
                if not Config.Locations["sandyBeds"][k].taken then
                    retval = k
                end
            end
        else
            if not Config.Locations["sandyBeds"][bedId].taken then
                retval = bedId
            end
        end
    -- Paleto
    elseif hospital == 3 then
        if bedId == nil then 
            for k, v in pairs(Config.Locations["paletoBeds"]) do
                if not Config.Locations["paletoBeds"][k].taken then
                    retval = k
                end
            end
        else
            if not Config.Locations["paletoBeds"][bedId].taken then
                retval = bedId
            end
        end
    end
    return retval
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if scCore ~= nil then
            if isInHospitalBed and canLeaveBed then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                scCore.Draw3DText(pos.x, pos.y, pos.z, "~r~[E]~w~ - To get out of bed")
                if IsControlJustReleased(0, Keys["E"]) then
                    LeaveBed()
                end
            else
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent('hospital:client:Revive')
AddEventHandler('hospital:client:Revive', function()
    local player = PlayerPedId()

    if isDead then
        SetLaststand(false)
		local playerPos = GetEntityCoords(player, true)
        NetworkResurrectLocalPlayer(playerPos, true, true, false)
        isDead = false
        SetEntityInvincible(GetPlayerPed(-1), false)
    elseif InLaststand then
        local playerPos = GetEntityCoords(player, true)
        NetworkResurrectLocalPlayer(playerPos, true, true, false)
        isDead = false
        SetEntityInvincible(GetPlayerPed(-1), false)
        SetLaststand(false)
    end

    if isInHospitalBed then
        loadAnimDict(inBedDict)
        TaskPlayAnim(player, inBedDict , inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
        SetEntityInvincible(GetPlayerPed(-1), true)
        canLeaveBed = true
        LeaveBed()
    end

    TriggerServerEvent("hospital:server:RestoreWeaponDamage")

    local ped = GetPlayerPed(-1)
    SetEntityMaxHealth(ped, 200)
    SetEntityHealth(ped, 200)
    ClearPedBloodDamage(player)
    SetPlayerSprint(PlayerId(), true)

    ResetAll()
    ResetPedMovementClipset(PlayerPedId())
    
    TriggerServerEvent('lcrp-hud:Server:RelieveStress', 100)
    TriggerServerEvent("hospital:server:SetDeathStatus", false)
    TriggerServerEvent("hospital:server:SetLaststandStatus", false)
    TriggerScreenblurFadeOut(100)
    scCore.Notification("You're back alive!")
end)

RegisterNetEvent('hospital:client:SetPain')
AddEventHandler('hospital:client:SetPain', function()
    ApplyBleed(math.random(1,4))
    if not BodyParts[Config.Bones[24816]].isDamaged then
        BodyParts[Config.Bones[24816]].isDamaged = true
        BodyParts[Config.Bones[24816]].severity = math.random(1, 4)
        table.insert(injured, {
            part = Config.Bones[24816],
            label = BodyParts[Config.Bones[24816]].label,
            severity = BodyParts[Config.Bones[24816]].severity
        })
    end

    if not BodyParts[Config.Bones[40269]].isDamaged then
        BodyParts[Config.Bones[40269]].isDamaged = true
        BodyParts[Config.Bones[40269]].severity = math.random(1, 4)
        table.insert(injured, {
            part = Config.Bones[40269],
            label = BodyParts[Config.Bones[40269]].label,
            severity = BodyParts[Config.Bones[40269]].severity
        })
    end

    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })
end)

RegisterNetEvent('hospital:client:KillPlayer')
AddEventHandler('hospital:client:KillPlayer', function()
    SetEntityHealth(GetPlayerPed(-1), 0)
end)

RegisterNetEvent('hospital:client:HealInjuries')
AddEventHandler('hospital:client:HealInjuries', function(type)
    if type == "full" then
        ResetAll()
    else
        ResetPartial()
    end
    TriggerServerEvent("hospital:server:RestoreWeaponDamage")
    scCore.Notification("Your wounds have been healed!")
end)

RegisterNetEvent('hospital:client:SendToPrisonBed')
AddEventHandler('hospital:client:SendToPrisonBed', function(coords)
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end

    TriggerEvent("hospital:client:Revive")
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, 0, 0, 0, false)
    SetEntityHeading(PlayerPedId(), coords.h)
    TriggerEvent('animations:client:EmoteCommandStart', {"bumsleep"})
    Citizen.Wait(100)

    DoScreenFadeIn(1000)
end)

RegisterNetEvent('hospital:client:SendToBed')
AddEventHandler('hospital:client:SendToBed', function(id, data, isRevive)
    bedOccupying = id
    bedOccupyingData = data
    SetBedCam()
    Citizen.CreateThread(function ()
        Citizen.Wait(5)
        local player = PlayerPedId()
        if isRevive then

            scCore.TaskBar("bed_treating", "You are being treated", Config.AIHealTimer * 1000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
                disableCancel = true
            }, {
            }, {}, {}, function() -- Done

                TriggerEvent("hospital:client:Revive")
                

            end, function() -- Cancel

            end)

            
        else
            canLeaveBed = true
        end
    end)
end)

RegisterNetEvent('hospital:client:SetBed')
AddEventHandler('hospital:client:SetBed', function(id, isTaken, hospital)
    if hospital == 1 then
        Config.Locations["beds"][id].taken = isTaken
    elseif hospital == 2 then
        Config.Locations["sandyBeds"][id].taken = isTaken
    elseif hospital == 3 then
        Config.Locations["paletoBeds"][id].taken = isTaken
    end
end)


RegisterNetEvent('hospital:client:RespawnAtHospital')
AddEventHandler('hospital:client:RespawnAtHospital', function()
    TriggerServerEvent("hospital:server:RespawnAtHospital")
    TriggerEvent("police:client:DeEscort")
end)

RegisterNetEvent('hospital:client:SendBillEmail')
AddEventHandler('hospital:client:SendBillEmail', function(amount)
    SetTimeout(math.random(2500, 4000), function()
        local gender = "sir"
        if scCore.Functions.GetPlayerData().charinfo.gender == 1 then
            gender = "Mrs"
        end
        local charinfo = scCore.Functions.GetPlayerData().charinfo
        TriggerServerEvent('lcrp-phone:server:sendNewMail', {
            sender = "Pillbox",
            subject = "Hospital Costs",
            message = "Dear " .. gender .. " " .. charinfo.lastname .. ",<br /><br /> We are sending you email to inform about your wound costs.<br />The final costs are: <strong>$"..amount.."</strong><br /><br />Thank you!",
            button = {}
        })
    end)
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = false
    --TriggerServerEvent("hospital:server:SetDoctor")
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    exports.spawnmanager:setAutoSpawn(false)
    local ped = GetPlayerPed(-1)
    SetEntityMaxHealth(ped, 200)
    SetEntityHealth(ped, 200)
    isLoggedIn = true
    --TriggerServerEvent("hospital:server:SetDoctor")
    --TriggerServerEvent("hospital:server:UpdateCurrentEMS")
    Citizen.CreateThread(function()
        Wait(1000)
        scCore.Functions.GetPlayerData(function(PlayerData)
            PlayerJob = PlayerData.job
            PlayerJobGrade = PlayerJob.grade
            if scCore.Shared.Jobs[PlayerJob.name].roles ~= nil then 
                PlayerJobRole = scCore.Shared.Jobs[PlayerJob.name].roles[PlayerJob.grade]
            end
            onDuty = PlayerData.job.onduty
            SetPedArmour(GetPlayerPed(-1), PlayerData.metadata["armor"])
            if PlayerJob.name == "ambulance" and onDuty then
                TriggerServerEvent("hospital:server:UpdateCurrentEMS", 1)
            else
                TriggerServerEvent("hospital:server:UpdateCurrentEMS", 0)
            end
            if PlayerJob.name == "ambulance" and PlayerJobGrade > 1 and onDuty then
                TriggerEvent("hospital:client:SetDoctorMission", false)
            end
            if (not PlayerData.metadata["inlaststand"] and PlayerData.metadata["isdead"]) then
                local player = PlayerId()
                local playerPed = PlayerPedId()
                deathTime = Laststand.ReviveInterval
                OnDeath(true)
                DeathTimer()
            elseif (PlayerData.metadata["inlaststand"] and not PlayerData.metadata["isdead"]) then
                SetLaststand(true, true)
            else
                TriggerServerEvent("hospital:server:SetDeathStatus", false)
                TriggerServerEvent("hospital:server:SetLaststandStatus", false)
            end
        end)
    end)
end)

RegisterNetEvent("hospital:client:SetEMSCount")
AddEventHandler("hospital:client:SetEMSCount", function(amount)
    EMSCount = amount
end)


RegisterNetEvent('scCore:Client:SetDuty')
AddEventHandler('scCore:Client:SetDuty', function(duty)
    onDuty = duty
    scCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        PlayerJobGrade = PlayerJob.grade
        if PlayerJob.name == "ambulance" and PlayerJobGrade > 1 and onDuty then
            TriggerEvent("hospital:client:SetDoctorMission", true)
        end
    end)
end)

-- This doesn't do shiet anyway, only called on logout and logout is rarely called since no1 logs out on their house.
RegisterNetEvent('scCore:Client:OnPlayerUnload')
AddEventHandler('scCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    TriggerServerEvent("hospital:server:SetDeathStatus", false)
    TriggerServerEvent('hospital:server:SetLaststandStatus', false)
    TriggerServerEvent("hospital:server:SetArmor", GetPedArmour(GetPlayerPed(-1)))
    if bedOccupying ~= nil then 
        TriggerServerEvent("hospital:server:LeaveBed", bedOccupying, currentHospital)
    end
    isDead = false
    deathTime = 0
    SetEntityInvincible(GetPlayerPed(-1), false)
    SetPedArmour(GetPlayerPed(-1), 0)
    TriggerServerEvent("hospital:server:UpdateCurrentEMS",-1)
    ResetAll()
end)

function GetDamagingWeapon(ped)
    for k, v in pairs(Config.Weapons) do
        if HasPedBeenDamagedByWeapon(ped, k, 0) then
            ClearEntityLastDamageEntity(ped)
            return v
        end
    end

    return nil
end

function IsDamagingEvent(damageDone, weapon)
    math.randomseed(GetGameTimer())
    local luck = math.random(100)
    local multi = damageDone / Config.HealthDamage

    return luck < (Config.HealthDamage * multi) or (damageDone >= Config.ForceInjury or multi > Config.MaxInjuryChanceMulti or Config.ForceInjuryWeapons[weapon])
end

function DoLimbAlert()
    local player = PlayerPedId()
    if not isDead then
        if #injured > 0 then
            local limbDamageMsg = ''
            if #injured <= Config.AlertShowInfo then
                for k, v in pairs(injured) do
                    limbDamageMsg = limbDamageMsg .. "Your " .. v.label .. " feels "..Config.WoundStates[v.severity]
                    if k < #injured then
                        limbDamageMsg = limbDamageMsg .. " | "
                    end
                end
            else
                limbDamageMsg = "You feel pain in many places"
            end
            scCore.Notification(limbDamageMsg, "primary", 5000)
        end
    end
end

function DoBleedAlert()
    local player = PlayerPedId()
    if not isDead and tonumber(isBleeding) > 0 then
        scCore.Notification("You're "..Config.BleedingStates[tonumber(isBleeding)].label, "error", 5000)
    end
end

function IsInjuryCausingLimp()
    for k, v in pairs(BodyParts) do
        if v.causeLimp and v.isDamaged then
            return true
        end
    end

    return false
end

function SetClosestBed() 
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil
    for k, v in pairs(Config.Locations["beds"]) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, Config.Locations["beds"][k].x, Config.Locations["beds"][k].y, Config.Locations["beds"][k].z, true) < dist)then
                current = k
                dist = GetDistanceBetweenCoords(pos, Config.Locations["beds"][k].x, Config.Locations["beds"][k].y, Config.Locations["beds"][k].z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, Config.Locations["beds"][k].x, Config.Locations["beds"][k].y, Config.Locations["beds"][k].z, true)
            current = k
        end
    end
    if current ~= closestBed and not isInHospitalBed then
        closestBed = current
    end
end

function ResetPartial()
    for k, v in pairs(BodyParts) do
        if v.isDamaged and v.severity <= 2 then
            v.isDamaged = false
            v.severity = 0
        end
    end

    for k, v in pairs(injured) do
        if v.severity <= 2 then
            v.severity = 0
            table.remove(injured, k)
        end
    end

    if isBleeding <= 2 then
        isBleeding = 0
        bleedTickTimer = 0
        advanceBleedTimer = 0
        fadeOutTimer = 0
        blackoutTimer = 0
    end
    
    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })

    ProcessRunStuff(PlayerPedId())
    DoLimbAlert()
    DoBleedAlert()

    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })
end

function ResetAll()
    isBleeding = 0
    bleedTickTimer = 0
    advanceBleedTimer = 0
    fadeOutTimer = 0
    blackoutTimer = 0
    onDrugs = 0
    wasOnDrugs = false
    onPainKiller = 0
    wasOnPainKillers = false
    injured = {}

    for k, v in pairs(BodyParts) do
        v.isDamaged = false
        v.severity = 0
    end
    
    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })

    CurrentDamageList = {}
    TriggerServerEvent('hospital:server:SetWeaponDamage', CurrentDamageList)

    ProcessRunStuff(PlayerPedId())
    DoLimbAlert()
    DoBleedAlert()

    TriggerServerEvent('hospital:server:SyncInjuries', {
        limbs = BodyParts,
        isBleeding = tonumber(isBleeding)
    })
    TriggerServerEvent("scCore:Server:SetMetaData", "hunger", 100)
    TriggerServerEvent("scCore:Server:SetMetaData", "thirst", 100)
end

function SetBedCam()
    isInHospitalBed = true
    canLeaveBed = false
    local player = PlayerPedId()

    DoScreenFadeOut(1000)

    while not IsScreenFadedOut() do
        Citizen.Wait(100)
    end

	if IsPedDeadOrDying(player) then
		local playerPos = GetEntityCoords(player, true)
		NetworkResurrectLocalPlayer(playerPos, true, true, false)
    end
    
    bedObject = GetClosestObjectOfType(bedOccupyingData.x, bedOccupyingData.y, bedOccupyingData.z, 1.0, bedOccupyingData.model, false, false, false)
    FreezeEntityPosition(bedObject, true)

    SetEntityCoords(player, bedOccupyingData.x, bedOccupyingData.y, bedOccupyingData.z + 0.02)
    --SetEntityInvincible(PlayerPedId(), true)
    Citizen.Wait(500)
    FreezeEntityPosition(player, true)

    loadAnimDict(inBedDict)

    TaskPlayAnim(player, inBedDict , inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
    SetEntityHeading(player, bedOccupyingData.h)

    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    AttachCamToPedBone(cam, player, 31085, 0, 1.0, 1.0 , true)
    SetCamFov(cam, 90.0)
    SetCamRot(cam, -45.0, 0.0, GetEntityHeading(player) + 180, true)

    DoScreenFadeIn(1000)

    Citizen.Wait(1000)
    FreezeEntityPosition(player, true)
end

function LeaveBed()
    local player = PlayerPedId()

    RequestAnimDict(getOutDict)
    while not HasAnimDictLoaded(getOutDict) do
        Citizen.Wait(0)
    end
    
    FreezeEntityPosition(player, false)
    SetEntityInvincible(player, false)
    SetEntityHeading(player, bedOccupyingData.h + 90)
    TaskPlayAnim(player, getOutDict , getOutAnim, 100.0, 1.0, -1, 8, -1, 0, 0, 0)
    Citizen.Wait(4000)
    ClearPedTasks(player)
    TriggerServerEvent('hospital:server:LeaveBed', bedOccupying, currentHospital)
    FreezeEntityPosition(bedObject, true)

    
    RenderScriptCams(0, true, 200, true, true)
    DestroyCam(cam, false)

    bedOccupying = nil
    bedObject = nil
    bedOccupyingData = nil
    isInHospitalBed = false
end

function MenuOutfits()
    ped = GetPlayerPed(-1);
    MenuTitle = "Outfits"
    ClearMenu()
    Menu.addButton("My Outfits", "OutfitsList", nil)
    Menu.addButton("Close Menu", "closeMenuFull", nil) 
end

function changeOutfit()
	Wait(200)
    loadAnimDict("clothingshirt")    	
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
	Wait(3100)
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

function optionMenu(outfitData)
    ped = GetPlayerPed(-1);
    MenuTitle = "Options"
    ClearMenu()

    Menu.addButton("Choose Outfit", "selectOutfit", outfitData) 
    Menu.addButton("Delete Outfit", "removeOutfit", outfitData) 
    Menu.addButton("Back", "OutfitsList",nil)
end

function selectOutfit(oData)
    TriggerServerEvent('clothes:selectOutfit', oData.model, oData.skin)
    scCore.Notification(oData.outfitname.." selected", "primary", 2500)
    closeMenuFull()
    changeOutfit()
end

function removeOutfit(oData)
    TriggerServerEvent('clothes:removeOutfit', oData.outfitname)
    scCore.Notification(oData.outfitname.." has been removed", "primary", 2500)
    closeMenuFull()
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

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

function loadAnimDict(dict)
	while(not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end



