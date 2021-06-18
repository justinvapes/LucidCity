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
local ATMObjects = {
  -870868698,
  -1126237515,
  -1364697528,
  506770882,
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if scCore == nil then
            TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

local banks = {
  [1] = {name="Bank", Closed = false, id=108, x = 314.187,   y = -278.621,  z = 54.170},
  [2] = {name="Bank", Closed = false, id=108, x = 150.266,   y = -1040.203, z = 29.374},
  [3] = {name="Bank", Closed = false, id=108, x = -351.534,  y = -49.529,   z = 49.042},
  [4] = {name="Bank", Closed = false, id=108, x = -1212.980, y = -330.841,  z = 37.787},
  [5] = {name="Bank", Closed = false, id=108, x = -2962.582, y = 482.627,   z = 15.703},
  [6] = {name="Bank", Closed = false, id=108, x = -112.202,  y = 6469.295,  z = 31.626},
  [7] = {name="Bank", Closed = false, id=108, x = 241.727,   y = 220.706,   z = 106.286},
}

RegisterNetEvent('banking:client:SetBankClosed')
AddEventHandler('banking:client:SetBankClosed', function(BankId, bool)
  banks[BankId].Closed = bool
end)

-- Display Map Blips
Citizen.CreateThread(function()
    for _, item in pairs(banks) do
        item.blip = AddBlipForCoord(item.x, item.y, item.z)
        SetBlipSprite(item.blip, item.id)
        SetBlipColour(item.blip, 0)
        SetBlipScale(item.blip, 0.6)
        SetBlipAsShortRange(item.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(item.name)
        EndTextCommandSetBlipName(item.blip)
    end
end)

-- NUI Variables
local bankOpen = false
local atmOpen = false

-- Open Gui and Focus NUI
function openGui()
  local ped = GetPlayerPed(-1)
  local playerPed = GetPlayerPed(-1)
  local PlayerData = scCore.Functions.GetPlayerData()
  TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_ATM", 0, true)
  scCore.TaskBar("use_bank", "Inserting card", 2500, false, true, {}, {}, {}, {}, function() -- Done
      ClearPedTasksImmediately(ped)
      SetNuiFocus(true, true)
      SendNUIMessage({
        openBank = true,
        PlayerData = PlayerData
      })
  end, function() -- Cancel
      ClearPedTasksImmediately(ped)
      scCore.Notification("Cancelled", "error")
  end)
end

-- Close Gui and disable NUI
function closeGui()
  SetNuiFocus(false, false)
  SendNUIMessage({openBank = false})
  bankOpen = false
  atmOpen = false
end

RegisterNetEvent("banking:client:OpenBank")
AddEventHandler("banking:client:OpenBank", function()
    if not IsInVehicle() then
        if bankOpen then
            closeGui()
            bankOpen = false
        else
            openGui()
            bankOpen = true
        end
    end
end)

-- Disable controls while GUI open
Citizen.CreateThread(function()
  while true do
    if bankOpen or atmOpen then
      local ply = GetPlayerPed(-1)
      local active = true
      DisableControlAction(0, 1, active) -- LookLeftRight
      DisableControlAction(0, 2, active) -- LookUpDown
      DisableControlAction(0, 24, active) -- Attack
      DisablePlayerFiring(ply, true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
    end
    Citizen.Wait(0)
  end
end)

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  closeGui()
  cb('ok')
end)

RegisterNUICallback('transfers', function(data, cb)
  scCore.TriggerServerCallback('lcrp-banking:server:getTransferData', function(result)
    if result ~= nil then
      cb({transactions = result, hasTrans = true, account = scCore.Functions.GetPlayerData().charinfo["account"]})
    else
      cb({transactions = result, hasTrans = false, account = scCore.Functions.GetPlayerData().charinfo["account"]})
    end
  end)
end)

RegisterNUICallback('newTransfer', function(data, cb)
  TriggerServerEvent('lcrp-banking:server:saveTransfer', { transaction = data.transaction, amount = data.amount})
  cb('ok')
end)

RegisterNUICallback('balance', function(data, cb)
  SendNUIMessage({openSection = "balance"})
  cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
  SendNUIMessage({openSection = "withdraw"})
  cb('ok')
end)

RegisterNUICallback('deposit', function(data, cb)
  SendNUIMessage({openSection = "deposit"})
  cb('ok')
end)

RegisterNUICallback('send', function(data, cb)
  SendNUIMessage({openSection = "send"})
  cb('ok')
end)

RegisterNUICallback('transferSubmit', function(data, cb)
  local fromPlayer = GetPlayerServerId();
  TriggerServerEvent('lcrp-banking:server:saveTransfer', { transaction = "transfer", amount = data.amount, plyid = data.toPlayer})
  cb('ok')
end)

-- Check if player is in a vehicle
function IsInVehicle()
  local ply = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

-- Check if player is near another player
function IsNearPlayer(player)
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  local ply2 = GetPlayerPed(GetPlayerFromServerId(player))
  local ply2Coords = GetEntityCoords(ply2, 0)
  local distance = GetDistanceBetweenCoords(ply2Coords["x"], ply2Coords["y"], ply2Coords["z"],  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
  if(distance <= 5) then
    return true
  end
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

RegisterNetEvent('banking:client:CheckDistance')
AddEventHandler('banking:client:CheckDistance', function(targetId, amount)
  local player, distance = GetClosestPlayer()
  if player ~= -1 and distance < 2.5 then
    local playerId = GetPlayerServerId(player)
    if targetId == playerId then
      TriggerServerEvent('banking:server:giveCash', playerId, amount)
    end
  else
    scCore.Notification('You\'re not near the person', 'error')
  end
end)


RegisterNetEvent('lcrp-banking:client:updateBank')
AddEventHandler('lcrp-banking:client:updateBank', function(bank)
  SendNUIMessage({
      updateBalance = true,
      bankAmount = bank
  })
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddTargetModel(ATMObjects, {
      options = {
          {
              event = "banking:client:OpenBank",
              icon = "fas fa-money-check-alt",
              label = "Use ATM",
              duty = false,
          },
      },
    job = {"all"}, distance = 1.5})

    exports["lcrp-interact"]:AddBoxZone("bank1", vector3(1175.19, 2707.54, 38.09), 1.2, 2.8, {
      name="bank1",
      heading=0,
      --debugPoly=true,
      minZ=37.09,
      maxZ=41.09}, {
      options = {
          {
              event = "banking:client:OpenBank",
              icon = "fas fa-money-check-alt",
              label = "Open Bank",
              duty = false,
          },
      },
    job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("bank2", vector3(-2961.91, 482.76, 15.7), 2.4, 1, {
      name="bank2",
      heading=0,
      --debugPoly=true,
      minZ=14.7,
      maxZ=18.7
    }, {
      options = {
          {
              event = "banking:client:OpenBank",
              icon = "fas fa-money-check-alt",
              label = "Open Bank",
              duty = false,
          },
      },
    job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("bank3", vector3(252.63, 221.23, 106.29), 2.95, 1.6, {
      name="bank3",
      heading=70,
      minZ=105.19,
      maxZ=108.79 }, {
      options = {
          {
              event = "banking:client:OpenBank",
              icon = "fas fa-money-check-alt",
              label = "Open Bank",
              duty = false,
          },
      },
    job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("bank4", vector3(242.22, 224.99, 106.29), 2.95, 1.6, {
      name="bank4",
      heading=70,
      minZ=105.19,
      maxZ=108.79 }, {
      options = {
          {
              event = "banking:client:OpenBank",
              icon = "fas fa-money-check-alt",
              label = "Open Bank",
              duty = false,
          },
      },
    job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("bank5", vector3(-1212.63, -331.33, 37.79), 1.2, 2.6, {
      name="bank5",
      heading=25,
      --debugPoly=true,
      minZ=36.79,
      maxZ=40.79
    }, {
      options = {
          {
              event = "banking:client:OpenBank",
              icon = "fas fa-money-check-alt",
              label = "Open Bank",
              duty = false,
          },
      },
    job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("bank6", vector3(-351.61, -50.51, 49.04), 1.0, 2.6, {
      name="bank6",
      heading=340,
      --debugPoly=true,
      minZ=48.04,
      maxZ=52.04
    }, {
      options = {
          {
              event = "banking:client:OpenBank",
              icon = "fas fa-money-check-alt",
              label = "Open Bank",
              duty = false,
          },
      },
    job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("bank7", vector3(313.48, -279.47, 54.17), 1.2, 2.4, {
      name="bank7",
      heading=340,
      --debugPoly=true,
      minZ=53.17,
      maxZ=57.17}, {
      options = {
          {
              event = "banking:client:OpenBank",
              icon = "fas fa-money-check-alt",
              label = "Open Bank",
              duty = false,
          },
      },
    job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("bank8", vector3(149.16, -1041.19, 29.37), 1, 2.4, {
      name="bank8",
      heading=340,
      --debugPoly=true,
      minZ=28.37,
      maxZ=32.37
    }, {
      options = {
          {
              event = "banking:client:OpenBank",
              icon = "fas fa-money-check-alt",
              label = "Open Bank",
              duty = false,
          },
      },
    job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("bank9", vector3(-112.15, 6469.84, 31.63), 0.6, 3.8, {
      name="bank9",
      --debugPoly=true,
      heading=315,
      minZ=28.83,
      maxZ=32.43 }, {
      options = {
          {
              event = "banking:client:OpenBank",
              icon = "fas fa-money-check-alt",
              label = "Open Bank",
              duty = false,
          },
      },
    job = {"all"}, distance = 2.0 })
end)
