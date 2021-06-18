scCore = nil
isLoggedIn = true
PlayerJob = {}
Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

vehicleCategorys = {
    ["coupes"] = {
        label = "Coupes",
        vehicles = {}
    },
    ["sedans"] = {
        label = "Sedans",
        vehicles = {}
    },
    ["muscle"] = {
        label = "Muscle",
        vehicles = {}
    },
    ["suvs"] = {
        label = "SUVs",
        vehicles = {}
    },
    ["compacts"] = {
        label = "Compacts",
        vehicles = {}
    },
    ["vans"] = {
        label = "Vans",
        vehicles = {}
    },
    ["super"] = {
        label = "Super",
        vehicles = {}
    },
    ["sports"] = {
        label = "Sports",
        vehicles = {}
    },
    ["sportsclassics"] = {
        label = "Sports Classics",
        vehicles = {}
    },
    ["motorcycles"] = {
        label = "Motorcycles",
        vehicles = {}
    },
    ["offroad"] = {
        label = "Offroad",
        vehicles = {}
    },
}

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    scCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        onDuty = PlayerJob.onduty
    end)
    isLoggedIn = true
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

function openVehicleShop(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        ui = bool
    })
end

function setupVehicles(vehs)
    SendNUIMessage({
        action = "setupVehicles",
        vehicles = vehs
    })
end

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    for k, v in pairs(scCore.Shared.Vehicles) do
        if v["shop"] == "pdm" then
            for cat,_ in pairs(vehicleCategorys) do
                if scCore.Shared.Vehicles[k]["category"] == cat then
                    table.insert(vehicleCategorys[cat].vehicles, scCore.Shared.Vehicles[k])
                end
            end
        end
    end
end)

RegisterNUICallback('GetCategoryVehicles', function(data)
    for k, v in pairs(scCore.Shared.Vehicles) do
        if v["shop"] == "pdm" then
            for cat,_ in pairs(vehicleCategorys) do
                if scCore.Shared.Vehicles[k]["category"] == data.selectedCategory then
                    setupVehicles(vehicleCategorys[data.selectedCategory].vehicles)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    modelHash = GetHashKey("a_m_y_business_02")
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(1)
    end
    if not DoesEntityExist(ped) then

        RequestAnimDict("anim@heists@heist_corona@team_idles@male_a")
        while not HasAnimDictLoaded("anim@heists@heist_corona@team_idles@male_a") do
            Wait(1)
        end
        ped =  CreatePed(4, modelHash, Config.VehicleShopNPC.coords.x, Config.VehicleShopNPC.coords.y, Config.VehicleShopNPC.coords.z, 3374176, false, true)
        SetEntityAsMissionEntity(ped)
        SetEntityHeading(ped, Config.VehicleShopNPC.coords.h)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskPlayAnim(ped,"anim@heists@heist_corona@team_idles@male_a","idle", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
        ped = nil
    end
end)

RegisterNUICallback('exit', function()
    openVehicleShop(false)
end)

RegisterNUICallback('buyVehicle', function(data)
    local vehicleData = data.vehicleData
    local garage = data.garage

    TriggerServerEvent('lcrp-vehicleshop:server:buyVehicle', vehicleData, garage)
    openVehicleShop(false)
end)

Citizen.CreateThread(function()
    Dealer = AddBlipForCoord(Config.VehicleShop.coords.x, Config.VehicleShop.coords.y, Config.VehicleShop.coords.z)

    SetBlipSprite (Dealer, 326)
    SetBlipDisplay(Dealer, 4)
    SetBlipScale  (Dealer, 0.75)
    SetBlipAsShortRange(Dealer, true)
    SetBlipColour(Dealer, 3)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Premium Deluxe Motorsports")
    EndTextCommandSetBlipName(Dealer)
end)

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent("lcrp-vehicleshop:client:OpenPDM")
AddEventHandler("lcrp-vehicleshop:client:OpenPDM", function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(PlayerPedId())
    local distance = Vdist(coords, Config.VehicleShop.coords.x, Config.VehicleShop.coords.y, Config.VehicleShop.coords.z)

    if distance < 5.0 then
        openVehicleShop(true)
    end
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddBoxZone("PDM", vector3(Config.VehicleShop.coords.x, Config.VehicleShop.coords.y, Config.VehicleShop.coords.z), 4.0, 3.4, {
        name="PDM",
        heading=Config.VehicleShop.coords.h,
        minZ=25.22,
        maxZ=28.02 
    }, {
        options = {
            {
                event = "lcrp-vehicleshop:client:OpenPDM",
                icon = "fas fa-cars",
                label = "Open PDM Catalog",
                duty = false,
            },
        },
    job = {"all"}, distance = 2.0})
end)