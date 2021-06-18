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

scCore                  = nil
local CurrentAction     = nil
local CurrentActionMsg  = nil
local CurrentActionData = nil
local Licenses          = {}
local CurrentTest       = nil
local CurrentTestType   = nil
local CurrentVehicle    = nil
local CurrentCheckPoint = 0
local LastCheckPoint    = -1
local CurrentBlip       = nil
local CurrentZoneType   = nil
local DriveErrors       = 0
local IsAboveSpeedLimit = false
local LastVehicleHealth = nil

Citizen.CreateThread(function()
    while scCore == nil do
        Citizen.Wait(10)
        TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
        Citizen.Wait(200)
    end
end)

Citizen.CreateThread(function()
  DrivingSchoolBlip = AddBlipForCoord(DrivingSchool.coords.x, DrivingSchool.coords.y, DrivingSchool.coords.z)

  SetBlipSprite (DrivingSchoolBlip, 498)
  SetBlipDisplay(DrivingSchoolBlip, 4)
  SetBlipScale  (DrivingSchoolBlip, 0.9)
  SetBlipAsShortRange(DrivingSchoolBlip, true)
  SetBlipColour(DrivingSchoolBlip, 37)

  BeginTextCommandSetBlipName("STRING")
  AddTextComponentSubstringPlayerName("Driving school")
  EndTextCommandSetBlipName(DrivingSchoolBlip)
end)

function DrawMissionText(msg, time)
  ClearPrints()
  SetTextEntry_2('STRING')
  AddTextComponentString(msg)
  DrawSubtitleTimed(time, 1)
end

RegisterNetEvent("lcrp-licenses:client:StartTheoryTest")
AddEventHandler("lcrp-licenses:client:StartTheoryTest", function()

  CurrentTest = 'theory'

  SendNUIMessage({
    openQuestion = true
  })

  Citizen.Wait(200)
  SetNuiFocus(true, true)

end)

function StopTheoryTest(success)
  CurrentTest = nil
  SendNUIMessage({
    openQuestion = false
  })
  SetNuiFocus(false)

  if success then
    TriggerServerEvent("lcrp-licenses:server:addTest", false)
    scCore.Notification("You passed theory test")
  else
    TriggerServerEvent("lcrp-licenses:server:addTest", true)
    scCore.Notification("You failed theory test", "error")
  end
end

RegisterNetEvent("lcrp-licenses:client:StartDriveTest")
AddEventHandler("lcrp-licenses:client:StartDriveTest", function(type)
  coords = Config.Zones.VehicleSpawnPoint.Pos
  scCore.Functions.SpawnVehicle(Config.VehicleModels[type], function(vehicle)
      CurrentTest       = 'drive'
      CurrentTestType   = type
      CurrentCheckPoint = 0
      LastCheckPoint    = -1
      CurrentZoneType   = 'residence'
      DriveErrors       = 0
      IsAboveSpeedLimit = false
      CurrentVehicle    = vehicle
      LastVehicleHealth = GetEntityHealth(vehicle)
      local playerPed   = GetPlayerPed(-1)

      SetVehicleNumberPlateText(vehicle, "DMV"..tostring(math.random(10, 99)))
      SetEntityHeading(vehicle, 72.0)
      exports['LegacyFuel']:SetFuel(vehicle, 100.0)
      --closeMenuFull()
      TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
      SetVehicleEngineOn(vehicle, true, true)
      TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    end, coords, true)
end)

function StopDriveTest(success, currentTest)

  if CurrentTestType == "drive_bike" then
    CurrentTestType = "A"
  end
  if CurrentTestType == "drive" then
    CurrentTestType = "B"
  end
  if CurrentTestType == "drive_truck" then
    CurrentTestType = "C"
  end

  if success then
    TriggerServerEvent('lcrp-licenses:server:AddLicense', CurrentTestType)
    scCore.Notification("You passed the drivers test")
  else
    scCore.Notification("You failed drivers test", "error")
  end

  CurrentTest     = nil
  CurrentTestType = nil
end

function SetCurrentZoneType(type)
  CurrentZoneType = type
end


--[[ function OpenDMVSchoolMenu()
  scCore.TriggerServerCallback("lcrp-licenses:server:checkDriverLicenses", function(hasA, hasB, hasC)
      scCore.TriggerServerCallback('lcrp-radio:server:GetItem', function(hasItem)
        if not hasItem then
            Menu.addButton("Start theory test", "theoryTest", nil)
        end
        if hasItem then
          if not hasA then
            Menu.addButton("[A] Start driver test ("..Config.Prices["drive_bike"].."$)", "driversTestA", nil)
          end
          if not hasB then
            Menu.addButton("[B] Start driver test ("..Config.Prices["drive"].."$)", "driversTestB", nil)
          end
          if not hasC then
            Menu.addButton("[C] Start driver test ("..Config.Prices["drive_truck"].."$)", "driversTestC", nil)
          end
      end
    end, "driving-test")
      Menu.addButton("Close Menu", "closeMenuFull", nil) 
  end)
end ]]

