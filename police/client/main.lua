Keys = {
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

local raw = LoadResourceFile(GetCurrentResourceName(), GetResourceMetadata(GetCurrentResourceName(), 'postal_file'))
local postals = json.decode(raw)
local nearest = nil
isLoggedIn = true

isHandcuffed = false
cuffType = 1
isEscorted = false
draggerId = 0
PlayerJob = {}
onDuty = false

databankOpen = false

scCore = nil
Citizen.CreateThread(function() 
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)
        Citizen.Wait(200)
    end
    SetCarItemsInfo()
end)

Citizen.CreateThread(function()
    for k, stationBlips in pairs(Config.Locations["stations"]) do
        local stationblip = AddBlipForCoord(stationBlips.coords.x, stationBlips.coords.y, stationBlips.coords.z)
        SetBlipSprite(stationblip, stationBlips.sprite)
        SetBlipAsShortRange(stationblip, true)
        SetBlipScale(stationblip, 0.8)
        SetBlipColour(stationblip, stationBlips.color)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(stationBlips.label)
        EndTextCommandSetBlipName(stationblip)
    end
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = false
    TriggerServerEvent("police:server:UpdateBlips")


    if (PlayerJob ~= nil) and PlayerJob.name ~= "police" or PlayerJob.name ~= "statepolice" or PlayerJob.name ~= "fib" then
        if DutyBlips ~= nil then 
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
    end
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerJob = scCore.Functions.GetPlayerData().job
    onDuty = PlayerJob.onduty
    isHandcuffed = false
    TriggerServerEvent("scCore:Server:SetMetaData", "ishandcuffed", false)
    TriggerServerEvent("police:server:SetHandcuffStatus", false)
    TriggerServerEvent("police:server:UpdateBlips")
    if PlayerJob.name == "police" and onDuty then TriggerServerEvent("police:server:UpdateCurrentCops", 1) else TriggerServerEvent("police:server:UpdateCurrentCops", 0) end
    --TriggerServerEvent("police:server:CheckBills")
    if scCore.Functions.GetPlayerData().metadata["tracker"] then
        local trackerClothingData = {outfitData = {["accessory"] = { item = 13, texture = 0}}}
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', trackerClothingData)
    else
        local trackerClothingData = {outfitData = {["accessory"]   = { item = -1, texture = 0}}}
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', trackerClothingData)
    end

    if (PlayerJob ~= nil) and PlayerJob.name ~= "police" or PlayerJob.name ~= "statepolice" or PlayerJob.name ~= "fib" then
        if DutyBlips ~= nil then 
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
    end
    TriggerEvent("scCore:client:LoadInteractions")
end)

RegisterNetEvent('police:client:sendBillingMail')
AddEventHandler('police:client:sendBillingMail', function(amount)
    SetTimeout(math.random(2500, 4000), function()
        local gender = "sir"
        if scCore.Functions.GetPlayerData().charinfo.gender == 1 then
            gender = "Mrs"
        end
        local charinfo = scCore.Functions.GetPlayerData().charinfo
        TriggerServerEvent('lcrp-phone:server:sendNewMail', {
            sender = "Lucid police department",
            subject = "Fines",
            message = "Hello ".. gender .. " ".. charinfo.lastname .. "<br /><br />Lucid police department has charged the fines you received from the police.<br /><strong>$"..amount.."</strong> was deducted from your account.<br /><br />With kind regards<br />Mr. K.Smith",
            button = {}
        })
    end)
end)

local tabletProp = nil
RegisterNetEvent('police:client:toggleDatabank')
AddEventHandler('police:client:toggleDatabank', function()
    databankOpen = not databankOpen
    if databankOpen then
        RequestAnimDict("amb@code_human_in_bus_passenger_idles@female@tablet@base")
        while not HasAnimDictLoaded("amb@code_human_in_bus_passenger_idles@female@tablet@base") do
            Citizen.Wait(0)
        end
        local tabletModel = GetHashKey("prop_cs_tablet")
        local bone = GetPedBoneIndex(GetPlayerPed(-1), 60309)
        RequestModel(tabletModel)
        while not HasModelLoaded(tabletModel) do
            Citizen.Wait(100)
        end
        tabletProp = CreateObject(tabletModel, 1.0, 1.0, 1.0, 1, 1, 0)
        AttachEntityToEntity(tabletProp, GetPlayerPed(-1), bone, 0.03, 0.002, -0.0, 10.0, 160.0, 0.0, 1, 0, 0, 0, 2, 1)
        TaskPlayAnim(GetPlayerPed(-1), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "databank",
        })
    else
        DetachEntity(tabletProp, true, true)
        DeleteObject(tabletProp)
        TaskPlayAnim(GetPlayerPed(-1), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "exit", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
        SetNuiFocus(false, false)
        SendNUIMessage({
            type = "closedatabank",
        })
    end
end)


