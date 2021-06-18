--[[ 
local requiredItems = {
    [1] = {name = scCore.Shared.Items["electronickit"]["name"], image = scCore.Shared.Items["electronickit"]["image"]},
    [2] = {name = scCore.Shared.Items["trojan_usb"]["name"], image = scCore.Shared.Items["trojan_usb"]["image"]},
} 
]]

RegisterNetEvent('lcrp-robberies:client:openLocker')
AddEventHandler('lcrp-robberies:client:openLocker', function(data)
    local retval = CanOpenLockerAtBankRobbery()
    local bankLocker = Config.Banks[data.closestBank].lockers[data.locker]
   
    if IsInOpenBankRobbery() and retval then
        if not bankLocker.isBusy and not bankLocker.isOpened then
            openLocker(data.closestBank, data.locker)
        else
            scCore.Notification("Someone is already on it!")
        end
    end
end)


RegisterNetEvent('lcrp-robberies:client:enableAllBankSecurity')
AddEventHandler('lcrp-robberies:client:enableAllBankSecurity', function()
    for k, v in pairs(Config.Banks) do
        Config.Banks[k]["alarm"] = true
    end
end)

RegisterNetEvent('lcrp-robberies:client:disableAllBankSecurity')
AddEventHandler('lcrp-robberies:client:disableAllBankSecurity', function()
    for k, v in pairs(Config.Banks) do
        Config.Banks[k]["alarm"] = false
    end
end)

