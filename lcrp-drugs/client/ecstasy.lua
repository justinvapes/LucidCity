local mixing = false
local stage = 1

RegisterNetEvent("lcrp-drugs:client:GetEcstasyLocations")
AddEventHandler("lcrp-drugs:client:GetEcstasyLocations", function(xtcData)
    xtcLoc = xtcData

    exports["lcrp-interact"]:AddBoxZone("ecstasyTp", vector3(xtcLoc.Locations.Enter[1].x, xtcLoc.Locations.Enter[1].y, xtcLoc.Locations.Enter[1].z), 2.0, 2.0, {
        name="ecstasyTp",
        heading=325,
        minZ=89.73,
        maxZ=92.13
        }, {
        options = {
            {
                event = "lcrp-drugs:client:EcstasyInteractions",
                icon = "fad fa-door-open",
                label = "Enter Ecstasy Warehouse",
                duty = false,
                parameters = 1,
            },
        },
    job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("ecstasyTp2", vector3(xtcLoc.Locations.Exit[1].x, xtcLoc.Locations.Exit[1].y, xtcLoc.Locations.Exit[1].z), 1.5, 1.5, {
        name="ecstasyTp2",
        heading=0,
        minZ=-37.39,
        maxZ=-34.79
        }, {
        options = {
            {
                event = "lcrp-drugs:client:EcstasyInteractions",
                icon = "far fa-portal-exit",
                label = "Exit",
                duty = false,
                parameters = 2,
            },
        },
    job = {"all"}, distance = 2.0 })

    for k, MakeEcstasyCoords in pairs(xtcLoc.Locations.EcstasyMixPlaces) do
        exports["lcrp-interact"]:AddBoxZone("makeEcstasy"..k, vector3(MakeEcstasyCoords.x, MakeEcstasyCoords.y, MakeEcstasyCoords.z), 2.0, 2.0, {
            name="makeEcstasy"..k,
            heading=0,
            minZ=-39.24,
            maxZ=-36.64
            }, {
            options = {
                {
                    event = "lcrp-drugs:client:EcstasyInteractions",
                    icon = "fad fa-tablets",
                    label = "Start making ecstasy",
                    duty = false,
                    parameters = 3,
                },
            },
        job = {"all"}, distance = 2.0 })
    end

    for k, PackEcstasyCoords in pairs(xtcLoc.Locations.EcstasyPackPlaces) do
        exports["lcrp-interact"]:AddBoxZone("packEcstasy"..k, vector3(PackEcstasyCoords.x, PackEcstasyCoords.y, PackEcstasyCoords.z), 2.0, 2.0, {
            name="packEcstasy"..k,
            heading=0,
            minZ=-39.24,
            maxZ=-36.64
            }, {
            options = {
                {
                    event = "lcrp-drugs:client:EcstasyInteractions",
                    icon = "fas fa-sack",
                    label = "Start packing ecstasy pills",
                    duty = false,
                    parameters = 4,
                },
            },
        job = {"all"}, distance = 2.0 })
    end
end)

RegisterNetEvent("lcrp-drugs:client:EcstasyMixingStatus")
AddEventHandler("lcrp-drugs:client:EcstasyMixingStatus", function(status)
    mixing = status
end)

RegisterNetEvent("lcrp-drugs:client:StartMixingEcstasy")
AddEventHandler("lcrp-drugs:client:StartMixingEcstasy", function()
    local ped = GetPlayerPed(-1)

    mixing = true

    if stage == #Config.Ecstasy.Messages then
        TriggerServerEvent("lcrp-drugs:server:CheckAmount", "dihydrogen_monoxide", 1, "sassafras_oil", "riboflavin", "water_bottle")
        stage = 1
        return
    end

    scCore.TaskBar("mix_ecstasy", Config.Ecstasy.Messages[stage].taskBar, Config.Ecstasy.Messages[stage].taskBarTime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = Config.Ecstasy.Messages[stage].animDict,
        anim = Config.Ecstasy.Messages[stage].anim,
        flags = 16,
    }, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        StopAnimTask(GetPlayerPed(-1), Config.Ecstasy.Messages[stage].animDict, Config.Ecstasy.Messages[stage].anim, 1.0)
        mixing = false
        stage = stage + 1
        TriggerEvent("lcrp-drugs:client:StartMixingEcstasy")
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), Config.Ecstasy.Messages[stage].animDict, Config.Ecstasy.Messages[stage].anim, 1.0)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        scCore.Notification("Mixing failed!", "error")
        mixing = false
    end)
end)

