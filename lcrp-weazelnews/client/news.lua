scCore = nil
Citizen.CreateThread(function() 
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)
        Citizen.Wait(200)
    end
end)

local PlayerJob = {}
local newsStands = {
  1211559620,
  -1186769817,
  -756152956,
  720581693, 
  -838860344,
}

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    PlayerJob = scCore.Functions.GetPlayerData().job
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)

RegisterNUICallback('getLive', function(data, cb)
  scCore.TriggerServerCallback('lcrp-weazelnews:server:getLive', function(result)
      cb(result)
  end)
end)

local guiEnabled = false
local hasOpened = false

local endloop = false

function openGui()
  SetPlayerControl(PlayerId(), 0, 0)
  guiEnabled = true
  SetNuiFocus(true)
  SendNUIMessage({openWarrants = true})

  if hasOpened == false then
    lstContacts = {}
    hasOpened = true
  end
end

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(-597.89, -929.95, 24.0)
    SetBlipSprite(blip, 459)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.6)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Weazel News")
    EndTextCommandSetBlipName(blip)
end)

function closeGui()
  endloop = true
  SetNuiFocus(false)
  SendNUIMessage({openSection = "close"})
  guiEnabled = false
  SetPlayerControl(PlayerId(), 1, 0)
  TriggerEvent("destroyProp")
end

RegisterNUICallback('close', function(data, cb)
  closeGui()
  cb('ok')
end)

RegisterNetEvent('NewsStandCheckFinish')
AddEventHandler('NewsStandCheckFinish', function(newsArray1,newsArray2)
  openGui()
  guiEnabled = true
  SendNUIMessage({openSection = "newsUpdate", string = newsArray1, string2 = newsArray2})

  TriggerEvent("attachItem","newspaper01")
  endloop = false
  local plycoords = GetEntityCoords(PlayerPedId())
  while not endloop do

    local adist = math.ceil(#(plycoords - GetEntityCoords(PlayerPedId())))

    if not IsEntityPlayingAnim(PlayerPedId(), "amb@world_human_tourist_map@female@base", "base", 3) then
        RequestAnimDict('amb@world_human_tourist_map@female@base')
      while not HasAnimDictLoaded("amb@world_human_tourist_map@female@base") do
        Citizen.Wait(0)
      end
      TaskPlayAnim(PlayerPedId(), "amb@world_human_tourist_map@female@base", "base", 8.0, -8, -1, 49, 0, 0, 0, 0)
    end
    if adist > 2 then
      endloop = true
    end
    Citizen.Wait(1)
  end
  closeGui()
  ClearPedTasksImmediately(PlayerPedId())
end)

local robberyCount = 0
local shotsFiredCount = 0
RegisterNetEvent("lcrp-weazelnews:client:CrimeStatistics")
AddEventHandler("lcrp-weazelnews:client:CrimeStatistics", function(crimeType, value)
  if crimeType == "robbery" then
    robberyCount = robberyCount + value
  end
  if crimeType == "shotsFired" then
    shotsFiredCount = shotsFiredCount + value
  end
end)

RegisterNetEvent('lcrp-weazelnews:client:Strings')
AddEventHandler('lcrp-weazelnews:client:Strings', function(newsInfo, newsWriter)

	local strg = "<font size='5px'>Daily News</font> <br><br> <br> <b> <font size='2px'>".. newsInfo .. "<br> <br> <font size='1px'>Reporter:</b></font> ".. newsWriter
  
  if shotsFiredCount == 0 or robberyCount == 0 then
    crimeRateMessage = "No reports"
  end
  if shotsFiredCount >= 1 or robberyCount >= 1 then
    crimeRateMessage = "Peaceful"
  end
  if shotsFiredCount >= 10 or robberyCount >= 10 then
    crimeRateMessage = "Normal"
  end
  if shotsFiredCount >= 300 or robberyCount >= 30 then
    crimeRateMessage = "Violent"
  end

	--local currentTax = exports["lcrp-tax"]:getTax()
	local currentTax = 7
	local strg2 = "<font size='5px'>Government Statistics</font> <br> <b><font size='3px'>Current tax:</b> " .. currentTax .. "%".. 
  "<br><br><br> <font size='5px'>Daily Crime Statistics</font> <br><font size='3px'><b>City crimerate:</b> ".. crimeRateMessage

	TriggerEvent("NewsStandCheckFinish", strg, strg2)
end)

function checkForNewsStand()
for i = 1, #newsStands do
  local objFound = GetClosestObjectOfType( GetEntityCoords(PlayerPedId()), 1.5, newsStands[i], 0, 0, 0)
  if DoesEntityExist(objFound) then
    return true and objFound
  end
end
return false
end

function MenuGarage()
  ped = GetPlayerPed(-1);
  MenuTitle = "Garage"
  ClearMenu()
  Menu.addButton("Vehicle List", "VehicleList", nil)
  Menu.addButton("Close Menu", "closeMenuFull", nil) 
end

function VehicleList(isDown)
  ped = GetPlayerPed(-1);
  MenuTitle = "Vehicles:"
  ClearMenu()
  for k, v in pairs(Config.Vehicles) do
      Menu.addButton(Config.Vehicles[k], "TakeOutVehicle", k, "Garage", " Engine: 100%", " Body: 100%", " Fuel: 100%")
  end
      
  Menu.addButton("Back", "MenuGarage", nil)
end

function TakeOutVehicle(vehicleInfo)
  local playerPed = GetPlayerPed(-1)
  local playerCoords = GetEntityCoords(playerPed)
  local coords = {x = playerCoords.x , y = playerCoords.y, z = playerCoords.z, a = 0.0}
  scCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
      SetVehicleNumberPlateText(veh, "WEAZEL"..tostring(math.random(10, 99)))
      SetEntityHeading(veh, coords.h)
      SetVehicleLivery(veh, 2)
      exports['LegacyFuel']:SetFuel(veh, 100.0)
      closeMenuFull()
      TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
      TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
      SetVehicleEngineOn(veh, true, true)
      CurrentPlate = GetVehicleNumberPlateText(veh)
  end, coords, true)
