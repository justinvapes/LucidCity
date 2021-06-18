scCore = {}
scCore.PlayerData = {}
scCore.Config = scCoreCFG
scCore.Shared = scShared
scCore.ServerCallbacks = {}

isLoggedIn = false
local nbrDisplaying = 0

function GetCoreObject()
	return scCore
end

RegisterNetEvent('scCore:GetObject')
AddEventHandler('scCore:GetObject', function(cb)
	cb(GetCoreObject())
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
	ShutdownLoadingScreenNui()
	isLoggedIn = true
end)

RegisterNetEvent('scCore:Client:OnPlayerUnload')
AddEventHandler('scCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('scCore:Me:Display')
AddEventHandler('scCore:Me:Display', function(text, source)
    Display(GetPlayerFromServerId(source), text, source)
end)

function Display(mePlayer, text, source)
    local displaying = true

    Citizen.CreateThread(function()
        Wait(5000)
        displaying = false
    end)
    Citizen.CreateThread(function()
        local offset = 0 + (nbrDisplaying*0.14)
        nbrDisplaying = nbrDisplaying + 1
        while displaying do
            Wait(0)
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist2(coordsMe, coords)
            if dist < 2500 then
                if dist == 0 and GetPlayerServerId(PlayerId()) == source then
                    scCore.Draw3DText(coordsMe['x'], coordsMe['y'], coordsMe['z'] + offset, text, 1)
                elseif dist ~= 0 then
                    scCore.Draw3DText(coordsMe['x'], coordsMe['y'], coordsMe['z'] + offset, text, 1)
                end
            end
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
end

local cd = {
    ["me"] = false,
    ["think"] = false,
    ["local"] = false,
}

RegisterCommand("me", function(src, args)
    if not cd["me"] then
        local message = table.concat(args, " ")
        TriggerServerEvent('scCore:server:MeDisplay', message)
        cd["me"] = true
        Citizen.Wait(5000)
        cd["me"] = false
    end
end)

RegisterCommand("think", function(src, args)
    if not cd["think"] then
        local message = table.concat(args, " ")
        TriggerServerEvent('scCore:server:Think', message)
        cd["think"] = true
        Citizen.Wait(5000)
        cd["think"] = false
    end
end)

RegisterCommand("local", function(src, args)
    if not cd["local"] then
        local message = table.concat(args, " ")
        TriggerServerEvent('scCore:server:Local', message)
        cd["local"] = true
        Citizen.Wait(5000)
        cd["local"] = false
    end
end)
