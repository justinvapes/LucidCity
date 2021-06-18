local robberyAlert = false
local firstAlarm = false
local closestVitrine = nil
local storeDist



function StartIsNearJewelleyThread()
    Citizen.CreateThread(function()
        while true do
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            inRange = false
    
            if scCore ~= nil then
                if isLoggedIn then
                    PlayerData = scCore.Functions.GetPlayerData()
                    storeDist = GetDistanceBetweenCoords(pos, Config.JewelleryLocation["coords"]["x"], Config.JewelleryLocation["coords"]["y"], Config.JewelleryLocation["coords"]["z"])
                    if storeDist < 25 then
                        for case,_ in pairs(Config.Locations) do
                            local dist = GetDistanceBetweenCoords(pos, Config.Locations[case]["coords"]["x"], Config.Locations[case]["coords"]["y"], Config.Locations[case]["coords"]["z"])
                            if dist < 1 then
                                inRange = true
                                closestVitrine = case
                            end
                        end
                    end
                    if storeDist < 2 then
                        if not firstAlarm then
                            if validWeapon() then
                                TriggerServerEvent('lcrp-robberies:server:PoliceAlertMessage', 'Suspicious person at Vangelico Jewellry store', pos, true)
                                firstAlarm = true
                            end
                        end
                    end
                end
            end
    
            if not inRange then
                closestVitrine = nil
                Citizen.Wait(1000)
            end
    
            Citizen.Wait(3)
        end
    end)
end


function IsNearJewelleryVitrine()
    if closestVitrine ~= nil and Config.Locations[closestVitrine] ~= nil and not Config.Locations[closestVitrine]["isBusy"] and not Config.Locations[closestVitrine]["isOpened"] then
        local vitrinePos = Config.Locations[closestVitrine].coords
        if CurrentCops >= Config.RequiredCops then
            return {retval = true, vitrine = closestVitrine, vitrinePos = {x = vitrinePos.x, y = vitrinePos.y, z = vitrinePos.z} }
        else
            return {retval = false, reason = "Not enough cops in town", vitrinePos = {x = vitrinePos.x, y = vitrinePos.y, z = vitrinePos.z} }
        end
    end
    return {retval = false}
end

function IsNearJewelleryStore()
    if storeDist < 25 and closestVitrine ~= nil and Config.Locations[closestVitrine] ~= nil and not Config.Locations[closestVitrine]["isBusy"] and not Config.Locations[closestVitrine]["isOpened"] then
        return true
    end
    return false
end

-- LEGIT CHECKS FOR STUPID LUA EXECUTORS
function iLikeThisGuy(uGoodYes)
    TriggerServerEvent("lcrp-robberies:server:JewellryCheckIfLegit", uGoodYes)
end

function loadParticle()
	if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
    RequestNamedPtfxAsset("scr_jewelheist")
    end
    while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
    Citizen.Wait(0)
    end
    SetPtfxAssetNextCall("scr_jewelheist")
end

function loadAnimDict(dict)  
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(3)
    end
end

function validWeapon()
    local ped = GetPlayerPed(-1)
    local pedWeapon = GetSelectedPedWeapon(ped)

    for k, v in pairs(Config.WhitelistedWeapons) do
        if pedWeapon == k then
            return true
        end
    end
    return false
end

