-------------------
-- Exports
-------------------
MenuAPI = exports.MenuAPI
-------------------
-- variables for arcade and time left
-------------------
gotTicket = false

minutes = 0
seconds = 0
-------------------

scCore = nil
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
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = scCore.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
    onDuty = PlayerJob.onDuty
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
	exports["lcrp-interact"]:AddBoxZone("ArcadeBarDuty", vector3(348.29, -903.23, 29.25), 0.8, 4.2, {
		name="ArcadeBarDuty",
		heading=0,
        minZ=28.25,
        maxZ=31.25,
        }, {
		options = {
			{
				event = "police:client:Duty",
				icon = "far fa-clipboard",
				label = "Clock in",
				duty = false,
				parameters = "duty",
			},
			{
				event = "police:client:Duty",
				icon = "far fa-clipboard",
				label = "Clock out",
				duty = true,
				parameters = "duty",
			},
		},
	job = {"arcadebar"}, distance = 2.5 })

	exports["lcrp-interact"]:AddBoxZone("ArcadeBarBoss", vector3(323.45, -927.16, 29.25), 1.8, 1, {
        name="ArcadeBarBoss",
		heading=0,
		minZ=28.25,
        maxZ=29.85,
        --debugPoly=true, 
        }, {
        options = {
            {
                event = "arcadebar:client:openSocietyMenu",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"arcadebar"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("ArcadeBuyTicket", vector3(337.05, -907.68, 29.25), 0.8, 1, {
        name="ArcadeBuyTicket",
		heading=0,
		minZ=28.25,
        maxZ=30.25,
        --debugPoly=true, 
        }, {
        options = setTickets(),
        job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("ArcadeBarComputer", vector3(342.99, -902.48, 29.25), 1.8, 4.2, {
        name="ArcadeBarComputer",
		heading=0,
		minZ=28.25,
        maxZ=29.85,
        --debugPoly=true, 
        }, {
        options = setGaming(),
    job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("ArcadeBarComputer2", vector3(338.93, -902.3, 29.25), 1.6, 4.2, {
        name="ArcadeBarComputer2",
		heading=0,
		minZ=28.25,
        maxZ=29.85,
        --debugPoly=true, 
        }, {
        options = setGaming(),
    job = {"all"}, distance = 2.0})
    exports["lcrp-interact"]:AddBoxZone("ArcadeBarComputer4", vector3(326.62, -903.67, 29.25), 1.8, 4.2, {
        name="ArcadeBarComputer",
		heading=0,
		minZ=28.25,
        maxZ=29.85,
        --debugPoly=true, 
        }, {
        options = setGaming(),
    job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("ArcadeBarComputer3", vector3(330.71, -903.78, 29.25), 2.0, 4.0, {
        name="ArcadeBarComputer3",
		heading=0,
		minZ=28.25,
        maxZ=29.85,
        --debugPoly=true, 
        }, {
        options = setGaming(),
    job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("ArcadeBarRetro", vector3(325.84, -912.19, 29.25), 1.2, 2.6, {
        name="ArcadeBarRetro",
		heading=0,
		minZ=28.25,
        maxZ=30.25,
        --debugPoly=true, 
        }, {
        options = setRetro(),
    job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("ArcadeBarRetro2", vector3(323.06, -915.72, 29.25), 2.6, 1.2, {
        name="ArcadeBarRetro2",
		heading=0,
		minZ=28.25,
        maxZ=30.25,
        --debugPoly=true, 
        }, {
        options = setRetro(),
    job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("ArcadeBarRetro3", vector3(323.02, -919.94, 29.25), 1, 1, {
        name="ArcadeBarRetro3",
		heading=0,
		minZ=28.25,
        maxZ=30.25,
        --debugPoly=true, 
        }, {
        options = setRetro(),
    job = {"all"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("ArcadeBarRetro4", vector3(327.57, -926.69, 29.25), 3.4, 1, {
        name="ArcadeBarRetro4",
		heading=0,
		minZ=28.25,
        maxZ=30.25,
        --debugPoly=true, 
        }, {
        options = setRetro(),
    job = {"all"}, distance = 2.0})

end)

RegisterNetEvent("arcadebar:client:openGame")
AddEventHandler("arcadebar:client:openGame", function(game)
    if gotTicket then
        SendNUIMessage({
            type = "on",
            game = game,
            gpu = Config.GPUList[2],
            cpu = Config.CPUList[2]
        })
        SetNuiFocus(true, true)
    else
        scCore.Notification(_U("need_to_buy_ticket"),'error')
    end
end)

RegisterNetEvent("arcadebar:client:openSocietyMenu")
AddEventHandler("arcadebar:client:openSocietyMenu", function()
    if PlayerJob.grade == #scCore.Shared.Jobs["arcadebar"].roles then
        TriggerEvent("police:server:OpenSocietyMenu", "arcadebar")
    end
end)

RegisterNetEvent("arcadebar:client:buyTicket")
AddEventHandler("arcadebar:client:buyTicket", function(ticket)
    TriggerServerEvent("rcore_arcade:buyTicket", ticket)
end)

function doesPlayerHaveTicket()
    return gotTicket
end

function isPlayerInArcade()
    local inArcade = false
    local plyCoords = GetEntityCoords(PlayerPedId())
    local distance = #(plyCoords - Config.ArcadeLocation)
    if distance < 30 and doesPlayerHaveTicket() then
        inArcade = true
    end
    return inArcade
end

isPlayerInArcade()

exports('doesPlayerHaveTicket', doesPlayerHaveTicket)
exports('isPlayerInArcade', isPlayerInArcade)
--count time
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if gotTicket then
            if hasPlayerRunOutOfTime() then
                scCore.Notification(_U("ticket_expired"))
                gotTicket = false

                SendNUIMessage({
                    type = "off",
                    game = "",
                })
                SetNuiFocus(false, false)
            end

            countTime()
            displayTime()
        end
    end
end)

--create npc, blip, marker
Citizen.CreateThread(function()
    for k, v in pairs(Config.Arcade) do

        if v.blip and v.blip.enable then
            createBlip(v.blip.name, v.blip.blipId, v.blip.position, v.blip)
        end

        createLocalPed(4, v.NPC.model, v.NPC.position, v.NPC.heading, function(ped)
            SetEntityAsMissionEntity(ped)
            SetBlockingOfNonTemporaryEvents(ped, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
        end)
    end
end)

function setGaming()
    games = {
        {
            event = "",
            icon = "",
            label = "Computer Games",
            duty = false
        } 
    }
    for k,v in pairs(Config.GamingMachine) do
        table.insert(games,{
            event = "arcadebar:client:openGame",
            icon = "far fa-gamepad-alt",
            label = v.name,
            duty = false,
            parameters = v.link
        })
    end
    return games
end

function setRetro()
    retro = {
        {
            event = "",
            icon = "",
            label = "Retro Games",
            duty = false
        } 
    }
    for k,v in pairs(Config.RetroMachine) do
        table.insert(retro,{
            event = "arcadebar:client:openGame",
            icon = "far fa-joystick",
            label = v.name,
            duty = false,
            parameters = v.link
        })
    end
    return retro
end

function setTickets()
    tickets = {
        {
            event = "",
            icon = "",
            label = "Buy Ticket",
            duty = false
        } 
    }
    for k,v in pairs(Config.ticketPrice) do
        table.insert(tickets,{
            event = "arcadebar:client:buyTicket",
            icon = "far fa-ticket-alt",
            label = v.label.." ticket | "..v.price.."$ | "..v.time.." Minutes",
            duty = false,
            parameters = k
        })
    end
    return tickets

end