--[[ function driversTestA()
  TriggerServerEvent('lcrp-licenses:server:Pay', "drivers-test", "A")
end
function driversTestB()
  TriggerServerEvent('lcrp-licenses:server:Pay', "drivers-test", "B")
end
function driversTestC()
  TriggerServerEvent('lcrp-licenses:server:Pay', "drivers-test", "C")
end

function theoryTest()
  closeMenuFull()
  TriggerServerEvent('lcrp-licenses:server:Pay', "theory-test")
end

function closeMenuFull()
  Menu.hidden = true
  currentGarage = nil
  ClearMenu()
  TriggerEvent('lcrp-licenses:client:hasExitedMarker', LastZone)
  HasAlreadyEnteredMarker = false
end ]]

RegisterNUICallback('question', function(data, cb)

  SendNUIMessage({
    openSection = 'question'
  })

  cb('OK')
end)

RegisterNUICallback('close', function(data, cb)
  StopTheoryTest(true)
  cb('OK')
end)

RegisterNUICallback('kick', function(data, cb)
  StopTheoryTest(false)
  cb('OK')
end)

RegisterNUICallback('closeButton', function(data, cb)
  StopTheoryTest(false)
  CurrentTest = nil
  SendNUIMessage({
    openQuestion = false
  })
  SetNuiFocus(false)
end)

--[[ AddEventHandler('lcrp-licenses:client:hasEnteredMarker', function(zone)
  if zone == 'DMVSchool' then
    CurrentAction     = 'dmvschool_menu'
    CurrentActionMsg  = 'Press ~INPUT_CONTEXT~ to open menu'
    CurrentActionData = {}
  end
end)

AddEventHandler('lcrp-licenses:client:hasExitedMarker', function(zone)
  CurrentAction = nil
  ClearMenu()
end)
 ]]
-- Display markers
--[[ Citizen.CreateThread(function()
  while true do
    sleep = 5
    local coords = GetEntityCoords(GetPlayerPed(-1))
    for k,v in pairs(Config.Zones) do
      if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 5.0) then
        sleep = 5
        DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
        

        if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 2.0) then
          SetTextComponentFormat('STRING')
          AddTextComponentString(CurrentActionMsg)
          DisplayHelpTextFromStringLabel(0, 0, 1, -1)
          if IsControlJustReleased(0, Keys['E']) then
            OpenDMVSchoolMenu()
            Menu.hidden = not Menu.hidden
        end
      Menu.renderGUI()
      end
    end
  end
    Citizen.Wait(sleep)
  end
end) ]]
RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
  exports["lcrp-interact"]:AddBoxZone("theoryTest", vector3(226.1, 375.03, 106.11), 2.0, 2.2, {
    name="theoryTest",
    heading=340,
    minZ=105.31,
    maxZ=106.71 }, {
    options = {
        {
          event = "",
          icon = "",
          label = "DMV",
          duty = false,
        },
        {
          event = "lcrp-licenses:server:manageLicense",
          icon = "far fa-clipboard",
          label = "Theory Test",
          duty = false,
          serverEvent = true,
          parameters = {
            type = "theory-test",
            price = "dmv"
          }
        },
        {
          event = "lcrp-licenses:server:manageLicense",
          icon = "far fa-motorcycle",
          label = "Driving Test Type A - Motorbikes",
          duty = false,
          serverEvent = true,
          parameters = {
            type = "drivers-test",
            driversTest = "A",
            price = "drive"
          }
        },
        {
          event = "lcrp-licenses:server:manageLicense",
          icon = "far fa-car",
          label = "Driving Test Type B - Cars",
          duty = false,
          serverEvent = true,
          parameters = {
            type = "drivers-test",
            driversTest = "B",
            price = "drive_bike"
          }
        },
        {
          event = "lcrp-licenses:server:manageLicense",
          icon = "far fa-truck",
          label = "Driving Test Type C - Trucks",
          duty = false,
          serverEvent = true,
          parameters = {
            type = "drivers-test",
            driversTest = "C",
            price = "drive_truck"
          }
        },
      },
    job = {"all"}, distance = 2 })

    exports["lcrp-interact"]:AddBoxZone("buyDrivers", vector3(228.19, 378.72, 106.11), 2.6, 1.35, {
      name="buyDrivers",
      heading=340,
      minZ=105.31,
      maxZ=106.51 }, {
      options = {
          {
            event = "",
            icon = "",
            label = "DMV",
            duty = false,
          },
          {
            event = "lcrp-licenses:server:BuyDriversLicense",
            icon = "fas fa-id-card",
            label = "Buy drivers license document ($50)",
            duty = false,
            serverEvent = true,
          },
        },
      job = {"all"}, distance = 2 })
