scCore = nil
local PlayerJob = nil
local onDuty = false
local PlayerGrade = nil

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

-- code
RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    scCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        onDuty = PlayerJob.onduty
        PlayerGrade = PlayerData.job.grade
    end)
    isLoggedIn = true
end)


RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = JobInfo.onduty
    PlayerGrade = JobInfo.grade
    if string.match(PlayerJob.name, "gym") then
        hasActiveLicense = true
        myGym = PlayerJob.name
    end
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddBoxZone("PizzaFreshMarket", vector3(282.75, -978.13, 29.43), 2.2, 1.2, {
		name="PizzaFreshMarket",
        heading=0,
        --debugPoly=true,
        minZ=28.43,
        maxZ=31.03 }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-apple-crate",
                label = "Get Ingredients",
                duty = true,
                parameters = "freshmarket"
            },
        },
    job = {"pizza"}, distance = 5.0})

    exports["lcrp-interact"]:AddBoxZone("airlinesShop", vector3(-940.92, -2953.95, 13.95), 0.6, 1.6, {
        name="airlinesShop",
        heading=329,
        --debugPoly=true,
        minZ=12.95,
        maxZ=15.35 }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-apple-crate",
                label = "Open Shop",
                duty = true,
                parameters = "airlines"
            },
        },
    job = {"all"}, distance = 5.0})

    exports["lcrp-interact"]:AddBoxZone("vanillaShop", vector3(129.07, -1284.78, 29.27), 2.6, 1.0, {
        name="vanillaShop",
        heading=30,
        --debugPoly=true,
        minZ=28.27,
        maxZ=29.87 }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-apple-crate",
                label = "Open Shop",
                duty = true,
                parameters = "stripclub"
            },
        },
    job = {"vanilla"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("casinoChips", vector3(Config.Locations["casinochips"]["coords"][1]["x"], Config.Locations["casinochips"]["coords"][1]["y"], Config.Locations["casinochips"]["coords"][1]["z"]), 2.0, 2.0, {
        name="casinoChips",
        heading=Config.Locations["casinochips"]["coords"][1]["heading"],
        --debugPoly=true,
        minZ=Config.Locations["casinochips"]["coords"][1]["minZ"],
        maxZ=Config.Locations["casinochips"]["coords"][1]["maxZ"], 
    }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "far fa-shopping-cart",
                label = "Open Shop",
                duty = false,
                parameters = "casinochips"
            },
        },
    job = {"all"}, distance = 2.5})

    exports["lcrp-interact"]:AddBoxZone("casinoChips2", vector3(Config.Locations["casinochips2"]["coords"][1]["x"], Config.Locations["casinochips2"]["coords"][1]["y"], Config.Locations["casinochips2"]["coords"][1]["z"]), 3.5, 3.5, {
        name="casinoChips2",
        heading=Config.Locations["casinochips2"]["coords"][1]["heading"],
        --debugPoly=true,
        minZ=Config.Locations["casinochips2"]["coords"][1]["minZ"],
        maxZ=Config.Locations["casinochips2"]["coords"][1]["maxZ"], 
    }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "far fa-shopping-cart",
                label = "Open Shop",
                duty = false,
                parameters = "casinochips2"
            },
        },
    job = {"all"}, distance = 2.5})
        --casino bar
    exports["lcrp-interact"]:AddBoxZone("casino", vector3(938.5, 26.35, 71.83), 2.0, 1.2, {
        name="casinobar",
        heading=325,
        --debugPoly=true,
        minZ=70.83,
        maxZ=74.83
      }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-apple-crate",
                label = "Open Shop",
                duty = false,
                parameters = "casino"
            },
        },
    job = {"casino"}, distance = 1.5})

    -- 24/7 shops
    exports["lcrp-interact"]:AddBoxZone("247supermarket", vector3(25.35, -1347.24, 29.5), 1.0, 1.2, {
        name="247supermarket",
        heading=0,
        --debugPoly=true,
        minZ=28.5,
        maxZ=32.5}, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-apple-crate",
                label = "Open Shop",
                duty = false,
                parameters = "247supermarket"
            },
        },
    job = {"all"}, distance = 1.0})

    exports["lcrp-interact"]:AddBoxZone("247supermarket2", vector3(-3039.12, 585.22, 7.91), 1, 2.0, {
        name="247supermarket2",
        heading=20,
        --debugPoly=true,
        minZ=6.91,
        maxZ=10.91
      }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-apple-crate",
                label = "Open Shop",
                duty = false,
                parameters = "247supermarket2"
            },
        },
    job = {"all"}, distance = 1.0})

    exports["lcrp-interact"]:AddBoxZone("247supermarket3",vector3(-3242.06, 1000.67, 12.83), 1, 2.2, {
        name="247supermarket3",
        heading=355,
        --debugPoly=true,
        minZ=11.83,
        maxZ=15.83
      }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-apple-crate",
                label = "Open Shop",
                duty = false,
                parameters = "247supermarket3"
            },
        },
    job = {"all"}, distance = 1.0})

    exports["lcrp-interact"]:AddBoxZone("247supermarket4", vector3(1728.52, 6414.9, 35.04), 2.2, 1.0, {
        name="247supermarket4",
        heading=335,
        --debugPoly=true,
        minZ=34.04,
        maxZ=38.04
      }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-apple-crate",
                label = "Open Shop",
                duty = false,
                parameters = "247supermarket4"
            },
        },
    job = {"all"}, distance = 1.0})

    exports["lcrp-interact"]:AddBoxZone("247supermarket5", vector3(1697.87, 4923.98, 42.06), 1.0, 2.0, {
        name="247supermarket5",
        heading=325,
        --debugPoly=true,
        minZ=41.06,
        maxZ=45.06
      }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-apple-crate",
                label = "Open Shop",
                duty = false,
                parameters = "247supermarket5"
            },
        },
    job = {"all"}, distance = 1.0})
    exports["lcrp-interact"]:AddBoxZone("247supermarket6", vector3(1960.78, 3740.25, 32.34), 2.2, 1, {
        name="247supermarket6",
        heading=30,
        --debugPoly=true,
        minZ=31.34,
        maxZ=35.34
      }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-apple-crate",
                label = "Open Shop",
                duty = false,
                parameters = "247supermarket6"
            },
        },
    job = {"all"}, distance = 1.0})
    exports["lcrp-interact"]:AddBoxZone("247supermarket7", vector3(548.38, 2671.35, 42.16), 2.0, 1, {
        name="247supermarket7",
        heading=5,
        --debugPoly=true,
        minZ=41.16,
        maxZ=45.16
      }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-apple-crate",
                label = "Open Shop",
                duty = false,
                parameters = "247supermarket7"
            },
        },
    job = {"all"}, distance = 1.0})
    exports["lcrp-interact"]:AddBoxZone("247supermarket8", vector3(2678.6, 3279.9, 55.24), 1.8, 0.8, {
        name="247supermarket8",
        heading=61,
        --debugPoly=true,
        minZ=54.24,
        maxZ=58.24
      }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-apple-crate",
                label = "Open Shop",
                duty = false,
                parameters = "247supermarket8"
            },
        },
    job = {"all"}, distance = 1.0})
    exports["lcrp-interact"]:AddBoxZone("247supermarket9", vector3(2557.5, 381.57, 108.62), 1, 2.0, {
        name="247supermarket9",
        heading=0,
        --debugPoly=true,
        minZ=107.62,
        maxZ=111.62
      }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-apple-crate",
                label = "Open Shop",
                duty = false,
                parameters = "247supermarket9"
            },
        },
    job = {"all"}, distance = 1.0})

    exports["lcrp-interact"]:AddBoxZone("247supermarketcayo",vector3(4480.01, -4470.12, 4.26), 1.8, 1.0, {
        name="247supermarketcayo",
        heading=20,
        --debugPoly=true,
        minZ=3.26,
        maxZ=7.26
      }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-apple-crate",
                label = "Open Shop",
                duty = false,
                parameters = "247supermarketcayo"
            },
        },
    job = {"all"}, distance = 1.0})
    --ltd gasoline
    exports["lcrp-interact"]:AddBoxZone("ltdgasoline",vector3(-47.93, -1758.12, 29.42), 1, 2.0, {
        name="ltdgasoline",
        heading=50,
        --debugPoly=true,
        minZ=28.42,
        maxZ=32.42
      }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-apple-crate",
                label = "Open Shop",
                duty = false,
                parameters = "ltdgasoline"
            },
        },
    job = {"all"}, distance = 1.0})

    exports["lcrp-interact"]:AddBoxZone("ltdgasoline2",vector3(-706.7, -914.53, 19.22), 2.0, 1.0, {
        name="ltdgasoline2",
        heading=0,
        --debugPoly=true,
        minZ=18.22,
        maxZ=22.22
      }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-apple-crate",
                label = "Open Shop",
                duty = false,
                parameters = "ltdgasoline2"
            },
        },
    job = {"all"}, distance = 1.0})

    exports["lcrp-interact"]:AddBoxZone("ltdgasoline3",vector3(-1820.1, 793.11, 138.11), 2.0, 1.0, {
        name="ltdgasoline3",
        heading=45,
        --debugPoly=true,
        minZ=137.11,
        maxZ=141.11
      }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-apple-crate",
                label = "Open Shop",
                duty = false,
                parameters = "ltdgasoline3"
            },
        },
    job = {"all"}, distance = 1.0})

    exports["lcrp-interact"]:AddBoxZone("ltdgasoline4",vector3(1164.2, -323.83, 69.21), 2.2, 1.0, {
        name="ltdgasoline4",
        heading=10,
        --debugPoly=true,
        minZ=68.21,
        maxZ=72.21
      }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-apple-crate",
                label = "Open Shop",
                duty = false,
                parameters = "ltdgasoline4"
            },
        },
    job = {"all"}, distance = 1.0})

    --Mega Malls
    exports["lcrp-interact"]:AddBoxZone("hardware",vector3(46.18, -1749.22, 29.57), 3.0, 3.0, {
        name="hardware",
        heading=320,
        --debugPoly=true,
        minZ=28.57,
        maxZ=32.57
      }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-tools",
                label = "Open Shop",
                duty = false,
                parameters = "hardware"
            },
        },
    job = {"all"}, distance = 1.0})

    exports["lcrp-interact"]:AddBoxZone("hardware3",vector3(-421.92, 6135.95, 31.88), 3.2, 2.8, {
        name="hardware3",
        heading=315,
        --debugPoly=true,
        minZ=30.88,
        maxZ=34.88
      }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-tools",
                label = "Open Shop",
                duty = false,
                parameters = "hardware3"
            },
        },
    job = {"all"}, distance = 1.0})

    --digital den

    exports["lcrp-interact"]:AddBoxZone("digitalden",vector3(-656.98, -857.95, 24.49), 1.2, 2.8, {
        name="digitalden1",
        heading=0,
        --debugPoly=true,
        minZ=23.49,
        maxZ=27.49
      }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-camera-retro",
                label = "Open Shop",
                duty = false,
                parameters = "digitalden"
            },
        },
    job = {"all"}, distance = 1.0})

    exports["lcrp-interact"]:AddBoxZone("labchemicals", vector3(Config.Locations["labchemicals"]["coords"][1]["x"], Config.Locations["labchemicals"]["coords"][1]["y"], Config.Locations["labchemicals"]["coords"][1]["z"]), 2.6, 2.0, {
        name="labchemicals",
        heading=Config.Locations["labchemicals"]["coords"][1]["heading"],
        minZ=Config.Locations["labchemicals"]["coords"][1]["minZ"],
        maxZ=Config.Locations["labchemicals"]["coords"][1]["maxZ"], 
    }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-vial",
                label = "Open Shop",
                duty = false,
                parameters = "labchemicals"
            },
        },
    job = {"all"}, distance = 2.5})

    exports["lcrp-interact"]:AddBoxZone("burgershotShop", vector3(-1196.51, -902.06, 13.98), 1.0, 1.6, {
        name="burgershotShop",
        heading=35,
        --debugPoly=true,
        minZ=12.78,
        maxZ=15.58, 
    }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fas fa-salad",
                label = "Open fridge",
                duty = true,
                parameters = "burgershot"
            },
        },
    job = {"burgershot"}, distance = 2.5})

    exports["lcrp-interact"]:AddBoxZone("seaworldShop", vector3(-1686.23, -1072.76, 13.15), 1.8, 1, {
        name="seaworldShop",
        heading=322,
        --debugPoly=true,
        minZ=11.75,
        maxZ=14.95, 
    }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fad fa-certificate",
                label = "Open Shop",
                duty = false,
                parameters = "seaword1"
            },
            {
                event = "lcrp-boatshop:server:SellCoral",
                icon = "fal fa-water",
                label = "Sell corals",
                duty = false,
                serverEvent = true,
            },
        },
    job = {"all"}, distance = 2.5})

    exports["lcrp-interact"]:AddBoxZone("diner", vector3(Config.Locations["diner"]["coords"][1]["x"], Config.Locations["diner"]["coords"][1]["y"], Config.Locations["diner"]["coords"][1]["z"]), 2.6, 2.0, {
        name="diner",
        heading=Config.Locations["diner"]["coords"][1]["heading"],
        minZ=Config.Locations["diner"]["coords"][1]["minZ"],
        maxZ=Config.Locations["diner"]["coords"][1]["maxZ"], 
    }, {
        options = {
            {
                event = "lcrp-shops:client:openShop",
                icon = "fad fa-burger-soda",
                label = "Open Shop",
                duty = false,
                parameters = "diner"
            },
        },
    job = {"all"}, distance = 2.5})
