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
Citizen.CreateThread(function()
    while true do
        sleep = 500
        if isLoggedIn then
            local pos = GetEntityCoords(GetPlayerPed(-1))

            for k, v in pairs(Config.Locations["evidenceLabs"]) do
                if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 4.5) then
                    if onDuty then
                        sleep = 5
                        if (GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 2.0) then
                            DrawText3D(v.x, v.y, v.z, "~b~Research DNA")
                        end  
                    end
                end
            end
            
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent('police:client:SendEmergencyMessage')
AddEventHandler('police:client:SendEmergencyMessage', function(message)
    local coords = GetEntityCoords(GetPlayerPed(-1))
    
    TriggerServerEvent("police:server:SendEmergencyMessage", coords, message)
    TriggerEvent("police:client:CallAnim")
end)

RegisterNetEvent('police:client:EmergencySound')
AddEventHandler('police:client:EmergencySound', function()
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
end)

RegisterNetEvent('police:client:CallAnim')
AddEventHandler('police:client:CallAnim', function()
    local isCalling = true
    local callCount = 5
    loadAnimDict("cellphone@")   
    TaskPlayAnim(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 3.0, -1, -1, 49, 0, false, false, false)
    Citizen.Wait(1000)
    Citizen.CreateThread(function()
        while isCalling do
            Citizen.Wait(1000)
            callCount = callCount - 1
            if callCount <= 0 then
                isCalling = false
                StopAnimTask(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 1.0)
            end
        end
    end)
end)

RegisterNetEvent('police:client:ImpoundVehicle')
AddEventHandler('police:client:ImpoundVehicle', function(fullImpound, price)
    local vehicle = scCore.Functions.GetClosestVehicle()
    if vehicle ~= 0 and vehicle ~= nil then
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local vehpos = GetEntityCoords(vehicle)
        if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 5.0) and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
            local plate = GetVehicleNumberPlateText(vehicle)
            TriggerServerEvent("police:server:Impound", plate, fullImpound, price)
            scCore.Notification("Vehicle impounded with plates: ".. plate)
            scCore.Functions.DeleteVehicle(vehicle)
        end
    end
end)

RegisterNetEvent('police:client:CheckStatus')
AddEventHandler('police:client:CheckStatus', function()
    scCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.job.name == "police" then
            local player, distance = GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                scCore.TriggerServerCallback('police:GetPlayerStatus', function(result)
                    if result ~= nil then
                        for k, v in pairs(result) do
                            TriggerEvent("chatMessage", "STATUS", "warning", v)
                        end
                    end
                end, playerId)
            end
        end
    end)
end)

function MenuOutfits()
    ped = GetPlayerPed(-1);
    MenuTitle = "Outfits"
    ClearMenu()
    Menu.addButton("My Outfits", "OutfitsList", nil)
    Menu.addButton("Close Menu", "closeMenuFull", nil) 
end

function changeOutfit()
	Wait(200)
    loadAnimDict("clothingshirt")    	
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
	Wait(3100)
	TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

function optionMenu(outfitData)
    ped = GetPlayerPed(-1);
    MenuTitle = "Outfits"
    ClearMenu()

    Menu.addButton("Select Outfit", "selectOutfit", outfitData) 
    Menu.addButton("Remove Outfit", "removeOutfit", outfitData) 
    Menu.addButton("Back", "OutfitsList",nil)
end

function selectOutfit(oData)
    TriggerServerEvent('clothes:selectOutfit', oData.model, oData.skin)
    scCore.Notification(oData.outfitname.." selected", "success", 2500)
    closeMenuFull()
    changeOutfit()
end

function removeOutfit(oData)
    TriggerServerEvent('clothes:removeOutfit', oData.outfitname)
    scCore.Notification(oData.outfitname.." is deleted", "success", 2500)
    closeMenuFull()
end

function MenuGarage()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Vehicles", "VehicleList", nil)
    Menu.addButton("Close Menu", "closeMenuFull", nil) 
end

function VehicleList(isDown)
    ped = GetPlayerPed(-1);
    ClearMenu()

    if PlayerJob.name == "fib" then
        vehiclesCFG = Config.FIBVehicles.categories
    elseif PlayerJob.name == "statepolice" then
        vehiclesCFG = Config.StatePDVehicles.categories
    else
        vehiclesCFG = Config.Vehicles.categories
    end

    for k, v in pairs(vehiclesCFG) do
        selectedCategoryData = {}
        selectedCategoryData.category = k
        selectedCategoryData.type = vehiclesCFG
        Menu.addButton(vehiclesCFG[k].label, "SelectCategory", selectedCategoryData)
    end
        
    Menu.addButton("Back", "MenuGarage", nil)
end

function SelectCategory(data)
    ped = GetPlayerPed(-1);
    ClearMenu()

    for k, v in pairs(data.type[data.category].vehicles) do
        Menu.addButton(v, "TakeOutVehicle", k)
    end

    Menu.addButton("Back", "VehicleList", nil)
end

function TakeOutVehicle(vehicleInfo)
    local playerPed = GetPlayerPed(-1)
    local playerHeading = GetEntityHeading(playerPed)
    local playerCoords = GetEntityCoords(playerPed)
    local coords = {x = playerCoords.x , y = playerCoords.y, z = playerCoords.z, a = 0.0}

    scCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "PLZI"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, playerHeading)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        TriggerServerEvent("inventory:server:addTrunkItems", GetVehicleNumberPlateText(veh), Config.CarItems)
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
end

