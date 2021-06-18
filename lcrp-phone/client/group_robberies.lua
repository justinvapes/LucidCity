local invites = {}
local groupLeader
local onCooldown = false
local playerCooldownFinish
local group
local isSearching = false
local AlertActive =  false
local groupMaxSize = 3
local startBlip

RegisterNUICallback('creategroup', function(data,cb)
    scCore.TriggerServerCallback('appheists:server:playerHasRobbery', function(inRobbery)
        if not inRobbery then
            creategroup()
        end
        cb({['inRobbery']= inRobbery})
    end)
end)

RegisterNUICallback('getPlayerIdGroup', function(data,cb)
    cb(PhoneData.PlayerData.source)
end)

RegisterNUICallback('leaveGroup', function(data, cb)
    leaveGroup(data.groupid)
    cb("You left the group!");
end)

RegisterNUICallback('jobCompleted', function(data, cb)
    TriggerServerEvent('appheists:server:jobCompleted')
    cb('')
end)

RegisterNUICallback('PhoneInPocket', function(data, cb)
    AlertActive = true
    SetTimeout(data.timeout, function()
        AlertActive = false
    end)
    cb(true)
end)

RegisterNUICallback('inRobbery', function(data, cb)
    scCore.TriggerServerCallback('appheists:server:playerHasRobbery', function(inRobbery)
        local notification = 'You are currently in a Robbery!'
        cb({['inRobbery'] = inRobbery,['notification'] = notification})
    end)
end)

RegisterNUICallback('acceptGroup', function(data, cb)
    scCore.TriggerServerCallback('appheists:server:playerHasRobbery', function(inRobbery)
        local notification = 'You are currently in a Robbery!'
        if not inRobbery then
            scCore.TriggerServerCallback('appheists:server:playerCanJoinGroup',function(result)
                if result then
                    TriggerServerEvent('appheists:server:inviteReponse', data.groupId, data.status)
                    invites[data.groupId] = nil
                    groupLeader = tonumber(data.groupId)
                    notification = "You accepted the invite"
                else
                    inRobbery = true
                    notification = 'Group no longer available'
                end
                cb({['inRobbery'] = inRobbery,['notification'] = notification})
            end, data.groupId)
        else
            cb({['inRobbery'] = inRobbery,['notification'] = notification})
        end
    end)
end)

RegisterNUICallback('getGroup', function(groupId,cb)
    scCore.TriggerServerCallback('appheists:server:getGroup', function(groupNames)
        cb(groupNames)
    end,groupId.groupid)
end)


-- 
RegisterNetEvent('appheists:client:newRobberyNotif')
AddEventHandler('appheists:client:newRobberyNotif',function(robbery) 
    -- dont show details, only notify of the job
    -- trigger new robbery notif
    SendNUIMessage({
        action = "newRobNoti",
        robbery= robbery,
    })
end)


RegisterNetEvent('appheists:client:receiveInvite')
AddEventHandler('appheists:client:receiveInvite',function(fromPlayer)
    -- trigger UI INVITE
    invites[fromPlayer] = 'pending'
    SendNUIMessage({
        action = "receiveRobInvite",
        InviteFN = fromPlayer.firstname,
        InviteLN = fromPlayer.lastname,
        id = fromPlayer.id,
        size = fromPlayer.groupSize,
    })
end)

RegisterNetEvent('appheists:client:inviteResponse')
AddEventHandler('appheists:client:inviteResponse',function(playerInfo,response)
    
    if response == 'true' then
        group['players'][tostring(playerInfo.id)] = 'member'

        SendNUIMessage({
            action = "joinedRobGroup",
            InviteFN = playerInfo.firstname,
            InviteLN = playerInfo.lastname,
            id = playerInfo.id,
        })
    else
        SendNUIMessage({
            action = "declineRobGroup",
            InviteFN = playerInfo.firstname,
            InviteLN = playerInfo.lastname,
            id = playerInfo.id,
        })
    end
    
end)

