local inputOpened = false

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        scCore.Functions.GetPlayerData(function(PlayerData)
            if PlayerData ~= nil and PlayerData.money ~= nil then
                playerCash = PlayerData.money["cash"]
                playerBank = PlayerData.money["bank"]
                playerDead = PlayerData.metadata["isdead"]
                playerCuff = PlayerData.metadata["ishandcuffed"]
                playerCID = PlayerData.citizenid
                playerJob = PlayerData.job.name
            end
        end)

    end
end)

function changeInput(status)
    inputOpened = status
end

function isPlayer(checkType)
	local checkType = string.lower(checkType)
    local pass = false

    if checkType == "playerjob" then
        pass = playerJob
    end

    if checkType == "playercash" then
        pass = playerCash
    end

    if checkType == "playerbank" then
        pass = playerBank
    end

    if checkType == "playerdead" then
        pass = playerDead
    end

    if checkType == "playercuff" then
        pass = playerCuff
    end

    if checkType == "playercid" then
        pass = playerCID
    end

    if checkType == "isinputopened" then
        pass = inputOpened
    end

    return pass
end

function Notification(text, textype, length)
    local ttype = textype ~= nil and textype or "primary"
    local length = length ~= nil and length or 5000
    SendNUIMessage({
        action = "show",
        type = ttype,
        length = length,
        text = text,
    })
end

function GetPlayers()
    local players = {}
        for _, player in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(player)
            if DoesEntityExist(ped) then
                table.insert(players, player)
            end
        end
    return players
end

function TaskBar()
    exports['progressbar']:Progress({
        name = name:lower(),
        duration = duration,
        label = label,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        controlDisables = disableControls,
        animation = animation,
        prop = prop,
        propTwo = propTwo,
    }, function(cancelled)
        if not cancelled then
            if onFinish ~= nil then
                onFinish()
            end
        else
            if onCancel ~= nil then
                onCancel()
            end
        end
    end)
end