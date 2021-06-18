function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local currentGarage = 1


function setInteractVehicles(currHospital)
    ambulance = {{
        event = "hospital:client:storeVehicle",
        icon = "",
        label = "EMS Vehicles",
        duty = true,
        storeVeh = true
    }}

    for k,v in pairs(Config.Vehicles)do
        table.insert(ambulance, {
            event = "hospital:client:takeVehicle",
            icon = "fas fa-ambulance",
            label = v,
            duty = true,
            parameters = {model = k, hospital = currHospital}
        })
    end

    return ambulance
end

function setInteractHelicopter(currHospital)
    heli = {{
        event = "hospital:client:storeHeli",
        icon = "",
        label = "EMS Helicopters",
        duty = true,
        storeVeh = true
    }}

    for k,v in pairs(Config.Helicopter)do
        table.insert(heli, {
            event = "hospital:client:takeHeli",
            icon = "fas fa-helicopter",
            label = v,
            duty = true,
            parameters = {model = k, hospital = currHospital}
        })
    end

    return heli
end

function setInteractClothes()
    outfits = {
        {
            event = "",
            icon = "",
            label = "Outfits",
            duty = true,
        },
        {
            event = "hospital:client:selectedOutfit",
            icon = "far fa-tshirt",
            label = "Civilian",
            duty = true,
            parameters = "civilian"
        },
    }
    outfitList = Config.EMSOutfitsMale 
    if scCore.Functions.GetPlayerData().charinfo.gender == 1 then outfitList = Config.EMSOutfitsFemale end
    for k,v in pairs(outfitList) do
        table.insert(outfits, {
            event = "hospital:client:selectedOutfit",
            icon = "far fa-tshirt",
            label = v,
            duty = true,
            parameters = k
        })
    end

    return outfits
end

RegisterNetEvent('hospital:client:selectedOutfit')
AddEventHandler('hospital:client:selectedOutfit', function(selection)
    SelectOutfit(selection)
end)

RegisterNetEvent("hospital:client:takeVehicle")
AddEventHandler("hospital:client:takeVehicle", function(data)
    local coords = Config.Locations["vehicle"][data.hospital]
    scCore.Functions.SpawnVehicle(data.model, function(veh)
        SetVehicleNumberPlateText(veh, "AMBU"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
end)

RegisterNetEvent("hospital:client:storeVehicle")
AddEventHandler("hospital:client:storeVehicle", function(data)
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        scCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
    end
end)

RegisterNetEvent("hospital:client:takeHeli")
AddEventHandler("hospital:client:takeHeli", function(data)
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        scCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
    else
        local coords = Config.Locations["helicopter"][data.hospital]
        scCore.Functions.SpawnVehicle(data.model, function(veh)
            SetVehicleNumberPlateText(veh, "EMS"..tostring(math.random(1000, 9999)))
            SetEntityHeading(veh, coords.h)
            exports['LegacyFuel']:SetFuel(veh, 100.0)
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
            SetVehicleEngineOn(veh, true, true)
        end, coords, true)
    end
end)

RegisterNetEvent("hospital:client:storeHeli")
AddEventHandler("hospital:client:storeHeli", function()
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        scCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
    end
end)

RegisterNetEvent("hospital:client:getSurgery")
AddEventHandler("hospital:client:getSurgery", function(bed)
    local coords = Config.Locations["surgeryBeds"][bed]
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, 0, 0, 0, false)
    SetEntityHeading(PlayerPedId(), coords.h)
    TriggerEvent('animations:client:EmoteCommandStart', {"passout3"})
end)

RegisterNetEvent("hospital:client:takeElevator")
AddEventHandler("hospital:client:takeElevator", function(elevatorTo)
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end

    local coords = Config.Locations[elevatorTo][1]
    if elevatorTo == "mainsecond" then
        local interior = GetInteriorAtCoords(coords.x, coords.y, coords.z)
        LoadInterior(interior)
        while not IsInteriorReady(interior) do
            Citizen.Wait(1000)
        end
    end

    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, 0, 0, 0, false)
    SetEntityHeading(PlayerPedId(), coords.h)

    Citizen.Wait(100)

    DoScreenFadeIn(1000)
end)



RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()

    exports["lcrp-interact"]:AddBoxZone("ambulance1Duty", vector3(311.85, -598.14, 43.28), 1.2, 1.2, {
        name="ambulance1Duty",
        heading=340,
        --debugPoly=true,
        minZ=42.28,
        maxZ=44.68
        }, {
        options = {
            {
                event = "police:client:Duty",
                icon = "far fa-clipboard",
                label = "Clock in",
                duty = false,
                parameters = "duty",
            },
            {
                event = "police:client:Duty",
                icon = "far fa-clipboard",
                label = "Clock out",
                duty = true,
                parameters = "duty",
            },
        },
        job = {"ambulance"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("ambulance2Duty", vector3(1831.86, 3677.43, 34.27), 1, 1, {
        name="ambulance2Duty",
        heading=337,
        --debugPoly=true,
        minZ=32.47,
        maxZ=34.67
        }, {
        options = {
            {
                event = "police:client:Duty",
                icon = "far fa-clipboard",
                label = "Clock in",
                duty = false,
                parameters = "duty",
            },
            {
                event = "police:client:Duty",
                icon = "far fa-clipboard",
                label = "Clock out",
                duty = true,
                parameters = "duty",
            },
        },
        job = {"ambulance"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("ambulanceBoss", vector3(335.44, -594.44, 43.28), 1.4, 1, {
        name="ambulanceBoss",
        heading=340,
        --debugPoly=true,
        minZ=41.68,
        maxZ=43.88 }, {
        options = {
            {
                event = "police:server:OpenSocietyMenu",
                icon = "fas fa-user-secret",
                label = "Boss Actions",
                duty = true,
                parameters = 'ambulance'
            },
        },
    job = {"ambulance"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("ambulanceArmory", vector3(312.14, -593.5, 43.28), 1.0, 1.6, {
        name="ambulanceArmory",
        heading=339,
        --debugPoly=true,
        minZ=41.88,
        maxZ=43.88
        }, {
        options = {
            {
                event = "hospital:client:EMSShop",
                icon = "far fa-clipboard",
                label = "EMS Shop",
                duty = true,
            },
        },
        job = {"ambulance"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("ambulance2Armory", vector3(1825.24, 3668.41, 34.27), 0.8, 1.2, {
        name="ambulance2Armory",
        heading=30,
        --debugPoly=true,
        minZ=33.27,
        maxZ=34.87
        }, {
        options = {
            {
                event = "hospital:client:EMSShop",
                icon = "far fa-clipboard",
                label = "EMS Shop",
                duty = true,
            },
        },
        job = {"ambulance"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("ambulanceVehicle", vector3(330.16, -573.08, 28.8), 15.2, 12.6, {
        name="ambulanceVehicle",
        heading=340,
        --debugPoly=true,
        minZ=25.8,
        maxZ=32.2
        }, {
        options = setInteractVehicles(1),
        job = {"ambulance"}, distance = 5.0 })

    exports["lcrp-interact"]:AddBoxZone("ambulance2Vehicle", vector3(-234.35, 6329.31, 32.16), 5, 5, {
        name="ambulance2Vehicle",
        heading=45,
        --debugPoly=true,
        minZ=29.56,
        maxZ=34.36
        }, {
        options = setInteractVehicles(2),
        job = {"ambulance"}, distance = 5.0 })

    exports["lcrp-interact"]:AddBoxZone("ambulance3Vehicle", vector3(1842.75, 3708.26, 33.46), 5, 5, {
        name="ambulance3Vehicle",
        heading=0,
        --debugPoly=true,
        minZ=32.46,
        maxZ=35.06
        }, {
        options = setInteractVehicles(3),
        job = {"ambulance"}, distance = 5.0 })

    exports["lcrp-interact"]:AddBoxZone("ambulanceHeli", vector3(351.81, -588.04, 74.16), 10.8, 10.6, {
        name="ambulanceHeli",
        heading=345,
        --debugPoly=true,
        minZ=73.16,
        maxZ=77.16
        }, {
        options = setInteractHelicopter(1),
        job = {"ambulance"}, distance = 10.0 })

    exports["lcrp-interact"]:AddBoxZone("ambulance2Heli", vector3(-475.33, 5988.35, 31.34), 12.0, 12.0, {
        name="ambulance2Heli",
        heading=315,
        --debugPoly=true,
        minZ=29.34,
        maxZ=34.34
        }, {
        options = setInteractHelicopter(2),
        job = {"ambulance"}, distance = 10.0 })

    exports["lcrp-interact"]:AddBoxZone("ambulanceSurgeryBeds", vector3(326.76, -571.08, 43.28), 2.4, 1.0, {
        name="ambulanceSurgeryBeds",
        heading=339,
        --debugPoly=true,
        minZ=42.08,
        maxZ=43.68
        }, {
        options = {
            {
                event = "hospital:client:getSurgery",
                icon = "far fa-clipboard",
                label = "Lay on bed",
                duty = false,
                parameters = 1
            },
        },
        job = {"all"}, distance = 2.0 })
    exports["lcrp-interact"]:AddBoxZone("ambulance2SurgeryBeds", vector3(321.07, -568.39, 43.28), 1.2, 2.4, {
        name="ambulance2SurgeryBeds",
        heading=70,
        --debugPoly=true,
        minZ=42.28,
        maxZ=43.68
        }, {
        options = {
            {
                event = "hospital:client:getSurgery",
                icon = "far fa-clipboard",
                label = "Lay on bed",
                duty = false,
                parameters = 2
            },
        },
        job = {"all"}, distance = 2.0 }) 

    exports["lcrp-interact"]:AddBoxZone("ambulance3SurgeryBeds", vector3(315.36, -566.47, 43.28), 2.4, 1.1, {
        name="ambulance3SurgeryBeds",
        heading=340,
        --debugPoly=true,
        minZ=42.08,
        maxZ=43.68
        }, {
        options = {
            {
                event = "hospital:client:getSurgery",
                icon = "far fa-clipboard",
                label = "Lay on bed",
                duty = false,
                parameters = 3
            },
        },
        job = {"all"}, distance = 2.0 })
        
    exports["lcrp-interact"]:AddBoxZone("ambulanceOutfits", vector3(302.36, -599.68, 43.28), 3.0, 1, {
        name="ambulanceOutfits",
        heading=340,
        --debugPoly=true,
        minZ=42.28,
        maxZ=44.48 }, {
        options = setInteractClothes(),
    job = {"ambulance"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("ambulance2Outfits", vector3(1836.38, 3685.62, 34.27), 1.6, 1.0, {
        name="ambulance2Outfits",
        heading=299,
        --debugPoly=true,
        minZ=33.27,
        maxZ=34.67 }, {
        options = setInteractClothes(),
    job = {"ambulance"}, distance = 2.0})

    exports["lcrp-interact"]:AddBoxZone("ambulanceMain", vector3(332.59, -595.78, 43.28), 2.6, 0.8, {
        name="ambulanceMain",
        heading=339,
        --debugPoly=true,
        minZ=42.28,
        maxZ=44.68
        }, {
        options = {
            {
                event = "hospital:client:takeElevator",
                icon = "fas fa-arrow-up",
                label = "Take the elevator to the roof",
                duty = false,
                parameters = "roof"
            },
        },
        job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("ambulanceOutside", vector3(342.13, -585.51, 28.8), 4.2, 3.6, {
        name="ambulanceOutside",
        heading=340,
        --debugPoly=true,
        minZ=27.8,
        maxZ=30.8
        }, {
        options = {
            {
                event = "hospital:client:takeElevator",
                icon = "fas fa-arrow-up",
                label = "Take the elevator",
                duty = false,
                parameters = "mainsecond"
            },
        },
        job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("ambulanceRoof", vector3(338.18, -583.7, 74.16), 3.2, 0.8, {
        name="ambulanceRoof",
        heading=340,
        --debugPoly=true,
        minZ=72.96,
        maxZ=75.56
        }, {
        options = {
            {
                event = "hospital:client:takeElevator",
                icon = "fas fa-arrow-down",
                label = "Take the elevator",
                duty = false,
                parameters = "main"
            },
        },
        job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("ambulanceMainSecond", vector3(330.55, -601.22, 43.28), 2.6, 0.8, {
        name="ambulanceMainSecond",
        heading=340,
        --debugPoly=true,
        minZ=42.28,
        maxZ=44.68
        }, {
        options = {
            {
                event = "hospital:client:takeElevator",
                icon = "fas fa-arrow-down",
                label = "Take the elevator",
                duty = false,
                parameters = "outside"
            },
        },
        job = {"all"}, distance = 2.0 })

end)

RegisterNetEvent("hospital:client:EMSShop")
AddEventHandler("hospital:client:EMSShop", function()
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "hospital", Config.Items)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if isStatusChecking then
            for k, v in pairs(statusChecks) do
                local x,y,z = table.unpack(GetPedBoneCoords(statusCheckPed, v.bone))
                DrawText3D(x, y, z, v.label)
            end
        end

        if isHealingPerson then
            if not IsEntityPlayingAnim(GetPlayerPed(-1), healAnimDict, healAnim, 3) then
                loadAnimDict(healAnimDict)	
                TaskPlayAnim(GetPlayerPed(-1), healAnimDict, healAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
            end
        end
    end
end)

RegisterNetEvent('hospital:client:SendAlert')
AddEventHandler('hospital:client:SendAlert', function(msg)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    TriggerEvent("chatMessage", "PAGER", "error", msg)
end)

RegisterNetEvent('112:client:SendAlert')
AddEventHandler('112:client:SendAlert', function(msg, blipSettings)
    print("LOG: Attempting to send alert")
    if (PlayerJob.name == "police" or PlayerJob.name == "statepolice" or PlayerJob.name == "ambulance" or PlayerJob.name == "doctor") and onDuty then
        print("LOG: Job passed, sending alert")
        print(blipSettings)
        if blipSettings ~= nil then
            local transG = 300
            local blip = AddBlipForCoord(blipSettings.x, blipSettings.y, blipSettings.z)
            SetBlipSprite(blip, blipSettings.sprite)
            SetBlipColour(blip, 59)
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

RegisterNetEvent('hospital:client:AiCall')
AddEventHandler('hospital:client:AiCall', function()
    local player = GetPlayerPed(-1)
    local coords = GetEntityCoords(player)
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)

    local gender = scCore.Functions.GetPlayerData().gender
    MakeCall(gender, street1, street2)
end)

function MakeCall(male, street1, street2)
    local rand = (math.random(6,9) / 100) + 0.3
    local rand2 = (math.random(6,9) / 100) + 0.3
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local blipsettings = {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        sprite = 280,
        color = 4,
        scale = 0.9,
        text = "Wounded person"
    }

    if math.random(10) > 5 then
        rand = 0.0 - rand
    end

    if math.random(10) > 5 then
        rand2 = 0.0 - rand2
    end

    Citizen.Wait(3000)

    TriggerServerEvent("hospital:server:MakeDeadCall", blipsettings, male, street1, street2)
end

function isBoss()
    local retval = false
    local roles = scCore.Shared.Jobs["ambulance"].roles
    for k, v in pairs(roles) do
        highestGrade = k
    end
    scCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.job.name == "ambulance" and PlayerData.job.grade >= highestGrade - 1 then
            retval = true
        else
            retval = false
        end
    end)
    return retval
end

RegisterNetEvent('hospital:client:RevivePlayer')
AddEventHandler('hospital:client:RevivePlayer', function()
    scCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerJob.name == "doctor" or PlayerJob.name == "ambulance" then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                isHealingPerson = true
                scCore.TaskBar("hospital_revive", "Reviving person", 5000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = healAnimDict,
                    anim = healAnim,
                    flags = 16,
                }, {}, {}, function() -- Done
                    isHealingPerson = false
                    StopAnimTask(GetPlayerPed(-1), healAnimDict, "exit", 1.0)
                    scCore.Notification("Person successfully revived!")
                    TriggerServerEvent("hospital:server:RevivePlayer", playerId)
                end, function() -- Cancel
                    isHealingPerson = false
                    StopAnimTask(GetPlayerPed(-1), healAnimDict, "exit", 1.0)
                    scCore.Notification("Failed!", "error")
                end)
            end
        end
    end)
end)

RegisterNetEvent('hospital:client:CheckStatus')
AddEventHandler('hospital:client:CheckStatus', function()
    scCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerJob.name == "doctor" or PlayerJob.name == "ambulance" or PlayerJob.name == "police" or PlayerJob.name == "statepolice" then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                statusCheckPed = GetPlayerPed(player)
                scCore.TriggerServerCallback('hospital:GetPlayerStatus', function(result)
                    if result ~= nil then
                        for k, v in pairs(result) do
                            if k ~= "BLEED" and k ~= "WEAPONWOUNDS" then
                                table.insert(statusChecks, {bone = Config.BoneIndexes[k], label = v.label .." (".. Config.WoundStates[v.severity] ..")"})
                            elseif result["WEAPONWOUNDS"] ~= nil then 
                                for k, v in pairs(result["WEAPONWOUNDS"]) do
                                    TriggerEvent("chatMessage", "STATUS CHECK", "error", WeaponDamageList[v])
                                end
                            elseif result["BLEED"] > 0 then
                                TriggerEvent("chatMessage", "STATUS CHECK", "error", "Is "..Config.BleedingStates[v].label)
                            end
                        end
                        isStatusChecking = true
                        statusCheckTime = Config.CheckTime
                    end
                end, playerId)
            end
        end
    end)
end)

RegisterNetEvent('hospital:client:TreatWounds')
AddEventHandler('hospital:client:TreatWounds', function()
    scCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerJob.name == "doctor" or PlayerJob.name == "ambulance" then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                isHealingPerson = true
                scCore.TaskBar("hospital_healwounds", "Healing wounds", 5000, false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = healAnimDict,
                    anim = healAnim,
                    flags = 16,
                }, {}, {}, function() -- Done
                    isHealingPerson = false
                    StopAnimTask(GetPlayerPed(-1), healAnimDict, "exit", 1.0)
                    scCore.Notification("You healed persons wounds!")
                    TriggerServerEvent("hospital:server:TreatWounds", playerId)
                end, function() -- Cancel
                    isHealingPerson = false
                    StopAnimTask(GetPlayerPed(-1), healAnimDict, "exit", 1.0)
                    scCore.Notification("Fail!", "error")
                end)
            end
        end
    end)
end)

function MenuGarage(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("My Vehicles", "VehicleList", isDown)
    Menu.addButton("Close Menu", "closeMenuFull", nil) 
end

function VehicleList(isDown)
    ped = GetPlayerPed(-1);
    MenuTitle = "Vehicles:"
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(Config.Vehicles[k], "TakeOutVehicle", {k, isDown}, "Garage", " Engine: 100%", " Body: 100%", " Fuel: 100%")
    end
        
    Menu.addButton("Back", "MenuGarage",nil)
end

function TakeOutVehicle(vehicleInfo)
    local coords = Config.Locations["vehicle"][currentGarage]
    scCore.Functions.SpawnVehicle(vehicleInfo[1], function(veh)
        SetVehicleNumberPlateText(veh, "AMBU"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.h)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

-- OUTFIT STUFF

function PersonalOutfitsMenu()
    ped = GetPlayerPed(-1);
    MenuTitle = "Outfits"
    ClearMenu()
    Menu.addButton("Outfits", "PersonalOutfitList", nil)
    Menu.addButton("Save Outfit", "SaveOutfit", nil)
    Menu.addButton("Close Menu", "close", nil)
end

function SaveOutfit()
    closeMenuFull()
    local outfitSlot = scCore.KeyboardInput("Type outfit slot", "", 10)
    local outfitName = scCore.KeyboardInput("Type outfit name", "", 10)
    outfitSlot = tonumber(outfitSlot)

    if outfitSlot == nil or outfitName == nil then
        return scCore.Notification("Wrong Input!", "error")
    end

    TriggerEvent("lcrp-clothes:outfits", 1, outfitSlot, outfitName)

    PersonalOutfitsMenu()
end

function PersonalOutfitList()
    scCore.TriggerServerCallback("lcrp-clothes:outfitList", function(result)
    ped = GetPlayerPed(-1);
    MenuTitle = "Outfits:"
    ClearMenu()

    if result == nil then
        scCore.Notification("You have no outfits!", "error")
        closeMenuFull()
    else
        for k, v in pairs(result) do
            Menu.addButton("Slot: " .. result[k].slot .. " | Name: " ..result[k].name, "selectPersonalOutfit", result[k].slot)
        end

        Menu.addButton("Back", "PersonalOutfitsMenu")
        end
    end)
end

function selectPersonalOutfit(outfit)
    TriggerEvent('InteractSound_CL:PlayOnOne','Clothes1', 0.6)
    TriggerServerEvent("lcrp-clothes:get_outfit", outfit)
    closeMenuFull()
end

function close()
    Menu.hidden = true
end

function MenuEMSOutfits()
    ped = GetPlayerPed(-1);
    MenuTitle = "EMS Outfits"
    ClearMenu()
    Menu.addButton("Outfits", "OutfitList", nil)
    Menu.addButton("Close Menu", "close", nil)
end

function OutfitList()
    ped = GetPlayerPed(-1);
    MenuTitle = "EMS Outfits:"
    ClearMenu()

    Menu.addButton("[0] Civilian Clothes", "SelectOutfit", "civilian")
    if scCore.Functions.GetPlayerData().charinfo.gender == 1 then -- FEMALE
        Menu.addButton("[1] EMS 1", "SelectOutfit", "emsfemale")
        Menu.addButton("[2] EMS 2", "SelectOutfit", "emsfemale2")
        Menu.addButton("[3] Doctor", "SelectOutfit", "doctorfemale")
        Menu.addButton("[4] Nurse", "SelectOutfit", "nursefemale")
    else -- MALE
        Menu.addButton("[1] EMS 1", "SelectOutfit", "emsmale")
        Menu.addButton("[2] EMS 2", "SelectOutfit", "emsmale2")
        Menu.addButton("[3] Doctor 1", "SelectOutfit", "doctor")
        Menu.addButton("[4] Nurse", "SelectOutfit", "nurse")
    end

    Menu.addButton("Back", "MenuEMSOutfits")
end

function SelectOutfit(outfit)
    if outfit == "civilian" then
        TriggerServerEvent('lcrp-clothes:get_character_current')
        TriggerServerEvent("lcrp-clothes:retrieve_tats")
    end

    if outfit == "emsfemale" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 99, texture = 0},
                ["arms"]        = { item = 109, texture = 0}, 
                ["t-shirt"]     = { item = 159, texture = 0},  
                ["vest"]        = { item = 0, texture = 0},  
                ["torso2"]      = { item = 258, texture = 6},  
                ["shoes"]       = { item = 25, texture = 0},  
                ["hat"]         = { item = -1, texture = 0},
                ["mask"]        = { item = 6, texture = 2},
                ["accessory"]   = { item = 96, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "emsfemale2" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 99, texture = 1},
                ["arms"]        = { item = 109, texture = 0}, 
                ["t-shirt"]     = { item = 159, texture = 0},  
                ["vest"]        = { item = 0, texture = 0},  
                ["torso2"]      = { item = 259, texture = 6},  
                ["shoes"]       = { item = 25, texture = 0},  
                ["hat"]         = { item = -1, texture = 0},
                ["mask"]        = { item = 6, texture = 2},
                ["accessory"]   = { item = 96, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "doctorfemale" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 23, texture = 0},
                ["arms"]        = { item = 101, texture = 0}, 
                ["t-shirt"]     = { item = 64, texture = 1},  
                ["vest"]        = { item = 0, texture = 0},  
                ["torso2"]      = { item = 194, texture = 2},  
                ["shoes"]       = { item = 80, texture = 15},  
                ["hat"]         = { item = -1, texture = 0},
                ["mask"]        = { item = 6, texture = 2},
                ["accessory"]   = { item = 96, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "nursefemale" then
        ClothingDataName = {
            outfitData = {
                ["mask"]        = { item = 6, texture = 2},
                ["accessory"]   = { item = 96, texture = 0},
                ["torso2"]      = { item = 203, texture = 0},  
                ["pants"]       = { item = 111, texture = 1},
                ["arms"]        = { item = 109, texture = 0}, 
                ["t-shirt"]     = { item = -1, texture = 0},  
                ["vest"]        = { item = 0, texture = 0},  
                ["shoes"]       = { item = 60, texture = 6},  
                ["hat"]         = { item = -1, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "emsmale" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 96, texture = 0},
                ["arms"]        = { item = 85, texture = 0}, 
                ["t-shirt"]     = { item = 129, texture = 0},  
                ["vest"]        = { item = 0, texture = 0},  
                ["torso2"]      = { item = 250, texture = 0},  
                ["shoes"]       = { item = 25, texture = 0},  
                ["hat"]         = { item = -1, texture = 0},
                ["accessory"]   = { item = 126, texture = 0},
                ["mask"]        = { item = 6, texture = 2},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "emsmale2" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 96, texture = 1},
                ["arms"]        = { item = 86, texture = 0}, 
                ["t-shirt"]     = { item = 15, texture = 0},  
                ["vest"]        = { item = 0, texture = 0},  
                ["torso2"]      = { item = 249, texture = 0},  
                ["shoes"]       = { item = 25, texture = 0},  
                ["hat"]         = { item = -1, texture = 0},
                ["mask"]        = { item = 6, texture = 2},
                ["accessory"]   = { item = 126, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "doctor" then
        ClothingDataName = {
            outfitData = {
                ["mask"]        = { item = 6, texture = 2},
                ["accessory"]   = { item = 126, texture = 0},
                ["torso2"]      = { item = 192, texture = 2},  
                ["t-shirt"]     = { item = 63, texture = 3},  
                ["pants"]       = { item = 20, texture = 0},
                ["arms"]        = { item = 86, texture = 0}, 
                ["vest"]        = { item = 0, texture = 0},  
                ["shoes"]       = { item = 3, texture = 0},  
                ["hat"]         = { item = -1, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "nurse" then
        ClothingDataName = {
            outfitData = {
                ["mask"]        = { item = 6, texture = 2},
                ["accessory"]   = { item = 126, texture = 0},
                ["torso2"]      = { item = 16, texture = 0},  
                ["t-shirt"]     = { item = -1, texture = 0},  
                ["pants"]       = { item = 104, texture = 0},
                ["arms"]        = { item = 85, texture = 0}, 
                ["vest"]        = { item = 0, texture = 0},  
                ["shoes"]       = { item = 3, texture = 0},  
                ["hat"]         = { item = -1, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    TriggerEvent('InteractSound_CL:PlayOnOne','Clothes1', 0.6)
    closeMenuFull()
end

-- [[ Control Keybinds ]]

RegisterCommand("control_emsheal", function(source)
    TriggerEvent("hospital:client:TreatWounds")
end)

RegisterCommand("control_emsrevive", function(source)
    TriggerEvent("hospital:client:RevivePlayer")
end)

