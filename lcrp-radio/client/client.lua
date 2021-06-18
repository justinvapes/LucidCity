scCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if scCore == nil then
            TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- RADIO KEY USED FOR ANIMATION
local radioKey = 19

local isInRadio = false
local radioMenu = false
local isLoggedIn = false
local volume = tonumber(GetConvar('voice_defaultVolume', '0.3'))

function enableRadio(enable)
  if enable then
    SetNuiFocus(enable, enable)
    PhonePlayIn()
    SendNUIMessage({
      type = "open",
    })
    radioMenu = enable
  end
end

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('scCore:Client:OnPlayerUnload')
AddEventHandler('scCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

Citizen.CreateThread(function()
  while true do
    if scCore ~= nil then
      if isLoggedIn then
        scCore.TriggerServerCallback('lcrp-radio:server:GetItem', function(hasItem)
          if not hasItem then
            exports["pma-voice"]:SetRadioChannel(0)
            exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
            isInRadio = false
            end
        end, "radio")
      end
    end
    Citizen.Wait(10000)
  end
end)

-- RADIO ANIMATION WHILE HOLDING
Citizen.CreateThread(function()
  local playerPed = PlayerPedId()

  while true do
    Citizen.Wait(0)

      if isInRadio then
        while IsControlJustPressed(0, radioKey) do
            TriggerEvent('animations:client:EmoteCommandStart', {"radio"})
            Citizen.Wait(0)
         end

        while IsControlJustReleased(0, radioKey) do
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            Citizen.Wait(0)
         end
      end
  end
end)

RegisterNUICallback('joinRadio', function(data, cb)
  local _source = source
  local PlayerData = scCore.Functions.GetPlayerData()
  local playerName = GetPlayerName(PlayerId())

  if tonumber(data.channel) <= Config.MaxFrequency then
    if tonumber(data.channel) ~= tonumber(getPlayerRadioChannel) then
      if tonumber(data.channel) <= Config.RestrictedChannels then
        if(PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'doctor' or PlayerData.job.name == "fib" or PlayerData.job.name == "statepolice") then
            exports["pma-voice"]:SetRadioChannel(tonumber(data.channel))
            exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
          if SplitStr(data.channel, ".")[2] ~= nil and SplitStr(data.channel, ".")[2] ~= "" then 
            scCore.Notification(Config.messages['joined_to_radio'] .. data.channel .. ' MHz </b>', 'primary')
            isInRadio = true
          else
            scCore.Notification(Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>', 'primary')
            isInRadio = true
          end
        else
          scCore.Notification(Config.messages['restricted_channel_error'], 'error')
        end
      end

      if tonumber(data.channel) > Config.RestrictedChannels then
          exports["pma-voice"]:SetRadioChannel(tonumber(data.channel))
          exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
        if SplitStr(data.channel, ".")[2] ~= nil and SplitStr(data.channel, ".")[2] ~= "" then 
          scCore.Notification(Config.messages['joined_to_radio'] .. data.channel .. ' MHz </b>', 'primary')
          isInRadio = true
        else
          scCore.Notification(Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>', 'primary')
          isInRadio = true
        end
      end
    else
      if SplitStr(data.channel, ".")[2] ~= nil and SplitStr(data.channel, ".")[2] ~= "" then 
        scCore.Notification(Config.messages['you_on_radio'] .. data.channel .. ' MHz </b>', 'error')
      else
        scCore.Notification(Config.messages['you_on_radio'] .. data.channel .. '.00 MHz </b>', 'error')
      end
    end
  else
    scCore.Notification('This frequency is not available.', 'error')
  end
  cb('ok')
end)

RegisterNUICallback('leaveRadio', function(data, cb)
    exports["pma-voice"]:SetRadioChannel(0)
    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
    scCore.Notification("Disconnected from radio")
    isInRadio = false
end)

RegisterNUICallback('volumeDown', function(data, cb)
		if volume > 0.15 then
			  volume = volume - 0.05
			  exports['lcrp-core']:Notification("Changed volume to "..volume)
        exports['pma-voice']:setRadioVolume(volume)
		else
			  exports['lcrp-core']:Notification("Radio is already set to lowest volume!", "error")
    end
end)

RegisterNUICallback('volumeUp', function(data, cb)
   if volume <= 1.0 then
      volume = volume + 0.05
      exports['lcrp-core']:Notification("Changed volume to "..volume)
      exports['pma-voice']:setRadioVolume(volume)
    else
      exports['lcrp-core']:Notification("Radio is already set to highest volume!", "error")
    end
end)

RegisterNUICallback('escape', function(data, cb)
  SetNuiFocus(false, false)
  radioMenu = false
  PhonePlayOut()
  cb('ok')
end)

RegisterNetEvent('lcrp-radio:use')
AddEventHandler('lcrp-radio:use', function()
  enableRadio(true)
end)

RegisterNetEvent('lcrp-radio:onRadioDrop')
AddEventHandler('lcrp-radio:onRadioDrop', function()
  local playerName = GetPlayerName(PlayerId())

  if getPlayerRadioChannel ~= "nil" then
    isInRadio = false
    exports["pma-voice"]:SetRadioChannel(0)
    scCore.Notification("Lost connection with radio")
  end
end)

function SplitStr(inputstr, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
	end
	return t
end