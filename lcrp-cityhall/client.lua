Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

scCore = nil

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

local redeemed = false
local JobListingCoords = {coords = {x = -1082.12, y = -247.65, z = 37.76}}
local CityhallCoords = {coords = {x = -552.0, y = -191.68, z = 38.22}}
local ViewBusinesses = {x = -539.70, y = -177.80, z = 38.22}
local Moneywash = {
    [1] = {x = 4904.15, y = -5273.58, z = -1.37},
    [2] = {x = 4905.67, y = -5273.51, z = -1.37},
    [3] = {x = 4907.19, y = -5273.49, z = -1.37},
    [4] = {x = 4909.61, y = -5273.47, z = -1.37},
    [5] = {x = 4911.08, y = -5273.47, z = -1.37},
    [6] = {x = 4912.99, y = -5273.41, z = -1.37},
    [7] = {x = 4915.60, y = -5273.43, z = -1.37},
    [8] = {x = 4917.20, y = -5273.52, z = -1.37},
    [9] = {x = 4918.80, y = -5273.42, z = -1.37},
}

Citizen.CreateThread(function()
    CityhallBlip = AddBlipForCoord(CityhallCoords.coords.x, CityhallCoords.coords.y, CityhallCoords.coords.z)

    SetBlipSprite (CityhallBlip, 419)
    SetBlipDisplay(CityhallBlip, 4)
    SetBlipScale  (CityhallBlip, 0.9)
    SetBlipAsShortRange(CityhallBlip, true)
    SetBlipColour(CityhallBlip, 0)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("City Hall")
    EndTextCommandSetBlipName(CityhallBlip)
end)

-- Map blip
Citizen.CreateThread(function()
    JobListingBlip = AddBlipForCoord(JobListingCoords.coords.x, JobListingCoords.coords.y, JobListingCoords.coords.z)

    SetBlipSprite (JobListingBlip, 351)
    SetBlipDisplay(JobListingBlip, 4)
    SetBlipScale  (JobListingBlip, 0.9)
    SetBlipAsShortRange(JobListingBlip, true)
    SetBlipColour(JobListingBlip, 59)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Employment center")
    EndTextCommandSetBlipName(JobListingBlip)
end)

function closeMenuFull()
    choosing = false
	Menu.hidden = true
	currentGarage = nil
	renderGUI = false
    FreezeEntityPosition(PlayerPedId(), false)
    ClearMenu()
end

RegisterNetEvent("lcrp-cityhall:client:ChangeJob")
AddEventHandler("lcrp-cityhall:client:ChangeJob", function(jobData)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(PlayerPedId())
    local PlayerData = scCore.Functions.GetPlayerData()
    if PlayerData.job.name == jobData.job then
        scCore.Notification("You already work as ".. jobData.label)
        ClearMenu()
    elseif PlayerData.job.name ~= "builder" and PlayerData.job.name ~= "slaughterer" and PlayerData.job.name ~= "lumberjack" and PlayerData.job.name ~= "machinerestock" and PlayerData.job.name ~= "unemployed" then
        scCore.Notification("You may do extra work as ".. jobData.label)
        ClearMenu()
    else
        ClearMenu()
        TriggerServerEvent("lcrp-cityhall:server:ChangeJob", jobData.job)
        scCore.Notification("You were hired as ".. jobData.label)
    end
    SetNewWaypoint(jobData.coords)
    scCore.Notification("The starting location for " .. jobData.label .. " is marked on your GPS!")
end)

function MenuCompanies()
    scCore.TriggerServerCallback('lcrp-cityhall:server:getCompanies', function(result)
        for k, v in pairs(result) do
            local capital = result[k].capital
            local name = result[k].name
            Menu.addButton(name.." | $"..capital, "closeMenuFull", nil)
        end
        Menu.addButton("Close Menu", "closeMenuFull", nil)
    end)
end


