scCore = nil
isLoggedIn = false
PlayerData = {}
local PlayerJob = {}

local JobsDone = 0
local doingTask = false

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

-- BLIP
Citizen.CreateThread(function()
    ConstructionsBlip = AddBlipForCoord(141.46, -379.73, 43.25)
    SetBlipSprite(ConstructionsBlip, 441)
    SetBlipDisplay(ConstructionsBlip, 4)
    SetBlipScale(ConstructionsBlip, 0.9)
    SetBlipAsShortRange(ConstructionsBlip, true)
    SetBlipColour(ConstructionsBlip, 21)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Construction Site")
    EndTextCommandSetBlipName(ConstructionsBlip)
end)

local BuilderData = {
    ShowDetails = false,
    CurrentTask = nil,
}

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = scCore.Functions.GetPlayerData()
    PlayerJob = scCore.Functions.GetPlayerData().job
    GetCurrentProject()
end)

function GetCurrentProject()
    scCore.TriggerServerCallback('lcrp-construction:server:GetCurrentProject', function(BuilderConfig)
        Config = BuilderConfig
    end)
end

function GetCompletedTasks()
    local retval = {
        completed = 0,
        total = #Config.Projects[Config.CurrentProject].ProjectLocations["tasks"]
    }
    for k, v in pairs(Config.Projects[Config.CurrentProject].ProjectLocations["tasks"]) do
        if v.completed then
            retval.completed = retval.completed + 1
        end
    end
    return retval
end
local MainDistance
local TaskDistance
Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        sleep = 1000
        local data = Config.Projects[Config.CurrentProject].ProjectLocations["main"]
        MainDistance = GetDistanceBetweenCoords(pos, data.coords.x, data.coords.y, data.coords.z, true)

        if MainDistance < 10 then
            sleep = 5
            DrawMarker(2, data.coords.x, data.coords.y, data.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 120, 120, 120, 255, 0, 0, 0, 1, 0, 0, 0)
        end

        for k, v in pairs(Config.Projects[Config.CurrentProject].ProjectLocations["tasks"]) do
            if not v.completed or not v.IsBusy then
                TaskDistance = GetDistanceBetweenCoords(pos, v.coords.x, v.coords.y, v.coords.z, true)
                if TaskDistance < 10 then
                    if not doingTask then
                        sleep = 5
                        DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 223, 230, 239, 200, 0, 0, 0, 1, 0, 0, 0)
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function DoTask()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local TaskData = Config.Projects[1].ProjectLocations["tasks"][BuilderData.CurrentTask]
    local Skillbar = exports['lcrp-skillbar']:GetSkillbarObject()
    local SucceededAttempts = 0
    local NeededAttempts = 3

    TriggerServerEvent('lcrp-construction:server:SetTaskState', BuilderData.CurrentTask, true, false)

    doingTask = true

    if TaskData.type == "hammer" then

        print("DOING TASK")

        doingTask = true
        TriggerEvent('animations:client:EmoteCommandStart', {"hammer"})
        FreezeEntityPosition(ped, true)

        Skillbar.Start({
            duration = math.random(3000, 9000),
            pos = math.random(10, 30),
            width = math.random(7, 12),
        }, function()
            if SucceededAttempts + 1 >= NeededAttempts then
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                scCore.Notification("Hammering finished!")
                FreezeEntityPosition(ped, false)
                TriggerServerEvent('lcrp-construction:server:SetTaskState', BuilderData.CurrentTask, true, true)
                doingTask = false

                JobsDone = JobsDone + 1
                SucceededAttempts = 0
            else
            -- Repeat
            Skillbar.Repeat({
                duration = math.random(1000, 2250),
                pos = math.random(12, 30),
                width = math.random(8, 10),
            })
            SucceededAttempts = SucceededAttempts + 1
        end
        end, function()
            -- Fail
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            FreezeEntityPosition(ped, false)
            scCore.Notification("Hammering failed!", "error")
            doingTask = false

            SucceededAttempts = 0
        end)
    end

if TaskData.type == "weld" then

        doingTask = true
        TriggerEvent('animations:client:EmoteCommandStart', {"weld"})
        FreezeEntityPosition(ped, true)

        Skillbar.Start({
            duration = math.random(3000, 9000),
            pos = math.random(10, 30),
            width = math.random(7, 12),
        }, function()
            if SucceededAttempts + 1 >= NeededAttempts then
                ClearPedTasks(GetPlayerPed(-1))
                ClearPedTasksImmediately(GetPlayerPed(-1))
                scCore.Notification("Welding finished!")
                FreezeEntityPosition(ped, false)
                TriggerServerEvent('lcrp-construction:server:SetTaskState', BuilderData.CurrentTask, true, true)
                doingTask = false

                JobsDone = JobsDone + 1
                SucceededAttempts = 0
            else
            -- Repeat
            Skillbar.Repeat({
                duration = math.random(1000, 2250),
                pos = math.random(12, 30),
                width = math.random(8, 10),
            })
            SucceededAttempts = SucceededAttempts + 1
        end
        end, function()
            -- Fail
            ClearPedTasksImmediately(GetPlayerPed(-1))
            FreezeEntityPosition(ped, false)
            scCore.Notification("Welding failed!", "error")
            doingTask = false

            SucceededAttempts = 0
        end)
    end

