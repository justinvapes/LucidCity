
knockingDoor = false

local waitingDelivery = nil

local DeliveryTimeLeft = 0

local isHealingPerson = false
local healAnimDict = "mini@cpr@char_a@cpr_str"
local healAnim = "cpr_pumpchest"

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    scCore.TriggerServerCallback('lcrp-drugs:server:RequestConfig', function(DealerConfig)
        Config.Dealers = DealerConfig
    end)
end)


RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()

    exports["lcrp-interact"]:AddBoxZone("dealerMichael", vector3(1569.53, -2129.22, 78.32), 0.6, 1.6, {
    name="dealerMichael",
    heading=15,
    --debugPoly=true,
    minZ=77.12,
    maxZ=79.92,
        }, {
        options = {
            {
                event = "deliveries:client:knockDoorDealer",
                icon = "fas fa-door-closed",
                label = "Knock",
                duty = false,
                parameters = {dealer = 1, loc = vector3(1569.53, -2129.22, 78.32) }
            },
        },
    job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("dealerJeff", vector3(281.0, 6789.39, 15.7), 1.4, 1, {
        name="dealerJeff",
        heading=350,
        --debugPoly=true,
        minZ=14.7,
        maxZ=17.7,
            }, {
            options = {
                {
                    event = "deliveries:client:knockDoorDealer",
                    icon = "fas fa-door-closed",
                    label = "Knock",
                    duty = false,
                    parameters = {dealer = 2, loc = vector3(281.0, 6789.39, 15.7) }
                },
            },
        job = {"all"}, distance = 1.5 })
    
    exports["lcrp-interact"]:AddBoxZone("dealerTommy", vector3(3725.41, 4526.12, 22.46), 0.6, 1.4, {
        name="dealerTommy",
        heading=0,
        --debugPoly=true,
        minZ=21.46,
        maxZ=23.86,
            }, {
            options = {
                {
                    event = "deliveries:client:knockDoorDealer",
                    icon = "fas fa-door-closed",
                    label = "Knock",
                    duty = false,
                    parameters = {dealer = 3, loc = vector3(3725.41, 4526.12, 22.46) }
                },
            },
        job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("drugDeliver1", vector3(106.36, -1280.96, 29.16), 0.8, 1.4, {
        name="drugDeliver1",
        heading=10,
        --debugPoly=true,
        minZ=27.96,
        maxZ=30.76,
            }, {
            options = {
                {
                    event = "deliveries:client:finishDelivery",
                    icon = "fas fa-box",
                    label = "Deliver package",
                    duty = false,
                    hasDrugDelivery = false,
                    parameters = {locID = 1, loc = vector3(106.36, -1280.96, 29.16) }
                },
            },
        job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("drugDeliver2", vector3(223.2, 121.81, 102.6), 2.8, 1, {
        name="drugDeliver2",
        heading=340,
        --debugPoly=true,
        minZ=101.2,
        maxZ=105.0,
            }, {
            options = {
                {
                    event = "deliveries:client:finishDelivery",
                    icon = "fas fa-box",
                    label = "Deliver package",
                    duty = false,
                    hasDrugDelivery = false,
                    parameters = {locID = 2, loc = vector3(223.2, 121.81, 102.6)}
                },
            },
        job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("drugDeliver3", vector3(-1245.5, 375.96, 75.35), 0.6, 1.4, {
        name="drugDeliver3",
        heading=15,
        --debugPoly=true,
        minZ=74.15,
        maxZ=76.95,
            }, {
            options = {
                {
                    event = "deliveries:client:finishDelivery",
                    icon = "fas fa-box",
                    label = "Deliver package",
                    duty = false,
                    hasDrugDelivery = false,
                    parameters = {locID = 3, loc = vector3(-1245.5, 375.96, 75.35)}
                },
            },
        job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("drugDeliver4", vector3(-1383.47, -639.52, 28.67), 1.2, 1, {
        name="drugDeliver4",
        heading=305,
        --debugPoly=true,
        minZ=27.27,
        maxZ=30.27,
            }, {
            options = {
                {
                    event = "deliveries:client:finishDelivery",
                    icon = "fas fa-box",
                    label = "Deliver package",
                    duty = false,
                    hasDrugDelivery = false,
                    parameters = {locID = 4, loc = vector3(-1383.47, -639.52, 28.67)}
                },
            },
        job = {"all"}, distance = 1.5 })

end)

RegisterNetEvent("deliveries:client:knockDoorDealer")
AddEventHandler("deliveries:client:knockDoorDealer", function(data)
    if not knockingDoor then
        knockDealerDoor(data.dealer,data.loc)
    else
        scCore.Notification("You're already doing something")
    end
end)

RegisterNetEvent('deliveries:client:openShop')
AddEventHandler('deliveries:client:openShop', function(dealer, items)
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "Dealer_"..Config.Dealers[dealer]["name"], items)
end)

RegisterNetEvent('deliveries:client:finishDelivery')
AddEventHandler('deliveries:client:finishDelivery', function(data)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local location = vector3(data.loc.x, data.loc.y, data.loc.z)
    local distance = GetDistanceBetweenCoords(playerCoords, location, true)
    if distance < 10 and waitingDelivery ~= nil then
        if waitingDelivery.id == data.locID then
            deliverStuff(waitingDelivery)
            waitingDelivery = nil

            if drugDeliveriesBlip ~= nil then
                RemoveBlip(drugDeliveriesBlip)
            end
        end
    end
end)

RegisterNetEvent('deliveries:client:getDelivery')
AddEventHandler('deliveries:client:getDelivery', function(data)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local location = vector3(data.loc.x,data.loc.y,data.loc.z)
    local distance = GetDistanceBetweenCoords(playerCoords, location, true)
    if distance < 10 then
        if waitingDelivery == nil then
            if DeliveryTimeLeft < 1000 then
                TriggerServerEvent("lcrp-drugs:server:giveDeliveryItems", data.dealer)
            else
                scCore.Notification(Config.Dealers[data.dealer]["name"].." doesn\'t have any drugs for you to deliver!", "error")
            end
        else
            TriggerEvent("chatMessage", "Dealer "..Config.Dealers[data.dealer]["name"], "error", 'You still have an open delivery. What are you waiting for?')
        end
    end
end)

function GetClosestPlayer()
    local closestPlayers = scCore.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(PlayerPedId())

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

knockDealerDoor = function(dealer,loc)
    local hours = GetClockHours()

    if not (hours >= Config.Dealers[dealer]["time"]["min"] and hours < 24) or (hours <= Config.Dealers[dealer]["time"]["max"] and hours > 0) then
        knockDoorAnim(true,dealer,loc)
        toggleDistanceCheck(dealer,loc)
    else
        knockDoorAnim(false,dealer,loc) 
    end
end

function toggleDistanceCheck(dealer,loc)
    Citizen.CreateThread(function()
        local playerCoords = GetEntityCoords(PlayerPedId())
        local location = vector3(loc.x,loc.y,loc.z)
        local distance = GetDistanceBetweenCoords(playerCoords, location, true)

        while distance < 50 do
            playerCoords = GetEntityCoords(PlayerPedId())
            distance = GetDistanceBetweenCoords(playerCoords, location, true)
            Citizen.Wait(1000)
        end

        options = {
            {
                event = "deliveries:client:knockDoorDealer",
                icon = "fas fa-door-closed",
                label = "Knock",
                duty = false,
                parameters = {dealer = dealer, loc = loc }
            },
        }
        TriggerEvent("lcrp-interact:client:updateInteractionOptions","zone", "dealer"..Config.Dealers[dealer].name, options)
    end)
end

function setDealerInteractOptions(dealerID,location)
    options = {
        {
            event = "deliveries:server:openShop",
            icon = "fas fa-dollar-sign",
            label = "Buy items",
            duty = false,
            serverEvent = true,
            parameters = dealerID
        }
    }
    if Config.Dealers[dealerID].name == "Michael" then
        -- REVIVE IN DEALER IS CURRENTLY DISABLED
        -- IF ENABLING ALSO REMOVE COMMENTS AROUND THE 'deliveries:client:ReviveFriend' EVENT

        --[[ table.insert(options,{
            event = "deliveries:client:ReviveFriend",
            icon = "fas fa-plus",
            label = "Revive Friend",
            duty = false,
            parameters = {dealer = dealer, loc = loc }
        }) ]]
    elseif Config.Dealers[dealerID].name == "Jeff" then
        table.insert(options,{
            event = 'deliveries:client:getDelivery',
            icon = "fas fa-route",
            label = "Request Delivery job",
            duty = false,
            parameters = {dealer = dealerID, loc = location}
        })
    end
    TriggerEvent("lcrp-interact:client:updateInteractionOptions","zone", "dealer"..Config.Dealers[dealerID].name, options)
end

--[[ 
RegisterNetEvent('deliveries:client:ReviveFriend')
AddEventHandler('deliveries:client:ReviveFriend', function(dealer, loc)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local location = vector3(loc.x,loc.y,loc.z)
    local distance = GetDistanceBetweenCoords(playerCoords, location, true)
    if distance < 10 then
        if Config.Dealers[dealer]["name"] == "Michael" and not isHealingPerson then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                isHealingPerson = true
                scCore.TaskBar("hospital_revive", "Help person up", 5000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = healAnimDict,
                    anim = healAnim,
                    flags = 16,
                }, {}, {}, function() -- Done
                    isHealingPerson = false
                    StopAnimTask(PlayerPedId(), healAnimDict, "exit", 1.0)
                    TriggerServerEvent("hospital:server:RevivePlayer", playerId, true)
                end, function() -- Cancel
                    isHealingPerson = false
                    StopAnimTask(PlayerPedId(), healAnimDict, "exit", 1.0)
                    scCore.Notification("Failed!", "error")
                end)
            else
                scCore.Notification("There is no one around", "error")
            end
        else
            scCore.Notification("You are already doing something", "error")
        end
    end
end) 
]]

function knockDoorAnim(home,dealer,loc)
    local knockAnimLib = "timetable@jimmy@doorknock@"
    local knockAnim = "knockdoor_idle"
    local PlayerPed = PlayerPedId()
    local myData = scCore.Functions.GetPlayerData()

    if home then
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "knock_door", 0.2)
        Citizen.Wait(100)
        while (not HasAnimDictLoaded(knockAnimLib)) do
            RequestAnimDict(knockAnimLib)
            Citizen.Wait(100)
        end
        knockingDoor = true
        TaskPlayAnim(PlayerPed, knockAnimLib, knockAnim, 3.0, 3.0, -1, 1, 0, false, false, false )
        Citizen.Wait(3500)
        TaskPlayAnim(PlayerPed, knockAnimLib, "exit", 3.0, 3.0, -1, 1, 0, false, false, false)
        knockingDoor = false
        Citizen.Wait(1000)
        if Config.Dealers[dealer]["name"] == "Michael" then
            TriggerEvent("chatMessage", "Dealer "..Config.Dealers[dealer]["name"], "normal", 'Whats up my friend, what can I do for you?')
        else
            TriggerEvent("chatMessage", "Dealer "..Config.Dealers[dealer]["name"], "normal", 'Yo '..myData.charinfo.firstname..' what can I do for you?')
        end
        setDealerInteractOptions(dealer,loc)
        -- knockTimeout()
    else
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "knock_door", 0.2)
        Citizen.Wait(100)
        while (not HasAnimDictLoaded(knockAnimLib)) do
            RequestAnimDict(knockAnimLib)
            Citizen.Wait(100)
        end
        knockingDoor = true
        TaskPlayAnim(PlayerPed, knockAnimLib, knockAnim, 3.0, 3.0, -1, 1, 0, false, false, false )
        Citizen.Wait(3500)
        TaskPlayAnim(PlayerPed, knockAnimLib, "exit", 3.0, 3.0, -1, 1, 0, false, false, false)
        knockingDoor = false
        Citizen.Wait(1000)
        scCore.Notification('Seems like no one is home', 'error', 3500)
    end
end

RegisterNetEvent('lcrp-drugs:client:updateDealerItems')
AddEventHandler('lcrp-drugs:client:updateDealerItems', function(itemData, amount, dealer)
    TriggerServerEvent('lcrp-drugs:server:updateDealerItems', itemData, amount, dealer)
end)

RegisterNetEvent('lcrp-drugs:client:setDealerItems')
AddEventHandler('lcrp-drugs:client:setDealerItems', function(itemData, amount, dealer)
    Config.Dealers[dealer]["products"][itemData.slot].amount = Config.Dealers[dealer]["products"][itemData.slot].amount - amount
end)

RegisterNetEvent("lcrp-drugs:client:EmailDeliveryLocation")
AddEventHandler("lcrp-drugs:client:EmailDeliveryLocation", function(dealer, amount)

    local location = math.random(1, #Config.DeliveryLocations)
    print("drugDeliver"..location)
    TriggerEvent("lcrp-interact:client:updateInteraction", 'zone', "drugDeliver"..location, "hasDrugDelivery", true)
    waitingDelivery = {
        id = location,
        coords = Config.DeliveryLocations[location]["coords"],
        amount = amount,
        dealer = dealer,
        locationLabel = Config.DeliveryLocations[location]['label'],
    }

    -- SETS BLIP AND IT REMOVES AFTER DELIVERY IS DONE OR TIME RANS OUT
    drugDeliveriesBlip = AddBlipForCoord(waitingDelivery["coords"]["x"], waitingDelivery["coords"]["y"],  waitingDelivery["coords"]["z"])
    SetBlipColour(drugDeliveriesBlip, 4)
    SetBlipRoute(drugDeliveriesBlip, true)
    scCore.Notification('The route to the delivery location was set on your map', 'primary')

    TriggerServerEvent('lcrp-phone:server:sendNewMail', {
        sender = Config.Dealers[dealer]["name"],
        subject = "Delivery Location",
        message = "Here is all the information about your delivery <br> Location: "..waitingDelivery["locationLabel"].."<br>Stuff to deliver: <br> (x1) "..scCore.Shared.Items["weed_brick"]["label"].."<br><br> Make sure you are on time!",
    })

end)

function setMapBlip(x, y)
    SetNewWaypoint(x, y)
    scCore.Notification('The route to the delivery location was set on your map', 'primary');
end

function deliverStuff(delivery)
    if DeliveryTimeLeft > 0 then
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        Citizen.Wait(500)
        TriggerEvent('animations:client:EmoteCommandStart', {"bumbin"})
        checkPedDistance()
        scCore.TaskBar("work_dropbox", "Delivering products", 3500, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerServerEvent('lcrp-drugs:server:succesDelivery', delivery, true)
        end, function() -- Cancel
            ClearPedTasks(PlayerPedId())
            scCore.Notification("Cancelled", "error")
        end)
    else
        TriggerServerEvent('lcrp-drugs:server:succesDelivery', delivery, false)
    end
    TriggerEvent("lcrp-interact:client:updateInteraction", 'zone', "drugDeliver"..delivery.id, "hasDrugDelivery", false)
end


function checkPedDistance()
    local PlayerPeds = {}
    if next(PlayerPeds) == nil then
        for _, player in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(player)
            table.insert(PlayerPeds, ped)
        end
    end
    
    local closestPed, closestDistance = scCore.Functions.GetClosestPed(coords, PlayerPeds)

    if closestDistance < 40 and closestPed ~= 0 then
        local callChance = math.random(1, 100)

        if callChance < 15 then
            doPoliceAlert()
        end
    end
end

function doPoliceAlert()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 ~= nil then 
        streetLabel = streetLabel .. " " .. street2
    end

    TriggerServerEvent('lcrp-drugs:server:callCops', streetLabel, pos)
end

RegisterNetEvent('lcrp-drugs:client:robberyCall')
AddEventHandler('lcrp-drugs:client:robberyCall', function(msg, streetLabel, coords)
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerEvent("chatMessage", "911-REPORT", "error", msg)
    local transG = 250
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 458)
    SetBlipColour(blip, 1)
    SetBlipDisplay(blip, 4)
    SetBlipAlpha(blip, transG)
    SetBlipScale(blip, 1.0)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("911: Drug dealing")
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
end)

RegisterNetEvent('lcrp-drugs:client:sendDeliveryMail')
AddEventHandler('lcrp-drugs:client:sendDeliveryMail', function(type, deliveryData)
    if type == 'perfect' then
        TriggerServerEvent('lcrp-phone:server:sendNewMail', {
            sender = Config.Dealers[deliveryData["dealer"]]["name"],
            subject = "Drug Deliveries",
            message = "You did a good job! I hope to do business with you again soon. <br> <br> Have a nice day "..Config.Dealers[deliveryData["dealer"]]["name"]
        })
    elseif type == 'bad' then
        TriggerServerEvent('lcrp-phone:server:sendNewMail', {
            sender = Config.Dealers[deliveryData["dealer"]]["name"],
            subject = "Drug Deliveries",
            message = "I got complaints about your delivery. <br> Make sure it doesnt happen again."
        })
    elseif type == 'late' then
        TriggerServerEvent('lcrp-phone:server:sendNewMail', {
            sender = Config.Dealers[deliveryData["dealer"]]["name"],
            subject = "Drug Deliveries",
            message = "You didnt deliver on time. Did you have more important things to do then business?"
        })
    end
end)

RegisterNetEvent("lcrp-drugs:client:setDeliveriesTime")
AddEventHandler("lcrp-drugs:client:setDeliveriesTime", function()
    DeliveryTimeLeft = Config.DeliveryTimeout
    Citizen.CreateThread(function()
        while DeliveryTimeLeft >= 1000 do
            DeliveryTimeLeft = DeliveryTimeLeft - 1000
            Citizen.Wait(1000)
        end
        if drugDeliveriesBlip ~= nil then
            RemoveBlip(drugDeliveriesBlip)
        end
    end)

end)