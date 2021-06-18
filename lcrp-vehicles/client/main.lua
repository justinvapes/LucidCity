local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

scCore = nil

local beingScrapped = {}
local hasBeenUnlocked = {}
local HasKey = false
local LastVehicle = nil
local IsHotwiring = false
local IsRobbing = false
local isLoggedIn = true
local windowup = true

local closestScrapyard = 0
local emailSend = false
local isBusy = false

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(-448.64, -1713.84, 18.73)
    SetBlipSprite(blip, 380)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 40)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Scrap yard")
    EndTextCommandSetBlipName(blip)
    Citizen.Wait(1000)
    while true do
        SetClosestScrapyard()
        Citizen.Wait(10000)
    end
end)

local isChecking = false

Citizen.CreateThread(function()
    while true do
        sleep = 500
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), true), -1) == GetPlayerPed(-1) and scCore ~= nil then
            sleep = 5
            
            local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), true))
            if LastVehicle ~= plate and not isChecking then
                isChecking = true
                scCore.TriggerServerCallback('vehiclekeys:CheckHasKey', function(result)
                    if result then
                        HasKey = true
                        SetVehicleEngineOn(veh, true, false, true)
                    else
                        HasKey = false
                        SetVehicleEngineOn(veh, false, false, true)
                    end
                    LastVehicle = plate
                    isChecking = false
                end, plate)
            end
        end

        if not HasKey and IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) and scCore ~= nil and not IsHotwiring then
            local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            local vehClass = GetVehicleClass(veh)

            if vehClass ~= 13 then
                SetVehicleEngineOn(veh, false, false, true)
                local vehpos = GetOffsetFromEntityInWorldCoords(veh, 0, 1.5, 0.5)
                scCore.Draw3DText(vehpos.x, vehpos.y, vehpos.z, "[~r~H~w~] - Hotwire")

                if IsControlJustPressed(0, Keys["H"]) then
                    Hotwire()
                end
            end
        end

        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if not IsRobbing and isLoggedIn and scCore ~= nil then
            if GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) ~= nil and GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) ~= 0 then
                local vehicle = GetVehiclePedIsTryingToEnter(GetPlayerPed(-1))
                local driver = GetPedInVehicleSeat(vehicle, -1)
                if driver ~= 0 and not IsPedAPlayer(driver) then
                    if IsEntityDead(driver) then
                        IsRobbing = true
                        scCore.TaskBar("rob_keys", "Taking keys", 3000, false, true, {}, {}, {}, {}, function() -- Done
                            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
                            HasKey = true
                            IsRobbing = false
                        end)
                    end
                end
            end


            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
                if aiming then
                    --print("YES AIMING")
                 if DoesEntityExist(targetPed) and not IsPedAPlayer(targetPed) and IsPedArmed(PlayerPedId(), 7) then
                  local vehicle = GetVehiclePedIsIn(targetPed, false)
                  local plate = GetVehicleNumberPlateText(vehicle)
                  local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), GetEntityCoords(vehicle, true), false)
             
                  if distance < 10 and IsPedFacingPed(targetPed, PlayerPedId(), 60.0) then
             
                  SetVehicleForwardSpeed(vehicle, 0)
             
                  hasBeenUnlocked[plate] = false
             
                  SetVehicleForwardSpeed(vehicle, 0)
                  TaskLeaveVehicle(targetPed, vehicle, 256)
                  --TriggerEvent('vehicle:RobbingVehicle')
             
                  while IsPedInAnyVehicle(targetPed, false) do
                   Citizen.Wait(5)
                  end
             
                  RequestAnimDict('missfbi5ig_22')
                  RequestAnimDict('mp_common')
             
                  SetPedDropsWeaponsWhenDead(targetPed,false)
                  ClearPedTasks(targetPed)
                  TaskTurnPedToFaceEntity(targetPed, GetPlayerPed(-1), 3.0)
                  TaskSetBlockingOfNonTemporaryEvents(targetPed, true)
                  SetPedFleeAttributes(targetPed, 0, 0)
                  SetPedCombatAttributes(targetPed, 17, 1)
                  SetPedSeeingRange(targetPed, 0.0)
                  SetPedHearingRange(targetPed, 0.0)
                  SetPedAlertness(targetPed, 0)
                  SetPedKeepTask(targetPed, true)
             
                  TaskPlayAnim(targetPed, "missfbi5ig_22", "hands_up_anxious_scientist", 8.0, -8, -1, 12, 1, 0, 0, 0)
                  Wait(1500)
                  TaskPlayAnim(targetPed, "missfbi5ig_22", "hands_up_anxious_scientist", 8.0, -8, -1, 12, 1, 0, 0, 0)
                  Wait(2500)
             
                  local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), GetEntityCoords(vehicle, true), false)
             
                  if not IsEntityDead(targetPed) and distance < 12 then
                   hasBeenUnlocked[plate] = true
                   TaskPlayAnim(targetPed, "mp_common", "givetake1_a", 8.0, -8, -1, 12, 1, 0, 0, 0)

                scCore.TaskBar("rob_keys", "Taking keys", 2000, false, true, {}, {}, {}, {}, function() -- Done
                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
                    HasKey = true
                    scCore.Notification('You have been handed the keys!')
                end)

                   Citizen.Wait(500)
                   TaskReactAndFleePed(targetPed, GetPlayerPed(-1))
                   SetPedKeepTask(targetPed, true)
                   Wait(2500)
                   TaskReactAndFleePed(targetPed, GetPlayerPed(-1))
                   SetPedKeepTask(targetPed, true)
                   Wait(2500)
                   TaskReactAndFleePed(targetPed, GetPlayerPed(-1))
                   SetPedKeepTask(targetPed, true)
                   Wait(2500)
                   TaskReactAndFleePed(targetPed, GetPlayerPed(-1))
                   SetPedKeepTask(targetPed, true)
                   end
                  end
                 end
                end
            end

        end
    end
