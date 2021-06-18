RegisterNetEvent("lcrp-drugs:client:GetMethLocations")
AddEventHandler("lcrp-drugs:client:GetMethLocations", function(methData)
    methLoc = methData

    exports["lcrp-interact"]:AddBoxZone("methWareHouseTp", vector3(methLoc.LabLocations.Enter[1].x, methLoc.LabLocations.Enter[1].y, methLoc.LabLocations.Enter[1].z), 2.0, 2.0, {
        name="methWareHouseTp",
        heading=320,
        minZ=274.01,
        maxZ=276.61
        }, {
        options = {
            {
                event = "lcrp-drugs:client:MethInteractions",
                icon = "fad fa-door-open",
                label = "Enter Meth Warehouse",
                duty = false,
                parameters = 1,
            },
        },
    job = {"all"}, distance = 2.0 })
    exports["lcrp-interact"]:AddBoxZone("methWareHouseTp2", vector3(methLoc.LabLocations.Exit[1].x, methLoc.LabLocations.Exit[1].y, methLoc.LabLocations.Exit[1].z), 2.0, 2.0, {
        name="methWareHouseTp2",
        heading=0,
        minZ=32.41,
        maxZ=35.21
        }, {
        options = {
            {
                event = "lcrp-drugs:client:MethInteractions",
                icon = "far fa-portal-exit",
                label = "Exit",
                duty = false,
                parameters = 2,
            },
        },
    job = {"all"}, distance = 2.0 })
    exports["lcrp-interact"]:AddBoxZone("mixMethLiquid", vector3(methLoc.LabLocations.MethLiquid[1].x, methLoc.LabLocations.MethLiquid[1].y, methLoc.LabLocations.MethLiquid[1].z), 2.0, 2.0, {
        name="mixMethLiquid",
        heading=0,
        minZ=32.41,
        maxZ=35.21
        }, {
        options = {
            {
                event = "lcrp-drugs:client:MethInteractions",
                icon = "far fa-sun-dust",
                label = "Start mixing liquid",
                duty = false,
                parameters = 3,
            },
        },
    job = {"all"}, distance = 2.0 })
    exports["lcrp-interact"]:AddBoxZone("makeMeth", vector3(methLoc.LabLocations.MethCook[1].x, methLoc.LabLocations.MethCook[1].y, methLoc.LabLocations.MethCook[1].z), 2.0, 2.0, {
        name="makeMeth",
        heading=0,
        minZ=32.41,
        maxZ=35.21
        }, {
        options = {
            {
                event = "lcrp-drugs:client:MethInteractions",
                icon = "fal fa-vial",
                label = "Make Meth",
                duty = false,
                parameters = 4,
            },
        },
    job = {"all"}, distance = 2.0 })
    exports["lcrp-interact"]:AddBoxZone("packMethBags", vector3(methLoc.LabLocations.MethBag[1].x, methLoc.LabLocations.MethBag[1].y, methLoc.LabLocations.MethBag[1].z), 2.0, 2.0, {
        name="packMethBags",
        heading=0,
        minZ=32.41,
        maxZ=35.21
        }, {
        options = {
            {
                event = "lcrp-drugs:client:MethInteractions",
                icon = "fal fa-vials",
                label = "Pack Meth Into Bags",
                duty = false,
                parameters = 5,
            },
        },
    job = {"all"}, distance = 2.0 })
end)

RegisterNetEvent("lcrp-drugs:client:MethInteractions")
AddEventHandler("lcrp-drugs:client:MethInteractions", function(Loc)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(PlayerPedId())
    local inMarker = false

    if not inMarker then    
        if Loc == 1 then
            distance = Vdist(coords, methLoc.LabLocations.Enter[1].x, methLoc.LabLocations.Enter[1].y, methLoc.LabLocations.Enter[1].z)
            if (distance < 5.0) then
                if not IsPedInAnyVehicle(PlayerPedId()) then
                    DoScreenFadeOut(500)
                    while not IsScreenFadedOut() do
                        Citizen.Wait(10)
                    end
                    SetEntityCoords(PlayerPedId(), methLoc.LabLocations.Exit[1].x, methLoc.LabLocations.Exit[1].y, methLoc.LabLocations.Exit[1].z)
                    DoScreenFadeIn(1000)
                else
                    scCore.Notification("Exit vehicle first", "error")
                end
            end
        elseif Loc == 2 then
            distance = Vdist(coords, methLoc.LabLocations.Exit[1].x, methLoc.LabLocations.Exit[1].y, methLoc.LabLocations.Exit[1].z)
            if (distance < 5.0) then
                if not IsPedInAnyVehicle(PlayerPedId()) then
                    DoScreenFadeOut(500)
                    while not IsScreenFadedOut() do
                        Citizen.Wait(10)
                    end
                    SetEntityCoords(PlayerPedId(), methLoc.LabLocations.Enter[1].x, methLoc.LabLocations.Enter[1].y, methLoc.LabLocations.Enter[1].z)
                    DoScreenFadeIn(1000)
                else
                    scCore.Notification("Exit vehicle first", "error")
                end
            end
        elseif Loc == 3 then
            distance = Vdist(coords, methLoc.LabLocations.MethLiquid[1].x, methLoc.LabLocations.MethLiquid[1].y, methLoc.LabLocations.MethLiquid[1].z)
            if (distance < 5.0) then
                scCore.TriggerServerCallback('scCore:HasItem', function(chemicals)
                    if chemicals then
                        if not IsPedInAnyVehicle(PlayerPedId()) then

                            TriggerServerEvent("lcrp-drugs:server:CheckAmount", "hydriodicacid", 1, "pseudoephedrine", "redphosphorus", "hydriodicacid")

                            inMarker = false
                        else
                            scCore.Notification("Exit vehicle first", "error")
                        end
                    else
                        scCore.Notification("Some of the chemicals are missing!", "error")
                    end
                end, "hydriodicacid")
            end
        elseif Loc == 4 then
            distance = Vdist(coords, methLoc.LabLocations.MethCook[1].x, methLoc.LabLocations.MethCook[1].y, methLoc.LabLocations.MethCook[1].z)
            if (distance < 5.0) then
                scCore.TriggerServerCallback('scCore:HasItem', function(hasMethLiquid)
                    if hasMethLiquid then
                        if not IsPedInAnyVehicle(PlayerPedId()) then

                            TriggerServerEvent("lcrp-drugs:server:CheckAmount", "meth_liquid", 5, "meth_liquid", "iodine_crystals")

                            inMarker = false
                        else
                            scCore.Notification("Exit vehicle first", "error")
                        end
                    else
                        scCore.Notification("Something is missing!", "error")
                    end
                end, "iodine_crystals")
            end
        elseif Loc == 5 then
            distance = Vdist(coords, methLoc.LabLocations.MethBag[1].x, methLoc.LabLocations.MethBag[1].y, methLoc.LabLocations.MethBag[1].z)
            if (distance < 5.0) then
                scCore.TriggerServerCallback('scCore:HasItem', function(hasMeth)
                    if hasMeth then
                        if not IsPedInAnyVehicle(PlayerPedId()) then

                            TriggerServerEvent("lcrp-drugs:server:CheckAmount", "meth", 5, "empty_weed_bag")

                            inMarker = false
                        else
                            scCore.Notification("Exit vehicle first", "error")
                        end
                    else
                        scCore.Notification("You don\'t have meth or bags!", "error")
                    end
                end, "meth")
            end
        end   
    else
        scCore.Notification("You already doing an action!", "error")
    end
end)