RegisterNetEvent('lcrp-cityhall:client:startWash')
AddEventHandler('lcrp-cityhall:client:startWash', function(expireTime, hasWashed, amount)
    local timer = (0.0001 * amount) * 60000
    scCore.TaskBar("work_carrybox", "Washing money", timer, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@gangops@facility@servers@",
        anim = "hotwire",
        flags = 16,
    }, {}, {}, function() -- Done
        TriggerServerEvent('lcrp-cityhall:server:washMoney2', expireTime, hasWashed, amount)
        ClearPedTasks(GetPlayerPed(-1))
    end, function() -- Cancel
        ClearPedTasks(GetPlayerPed(-1))
        scCore.Notification("Canceled", "error")
    end)
end)

function chooseCar(cars)
    scCore.TriggerServerCallback('lcrp-garages:server:GetAllVehicles', function(cars)
        MenuTitle = "Vehicles:"
        FreezeEntityPosition(PlayerPedId(), true)
        for k, v in pairs(cars) do
            Menu.addButton(v.label, "choosePlate", v.plate, nil)
        end
        Menu.addButton("Close menu", "closeMenuFull",nil)
    end)
end

function choosePlate(oldPlate)
    closeMenuFull()
    local newPlate = scCore.KeyboardInput("Insert plate - 8 chars max, no blank spaces or symbols", "", 8)
    if newPlate ~= nil then
        TriggerServerEvent("lcrp-cityhall:server:registerPlate", oldPlate, newPlate)
    else
        scCore.Notification("Invalid input!", "error", 4500)
    end
end

RegisterNetEvent("lcrp-cityhall:client:StartingMoney")
AddEventHandler("lcrp-cityhall:client:StartingMoney", function()
    if not redeemed then
        redeemed = true
        TriggerServerEvent("lcrp-base:server:StartMoney", source)
        Citizen.Wait(500)
    else
        scCore.Notification("You already claimed the starter money!")
    end
end)

RegisterNetEvent("lcrp-cityhall:client:OpenCompany")
AddEventHandler("lcrp-cityhall:client:OpenCompany", function()
    companyName = scCore.KeyboardInput("Company name (letters only)", "", 100)
    if companyName ~= nil then 
        TriggerServerEvent("lcrp-cityhall:server:createIlegalCompany", companyName)
    else
        scCore.Notification("Dude you gotta input the name..)!")
    end
end)

RegisterNetEvent("lcrp-cityhall:client:viewCompanies")
AddEventHandler("lcrp-cityhall:client:viewCompanies", function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    ClearMenu()
    Menu.hidden = not Menu.hidden
    renderGUI = true
    MenuCompanies()

    Citizen.CreateThread(function()
        while renderGUI do
            Wait(5)
            local playerLoc = GetEntityCoords(ped)
            local distance = GetDistanceBetweenCoords(pos, playerLoc.x, playerLoc.y, playerLoc.z, false)
            if distance > 0.5 then
                closeMenuFull()
                break
            end
    
            Menu.renderGUI()
        end
    end)
end)

RegisterNetEvent("lcrp-cityhall:client:vipPlate")
AddEventHandler("lcrp-cityhall:client:vipPlate", function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local PlayerData = scCore.Functions.GetPlayerData()
    if PlayerData.donations.plate ~= nil and PlayerData.donations.plate > 0 then
        ClearMenu()
        Menu.hidden = not Menu.hidden
        renderGUI = true

        chooseCar()
    else
        scCore.Notification("You don\'t have any permit to change the plate. Check http://store.lucidcityrp.com/", "error", 4500)
    end
    Citizen.CreateThread(function()
        while renderGUI do
            Wait(5)
            local playerLoc = GetEntityCoords(ped)
            local distance = GetDistanceBetweenCoords(pos, playerLoc.x, playerLoc.y, playerLoc.z, false)
            if distance > 0.5 then
                closeMenuFull()
                break
            end
    
            Menu.renderGUI()
        end
    end)
end)

