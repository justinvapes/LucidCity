local ClosestCustomVehicle = 1
local CustomModelLoaded = true
local testritveh = 0
local isOnVip = false

Citizen.CreateThread(function()
    Dealer = AddBlipForCoord(ConfigCustom.VehicleBuyLocation.x, ConfigCustom.VehicleBuyLocation.y, ConfigCustom.VehicleBuyLocation.z)

    SetBlipSprite (Dealer, 326)
    SetBlipDisplay(Dealer, 4)
    SetBlipScale  (Dealer, 0.75)
    SetBlipAsShortRange(Dealer, true)
    SetBlipColour(Dealer, 3)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Import Dealership")
    EndTextCommandSetBlipName(Dealer)
end)

CustomVehicleCats = {
    ["coupes"] = {
        label = "Imported Vehicles",
        vehicles = {}
    },
}

CustomVehicleShop = {
	opened = false,
	title = "Vehicle Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 250, type = 1 },
	menu = {
		x = 0.14,
		y = 0.15,
		width = 0.12,
		height = 0.03,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.29,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Vehicles", description = ""},
			}
		},
		["vehicles"] = {
			title = "VEHICLES",
			name = "vehicles",
			buttons = {}
		},	
	}
}

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    for k, v in pairs(scCore.Shared.Vehicles) do
        if v["shop"] == "custom" then
            for cat,_ in pairs(CustomVehicleCats) do
                if scCore.Shared.Vehicles[k]["category"] == cat then
                    table.insert(CustomVehicleCats[cat].vehicles, scCore.Shared.Vehicles[k])
                end
            end
        end
    end
    for k, v in pairs(CustomVehicleCats) do
        table.insert(CustomVehicleShop.menu["vehicles"].buttons, {
            menu = k,
            name = v.label,
            description = {}
        })

        CustomVehicleShop.menu[k] = {
            title = k,
            name = v.label,
            buttons = v.vehicles
        }
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    for i = 1, #ConfigCustom.ShowroomPositions, 1 do
        local oldVehicle = GetClosestVehicle(ConfigCustom.ShowroomPositions[i].coords.x, ConfigCustom.ShowroomPositions[i].coords.y, ConfigCustom.ShowroomPositions[i].coords.z, 3.0, 0, 70)
        if oldVehicle ~= 0 then
            scCore.Functions.DeleteVehicle(oldVehicle)
        end

		local model = GetHashKey(ConfigCustom.ShowroomPositions[i].vehicle)
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local veh = CreateVehicle(model, ConfigCustom.ShowroomPositions[i].coords.x, ConfigCustom.ShowroomPositions[i].coords.y, ConfigCustom.ShowroomPositions[i].coords.z, false, false)
		SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)
		SetEntityInvincible(veh,true)
        SetEntityHeading(veh, ConfigCustom.ShowroomPositions[i].coords.h)
        SetVehicleDoorsLocked(veh, 2)

		FreezeEntityPosition(veh,true)
		SetVehicleNumberPlateText(veh, i .. "CARSALE")
		SetVehicleOnGroundProperly(veh)
    end
end)

function SetClosestCustomVehicle()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil

    for id, veh in pairs(ConfigCustom.ShowroomPositions) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, ConfigCustom.ShowroomPositions[id].coords.x, ConfigCustom.ShowroomPositions[id].coords.y, ConfigCustom.ShowroomPositions[id].coords.z, true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, ConfigCustom.ShowroomPositions[id].coords.x, ConfigCustom.ShowroomPositions[id].coords.y, ConfigCustom.ShowroomPositions[id].coords.z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, ConfigCustom.ShowroomPositions[id].coords.x, ConfigCustom.ShowroomPositions[id].coords.y, ConfigCustom.ShowroomPositions[id].coords.z, true)
            current = id
        end
    end
    if current ~= ClosestCustomVehicle then
        ClosestCustomVehicle = current
    end