end

function closeMenuFull()
  Menu.hidden = true
  currentGarage = nil
  renderGUI = false
  ClearMenu()
end

RegisterNetEvent("lcrp-weazelnews:client:Garage")
AddEventHandler("lcrp-weazelnews:client:Garage", function()
   if PlayerJob.name == "reporter" then
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            scCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
        else
            MenuGarage()
            currentGarage = k
            Menu.hidden = not Menu.hidden
            renderGUI = true

          while renderGUI do
              Wait(5)
              Menu.renderGUI()
          end
       end
    end
end)

RegisterNetEvent("lcrp-weazelnews:client:WriteNews")
AddEventHandler("lcrp-weazelnews:client:WriteNews", function()
    if PlayerJob.name == "reporter" then
      TriggerEvent('animations:client:EmoteCommandStart', {"notepad"})
  
      local dailyNewsInput = scCore.KeyboardInput("Type in Daily News Post (MAX 500 characters)", "", 500)
      local areYouSure = scCore.KeyboardInput("Are you sure? Type: (y/n)", "", 1)
    
      if areYouSure == "y" then
          TriggerServerEvent("lcrp-weazelnews:server:updateDailyNews", dailyNewsInput)
          scCore.Notification("Daily news updated!", "primary")
          TriggerEvent('animations:client:EmoteCommandStart', {"c"})
      else
          TriggerEvent('animations:client:EmoteCommandStart', {"c"})
          scCore.Notification("Cancelled", "error")
      end
    end
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddTargetModel(newsStands, {
      options = {
          {
              event = "lcrp-weazelnews:server:fetchNews",
              icon = "far fa-newspaper",
              label = "Check Daily Newspaper",
              duty = false,
              serverEvent = true,
          },
      },
    job = {"all"}, distance = 1.5})

    -- weazel news actions

  exports["lcrp-interact"]:AddBoxZone("weazelNewsBoss", vector3(-581.8, -937.29, 23.88), 2.4, 1.3, {
    name="weazelNewsBoss",
    heading=0,
    --debugPoly=true,
    minZ=22.88,
    maxZ=24.48 }, {
    options = {
        {
            event = "lcrp-weazelnews:client:WriteNews",
            icon = "fas fa-pen-alt",
            label = "Write daily news",
            duty = true,
        },
        {
            event = "lcrp-weazelnews:server:fetchNews",
            icon = "far fa-newspaper",
            label = "Check Newspaper",
            duty = true,
            serverEvent = true,
        },
        {
          event = "police:client:BossActions",
          icon = "far fa-clipboard",
          label = "Boss Actions",
          duty = true,
      },
      },
  job = {"reporter"}, distance = 1.5 })

  exports["lcrp-interact"]:AddBoxZone("weazelNewsDuty", vector3(-580.88, -926.87, 23.88), 0.6, 2.8, {
    name="weazelNewsDuty",
    heading=0,
    --debugPoly=true,
    minZ=22.48,
    maxZ=25.48 }, {
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
  job = {"reporter"}, distance = 1.5 })

  exports["lcrp-interact"]:AddBoxZone("weazelNewsWrite", vector3(-577.42, -934.99, 23.88), 2.4, 2.4, {
    name="weazelNewsWrite",
    heading=0,
    --debugPoly=true,
    minZ=22.88,
    maxZ=24.68 }, {
    options = {
      {
          event = "lcrp-weazelnews:client:WriteNews",
          icon = "fas fa-pen-alt",
          label = "Write daily news",
          duty = true,
      },
    },
    job = {"reporter"}, distance = 2.5})

  exports["lcrp-interact"]:AddBoxZone("weazelNewsFetch", vector3(-589.16, -937.42, 23.88), 0.8, 2.6, {
    name="weazelNewsFetch",
    heading=0,
    --debugPoly=true,
    minZ=22.88,
    maxZ=25.08 }, {
    options = {
      {
        event = "lcrp-weazelnews:server:fetchNews",
        icon = "far fa-newspaper",
        label = "Check Newspaper",
        duty = true,
        serverEvent = true,
      },
    },
    job = {"reporter"}, distance = 1.5})

  exports["lcrp-interact"]:AddBoxZone("weazelNewsGarage", vector3(-544.55, -891.76, 24.56), 11.6, 9.4, {
    name="weazelNewsGarage",
    heading=0,
    minZ=23.36,
    maxZ=27.36 }, {
    options = {
      {
          event = "lcrp-weazelnews:client:Garage",
          icon = "fas fa-car-alt",
          label = "Weazel News Garage",
          storeVeh = true,
          duty = true,
      },
    },
  job = {"reporter"}, distance = 5.5 })

  exports["lcrp-interact"]:AddBoxZone("weazelNewsHeli", vector3(-583.28, -930.72, 36.83), 10.6, 10.8, {
    name="weazelNewsHeli",
    heading=0,
    --debugPoly=true,
    minZ=35.23,
    maxZ=38.83 }, {
    options = {
      {
          event = "lcrp-weazelnews:client:takeHeli",
          icon = "fas fa-helicopter",
          label = "Take Heli",
          storeVeh = true,
          duty = true,
          parameters = "frogger"
      },
    },
  job = {"reporter"}, distance = 10.0 })

end)

RegisterNetEvent("lcrp-weazelnews:client:takeHeli")
AddEventHandler("lcrp-weazelnews:client:takeHeli", function(vehCode)
  if PlayerJob.name == "reporter" then
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        scCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
    else
      TakeOutVehicle(vehCode)
    end
  end
end)