RegisterNetEvent("lcrp-cityhall:client:WashDirtyMoney")
AddEventHandler("lcrp-cityhall:client:WashDirtyMoney", function(loc)
    local coords = GetEntityCoords(PlayerPedId())
    local distance = Vdist(coords, Moneywash[loc].x, Moneywash[loc].y, Moneywash[loc].z)

    if distance < 5.0 then
        amount = scCore.KeyboardInput("Amount to wash", "", 100)
        if amount ~= nil then 
            amount = tonumber(amount)
            if amount ~= nil and amount > 0 then 
                TriggerServerEvent("lcrp-cityhall:server:washMoney", amount)
            else
                scCore.Notification("Invalid amount!")
            end
        else
            scCore.Notification("You need to input the amount (number)!")
        end
    end
end)

RegisterNetEvent("lcrp-cityhall:client:DepositCompanyMoney")
AddEventHandler("lcrp-cityhall:client:DepositCompanyMoney", function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local distance = GetDistanceBetweenCoords(pos, ViewBusinesses.x, ViewBusinesses.y, ViewBusinesses.z, false)

    if distance < 5.0 then
        amount = tonumber(scCore.KeyboardInput("Amount to deposit", "", 100))
        if amount ~= nil and amount > 0 then 
            TriggerServerEvent("lcrp-cityhall:server:depositMoney", amount)
        else
            scCore.Notification("Invalid amount!")
        end
    end
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    jobList = {}
    
    for k, jobs in pairs(Config.Jobs) do
        table.insert(jobList, {
            event = "lcrp-cityhall:client:ChangeJob",
            icon = "fal fa-clipboard-list",
            label = jobs.label,
            duty = false,
            parameters = jobs
        })
    end
    
    exports["lcrp-interact"]:AddBoxZone("jobListing", vector3(JobListingCoords.coords.x, JobListingCoords.coords.y, JobListingCoords.coords.z), 2.0, 2.0, {
        name="jobListing",
        heading=300,
        minZ=33.96,
        maxZ=39.56 }, {
        options = jobList,
    job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("cityHall", vector3(CityhallCoords.coords.x, CityhallCoords.coords.y, CityhallCoords.coords.z), 2.0, 1.5, {
        name="cityHall",
        heading=349,
        minZ=35.62,
        maxZ=39.62
        }, {
        options = {
            {
                event = "lcrp-cityhall:server:giveId",
                icon = "fad fa-address-card",
                label = "Buy ID card",
                duty = false,
                serverEvent = true,
            },
            {
                event = "lcrp-cityhall:client:StartingMoney",
                icon = "fas fa-sack-dollar",
                label = "Redeem Starting Money",
                duty = false,
            },
            {
                event = "lcrp-cityhall:client:vipPlate",
                icon = "fad fa-text-size",
                label = "Change car plate",
                duty = false,
            },
            {
                event = "lcrp-cityhall:client:OpenCompany",
                icon = "fad fa-phone-office",
                label = "Open A Company",
                duty = false,
            },
        },
    job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("companyMenu", vector3(ViewBusinesses.x, ViewBusinesses.y, ViewBusinesses.z), 2.0, 1.5, {
        name="companyMenu",
        heading=300,
        minZ=36.02,
        maxZ=40.02
        }, {
        options = {
            {
                event = "lcrp-cityhall:client:viewCompanies",
                icon = "fad fa-list-ul",
                label = "View Active Companies",
                duty = false,
            },
            {
                event = "lcrp-cityhall:client:DepositCompanyMoney",
                icon = "far fa-money-bill",
                label = "Increase company capital",
                duty = false,
            },
        },
    job = {"all"}, distance = 2.0 })

    for k, v in pairs(Moneywash) do
        exports["lcrp-interact"]:AddBoxZone("washDirtyMoney"..k, vector3(Moneywash[k].x, Moneywash[k].y, Moneywash[k].z), 1.2, 1.4, {
            name="washDirtyMoney"..k,
            heading=0,
            minZ=-2.38,
            maxZ=0.02,
        }, {
            options = {
                {
                    event = "lcrp-cityhall:client:WashDirtyMoney",
                    icon = "far fa-money-bill-alt",
                    label = "Wash Dirty Money",
                    duty = false,
                    parameters = k,
                },
            },
        job = {"all"}, distance = 2.0 })
    end
end)