end

Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        local ShopDistance = GetDistanceBetweenCoords(pos, ConfigCustom.ShowroomPositions[1].coords.x, ConfigCustom.ShowroomPositions[1].coords.y, ConfigCustom.ShowroomPositions[1].coords.z, false)

        if isLoggedIn then
            if ShopDistance <= 100 then
                SetClosestCustomVehicle()
            end
        end
        Citizen.Wait(5000)
    end
end)

function isOwner()
    local retval = false
    local roles = scCore.Shared.Jobs["cardealer"].roles
    highestGrade = 0
    for k, v in pairs(roles) do
        if k > highestGrade then 
            highestGrade = k
        end
    end
    if PlayerJob.name == "cardealer" and PlayerJob.grade >= highestGrade - 1 then
        retval = true
    else
        retval = false
    end

    return retval
end

function isCustomValidMenu(menu)
    for k, v in pairs(CustomVehicleShop.menu["vehicles"].buttons) do
        if menu == v.menu then
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        sleep = 1000
        
        if isLoggedIn then
            if onDuty then
                if CustomVehicleShop.opened then
                    sleep = 5
                    local menu = CustomVehicleShop.menu[CustomVehicleShop.currentmenu]
                    local y = CustomVehicleShop.menu.y + 0.12
                    buttoncount = tablelength(menu.buttons)
                    local selected = false

                    if isOnVip then
                        local vipCars = {}
                        for i, button in pairs(menu.buttons) do
                            if button.name ~= "Vehicles" then
                                if button.vip then
                                    table.insert(vipCars, button)
                                end
                            else
                                if i == CustomVehicleShop.selectedbutton then
                                    selected = true
                                else
                                    selected = false
                                end
                                drawMenuButton(button,CustomVehicleShop.menu.x,y,selected)
                                y = y + 0.04
                                if selected and (IsControlJustPressed(1,38) or IsControlJustPressed(1, 18)) then
                                    CustomButtonSelected(button)
                                end
                            end
                        end
                        for k, v in pairs(vipCars) do
                            if k >= CustomVehicleShop.menu.from and k <= CustomVehicleShop.menu.to then
                                if k == CustomVehicleShop.selectedbutton then
                                    selected = true
                                else
                                    selected = false
                                end
                                drawMenuButton(v,CustomVehicleShop.menu.x,y,selected)
                                if v.price ~= nil then
                                    drawMenuRight("$"..v.price,CustomVehicleShop.menu.x,y,selected)
                                end
                                y = y + 0.04
                                if isCustomValidMenu(CustomVehicleShop.currentmenu) then
                                    if selected then
                                        if IsControlJustPressed(1, 18) then
                                            if CustomModelLoaded then
                                                TriggerServerEvent('lcrp-vehicleshop:server:SetCustomShowroomVeh', v.model, ClosestCustomVehicle)
                                            end
                                        end
                                    end
                                end
                                if selected and (IsControlJustPressed(1,38) or IsControlJustPressed(1, 18)) then
                                    CustomButtonSelected(v)
                                end
                            end
                        end
                    else
                        for i,button in pairs(menu.buttons) do
                            if i >= CustomVehicleShop.menu.from and i <= CustomVehicleShop.menu.to then
                                if i == CustomVehicleShop.selectedbutton then
                                    selected = true
                                else
                                    selected = false
                                end
                                drawMenuButton(button,CustomVehicleShop.menu.x,y,selected)
                                if button.price ~= nil then
                                    drawMenuRight("$"..button.price,CustomVehicleShop.menu.x,y,selected)
                                end
                                y = y + 0.04
                                if isCustomValidMenu(CustomVehicleShop.currentmenu) then
                                    if selected then
                                        if IsControlJustPressed(1, 18) then
                                            if CustomModelLoaded then
                                                TriggerServerEvent('lcrp-vehicleshop:server:SetCustomShowroomVeh', button.model, ClosestCustomVehicle)
                                            end
                                        end
                                    end
                                end
                                if selected and (IsControlJustPressed(1,38) or IsControlJustPressed(1, 18)) then
                                    CustomButtonSelected(button)
                                end
                            end
                        end
                    end
                end

                if CustomVehicleShop.opened then
                    if IsControlJustPressed(1,202) then
                        BackCustom()
                    end
                    if IsControlJustReleased(1,202) then
                        backlock = false
                    end
                    if IsControlJustPressed(1,188) then
                        if CustomModelLoaded then
                            if CustomVehicleShop.selectedbutton > 1 then
                                CustomVehicleShop.selectedbutton = CustomVehicleShop.selectedbutton -1
                                if buttoncount > 10 and CustomVehicleShop.selectedbutton < CustomVehicleShop.menu.from then
                                    CustomVehicleShop.menu.from = CustomVehicleShop.menu.from -1
                                    CustomVehicleShop.menu.to = CustomVehicleShop.menu.to - 1
                                end
                            end
                        end
                    end
                    if IsControlJustPressed(1,187)then
                        if CustomModelLoaded then
                            if CustomVehicleShop.selectedbutton < buttoncount then
                                CustomVehicleShop.selectedbutton = CustomVehicleShop.selectedbutton +1
                                if buttoncount > 10 and CustomVehicleShop.selectedbutton > CustomVehicleShop.menu.to then
                                    CustomVehicleShop.menu.to = CustomVehicleShop.menu.to + 1
                                    CustomVehicleShop.menu.from = CustomVehicleShop.menu.from + 1
                                end
                            end
                        end
                    end
                end

                vehEnterPlate = GetVehicleNumberPlateText(GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)))
                if vehEnterPlate ~= nil and string.match(vehEnterPlate, "CARSALE") then
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                end

                DisableControlAction(0, Keys["8"], true)
                DisableControlAction(0, Keys["9"], true)  
            end
        end

        if ConfigCustom.ShowroomPositions[ClosestCustomVehicle].buying and ConfigCustom.ShowroomPositions[ClosestCustomVehicle].vendor ~= nil then
            sleep = 5
            DrawText3Ds(ConfigCustom.ShowroomPositions[ClosestCustomVehicle].coords.x, ConfigCustom.ShowroomPositions[ClosestCustomVehicle].coords.y, ConfigCustom.ShowroomPositions[ClosestCustomVehicle].coords.z + 1.6, '~g~[8]~w~ - To buy / ~r~[9]~w~ - To Cancel - ~g~($'..scCore.Shared.Vehicles[ConfigCustom.ShowroomPositions[ClosestCustomVehicle].vehicle].price..',-)')
            if IsDisabledControlJustPressed(0, Keys["8"]) then
                local vendorId = ConfigCustom.ShowroomPositions[ClosestCustomVehicle].vendor
                TriggerServerEvent('lcrp-vehicleshop:server:ConfirmVehicle',vendorId, ConfigCustom.ShowroomPositions[ClosestCustomVehicle], closestPlayer)
                ConfigCustom.ShowroomPositions[ClosestCustomVehicle].buying = false
                ConfigCustom.ShowroomPositions[ClosestCustomVehicle].vendor = nil
            end

            if IsDisabledControlJustPressed(0, Keys["9"]) then
                scCore.Notification('Canceled buying!')
                ConfigCustom.ShowroomPositions[ClosestCustomVehicle].buying = false
                ConfigCustom.ShowroomPositions[ClosestCustomVehicle].vendor = nil
            end
        end

        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent("lcrp-vehicleshop:client:OfferVehicle")
