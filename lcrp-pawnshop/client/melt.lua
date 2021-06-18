local enablePickup = false
local openingDoor = false

--[[ function ScrapAnim(time)
    local time = time / 1000
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
end ]]

function HasPlayerGold()
    PlayerData = scCore.Functions.GetPlayerData()
    for k,v in pairs(PlayerData.items) do
        if v.name == "goldbar" and v.amount > 0 then
            return true
        end
    end
    return false
end

function HasMeltableItems()
    PlayerData = scCore.Functions.GetPlayerData()
    for k,v in pairs(PlayerData.items) do
        if (v.name == "rolex" and v.amount > 0) or (v.name == "goldchain" and v.amount > 0) then
            return true
        end
    end
    return false
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddBoxZone("pawnshopSellGold", vector3(-1459.14, -413.03, 35.68), 0.8, 2.2, {
        name="pawnshopSellGold",
        heading=345,
        --debugPoly=true,
        minZ=34.68,
        maxZ=37.48 }, {
		options = {
			{
				event = "lcrp-pawnshop:client:SellGold",
				icon = "fas fa-coins",
				label = "Sell Gold",
				duty = false,
			},
		},
	job = {"all"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("pawnshopMeltGold", vector3(1086.3, -2003.66, 30.88), 4.6, 2.9, {
        name="pawnshopMeltGold",
        heading=317,
        --debugPoly=true,
        minZ=30.28,
        maxZ=32.28 }, {
		options = {
			{
				event = "lcrp-pawnshop:client:MeltGold",
				icon = "fas fa-cauldron",
				label = "Melt Gold",
				duty = false,
			},
		},
	job = {"all"}, distance = 5 })

end)

RegisterNetEvent('lcrp-pawnshop:client:MeltGold')
AddEventHandler('lcrp-pawnshop:client:MeltGold', function()
    if HasMeltableItems() then
        local waitTime = math.random(10000, 15000)
        --ScrapAnim(waitTime)
        scCore.TaskBar("drop_golden_stuff", "Grabbing items", 1000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "mp_car_bomb",--"veh@break_in@0h@p_m_one@",
            anim = "car_bomb_mechanic",--"low_force_entry_ds",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
            TriggerServerEvent("lcrp-pawnshop:server:meltItems")
        end)
    else
        scCore.Notification("You don't have items to melt!","error")
    end
end)

RegisterNetEvent('lcrp-pawnshop:client:SellGold')
AddEventHandler('lcrp-pawnshop:client:SellGold', function()
    if GetClockHours() >= 9 and GetClockHours() <= 18 then
        if HasPlayerGold() then
            local lockpickTime = 20000
            scCore.TaskBar("sell_gold", "Selling gold", lockpickTime, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "veh@break_in@0h@p_m_one@",
                anim = "low_force_entry_ds",
                flags = 16,
            }, {}, {}, function() -- Done
                ClearPedTasks(GetPlayerPed(-1))
                TriggerServerEvent('lcrp-pawnshop:server:sellGold')
            end, function() -- Cancel
                ClearPedTasks(GetPlayerPed(-1))
                scCore.Notification("Process canceled", "error")
            end)
        else
            scCore.Notification("You have no gold on you","error")
        end
    else
        scCore.Notification("The sign reads: Pawnshop opens at 9AM")
    end
end)

RegisterNetEvent('lcrp-pawnshop:client:pickedUp')
AddEventHandler('lcrp-pawnshop:client:pickedUp', function()
    options = {
        {
            event = "lcrp-pawnshop:client:MeltGold",
            icon = "fas fa-cauldron",
            label = "Melt Gold",
            duty = false,
        },
    }
    TriggerEvent("lcrp-interact:client:updateInteractionOptions", "zone", "pawnshopMeltGold", options)
end)

RegisterNetEvent('lcrp-pawnshop:client:startMelting')
AddEventHandler('lcrp-pawnshop:client:startMelting', function()
    Config.IsMelting = true
    Config.MeltTime = 300    
    local options = {
        {
            event = "",
            icon = "fas fa-clock",
            label = "Melting... | "..Config.MeltTime,
            duty = false,
        }
    }
    TriggerEvent("lcrp-interact:client:updateInteractionOptions", "zone", "pawnshopMeltGold", options)
    Citizen.CreateThread(function()
        while Config.IsMelting do
            Config.MeltTime = Config.MeltTime - 1
            if Config.MeltTime <= 0 then
                Config.IsMelting = false
            end
            TriggerEvent("lcrp-interact:client:updateInteraction", "zone", "pawnshopMeltGold", "label", "Melting... | "..Config.MeltTime.."s")
            Citizen.Wait(1000)
        end
        options = {
            {
                event = "lcrp-pawnshop:server:getGoldBars",
                icon = "fas fa-coins",
                label = "Pick up gold",
                duty = false,
                serverEvent = true
            },
        }
        TriggerEvent("lcrp-interact:client:updateInteractionOptions", "zone", "pawnshopMeltGold", options)
    end)
end)