RegisterNUICallback("closeDatabank", function(data, cb)
    databankOpen = false
    DetachEntity(tabletProp, true, true)
    DeleteObject(tabletProp)
    SetNuiFocus(false, false)
    TaskPlayAnim(GetPlayerPed(-1), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "exit", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
end)

RegisterNetEvent('scCore:Client:OnPlayerUnload')
AddEventHandler('scCore:Client:OnPlayerUnload', function()
    TriggerServerEvent('police:server:UpdateBlips')
    TriggerServerEvent("police:server:SetHandcuffStatus", false)
    TriggerServerEvent("police:server:UpdateCurrentCops")
    isLoggedIn = false
    isHandcuffed = false
    isEscorted = false
    onDuty = false
    ClearPedTasks(GetPlayerPed(-1))
    DetachEntity(GetPlayerPed(-1), true, false)
    if DutyBlips ~= nil then 
        for k, v in pairs(DutyBlips) do
            RemoveBlip(v)
        end
        DutyBlips = {}
    end
end)

local DutyBlips = {}
RegisterNetEvent('police:client:UpdateBlips')
AddEventHandler('police:client:UpdateBlips', function(players)
    if PlayerJob ~= nil and (PlayerJob.name == 'police' or PlayerJob.name == 'statepolice' or PlayerJob.name == 'fib' or PlayerJob.name == 'ambulance' or PlayerJob.name == 'doctor') and onDuty then
        if DutyBlips ~= nil then 
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
        if players ~= nil then
            for k, data in pairs(players) do
                local id = GetPlayerFromServerId(data.source)
                if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
                    CreateDutyBlips(id, data.label, data.job)
                end
            end
        end
	end
end)

function CreateDutyBlips(playerId, playerLabel, playerJob)
	local ped = GetPlayerPed(playerId)
	local blip = GetBlipFromEntity(ped)
	if not DoesBlipExist(blip) then
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		ShowHeadingIndicatorOnBlip(blip, true)
		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped)))
        SetBlipScale(blip, 1.0)
        if playerJob == "police" then
            SetBlipColour(blip, 38)
        elseif playerJob == "fib" then
            SetBlipColour(blip, 39)
        elseif playerJob == "statepolice" then
            SetBlipColour(blip, 47)
        else
            SetBlipColour(blip, 5)
        end
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(playerLabel)
        EndTextCommandSetBlipName(blip)
		
		table.insert(DutyBlips, blip)
	end
end

RegisterNetEvent('police:client:PostalCode')
AddEventHandler('police:client:PostalCode', function(args)
    if args[1] then
        local postalArgs = string.upper(args[1])
        
        for _, p in ipairs(postals) do
            if string.upper(p.code) == postalArgs then
                postalPos = p
            end
        end

        if postalPos then
            SetNewWaypoint(postalPos.x, postalPos.y)
            scCore.Notification("Postal waypoint set!")
        else
            scCore.Notification("Postal code doesn\'t exist!", "error")
        end
    else
        local x, y = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
        local ndm = -1
        local ni = -1

        for i, p in ipairs(postals) do
            local dm = (x - p.x) ^ 2 + (y - p.y) ^ 2
            if ndm == -1 or dm < ndm then
                ni = i
                ndm = dm
            end
        end
    
        if ni ~= -1 then
            local nd = math.sqrt(ndm)
            nearest = {i = ni, d = nd}
        end
    
        scCore.Notification("Nearest postal: ".. postals[nearest.i].code.. ", Distance: ".. nearest.d.. "m")
    end
end)

RegisterNetEvent('police:client:SendPoliceEmergencyAlert')
AddEventHandler('police:client:SendPoliceEmergencyAlert', function()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 ~= nil then 
        streetLabel = streetLabel .. " " .. street2
    end
    local alertTitle = "Colleague Assistant"
    if PlayerJob.name == "ambulance" or PlayerJob.name == "doctor" then
        alertTitle = "Assistant " .. PlayerJob.label
    end

    local MyId = GetPlayerServerId(PlayerId())

    TriggerServerEvent("police:server:SendPoliceEmergencyAlert", streetLabel, pos, scCore.Functions.GetPlayerData().metadata["callsign"])
    TriggerServerEvent('lcrp-alerts:server:AddPoliceAlert', {
        timeOut = 10000,
        alertTitle = alertTitle,
        coords = {
            x = pos.x,
            y = pos.y,
            z = pos.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-passport"></i>',
                detail = MyId .. ' | ' .. scCore.Functions.GetPlayerData().charinfo.firstname .. ' ' .. scCore.Functions.GetPlayerData().charinfo.lastname,
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = streetLabel,
            },
        },
        callSign = scCore.Functions.GetPlayerData().metadata["callsign"],
    }, true)