function closeMenuFull()
    Menu.hidden = true
    renderGUI = false
    currentGarage = nil
    ClearMenu()
end

function doCarDamage(currentVehicle, veh)
	smash = false
	damageOutside = false
	damageOutside2 = false 
	local engine = veh.engine + 0.0
	local body = veh.body + 0.0
	if engine < 200.0 then
		engine = 200.0
    end
    
    if engine  > 1000.0 then
        engine = 950.0
    end

	if body < 150.0 then
		body = 150.0
	end
	if body < 950.0 then
		smash = true
	end

	if body < 920.0 then
		damageOutside = true
	end

	if body < 920.0 then
		damageOutside2 = true
	end

    Citizen.Wait(100)
    SetVehicleEngineHealth(currentVehicle, engine)
	if smash then
		SmashVehicleWindow(currentVehicle, 0)
		SmashVehicleWindow(currentVehicle, 1)
		SmashVehicleWindow(currentVehicle, 2)
		SmashVehicleWindow(currentVehicle, 3)
		SmashVehicleWindow(currentVehicle, 4)
	end
	if damageOutside then
		SetVehicleDoorBroken(currentVehicle, 1, true)
		SetVehicleDoorBroken(currentVehicle, 6, true)
		SetVehicleDoorBroken(currentVehicle, 4, true)
	end
	if damageOutside2 then
		SetVehicleTyreBurst(currentVehicle, 1, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 2, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 3, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 4, false, 990.0)
	end
	if body < 1000 then
		SetVehicleBodyHealth(currentVehicle, 985.1)
	end
end

function SetCarItemsInfo()
	local items = {}
	for k, item in pairs(Config.CarItems) do
		local itemInfo = scCore.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = item.info,
			label = itemInfo["label"],
			description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = item.slot,
		}
	end
	Config.CarItems = items
end

function IsArmoryWhitelist()
    local retval = false
    local citizenid = scCore.Functions.GetPlayerData().citizenid
    for k, v in pairs(Config.ArmoryWhitelist) do
        if v == citizenid then
            retval = true
            break
        end
    end
    return retval
end

function isBoss(job)
    local retval = false
    local roles = scCore.Shared.Jobs[job].roles
    for k, v in pairs(roles) do
        highestGrade = k
    end
    scCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.job.name == job and PlayerData.job.grade >= highestGrade then
            retval = true
        else
            retval = false
        end
    end)
    return retval
end

function SetWeaponSeries()
    for k, v in pairs(Config.Items.items) do
        if k < 6 then
            Config.Items.items[k].info.serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
        end
    end

    for k, v in pairs(Config.StatePDItems.items) do
        if k < 6 then
            Config.StatePDItems.items[k].info.serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
        end
    end

    for k, v in pairs(Config.FIBItems.items) do
        if k < 6 then
            Config.FIBItems.items[k].info.serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
        end
    end
end

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
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

RegisterNetEvent("police:client:JobOutfits")
AddEventHandler("police:client:JobOutfits", function()
    MenuPoliceOutfits()
    Menu.hidden = not Menu.hidden
    renderGUI = true

    while renderGUI do
		Wait(5)
		Menu.renderGUI()
	end
end)

RegisterNetEvent("police:client:PersonalOutfits")
AddEventHandler("police:client:PersonalOutfits", function()
    PersonalOutfitsMenu()
    Menu.hidden = not Menu.hidden
    renderGUI = true

    while renderGUI do
		Wait(5)
		Menu.renderGUI()
	end
end)

function MenuPoliceOutfits()
    ped = GetPlayerPed(-1);
    if PlayerJob.name == "police" then
        MenuTitle = "Police Outfits"
    elseif PlayerJob.name == "statepolice" then
        MenuTitle = "State Police Outfits"
    else
        MenuTitle = "FIB Outfits"
    end

    ClearMenu()
    Menu.addButton("Outfits", "OutfitList", PlayerJob.name)
    Menu.addButton("Close Menu", "close", nil)
end

function OutfitList(plyJob)
    ped = GetPlayerPed(-1);
    gender = scCore.Functions.GetPlayerData().charinfo.gender
    if plyJob == "police" then
        MenuTitle = "Police Outfits:"
        ClearMenu()

        if gender == 1 then
            Menu.addButton("[0] Civilian Clothes", "SelectOutfit", "civilian")
            Menu.addButton("[1] Police", "SelectOutfit", "femalepolice")
            Menu.addButton("[2] Police 2", "SelectOutfit", "femalepolice2")
            Menu.addButton("[3] Police 3", "SelectOutfit", "femalepolice3")
            Menu.addButton("[4] Police 4", "SelectOutfit", "femalepolice4")

            Menu.addButton("[7] Body Vest", "SelectOutfit", "femalevest")
            Menu.addButton("[8] Blue Vest", "SelectOutfit", "femalebluevest")
        else
            Menu.addButton("[0] Civilian Clothes", "SelectOutfit", "civilian")
            Menu.addButton("[1] Police", "SelectOutfit", "police")
            Menu.addButton("[2] Police 2", "SelectOutfit", "police2")
            Menu.addButton("[3] Air Support", "SelectOutfit", "airsupport")
            Menu.addButton("[4] SWAT", "SelectOutfit", "swat")
            Menu.addButton("[5] GIU", "SelectOutfit", "giu")
            Menu.addButton("[6] Motorcycle Division", "SelectOutfit", "moto")

            Menu.addButton("[5] Body Vest", "SelectOutfit", "vest")
            Menu.addButton("[6] Blue Vest", "SelectOutfit", "bluevest")
        end
    elseif plyJob == "statepolice" then
        MenuTitle = "State Police Outfits:"
        ClearMenu()

        if gender == 1 then
            Menu.addButton("[1] State PD", "SelectOutfit", "femaleStatePD")
        else
            Menu.addButton("[1] State PD 1", "SelectOutfit", "maleStatePD")
            Menu.addButton("[2] State PD 2", "SelectOutfit", "maleStatePD2")
            Menu.addButton("[3] State PD 3", "SelectOutfit", "maleStatePD3")
        end

        Menu.addButton("[0] Civilian Clothes", "SelectOutfit", "civilian")
    else
        MenuTitle = "FIB Outfits:"
        ClearMenu()

        Menu.addButton("[0] Civilian Clothes", "SelectOutfit", "civilian")
        Menu.addButton("[1] FIB 1", "SelectOutfit", "fib")
        Menu.addButton("[2] FIB 2", "SelectOutfit", "fib2")
    end

    Menu.addButton("Back", "MenuPoliceOutfits")
