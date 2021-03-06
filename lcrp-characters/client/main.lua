scCore = nil

local charPed = nil

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        if NetworkIsSessionStarted() then
			TriggerEvent('lcrp-characters:client:chooseChar')
			return
		end
	end
end)

local choosingCharacter = false
local cam = nil

function openCharMenu(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "openUI",
        toggle = bool,
    })
    choosingCharacter = bool
    skyCam(bool)
    print('[Character Menu Loaded]')
end

RegisterNUICallback('closeUI', function()
    openCharMenu(false)
end)

RegisterNUICallback('disconnectButton', function()
    TriggerServerEvent('lcrp-characters:server:disconnect')
end)

RegisterNUICallback('selectCharacter', function(data)
    local cData = data.cData
    DoScreenFadeOut(10)
    TriggerServerEvent('lcrp-characters:server:loadUserData', cData)
    openCharMenu(false)
end)

RegisterNetEvent('lcrp-characters:client:closeNUI')
AddEventHandler('lcrp-characters:client:closeNUI', function()
    openCharMenu(false)
end)

RegisterNetEvent('lcrp-characters:client:chooseChar')
AddEventHandler('lcrp-characters:client:chooseChar', function()
    SetNuiFocus(false, false)
    
    -- Freezes player and places player inside interior hidden room
    FreezeEntityPosition(GetPlayerPed(-1), true)
    SetEntityCoords(GetPlayerPed(-1), 296.22, -992.08, -99.0)
    Citizen.Wait(100)
    -- Closes loading screen
    ShutdownLoadingScreenNui()

    -- Disables NATIVE voicechat
    -- NetworkSetTalkerProximity(0.0)

    DoScreenFadeOut(0)
    DoScreenFadeIn(1000)
    openCharMenu(true)
    
    TriggerServerEvent("lcrp-scoreboard:AddPlayer")
end)

function selectChar()
    openCharMenu(true)
end

RegisterNUICallback('cDataPed', function(data)
    local cData = data.cData
   
	RequestModel(GetHashKey("mp_m_freemode_01"))

	while not HasModelLoaded(GetHashKey("mp_m_freemode_01")) do
	    Wait(1)
    end
    
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)

    if cData ~= nil then
        scCore.TriggerServerCallback('lcrp-characters:server:getSkin', function(model, data)
            if model ~= nil then
                model = model ~= nil and tonumber(model) or false

                if not IsModelInCdimage(model) or not IsModelValid(model) then setDefault() return end
            
                Citizen.CreateThread(function()
                    RequestModel(model)
            
                    while not HasModelLoaded(model) do
                        Citizen.Wait(0)
                    end

                    --charPed = CreatePed(3, model, 306.25, -991.09, -99.99, 89.5, false, true)
                    
                    data = json.decode(data)
                    --TriggerEvent('lcrp-clothes:client:loadPlayerClothing', data, charPed)
                --end)
            end)
            else
                --charPed = CreatePed(4, GetHashKey("mp_m_freemode_01"), 306.25, -991.09, -99.99, 89.5, false, true)
            end
        end, cData.citizenid)
    else
        --charPed = CreatePed(4, GetHashKey("mp_m_freemode_01"), 306.25, -991.09, -99.99, 89.5, false, true)
    end

    Citizen.Wait(100)
    
    SetEntityHeading(charPed, 89.5)
    FreezeEntityPosition(charPed, false)
    SetEntityInvincible(charPed, true)
    PlaceObjectOnGroundProperly(charPed)
    SetBlockingOfNonTemporaryEvents(charPed, true)
end)

RegisterNUICallback('setupCharacters', function()
    scCore.TriggerServerCallback("test:yeet", function(result)
        SendNUIMessage({
            action = "setupCharacters",
            characters = result
        })
        SetTimecycleModifier('default')
    end)
end)

RegisterNUICallback("discord", function(data, cb)
	os.execute('open https://discord.gg/f79pGtrA')
end)

RegisterNUICallback('createNewCharacter', function(data)
    print(data)
    local cData = data
    DoScreenFadeOut(150)
    if cData.gender == "man" then
        cData.gender = 0
    elseif cData.gender == "woman" then
        cData.gender = 1
    end

    TriggerServerEvent('lcrp-characters:server:createCharacter', cData)
    TriggerServerEvent('lcrp-characters:server:GiveStarterItems')
    Citizen.Wait(500)
end)

RegisterNUICallback('removeCharacter', function(data)
    TriggerServerEvent('lcrp-characters:server:deleteCharacter', data.citizenid)
end)

function skyCam(bool)
    if bool then
        DoScreenFadeIn(10)
        SetTimecycleModifier('hud_def_blur')
        SetTimecycleModifierStrength(1.0)
        FreezeEntityPosition(GetPlayerPed(-1), false)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1201.083, -2065.208, 1148.4, -2.00, 0.00, 269.50, 85.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    else
        SetTimecycleModifier('default')
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 1, true, true)
        FreezeEntityPosition(GetPlayerPed(-1), false)
    end
end