end)

RegisterNetEvent('police:PlaySound')
AddEventHandler('police:PlaySound', function()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
end)

RegisterNetEvent('police:client:PoliceEmergencyAlert')
AddEventHandler('police:client:PoliceEmergencyAlert', function(callsign, streetLabel, coords)
    if (PlayerJob.name == 'police' or PlayerJob.name == 'ambulance' or PlayerJob.name == 'doctor') and onDuty then
        local transG = 250
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 487)
        SetBlipColour(blip, 4)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 1.2)
        SetBlipFlashes(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Assistance Needed")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)

RegisterNetEvent('police:client:DeadAlert')
AddEventHandler('police:client:DeadAlert', function(callsign, streetLabel, coords)
    if (PlayerJob.name == 'ambulance' or PlayerJob.name == 'doctor') and onDuty then
        local transG = 50
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 153)
        SetBlipColour(blip, 83)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 1.2)
        SetBlipFlashes(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Wounded Person")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)

RegisterNetEvent('police:client:GunShotAlert')
AddEventHandler('police:client:GunShotAlert', function(streetLabel, isAutomatic, fromVehicle, coords, vehicleInfo)
    if PlayerJob.name == 'police' or PlayerJob.name == 'fib' and onDuty then        
        local msg = ""
        local blipSprite = 313
        local blipText = "Shots fired"
        local MessageDetails = {}
        if fromVehicle then
            blipText = "Shots fired from vehicle"
            MessageDetails = {
                [1] = {
                    icon = '<i class="fas fa-car"></i>',
                    detail = vehicleInfo.name,
                },
                [2] = {
                    icon = '<i class="fas fa-closed-captioning"></i>',
                    detail = vehicleInfo.plate,
                },
                [3] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = streetLabel,
                },
            }
        else
            blipText = "Shots fired"
            MessageDetails = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = streetLabel,
                },
            }
        end

        TriggerEvent('lcrp-alerts:client:AddPoliceAlert', {
            timeOut = 4000,
            alertTitle = blipText,
            coords = {
                x = coords.x,
                y = coords.y,
                z = coords.z,
            },
            details = MessageDetails,
            callSign = "10-13",
        })

        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        local transG = 250
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, blipSprite)
        SetBlipColour(blip, 0)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(blipText)
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)

RegisterNetEvent('police:client:VehicleCall')
AddEventHandler('police:client:VehicleCall', function(pos, alertTitle, streetLabel, modelPlate, modelName)
    if PlayerJob.name == 'police' or PlayerJob.name == 'fib' and onDuty then
        TriggerEvent('lcrp-alerts:client:AddPoliceAlert', {
            timeOut = 4000,
            alertTitle = alertTitle,
            coords = {
                x = pos.x,
                y = pos.y,
                z = pos.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-car"></i>',
                    detail = "MODEL: ["..modelName.."] PLATE: [".. modelPlate.. "]",
                },
                [2] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = streetLabel,
                },
            },
            callSign = "10-16",
        })
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        local transG = 250
        local blip = AddBlipForCoord(pos.x, pos.y, pos.z)
        SetBlipSprite(blip, 380)
        SetBlipColour(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 1.0)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Report: Carjacking")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)