end

RegisterNetEvent('lcrp-construction:client:SetTaskState')
AddEventHandler('lcrp-construction:client:SetTaskState', function(Task, IsBusy, IsCompleted)
    if Task ~= nil and IsBusy ~= nil and IsCompleted ~= nil then
        Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][Task].IsBusy = IsBusy
        Config.Projects[Config.CurrentProject].ProjectLocations["tasks"][Task].completed = IsCompleted
    end
end)

RegisterNetEvent('lcrp-construction:client:FinishProject')
AddEventHandler('lcrp-construction:client:FinishProject', function(BuilderConfig)
    Config = BuilderConfig
end)

RegisterNetEvent('lcrp-construction:client:doTask')
AddEventHandler('lcrp-construction:client:doTask', function(task)
    local TaskData = Config.Projects[1].ProjectLocations["tasks"][task]
    if not TaskData.completed or not TaskData.IsBusy then
        if not doingTask then
            BuilderData.CurrentTask = task
            DoTask()
        else
            scCore.Notification("You are already doing something!","error")
        end
    else
        scCore.Notification("This task is doesn't require you attention!","error")
    end
end)

RegisterNetEvent("lcrp-construction:server:ProjectSite")
AddEventHandler("lcrp-construction:server:ProjectSite", function(choice)
    if choice == 1 then
        if JobsDone > 0 then
            TriggerServerEvent('lcrp-construction:server:FinishProject')
            TriggerServerEvent("lcrp-construction:server:01101110")
            JobsDone = 0
        else
            scCore.Notification("You haven't done any work yet", "error")
        end
    else
        local TaskData = GetCompletedTasks()
        TriggerEvent("chatMessage", "CONSTRUCTION", "system", "Tasks: ["..TaskData.completed..' / '..TaskData.total.. "] Completed")
    end
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
	exports["lcrp-interact"]:AddBoxZone("projectLocation", vector3(142.09, -379.92, 43.26), 1.4, 0.8, {
        name="projectLocation",
        heading=340,
        --debugPoly=true,
        minZ=42.46,
        maxZ=45.26 }, {
        options = {
            {
                event = "lcrp-construction:server:ProjectSite",
                icon = "fas fa-money-bill-wave",
                label = "Get paycheck",
                duty = false,
                parameters = 1
            },
            {
                event = "lcrp-construction:server:ProjectSite",
                icon = "fas fa-user-hard-hat",
                label = "Check Details",
                duty = false,
                parameters = 0
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("hammer1", vector3(97.02, -415.49, 37.55), 1.4, 1, {
        name="hammer1",
        heading=340,
        --debugPoly=true,
        minZ=36.55,
        maxZ=38.95 }, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 1
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("hammer2", vector3(86.83, -442.73, 37.55), 1.4, 1, {
        name="hammer2",
        heading=340,
        --debugPoly=true,
        minZ=36.55,
        maxZ=39.55 }, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 2
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("hammer3", vector3(82.43, -457.49, 37.55), 1.0, 1.4, {
        name="hammer3",
        heading=340,
        --debugPoly=true,
        minZ=36.55,
        maxZ=39.55 }, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 3
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding4", vector3(105.82, -357.24, 55.5), 1.2, 1, {
        name="welding4",
        heading=340,
        --debugPoly=true,
        minZ=54.5,
        maxZ=56.9}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 4
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding5", vector3(102.16, -367.16, 55.49), 1.2, 1, {
        name="welding5",
        heading=340,
        --debugPoly=true,
        minZ=54.49,
        maxZ=56.89}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 5
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding6", vector3(98.67, -376.95, 55.5), 1, 1, {
        name="welding6",
        heading=340,
        --debugPoly=true,
        minZ=54.5,
        maxZ=56.9}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 6
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding7", vector3(116.56, -361.14, 55.5), 1, 1, {
        name="welding7",
        heading=340,
        --debugPoly=true,
        minZ=54.5,
        maxZ=56.9}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 7
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding8", vector3(119.98, -351.41, 55.5), 1, 1, {
        name="welding8",
        heading=342,
        --debugPoly=true,
        minZ=54.5,
        maxZ=56.9}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 8
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding9", vector3(109.23, -347.44, 55.5), 1.2, 1, {
        name="welding9",
        heading=340,
        --debugPoly=true,
        minZ=54.5,
        maxZ=57.1}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 9
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding10", vector3(80.3, -342.19, 55.51), 0.8, 0.8, {
        name="welding10",
        heading=340,
        --debugPoly=true,
        minZ=54.51,
        maxZ=56.51}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 10
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding11", vector3(72.25, -339.37, 56.12), 0.6, 0.8, {
        name="welding11",
        heading=346,
        --debugPoly=true,
        minZ=54.52,
        maxZ=57.32}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 11
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding12", vector3(50.82, -346.74, 55.5), 1.0, 1.8, {
        name="welding12",
        heading=340,
        --debugPoly=true,
        minZ=54.5,
        maxZ=56.9}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 12
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding13", vector3(92.0, -361.69, 67.14), 1.0, 1.4, {
        name="welding13",
        heading=340,
        --debugPoly=true,
        minZ=66.14,
        maxZ=69.14}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 13
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding14", vector3(88.08, -372.32, 67.14), 1.0, 1.4, {
        name="welding14",
        heading=340,
        --debugPoly=true,
        minZ=66.34,
        maxZ=69.14}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 14
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding15", vector3(109.2, -379.98, 67.31), 1.0, 1.4, {
        name="welding15",
        heading=340,
        --debugPoly=true,
        minZ=66.11,
        maxZ=69.31}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 15
            },
        },
        job = {"all"}, distance = 3.0})
    exports["lcrp-interact"]:AddBoxZone("welding16", vector3(60.65, -319.51, 67.14), 1.0, 1.6, {
        name="welding16",
        heading=340,
        --debugPoly=true,
        minZ=66.14,
        maxZ=69.14}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 16
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding17", vector3(45.83, -424.63, 45.5), 1, 1, {
        name="welding17",
        heading=341,
        --debugPoly=true,
        minZ=44.5,
        maxZ=46.9}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 17
            },
        },
        job = {"all"}, distance = 3.0})


    exports["lcrp-interact"]:AddBoxZone("welding18", vector3(40.16, -440.5, 45.5), 1, 1, {
        name="welding18",
        heading=340,
        --debugPoly=true,
        minZ=44.5,
        maxZ=46.9}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 18
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding19", vector3(19.48, -450.22, 45.5), 1, 1, {
        name="welding19",
        heading=340,
        --debugPoly=true,
        minZ=44.5,
        maxZ=47.1}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 19
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding20", vector3(30.21, -418.78, 45.55), 1.6, 1, {
        name="welding20",
        heading=340,
        --debugPoly=true,
        minZ=44.55,
        maxZ=46.95}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 20
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding21", vector3(15.22, -413.48, 45.5), 1, 1, {
        name="welding21",
        heading=340,
        --debugPoly=true,
        minZ=44.5,
        maxZ=47.1}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 21
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding22", vector3(21.3, -396.11, 45.5), 1, 1, {
        name="welding22",
        heading=339,
        --debugPoly=true,
        minZ=44.5,
        maxZ=47.3}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 22
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding23", vector3(29.37, -399.31, 45.5), 1, 1, {
        name="welding23",
        heading=340,
        --debugPoly=true,
        minZ=44.5,
        maxZ=46.7}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 23
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding24", vector3(36.36, -401.02, 45.64), 1.4, 1, {
        name="welding24",
        heading=340,
        --debugPoly=true,
        minZ=44.64,
        maxZ=47.44}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 24
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding25", vector3(33.23, -388.37, 45.5), 1, 1, {
        name="welding25",
        heading=340,
        --debugPoly=true,
        minZ=44.5,
        maxZ=47.3}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 25
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding26", vector3(36.97, -377.88, 45.56), 1, 1, {
        name="welding26",
        heading=340,
        --debugPoly=true,
        minZ=44.56,
        maxZ=47.16}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 26
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding27", vector3(44.67, -380.7, 45.5), 1, 1, {
        name="welding27",
        heading=340,
        --debugPoly=true,
        minZ=44.5,
        maxZ=47.3}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 27
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding28", vector3(48.47, -393.96, 45.5), 1, 1, {
        name="welding28",
        heading=340,
        --debugPoly=true,
        minZ=44.5,
        maxZ=47.1}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 28
            },
        },
        job = {"all"}, distance = 3.0})


    exports["lcrp-interact"]:AddBoxZone("welding29", vector3(44.55, -404.91, 45.5), 1, 1, {
        name="welding29",
        heading=340,
        --debugPoly=true,
        minZ=44.5,
        maxZ=46.7}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 29
            },
        },
        job = {"all"}, distance = 3.0})

    exports["lcrp-interact"]:AddBoxZone("welding30", vector3(52.18, -383.41, 45.5), 1, 1, {
        name="welding30",
        heading=340,
        --debugPoly=true,
        minZ=44.5,
        maxZ=47.1}, {
        options = {
            {
                event = "lcrp-construction:client:doTask",
                icon = "fas fa-hammer",
                label = "Start task",
                duty = false,
                parameters = 30
            },
        },
        job = {"all"}, distance = 3.0})
end)