end)

RegisterNetEvent('lcrp-shops:client:openShop')
AddEventHandler('lcrp-shops:client:openShop', function(shop)
    local ShopItems = {}
    ShopItems.label = Config.Locations[shop]["label"]
    ShopItems.items = Config.Locations[shop]["products"]
    ShopItems.slots = 30
    if Config.Locations[shop]["type"] == "weapon" then

        scCore.TriggerServerCallback('lcrp-shops:server:CheckWeaponLicense', function(result)
            if result then
                TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..shop, ShopItems)
            else
                exports['lcrp-core']:Notification("You don\'t have weapon license!", "error")
            end
        end)
    elseif Config.Locations[shop]["type"] == "casino" then
        if PlayerJob ~= nil then
            if string.match(PlayerJob.name, "casino") then
                TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..shop, ShopItems)
            else
                exports['lcrp-core']:Notification("You don\'t have permission to access this!", "error")
            end
        end
    elseif Config.Locations[shop]["type"] == "stripclub" then
        if PlayerJob ~= nil then 
            if string.match(PlayerJob.name, "vanilla") then
                TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..shop, ShopItems)
            else
                exports['lcrp-core']:Notification("You don\'t have permission to access this!", "error")
            end
        end
    elseif Config.Locations[shop]["type"] == "freshmarket" then
        if PlayerJob ~= nil then
            if string.match(PlayerJob.name, "pizza") then
                TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..shop, ShopItems)
            else
                exports['lcrp-core']:Notification("You don\'t have permission to access this!", "error")
            end
        end
    elseif Config.Locations[shop]["type"] == "burgershot" then
        if PlayerJob ~= nil then 
            if string.match(PlayerJob.name, "burgershot") then
                TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..shop, ShopItems)
            else
                exports['lcrp-core']:Notification("You don\'t have permission to access this!", "error")
            end
        end
    else
        TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..shop, ShopItems)
    end