AddEventHandler("lcrp-vehicleshop:client:OfferVehicle", function(vehParameter)
    if PlayerJob.name == "cardealer" then
        local targetId = scCore.KeyboardInput("Enter player\'s ID", "", 5)
        tonumber(targetId)
        TriggerEvent("lcrp-vehicleshop:client:SellCustomVehicle", targetId, vehParameter)
    end
end)

RegisterNetEvent("lcrp-vehicleshop:client:BuyVehAction")
AddEventHandler("lcrp-vehicleshop:client:BuyVehAction", function(vehParameters)
    if vehParameters ~= nil then
        local vendorId = ConfigCustom.ShowroomPositions[vehParameters].vendor
        TriggerServerEvent('lcrp-vehicleshop:server:ConfirmVehicle',vendorId, ConfigCustom.ShowroomPositions[vehParameters])
    end
    ConfigCustom.ShowroomPositions[vehParameters].buying = false
    ConfigCustom.ShowroomPositions[vehParameters].vendor = nil
end)

RegisterNetEvent('lcrp-vehicleshop:client:buyShowroomVehicle')
AddEventHandler('lcrp-vehicleshop:client:buyShowroomVehicle', function(vehicle, plate)
    scCore.Functions.SpawnVehicle(vehicle, function(veh)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        exports['LegacyFuel']:SetFuel(veh, 100)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, Config.DefaultBuySpawn.h)
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        TriggerServerEvent("vehicletuning:server:SaveVehicleProps", scCore.Functions.GetVehicleProperties(veh))
        SetEntityAsMissionEntity(veh, true, true)
    end, Config.DefaultBuySpawn, false)
