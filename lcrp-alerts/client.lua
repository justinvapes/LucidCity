scCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if scCore == nil then
            TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

local isLoggedIn = false
PlayerData = {}
PlayerJob = {}

Citizen.CreateThread(function()
    Wait(100)
    if scCore.Functions.GetPlayerData() ~= nil then
        PlayerData = scCore.Functions.GetPlayerData()
        PlayerJob = PlayerData.job
    end
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData =  scCore.Functions.GetPlayerData()
    PlayerJob = scCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('lcrp-alerts:ToggleDuty')
AddEventHandler('lcrp-alerts:ToggleDuty', function(Duty)
    PlayerJob.onduty = Duty
end)

function Waypoint(coords)
    while true do
        EnableControlAction(0, Keys["8"], true)

        if IsControlPressed(0, 162) then
            SetNewWaypoint(coords.x, coords.y)
            return
        end

        Wait(0)
    end
end

RegisterNetEvent('lcrp-alerts:client:AddPoliceAlert')
AddEventHandler('lcrp-alerts:client:AddPoliceAlert', function(data, forBoth)
    if forBoth then
        if (PlayerJob.name == "police" or PlayerJob.name == "statepolice" or PlayerJob.name == "fib" or PlayerJob.name == "doctor" or PlayerJob.name == "ambulance") and PlayerJob.onduty then
            if data.alertTitle == "Colleague Assistant" or data.alertTitle == "Officer assistance" or data.alertTitle == "EMS Assistance" or data.alertTitle == "Doctor assistance" then
                PlaySound(-1, "Friend_Pick_Up", "HUD_FRONTEND_MP_COLLECTABLE_SOUNDS", 0, 0, 1)
            elseif data.alertTitle == "Shop robbery" then
                PlaySound(-1, "Friend_Deliver", "HUD_FRONTEND_MP_COLLECTABLE_SOUNDS", 0, 0, 1)
            elseif data.alertTitle == "Suspicious person" or data.alertTitle == "Possible drug sale" then
                PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            else
                PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
            end
            data.callSign = data.callSign ~= nil and data.callSign or PlayerData.metadata["callsign"]
            data.alertId = math.random(11111, 99999)
            SendNUIMessage({
                action = "add",
                data = data,
            })
            if data.coords then
                Waypoint(data.coords)
            end
        end
    else
        if (PlayerJob.name == "police" or PlayerJob.name == "statepolice" or PlayerJob.name == "fib" and PlayerJob.onduty) then
            if data.alertTitle == "Officer assistance" or data.alertTitle == "EMS Assistance" or data.alertTitle == "Doctor assistance" or data.alertTitle == "House Burglary" then
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "emergency", 0.7)
            else
                PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
            end
            data.callSign = data.callSign ~= nil and data.callSign or PlayerData.metadata["callsign"]
            data.alertId = math.random(11111, 99999)
            SendNUIMessage({
                action = "add",
                data = data,
            })
        end 
    end
end)

RegisterNUICallback('SetWaypoint', function(data)
    local coords = data.coords

    SetNewWaypoint(coords.x, coords.y)
    scCore.Notification('GPS set!')
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false, false)
    MouseActive = false
end)