end)

RegisterNetEvent('lcrp-vehicles:client:washCar')
AddEventHandler('lcrp-vehicles:client:washCar', function()
    local PlayerPed = GetPlayerPed(-1)
    local PedVehicle = GetVehiclePedIsIn(PlayerPed)
    local Driver = GetPedInVehicleSeat(PedVehicle, -1)

    washingVehicle = true

    scCore.TaskBar("search_cabin", "Vehicle is being washed", math.random(4000, 8000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        SetVehicleDirtLevel(PedVehicle)
        SetVehicleUndriveable(PedVehicle, false)
        WashDecalsFromVehicle(PedVehicle, 1.0)
        washingVehicle = false
    end, function() -- Cancel
        scCore.Notification("Washing canceled", "error")
        washingVehicle = false
    end)
end)

Citizen.CreateThread(function()
    carWash = AddBlipForCoord(29.63, -1391.92, 28.62)

    SetBlipSprite (carWash, 100)
    SetBlipDisplay(carWash, 4)
    SetBlipScale  (carWash, 0.75)
    SetBlipAsShortRange(carWash, true)
    SetBlipColour(carWash, 37)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Car Wash")
    EndTextCommandSetBlipName(carWash)
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("lcrp-vehicles:server:LoadVehicleList")
    isLoggedIn = true
end)

RegisterNetEvent('scCore:Client:OnPlayerUnload')
AddEventHandler('scCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('vehiclekeys:client:SetOwner')
AddEventHandler('vehiclekeys:client:SetOwner', function(plate)
    local VehPlate = plate
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, true)
    if VehPlate == nil then
        VehPlate = GetVehicleNumberPlateText(vehicle)
    end
    TriggerServerEvent('vehiclekeys:server:SetVehicleOwner', VehPlate)
    while isChecking do
        Citizen.Wait(0)
    end
    LastVehicle = VehPlate
    HasKey = true
    SetVehicleEngineOn(vehicle, true, true)
end)

RegisterNetEvent('vehiclekeys:client:GiveKeys')
AddEventHandler('vehiclekeys:client:GiveKeys', function()
    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), true))
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local target = GetPlayerServerId(player)

        TriggerServerEvent('vehiclekeys:server:GiveVehicleKeys', plate, target)
    else
        scCore.Notification("No player close by!", "error")
    end
end)

RegisterNetEvent('vehiclekeys:client:ToggleEngine')
AddEventHandler('vehiclekeys:client:ToggleEngine', function()
    local EngineOn = IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1)))
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), true)
    if HasKey then
        if EngineOn then
            SetVehicleEngineOn(veh, false, false, true)
        else
            SetVehicleEngineOn(veh, true, false, true)
        end
    end
end)

RegisterNetEvent("vehiclekeys:client:RollWindow")
AddEventHandler('vehiclekeys:client:RollWindow', function()
    local playerPed = GetPlayerPed(-1)
    if IsPedInAnyVehicle(playerPed, false) then
        local playerCar = GetVehiclePedIsIn(playerPed, false)
		if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then 
            SetEntityAsMissionEntity( playerCar, true, true)
			if windowup then
				RollDownWindow(playerCar, 0)
				RollDownWindow(playerCar, 1)
				windowup = false
			else
				RollUpWindow(playerCar, 0)
				RollUpWindow(playerCar, 1)
				windowup = true
			end
		end
	end
end)

RegisterNetEvent('lockpicks:UseLockpick')
AddEventHandler('lockpicks:UseLockpick', function(isAdvanced)
    if (IsPedInAnyVehicle(GetPlayerPed(-1))) then
        if not HasKey then
            LockpickIgnition(isAdvanced)
        end
    else
        LockpickDoor(isAdvanced)
    end
end)

