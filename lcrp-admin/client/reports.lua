local NUI = false

RegisterNetEvent("reports:openreport")
AddEventHandler("reports:openreport", function(id)
    if not id then
        scCore.Notification("Report ID doesn\'t exist!", 'error')
        return
    end

    SendNUIMessage({ action = 'open', data = id })
end)

RegisterNetEvent("reports:history")
AddEventHandler("reports:history", function(history)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'history' })
end)

RegisterNetEvent("reports:delete")
AddEventHandler("reports:delete", function(id)
    SendNUIMessage({ action = 'delete', data = id })
end)

RegisterNUICallback('closeNUI', function()
    NUI = false
    SetNuiFocus(NUI, NUI)
end)

RegisterNUICallback('openNUI', function()
    NUI = true
    SetNuiFocus(NUI, NUI)
end)

RegisterNUICallback('goto', function(data)
    TriggerEvent("reports:goto", data.player)
end)

RegisterNUICallback('GetInfo', function(data, cb)
    local sec = math.floor((GetGameTimer()-data.timer)/1000)
    local min = math.floor(((GetGameTimer()-data.timer)/1000)/60)

    local id = GetPlayerFromServerId(data.player)
    local ped = GetPlayerPed(id)
    local callback = cb
    
    callback(data)
end)

RegisterNUICallback('reply', function(data)
    local id = GetPlayerFromServerId(data.player)
    local ped = GetPlayerPed(id)
    local replyMessage = scCore.KeyboardInput("Enter Reply Message", "", 100)

    if DoesEntityExist(ped) then
        TriggerServerEvent("lcrp-admin:server:ReportReply", data.player, replyMessage, data.reportId)
    else
        scCore.Notification('Player offline!', 'error')
    end
end)

RegisterNUICallback('delete', function(data)
    TriggerServerEvent("reports:delete", data.report)
end)

RegisterNUICallback('notify', function(data)
    scCore.Notification(data.error, data.type)
end)

RegisterNetEvent("reports:goto")
AddEventHandler("reports:goto", function(id)
    local id = GetPlayerFromServerId(id)
    local ped = GetPlayerPed(id)

    if DoesEntityExist(ped) then
        DoScreenFadeOut(500)
        Wait(500)
        SetEntityCoords(PlayerPedId(), GetEntityCoords(ped))
        DoScreenFadeIn(500)
    else
        scCore.Notification('Player offline!', 'error')
    end
end)

RegisterNetEvent("reports:info")
AddEventHandler("reports:info", function(msg)
    SendNUIMessage({ action = 'info', data = msg })
end)

RegisterNetEvent("reports:addReport")
AddEventHandler("reports:addReport", function(data)
    local years, months, days, hours, minutes, seconds = Citizen.InvokeNative(0x50C7A99057A69748, Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local id = GetPlayerFromServerId(data.id)
    local ped = GetPlayerPed(id)
    local coords = GetEntityCoords(ped)

    data.x = coords.x
    data.y = coords.x
    data.z = coords.x
    data.time = hours .. ":" .. minutes .. ":" .. seconds
    data.timer = GetGameTimer()

    SendNUIMessage({ action = 'new', data = data })

    print(math.floor((GetGameTimer()-data.timer)/1000))
end)