end

function SelectOutfit(outfit)
    
    if outfit == "civilian" then
        TriggerServerEvent('lcrp-clothes:get_character_current')
        TriggerServerEvent("lcrp-clothes:retrieve_tats")
    end

    if outfit == "maleStatePD" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 19, texture = 1},
                ["arms"]        = { item = 6, texture = 0}, 
                ["t-shirt"]     = { item = 129, texture = 0},  
                ["torso2"]      = { item = 39, texture = 1},  
                ["shoes"]       = { item = 97, texture = 0},  
                ["decals"]      = { item = -1, texture = 0}, 
                ["hat"]         = { item = -1, texture = 5},  
                ["mask"]        = { item = -1, texture = 0},  
                ["accessory"]   = { item = -1, texture = 0},  
                ["vest"]        = { item = 0, texture = 0}, 
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "maleStatePD2" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 19, texture = 0},
                ["arms"]        = { item = 6, texture = 0}, 
                ["t-shirt"]     = { item = 129, texture = 0},  
                ["torso2"]      = { item = 39, texture = 0},  
                ["shoes"]       = { item = 97, texture = 0},  
                ["decals"]      = { item = -1, texture = 0}, 
                ["hat"]         = { item = -1, texture = 5},  
                ["mask"]        = { item = -1, texture = 0},  
                ["accessory"]   = { item = -1, texture = 0},  
                ["vest"]        = { item = 0, texture = 0}, 
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "maleStatePD3" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 19, texture = 0},
                ["arms"]        = { item = 0, texture = 0}, 
                ["t-shirt"]     = { item = 105, texture = 0},
                ["torso2"]      = { item = 34, texture = 0},
                ["shoes"]       = { item = 54, texture = 2},
                ["decals"]      = { item = -1, texture = 0}, 
                ["hat"]         = { item = -1, texture = 5},
                ["mask"]        = { item = -1, texture = 0},
                ["accessory"]   = { item = -1, texture = 0},
                ["vest"]        = { item = 0, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "femaleStatePD" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 64, texture = 0},
                ["arms"]        = { item = 0, texture = 0}, 
                ["t-shirt"]     = { item = 125, texture = 0},
                ["torso2"]      = { item = 299, texture = 0},
                ["shoes"]       = { item = 52, texture = 2},
                ["decals"]      = { item = -1, texture = 0}, 
                ["hat"]         = { item = -1, texture = 5},
                ["mask"]        = { item = -1, texture = 0},
                ["accessory"]   = { item = -1, texture = 0},
                ["vest"]        = { item = 0, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "femalepolice" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 3, texture = 0},
                ["arms"]        = { item = 14, texture = 0}, 
                ["t-shirt"]     = { item = 15, texture = 0},  
                ["torso2"]      = { item = 14, texture = 0},  
                ["shoes"]       = { item = 24, texture = 0},  
                ["decals"]      = { item = -1, texture = 0}, 
                ["hat"]         = { item = -1, texture = 5},  
                ["mask"]        = { item = -1, texture = 0},  
                ["accessory"]   = { item = 125, texture = 0},  
                ["vest"]        = { item = 0, texture = 0}, 
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "femalepolice2" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 3, texture = 0},
                ["arms"]        = { item = 14, texture = 0}, 
                ["t-shirt"]     = { item = 15, texture = 0},  
                ["torso2"]      = { item = 74, texture = 0},  
                ["shoes"]       = { item = 24, texture = 0},  
                ["decals"]      = { item = -1, texture = 0}, 
                ["hat"]         = { item = -1, texture = 5},  
                ["mask"]        = { item = -1, texture = 0},  
                ["accessory"]   = { item = 125, texture = 0},  
                ["vest"]        = { item = 0, texture = 0}, 
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "femalepolice3" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 3, texture = 0},
                ["arms"]        = { item = 14, texture = 0}, 
                ["t-shirt"]     = { item = 15, texture = 0},  
                ["torso2"]      = { item = 92, texture = 3},  
                ["shoes"]       = { item = 24, texture = 0},  
                ["decals"]      = { item = -1, texture = 0}, 
                ["hat"]         = { item = -1, texture = 5},  
                ["mask"]        = { item = -1, texture = 0},  
                ["accessory"]   = { item = 125, texture = 0},  
                ["vest"]        = { item = 0, texture = 0}, 
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "femalepolice4" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 3, texture = 0},
                ["arms"]        = { item = 14, texture = 0}, 
                ["t-shirt"]     = { item = 15, texture = 0},  
                ["torso2"]      = { item = 93, texture = 3},  
                ["shoes"]       = { item = 24, texture = 0},  
                ["decals"]      = { item = -1, texture = 0}, 
                ["hat"]         = { item = -1, texture = 5},  
                ["mask"]        = { item = -1, texture = 0},  
                ["accessory"]   = { item = 125, texture = 0},  
                ["vest"]        = { item = 0, texture = 0}, 
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end


    if outfit == "fib" then 
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 10, texture = 0},
                ["arms"]        = { item = 86, texture = 0}, 
                ["t-shirt"]     = { item = 11, texture = 0},  
                ["torso2"]      = { item = 254, texture = 3},  
                ["shoes"]       = { item = 20, texture = 0},  
                ["decals"]      = { item = -1, texture = 0}, 
                ["hat"]         = { item = -1, texture = 5},  
                ["mask"]        = { item = -1, texture = 0},  
                ["accessory"]   = { item = 125, texture = 0},  
                ["vest"]        = { item = 0, texture = 0}, 
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "fib2" then 
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 10, texture = 0},
                ["arms"]        = { item = 37, texture = 0}, 
                ["t-shirt"]     = { item = 122, texture = 0},  
                ["torso2"]      = { item = 26, texture = 3},  
                ["shoes"]       = { item = 20, texture = 0},  
                ["decals"]      = { item = 56, texture = 0}, 
                ["hat"]         = { item = -1, texture = 5},  
                ["mask"]        = { item = -1, texture = 0},  
                ["accessory"]   = { item = 125, texture = 0},  
                ["vest"]        = { item = 0, texture = 0}, 
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "vest" then
        ClothingDataName = {
            outfitData = {
                ["vest"]       = { item = 16, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "bluevest" then
        ClothingDataName = {
            outfitData = {
                ["vest"]       = { item = 10, texture = 1},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "femalebluevest" then
        ClothingDataName = {
            outfitData = {
                ["vest"]       = { item = 19, texture = 1},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "femalevest" then
        ClothingDataName = {
            outfitData = {
                ["vest"]       = { item = 30, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "police" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 24, texture = 0},
                ["arms"]        = { item = 1, texture = 0}, 
                ["t-shirt"]     = { item = 105, texture = 0},  
                --["vest"]        = { item = 18, texture = 0},  
                ["torso2"]      = { item = 102, texture = 3},  
                ["shoes"]       = { item = 24, texture = 0},  
                ["decals"]      = { item = 1, texture = 0}, 
                --["accessory"]   = { item = 8, texture = 0},  
                ["hat"]         = { item = 83, texture = 5},  
                ["mask"]        = { item = -1, texture = 0},  
                --["mask"]         = { item = 121, texture = 0}, 
                ["vest"]       = { item = 0, texture = 0}, 
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "police2" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 24, texture = 0},
                ["arms"]        = { item = 0, texture = 0}, 
                ["t-shirt"]     = { item = 105, texture = 0},  
                --["vest"]        = { item = 18, texture = 0},  
                ["torso2"]      = { item = 2, texture = 0},  
                ["shoes"]       = { item = 24, texture = 0},  
                ["decals"]      = { item = 1, texture = 0}, 
                --["accessory"]   = { item = 8, texture = 0},  
                ["hat"]         = { item = 83, texture = 1},  
                ["mask"]        = { item = -1, texture = 0},  
                --["mask"]         = { item = 121, texture = 0}, 
                ["vest"]       = { item = 0, texture = 0}, 
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "airsupport" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 52, texture = 0},
                ["arms"]        = { item = 0, texture = 0}, 
                ["t-shirt"]     = { item = 15, texture = 0},  
                --["vest"]        = { item = 18, texture = 0},  
                ["torso2"]      = { item = 65, texture = 0},  
                ["shoes"]       = { item = 12, texture = 6},  
                ["decals"]      = { item = 0, texture = 0}, 
                --["accessory"]   = { item = 8, texture = 0},  
                ["hat"]         = { item = 79, texture = 0},  
                ["mask"]        = { item = -1, texture = 0},  
                --["mask"]         = { item = 121, texture = 0},  
                ["vest"]       = { item = 0, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "swat" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 52, texture = 1},
                ["arms"]        = { item = 31, texture = 0}, 
                ["t-shirt"]     = { item = 15, texture = 0},  
                --["vest"]        = { item = 18, texture = 0},  
                ["torso2"]      = { item = 110, texture = 0},  
                ["shoes"]       = { item = 12, texture = 6},  
                ["decals"]      = { item = 0, texture = 0}, 
                --["accessory"]   = { item = 8, texture = 0},  
                ["hat"]         = { item = -1, texture = 1},  
                ["mask"]         = { item = 52, texture = 0},  
                ["vest"]       = { item = 0, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "giu" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 52, texture = 1},
                ["arms"]        = { item = 31, texture = 0}, 
                ["t-shirt"]     = { item = 15, texture = 0},  
                --["vest"]        = { item = 18, texture = 0},  
                ["torso2"]      = { item = 95, texture = 1},  
                ["shoes"]       = { item = 12, texture = 6},  
                ["decals"]      = { item = 0, texture = 0}, 
                --["accessory"]   = { item = 8, texture = 0},  
                ["hat"]         = { item = 7, texture = 0},  
                ["mask"]         = { item = -1, texture = 0},  
                ["vest"]       = { item = -1, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "moto" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 24, texture = 0},
                ["arms"]        = { item = 31, texture = 0}, 
                ["t-shirt"]     = { item = 105, texture = 0},  
                --["vest"]        = { item = 18, texture = 0},  
                ["torso2"]      = { item = 160, texture = 0},  
                ["shoes"]       = { item = 12, texture = 6},  
                ["decals"]      = { item = 0, texture = 0}, 
                --["accessory"]   = { item = 8, texture = 0},  
                ["hat"]         = { item = 48, texture = 0},  
                ["mask"]         = { item = -1, texture = 0},  
                ["vest"]       = { item = -1, texture = 0},
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    TriggerEvent('InteractSound_CL:PlayOnOne','Clothes1', 0.6)
    closeMenuFull()
end

RegisterNetEvent("police:client:EvidenceLocker")
AddEventHandler("police:client:EvidenceLocker", function(locker)
    if PlayerJob.name == "police" or PlayerJob.name == "statepolice" or PlayerJob.name == "fib" then
        if locker == 1 then
            TriggerServerEvent("inventory:server:OpenInventory", "stash", PlayerJob.name.."evidence", {
                maxweight = 4000000,
                slots = 500,
            })
            TriggerEvent("inventory:client:SetCurrentStash", PlayerJob.name.."evidence")
        elseif locker == 2 then
            TriggerServerEvent("inventory:server:OpenInventory", "stash", PlayerJob.name.."evidence2", {
                maxweight = 4000000,
                slots = 500,
            })
            TriggerEvent("inventory:client:SetCurrentStash", PlayerJob.name.."evidence2")
        elseif locker == 3 then
            TriggerServerEvent("inventory:server:OpenInventory", "stash", PlayerJob.name.."evidence3", {
                maxweight = 4000000,
                slots = 500,
            })
            TriggerEvent("inventory:client:SetCurrentStash", PlayerJob.name.."evidence3")
        end
    end
end)

RegisterNetEvent("police:client:PersonalStash")
AddEventHandler("police:client:PersonalStash", function(number)
    playerData = scCore.Functions.GetPlayerData()
    playerJob = playerData.job.name
    plyCID = playerData.citizenid
    
    if json.encode(number) == "[]" then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", playerJob.."stash_"..plyCID)
        TriggerEvent("inventory:client:SetCurrentStash", playerJob.."stash_"..plyCID)
    else
        TriggerServerEvent("inventory:server:OpenInventory", "stash", playerJob.."stash"..number.."_"..plyCID)
        TriggerEvent("inventory:client:SetCurrentStash", playerJob.."stash"..number.."_"..plyCID)
    end
end)

RegisterNetEvent("police:client:Armory")
AddEventHandler("police:client:Armory", function(number)
    SetWeaponSeries()
    if PlayerJob.name == "fib" then
        TriggerServerEvent("inventory:server:OpenInventory", "shop", "fib", Config.FIBItems)
    elseif PlayerJob.name == "police" then
        if number == 1 then
            TriggerServerEvent("inventory:server:OpenInventory", "shop", "police", Config.Items)
        elseif number == 2 then
            TriggerServerEvent("inventory:server:OpenInventory", "shop", "police", Config.GuardItems)
        end
    elseif PlayerJob.name == "statepolice" then
        TriggerServerEvent("inventory:server:OpenInventory", "shop", "statepolice", Config.StatePDItems)
    end
end)

RegisterNetEvent("police:client:VehicleGarage")
AddEventHandler("police:client:VehicleGarage", function()
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        scCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
    else
        MenuGarage()
        currentGarage = k
        Menu.hidden = not Menu.hidden
        renderGUI = true
    
        while renderGUI do
            Wait(5)
            Menu.renderGUI()
        end
    end
end)

RegisterNetEvent("police:client:Duty")
AddEventHandler("police:client:Duty", function()
    local player = PlayerId()
    onDuty = not onDuty
    TriggerServerEvent("scCore:ToggleDuty")

    if PlayerJob == "police" or PlayerJob == "statepolice" or PlayerJob == "fib" then
        if onDuty then
            -- TriggerServerEvent("lcrp-logs:server:CreateLog", "duty", GetPlayerName(player) .. " Went On duty")
            TriggerServerEvent("police:server:UpdateCurrentCops", 1)
        else
            -- TriggerServerEvent("lcrp-logs:server:CreateLog", "duty", GetPlayerName(player) .. " Went Off duty")
            TriggerServerEvent("police:server:UpdateCurrentCops", -1)
        end
        TriggerServerEvent("police:server:UpdateBlips")
    elseif PlayerJob == "ambulance" then
        if onDuty then
            TriggerServerEvent("hospital:server:UpdateCurrentEMS", 1)
        else
            TriggerServerEvent("hospital:server:UpdateCurrentEMS", -1)
        end
        TriggerServerEvent("police:server:UpdateBlips")
    end
end)

function isCop()
    retval = false
    if PlayerJob.name == "police" or PlayerJob.name == "statepolice" or PlayerJob.name == "fib" and onDuty then
        retval = true
    end
    return retval
end

RegisterNetEvent("police:client:Fingerprint")
AddEventHandler("police:client:Fingerprint", function()
    if isCop() then
        local player, distance = GetClosestPlayer()
        if player ~= -1 and distance < 2.5 then
            local playerId = GetPlayerServerId(player)
            TriggerServerEvent("police:server:checkFingerprint", playerId)
        else
            scCore.Notification("No one nearby!", "error")
        end
    end
end)

RegisterNetEvent("police:client:BossActions")
AddEventHandler("police:client:BossActions", function()
    if isBoss(PlayerJob.name) then
        local playerId = GetPlayerServerId(player)
        TriggerEvent("police:server:OpenSocietyMenu", PlayerJob.name)
    else
        scCore.Notification("You are not boss!", "error")
    end
end)

RegisterNetEvent("police:client:Helicopter")
AddEventHandler("police:client:Helicopter", function()
    if isCop() then
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            scCore.Functions.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
        else
            local plyPos = GetEntityCoords(PlayerPedId())
            local coords = {x = plyPos.x , y = plyPos.y, z = plyPos.z, a = 0.0}
            scCore.Functions.SpawnVehicle(Config.Helicopter, function(veh)
                SetVehicleNumberPlateText(veh, "LSPD"..tostring(math.random(1000, 9999)))
                SetEntityHeading(veh, coords.h)
                exports['LegacyFuel']:SetFuel(veh, 100.0)
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                SetVehicleEngineOn(veh, true, true)
            end, coords, true)
        end
    end
end)

RegisterNetEvent("police:client:Elevator")
AddEventHandler("police:client:Elevator", function(coords)
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end

    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, 0, 0, 0, false)
    SetEntityHeading(PlayerPedId(), coords.h)

    Citizen.Wait(100)

    DoScreenFadeIn(1000)
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddBoxZone("mrpdPoliceDuty", vector3(441.79, -982.07, 30.69), 0.4, 0.6, {
    name="mrpdPoliceDuty",
    heading=91,
    minZ=30.79,
    maxZ=30.99 }, {
    options = {
        {
            event = "police:client:Duty",
            icon = "fas fa-address-card",
            label = "Clock in",
            duty = false,
            parameters = "duty",
        },
        {
            event = "police:client:Duty",
            icon = "fas fa-address-card",
            label = "Clock out",
            duty = true,
            parameters = "duty",
        },
    },
    job = {"police", "statepolice", "fib"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("mrpdPoliceStash", vector3(452.49, -980.18, 30.69), 0.6, 0.6, {
    name="mrpdPoliceStash",
    heading=175,
    
    minZ=30.59,
    maxZ=31.2 }, {
    options = {
        {
            event = "police:client:PersonalStash",
            icon = "fas fa-briefcase",
            label = "Personal Stash",
            duty = true,
        },
    },
    job = {"police", "statepolice", "fib"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("mrpdPoliceArmory", vector3(485.42, -994.89, 30.69), 0.4, 1, {
        name="mrpdPoliceArmory",
        heading=0,
        minZ=28.49,
        maxZ=32.49 }, {
        options = {
            {
                event = "police:client:Armory",
                icon = "fas fa-shield",
                label = "Police Armory",
                duty = true,
                parameters = 1,
            },
        },
    job = {"police", "statepolice", "fib"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("mrpdPoliceClothing", vector3(464.3, -996.65, 30.69), 1.0, 0.2, {
        name="mrpdPoliceClothing",
        heading=359,
        
        minZ=28.49,
        maxZ=32.49}, {
        options = {
            {
                event = "police:client:JobOutfits",
                icon = "fas fa-tshirt",
                label = "Police Outfits",
                duty = true,
            },
            {
                event = "raid-clothes:OpenClothesMenu",
                icon = "fas fa-tshirt",
                label = "Clothing Menu",
                duty = true,
            },
            {
                event = "police:client:PersonalOutfits",
                icon = "fas fa-tshirt",
                label = "Outfit List",
                duty = true,
            },
        },
    job = {"police", "statepolice", "fib"}, distance = 2.5 })

    exports["lcrp-interact"]:AddBoxZone("mrpdPoliceFingerprint", vector3(483.69, -988.54, 30.69), 0.9, 0.5, {
        name="mrpdPoliceFingerprint",
        heading=270,
        
        minZ=29.39,
        maxZ=31.39 }, {
        options = {
            {
                event = "police:client:Fingerprint",
                icon = "fas fa-fingerprint",
                label = "Scan person\'s fingerprint",
                duty = true,
            },
        },
    job = {"police", "statepolice", "fib"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("mrpdPoliceEvidence", vector3(474.82, -997.23, 26.27), 8.7, 1.5, {
        name="mrpdPoliceEvidence",
        heading=0,
        
        minZ=23.47,
        maxZ=27.47 }, {
        options = {
            {
                event = "police:client:EvidenceLocker",
                icon = "fas fa-lock",
                label = "Evidence Locker 1",
                parameters = 1,
                duty = true,
            },
            {
                event = "police:client:EvidenceLocker",
                icon = "fas fa-lock",
                label = "Evidence Locker 2",
                parameters = 2,
                duty = true,
            },
            {
                event = "police:client:EvidenceLocker",
                icon = "fas fa-lock",
                label = "Evidence Locker 3",
                parameters = 3,
                duty = true,
            },
        },
    job = {"police", "statepolice", "fib"}, distance = 4.5 })

    exports["lcrp-interact"]:AddBoxZone("mrpdPoliceGarage", vector3(452.19, -987.02, 25.7), 14.8, 9.2, {
        name="mrpdPoliceGarage",
        heading=2,
        
        minZ=23.47,
        maxZ=28.47 }, {
        options = {
            {
                event = "police:client:VehicleGarage",
                icon = "fas fa-car-alt",
                label = "Police Garage",
                storeVeh = true,
                duty = true,
            },
        },
    job = {"police", "statepolice", "fib"}, distance = 5.5 })

    exports["lcrp-interact"]:AddBoxZone("mrpdPoliceBoss", vector3(463.28, -984.22, 30.73), 1.2, 1, {
        name="mrpdPoliceBoss",
        heading=0,
        --debugPoly=true,
        minZ=29.58,
        maxZ=31.18 }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-car-alt",
                label = "Chief\'s Actions",
                duty = true,
            },
        },
    job = {"police", "statepolice", "fib"}, distance = 5.5 })

    exports["lcrp-interact"]:AddBoxZone("mrpdPoliceHeli", vector3(449.34, -980.94, 43.69), 17.8, 17.8, {
        name="mrpdPoliceHeli",
        heading=0,
        
        minZ=42.69,
        maxZ=55.69 }, {
        options = {
            {
                event = "police:client:Helicopter",
                icon = "fas fa-car-alt",
                label = "Take out Helicopter",
                storeVeh = true,
                duty = true,
            },
        },
    job = {"police", "statepolice", "fib"}, distance = 8.5 })

    -- STATE POLICE --

    exports["lcrp-interact"]:AddBoxZone("statePoliceDuty", vector3(1549.27, 837.46, 77.66), 2.2, 2.2, {
        name="statePoliceDuty",
        heading=330,
        minZ=76.66,
        
        maxZ=79.06 }, {
        options = {
            {
                event = "police:client:Duty",
                icon = "fas fa-address-card",
                label = "Clock in",
                duty = false,
                parameters = "duty",
            },
            {
                event = "police:client:Duty",
                icon = "fas fa-address-card",
                label = "Clock out",
                duty = true,
                parameters = "duty",
            },
        },
    job = {"police", "statepolice", "fib"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("statePoliceArmory", vector3(1550.27, 841.36, 77.66), 2.8, 2.2, {
        name="statePoliceArmory",
        heading=330,
        minZ=76.66,
        maxZ=84.06 }, {
        options = {
            {
                event = "police:client:Armory",
                icon = "fas fa-shield",
                label = "Armory",
                duty = true,
            },
        },
    job = {"police", "statepolice", "fib"}, distance = 2.5 })

    exports["lcrp-interact"]:AddBoxZone("statePoliceClothing", vector3(1539.59, 811.08, 77.66), 2.4, 2.0, {
        name="statePoliceClothing",
        heading=329,
        minZ=76.66,
        maxZ=79.56}, {
        options = {
            {
                event = "police:client:JobOutfits",
                icon = "fas fa-tshirt",
                label = "State Police Outfits",
                duty = true,
            },
            {
                event = "raid-clothes:OpenClothesMenu",
                icon = "fas fa-tshirt",
                label = "Clothing Menu",
                duty = true,
            },
            {
                event = "police:client:PersonalOutfits",
                icon = "fas fa-tshirt",
                label = "Outfit List",
                duty = true,
            },
        },
    job = {"police", "statepolice", "fib"}, distance = 2.5 })

    exports["lcrp-interact"]:AddBoxZone("statePoliceFingerprint", vector3(1541.21, 825.1, 77.66), 1.8, 2.0, {
        name="statePoliceFingerprint",
        heading=330,
        
        minZ=77.51,
        maxZ=78.51 
    }, {
        options = {
            {
                event = "police:client:Fingerprint",
                icon = "fas fa-fingerprint",
                label = "Scan person\'s fingerprint",
                duty = true,
            },
        },
    job = {"police", "statepolice", "fib"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("statePoliceStash", vector3(1545.08, 834.11, 77.66), 0.6, 2.2, {
        name="statePoliceStash",
        heading=330,
        
        minZ=77.56,
        maxZ=78.16 }, {
        options = {
            {
                event = "police:client:PersonalStash",
                icon = "fas fa-briefcase",
                label = "Personal Stash",
                duty = true,
            },
        },
    job = {"police", "statepolice", "fib"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("statePoliceBoss", vector3(1540.42, 816.29, 82.13), 1.2, 3.0, {
        name="statePoliceBoss",
        heading=330,
        
        minZ=82.03,
        maxZ=82.63 }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-car-alt",
                label = "Commissioner\'s Actions",
                duty = true,
            },
        },
    job = {"police", "statepolice", "fib"}, distance = 5.5 })

    exports["lcrp-interact"]:AddBoxZone("statePoliceEvidence", vector3(1548.0, 826.95, 82.13), 1.8, 2.6, {
        name="statePoliceEvidence",
        heading=330,
        
        minZ=81.13,
        maxZ=84.33 }, {
        options = {
            {
                event = "police:client:EvidenceLocker",
                icon = "fas fa-lock",
                label = "Evidence Locker 1",
                parameters = 1,
                duty = true,
            },
            {
                event = "police:client:EvidenceLocker",
                icon = "fas fa-lock",
                label = "Evidence Locker 2",
                parameters = 2,
                duty = true,
            },
            {
                event = "police:client:EvidenceLocker",
                icon = "fas fa-lock",
                label = "Evidence Locker 3",
                parameters = 3,
                duty = true,
            },
        },
    job = {"police", "statepolice", "fib"}, distance = 4.5 })

    exports["lcrp-interact"]:AddBoxZone("statePoliceGarage", vector3(1542.64, 795.69, 77.14), 10.4, 13.0, {
        name="statePoliceGarage",
        heading=325,
        
        minZ=75.94,
        maxZ=81.74 }, {
        options = {
            {
                event = "police:client:VehicleGarage",
                icon = "fas fa-car-alt",
                label = "State Police Garage",
                storeVeh = true,
                duty = true,
            },
        },
    job = {"police", "statepolice", "fib"}, distance = 5.5 })

    -- FIB

    exports["lcrp-interact"]:AddBoxZone("fibDuty", vector3(16.43, -928.89, 29.9), 2.0, 1, {
        name="fibDuty",
        heading=25,
        minZ=29.55,
        maxZ=31.35
    }, {
        options = {
            {
                event = "police:client:Duty",
                icon = "fas fa-address-card",
                label = "Clock in",
                duty = false,
                parameters = "duty",
            },
            {
                event = "police:client:Duty",
                icon = "fas fa-address-card",
                label = "Clock out",
                duty = true,
                parameters = "duty",
            },
        },
    job = {"fib"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("fibElevator1", vector3(8.58, -920.06, 29.9), 2.8, 2.6, {
        name="fibElevator1",
        heading=25,
        --debugPoly=true,
        minZ=28.9,
        maxZ=31.3
        }, {
        options = {
            {
                event = "police:client:Elevator",
                icon = "fas fa-arrow-up",
                label = "Take the elevator up",
                duty = false,
                parameters = {x= 8.58, y=-920.06, z=33.9},
            },
        },
    job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("fibElevator2", vector3(8.5, -920.11, 33.9), 2.8, 2.8, {
        name="fibElevator2",
        heading=340,
        --debugPoly=true,
        minZ=32.9,
        maxZ=35.5
        }, {
        options = {
            {
                event = "police:client:Elevator",
                icon = "fas fa-arrow-up",
                label = "Take the elevator down",
                duty = false,
                parameters = {x= 8.58, y=-920.06, z=29.9},
            },
        },
    job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("fibEvidence", vector3(40.21, -911.9, 29.9), 4, 4, {
        name="fibEvidence",
        heading=25,
        minZ=28.9,
        maxZ=32.1
     }, {
        options = {
            {
                event = "police:client:EvidenceLocker",
                icon = "fas fa-lock",
                label = "Evidence Locker 1",
                parameters = 1,
                duty = true,
            },
            {
                event = "police:client:EvidenceLocker",
                icon = "fas fa-lock",
                label = "Evidence Locker 2",
                parameters = 2,
                duty = true,
            },
            {
                event = "police:client:EvidenceLocker",
                icon = "fas fa-lock",
                label = "Evidence Locker 3",
                parameters = 3,
                duty = true,
            },
        },
    job = {"fib"}, distance = 2.5 })

    exports["lcrp-interact"]:AddBoxZone("fibArmory", vector3(23.95, -938.49, 29.9), 0.6, 2.8, {
        name="fibArmory",
        heading=25,
        minZ=29.75,
        maxZ=30.55
     }, {
        options = {
            {
                event = "police:client:Armory",
                icon = "fas fa-shield",
                label = "Armory",
                duty = true,
            },
        },
    job = {"fib"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("fibArmory2", vector3(28.81, -936.23, 29.9), 0.6, 2.8, {
        name="fibArmory2",
        heading=25,
        minZ=29.75,
        maxZ=30.55
     }, {
        options = {
            {
                event = "police:client:Armory",
                icon = "fas fa-shield",
                label = "Armory",
                duty = true,
            },
        },
    job = {"fib"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("fibBoss", vector3(24.07, -924.81, 33.9), 1.4, 2.4, {
        name="fibBoss",
        heading=25,
        minZ=33.6,
        maxZ=34.2
     }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fas fa-car-alt",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"fib"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("fibClothing", vector3(15.43, -913.26, 33.9), 5, 4.0, {
        name="fibClothing",
        heading=25,
        minZ=32.9,
        maxZ=36.3
    }, {
        options = {
            {
                event = "police:client:JobOutfits",
                icon = "fas fa-tshirt",
                label = "Fib Police Outfits",
                duty = true,
            },
            {
                event = "raid-clothes:OpenClothesMenu",
                icon = "fas fa-tshirt",
                label = "Clothing Menu",
                duty = true,
            },
            {
                event = "police:client:PersonalOutfits",
                icon = "fas fa-tshirt",
                label = "Outfit List",
                duty = true,
            },
        },
    job = {"fib"}, distance = 2.5 })

    exports["lcrp-interact"]:AddBoxZone("fibFingerprint", vector3(20.75, -926.84, 29.9), 1, 1, {
        name="fibFingerprint",
        heading=25,
        minZ=28.8,
        maxZ=31.0
     }, {
        options = {
            {
                event = "police:client:Fingerprint",
                icon = "fas fa-fingerprint",
                label = "Scan person\'s fingerprint",
                duty = true,
            },
        },
    job = {"fib"}, distance = 1.5 })

    exports["lcrp-interact"]:AddBoxZone("fibGarage", vector3(31.26, -885.19, 30.22), 15.4, 14.0, {
        name="fibGarage",
        heading=340,        
        minZ=29.22,
        maxZ=35.42
     }, {
        options = {
            {
                event = "police:client:VehicleGarage",
                icon = "fas fa-car-alt",
                label = "FIB Garage",
                storeVeh = true,
                duty = true,
            },
            {
                event = "police:client:Helicopter",
                icon = "fas fa-car-alt",
                label = "Take out Helicopter",
                storeVeh = true,
                duty = true,
            },
        },
    job = {"fib"}, distance = 8.5 })
end)