end)

--[[ 
-- Enter / Exit marker events
Citizen.CreateThread(function()
  while true do
    sleep = 5
    local coords      = GetEntityCoords(GetPlayerPed(-1))
    local isInMarker  = false
    local currentZone = nil

    for k,v in pairs(Config.Zones) do
      if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 2.0) then
        sleep = 5
        isInMarker  = true
        currentZone = k
      else
        sleep = 500
      end
    end

    if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
      sleep = 5
      HasAlreadyEnteredMarker = true
      LastZone                = currentZone
      TriggerEvent('lcrp-licenses:client:hasEnteredMarker', currentZone)
    end

    if not isInMarker and HasAlreadyEnteredMarker then
      sleep = 500
      HasAlreadyEnteredMarker = false
      TriggerEvent('lcrp-licenses:client:hasExitedMarker', LastZone)
    end

    Citizen.Wait(sleep)
  end
end) ]]

-- Block UI
Citizen.CreateThread(function()
  while true do
    sleep = 2000
    if CurrentTest == 'theory' then
      sleep = 5
      local playerPed = PlayerPedId()
      DisableControlAction(0, 1, true) -- LookLeftRight
      DisableControlAction(0, 2, true) -- LookUpDown
      DisablePlayerFiring(playerPed, true) -- Disable weapon firing
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
    elseif CurrentTest == 'drive' then
      sleep = 5
      local playerPed      = PlayerPedId()
      local coords         = GetEntityCoords(playerPed)
      local nextCheckPoint = CurrentCheckPoint + 1
      if IsPedInAnyVehicle(playerPed,  false) then
        local vehicle      = GetVehiclePedIsIn(playerPed,  false)
        local speed        = GetEntitySpeed(vehicle) * Config.SpeedMultiplier
        local tooMuchSpeed = false
        for k,v in pairs(Config.SpeedLimits) do
          if CurrentZoneType == k and speed > v then
            tooMuchSpeed = true
            if not IsAboveSpeedLimit then
              DriveErrors       = DriveErrors + 1
              IsAboveSpeedLimit = true
              scCore.Notification('You\'re driving too fast! Speed Limit: ' .. v .. 'mp/h', 'error')
              scCore.Notification('Fail errors: '.. DriveErrors .. '/' .. Config.MaxErrors, 'error')
            end
          end
        end
        if not tooMuchSpeed then
          IsAboveSpeedLimit = false
        end
        local health = GetEntityHealth(vehicle)
        if health < LastVehicleHealth then
          DriveErrors = DriveErrors + 1
          scCore.Notification('you damaged the vehicle', 'error')
          scCore.Notification('Fail errors:' .. DriveErrors .. '/' .. Config.MaxErrors, 'error')
          LastVehicleHealth = health
        end
      end
      if Config.CheckPoints[nextCheckPoint] == nil then
        if DoesBlipExist(CurrentBlip) then
          RemoveBlip(CurrentBlip)
        end
        CurrentTest = nil

        scCore.Notification("Driving test completed")

        if DriveErrors < Config.MaxErrors then
          StopDriveTest(true, CurrentTestType)
        else
          StopDriveTest(false, CurrentTestType)
        end
        else
        if CurrentCheckPoint ~= LastCheckPoint then
          if DoesBlipExist(CurrentBlip) then
            RemoveBlip(CurrentBlip)
          end
          CurrentBlip = AddBlipForCoord(Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z)
          SetBlipRoute(CurrentBlip, 1)
          LastCheckPoint = CurrentCheckPoint
        end

        local distance = GetDistanceBetweenCoords(coords, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, true)
        if distance <= 100.0 then
          DrawMarker(1, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
        end
        if distance <= 3.0 then
          if IsPedInAnyVehicle(playerPed, false) then
            Config.CheckPoints[nextCheckPoint].Action(playerPed, CurrentVehicle, SetCurrentZoneType)
            CurrentCheckPoint = CurrentCheckPoint + 1
          end
        end
      end
    end
    Citizen.Wait(sleep)
  end
end)




