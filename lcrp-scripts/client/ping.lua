local pendingPing = nil
local isPending = false

function AddBlip(bData)
    pendingPing.blip = AddBlipForCoord(bData.x, bData.y, bData.z)
    SetBlipSprite(pendingPing.blip, bData.id)
    SetBlipAsShortRange(pendingPing.blip, true)
    SetBlipScale(pendingPing.blip, bData.scale)
    SetBlipColour(pendingPing.blip, bData.color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(bData.name)
    EndTextCommandSetBlipName(pendingPing.blip)

    pendingPing.count = 0
end

function TimeoutPingRequest()
    Citizen.CreateThread(function()
        local count = 0
        while isPending do
            count = count + 1
            if count >= Config.Timeout and isPending then

                scCore.Notification('Ping From ' .. pendingPing.name .. ' Timed Out', 5000)

                TriggerServerEvent('lcrp-scripts:server:SendPingResult', pendingPing.id, 'timeout')
                pendingPing = nil
                isPending = false
            end
            Citizen.Wait(1000)
        end
    end)
end

function TimeoutBlip()
    Citizen.CreateThread(function()
        while pendingPing ~= nil do
            if pendingPing.count ~= nil then
                if pendingPing.count >= Config.BlipDuration then
                    RemoveBlip(pendingPing.blip)
                    pendingPing = nil
                else
                    pendingPing.count = pendingPing.count + 1
                end
            end
            Citizen.Wait(1000)
        end
    end)
end

function RemoveBlipDistance()
    local player = PlayerPedId()
    Citizen.CreateThread(function()
        while pendingPing ~= nil do
            local plyCoords = GetEntityCoords(player)
            local dist = math.floor(#(vector2(pendingPing.pos.x, pendingPing.pos.y) - vector2(plyCoords.x, plyCoords.y)))

            if dist < Config.DeleteDistance then
                RemoveBlip(pendingPing.blip)
                pendingPing = nil
            else
                Citizen.Wait(math.floor((dist - Config.DeleteDistance) * 30))
            end
        end
    end)
end

RegisterNetEvent('lcrp-scripts:client:SendPing')
AddEventHandler('lcrp-scripts:client:SendPing', function(sender, senderId)
    if pendingPing == nil then
        pendingPing = {}
        pendingPing.id = senderId
        pendingPing.name = sender
        pendingPing.pos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(pendingPing.id)), false) 

        TriggerServerEvent('lcrp-scripts:server:SendPingResult', pendingPing.id, 'received')

        scCore.Notification(pendingPing.name .. ' Sent You a Ping, Use /ping accept To Accept', Config.Timeout * 1000)

        isPending = true

        if Config.Timeout > 0 then
            TimeoutPingRequest()
        end

    else
        scCore.Notification(sender .. ' Attempted To Ping You')
        TriggerServerEvent('lcrp-scripts:server:SendPingResult', senderId, 'unable')
    end
end)

RegisterNetEvent('lcrp-scripts:client:AcceptPing')
AddEventHandler('lcrp-scripts:client:AcceptPing', function()
    if isPending then
        local playerBlip = { name = pendingPing.name, color = Config.BlipColor, id = Config.BlipIcon, scale = Config.BlipScale, x = pendingPing.pos.x, y = pendingPing.pos.y, z = pendingPing.pos.z }
        AddBlip(playerBlip)

        if Config.RouteToPing then
            SetNewWaypoint(pendingPing.pos.x, pendingPing.pos.y)
        end

        if Config.Timeout > 0 then
            TimeoutBlip()
        end

        if Config.DeleteDistance > 0 then
            RemoveBlipDistance()
        end

        scCore.Notification(pendingPing.name .. '\'s Location Showing On Map')
        TriggerServerEvent('lcrp-scripts:server:SendPingResult', pendingPing.id, 'accept')
        isPending = false
    else
        scCore.Notification('You Have No Pending Ping', 'error')
    end
end)

RegisterNetEvent('lcrp-scripts:client:RejectPing')
AddEventHandler('lcrp-scripts:client:RejectPing', function()
    if pendingPing ~= nil then
        scCore.Notification('Rejected Ping From ' .. pendingPing.name, 'error')
        TriggerServerEvent('lcrp-scripts:server:SendPingResult', pendingPing.id, 'reject')
        pendingPing = nil
        isPending = false
    else
        scCore.Notification('You Have No Pending Ping', 'error')
        exports['mythic_notify']:DoHudText('inform', 'You Have No Pending Ping')
    end
end)

RegisterNetEvent('lcrp-scripts:client:RemovePing')
AddEventHandler('lcrp-scripts:client:RemovePing', function()
    if pendingPing ~= nil then
        RemoveBlip(pendingPing.blip)
        pendingPing = nil
        scCore.Notification('Player Ping Removed')
    else
        scCore.Notification('You Have No Player Ping', 'error')
    end
end)