function RobVehicle(target)
    IsRobbing = true
    Citizen.CreateThread(function()
        while IsRobbing do
            local RandWait = math.random(10000, 15000)
            loadAnimDict("random@mugging3")

            TaskLeaveVehicle(target, GetVehiclePedIsIn(target, true), 256)
            Citizen.Wait(1000)
            ClearPedTasksImmediately(target)

            TaskStandStill(target, RandWait)
            TaskHandsUp(target, RandWait, GetPlayerPed(-1), 0, false)

            Citizen.Wait(RandWait)

            --TaskReactAndFleePed(target, GetPlayerPed(-1))
            IsRobbing = false
        end
    end)
end

function LockVehicle()
    local veh = scCore.Functions.GetClosestVehicle()
    local coordA = GetEntityCoords(GetPlayerPed(-1), true)
    local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 255.0, 0.0)
    local veh = GetClosestVehicleInDirection(coordA, coordB)
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
        veh = GetVehiclePedIsIn(GetPlayerPed(-1))
    end
    if GetVehicleClass(veh) == 13 then
        return
    end
    local plate = GetVehicleNumberPlateText(veh)
    local vehpos = GetEntityCoords(veh, false)
    if veh ~= nil and GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 7.5 then
        scCore.TriggerServerCallback('vehiclekeys:CheckHasKey', function(result)
            if result then
                if HasKey then
                    local vehLockStatus = GetVehicleDoorLockStatus(veh)
                    loadAnimDict("anim@mp_player_intmenu@key_fob@")
                    TaskPlayAnim(GetPlayerPed(-1), 'anim@mp_player_intmenu@key_fob@', 'fob_click' ,3.0, 3.0, -1, 49, 0, false, false, false)
                    local myCoords = GetEntityCoords(GetPlayerPed(-1))
                    if vehLockStatus == 1 then
                        Citizen.Wait(750)
                        ClearPedTasks(GetPlayerPed(-1))
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.3, myCoords)
                        SetVehicleDoorsLocked(veh, 2)
                        if(GetVehicleDoorLockStatus(veh) == 2)then
                            scCore.Notification("Vehicle locked!")
                        else
                            scCore.Notification("Something went wrong with the locking system!")
                        end
                    else
                        Citizen.Wait(750)
                        ClearPedTasks(GetPlayerPed(-1))
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "unlock", 0.3, myCoords)
                        SetVehicleDoorsLocked(veh, 1)
                        if(GetVehicleDoorLockStatus(veh) == 1)then
                            scCore.Notification("Vehicle unlocked!")
                        else
                            scCore.Notification("Something went wrong with the locking system!")
                        end
                    end
        
                    if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                        SetVehicleInteriorlight(veh, true)
                        SetVehicleIndicatorLights(veh, 0, true)
                        SetVehicleIndicatorLights(veh, 1, true)
                        Citizen.Wait(450)
                        SetVehicleIndicatorLights(veh, 0, false)
                        SetVehicleIndicatorLights(veh, 1, false)
                        Citizen.Wait(450)
                        SetVehicleInteriorlight(veh, true)
                        SetVehicleIndicatorLights(veh, 0, true)
                        SetVehicleIndicatorLights(veh, 1, true)
                        Citizen.Wait(450)
                        SetVehicleInteriorlight(veh, false)
                        SetVehicleIndicatorLights(veh, 0, false)
                        SetVehicleIndicatorLights(veh, 1, false)
                    end
                end
            else
                scCore.Notification('You dont have keys of the vehicle', 'error')
            end
        end, plate)
    end
end