end)

RegisterNetEvent('lcrp-vehicleshop:client:SetCustomShowroomVeh')
AddEventHandler('lcrp-vehicleshop:client:SetCustomShowroomVeh', function(showroomVehicle, k)
    if scCore ~= nil then
        CancelEvent()
        if ConfigCustom.ShowroomPositions[k].vehicle ~= showroomVehicle then
            scCore.Functions.DeleteVehicle(GetClosestVehicle(ConfigCustom.ShowroomPositions[k].coords.x, ConfigCustom.ShowroomPositions[k].coords.y, ConfigCustom.ShowroomPositions[k].coords.z, 3.0, 0, 70))
            CustomModelLoaded =  false
            Wait(100)
            local model = GetHashKey(showroomVehicle)
            local waiting = 0
            RequestModel(model)
            while not HasModelLoaded(model) do
                waiting = waiting + 100
                Citizen.Wait(100)
                if waiting > 9000 then
                    break
                end
            end
            local veh = CreateVehicle(model, ConfigCustom.ShowroomPositions[k].coords.x, ConfigCustom.ShowroomPositions[k].coords.y, ConfigCustom.ShowroomPositions[k].coords.z, false, false)
            SetModelAsNoLongerNeeded(model)
            SetVehicleOnGroundProperly(veh)
            SetEntityInvincible(veh,true)
            SetEntityHeading(veh, ConfigCustom.ShowroomPositions[k].coords.h)
            SetVehicleDoorsLocked(veh, 2)

            FreezeEntityPosition(veh, true)
            SetVehicleNumberPlateText(veh, k .. "CARSALE")
            CustomModelLoaded =  true
            ConfigCustom.ShowroomPositions[k].vehicle = showroomVehicle
        end
    end
end)

RegisterNetEvent('lcrp-vehicleshop:client:ConfirmVehicle')
AddEventHandler('lcrp-vehicleshop:client:ConfirmVehicle', function(Showroom, plate)
    scCore.Functions.SpawnVehicle(Showroom.vehicle, function(veh)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        exports['LegacyFuel']:SetFuel(veh, 100)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityAsMissionEntity(veh, true, true)
        SetEntityHeading(veh, ConfigCustom.VehicleBuyLocation.h)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        TriggerServerEvent("vehicletuning:server:SaveVehicleProps", scCore.Functions.GetVehicleProperties(veh))
    end, ConfigCustom.VehicleBuyLocation, false)
end)

RegisterNetEvent('lcrp-vehicleshop:client:TestDrive')
AddEventHandler('lcrp-vehicleshop:client:TestDrive', function(closestVeh)
    local plate = "TEST"..math.random(1111, 9999)
    if closestVeh ~= 0 then
        scCore.Functions.SpawnVehicle(ConfigCustom.ShowroomPositions[closestVeh].vehicle, function(veh)
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
            exports['LegacyFuel']:SetFuel(veh, 100)
            SetVehicleNumberPlateText(veh, plate)
            SetEntityAsMissionEntity(veh, true, true)
            SetEntityHeading(veh, ConfigCustom.VehicleBuyLocation.h)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
            TriggerServerEvent("vehicletuning:server:SaveVehicleProps", scCore.Functions.GetVehicleProperties(veh))
            testritveh = veh
        end, ConfigCustom.VehicleBuyLocation, false)
    end
end)

