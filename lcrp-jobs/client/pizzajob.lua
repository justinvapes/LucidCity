local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

exports["lcrp-polyzone"]:AddBoxZone("pizza_luchetti", vector3(289.78, -972.04, 29.43), 14.8, 24.5, {
    heading=180,
    minZ=28.12,
    maxZ=31.62
})

local inPizzeria = false
local hasProducts = false
local hasLoaded = false
local CurrentPlate = nil
local isWorking = false
local list = nil
local pizza = nil
local pizzaIngredients = nil
local pizzaPerk = 0
local meat = nil

local vehicle

local Products = nil
local Hunting = nil

local hasCookedMeat = false
local hasSetupPizza = false
local isPizzaBaking = false
local isBaking = false

local slaughterAnimals = {}

-- scCore shit --
scCore = nil

Citizen.CreateThread(function()
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
        Citizen.Wait(200)
    end
    ScriptLoaded()
end)

function ScriptLoaded()
	Citizen.Wait(1000)
	LoadMarkers()
end

RegisterNetEvent("lcrp-polyzone:enter")
AddEventHandler("lcrp-polyzone:enter", function(zone)
    if zone == "pizza_luchetti" then
        inPizzeria = true
    end
end)

RegisterNetEvent("lcrp-polyzone:exit")
AddEventHandler("lcrp-polyzone:exit", function(zone)
    if zone == "pizza_luchetti" then
        inPizzeria = false
    end
end)

-- CONFIG --
local AnimalMeat = 1 -- How much meat you get from 1 animal
local SlaughterTime = math.random(7000,10000) -- Slaughter time in miliseconds

local AnimalPositions = {
	{ x = -833.21, y = 5972.63, z = 20.60 },  
	{ x = -776.36, y = 5923.53, z = 20.90 },  
	{ x = -840.48, y = 5653.6, z = 19.62 },  
	{ x = -606.31, y = 5764.119, z = 33.07 },  
	{ x = -594.09, y = 5897.45, z = 25.30 },  
	{ x = -538.25, y = 5877.24, z = 33.49 },  
    { x = -666.71, y = 5458.54, z = 50.14 },   
    { x = -782.39, y = 5467.011, z = 29.14 },  
    { x = -568.76, y = 5546.48, z = 52.80 },  
}

local OnGoingHuntSession = false -- DONT TOUCH

local AnimalsInSession = {} -- DONT TOUCH

function LoadMarkers()
	LoadModel('a_c_deer')
	LoadAnimDict('amb@medic@standing@kneel@base')
	LoadAnimDict('anim@gangops@facility@servers@bodysearch@')

    local blip = AddBlipForCoord(287.24, -965.82, 29.41)  
    SetBlipSprite(blip, 488)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 17)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Pizzeria Luchetti's")
    EndTextCommandSetBlipName(blip)

end

function isTruckerVehicle(vehicle)
    local retval = false
    if GetEntityModel(vehicle) == GetHashKey("pony") then
        retval = true
    end
    return retval
end

RegisterNetEvent("lcrp-jobs:client:getProducts")
AddEventHandler("lcrp-jobs:client:getProducts", function()
    if isWorking then
        scCore.TaskBar("work_carrybox", "Picking up products", 2000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@gangops@facility@servers@",
            anim = "hotwire",
            flags = 16,
        }, {}, {}, function() -- Done
            hasProducts = true
            hasLoaded = false
            StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
            TriggerEvent('animations:client:EmoteCommandStart', {"box"})
        end, function() -- Cancel
            StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
            scCore.Notification("Canceled", "error")
        end)
    end
end)

local sellCooldown = 30
local hasSold = false

RegisterNetEvent("lcrp-jobs:client:sellPizzaPlayer")
AddEventHandler("lcrp-jobs:client:sellPizzaPlayer", function(amount, pizza)
    if not hasSold then
        if PlayerJob ~= nil then
            if PlayerJob.name == "pizza" and onDuty and amount > 0 then

                local player, distance = GetClosestPlayer()
                if player ~= -1 and distance < 2.5 then
                    local playerId = GetPlayerServerId(player)
                    TriggerServerEvent("lcrp-jobs:server:sellPizzaPlayer", playerId, amount, pizza)
                else
                    scCore.Notification("No one around!", "error")
                end
            end
        end
    else
        scCore.Notification("You're on cooldown. You'll be able to sell another in ".. sellCooldown.. " seconds.")
    end
end)