local openingDoor = false
function LockpickDoor(isAdvanced)
    local vehicle = scCore.Functions.GetClosestVehicle()
    if vehicle ~= nil and vehicle ~= 0 then
        local vehpos = GetEntityCoords(vehicle)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 1.5 then
            local vehLockStatus = GetVehicleDoorLockStatus(vehicle)
            if (vehLockStatus > 1) then
                local lockpickTime = math.random(8000, 12000)
                if isAdvanced then
                    lockpickTime = math.ceil(lockpickTime*0.5)
                end
                LockpickDoorAnim(lockpickTime)
                PoliceCall()
                IsHotwiring = true
                SetVehicleAlarm(vehicle, true)
                SetVehicleAlarmTimeLeft(vehicle, lockpickTime)
                local myCoords = GetEntityCoords(GetPlayerPed(-1))
                scCore.TaskBar("lockpick_vehicledoor", "Lockpicking door", lockpickTime, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    openingDoor = false
                    StopAnimTask(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
                    IsHotwiring = false
                    if math.random(1, 100) <= 90 then
                        scCore.Notification("Door unlocked!")
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "unlock", 0.3, myCoords)
                        SetVehicleDoorsLocked(vehicle, 0)
                        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                    else
                        scCore.Notification("Failed!", "error")
                    end
                end, function() -- Cancel
                    openingDoor = false
                    StopAnimTask(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
                    scCore.Notification("Failed!", "error")
                    IsHotwiring = false
                end)
            else
                scCore.Notification("Vehicle is not locked!", "error")
            end
        end
    end
end

function LockpickDoorAnim(time)
    time = time / 1000
    loadAnimDict("veh@break_in@0h@p_m_one@")
    TaskPlayAnim(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(1000)
            time = time - 1
            if time <= 0 then
                openingDoor = false
                StopAnimTask(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
            end
        end
    end)
end

function LockpickIgnition(isAdvanced)
    if not HasKey then 
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        IsHotwiring = true
        PoliceCall()
        local lockpickTime = math.random(30000, 40000)
        if isAdvanced then
            lockpickTime = math.ceil(lockpickTime*0.5)
        end
        scCore.TaskBar("lockpick_ignition", "Lockpicking", lockpickTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
            IsHotwiring = false
            if math.random(1, 100) <= 65 then
                scCore.Notification("Succesfully lockpicked!")
                HasKey = true
                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
            else
                scCore.Notification("Failed!", "error")
            end
        end, function() -- Cancel
            StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
            HasKey = false
            SetVehicleEngineOn(veh, false, false, true)
            scCore.Notification("Failed!", "error")
            IsHotwiring = false
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsHotwiring then
            DisableControlAction(0, 63, true) -- veh turn left
            DisableControlAction(0, 64, true) -- veh turn right
            DisableControlAction(0, 71, true) -- veh forward
            DisableControlAction(0, 72, true) -- veh backwards
            DisableControlAction(0, 75, true) -- disable exit vehicle
        else
            -- EnableControlAction(0, 63, true) -- veh turn left
            -- EnableControlAction(0, 64, true) -- veh turn right
            -- EnableControlAction(0, 71, true) -- veh forward
            -- EnableControlAction(0, 72, true) -- veh backwards
            -- EnableControlAction(0, 75, true) -- disable exit vehicle
        end
    end
end)

function Hotwire()
    if not HasKey then 
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        
        IsHotwiring = true
        local Skillbar = exports['lcrp-skillbar']:GetSkillbarObject()

        local SucceededAttempts = 0
        local NeededAttempts = 3
        --SetVehicleAlarm(vehicle, true)
        --SetVehicleAlarmTimeLeft(vehicle, 5000)
        PoliceCall()

        local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        SetVehicleUndriveable(veh, false)
        FreezeEntityPosition(ped, true)
        SetVehicleEngineOn(veh, false, false, true)
        Skillbar.Start({
            duration = math.random(3000, 9000),
            pos = math.random(10, 30),
            width = math.random(7, 12),
        }, function()
            if SucceededAttempts + 1 >= NeededAttempts then
                HasKey = true
                ClearPedTasks(GetPlayerPed(-1))
                SetVehicleEngineOn(vehicle, true, false, true)
                SetVehicleUndriveable(vehicle, false)
                --print(HasKey)
                scCore.Notification("Successfully hotwired!")
                FreezeEntityPosition(ped, false)

                IsHotwiring = false

                SucceededAttempts = 0
            else
            -- Repeat
            Skillbar.Repeat({
                duration = math.random(500, 1250),
                pos = math.random(10, 30),
                width = math.random(5, 6),
            })
            SucceededAttempts = SucceededAttempts + 1
        end


                --  HasKey = false
                --  --print(HasKey)
                --  SetVehicleEngineOn(vehicle, false, false, true)
                --  scCore.Notification("Hotwire failed!", "error")

                --  SucceededAttempts = SucceededAttempts + 1
            -- end
        end, function()
            -- Fail
            StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
            HasKey = false
            FreezeEntityPosition(ped, false)
            --SetVehicleEngineOn(vehicle, false, false, true)
            scCore.Notification("Hotwire Failed!", "error")
            IsHotwiring = false

            SucceededAttempts = 0
        end)
    end
end

function PoliceCall()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local chance = 5
    if GetClockHours() >= 1 and GetClockHours() <= 6 then
        chance = 3
    end
    if math.random(1, 100) <= chance then
        local closestPed = GetNearbyPed()
        if closestPed ~= nil then
            local msg = ""
            local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
            local streetLabel = GetStreetNameFromHashKey(s1)
            local street2 = GetStreetNameFromHashKey(s2)
            if street2 ~= nil and street2 ~= "" then 
                streetLabel = streetLabel .. " " .. street2
            end
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                local modelName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                local modelPlate = GetVehicleNumberPlateText(vehicle)
                msg = "Vehicle theft attempt at " ..streetLabel.. ". Vehicle: " .. modelName .. ", license Plate: " .. modelPlate
            else
                local vehicle = scCore.Functions.GetClosestVehicle()
                local modelName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                local modelPlate = GetVehicleNumberPlateText(vehicle)
                msg = "Vehicle theft attempt at " ..streetLabel.. ". Vehicle: " .. modelName .. ", license Plate: " .. modelPlate
            end

            local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            local modelName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            local modelPlate = GetVehicleNumberPlateText(vehicle)
            local alertTitle = "Vehicle theft"
            TriggerServerEvent("police:server:VehicleCall", pos, msg, alertTitle, streetLabel, modelPlate, modelName)
        end
    end
end

function GetClosestVehicleInDirection(coordFrom, coordTo)
	local offset = 0
	local rayHandle
	local vehicle

	for i = 0, 100 do
		rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, GetPlayerPed(-1), 0)	
		a, b, c, d, vehicle = GetRaycastResult(rayHandle)
		
		offset = offset - 1

		if vehicle ~= 0 then break end
	end
	
	local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
	
	if distance > 250 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end

function GetNearbyPed()
	local retval = nil
	local PlayerPeds = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        table.insert(PlayerPeds, ped)
    end
    local player = GetPlayerPed(-1)
    local coords = GetEntityCoords(player)
	local closestPed, closestDistance = scCore.Functions.GetClosestPed(coords, PlayerPeds)
	if not IsEntityDead(closestPed) and closestDistance < 30.0 then
		retval = closestPed
	end
	return retval
end

function IsBlacklistedWeapon()
    local weapon = GetSelectedPedWeapon(GetPlayerPed(-1))
    if weapon ~= nil then
        for _, v in pairs(Config.NoRobWeapons) do
            if weapon == GetHashKey(v) then
                return true
            end
        end
    end
    return false
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end

-- shuff seat vehicle functions

local disableShuffle = true

Citizen.CreateThread(function()
	while true do
		local ped = GetPlayerPed(-1)
		local veh = GetVehiclePedIsIn(ped)

		if IsPedInAnyVehicle(ped, false) and disableShuffle then
			if GetPedInVehicleSeat(veh, false, 0) == ped then
				if GetIsTaskActive(ped, 165) then
					SetPedIntoVehicle(ped, veh, 0)
				end
			end
		end

		Citizen.Wait(2)
	end
end)

RegisterNetEvent('lcrp-vehicles:client:Livery')
AddEventHandler('lcrp-vehicles:client:Livery', function(args)
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
    local livery = tonumber(args[1])

    SetVehicleLivery(vehicle, livery)

    scCore.Notification("Livery changed")
end)

RegisterNetEvent('lcrp-vehicles:client:Extra')
AddEventHandler('lcrp-vehicles:client:Extra', function(args)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local extraID = tonumber(args[1])
    local toggle = tostring(args[2])

    if toggle == "true" then
        toggle = 0
    end

    if args[1] == "all" and args[2] == "true" then
        SetVehicleAutoRepairDisabled(veh, true)
        for i=0,20 do
            SetVehicleExtra(GetVehiclePedIsIn(GetPlayerPed(-1),false),i,0)
        end
    end
    if args[1]=="all" and args[2]=="false" then
        SetVehicleAutoRepairDisabled(veh, true)
        for i=0,20 do
            SetVehicleExtra(GetVehiclePedIsIn(GetPlayerPed(-1),false),i,1)
        end
    end
    
    if veh ~= nil and veh ~= 0 and veh ~= 1 then
        if extraID == "99" then
            SetVehicleAutoRepairDisabled(veh, true)
            SetVehicleExtra(veh, 1, toggle)
            SetVehicleExtra(veh, 2, toggle)
            SetVehicleExtra(veh, 3, toggle)
            SetVehicleExtra(veh, 4, toggle)
            SetVehicleExtra(veh, 5, toggle)				
            SetVehicleExtra(veh, 6, toggle)
            SetVehicleExtra(veh, 7, toggle)
            SetVehicleExtra(veh, 8, toggle)
            SetVehicleExtra(veh, 9, toggle)								
            SetVehicleExtra(veh, 10, toggle)
            SetVehicleExtra(veh, 11, toggle)
            SetVehicleExtra(veh, 12, toggle)
            SetVehicleExtra(veh, 13, toggle)
            SetVehicleExtra(veh, 14, toggle)
            SetVehicleExtra(veh, 15, toggle)
            SetVehicleExtra(veh, 16, toggle)
            SetVehicleExtra(veh, 17, toggle)
            SetVehicleExtra(veh, 18, toggle)
            SetVehicleExtra(veh, 19, toggle)
            SetVehicleExtra(veh, 20, toggle)
        else
            SetVehicleAutoRepairDisabled(veh, true)
            SetVehicleExtra(veh, extraID, toggle)
        end
    
    end
end)

RegisterNetEvent('lcrp-vehicles:client:flipVehicle')
AddEventHandler('lcrp-vehicles:client:flipVehicle', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local vehicle = nil

    if not IsPedInAnyVehicle(ped, false) then
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
        if DoesEntityExist(vehicle) then
            scCore.TaskBar("flipping_vehicle", "Flipping vehicle", 5000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "random@mugging4",
                anim = "struggle_loop_b_thief",
                flags = 49,
            }, {}, {}, function() -- Done
                local playerped = PlayerPedId()
                local coordA = GetEntityCoords(playerped, 1)
                local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
                local targetVehicle = getVehicleInDirection(coordA, coordB)
                SetVehicleOnGroundProperly(targetVehicle)
                scCore.Notification("Vehicle flipped!")
            end, function() -- Cancel
                StopAnimTask(GetPlayerPed(-1), "random@mugging4", "struggle_loop_b_thief", 1.0)
                scCore.Notification("Canceled!", "error")
            end)
        else
            scCore.Notification('There is no vehicle close by', 'error')
        end
    else
        scCore.Notification('Exit vehicle first', 'error')
    end
end)

