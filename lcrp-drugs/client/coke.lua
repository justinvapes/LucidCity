RegisterNetEvent("lcrp-drugs:client:GetCokeLocations")
AddEventHandler("lcrp-drugs:client:GetCokeLocations", function(cokeData)
    cokeLoc = cokeData

    exports["lcrp-interact"]:AddBoxZone("cokeWareHouseTp", vector3(cokeLoc.LabLocations.Enter[1].x, cokeLoc.LabLocations.Enter[1].y, cokeLoc.LabLocations.Enter[1].z), 2.0, 2.0, {
        name="cokeWareHouseTp",
        heading=320,
        minZ=209.92,
        maxZ=212.72
        }, {
        options = {
            {
                event = "lcrp-drugs:client:CokeInteractions",
                icon = "fad fa-door-open",
                label = "Enter Cocaine Warehouse",
                duty = false,
                parameters = 1,
            },
        },
    job = {"all"}, distance = 2.0 })
    exports["lcrp-interact"]:AddBoxZone("cokeWareHouseTp2", vector3(cokeLoc.LabLocations.Exit[1].x, cokeLoc.LabLocations.Exit[1].y, cokeLoc.LabLocations.Exit[1].z), 2.0, 2.0, {
        name="cokeWareHouseTp2",
        heading=0,
        minZ=-39.99,
        maxZ=-37.59
        }, {
        options = {
            {
                event = "lcrp-drugs:client:CokeInteractions",
                icon = "far fa-portal-exit",
                label = "Exit",
                duty = false,
                parameters = 2,
            },
        },
    job = {"all"}, distance = 2.0 })
    exports["lcrp-interact"]:AddBoxZone("cokeDryLeaves", vector3(cokeLoc.LabLocations.DryLeaves[1].x, cokeLoc.LabLocations.DryLeaves[1].y, cokeLoc.LabLocations.DryLeaves[1].z), 2.0, 2.0, {
        name="cokeDryLeaves",
        heading=0,
        minZ=-39.99,
        maxZ=-37.59
        }, {
        options = {
            {
                event = "lcrp-drugs:client:CokeInteractions",
                icon = "far fa-sun-dust",
                label = "Dry x4 Coca Leafs",
                duty = false,
                parameters = 3,
            },
        },
    job = {"all"}, distance = 2.0 })
    exports["lcrp-interact"]:AddBoxZone("makeCocaPaste", vector3(cokeLoc.LabLocations.CocaPaste[1].x, cokeLoc.LabLocations.CocaPaste[1].y, cokeLoc.LabLocations.CocaPaste[1].z), 2.0, 2.0, {
        name="makeCocaPaste",
        heading=0,
        minZ=-39.99,
        maxZ=-37.59
        }, {
        options = {
            {
                event = "lcrp-drugs:client:CokeInteractions",
                icon = "fal fa-vial",
                label = "Make Coca Paste",
                duty = false,
                parameters = 4,
            },
        },
    job = {"all"}, distance = 2.0 })
    exports["lcrp-interact"]:AddBoxZone("makeCrackCocaine", vector3(cokeLoc.LabLocations.CrackCocaine[1].x, cokeLoc.LabLocations.CocaPaste[1].y, cokeLoc.LabLocations.CocaPaste[1].z), 2.0, 2.0, {
        name="makeCrackCocaine",
        heading=0,
        minZ=-39.99,
        maxZ=-37.59
        }, {
        options = {
            {
                event = "lcrp-drugs:client:CokeInteractions",
                icon = "fal fa-vials",
                label = "Make Crack Cocaine",
                duty = false,
                parameters = 5,
            },
        },
    job = {"all"}, distance = 2.0 })
end)

