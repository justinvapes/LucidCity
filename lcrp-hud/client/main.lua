scCore = nil

Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

isLoggedIn = true
stress = 0
PlayerJob = {}
playerId = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if scCore == nil then
            TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
            Citizen.Wait(200)
        end
        if scCore ~= nil then
            TriggerEvent("hud:client:SetMoney")
            return
        end
    end
end)

RegisterNetEvent("scCore:Client:OnPlayerUnload")
AddEventHandler("scCore:Client:OnPlayerUnload", function()
    isLoggedIn = false
    LCRPHud.Show = false
    SendNUIMessage({
        action = "hudtick",
        show = true,
    })
end)

RegisterNetEvent("scCore:Client:OnPlayerLoaded")
AddEventHandler("scCore:Client:OnPlayerLoaded", function()
    isLoggedIn = true
    LCRPHud.Show = true
    PlayerJob = scCore.Functions.GetPlayerData().job
end)

local StressGain = 0
local IsGaining = false

Citizen.CreateThread(function()
    local ped = GetPlayerPed(-1)
    local plyPedId = PlayerPedId()
    local pedId = PlayerId()
    while true do
        sleep = 1000

        if IsPedArmed(plyPedId, 6) then
            sleep = 5    
            if IsPedShooting(ped) then
                local StressChance = math.random(1, 3)
                local odd = math.random(1, 3)
                if StressChance == odd then
                    local PlusStress = math.random(2, 4) / 100
                    StressGain = StressGain + PlusStress
                end
                if not IsGaining then
                    IsGaining = true
                end
            else
                if IsGaining then
                    IsGaining = false
                end
            end
        else
            sleep = 1000
        end

        if (PlayerJob.name ~= "police") then
            if IsPedArmed(plyPedId, 6) then
                sleep = 5
                if IsPlayerFreeAiming(pedId) and not IsPedShooting(ped) then
                    local CurrentWeapon = GetSelectedPedWeapon(ped)
                    local WeaponData = scCore.Shared.Weapons[CurrentWeapon]
                    if WeaponData.name:upper() ~= "WEAPON_UNARMED" then
                        local StressChance = math.random(1, 20)
                        local odd = math.random(1, 20)
                        if StressChance == odd then
                            local PlusStress = math.random(1, 3) / 100
                            StressGain = StressGain + PlusStress
                        end
                    end
                    if not IsGaining then
                        IsGaining = true
                    end
                else
                    if IsGaining then
                        IsGaining = false
                    end
                end
            end
        end

        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent('hud:client:UpdateStress')
AddEventHandler('hud:client:UpdateStress', function(newStress)
    stress = newStress
end)

Citizen.CreateThread(function()
    while true do
        if not IsGaining then
            StressGain = math.ceil(StressGain)
            if StressGain > 0 then
                scCore.Notification('Stress Gained', "primary", 2000)
                TriggerServerEvent('lcrp-hud:Server:UpdateStress', StressGain)
                StressGain = 0
            end
        end
        if stress > 20 and stress < 30 then
            if math.random(1,100) < 10 then
                TriggerScreenblurFadeIn(100)
                Citizen.Wait(2000)
                TriggerScreenblurFadeOut(100)
                Citizen.Wait(10000)
                scCore.Notification('You\'re stressed out', "primary", 2000)
            end
        elseif stress >= 30 and stress < 60 then
            if math.random(1,100) < 20 then
                TriggerScreenblurFadeIn(100)
                Citizen.Wait(5000)
                TriggerScreenblurFadeOut(100)
                Citizen.Wait(10000)
                scCore.Notification('You\'re stressed out', "primary", 2000)
            end

            if math.random(1,100) < 10 then
                DoScreenFadeOut(500)
                Citizen.Wait(1000)
                DoScreenFadeIn(500)
                Citizen.Wait(10000)
                scCore.Notification('You\'re stressed out', "primary", 2000)
            end
        elseif stress >= 60 then
            if math.random(1,100) < 40 then
                TriggerScreenblurFadeIn(100)
                Citizen.Wait(1000 * 60)
                TriggerScreenblurFadeOut(100)
                Citizen.Wait(10000)
                scCore.Notification('You\'re too stressed out', "primary", 2000)
            end
            if math.random(1,100) < 60 then
                DoScreenFadeOut(100)
                SetPedToRagdoll(PlayerPedId(), 3000, 3000, 3, 0, 0, 0)
                Citizen.Wait(1000)
                DoScreenFadeIn(100)
                Citizen.Wait(10000)
                scCore.Notification('You\'re too stressed out', "primary", 2000)
            end
        end
        Citizen.Wait(3000)
    end
end)

function GetShakeIntensity(stresslevel)
    local retval = 0.05
    for k, v in pairs(Stress.Intensity["shake"]) do
        if stresslevel >= v.min and stresslevel < v.max then
            retval = v.intensity
            break
        end
    end
    return retval
end

function GetEffectInterval(stresslevel)
    local retval = 60000
    for k, v in pairs(Stress.EffectInterval) do
        if stresslevel >= v.min and stresslevel < v.max then
            retval = v.timeout
            break
        end
    end
    return retval
end