function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle

    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)    
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1

        if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 25 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end

-- SWTICH SEAT --

RegisterNetEvent("lcrp-vehicles:client:Shuff")
AddEventHandler("lcrp-vehicles:client:Shuff", function()
	local ped = GetPlayerPed(-1)
	if IsPedInAnyVehicle(ped, false) then
		disableShuffle = false
		SetTimeout(5000, function()
			disableShuffle = true
		end)
	else
		CancelEvent()
	end
end)

local tonumber            = tonumber
local unpack              = table.unpack
local CreateThread        = Citizen.CreateThread
local Wait                = Citizen.Wait
local PlayerPedId         = PlayerPedId
local IsPedInAnyVehicle   = IsPedInAnyVehicle
local GetPedInVehicleSeat = GetPedInVehicleSeat
local GetVehiclePedIsIn   = GetVehiclePedIsIn
local GetIsTaskActive     = GetIsTaskActive
local SetPedIntoVehicle   = SetPedIntoVehicle
local disabled            = false

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) and not disabled then
            local veh = GetVehiclePedIsIn(ped, false)
            if GetPedInVehicleSeat(veh, 0) == ped then
                if not GetIsTaskActive(ped, 164) and GetIsTaskActive(ped, 165) then
                    SetPedIntoVehicle(PlayerPedId(), veh, 0)
                end
            end
        end
    end