RegisterNetEvent('lcrp-robberies:client:BankSecurity')
AddEventHandler('lcrp-robberies:client:BankSecurity', function(key, status)
    Config.Banks[key]["alarm"] = status
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

function ResetBankDoors()
    for k, v in pairs(Config.Banks) do
        if not Config.Banks[k]["isOpened"] then
            local object = GetClosestObjectOfType(Config.Banks[k]["coords"]["x"], Config.Banks[k]["coords"]["y"], Config.Banks[k]["coords"]["z"], 5.0, Config.Banks[k]["object"], false, false, false)
            SetEntityHeading(object, Config.Banks[k]["heading"].closed)
        end
    end
end

function openLocker(bankId, lockerId)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    if math.random(1, 100) <= 65 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    TriggerServerEvent('lcrp-robberies:server:setLockerState', bankId, lockerId, 'isBusy', true)
    if type(bankId) == "number" then
        scCore.TaskBar("open_locker", "Lockpicking safe...", math.random(8000, 16000), false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@gangops@facility@servers@",
            anim = "hotwire",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
            TriggerServerEvent('lcrp-robberies:server:setLockerState', bankId, lockerId, 'isBusy', false)
            AwesomeFleeca(bankId, lockerId)
            --TriggerServerEvent('lcrp-robberies:server:recieveItem', 'small')
            scCore.Notification("Successful!", "success")
        end, function() -- Cancel
            StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
            TriggerServerEvent('lcrp-robberies:server:setLockerState', bankId, lockerId, 'isBusy', false)
            scCore.Notification("Canceled", "error")
        end)
    else
        scCore.TriggerServerCallback('lcrp-radio:server:GetItem', function(hasItem)
            if hasItem then
                loadAnimDict("anim@heists@fleeca_bank@drilling")
                TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
                local pos = GetEntityCoords(GetPlayerPed(-1), true)
                local DrillObject = CreateObject(GetHashKey("hei_prop_heist_drill"), pos.x, pos.y, pos.z, true, true, true)
                AttachEntityToEntity(DrillObject, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
                scCore.TaskBar("open_locker_drill", "Drilling the safe...", math.random(20000, 40000), false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    StopAnimTask(GetPlayerPed(-1), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                    DetachEntity(DrillObject, true, true)
                    DeleteObject(DrillObject)
                    TriggerServerEvent('lcrp-robberies:server:setLockerState', bankId, lockerId, 'isBusy', false)
                    AwesomeFleeca('paleto', lockerId)
                    --TriggerServerEvent('lcrp-robberies:server:recieveItem', 'paleto')
                    scCore.Notification("Successful!", "success")
                end, function() -- Cancel
                    StopAnimTask(GetPlayerPed(-1), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                    TriggerServerEvent('lcrp-robberies:server:setLockerState', bankId, lockerId, 'isBusy', false)
                    DetachEntity(DrillObject, true, true)
                    DeleteObject(DrillObject)
                    scCore.Notification("Canceled", "error")
                end)
            else
                scCore.Notification("Looks like the safe lock is too strong", "error")
                TriggerServerEvent('lcrp-robberies:server:setLockerState', bankId, lockerId, 'isBusy', false)
            end
        end, "drill")
    end
end

RegisterNetEvent('lcrp-robberies:client:setLockerState')
AddEventHandler('lcrp-robberies:client:setLockerState', function(bankId, lockerId, state, bool)
    Config.Banks[bankId]["lockers"][lockerId][state] = bool
end)

RegisterNetEvent('lcrp-robberies:client:robberyCall')
AddEventHandler('lcrp-robberies:client:robberyCall', function(key, streetLabel, coords)
    if PlayerJob.name == "police" or PlayerJob.name == "statepolice" or PlayerJob.name == "fib" and onDuty then 
        local cameraId = 4
        local bank = "Fleeca"
        if type(key) == "number" then
            cameraId = Config.Banks[key]["camId"]
            bank = "Fleeca"
            PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            TriggerEvent("chatMessage", "911-MELDING", "error", "Camera alert has been triggered at bank: "..bank.. " " ..streetLabel.." (CAMERA ID: "..cameraId..")")
        else
            if key == "paleto" then
                cameraId = Config.Banks["paleto"]["camId"]
                bank = "Blaine County Savings"
                PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
                Citizen.Wait(100)
                PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                Citizen.Wait(100)
                PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
                Citizen.Wait(100)
                PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                TriggerEvent("chatMessage", "911-MELDING", "error", "Camera alert has been triggered at bank: "..bank.. " Paleto Bay (CAMERA ID: "..cameraId..")")
            elseif key == "pacific" then
                bank = "Pacific Standard Bank"
                PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
                Citizen.Wait(100)
                PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                Citizen.Wait(100)
                PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
                Citizen.Wait(100)
                PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                TriggerEvent("chatMessage", "911-MELDING", "error", "Camera alert has been triggered at bank: "..bank.. " Alta St (CAMERA ID: 1/2/3)")
            end
        end
        local transG = 250
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 487)
        SetBlipColour(blip, 4)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 1.2)
        SetBlipFlashes(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("911: Bank robbery")
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
    end
end)

function OnHackDone(success, timeremaining)
    if success then
        TriggerEvent('mhacking:hide')
        TriggerServerEvent('lcrp-robberies:server:setBankState', closestBank, true)
    else
		TriggerEvent('mhacking:hide')
	end
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function searchPockets()
    if ( DoesEntityExist( GetPlayerPed(-1) ) and not IsEntityDead( GetPlayerPed(-1) ) ) then 
        loadAnimDict( "random@mugging4" )
        TaskPlayAnim( GetPlayerPed(-1), "random@mugging4", "agitated_loop_a", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
    end
end

function giveAnim()
    if ( DoesEntityExist( GetPlayerPed(-1) ) and not IsEntityDead( GetPlayerPed(-1) ) ) then 
        loadAnimDict( "mp_safehouselost@" )
        if ( IsEntityPlayingAnim( GetPlayerPed(-1), "mp_safehouselost@", "package_dropoff", 3 ) ) then 
            TaskPlayAnim( GetPlayerPed(-1), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        else
            TaskPlayAnim( GetPlayerPed(-1), "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
        end     
    end
end

function AwesomeFleeca(bankType,lockerId)
    TriggerServerEvent('lcrp-robberies:server:recieveItem', bankType, lockerId)
end