RegisterNetEvent("lcrp-vehicleshop:client:VehMenu")
AddEventHandler("lcrp-vehicleshop:client:VehMenu", function()
    if CustomVehicleShop.opened then
        CloseCustomCreator()
    else
        OpenCustomCreator()
    end
end)

RegisterNetEvent("lcrp-vehicleshop:client:ReturnVehicle")
AddEventHandler("lcrp-vehicleshop:client:ReturnVehicle", function()
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped)

    if veh == testritveh then
        testritveh = 0
        scCore.Functions.DeleteVehicle(veh)
        scCore.Notification("Vehicle returned")
    else
        scCore.Notification("This is not test vehicle!", "error")
    end
end)

RegisterNetEvent('lcrp-vehicleshop:client:SellCustomVehicle')
AddEventHandler('lcrp-vehicleshop:client:SellCustomVehicle', function(TargetId, vehParameter)
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local player, distance = GetClosestPlayer()
    local src = GetPlayerServerId(PlayerId())
    if player ~= -1 and distance < 2.5 then
        local VehicleDist = GetDistanceBetweenCoords(pos, ConfigCustom.ShowroomPositions[vehParameter].coords.x, ConfigCustom.ShowroomPositions[vehParameter].coords.y, ConfigCustom.ShowroomPositions[vehParameter].coords.z)
        if VehicleDist < 2.5 then
            TriggerServerEvent('lcrp-vehicleshop:server:SellCustomVehicle', TargetId, vehParameter, src)
        else
            scCore.Notification("You are not near the vehicle!", "error")
        end
    else
        scCore.Notification("No players close!", "error")
    end
end)

function GetClosestPlayer()
    local closestPlayers = scCore.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

RegisterNetEvent('lcrp-vehicleshop:client:SetVehicleBuying')
AddEventHandler('lcrp-vehicleshop:client:SetVehicleBuying', function(slot, source)
    ConfigCustom.ShowroomPositions[slot].buying = true
    ConfigCustom.ShowroomPositions[slot].vendor = source
    SetTimeout((60 * 1000) * 5, function()
        ConfigCustom.ShowroomPositions[slot].buying = false
        ConfigCustom.ShowroomPositions[slot].vendor = nil
    end)
end)

function isCustomValidMenu(menu)
    local retval = false
    for k, v in pairs(CustomVehicleShop.menu["vehicles"].buttons) do
        if menu == v.menu then
            retval = true
        end
    end
    return retval
end

function drawMenuButton(button,x,y,selected)
	local menu = CustomVehicleShop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0, 0, 0,220)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuInfo(text)
	local menu = CustomVehicleShop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,250)
	DrawText(0.255, 0.254)
end

function drawMenuRight(txt,x,y,selected)
	local menu = CustomVehicleShop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.2, 0.2)
	--SetTextRightJustify(1)
	if selected then
		SetTextColour(0,0,0, 255)
	else
		SetTextColour(255, 255, 255, 255)
		
	end
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 + 0.025, y - menu.height/3 + 0.0002)

	if selected then
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,255, 255, 255,250)
	else
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,0, 0, 0,250) 
	end
end

function drawMenuTitle(txt,x,y)
	local menu = CustomVehicleShop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)

	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,250)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function CustomButtonSelected(button)
	local this = CustomVehicleShop.currentmenu
    local btn = button.name
    
	if this == "main" then
		if btn == "Vehicles" then
			OpenCustomMenu('coupes')
		end
	end
end