end)

RegisterNetEvent("lcrp-vehicles:client:switchSeat")
AddEventHandler("lcrp-vehicles:client:switchSeat", function(args)
    local IsHandcuffed = exports['police']:IsHandcuffed()
    local seatIndex = unpack(args)
    seatIndex       = tonumber(seatIndex) - 1

    if not IsHandcuffed then
        if seatIndex < -1 or seatIndex >= 4 then
            scCore.Notification("Seat ".. (seatIndex + 1).. " doesn\'t exist")
        else
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)

            scCore.TaskBar("switch_seat", "Switching seats", 2000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                if veh ~= nil and veh > 0 then
                    CreateThread(function()
                        disabled = true
                        SetPedIntoVehicle(PlayerPedId(), veh, seatIndex)
                        Wait(50)
                        disabled = false
                    end)
                end
            end, function() -- Cancel
                scCore.Notification("Canceled", "error")
            end)
        end
    else
        scCore.Notification("Action is currently not possible!", "error")
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000)
        TriggerServerEvent("lcrp-vehicles:server:GenerateVehicleList")
        Citizen.Wait((1000 * 60) * 60)
    end
end)


RegisterNetEvent('lcrp-vehicles:client:setNewVehicles')
AddEventHandler('lcrp-vehicles:client:setNewVehicles', function(vehicleList)
	Config.CurrentVehicles = vehicleList
end)

RegisterNetEvent('lcrp-vehicle:client:setBeingScrapped')
AddEventHandler('lcrp-vehicle:client:setBeingScrapped', function(plate)
	table.insert(beingScrapped, plate)
end)

RegisterNetEvent('lcrp-vehicle:client:removeScrapped')
AddEventHandler('lcrp-vehicle:client:removeScrapped', function(plate)
	for k, v in pairs(beingScrapped) do
        if v == plate then
            beingScrapped[k] = nil
        end
    end
end)

RegisterNetEvent('lcrp-vehicle:client:forceDelVeh')
AddEventHandler('lcrp-vehicle:client:forceDelVeh', function(plate)
    local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped)
    if vehicle ~= 0 then
        if plate == GetVehicleNumberPlateText(vehicle) then
            scCore.Functions.DeleteVehicle(vehicle)
        end
    end
end)

