scCore = nil
local TaskBarTime = 0
local animation = nil
local animationDict = nil
PlayerJob = nil
PlayerData = nil
onDuty = false

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    --local OldPlayerJob = PlayerJob.name
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = scCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent('scCore:Client:SetDuty')
AddEventHandler('scCore:Client:SetDuty', function(duty)
    onDuty = duty
end)

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function close()
    Menu.hidden = true
end


RegisterNetEvent("lcrp-jobs:client:ProcessTaskBar")
AddEventHandler("lcrp-jobs:client:ProcessTaskBar", function(Item, ItemCount)
    local playerPed = GetPlayerPed(-1)

    if not IsPedInAnyVehicle(playerPed) then
        
        if Item == "packaged_chicken" then
            TaskBarTime = (1000 * Config.ChickenForDelivery) * ItemCount
            animation = Config.SlaughtererPositions.MarkerLocations["placefordelivery"].anim
            animationDict = Config.SlaughtererPositions.MarkerLocations["placefordelivery"].animDict
        end
        
        scCore.TaskBar("slaughter_chicken", "Placing Chicken", TaskBarTime, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = animationDict,
            anim = animation,
            flags = 16,
        }, {}, {}, function() -- Done
            ClearPedTasksImmediately(PlayerPedId())
            TriggerServerEvent('lcrp-jobs:server:ProcessItem', Item, ItemCount)
        end, function() -- Cancel
            ClearPedTasksImmediately(PlayerPedId())
            scCore.Notification("Canceled", "error")
        end)

    else
        scCore.Notification("Leave vehicle first!", "error")
    end
end)