RegisterNetEvent("lcrp-drugs:client:EcstasyInteractions")
AddEventHandler("lcrp-drugs:client:EcstasyInteractions", function(Loc)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(PlayerPedId())
    local inMarker = false

    if not mixing then
        if Loc == 1 then
            distance = Vdist(coords, xtcLoc.Locations.Enter[1].x, xtcLoc.Locations.Enter[1].y, xtcLoc.Locations.Enter[1].z)
            if (distance < 5.0) then
                if not IsPedInAnyVehicle(PlayerPedId()) then
                    DoScreenFadeOut(500)
                    while not IsScreenFadedOut() do
                        Citizen.Wait(10)
                    end
                    SetEntityCoords(PlayerPedId(), xtcLoc.Locations.Exit[1].x, xtcLoc.Locations.Exit[1].y, xtcLoc.Locations.Exit[1].z)
                    DoScreenFadeIn(1000)
                else
                    scCore.Notification("Exit vehicle first", "error")
                end
            else
                scCore.Notification("Too far away!", "error")
            end
        elseif Loc == 2 then
            distance = Vdist(coords, xtcLoc.Locations.Exit[1].x, xtcLoc.Locations.Exit[1].y, xtcLoc.Locations.Exit[1].z)
            if (distance < 5.0) then
                if not IsPedInAnyVehicle(PlayerPedId()) then
                    DoScreenFadeOut(500)
                    while not IsScreenFadedOut() do
                        Citizen.Wait(10)
                    end
                    SetEntityCoords(PlayerPedId(), xtcLoc.Locations.Enter[1].x, xtcLoc.Locations.Enter[1].y, xtcLoc.Locations.Enter[1].z)
                    DoScreenFadeIn(1000)
                else
                    scCore.Notification("Exit vehicle first", "error")
                end
            else
                scCore.Notification("Too far away!", "error")
            end
        elseif Loc == 3 then
            for k, MakeEcstasyCoords in pairs(xtcLoc.Locations.EcstasyMixPlaces) do
                local distance = Vdist(coords, MakeEcstasyCoords.x, MakeEcstasyCoords.y, MakeEcstasyCoords.z)
                if distance < 5.0 then
                    if not IsPedInAnyVehicle(PlayerPedId()) then
                        local plyID = PlayerPedId()

                        -- If Player is standing on same position don't replay native
                        if not (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, MakeEcstasyCoords.x, MakeEcstasyCoords.y, MakeEcstasyCoords.z, true) < 0.1) then
                            TaskGoStraightToCoord(plyID, MakeEcstasyCoords.x, MakeEcstasyCoords.y, MakeEcstasyCoords.z, 1.0, -1, 0.0, 0.0) -- go to the coord
                            Citizen.Wait(700)
                            SetEntityCoords(PlayerPedId(), MakeEcstasyCoords.x, MakeEcstasyCoords.y, MakeEcstasyCoords.z - 1.0)
                        end

                        SetEntityHeading(PlayerPedId(), MakeEcstasyCoords.h)
                        TriggerServerEvent("lcrp-drugs:server:CheckAmount", "sassafras_oil", 1, "dihydrogen_monoxide", "riboflavin", "water_bottle")
                    else
                        scCore.Notification("Exit vehicle first!", "error")
                    end
                end
            end
        elseif Loc == 4 then
            for k, PackEcstasyCoords in pairs(xtcLoc.Locations.EcstasyPackPlaces) do
                local distance = Vdist(coords, PackEcstasyCoords.x, PackEcstasyCoords.y, PackEcstasyCoords.z)

                if distance < 5.0 then
                    if not IsPedInAnyVehicle(PlayerPedId()) then
                        local plyID = PlayerPedId()

                        -- If Player is standing on same position don't replay native
                        if not (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, PackEcstasyCoords.x, PackEcstasyCoords.y, PackEcstasyCoords.z, true) < 0.1) then
                            TaskGoStraightToCoord(plyID, PackEcstasyCoords.x, PackEcstasyCoords.y, PackEcstasyCoords.z, 1.0, -1, 0.0, 0.0) -- go to the coord
                            Citizen.Wait(700)
                            SetEntityCoords(PlayerPedId(), PackEcstasyCoords.x, PackEcstasyCoords.y, PackEcstasyCoords.z - 1.0)
                        end

                        SetEntityHeading(PlayerPedId(), PackEcstasyCoords.h)
                        TriggerServerEvent("lcrp-drugs:server:CheckAmount", "ecstasy", 1, "empty_weed_bag")
                    else
                        scCore.Notification("Exit vehicle first!", "error")
                    end
                end
            end
        end
    else
        scCore.Notification("You already doing an action!", "error")
    end
end)