function OpenCustomMenu(menu)
    CustomVehicleShop.lastmenu = CustomVehicleShop.currentmenu
    fakecar = {model = '', car = nil}
	if menu == "vehicles" then
		CustomVehicleShop.lastmenu = "main"
	end
	CustomVehicleShop.menu.from = 1
	CustomVehicleShop.menu.to = 10
	CustomVehicleShop.selectedbutton = 0
	CustomVehicleShop.currentmenu = menu
end

function BackCustom()
	if backlock then
		return
	end
	backlock = true
	if CustomVehicleShop.currentmenu == "main" then
		CloseCustomCreator()
	elseif isCustomValidMenu(CustomVehicleShop.currentmenu) then
		OpenCustomMenu(CustomVehicleShop.lastmenu)
	else
		OpenCustomMenu(CustomVehicleShop.lastmenu)
	end
end

function CloseCustomCreator(name, veh, price, financed)
	Citizen.CreateThread(function()
		local ped = GetPlayerPed(-1)
		CustomVehicleShop.opened = false
		CustomVehicleShop.menu.from = 1
        CustomVehicleShop.menu.to = 10
	end)
end


function OpenCustomCreator()
	CustomVehicleShop.currentmenu = "main"
	CustomVehicleShop.opened = true
    CustomVehicleShop.selectedbutton = 0
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 116.27, -150.23, 60.74) < 10 then
        isOnVip = true
    else
        isOnVip = false
    end
end

function close()
    Menu.hidden = true
end

function MenuPoliceOutfits()
    ped = GetPlayerPed(-1);
    MenuTitle = "Car Dealer Outfits"
    ClearMenu()
    Menu.addButton("Outfits", "OutfitList", nil)
    Menu.addButton("Close Menu", "close", nil)
end

function OutfitList()
    ped = GetPlayerPed(-1);
    MenuTitle = "Car Dealer Outfits:"
    ClearMenu()

    Menu.addButton("[0] Civilian Clothes", "SelectOutfit", "civilian")
    Menu.addButton("[1] Security", "SelectOutfit", "security")
    Menu.addButton("[2] Car Salesman", "SelectOutfit", "salesman")
    Menu.addButton("[3] Car Salesman 2", "SelectOutfit", "salesman2")
   
    Menu.addButton("Back", "MenuPoliceOutfits")
end

RegisterNetEvent('lcrp-vehicleshop:client:selectedOutfit')
AddEventHandler('lcrp-vehicleshop:client:selectedOutfit', function(outfit)    
    if outfit == "civilian" then
        TriggerServerEvent('lcrp-clothes:get_character_current')
        TriggerServerEvent("lcrp-clothes:retrieve_tats")
    end

    if outfit == "security" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 50, texture = 2},
                ["arms"]        = { item = 6, texture = 0}, 
                ["t-shirt"]     = { item = 23, texture = 1},  
                ["torso2"]      = { item = 72, texture = 2},  
                ["shoes"]       = { item = 36, texture = 3},
                ["glass"]       = { item = 17, texture = 2},    
                ["ear"]       = { item = 0, texture = 0}, 
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "salesman" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 49, texture = 0},
                ["arms"]        = { item = 4, texture = 0}, 
                ["t-shirt"]     = { item = 4, texture = 1},  
                ["torso2"]      = { item = 23, texture = 2},  
                ["shoes"]       = { item = 20, texture = 3},  
                ["glass"]         = { item = 17, texture = 2},  
                ["accessory"]         = { item = 24, texture = 2},  
                ["ear"]       = { item = -1, texture = 0}
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end

    if outfit == "salesman2" then
        ClothingDataName = {
            outfitData = {
                ["pants"]       = { item = 49, texture = 0},
                ["arms"]        = { item = 4, texture = 0}, 
                ["t-shirt"]     = { item = 10, texture = 2},  
                ["torso2"]      = { item = 24, texture = 8},  
                ["shoes"]       = { item = 20, texture = 3},  
                ["glass"]         = { item = 17, texture = 2},   
                ["ear"]       = { item = -1, texture = 0}
            }
        }
        TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)
    end


    TriggerEvent('InteractSound_CL:PlayOnOne','Clothes1', 0.6)
    closeMenuFull()