end)


RegisterNetEvent('lcrp-shops:client:UpdateShop')
AddEventHandler('lcrp-shops:client:UpdateShop', function(shop, itemData, amount)
    TriggerServerEvent('lcrp-shops:server:UpdateShopItems', shop, itemData, amount)
end)

RegisterNetEvent('lcrp-shops:client:SetShopItems')
AddEventHandler('lcrp-shops:client:SetShopItems', function(shop, shopProducts)
    Config.Locations[shop]["products"] = shopProducts
end)

RegisterNetEvent('lcrp-shops:client:RestockShopItems')
AddEventHandler('lcrp-shops:client:RestockShopItems', function(shop, amount)
    if Config.Locations[shop]["products"] ~= nil then 
        for k, v in pairs(Config.Locations[shop]["products"]) do 
            Config.Locations[shop]["products"][k].amount = Config.Locations[shop]["products"][k].amount + amount
        end
    end
end)

Citizen.CreateThread(function()
    for store,_ in pairs(Config.Locations) do
        StoreBlip = AddBlipForCoord(Config.Locations[store]["coords"][1]["x"], Config.Locations[store]["coords"][1]["y"], Config.Locations[store]["coords"][1]["z"])
        SetBlipColour(StoreBlip, 0)

        if Config.Locations[store]["products"] == Config.Products["normal"] then
            SetBlipSprite(StoreBlip, 52)
            SetBlipScale(StoreBlip, 0.6)
        elseif Config.Locations[store]["products"] == Config.Products["coffeeplace"] then
            SetBlipSprite(StoreBlip, 52)
            SetBlipScale(StoreBlip, 0.6)
        elseif Config.Locations[store]["products"] == Config.Products["gearshop"] then
            SetBlipSprite(StoreBlip, 52)
            SetBlipScale(StoreBlip, 0.6)
        elseif Config.Locations[store]["products"] == Config.Products["hardware"] then
            SetBlipSprite(StoreBlip, 52)
            SetBlipScale(StoreBlip, 0.8)
        elseif Config.Locations[store]["products"] == Config.Products["cinema"] then
            SetBlipSprite(StoreBlip, 135)
            SetBlipScale(StoreBlip, 0.9)
            SetBlipColour(StoreBlip, 70)
        elseif Config.Locations[store]["products"] == Config.Products["diner"] then
            SetBlipSprite(StoreBlip, 52)
            SetBlipScale(StoreBlip, 0.8)
            SetBlipColour(StoreBlip, 33)
        elseif Config.Locations[store]["products"] == Config.Products["digitalden"] then
            SetBlipSprite(StoreBlip, 521)
            SetBlipScale(StoreBlip, 0.8)
            SetBlipColour(StoreBlip, 23)
        elseif Config.Locations[store]["products"] == Config.Products["casino"] then
            SetBlipSprite(StoreBlip, 89)
            SetBlipScale(StoreBlip, 0.80)
            SetBlipColour(StoreBlip, 47)
        elseif Config.Locations[store]["products"] == Config.Products["casinochips"] then
            SetBlipSprite(StoreBlip, 52)
            SetBlipScale(StoreBlip, 0.50)
            SetBlipColour(StoreBlip, 47)
        elseif Config.Locations[store]["products"] == Config.Products["weapons"] then
            SetBlipSprite(StoreBlip, 110)
            SetBlipScale(StoreBlip, 0.85)
        elseif Config.Locations[store]["products"] == Config.Products["leisureshop"] then
            SetBlipSprite(StoreBlip, 52)
            SetBlipScale(StoreBlip, 0.6)
            SetBlipColour(StoreBlip, 3)           
        elseif Config.Locations[store]["products"] == Config.Products["mustapha"] then
            SetBlipSprite(StoreBlip, 225)
            SetBlipScale(StoreBlip, 0.6)
            SetBlipColour(StoreBlip, 3)              
        elseif Config.Locations[store]["products"] == Config.Products["coffeeshop"] then
            SetBlipSprite(StoreBlip, 140)
            SetBlipScale(StoreBlip, 0.55)
        elseif Config.Locations[store]["products"] == Config.Products["stripclub"] then
            SetBlipSprite(StoreBlip, 93)
            SetBlipScale(StoreBlip, 0.8)
            SetBlipColour(StoreBlip, 7)
        elseif Config.Locations[store]["products"] == Config.Products["labchemicals"] then
            SetBlipSprite(StoreBlip, 499)
            SetBlipScale(StoreBlip, 0.8)
            SetBlipColour(StoreBlip, 51)
        elseif Config.Locations[store]["products"] == Config.Products["airlines"] then
            SetBlipSprite(StoreBlip, 377)
            SetBlipScale(StoreBlip, 0.8)
            SetBlipColour(StoreBlip, 0)
        elseif Config.Locations[store]["products"] == Config.Products["arcadebar"] or Config.Locations[store]["products"] == Config.Products["burgershot"] then
            SetBlipScale(StoreBlip, 0.0)
        end

        SetBlipDisplay(StoreBlip, 4)
        SetBlipAsShortRange(StoreBlip, true)
    

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locations[store]["label"])
        EndTextCommandSetBlipName(StoreBlip)
        if _.type == "freshmarket" or _.type == "casinochips2" then
            RemoveBlip(StoreBlip)
        end
        
    end
end)