RegisterNetEvent("lcrp-jobs:client:pizzaCooldown")
AddEventHandler("lcrp-jobs:client:pizzaCooldown", function()
    hasSold = true
    countCooldown()
end)

RegisterNetEvent("lcrp-jobs:client:pizzaPerk")
AddEventHandler("lcrp-jobs:client:pizzaPerk", function()
    if inPizzeria then
        if pizzaPerk == 100 then
            scCore.Notification("You've hit the maximum armor you can stack (100 + extra 100)")
        else
            pizzaPerk = pizzaPerk + 50
            if pizzaPerk > 100 then pizzaPerk = 100 end
            handlePizzaPerk()
        end
    end
end)

function handlePizzaPerk()
    while pizzaPerk > 0 do
        local armor = GetPedArmour(PlayerPedId())
        if armor < 100 then
            local dif = 100 - armor
            if pizzaPerk > dif then
                pizzaPerk = pizzaPerk - dif
                AddArmourToPed(PlayerPedId(), dif)
            else
                AddArmourToPed(PlayerPedId(), pizzaPerk)
                pizzaPerk = 0
            end
        end
        Citizen.Wait(1000)
    end
end

function countCooldown()
    while hasSold do
        if sellCooldown > 0 then 
            sellCooldown = sellCooldown - 1
        else
            sellCooldown = 30
            hasSold = false
        end
        Citizen.Wait(1000)
    end
end

function StartHunting()
    local playerPed = PlayerPedId()

	Citizen.CreateThread(function()  
        for index, value in pairs(AnimalPositions) do
            local Animal = CreatePed(29, GetHashKey('a_c_deer'), value.x, value.y, value.z, 0.0, true, false)
            TaskWanderStandard(Animal, true, true)
            SetEntityAsMissionEntity(Animal, true, true)
            local AnimalBlip = AddBlipForEntity(Animal)
            SetBlipSprite(AnimalBlip, 463)
            SetBlipColour(AnimalBlip, 44)
            SetBlipScale(AnimalBlip, 0.7)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Deer - Animal')
            EndTextCommandSetBlipName(AnimalBlip)
            table.insert(AnimalsInSession, {id = Animal, x = value.x, y = value.y, z = value.z, Blipid = AnimalBlip})
        end     
    end)
end

function SlaughterAnimal(AnimalId)
    ClearPedTasksImmediately(PlayerPedId())
    Citizen.Wait(200)
    TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
	TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
    scCore.TaskBar("slaughter_animal", "Slaughtering animal", SlaughterTime, false, true, {
        disableMovement = true,
        disableCarMovement = false,
		disableMouse = false,
        disableCombat = true,
        disableCancel = true
    }, {}, {}, {}, function() -- Done
        ClearPedTasksImmediately(PlayerPedId())
    
        TriggerServerEvent('lcrp-activities:client:HuntingReward', AnimalMeat)
    
        DeleteEntity(AnimalId)
    end)
end

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end    
end

function LoadModel(model)
    while not HasModelLoaded(model) do
          RequestModel(model)
          Citizen.Wait(10)
    end
end

function DrawM(hint, type, x, y, z)
    DrawMarker(type, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.2, 0.3, 255, 255, 255, 100, false, true, 2, false, false, false, false)
end



RegisterNetEvent('lcrp-jobs:client:SpawnTruck')
AddEventHandler('lcrp-jobs:client:SpawnTruck', function()
    
    if PlayerJob.name == "pizza" then
        local coords = Config.PizzaPositions['vehicle']
        scCore.Functions.SpawnVehicle("pony", function(veh)
            --SetVehicleNumberPlateText(veh, myShop..tostring(math.random(10, 99)))
            SetEntityHeading(veh, 269.09)
            exports['LegacyFuel']:SetFuel(veh, 100.0)
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
            SetEntityAsMissionEntity(veh, true, true)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
            SetVehicleEngineOn(veh, true, true)
            vehicle = veh
            CurrentPlate = GetVehicleNumberPlateText(veh)
            TriggerServerEvent("lcrp-jobs:server:AddPlates", CurrentPlate, 0)
            startJob()
        end, coords, true)
    end
end)

