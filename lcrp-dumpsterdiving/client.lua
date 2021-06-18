scCore = nil

local searched = {3423423424}
local canSearch = true
local searchTime = 14000
local Keys = {["E"] = 38, ["SPACE"] = 22, ["DELETE"] = 178,["F"] = 23}

local PlayerLoaded = false

Citizen.CreateThread(function()
	while scCore == nil do
		TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
		Citizen.Wait(0)
	end
end)



RegisterNetEvent("lcrp-dumpster:client:searchDumpster")
AddEventHandler("lcrp-dumpster:client:searchDumpster", function()
    if canSearch then
        for k,v in pairs(Config.dumpsters) do
            local dumpster = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.5, v, false, false, false)
            if dumpster ~= 0 then
                local dumpsterSearched = false
                for i,j in pairs(searched) do
                    if j == dumpster then
                        dumpsterSearched = true
                        break
                    end
                end
    
                if not dumpsterSearched then
                    if IsPedInAnyVehicle(PlayerPedId(), true) ~= 1 then
                        startSearching(searchTime, 'amb@prop_human_bum_bin@base', 'base',dumpster)
                        TriggerServerEvent('lcrp-dumpsterdiving:startDumpsterTimer', dumpster)
                    else
                        scCore.Notification("I can't reach the dumpster")
                    end
                else
                    scCore.Notification("There is only trash here")
                end
            end
        end
    else
        scCore.Notification("You are already doing something",'error') 
    end
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddTargetModel(Config.dumpsters, {
        options = {
            {
                event = "lcrp-dumpster:client:searchDumpster",
                icon = "fas fa-dumpster",
                label = "Search",
                duty = false,
            },
        },
      job = {"all"}, distance = 1.5})
end)

RegisterNetEvent('lcrp-dumpsterdiving:removeDumpster')
AddEventHandler('lcrp-dumpsterdiving:removeDumpster', function(object)
    for k,v in pairs(searched) do
        if v == object then
            table.remove(searched,k)
        end
    end
end)

-- Functions

function startSearching(time, dict, anim, dumpster)
    local animDict = dict
    local animation = anim
    local ped = PlayerPedId()

    canSearch = false

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end
    FreezeEntityPosition(ped, true)
    TaskPlayAnim(ped, animDict, animation, 8.0, 8.0, time, 1, 1, 0, 0, 0)

    scCore.TaskBar("dumpster_dive", "Searching dumpster", time, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        table.insert(searched, dumpster)
        TriggerServerEvent('lcrp-dumpsterdiving:giveDumpsterReward')
        FreezeEntityPosition(ped, false)
    end, function() -- Cancel
        FreezeEntityPosition(ped, false)
    end)

    Wait(time)
    ClearPedTasks(ped)
    canSearch = true
end