RegisterNetEvent("lcrp-drugs:client:CokeInteractions")
AddEventHandler("lcrp-drugs:client:CokeInteractions", function(Loc)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(PlayerPedId())
    local inMarker = false

    for k,v in pairs(cokeLoc) do
        if not inMarker then    
            if Loc == 1 then
                distance = Vdist(coords, v.Enter[1].x, v.Enter[1].y, v.Enter[1].z)
                if (distance < 5.0) then
                    scCore.TriggerServerCallback('scCore:HasItem', function(labKey)
                        if labKey then
                            if not IsPedInAnyVehicle(PlayerPedId()) then
                                DoScreenFadeOut(500)
                                while not IsScreenFadedOut() do
                                    Citizen.Wait(10)
                                end
                                SetEntityCoords(PlayerPedId(), v.Exit[1].x, v.Exit[1].y, v.Exit[1].z)
                                DoScreenFadeIn(1000)
                                inMarker = false
                            else
                                scCore.Notification("Exit vehicle first", "error")
                            end
                        else
                            scCore.Notification("You don\'t have warehouse key", "error")
                        end
                    end, "warehousekey")
                else
                    scCore.Notification("Too far away!", "error")
                end
            elseif Loc == 2 then
                distance = Vdist(coords, v.Exit[1].x, v.Exit[1].y, v.Exit[1].z)
                if (distance < 5.0) then
                    if not IsPedInAnyVehicle(PlayerPedId()) then
                        DoScreenFadeOut(500)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(10)
                        end
                        SetEntityCoords(PlayerPedId(), v.Enter[1].x, v.Enter[1].y, v.Enter[1].z)
                        DoScreenFadeIn(1000)
                        inMarker = false
                    else
                        scCore.Notification("Exit vehicle first", "error")
                    end
                else
                    scCore.Notification("Too far away!", "error")
                end
            elseif Loc == 3 then
                distance = Vdist(coords, v.DryLeaves[1].x, v.DryLeaves[1].y, v.DryLeaves[1].z)
                if (distance < 5.0) then
                    scCore.TriggerServerCallback('scCore:HasItem', function(hasCocaLeaf)
                        if hasCocaLeaf then
                            if not IsPedInAnyVehicle(playerPed) then
                                inMarker = true
        
                                RequestAnimDict(Config.CocaLeafDict)
                                while not HasAnimDictLoaded(Config.CocaLeafDict) do
                                    Citizen.Wait(0)
                                end
                                TaskPlayAnim(PlayerPedId(), Config.CocaLeafDict, Config.CocaLeafAnim, 8.0, 8.0, -1, 48, 1, false, false, false)
        
                                scCore.TaskBar("dry_coca_leaf", "Drying Coca Leafs", Config.CocaLeafTime, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = false,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {}, {}, {}, function() -- Done
                                    TriggerServerEvent("lcrp-drugs:server:ProcessItem", "coca_leaf", 4, "dry_coca_leaf", 4)
                                end, function() -- Cancel
                                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                    ClearPedTasksImmediately(playerPed)
                                    scCore.Notification("Canceled", "error")
                                end)
                            else
                                scCore.Notification("Exit vehicle first", "error")
                            end
                        else
                            scCore.Notification("You don\'t have coca leaf", "error")
                        end
                    end, "coca_leaf")
                else
                    scCore.Notification("Too far away!", "error")
                end  
            elseif Loc == 4 then
                distance = Vdist(coords, v.CocaPaste[1].x, v.CocaPaste[1].y, v.CocaPaste[1].z)
                if (distance < 5.0) then
                    local CocaPasteAmount = scCore.KeyboardInput("How much coca paste you want to make?", "", 2)
                    CocaPasteAmount = tonumber(CocaPasteAmount)
                    scCore.TriggerServerCallback('scCore:HasItem', function(DryCocaLeaf)
                        if DryCocaLeaf and CocaPasteAmount >= 1 then
                            if not IsPedInAnyVehicle(playerPed) then
                                inMarker = true
                                TriggerServerEvent("lcrp-drugs:server:CheckAmount", "dry_coca_leaf", CocaPasteAmount, "lime")
                            else
                                scCore.Notification("Exit vehicle first", "error")
                            end
                        else
                            scCore.Notification("You don\'t have any dried coca leaf", "error")
                        end
                    end, "dry_coca_leaf")
                else
                    scCore.Notification("Too far away!", "error")
                end
            elseif Loc == 5 then
                distance = Vdist(coords, v.CrackCocaine[1].x, v.CrackCocaine[1].y, v.CrackCocaine[1].z)
                if (distance < 5.0) then
                    local CrackCocaineAmount = scCore.KeyboardInput("How much coca paste you want to use?", "", 2)
                    CrackCocaineAmount = tonumber(CrackCocaineAmount)
                    scCore.TriggerServerCallback('scCore:HasItem', function(CrackCocaine)
                        if CrackCocaine and CrackCocaineAmount >= 1 then
                            if not IsPedInAnyVehicle(playerPed) then
                                inMarker = true
                                TriggerServerEvent("lcrp-drugs:server:CheckAmount", "coca_paste", CrackCocaineAmount, "sulfuricacid", "permanganate", "empty_weed_bag")
                            else
                                scCore.Notification("Exit vehicle first", "error")
                            end
                        else
                            scCore.Notification("You don\'t have any coca paste", "error")
                        end
                    end, "coca_paste")
                else
                    scCore.Notification("Too far away!", "error")
                end    
            end   
        else
            scCore.Notification("You already doing an action!", "error")
        end
    end
end)