RegisterNetEvent('appheists:client:notifyMemberLeave')
AddEventHandler('appheists:client:notifyMemberLeave',function(playerInfo)
    SendNUIMessage({
        action = "notifyRobLeave",
        id = playerInfo.id,
    })
    if scCore ~= nil then
        scCore.Notification(playerInfo.id.." "..playerInfo.firstname.." "..playerInfo.lastname.." has left the group!")
    end

end)

RegisterNetEvent('appheists:client:notifyMemberKicked')
AddEventHandler('appheists:client:notifyMemberKicked',function(playerId)
    SendNUIMessage({
        action = "kickedRobGroup",
    })
end)

RegisterNetEvent('appheists:client:getRobberyDetails')
AddEventHandler('appheists:client:getRobberyDetails',function(robberyCoords, robName)
    SendNUIMessage({
        action = "robberyFound",
    })
    
    startBlip = AddBlipForCoord(robberyCoords)
    local robberyName = robName

    SetBlipRoute(startBlip, true)
    SetBlipRouteColour(startBlip, 69)

    Citizen.CreateThread(function()
        local hasArrived = false
        local blipCoords = GetBlipCoords(startBlip)
        while not hasArrived do
            local player = GetEntityCoords(GetPlayerPed(-1))
            if GetDistanceBetweenCoords(player,blipCoords) < 5 then
                if startBlip ~= nil then
                    hasArrived = true
                    SendNUIMessage({
                        action = "rob2",
                    })
                    TriggerEvent('lcrp-houses-robberies:client:ArrivedAtJob', robberyName)
                    TriggerServerEvent('appheists:server:arrivedAtRobbery', robberyName)

                    RemoveBlip(startBlip)
                end
            end
            Citizen.Wait(1000)
        end   
    end)

    Citizen.CreateThread(function()
        Citizen.Wait(600000)
        if startBlip ~= nil then
            hasArrived = true
            RemoveBlip(startBlip)
        end
    end)
    
    -- MAP MARKER
end)

RegisterNetEvent('appheists:client:playerLeftRobbery')
AddEventHandler('appheists:client:playerLeftRobbery',function(buyerLocation)
    SendNUIMessage({
        action = "rob3",
    })
end)


RegisterNetEvent('appheists:client:JobCompleted')
AddEventHandler('appheists:client:JobCompleted',function(buyerLocation)
    SendNUIMessage({
        action = "rob4",
    })
end)



RegisterNetEvent('appheists:client:resetThiefPhone')
AddEventHandler('appheists:client:resetThiefPhone',function()
    SendNUIMessage({
        action = "resetRob",
    })
end)

RegisterNetEvent('appheists:client:robberyLost')
AddEventHandler('appheists:client:robberyLost',function(robberyName)
    scCore.Notification("You didn't arrive at the location in time! You lost your job",'error')
    if startBlip ~= nil then
        RemoveBlip(startBlip)
    end
    SendNUIMessage({
        action = "resetRob",
    })
end)

RegisterNetEvent('appheists:client:robberyNotAvailable')
AddEventHandler('appheists:client:robberyNotAvailable',function(robberyName)
    if scCore ~= nil then
        scCore.Notification('Robbery no longer available', 'error')
        scCore.Notification('Your group is still searching for a robbery.')
    end
end)

RegisterNetEvent('appheists:client:setPlayerCooldown')
AddEventHandler('appheists:client:setPlayerCooldown',function(cooldown)
    onCooldown = true
    playerCooldownFinish = cooldown
end)

RegisterNetEvent('appheists:client:sendDayTime')
AddEventHandler('appheists:client:sendDayTime',function()
    local hours = GetClockHours()
    TriggerServerEvent('appheists:server:receiveDayTime',hours)
end)