end)

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
	exports["lcrp-interact"]:AddBoxZone("cardealerDuty", vector3(148.5122, -155.5411, 60.491), 1.6, 4.2, {
		name="cardealerDuty",
        heading=244,
        minZ=59.44,
        maxZ=61.84
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
	job = {"cardealer"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("cardealerClothing", vector3(148.5, -150.25, 60.49), 4.0, 2, {
        name="cardealerClothing",
        heading=69,
        minZ=59.49,
        maxZ=62.09}, {
        options = {
            {
                event = "",
                icon = "",
                label = "Car Dealer Outfits",
                duty = true,
            },
            {
                event = "raid-clothes:OpenClothesMenu",
                icon = "fad fa-tshirt",
                label = "Clothing Menu",
                duty = true,
            },
            {
                event = "lcrp-vehicleshop:client:selectedOutfit",
                icon = "fad fa-tshirt",
                label = "Civilian",
                duty = true,
                parameters = "civilian"
            },
            {
                event = "lcrp-vehicleshop:client:selectedOutfit",
                icon = "fad fa-tshirt",
                label = "Security",
                duty = true,
                parameters = "security"
            },
            {
                event = "lcrp-vehicleshop:client:selectedOutfit",
                icon = "fad fa-tshirt",
                label = "Car Salesman",
                duty = true,
                parameters = "salesman"
            },
            {
                event = "lcrp-vehicleshop:client:selectedOutfit",
                icon = "fad fa-tshirt",
                label = "Car Salesman 2",
                duty = true,
                parameters = "salesman2"
            },
        },
    job = {"cardealer"}, distance = 2.5 })

    exports["lcrp-interact"]:AddBoxZone("cardealerBoss", vector3(117.29, -128.92, 60.49), 3, 2, {
        name="cardealerBoss",
        heading=70,
        minZ=60.29,
        maxZ=60.89 }, {
        options = {
            {
                event = "police:client:BossActions",
                icon = "fad fa-user-secret",
                label = "Boss Actions",
                duty = true,
            },
        },
    job = {"cardealer"}, distance = 2.5 })

    exports["lcrp-interact"]:AddBoxZone("cardealerReturnVeh", vector3(146.97, -127.44, 54.83), 10.0, 12.8, {
        name="cardealerReturnVeh",
        heading=70,
        minZ=53.73,
        maxZ=58.93 }, {
        options = {
            {
                event = "lcrp-vehicleshop:client:ReturnVehicle",
                icon = "fad fa-undo",
                label = "Return Vehicle",
                duty = true,
                onlyInVeh = true,
            },
        },
    job = {"cardealer"}, distance = 2.5 })

    for k,v in pairs(ConfigCustom.ShowroomPositions) do
        exports["lcrp-interact"]:AddBoxZone("ShowroomPositions"..k, vector3(ConfigCustom.ShowroomPositions[k].coords.x, ConfigCustom.ShowroomPositions[k].coords.y, ConfigCustom.ShowroomPositions[k].coords.z), 6.0, 6.0, {
            name="ShowroomPositions"..k,
            heading=70,
            minZ=ConfigCustom.ShowroomPositions[k].coords.minZ,
            maxZ=ConfigCustom.ShowroomPositions[k].coords.maxZ }, {
            options = {
                {
                    event = "lcrp-vehicleshop:client:VehMenu",
                    icon = "fad fa-car-alt",
                    label = "Change vehicle",
                    duty = true,
                },
                {
                    event = "lcrp-vehicleshop:client:TestDrive",
                    icon = "fad fa-car-alt",
                    label = "Test drive",
                    duty = true,
                    parameters = k,
                },
                {
                    event = "lcrp-vehicleshop:client:OfferVehicle",
                    icon = "fad fa-car-alt",
                    label = "Sell Vehicle",
                    duty = true,
                    parameters = k,
                },
            },
        job = {"cardealer"}, distance = 2.5 })
    end
end)