scCore = nil

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

RegisterNetEvent("rcore_arcade:ticketResult")
AddEventHandler("rcore_arcade:ticketResult", function(ticket)
    scCore.Notification(_U("bought_ticket", ticket, Config.ticketPrice[ticket].time),'success')
    -- Will set time player can be in arcade from Config
    seconds = 1
    minutes = minutes + Config.ticketPrice[ticket].time

    -- Tell the script that player has Ticket and can enter.
    gotTicket = true
    
end)

RegisterNetEvent("rcore_arcade:nomoney")
AddEventHandler("rcore_arcade:nomoney", function()
    scCore.Notification(_U("not_enough_money"),'error')
end)

RegisterNUICallback('exit', function()
    SendNUIMessage({
        type = "off",
        game = "",
    })
    SetNuiFocus(false, false)
end)