RegisterNetEvent('appheists:client:playerFound')
AddEventHandler('appheists:client:playerFound',function(playerInfo)
    if scCore ~= nil then
        scCore.Notification(playerInfo.id.." "..playerInfo.firstname.." "..playerInfo.lastname.." has joined your group!")
        SendNUIMessage({
            action = "playerRobFound",
        })
    end
end)

RegisterNetEvent('appheists:client:groupFound')
AddEventHandler('appheists:client:groupFound',function(group)
    isSearching = false
    local leaderid = -1
    for k,v in pairs(group) do
        if (group[k] == "leader") then
            leaderid = k
            break
        end
    end
    SendNUIMessage({
        action = "groupRobFound",
        group = leaderid,
    })
end)

Citizen.CreateThread(function()
    while true do
        if onCooldown then
            playerCooldownFinish = playerCooldownFinish - 1
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        TriggerServerEvent('appheists:server:robberyTime',true)
        Citizen.Wait(300000)
    end
end)

function creategroup()
    TriggerServerEvent('appheists:server:creategroup')
    local Player = PhoneData.PlayerData.source
    group = {
        ['players'] = {
            [tostring(Player)] = 'leader'
        },
        ['open'] = false  
    }
end

RegisterNUICallback('invitePlayerById', function(inviteId,cb)
    cb(invitePlayer(inviteId.inviteId))
end)

function invitePlayer(id) 
    local groupSize = 0

    for k in pairs(group['players']) do 
        groupSize = groupSize + 1
    end
    if groupSize < groupMaxSize then
        TriggerServerEvent('appheists:server:invitePlayer', id)
        return("Invite sent to "..id)
    else
        return("Group is full!")
    end
end

RegisterNUICallback('stopSearchRobbery', function(data,cb)
    stopSearchRobbery()
    cb("")
end)

function stopSearchRobbery()
    TriggerServerEvent('appheists:server:stopSearch')
end

RegisterNUICallback('findRobberyJob', function(data,cb)
    scCore.TriggerServerCallback('appheists:server:startSearch', function(data)
        cb({['enoughCops'] = data[1], ['canSearch'] = data[2]})
    end)
end)


function leaveGroup(leaderId)
    if leaderId ~= nil then
        TriggerServerEvent('appheists:server:leaveGroup', false,leaderId)
    end
end

RegisterNUICallback('acceptRobbery', function(data,cb)
    scCore.TriggerServerCallback('appheists:server:acceptRobbery', function(available)
        cb({['available']=available})
    end, data.robName)
end)

RegisterNUICallback('findRobGroup', function(data,cb)
    findGroup()
    cb("")
end)
RegisterNUICallback('cancelFindGroup', function(data,cb)
    isSearching = false
    cb("")
end)


function findGroup()
    isSearching = true
    Citizen.CreateThread(function()
        while isSearching do
            TriggerServerEvent('appheists:server:findGroup')
            Citizen.Wait(1000)
        end
    end)
end

RegisterNUICallback('kickFromGroup', function(data,cb)
    kickFromGroup(data.kickId,data.groupId)
    cb("Player was kicked!")
end)


function kickFromGroup(playerId,groupId)
    TriggerServerEvent('appheists:server:kickFromGroup',playerId,groupId)
end


RegisterNUICallback('toggleGroup', function(data,cb)
    toggleOpen()
    cb("")
end)

function toggleOpen()
    group['open'] = not group['open']
    TriggerServerEvent('appheists:server:toggleOpen')
end


Citizen.CreateThread(function()
    while true do
        if AlertActive then
            if IsControlJustPressed(0, Keys["LEFTALT"]) then
                SetNuiFocus(true, true)
                SetNuiFocusKeepInput(true, false)
                SetCursorLocation(0.965, 0.12)
                MouseActive = true
            end
        end

        if MouseActive then
            if IsControlJustReleased(0, Keys["LEFTALT"]) then
                SetNuiFocus(false, false)
                SetNuiFocusKeepInput(false, false)
                MouseActive = false
            end
        end

        Citizen.Wait(6)
    end
end)