RegisterNetEvent('police:client:HouseRobberyCall')
AddEventHandler('police:client:HouseRobberyCall', function(coords, msg, gender, streetLabel)
    if PlayerJob.name == 'police' or PlayerJob.name == 'fib' and onDuty then
        TriggerEvent('lcrp-alerts:client:AddPoliceAlert', {
            timeOut = 5000,
            alertTitle = "House Burglary",
            coords = {
                x = coords.x,
                y = coords.y,
                z = coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-venus-mars"></i>',
                    detail = gender,
                },
                [2] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = streetLabel,
                },
            },
            callSign = "10-90",
        },false)

        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        local transG = 250
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 411)
        SetBlipColour(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Report: House Burglary")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)

RegisterNetEvent('911:client:SendPoliceAlert')
AddEventHandler('911:client:SendPoliceAlert', function(notifyType, data, blipSettings)
    if PlayerJob.name == 'police' or PlayerJob.name == 'fib' and onDuty then
        if notifyType == "flagged" then
            TriggerEvent('lcrp-alerts:client:AddPoliceAlert', {
                timeOut = 5000,
                alertTitle = "House invasion attempt",
                details = {
                    [1] = {
                        icon = '<i class="fas fa-video"></i>',
                        detail = data.camId,
                    },
                    [2] = {
                        icon = '<i class="fas fa-closed-captioning"></i>',
                        detail = data.plate,
                    },
                    [3] = {
                        icon = '<i class="fas fa-globe-europe"></i>',
                        detail = data.streetLabel,
                    },
                },
                callSign = "10-90",
            })
            RadarSound()
        end
    
        if blipSettings ~= nil then
            local transG = 250
            local blip = AddBlipForCoord(blipSettings.x, blipSettings.y, blipSettings.z)
            SetBlipSprite(blip, blipSettings.sprite)
            SetBlipColour(blip, blipSettings.color)
            SetBlipDisplay(blip, 4)
            SetBlipAlpha(blip, transG)
            SetBlipScale(blip, blipSettings.scale)
            SetBlipAsShortRange(blip, false)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(blipSettings.text)
            EndTextCommandSetBlipName(blip)
            while transG ~= 0 do
                Wait(180 * 4)
                transG = transG - 1
                SetBlipAlpha(blip, transG)
                if transG == 0 then
                    SetBlipSprite(blip, 2)
                    RemoveBlip(blip)
                    return
                end
            end
        end
    end
end)

RegisterNetEvent('police:client:PoliceAlertMessage')
AddEventHandler('police:client:PoliceAlertMessage', function(title, streetLabel, coords)
    if PlayerJob.name == 'police' or PlayerJob.name == 'fib' and onDuty then
        TriggerEvent('lcrp-alerts:client:AddPoliceAlert', {
            timeOut = 5000,
            alertTitle = title,
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = streetLabel,
                },
            },
            callSign = scCore.Functions.GetPlayerData().metadata["callsign"],
        })

        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        local transG = 100
        local blip = AddBlipForRadius(coords.x, coords.y, coords.z, 100.0)
        SetBlipSprite(blip, 9)
        SetBlipColour(blip, 1)
        SetBlipAlpha(blip, transG)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("999 - "..title)
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)

RegisterNetEvent('police:server:SendEmergencyMessageCheck')
AddEventHandler('police:server:SendEmergencyMessageCheck', function(MainPlayer, message, coords)
    if scCore ~= nil then
        local PlayerData = scCore.Functions.GetPlayerData()
        if PlayerData ~= nil then 
            if PlayerData.job ~= nil then
                if ((PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "doctor") and onDuty) then
                    TriggerEvent('chatMessage', "991 Report - " .. MainPlayer.PlayerData.charinfo.firstname .. " " .. MainPlayer.PlayerData.charinfo.lastname .. " ("..MainPlayer.PlayerData.source..")", "warning", message)
                    TriggerEvent("police:client:EmergencySound")
                    local transG = 250
                    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                    SetBlipSprite(blip, 280)
                    SetBlipColour(blip, 4)
                    SetBlipDisplay(blip, 4)
                    SetBlipAlpha(blip, transG)
                    SetBlipScale(blip, 0.9)
                    SetBlipAsShortRange(blip, false)
                    BeginTextCommandSetBlipName('STRING')
                    AddTextComponentString("991 Report")
                    EndTextCommandSetBlipName(blip)
                    while transG ~= 0 do
                        Wait(180 * 4)
                        transG = transG - 1
                        SetBlipAlpha(blip, transG)
                        if transG == 0 then
                            SetBlipSprite(blip, 2)
                            RemoveBlip(blip)
                            return
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('police:client:Send999AMessage')
AddEventHandler('police:client:Send999AMessage', function(message)
    local PlayerData = scCore.Functions.GetPlayerData()
    if ((PlayerData.job.name == "police" or PlayerData.job.name == "ambulance") and onDuty) then
        TriggerEvent('chatMessage', "ANONYMOUS NOTIFICATION", "warning", message)
        TriggerEvent("police:client:EmergencySound")
    end
end)

RegisterNetEvent('police:client:SendToJail')
AddEventHandler('police:client:SendToJail', function(time)
    TriggerServerEvent("police:server:SetHandcuffStatus", false)
    isHandcuffed = false
    isEscorted = false
    ClearPedTasks(GetPlayerPed(-1))
    DetachEntity(GetPlayerPed(-1), true, false)
    TriggerEvent("lcrp-jail:client:Enter", time)
end)

function RadarSound()
    PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Citizen.Wait(100)
    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Citizen.Wait(100)
    PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Citizen.Wait(100)
    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Citizen.Wait(100)   
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

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end 