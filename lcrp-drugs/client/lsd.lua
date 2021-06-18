local mixing = false
local stage = 1

RegisterNetEvent("lcrp-drugs:client:GetLSDLocations")
AddEventHandler("lcrp-drugs:client:GetLSDLocations", function(lsdData)
    LSDLoc = lsdData

    exports["lcrp-interact"]:AddBoxZone("makeLSD", vector3(LSDLoc.LabLocations.MakeLSD[1].x, LSDLoc.LabLocations.MakeLSD[1].y, LSDLoc.LabLocations.MakeLSD[1].z), 2.0, 2.0, {
        name="makeLSD",
        heading=0,
        minZ=44.48,
        maxZ=48.48
        }, {
        options = {
            {
                event = "lcrp-drugs:client:LSDInteractions",
                icon = "fal fa-vial",
                label = "Start making LSD",
                duty = false,
                parameters = 4,
            },
        },
    job = {"all"}, distance = 2.0 })
end)

RegisterNetEvent("lcrp-drugs:client:LSDMixingStatus")
AddEventHandler("lcrp-drugs:client:LSDMixingStatus", function(status)
    mixing = status
end)

RegisterNetEvent("lcrp-drugs:client:StartMixingLSD")
AddEventHandler("lcrp-drugs:client:StartMixingLSD", function()
    local ped = GetPlayerPed(-1)

    mixing = true

    if stage == 3 then
        TriggerServerEvent("lcrp-drugs:server:CheckAmount", "lsd", 1, "morning_glory_seeds", "hydrogen_peroxide", "pure_ammonia")
        stage = 1
        return
    end

    scCore.TaskBar("mix_lsd", Config.LSD.Messages[stage].taskBar, Config.LSD.Messages[stage].taskBarTime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = Config.LSD.Messages[stage].animDict,
        anim = Config.LSD.Messages[stage].anim,
        flags = 16,
    }, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        StopAnimTask(GetPlayerPed(-1), Config.LSD.Messages[stage].animDict, Config.LSD.Messages[stage].anim, 1.0)
        mixing = false
        stage = stage + 1
        TriggerEvent("lcrp-drugs:client:StartMixingLSD")
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), Config.LSD.Messages[stage].animDict, Config.LSD.Messages[stage].anim, 1.0)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        scCore.Notification("Mixing failed!", "error")
        mixing = false
    end)
end)

RegisterNetEvent("lcrp-drugs:client:LSDInteractions")
AddEventHandler("lcrp-drugs:client:LSDInteractions", function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(PlayerPedId())
    local distance = Vdist(coords, LSDLoc.LabLocations.MakeLSD[1].x, LSDLoc.LabLocations.MakeLSD[1].y, LSDLoc.LabLocations.MakeLSD[1].z)

    if not mixing then
        if distance < 5.0 then
            if not IsPedInAnyVehicle(PlayerPedId()) then
                local plyID = PlayerPedId()

                -- If Player is standing on same position don't replay native
                if not (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, LSDLoc.LabLocations.MakeLSD[1].x, LSDLoc.LabLocations.MakeLSD[1].y, LSDLoc.LabLocations.MakeLSD[1].z, true) < 0.1) then
                    TaskGoStraightToCoord(plyID, LSDLoc.LabLocations.MakeLSD[1].x, LSDLoc.LabLocations.MakeLSD[1].y, LSDLoc.LabLocations.MakeLSD[1].z, 1.0, -1, 0.0, 0.0) -- go to the coord
                    Citizen.Wait(700)
                    SetEntityCoords(plyID, LSDLoc.LabLocations.MakeLSD[1].x, LSDLoc.LabLocations.MakeLSD[1].y, LSDLoc.LabLocations.MakeLSD[1].z - 1.0)
                end

                SetEntityHeading(plyID, LSDLoc.LabLocations.MakeLSD[1].h)
                TriggerServerEvent("lcrp-drugs:server:CheckAmount", "ethyl_alcohol", 1, "morning_glory_seeds", "hydrogen_peroxide", "pure_ammonia")
            else
                scCore.Notification("Exit vehicle first!", "error")
            end
        else
            scCore.Notification("Too far away!", "error")
        end
    else
        scCore.Notification("You already doing an action!", "error")
    end
end)