function ScrapVehicle(vehicle, vehiclePlate)
	isBusy = true
	local scrapTime = math.random(30000, 40000)
	ScrapVehicleAnim(scrapTime)
	scCore.TaskBar("scrap_vehicle", "Scrapping vehicle", scrapTime, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
        TriggerServerEvent('lcrp-vehicle:server:removeScrapped', vehiclePlate)
		TriggerServerEvent("lcrp-vehicles:server:ScrapVehicle", GetVehicleKey(GetEntityModel(vehicle)))
        TriggerServerEvent('lcrp-vehicle:server:forceDelVeh', vehiclePlate)
        scCore.Functions.DeleteVehicle(vehicle)
		isBusy = false
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent('lcrp-vehicle:server:removeScrapped', vehiclePlate)
		StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
        isBusy = false
        openingDoor = false
		scCore.Notification("Canceled", "error")
	end)
end

function IsVehicleValid(vehicleModel)
	local retval = false
	if Config.CurrentVehicles ~= nil and next(Config.CurrentVehicles) ~= nil then 
		for k, v in pairs(Config.CurrentVehicles) do
			if Config.CurrentVehicles[k] ~= nil and GetHashKey(Config.CurrentVehicles[k]) == vehicleModel then 
				retval = true
			end
		end
	end
	return retval
end

function IsVehicleNotBeingScrapped(plate)
    for k, v in pairs(beingScrapped) do
        if plate == v then
            return false
        end
    end
    return true
end

function GetVehicleKey(vehicleModel)
	local retval = 0
	if Config.CurrentVehicles ~= nil and next(Config.CurrentVehicles) ~= nil then 
		for k, v in pairs(Config.CurrentVehicles) do
			if GetHashKey(Config.CurrentVehicles[k]) == vehicleModel then 
				retval = k
			end
		end
	end
	return retval
end

function SetClosestScrapyard()
	local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil
    if current ~= nil then
        if(GetDistanceBetweenCoords(pos, -448.64, -1713.84, 18.73, true) < dist)then
            current = id
            dist = GetDistanceBetweenCoords(pos, -448.64, -1713.84, 18.73, true)
        end
    else
        dist = GetDistanceBetweenCoords(pos, -448.64, -1713.84, 18.73, true)
        current = id
    end
	closestScrapyard = current
end

function ScrapVehicleAnim(time)
    time = (time / 1000)
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



function GetDriverOfVehicle(vehicle)
	local dPed = GetPedInVehicleSeat(vehicle, -1)
	for a = 0, 256 do
		if dPed == GetPlayerPed(a) then
			return a
		end
	end
	return -1
end

function CanUseWeapon(allowedWeapons)
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyCurrentWeapon = GetSelectedPedWeapon(plyPed)
	for a = 1, #allowedWeapons do
		if GetHashKey(allowedWeapons[a]) == plyCurrentWeapon then
			return true
		end
	end
	return false
end

function GetClosestVehicleToPlayer()
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(plyPed, false)
	local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.0, 0.0)
	local radius = 3.0
	local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, radius, 10, plyPed, 7)
	local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)
	return vehicle
end

function GetClosestVehicleTire(vehicle)
	local tireBones = {"wheel_lf", "wheel_rf", "wheel_lm1", "wheel_rm1", "wheel_lm2", "wheel_rm2", "wheel_lm3", "wheel_rm3", "wheel_lr", "wheel_rr"}
	local tireIndex = {
		["wheel_lf"] = 0,
		["wheel_rf"] = 1,
		["wheel_lm1"] = 2,
		["wheel_rm1"] = 3,
		["wheel_lm2"] = 45,
		["wheel_rm2"] = 47,
		["wheel_lm3"] = 46,
		["wheel_rm3"] = 48,
		["wheel_lr"] = 4,
		["wheel_rr"] = 5,
	}
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(plyPed, false)
	local minDistance = 1.0
	local closestTire = nil
	
	for a = 1, #tireBones do
		local bonePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tireBones[a]))
		local distance = Vdist(plyPos.x, plyPos.y, plyPos.z, bonePos.x, bonePos.y, bonePos.z)

		if closestTire == nil then
			if distance <= minDistance then
				closestTire = {bone = tireBones[a], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[a]]}
			end
		else
			if distance < closestTire.boneDist then
				closestTire = {bone = tireBones[a], boneDist = distance, bonePos = bonePos, tireIndex = tireIndex[tireBones[a]]}
			end
		end
	end

	return closestTire
end

