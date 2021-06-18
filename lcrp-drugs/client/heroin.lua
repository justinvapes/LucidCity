local mixingHeroin = false
local stage = 1

RegisterNetEvent("lcrp-drugs:client:GetHeroinLocations")
AddEventHandler("lcrp-drugs:client:GetHeroinLocations", function(heroinData)
    heroinLoc = heroinData

    for k, makeHeroinCoords in pairs(heroinLoc.Locations.HeroinMixPlaces) do
        exports["lcrp-interact"]:AddBoxZone("makeHeroin"..k, vector3(makeHeroinCoords.x, makeHeroinCoords.y, makeHeroinCoords.z), 1.5, 1.5, {
            name="makeHeroin"..k,
            heading=338,
            minZ=0.45,
            maxZ=4.45
            }, {
            options = {
                {
                    event = "lcrp-drugs:client:HeroinInteractions",
                    icon = "fal fa-vial",
                    label = "Start Making Heroin",
                    duty = false,
                    parameters = 4,
                },
            },
        job = {"all"}, distance = 2.0 })
    end
end)

RegisterNetEvent("lcrp-drugs:client:HeroinMixingStatus")
AddEventHandler("lcrp-drugs:client:HeroinMixingStatus", function(status)
    mixingHeroin = status
end)

RegisterNetEvent("lcrp-drugs:client:StartMixingHeroin")
AddEventHandler("lcrp-drugs:client:StartMixingHeroin", function()
    local ped = GetPlayerPed(-1)

    mixingHeroin = true

    if stage == #Config.Heroin.Messages then
        TriggerServerEvent("lcrp-drugs:server:CheckAmount", "chloroform", 1, "acetic_anhydride", "sodium_carbonate", "hydrochloric_acid", "water_bottle")
        stage = 1
        return
    end

    scCore.TaskBar("mix_heroin", Config.Heroin.Messages[stage].taskBar, Config.Heroin.Messages[stage].taskBarTime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = Config.Heroin.Messages[stage].animDict,
        anim = Config.Heroin.Messages[stage].anim,
        flags = 16,
    }, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        StopAnimTask(GetPlayerPed(-1), Config.Heroin.Messages[stage].animDict, Config.Heroin.Messages[stage].anim, 1.0)
        mixingHeroin = false
        stage = stage + 1
        TriggerEvent("lcrp-drugs:client:StartMixingHeroin")
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), Config.Heroin.Messages[stage].animDict, Config.Heroin.Messages[stage].anim, 1.0)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        scCore.Notification("Mixing failed!", "error")
        mixingHeroin = false
    end)
end)

RegisterNetEvent("lcrp-drugs:client:HeroinInteractions")
AddEventHandler("lcrp-drugs:client:HeroinInteractions", function()
    local plyID = PlayerPedId()
    local coords = GetEntityCoords(plyID)

    if not mixingHeroin then
        for k, makeHeroinCoords in pairs(heroinLoc.Locations.HeroinMixPlaces) do
            local distance = Vdist(coords, makeHeroinCoords.x, makeHeroinCoords.y, makeHeroinCoords.z)
            if distance < 2.0 then
                if not IsPedInAnyVehicle(plyID) then

                    -- If Player is standing on same position don't replay native
                    if not (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, makeHeroinCoords.x, makeHeroinCoords.y, makeHeroinCoords.z, true) < 0.1) then
                        TaskGoStraightToCoord(plyID, makeHeroinCoords.x, makeHeroinCoords.y, makeHeroinCoords.z, 1.0, -1, 0.0, 0.0) -- go to the coord
                        Citizen.Wait(700)
                        SetEntityCoords(plyID, makeHeroinCoords.x, makeHeroinCoords.y, makeHeroinCoords.z - 1.0)
                    end

                    SetEntityHeading(plyID, makeHeroinCoords.h)
                    TriggerServerEvent("lcrp-drugs:server:CheckAmount", "acetic_anhydride", 1, "chloroform", "sodium_carbonate", "hydrochloric_acid", "water_bottle")
                else
                    scCore.Notification("Exit vehicle first!", "error")
                end
            end
        end
    else
        scCore.Notification("You already doing an action!", "error")
    end
end)