RegisterNetEvent('lcrp-jobs:client:pizzaIngredients')
AddEventHandler('lcrp-jobs:client:pizzaIngredients', function(items)
    local slot = 0
    local pizzaItems = {}
    if isWorking then
        for k, v in pairs(Config.Ingredients) do
            for m, b in pairs(items) do
                if v == b.name then
                    table.insert(pizzaItems, b)
                end
            end
        end
        if #pizzaItems > 0 then 
            TriggerServerEvent("inventory:server:addTrunkItems", CurrentPlate, pizzaItems)
            scCore.Notification('Trunk loaded with the products.', 'primary', 10000)
        end
    end
end)

function setHuntLocBlip()
    -- Hunting
    Hunting = AddBlipForCoord(-769.23773193359, 5595.6215820313, 33.48571395874)
    SetBlipSprite(Hunting, 442)
    SetBlipColour(Hunting, 75)
    SetBlipScale(Hunting, 0.7)
    SetBlipAsShortRange(Hunting, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Hunting Spot')
    EndTextCommandSetBlipName(Hunting)
    SetBlipRoute(Hunting, true)
    SetBlipRouteColour(Hunting, 30)
end

function startJob()
    setHuntLocBlip()

    --[[ setProductThread() ]]
    
    isWorking = true

    scCore.Notification('Go hunt!', 'success')
    
end

local Lists = {
    [1] = {ingredientsTxt = "Ingredients list for Ham & Mushrooms Pizza:\n- 5x Dough\n- 1x Tomato Sauce\n- 3x Mozzarella\n- 2x Mushrooms\n- Ham - 3x Meat", name = "Ham & Mushrooms Pizza", ingredients = {
        [1] = {name = "dough", quantity = 5},
        [2] = {name = "tomatosauce", quantity = 1},
        [3] = {name = "mozzarella", quantity = 3},
        [4] = {name = "mushrooms", quantity = 2},
        [5] = {name = "ham", quantity = 1},
    }, meat = "ham"},
    [2] = {ingredientsTxt = "Ingredients list for Pepperoni Pizza:\n- 5x Dough\n- 1x Tomato Sauce\n- Pepperoni - 3x Meat", name = "Pepperoni Pizza", ingredients = {
        [1] = {name = "dough", quantity = 5},
        [2] = {name = "tomatosauce", quantity = 1},
        [3] = {name = "pepperoni", quantity = 1},
    }, meat = "pepperoni"},
    [3] = {ingredientsTxt = "Ingredients list for Supreme Pizza:\n- 5x Dough\n- 1x Tomato Sauce\n- 2x Onions\n- 1x Black olives\n- Ham - 3x Meat", name = "Supreme Pizza", ingredients = {
        [1] = {name = "dough", quantity = 5},
        [2] = {name = "tomatosauce", quantity = 1},
        [3] = {name = "onion", quantity = 2},
        [4] = {name = "olive", quantity = 1},
        [5] = {name = "ham", quantity = 1},
    }, meat = "ham"},
    [4] = {ingredientsTxt = "Ingredients list for Meat Pizza:\n- 5x Dough\n- 1x Tomato Sauce\n- Bolognese - 3x Meat", name = "Meat Pizza", ingredients = {
        [1] = {name = "dough", quantity = 5},
        [2] = {name = "tomatosauce", quantity = 1},
        [3] = {name = "bolognese", quantity = 1},
    }, meat = "bolognese"},
    [5] = {ingredientsTxt = "Ingredients list for Vegan Pizza:\n- 5x Dough\n- 2x Tomato Sauce\n - 2x Onions \n- 1x Black olives \n-2x Mushrooms ", name = "Vegan Pizza", ingredients = {
        [1] = {name = "dough", quantity = 5},
        [2] = {name = "tomatosauce", quantity = 2},
        [3] = {name = "onion", quantity = 2},
        [4] = {name = "olive", quantity = 2},
        [5] = {name = "mushrooms", quantity = 2},
    }}
}

function hasRequiredItems(pizza)
    local chosenPizza = Lists[pizza]
	local hasItems = {
		dough = 0,
		tomatosauce = 0,
		mozzarella = 0,
		mushrooms = 0,
		ham = 0,
		pepperoni = 0,
		onion = 0,
		olive = 0,
		bolognese = 0,
	}
	local retval = true
	scCore.Functions.GetPlayerData(function(PlayerData)
		for id, ingredient in pairs(chosenPizza.ingredients) do
			for slot,item in pairs(PlayerData.items) do
				if item.name == ingredient.name then
					hasItems[ingredient.name] = hasItems[ingredient.name] + item.amount
				end
			end
		end

		for k,v in pairs(hasItems) do
			for i,j in pairs(chosenPizza.ingredients) do
				if k == j.name then
					if v < j.quantity then
						amount = j.quantity - v
						retval = false
						scCore.Notification("You're missing "..amount.." "..scCore.Shared.Items[k].label.."!",'error')
					end
				end
			end
		end

		if retval then
            pizzaID = pizza
			setupPizza(chosenPizza)
		end
	end)
end


function setupPizza(pizza)

    local Skillbar = exports['lcrp-skillbar']:GetSkillbarObject()
    isBaking = true
    local SucceededAttempts = 0
    local NeededAttempts = #pizza.ingredients--
    Skillbar.Start({
        duration = math.random(3000, 9000),
        pos = math.random(10, 30),
        width = math.random(7, 12),
    }, function()
        if SucceededAttempts + 1 >= NeededAttempts then
            hasSetupPizza = true
            TriggerServerEvent('lcrp-jobs:server:setupPizza', pizza.ingredients)
            ClearPedTasks(GetPlayerPed(-1))
            SucceededAttempts = 0
            isBaking = false
        else
        -- Repeat
        Skillbar.Repeat({
            duration = math.random(500, 1250),
            pos = math.random(10, 30),
            width = math.random(5, 6),
        })
        SucceededAttempts = SucceededAttempts + 1
        end
    end, function()
        -- Fail
        StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
        scCore.Notification("The pizza looks awful! Try again.", "error")
        SucceededAttempts = 0
        isBaking = false
    end)
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

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()

	exports["lcrp-interact"]:AddBoxZone("PizzaDuty", vector3(291.95, -980.19, 29.43), 1.0, 1.6, {
        name="PizzaDuty",
        heading=0,
        --debugPoly=true,
        minZ=29.03,
        maxZ=30.63
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
	job = {"pizza"}, distance = 2.0 })

	exports["lcrp-interact"]:AddBoxZone("PizzaBoss", vector3(288.16, -990.0, 29.43), 2.6, 1.2, {
        name="PizzaBoss",
        heading=0,
        --debugPoly=true,
        minZ=28.43,
        maxZ=30.03 }, {
        options = {
            {
                event = "police:server:OpenSocietyMenu",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
                parameters = 'pizza'
            },
        },
    job = {"pizza"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("PizzaProcessMeat", vector3(288.64, -986.0, 29.43), 2.2, 3.0, {
        name="PizzaProcessMeat",
        heading=0,
        --debugPoly=true,
        minZ=28.43,
        maxZ=30.23 }, {
        options = {
            {
                event = "",
                icon = "",
                label = "Process 9 Meat",
                duty = true,
            },
            {
                event = "pizza:client:processMeat",
                icon = "fad fa-meat",
                label = "Ham",
                duty = true,
                parameters = 'ham'
            },
            {
                event = "pizza:client:processMeat",
                icon = "fad fa-sausage",
                label = "Pepperoni",
                duty = true,
                parameters = 'pepperoni'
            },
            {
                event = "pizza:client:processMeat",
                icon = "fad fa-badge",
                label = "Bolognese",
                duty = true,
                parameters = 'bolognese'
            },
        },
    job = {"pizza"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("PizzaSetup", vector3(286.63, -983.94, 29.43), 2.2, 1, {
        name="PizzaSetup",
        heading=0,
        --debugPoly=true,
        minZ=28.43,
        maxZ=30.23 }, {
        options = {
            {
                event = "",
                icon = "",
                label = "Make",
                duty = true,
                parameters = 0
            },
            {
                event = "pizza:client:setupPizza",
                icon = "fas fa-pizza-slice",
                label = "Ham & Mushrooms Pizza",
                duty = true,
                parameters = 1
            },
            {
                event = "pizza:client:setupPizza",
                icon = "fas fa-pizza-slice",
                label = "Pepperoni Pizza",
                duty = true,
                parameters = 2
            },
            {
                event = "pizza:client:setupPizza",
                icon = "fas fa-pizza-slice",
                label = "Supreme Pizza",
                duty = true,
                parameters = 3
            },
            {
                event = "pizza:client:setupPizza",
                icon = "fas fa-pizza-slice",
                label = "Meat Pizza",
                duty = true,
                parameters = 4
            },
            {
                event = "pizza:client:setupPizza",
                icon = "fas fa-pizza-slice",
                label = "Vegan Pizza",
                duty = true,
                parameters = 5
            },
        },
    job = {"pizza"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("PizzaStash", vector3(288.04, -980.38, 29.43), 1.6, 2.2, {
        name="PizzaStash",
        heading=0,
        --debugPoly=true,
        minZ=28.43,
        maxZ=30.23 }, {
        options = {
            {
                event = "pizza:client:openStash",
                icon = "fas fa-briefcase",
                label = "Open Stash",
                duty = true,
            },
        },
    job = {"pizza"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("PizzaSell1", vector3(290.75, -977.14, 29.43), 1, 1, {
        name="PizzaSell1",
        heading=0,
        --debugPoly=true,
        minZ=28.43,
        maxZ=30.03 }, {
        options = {
            {
                event = "pizza:client:sellPizza",
                icon = "fas fa-pizza-slice",
                label = "Sell Pizza",
                duty = true,
            },
        },
    job = {"pizza"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("PizzaSell2", vector3(287.36, -977.16, 29.43), 1, 1, {
        name="PizzaSell2",
        heading=0,
        --debugPoly=true,
        minZ=28.43,
        maxZ=30.03 }, {
        options = {
            {
                event = "pizza:client:sellPizza",
                icon = "fas fa-pizza-slice",
                label = "Sell Pizza",
                duty = true,
            },
        },
    job = {"pizza"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("PizzaTakeVehicle", vector3(297.45, -997.62, 29.16), 3.4, 6.4, {
        name="PizzaTakeVehicle",
        heading=0,
        --debugPoly=true,
        minZ=28.16,
        maxZ=30.36 }, {
        options = {
            {
                event = "pizza:client:takeStoreVeh",
                icon = "fad fa-car-side",
                label = "Take Vehicle",
                duty = true,
                storeVeh = true
            },
        },
    job = {"pizza"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("PizzaOven", vector3(281.71, -974.19, 29.43), 3.0, 2.4, {
        name="PizzaOven",
        heading=0,
        --debugPoly=true,
        minZ=28.16,
        maxZ=30.36 }, {
        options = {
            {
                event = "pizza:client:toTheOven",
                icon = "fad fa-oven",
                label = "Put pizza in the oven",
                duty = true,
            },
        },
    job = {"pizza"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("PizzaHunting", vector3(-771.97, 5598.27, 33.49), 6.2, 9.8, {
        name="PizzaHunting",
        heading=350,
        --debugPoly=true,
        minZ=32.49,
        maxZ=35.09 }, {
        options = {
            {
                event = "pizza:client:toggleHunting",
                icon = "fad fa-deer",
                label = "Start/Stop hunting",
                duty = true,
            },
        },
    job = {"pizza"}, distance = 5.0})

end)


RegisterNetEvent("pizza:client:processMeat")
AddEventHandler("pizza:client:processMeat", function(meat) 
    scCore.TriggerServerCallback('scCore:HasItem', function(hasMeat)
        if hasMeat then
            TriggerServerEvent('lcrp-jobs:server:ProcessItem', "meat", 9, meat)
            hasCookedMeat = true
        else
            scCore.Notification("You don't have any meat to process.", "error")
        end
    end, "meat") 
end)
                            

RegisterNetEvent("pizza:client:setupPizza")
AddEventHandler("pizza:client:setupPizza", function(pizza)
    if pizza ~= 0 then
        hasRequiredItems(pizza)
    end 
end)

RegisterNetEvent("pizza:client:openStash")
AddEventHandler("pizza:client:openStash", function() 
    TriggerEvent("inventory:client:SetCurrentStash", "pizza")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "pizza", {
        maxweight = 200000,
        slots = 10,
    })
end)

RegisterNetEvent("pizza:client:sellPizza")
AddEventHandler("pizza:client:sellPizza", function()
    TriggerServerEvent("pizza:server:sellPizza")             
end)

RegisterNetEvent("pizza:client:vehDeleted")
AddEventHandler("pizza:client:vehDeleted", function()  
    OnGoingHuntSession = false
    RemoveBlip(Hunting)
    RemoveBlip(Products)
    isWorking = false
    hasProducts = false
    hasLoaded = false
    CurrentPlate = nil
    vehicle = nil
end)

RegisterNetEvent("pizza:client:takeStoreVeh")
AddEventHandler("pizza:client:takeStoreVeh", function()
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
        if GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1) then
            local CurrentPlate = GetVehicleNumberPlateText(vehicle)
            if isTruckerVehicle(vehicle) then
                TriggerServerEvent("lcrp-jobs:server:CheckDepositMoney", false, "pizza",nil,CurrentPlate)
            else
                scCore.Notification('This is not the delivery vehicle!', 'error')
            end
        else
            scCore.Notification('You must be a driver')
        end
    else
        TriggerServerEvent("lcrp-jobs:server:CheckDepositMoney", true, "pizza")
    end
end)

RegisterNetEvent("pizza:client:toTheOven")
AddEventHandler("pizza:client:toTheOven", function()
    scCore.TriggerServerCallback('scCore:HasItem', function(hasPizza)
        if hasPizza then
            TriggerEvent('animations:client:EmoteCommandStart', {"wait"})
            scCore.TaskBar("bake_pizza", "Waiting for pizza to bake...", 30000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                list = nil
                pizza = nil
                pizzaIngredients = nil
                hasCookedMeat = false
                hasSetupPizza = false
                isPizzaBaking = false
                ClearPedTasks(GetPlayerPed(-1))
                TriggerServerEvent('lcrp-jobs:server:ProcessItem', "unbakedpizza", 1, pizzaID)
            end, function() -- Cancel
                ClearPedTasks(GetPlayerPed(-1))
                scCore.Notification("Canceled", "error")
            end)
            
        else
            scCore.Notification("You forgot your pizza somewhere...", "error")
        end
    end, "unbakedpizza")
end)

RegisterNetEvent("pizza:client:toggleHunting")
AddEventHandler("pizza:client:toggleHunting", function() 
    if not OnGoingHuntSession then
        scCore.Notification("Started hunting. Check your map for some tips on the animals locations.")
        OnGoingHuntSession = true
        if Hunting ~= nil then
            RemoveBlip(Hunting)
        end
        StartHunting()
    else
        scCore.Notification("Stopped hunting")
        OnGoingHuntSession = false
        for index, value in pairs(AnimalsInSession) do
            if DoesEntityExist(value.id) then
                DeleteEntity(value.id)
            end
        end
    end
end)

RegisterNetEvent("lcrp-jobs:client:loadToTrunk")
AddEventHandler("lcrp-jobs:client:loadToTrunk", function()
    if hasProducts and not hasLoaded then
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        Citizen.Wait(500)
        TriggerEvent('animations:client:EmoteCommandStart', {"bumbin"})
        scCore.TaskBar("work_carrybox", "Picking up products", 2000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
            SetVehicleDoorOpen(vehicle, 3, false, false),
            SetVehicleDoorOpen(vehicle, 2, false, false),
        }, {
            animDict = "anim@gangops@facility@servers@",
            anim = "bumbin",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "bumbin", 1.0)
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            TriggerServerEvent('lcrp-jobs:server:pizzaIngredients')
            hasProducts = false
            hasLoaded = true
            SetVehicleDoorShut(vehicle, 3, false)
            SetVehicleDoorShut(vehicle, 2, false)
        end, function() -- Cancel
            StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "bumbin", 1.0)
            scCore.Notification("Canceled", "error")
        end)
    end
end)

RegisterNetEvent("lcrp-jobs:client:SlaughterAnimal")
AddEventHandler("lcrp-jobs:client:SlaughterAnimal", function(entity)
    if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_KNIFE')  then
        for k,v in pairs(AnimalsInSession) do
            if v.id == entity then
                table.remove(AnimalsInSession, k)
                SlaughterAnimal(v.id)
            end
        end
    else
        scCore.Notification('You need to use a knife!', 'error')
    end
end)


function CanLoadProducts(entity)
    if string.match(PlayerJob.name, "pizza") and onDuty and GetEntityType(entity) == 2 and hasProducts and not hasLoaded and vehicle ~= nil and GetVehicleNumberPlateText(entity) == GetVehicleNumberPlateText(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetOffsetFromEntityInWorldCoords(entity, 0, -2.5, 0), true) < 1.5 then
        return true  
    else
        return false
    end
end

function IsWorking()
    return isWorking
end

function CanSlaughter(entity)
    if GetEntityType(entity) == 1 and GetEntityModel(entity) == -664053099 and IsEntityDead(entity) and OnGoingHuntSession and string.match(PlayerJob.name, "pizza") and onDuty and not IsPedInAnyVehicle(playerPed, false) and IsCorrectAnimal(entity) then
        return true
    else
        return false
    end
end

function IsCorrectAnimal(entity)
    for k,v in pairs(AnimalsInSession) do
        if v.id == entity then
            return true
        end
    end
    return false
end