function smashVitrine(k)
    local animDict = "missheist_jewel"
    local animName = "smash_case"
    local ped = GetPlayerPed(-1)
    local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.6, 0)
    local pedWeapon = GetSelectedPedWeapon(ped)
    uGoodYes = true

    if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", plyCoords)
    elseif math.random(1, 100) <= 5 and IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", plyCoords)
        scCore.Notification("You broke the glass", "error")
    end

    scCore.TaskBar("smash_vitrine", "Smashing glass", Config.WhitelistedWeapons[pedWeapon]["timeOut"], false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("lcrp-robberies:server:LockJewellryDoor")
        iLikeThisGuy(uGoodYes)
        TriggerServerEvent('lcrp-robberies:server:setVitrineState', "isOpened", true, k)
        TriggerServerEvent('lcrp-robberies:server:setVitrineState', "isBusy", false, k)
        TriggerServerEvent('lcrp-robberies:server:setTimeout')
        TriggerEvent("lcrp-weazelnews:client:CrimeStatistics", "robbery", 1)
        TriggerServerEvent('lcrp-robberies:server:PoliceAlertMessage', "Armed Robbery at Vangelico Jeweler", plyCoords, false)
        TaskPlayAnim(ped, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end, function() -- Cancel
        TriggerServerEvent('lcrp-robberies:server:setVitrineState', "isBusy", false, k)
        TaskPlayAnim(ped, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end)
    TriggerServerEvent('lcrp-robberies:server:setVitrineState', "isBusy", true, k)
    loadAnimDict(animDict)
    TaskPlayAnim(ped, animDict, animName, 3.0, 3.0, -1, 2, 0, 0, 0, 0 )
    Citizen.Wait(500)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "breaking_vitrine_glass", 0.25)
    loadParticle()
    StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", plyCoords.x, plyCoords.y, plyCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
end

-- MORE LEGIT CHECKS FOR STUPID LUA EXECUTORS
RegisterNetEvent('lcrp-robberies:client:moreLegitCheck')
AddEventHandler('lcrp-robberies:client:moreLegitCheck', function(isGood)
    TriggerServerEvent('lcrp-robberies:server:vitrineReward', isGood)
end)

RegisterNetEvent('lcrp-robberies:client:setVitrineState')
AddEventHandler('lcrp-robberies:client:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
end)

RegisterNetEvent('lcrp-robberies:client:setAlertState')
AddEventHandler('lcrp-robberies:client:setAlertState', function(bool)
    robberyAlert = bool
end)

RegisterNetEvent('lcrp-robberies:client:PoliceAlertMessage')
AddEventHandler('lcrp-robberies:client:PoliceAlertMessage', function(msg, coords, blip)
    if blip then
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        TriggerEvent("chatMessage", "911-MELDING", "error", msg)
        local transG = 100
        local blip = AddBlipForRadius(coords.x, coords.y, coords.z, 100.0)
        SetBlipSprite(blip, 9)
        SetBlipColour(blip, 1)
        SetBlipAlpha(blip, transG)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Jewelry Store Robbery")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    else
        if not robberyAlert then
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            TriggerEvent("chatMessage", "911-MELDING", "error", msg)
            robberyAlert = true
        end
    end
end)

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(GetPlayerPed(-1), 3)
    local model = GetEntityModel(GetPlayerPed(-1))
    local retval = true
    if model == GetHashKey("mp_m_freemode_01") then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

function CheckFirstAlarm()
    if not firstAlarm then
        if validWeapon() then
            TriggerServerEvent('lcrp-robberies:server:PoliceAlertMessage', 'Suspicious person at Vangelico Jewellry store', pos, true)
            firstAlarm = true
        end
    end
end

RegisterNetEvent("lcrp-robberies:client:breakVitrine")
AddEventHandler("lcrp-robberies:client:breakVitrine", function(case)
    local pos = GetEntityCoords(PlayerPedId())
    local case = case.vitrine
    local dist = GetDistanceBetweenCoords(pos, Config.Locations[case]["coords"]["x"], Config.Locations[case]["coords"]["y"], Config.Locations[case]["coords"]["z"])
    CheckFirstAlarm()
    if dist < 25 then
        if not Config.Locations[case]["isBusy"] and not Config.Locations[case]["isOpened"] then
            if CurrentCops >= Config.RequiredCops then
                if validWeapon() then
                    local plyID = PlayerPedId()
                    local plyHeading = GetEntityHeading(plyID)
                    

                    TaskGoStraightToCoord(plyID, Config.Locations[case]["coords"]["x"], Config.Locations[case]["coords"]["y"], Config.Locations[case]["coords"]["z"], 1.0, -1, plyHeading, 0.0) -- go to the coord
                    Citizen.Wait(700)
                    SetEntityCoords(plyID, Config.Locations[case]["coords"]["x"], Config.Locations[case]["coords"]["y"], Config.Locations[case]["coords"]["z"] - 1.0)
                
                    smashVitrine(case)
                else
                    scCore.Notification('Your weapon doesn\'t seem strong enough', 'error')
                end
            else
                scCore.Notification('There are not enough police in town', 'error')
            end 
        end
    end
end)