function Draw3DText(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
		DrawText(_x,_y)
		local factor = (string.len(text)) / 370
		DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
    end
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

RegisterCommand("control_engine", function(source)
    TriggerEvent("vehiclekeys:client:ToggleEngine")
end)

RegisterCommand("control_rollw", function(source)
    TriggerEvent("vehiclekeys:client:RollWindow")
end)

RegisterCommand("control_lockunlock", function()
    LockVehicle()
end)

RegisterNetEvent("lcrp-vehicles:client:ScrapVehicle")
AddEventHandler("lcrp-vehicles:client:ScrapVehicle", function()
    local playerPed = GetPlayerPed(-1)
    local playerPos = GetEntityCoords(playerPed)
    local isPedInVehicle = IsPedInAnyVehicle(playerPed)
    local vehicle = scCore.Functions.GetClosestVehicle()
    local vehiclePlate = GetVehicleNumberPlateText(vehicle)
    local vehpos = GetEntityCoords(vehicle)

    if not isPedInVehicle then
        local vehpos = GetEntityCoords(vehicle)
        if vehicle ~= 0 and vehicle ~= nil then
            if GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, vehpos.x, vehpos.y, vehpos.z, true) < 2.5 and not isBusy then
                if IsVehicleValid(GetEntityModel(vehicle)) and IsVehicleNotBeingScrapped(vehiclePlate) then 
                    TriggerServerEvent('lcrp-vehicle:server:setBeingScrapped', vehiclePlate)
                    ScrapVehicle(vehicle, vehiclePlate)
                else
                    scCore.Notification("This vehicle cannot be chopped", "error")
                end
            else
                scCore.Notification("Vehicle not found!", "error")
            end   
        end
    else
        scCore.Notification("Exit vehicle first!", "error")
    end
end)

RegisterNetEvent("lcrp-vehicles:client:ScrapVehicleList")
AddEventHandler("lcrp-vehicles:client:ScrapVehicleList", function()
	if Config.CurrentVehicles ~= nil and next(Config.CurrentVehicles) ~= nil then 
		emailSend = true
		local vehicleList = ""
		for k, v in pairs(Config.CurrentVehicles) do
			if Config.CurrentVehicles[k] ~= nil then 
				local vehicleInfo = scCore.Shared.Vehicles[v]
				if vehicleInfo ~= nil then 
					vehicleList = vehicleList  .. vehicleInfo["brand"] .. " " .. vehicleInfo["name"] .. "<br />"
				end
			end
		end
		SetTimeout(math.random(15000, 20000), function()
			emailSend = false
			TriggerServerEvent('lcrp-phone:server:sendNewMail', {
				sender = "Tony G",
				subject = "Vehicle list",
				message = "Sorry Its too dangerous for me to go outside. Could you please get those vehicles and chop them for me? <br /> You can keep some parts of vehicle. This is valid for 1 hour only <br /> <br /> <strong> Vehicle list: </strong><br />".. vehicleList,
				button = {}
			})
		end)
	else
		scCore.Notification("You can\'t chop vehicles right now", "error")
	end
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddBoxZone("ChopVehicle", vector3(-423.97, -1683.74, 19.0), 11.0, 18.6, {
        name="ChopVehicle",
        heading=70,
        minZ=18.0,
        maxZ=25.2 }, {
        options = {
            {
                event = "lcrp-vehicles:client:ScrapVehicle",
                icon = "far fa-clipboard",
                label = "Chop Vehicle",
                duty = false,
            },
        },
    job = {"all"}, distance = 8.5 })

    exports["lcrp-interact"]:AddBoxZone("ChopVehicleList", vector3(224.41, -1871.91, 26.87), 1.4, 1.4, {
        name="ChopVehicleList",
        heading=50,
        minZ=25.87,
        maxZ=28.67 }, {
        options = {
            {
                event = "lcrp-vehicles:client:ScrapVehicleList",
                icon = "far fa-clipboard",
                label = "Ask Tony For Work",
                duty = false,
            },
        },
    job = {"all"}, distance = 5.5 })

    -- Car wash locations

    exports["lcrp-interact"]:AddBoxZone("carWash1", vector3(26.01, -1391.97, 29.36), 6.2, 22.8, {
        name="carWash1",
        heading=0,
        minZ=28.09,
        maxZ=33.0 }, {
        options = {
            {
                event = "lcrp-vehicles:server:washCar",
                icon = "far fa-clipboard",
                label = "Wash a vehicle for: $"..Config.CarWashPrice,
                duty = false,
                serverEvent = true,
            },
        },
    job = {"all"}, distance = 8.5 })

    exports["lcrp-interact"]:AddBoxZone("rentCar1", vector3(986.77, -214.52, 70.8), 23.2, 12.6, {
        name="rentCar1",
        heading=330,
        --debugPoly=true,
        minZ=69.8,
        maxZ=75.8 }, {
        options = {
            {
                event = "lcrp-vehicles:client:RentCar",
                icon = "far fa-clipboard",
                label = "Rent Panto (100$)",
                duty = false,
                storeVeh = true,
                parameters = "Panto",
            },
            {
                event = "lcrp-vehicles:client:RentCar",
                icon = "far fa-clipboard",
                label = "Rent Pigalle (120$)",
                duty = false,
                parameters = "Pigalle",
            },
            {
                event = "lcrp-vehicles:client:RentCar",
                icon = "far fa-clipboard",
                label = "Rent Mesa (150$)",
                duty = false,
                parameters = "Mesa",
            },
        },
    job = {"all"}, distance = 9.0 })
end)