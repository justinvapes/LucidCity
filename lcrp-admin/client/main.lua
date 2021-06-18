scCore = nil

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

local PlayerBlips = {}
scAdmin = {}
scAdmin.Functions = {}
in_noclip_mode = false

local animalSkin = {"a_c_boar", "a_c_cat_01", "a_c_chickenhawk", "a_c_chimp", "a_c_chop", "a_c_cormorant", "a_c_cow", "a_c_coyote", "a_c_crow", "a_c_deer", "a_c_dolphin", "a_c_fish", "a_c_hen", "a_c_humpback", "a_c_husky", "a_c_killerwhale", "a_c_mtlion", "a_c_pig", "a_c_pigeon", "a_c_poodle", "a_c_rabbit_01", "a_c_rat", "a_c_retriever", "a_c_rhesus", "a_c_rottweiler", "a_c_seagull", "a_c_sharkhammer", "a_c_sharktiger", "a_c_shepherd", "a_c_westy"}

scAdmin.Functions.DrawText3D = function(x, y, z, text, lines)
    -- Amount of lines default 1
    if lines == nil then
        lines = 1
    end

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
    DrawRect(0.0, 0.0+0.0125 * lines, 0.017+ factor, 0.03 * lines, 0, 0, 0, 75)
    ClearDrawOrigin()
end



GetPlayersFromCoords = function(coords, distance)
    local players = testing
    local closePlayers = {}

    if coords == nil then
		coords = GetEntityCoords(GetPlayerPed(-1))
    end
    if distance == nil then
        distance = 50.0
    end
    for _, player in pairs(players) do
		local target = GetPlayerPed(GetPlayerFromServerId(player.serverid))
		local targetCoords = GetEntityCoords(target)
		local targetdistance = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)
        if targetdistance <= distance then
            if targetdistance == 0 and player.serverid == GetPlayerServerId(PlayerId()) then
                table.insert(closePlayers, player)
            elseif targetdistance ~= 0 then
                table.insert(closePlayers, player)
            end
		end
    end
    
    return closePlayers
end

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        Citizen.Wait(1000)
    
        scCore.TriggerServerCallback('lcrp-scoreboard:server:CheckPermissions', function(UserGroup)
            myPermissionRank = UserGroup
        end)
    end
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("lcrp-admin:server:loadPermissions")
    TriggerServerEvent("lcrp-admin:server:BanInfo", source)
    TriggerServerEvent("sk1nnygod-autorestart")

    scCore.TriggerServerCallback('lcrp-scoreboard:server:CheckPermissions', function(UserGroup)
		myPermissionRank = UserGroup
        TriggerEvent("lcrp-binds:client:LoadKeybinds", myPermissionRank)
	end)
end)

RegisterNetEvent('scCore:Client:OnPermissionUpdate')
AddEventHandler('scCore:Client:OnPermissionUpdate', function(UserGroup)
    myPermissionRank = UserGroup
end)

AvailableWeatherTypes = {
    {label = "Extra Sunny",         weather = 'EXTRASUNNY',}, 
    {label = "Clear",               weather = 'CLEAR',}, 
    {label = "Neutral",             weather = 'NEUTRAL',}, 
    {label = "Smog",                weather = 'SMOG',}, 
    {label = "Foggy",               weather = 'FOGGY',}, 
    {label = "Overcast",            weather = 'OVERCAST',}, 
    {label = "Clouds",              weather = 'CLOUDS',}, 
    {label = "Clearing",            weather = 'CLEARING',}, 
    {label = "Rain",                weather = 'RAIN',}, 
    {label = "Thunder",             weather = 'THUNDER',}, 
    {label = "Snow",                weather = 'SNOW',}, 
    {label = "Blizzard",            weather = 'BLIZZARD',}, 
    {label = "Snowlight",           weather = 'SNOWLIGHT',}, 
    {label = "XMAS (Heavy Snow)",   weather = 'XMAS',}, 
    {label = "Halloween (Scarry)",  weather = 'HALLOWEEN',},
}

BanTimes = {
    [1] = 3600,
    [2] = 21600,
    [3] = 43200,
    [4] = 86400,
    [5] = 259200,
    [6] = 604800,
    [7] = 2678400,
    [8] = 8035200,
    [9] = 16070400,
    [10] = 32140800,
    [11] = 99999999999,
}

ServerTimes = {
    [1] = {hour = 0, minute = 0},
    [2] = {hour = 1, minute = 0},
    [3] = {hour = 2, minute = 0},
    [4] = {hour = 3, minute = 0},
    [5] = {hour = 4, minute = 0},
    [6] = {hour = 5, minute = 0},
    [7] = {hour = 6, minute = 0},
    [8] = {hour = 7, minute = 0},
    [9] = {hour = 8, minute = 0},
    [10] = {hour = 9, minute = 0},
    [11] = {hour = 10, minute = 0},
    [12] = {hour = 11, minute = 0},
    [13] = {hour = 12, minute = 0},
    [14] = {hour = 13, minute = 0},
    [15] = {hour = 14, minute = 0},
    [16] = {hour = 15, minute = 0},
    [17] = {hour = 16, minute = 0},
    [18] = {hour = 17, minute = 0},
    [19] = {hour = 18, minute = 0},
    [20] = {hour = 19, minute = 0},
    [21] = {hour = 20, minute = 0},
    [22] = {hour = 21, minute = 0},
    [23] = {hour = 22, minute = 0},
    [24] = {hour = 23, minute = 0},
}

PermissionLevels = {
    [1] = {rank = "user", label = "User"},
    [2] = {rank = "helper", label = "Helper"},
    [3] = {rank = "mod", label = "Moderator"},
    [4] = {rank = "admin", label = "Admin"},
    [5] = {rank = "god", label = "God"},
}

isNoclip = false
isFreeze = false
isSpectating = false
showNames = false
showBlips = false
isInvisible = false
deleteLazer = false
hasGodmode = false

-- SPECTATE --
local InSpectatorMode	= false
local TargetSpectate	= nil
local LastPosition		= nil
local polarAngleDeg		= 0;
local azimuthAngleDeg	= 90;
local radius			= -3.5;
local cam 				= nil
local PlayerDate		= {}
local ShowInfos			= false
local group

myPermissionRank = "user"

local DealersData = {}


playerList = nil

function getPlayers()
    local players = {}

    TriggerServerEvent('lcrp-admin:server:GetPlayers')
    while playerList == nil do
        Citizen.Wait(0)
    end

    for k, player in pairs(playerList) do
        local playerId = player.source
        players[k] = {
            ['ped'] = -1,
            ['name'] = player.name,
            ['id'] = playerId,
            ['serverid'] = playerId,
        }
    end
    table.sort(players, function(a, b)
        return a.serverid < b.serverid
    end)
    
    return players
end

function changeSkin(who, skin)

	local modelName = skin
    local modelHash = (GetHashKey(modelName))

    RequestModel(modelHash) 
    
    while not HasModelLoaded(modelHash) do
        RequestModel(modelHash)      
        Citizen.Wait(0)
    end

    SetPlayerModel(PlayerId(), modelHash)    
    SetModelAsNoLongerNeeded(modelHash)

end

RegisterNetEvent('lcrp-admin:client:getPlayers')
AddEventHandler('lcrp-admin:client:getPlayers', function(p)
    playerList = p
end)

RegisterNetEvent('lcrp-admin:client:openMenu')
AddEventHandler('lcrp-admin:client:openMenu', function()
    if myPermissionRank == "admin" or myPermissionRank == "god" or myPermissionRank == "mod" then
        testing = getPlayers()
        WarMenu.OpenMenu('admin')
    else
        scCore.Notification("Nice try, but you're not admin", "error")
    end
end)

local currentPlayerMenu = nil
local currentPlayer = 0

Citizen.CreateThread(function()
    local menus = {
        "admin",
        "playerMan",
        "serverMan",
        currentPlayer,
        "playerOptions",
        "teleportOptions",
        "permissionOptions",
        "weatherOptions",
        "adminOptions",
        "adminOpt",
        "vehicleMenu",
        "selfOptions",
        "changeSkin",
        "dealerManagement",
        "allDealers",
        "createDealer",
    }

    local bans = {
        "1 hour",
        "6 hour",
        "12 hour",
        "1 day",
        "3 days",
        "1 week",
        "1 month",
        "3 months",
        "6 months",
        "1 year",
        "Permanent",
        "Myself",
    }

    local times = {
        "00:00",
        "01:00",
        "02:00",
        "03:00",
        "04:00",
        "05:00",
        "06:00",
        "07:00",
        "08:00",
        "09:00",
        "10:00",
        "11:00",
        "12:00",
        "13:00",
        "14:00",
        "15:00",
        "16:00",
        "17:00",
        "18:00",
        "19:00",
        "20:00",
        "21:00",
        "22:00",
        "23:00",
    }

    local perms = {
        "User",
        "Helper",
        "Moderator",
        "Admin",
        "God"
    }

    
    local currentBanIndex = 1
    local selectedBanIndex = 1
    
    local currentMinTimeIndex = 1
    local selectedMinTimeIndex = 1

    local currentMaxTimeIndex = 1
    local selectedMaxTimeIndex = 1

    local currentPermIndex = 1
    local selectedPermIndex = 1

    WarMenu.CreateMenu('admin', 'Admin Menu')
    WarMenu.CreateSubMenu('playerMan', 'admin')
    WarMenu.CreateSubMenu('serverMan', 'admin')
    WarMenu.CreateSubMenu('adminOpt', 'admin')
    WarMenu.CreateSubMenu('selfOptions', 'adminOpt')
    WarMenu.CreateSubMenu('changeSkin', 'selfOptions')
    WarMenu.CreateSubMenu('vehicleMenu', 'admin')

    WarMenu.CreateSubMenu('weatherOptions', 'serverMan')
    WarMenu.CreateSubMenu('dealerManagement', 'serverMan')
    WarMenu.CreateSubMenu('allDealers', 'dealerManagement')
    WarMenu.CreateSubMenu('createDealer', 'dealerManagement')
    
    for k, v in pairs(menus) do
        WarMenu.SetMenuX(v, 0.71)
        WarMenu.SetMenuY(v, 0.017)
        WarMenu.SetMenuWidth(v, 0.23)
        WarMenu.SetTitleColor(v, 218, 74, 70, 255)
        WarMenu.SetTitleBackgroundColor(v, 0, 0, 0, 111)
    end

    while true do
        if WarMenu.IsMenuOpened('admin') then
            WarMenu.MenuButton('Player', 'adminOpt')
            WarMenu.MenuButton('Server', 'serverMan')
            WarMenu.MenuButton('Vehicle Functions', 'vehicleMenu')
            WarMenu.MenuButton('Online Players', 'playerMan')

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('adminOpt') then
            WarMenu.MenuButton('Functions', 'selfOptions')
            WarMenu.CheckBox("Show Player Names", showNames, function(checked) showNames = checked end)
            if WarMenu.CheckBox("Show Player Blips", showBlips, function(checked) showBlips = checked end) then
                toggleBlips()
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('selfOptions') then
            if WarMenu.CheckBox("Noclip", isNoclip, function(checked) isNoclip = checked end) then
                local target = PlayerId()
                local targetId = GetPlayerServerId(target)
                TriggerServerEvent("lcrp-admin:server:togglePlayerNoclip", targetId)
            end
            if WarMenu.Button('Revive') then
                local target = PlayerId()
                local targetId = GetPlayerServerId(target)
                TriggerServerEvent('lcrp-admin:server:revivePlayer', targetId)
            end
            if WarMenu.CheckBox("Invisible", isInvisible, function(checked) isInvisible = checked end) then
                local myPed = GetPlayerPed(-1)
                
                if isInvisible then
                    SetEntityVisible(myPed, false, false)
                else
                    SetEntityVisible(myPed, true, false)
                end
            end
            if WarMenu.CheckBox("Godmode", hasGodmode, function(checked) hasGodmode = checked end) then
                local myPlayer = PlayerId()
                
                SetPlayerInvincible(myPlayer, hasGodmode)
            end
            if WarMenu.CheckBox("Delete Lazer", deleteLazer, function(checked) deleteLazer = checked end) then
            end
            if WarMenu.Button("Open Barber Menu") then
                local target = PlayerId()
                local targetId = GetPlayerServerId(target)
                TriggerServerEvent('lcrp-admin:server:OpenBarberShopMenu', targetId)
            end
            if WarMenu.Button("Open Clothing Menu") then
                local target = PlayerId()
                local targetId = GetPlayerServerId(target)
                TriggerServerEvent('lcrp-admin:server:OpenSkinMenu', targetId)
            end
            if WarMenu.Button("Open Tattoo Menu") then
                local target = PlayerId()
                local targetId = GetPlayerServerId(target)
                TriggerServerEvent('lcrp-admin:server:OpenTattooMenu', targetId)
            end
            if myPermissionRank == "god" then
                WarMenu.MenuButton('Change Ped Skin', 'changeSkin')
            end
            
            WarMenu.Display()

        elseif WarMenu.IsMenuOpened("changeSkin") then
            local target = PlayerId()
		
			if WarMenu.Button(animalSkin[1]) then

				changeSkin(target, animalSkin[1])

			elseif WarMenu.Button(animalSkin[2]) then

				changeSkin(target, animalSkin[2])

			elseif WarMenu.Button(animalSkin[3]) then

				changeSkin(target, animalSkin[3])

			elseif WarMenu.Button(animalSkin[4]) then

				changeSkin(target, animalSkin[4])

			elseif WarMenu.Button(animalSkin[5]) then

				changeSkin(target, animalSkin[5])

			elseif WarMenu.Button(animalSkin[6]) then

				changeSkin(target, animalSkin[6])

			elseif WarMenu.Button(animalSkin[7]) then

				changeSkin(target, animalSkin[7])

			elseif WarMenu.Button(animalSkin[8]) then

				changeSkin(target, animalSkin[8])

			elseif WarMenu.Button(animalSkin[9]) then

				changeSkin(target, animalSkin[9])

			elseif WarMenu.Button(animalSkin[10]) then

				changeSkin(target, animalSkin[10])

			elseif WarMenu.Button(animalSkin[11]) then

				changeSkin(target, animalSkin[11])

			elseif WarMenu.Button(animalSkin[12]) then

				changeSkin(target, animalSkin[12])

			elseif WarMenu.Button(animalSkin[13]) then

				changeSkin(target, animalSkin[13])

			elseif WarMenu.Button(animalSkin[14]) then

				changeSkin(target, animalSkin[14])

			elseif WarMenu.Button(animalSkin[15]) then

				changeSkin(target, animalSkin[15])

			elseif WarMenu.Button(animalSkin[16]) then

				changeSkin(target, animalSkin[16])

			elseif WarMenu.Button(animalSkin[17]) then

				changeSkin(target, animalSkin[17])

			elseif WarMenu.Button(animalSkin[18]) then

				changeSkin(target, animalSkin[18])

			elseif WarMenu.Button(animalSkin[19]) then

				changeSkin(target, animalSkin[19])

			elseif WarMenu.Button(animalSkin[20]) then

				changeSkin(target, animalSkin[20])

			elseif WarMenu.Button(animalSkin[21]) then

				changeSkin(target, animalSkin[21])

			elseif WarMenu.Button(animalSkin[22]) then

				changeSkin(target, animalSkin[22])

			elseif WarMenu.Button(animalSkin[23]) then

				changeSkin(target, animalSkin[23])

			elseif WarMenu.Button(animalSkin[24]) then

				changeSkin(target, animalSkin[24])

			elseif WarMenu.Button(animalSkin[25]) then

				changeSkin(target, animalSkin[25])

			elseif WarMenu.Button(animalSkin[26]) then

				changeSkin(target, animalSkin[26])

			elseif WarMenu.Button(animalSkin[27]) then

				changeSkin(target, animalSkin[27])

			elseif WarMenu.Button(animalSkin[28]) then

				changeSkin(target, animalSkin[28])

			elseif WarMenu.Button(animalSkin[29]) then

				changeSkin(target, animalSkin[29])

			elseif WarMenu.Button(animalSkin[30]) then

				changeSkin(target, animalSkin[30])

			end
			
			WarMenu.Display()



        elseif WarMenu.IsMenuOpened('playerMan') then
            local players = testing

            for k, v in pairs(players) do
                if v["name"] == nil then v["name"] = "INVALID NAME. BAN THIS USER" end
                WarMenu.CreateSubMenu(v["id"], 'playerMan', v["serverid"].." | "..v["name"])
            end
            if WarMenu.MenuButton('#'..GetPlayerServerId(PlayerId()).." | "..GetPlayerName(PlayerId()), PlayerId()) then
                currentPlayer = v["id"]
                if WarMenu.CreateSubMenu('playerOptions', currentPlayer) then
                    currentPlayerMenu = 'playerOptions'
                elseif WarMenu.CreateSubMenu('teleportOptions', currentPlayer) then
                    currentPlayerMenu = 'teleportOptions'
                elseif WarMenu.CreateSubMenu('adminOptions', currentPlayer) then
                    currentPlayerMenu = 'adminOptions'
                end

                if myPermissionRank == "god" then
                    if WarMenu.CreateSubMenu('permissionOptions', currentPlayer) then
                        currentPlayerMenu = 'permissionOptions'
                    end
                end
            end
            for k, v in pairs(players) do
                if v["id"] ~= PlayerId() then
                    if WarMenu.MenuButton('#'..v["serverid"].." | "..v["name"], v["id"]) then
                        currentPlayer = v["id"]
                        if WarMenu.CreateSubMenu('playerOptions', currentPlayer) then
                            currentPlayerMenu = 'playerOptions'
                        elseif WarMenu.CreateSubMenu('teleportOptions', currentPlayer) then
                            currentPlayerMenu = 'teleportOptions'
                        elseif WarMenu.CreateSubMenu('adminOptions', currentPlayer) then
                            currentPlayerMenu = 'adminOptions'
                        end
                    end
                end
            end

            if myPermissionRank == "god" then
                if WarMenu.CreateSubMenu('permissionOptions', currentPlayer) then
                    currentPlayerMenu = 'permissionOptions'
                end
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('serverMan') then
            WarMenu.MenuButton('Weather Options', 'weatherOptions')
            WarMenu.MenuButton('Dealer Management', 'dealerManagement')
            if WarMenu.ComboBox('Server time', times, currentBanIndex, selectedBanIndex, function(currentIndex, selectedIndex)
                currentBanIndex = currentIndex
                selectedBanIndex = selectedIndex
            end) then
                local time = ServerTimes[currentBanIndex]
                TriggerServerEvent("lcrp-weather:server:setTime", time.hour, time.minute)
            end
            
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('vehicleMenu') then

            if WarMenu.Button('Spawn vehicle') then
                local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
                local ModelName = scCore.KeyboardInput("Enter Vehicle Spawn Name", "", 100)
        
                if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then
                    RequestModel(ModelName)
                    while not HasModelLoaded(ModelName) do
                        Citizen.Wait(0)
                    end
        
                    spawnedvehicle = CreateVehicle(GetHashKey(ModelName), x, y, z, GetEntityHeading(PlayerPedId())+90, 1, 0)
                
                    TaskWarpPedIntoVehicle(GetPlayerPed(-1), spawnedvehicle, -1)
                    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(spawnedvehicle))
                else
                    scCore.Notification("Vehicle model is invalid!", "error")
                end
            end

            if WarMenu.Button('Fix vehicle') then
                TriggerEvent('iens:repaira')
                TriggerEvent('vehiclemod:client:fixEverything')
            end

            if WarMenu.Button('Delete vehicle') then
                DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
            end
            
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened(currentPlayer) then
            WarMenu.MenuButton('Player Options', 'playerOptions')
            WarMenu.MenuButton('Teleport Options', 'teleportOptions')
            WarMenu.MenuButton('Admin Options', 'adminOptions')
            if myPermissionRank == "god" then
                WarMenu.MenuButton('Permission Options', 'permissionOptions')
            end
            
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('playerOptions') then
            if WarMenu.MenuButton('Kill', currentPlayer) then
                TriggerServerEvent("lcrp-admin:server:killPlayer", GetPlayerServerId(currentPlayer))
            end
            if WarMenu.MenuButton('Revive', currentPlayer) then
                local target = currentPlayer
                TriggerServerEvent('lcrp-admin:server:revivePlayer', target)
            end
            if WarMenu.CheckBox("Noclip", isNoclip, function(checked) isNoclip = checked end) then
                local target = currentPlayer
                TriggerServerEvent("lcrp-admin:server:togglePlayerNoclip", target)
            end
            if WarMenu.CheckBox("Freeze", isFreeze, function(checked) isFreeze = checked end) then
                local target = currentPlayer
                TriggerServerEvent("lcrp-admin:server:Freeze", target, isFreeze)
            end
            if WarMenu.CheckBox("Spectate", isSpectating, function(checked) isSpectating = checked end) then
                local targetID = currentPlayer
                local plyId = PlayerId()
                local myId = GetPlayerServerId(plyId)

                spectate(targetID, isSpectating)
            end
            if WarMenu.MenuButton("Open Inventory", currentPlayer) then
                local targetId = currentPlayer

                OpenTargetInventory(targetId)
            end
            if WarMenu.MenuButton("Eject from vehicle", currentPlayer) then
                local targetId = currentPlayer

                ClearPedTasksImmediately(GetPlayerPed(currentPlayer))
            end
            if WarMenu.MenuButton("Open Clothing Menu", currentPlayer) then
                local targetId = currentPlayer

                TriggerServerEvent('lcrp-admin:server:OpenSkinMenu', targetId)
            end
            if WarMenu.MenuButton("Open Barber Menu", currentPlayer) then
                local targetId = currentPlayer

                TriggerServerEvent('lcrp-admin:server:OpenBarberShopMenu', targetId)
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('teleportOptions') then
            if WarMenu.MenuButton('Goto', currentPlayer) then
                local othersource = currentPlayer
                TriggerServerEvent('lcrp-admin:server:startPlayerTp', othersource)
            end
            if WarMenu.MenuButton('Bring', currentPlayer) then
                local othersource = currentPlayer
                TriggerServerEvent('lcrp-admin:server:startBringTp', othersource)
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('permissionOptions') then
            if WarMenu.ComboBox('Permission Group', perms, currentPermIndex, selectedPermIndex, function(currentIndex, selectedIndex)
                currentPermIndex = currentIndex
                selectedPermIndex = selectedIndex
            end) then
                local group = PermissionLevels[currentPermIndex]
                local target = currentPlayer
                TriggerServerEvent('lcrp-admin:server:setPermissions', target, group)

                scCore.Notification('Player ID #'..currentPlayer..' group has changed to '..group.label)
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('adminOptions') then
            if WarMenu.ComboBox('Ban time', bans, currentBanIndex, selectedBanIndex, function(currentIndex, selectedIndex)
                currentBanIndex = currentIndex
                selectedBanIndex = selectedIndex
            end) then
                local time = BanTimes[currentBanIndex]
                local index = currentBanIndex
                if index == 12 then
                    DisplayOnscreenKeyboard(1, "Time", "", "Time", "", "", "", 128 + 1)
                    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                        Citizen.Wait(7)
                    end
                    time = tonumber(GetOnscreenKeyboardResult())
                    time = time * 3600
                end
                DisplayOnscreenKeyboard(1, "Reason", "", "Reason", "", "", "", 128 + 1)
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait(7)
				end
                local reason = GetOnscreenKeyboardResult()
                if reason ~= nil and reason ~= "" and time ~= 0 then
                    local target = GetPlayerServerId(currentPlayer)
                    TriggerServerEvent("lcrp-admin:server:banPlayer", target, time, reason)
                end
            end
            if WarMenu.MenuButton('Warn Player', currentPlayer) then
                local targetId = GetPlayerServerId(currentPlayer)
                local warnReason = scCore.KeyboardInput("Enter Warn reason", "", 100)

                if warnReason ~= nil and warnReason ~= "" then
                    TriggerServerEvent("lcrp-admin:server:WarnPlayer", targetId, warnReason)
                else
                    scCore.Notification("Warn Reason is invalid!", "error")
                end
            end
            if WarMenu.MenuButton('Kick', currentPlayer) then
                DisplayOnscreenKeyboard(1, "Reason", "", "Reason", "", "", "", 128 + 1)
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait(7)
				end
                local reason = GetOnscreenKeyboardResult()
                if reason ~= nil and reason ~= "" then
                    local target = GetPlayerServerId(currentPlayer)
                    TriggerServerEvent("lcrp-admin:server:kickPlayer", target, reason)
                end
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('weatherOptions') then
            for k, v in pairs(AvailableWeatherTypes) do
                if WarMenu.MenuButton(AvailableWeatherTypes[k].label, 'weatherOptions') then
                    TriggerServerEvent('lcrp-weather:server:setWeather', AvailableWeatherTypes[k].weather)
                    scCore.Notification('Weather has changed to: '..AvailableWeatherTypes[k].label)
                end
            end
            
            WarMenu.Display()
        end

        Citizen.Wait(3)
    end
end)

function DrawInfos(text)
    SetTextColour(255, 255, 255, 255)   
    SetTextFont(4)                      
    SetTextScale(0.5, 0.5)              
    SetTextWrap(0.0, 1.0)               
    SetTextCentre(false)                
    SetTextDropshadow(0, 0, 0, 0, 255)  
    SetTextEdge(50, 0, 0, 0, 255)       
    SetTextOutline()                    
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.015, 0.71) 
end

function OpenTargetInventory(targetId)
    WarMenu.CloseMenu()

    TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", targetId)
end

Citizen.CreateThread(function()
    while true do
        sleep = 1000
        if showNames then
            sleep = 5
            local mycoords = GetEntityCoords(GetPlayerPed(-1))
            local data = GetPlayersFromCoords(mycoords, 50)
            for _, player in pairs(data) do
                local PlayerPed = GetPlayerPed(GetPlayerFromServerId(player.serverid))
                local PlayerName = player.name
                local PlayerCoords = GetEntityCoords(PlayerPed)
                scAdmin.Functions.DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 1.0, '['..player.serverid..'] '..PlayerName)
            end
        else
            sleep = 1000
        end

        Citizen.Wait(sleep)
    end
end)

function toggleBlips()
    if showBlips then
        Citizen.CreateThread(function()
            local Players = getPlayers()

            for k, v in pairs(Players) do
                local playerPed = v["ped"]
                if DoesEntityExist(playerPed) then
                    if PlayerBlips[k] == nil then
                        local playerName = v["name"]
            
                        PlayerBlips[k] = AddBlipForEntity(playerPed)
            
                        SetBlipSprite(PlayerBlips[k], 1)
                        SetBlipColour(PlayerBlips[k], 0)
                        SetBlipScale  (PlayerBlips[k], 0.75)
                        SetBlipAsShortRange(PlayerBlips[k], true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString('['..v["serverid"]..'] '..playerName)
                        EndTextCommandSetBlipName(PlayerBlips[k])
                    end
                else
                    if PlayerBlips[k] ~= nil then
                        RemoveBlip(PlayerBlips[k])
                        PlayerBlips[k] = nil
                    end
                end
            end

            Citizen.Wait(5000)
        end)
    else
        if next(PlayerBlips) ~= nil then
            for k, v in pairs(PlayerBlips) do
                RemoveBlip(PlayerBlips[k])
            end
            PlayerBlips = {}
        end
        Citizen.Wait(1000)
    end
end

Citizen.CreateThread(function()	
	while true do
		sleep = 1000

        if deleteLazer then
            sleep = 5
            local color = {r = 255, g = 255, b = 255, a = 200}
            local position = GetEntityCoords(GetPlayerPed(-1))
            local hit, coords, entity = RayCastGamePlayCamera(1000.0)
            
            -- If entity is found then verifie entity
            if hit and (IsEntityAVehicle(entity) or IsEntityAPed(entity) or IsEntityAnObject(entity)) then
                local entityCoord = GetEntityCoords(entity)
                local minimum, maximum = GetModelDimensions(GetEntityModel(entity))
                
                DrawEntityBoundingBox(entity, color)
                DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
                scAdmin.Functions.DrawText3D(entityCoord.x, entityCoord.y, entityCoord.z, "Obj: " .. entity .. " Model: " .. GetEntityModel(entity).. " \nPress [~g~E~s~] to delete this object!", 2)

                -- When E pressed then remove targeted entity
                if IsControlJustReleased(0, 38) then
                    -- Set as missionEntity so the object can be remove (Even map objects)
                    SetEntityAsMissionEntity(entity, true, true)
                    --SetEntityAsNoLongerNeeded(entity)
                    --RequestNetworkControl(entity)
                    DeleteEntity(entity)
                end
            -- Only draw of not center of map
            elseif coords.x ~= 0.0 and coords.y ~= 0.0 then
                -- Draws line to targeted position
                DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
                DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.1, 0.1, 0.1, color.r, color.g, color.b, color.a, false, true, 2, nil, nil, false)
            end
        else
            sleep = 1000
        end
        Citizen.Wait(sleep)
	end
end)

-- Draws boundingbox around the object with given color parms
function DrawEntityBoundingBox(entity, color)
    local model = GetEntityModel(entity)
    local min, max = GetModelDimensions(model)
    local rightVector, forwardVector, upVector, position = GetEntityMatrix(entity)

    -- Calculate size
    local dim = 
	{ 
		x = 0.5*(max.x - min.x), 
		y = 0.5*(max.y - min.y), 
		z = 0.5*(max.z - min.z)
	}

    local FUR = 
    {
		x = position.x + dim.y*rightVector.x + dim.x*forwardVector.x + dim.z*upVector.x, 
		y = position.y + dim.y*rightVector.y + dim.x*forwardVector.y + dim.z*upVector.y, 
		z = 0
    }

    local FUR_bool, FUR_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    FUR.z = FUR_z
    FUR.z = FUR.z + 2 * dim.z

    local BLL = 
    {
        x = position.x - dim.y*rightVector.x - dim.x*forwardVector.x - dim.z*upVector.x,
        y = position.y - dim.y*rightVector.y - dim.x*forwardVector.y - dim.z*upVector.y,
        z = 0
    }
    local BLL_bool, BLL_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    BLL.z = BLL_z

    -- DEBUG
    local edge1 = BLL
    local edge5 = FUR

    local edge2 = 
    {
        x = edge1.x + 2 * dim.y*rightVector.x,
        y = edge1.y + 2 * dim.y*rightVector.y,
        z = edge1.z + 2 * dim.y*rightVector.z
    }

    local edge3 = 
    {
        x = edge2.x + 2 * dim.z*upVector.x,
        y = edge2.y + 2 * dim.z*upVector.y,
        z = edge2.z + 2 * dim.z*upVector.z
    }

    local edge4 = 
    {
        x = edge1.x + 2 * dim.z*upVector.x,
        y = edge1.y + 2 * dim.z*upVector.y,
        z = edge1.z + 2 * dim.z*upVector.z
    }

    local edge6 = 
    {
        x = edge5.x - 2 * dim.y*rightVector.x,
        y = edge5.y - 2 * dim.y*rightVector.y,
        z = edge5.z - 2 * dim.y*rightVector.z
    }

    local edge7 = 
    {
        x = edge6.x - 2 * dim.z*upVector.x,
        y = edge6.y - 2 * dim.z*upVector.y,
        z = edge6.z - 2 * dim.z*upVector.z
    }

    local edge8 = 
    {
        x = edge5.x - 2 * dim.z*upVector.x,
        y = edge5.y - 2 * dim.z*upVector.y,
        z = edge5.z - 2 * dim.z*upVector.z
    }

    DrawLine(edge1.x, edge1.y, edge1.z, edge2.x, edge2.y, edge2.z, color.r, color.g, color.b, color.a)
    DrawLine(edge1.x, edge1.y, edge1.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
    DrawLine(edge2.x, edge2.y, edge2.z, edge3.x, edge3.y, edge3.z, color.r, color.g, color.b, color.a)
    DrawLine(edge3.x, edge3.y, edge3.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
    DrawLine(edge5.x, edge5.y, edge5.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
    DrawLine(edge5.x, edge5.y, edge5.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge6.x, edge6.y, edge6.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
    DrawLine(edge7.x, edge7.y, edge7.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge1.x, edge1.y, edge1.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
    DrawLine(edge2.x, edge2.y, edge2.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge3.x, edge3.y, edge3.z, edge5.x, edge5.y, edge5.z, color.r, color.g, color.b, color.a)
    DrawLine(edge4.x, edge4.y, edge4.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
end

-- Embed direction in rotation vector
function RotationToDirection(rotation)
	local adjustedRotation = 
	{ 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	local direction = 
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

-- Raycast function for "Admin Lazer"
function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination = 
	{ 
		x = cameraCoord.x + direction.x * distance, 
		y = cameraCoord.y + direction.y * distance, 
		z = cameraCoord.z + direction.z * distance 
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end

RegisterNetEvent('lcrp-admin:client:bringTp')
AddEventHandler('lcrp-admin:client:bringTp', function(coords)
    local ped = GetPlayerPed(-1)

    SetEntityCoords(ped, coords.x, coords.y, coords.z)
end)


RegisterNetEvent('lcrp-admin:client:playerTp')
AddEventHandler('lcrp-admin:client:playerTp', function(coords)
    SetEntityCoords(GetPlayerPed(-1), coords.x, coords.y, coords.z)
end)


RegisterNetEvent('lcrp-admin:client:Freeze')
AddEventHandler('lcrp-admin:client:Freeze', function(toggle)
    local ped = GetPlayerPed(-1)

    local veh = GetVehiclePedIsIn(ped)

    if veh ~= 0 then
        FreezeEntityPosition(ped, toggle)
        FreezeEntityPosition(veh, toggle)
    else
        FreezeEntityPosition(ped, toggle)
    end
end)

RegisterNetEvent('lcrp-admin:client:SendReport')
AddEventHandler('lcrp-admin:client:SendReport', function(name, src, msg)
    TriggerServerEvent('lcrp-admin:server:SendReport', name, src, msg)
end)

RegisterNetEvent('lcrp-admin:client:SendStaffChat')
AddEventHandler('lcrp-admin:client:SendStaffChat', function(name, msg)
    TriggerServerEvent('lcrp-admin:server:StaffChatMessage', name, msg)
end)

RegisterNetEvent('lcrp-admin:client:SaveCar')
AddEventHandler('lcrp-admin:client:SaveCar', function()
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped)

    if veh ~= nil and veh ~= 0 then
        local plate = GetVehicleNumberPlateText(veh)
        local props = scCore.Functions.GetVehicleProperties(veh)
        local hash = props.model
        if scCore.Shared.VehicleModels[hash] ~= nil and next(scCore.Shared.VehicleModels[hash]) ~= nil then
            TriggerServerEvent('lcrp-admin:server:SaveCar', props, scCore.Shared.VehicleModels[hash], GetHashKey(veh), plate)
        else
            scCore.Notification('You cannot put this vehicle in your garage', 'error')
        end
    else
        scCore.Notification('You are not in a vehicle', 'error')
    end
end)

function LoadPlayerModel(skin)
    RequestModel(skin)
    while not HasModelLoaded(skin) do
        
        Citizen.Wait(0)
    end
end


local blockedPeds = {
    "mp_m_freemode_01",
    "mp_f_freemode_01",
    "tony",
    "g_m_m_chigoon_02_m",
    "u_m_m_jesus_01",
    "a_m_y_stbla_m",
    "ig_terry_m",
    "a_m_m_ktown_m",
    "a_m_y_skater_m",
    "u_m_y_coop",
    "ig_car3guy1_m",
}

function isPedAllowedRandom(skin)
    local retval = false
    for k, v in pairs(blockedPeds) do
        if v ~= skin then
            retval = true
        end
    end
    return retval
end


RegisterNetEvent('lcrp-admin:client:SetSpeed')
AddEventHandler('lcrp-admin:client:SetSpeed', function(speed)
    local ped = PlayerId()
    if speed == "fast" then
        SetRunSprintMultiplierForPlayer(ped, 1.49)
        SetSwimMultiplierForPlayer(ped, 1.49)
    else
        SetRunSprintMultiplierForPlayer(ped, 1.0)
        SetSwimMultiplierForPlayer(ped, 1.0)
    end
end)

RegisterNetEvent('lcrp-weapons:client:SetWeaponAmmoManual')
AddEventHandler('lcrp-weapons:client:SetWeaponAmmoManual', function(weapon, ammo)
    local ped = GetPlayerPed(-1)
    if weapon ~= "current" then
        local weapon = weapon:upper()
        SetPedAmmo(ped, GetHashKey(weapon), ammo)
        scCore.Notification('+'..ammo..' Ammo for the '..scCore.Shared.Weapons[GetHashKey(weapon)]["label"], 'success')
    else
        local weapon = GetSelectedPedWeapon(ped)
        if weapon ~= nil then
            SetPedAmmo(ped, weapon, ammo)
            scCore.Notification('+'..ammo..' Ammo for the '..scCore.Shared.Weapons[weapon]["label"], 'success')
        else
            scCore.Notification('You don\'t have a weapon', 'error')
        end
    end
end)

RegisterNetEvent('lcrp-admin:client:GiveNuiFocus')
AddEventHandler('lcrp-admin:client:GiveNuiFocus', function(focus, mouse)
    SetNuiFocus(focus, mouse)
end)


-- SPECTATE FUNCTIONS

function polar3DToWorld3D(entityPosition, radius, polarAngleDeg, azimuthAngleDeg)
	local polarAngleRad   = polarAngleDeg   * math.pi / 180.0
	local azimuthAngleRad = azimuthAngleDeg * math.pi / 180.0

	local pos = {
		x = entityPosition.x + radius * (math.sin(azimuthAngleRad) * math.cos(polarAngleRad)),
		y = entityPosition.y - radius * (math.sin(azimuthAngleRad) * math.sin(polarAngleRad)),
		z = entityPosition.z - radius * math.cos(azimuthAngleRad)
	}

	return pos
end

function spectate(target, toggle)
    if toggle then
        local othersource = target
        TriggerServerEvent('lcrp-admin:server:startPlayerTp', othersource)
        scCore.TriggerServerCallback('lcrp-admin:spectate:getPlayerData', function(player)
            if not InSpectatorMode then
                LastPosition = GetEntityCoords(GetPlayerPed(-1))
            end

            local playerPed = GetPlayerPed(-1)

            SetEntityCollision(playerPed, false, false)
            SetEntityVisible(playerPed, false)

            PlayerData = player
            if ShowInfos then
                SendNUIMessage({
                    type = 'infos',
                    data = PlayerData
                })	
            end

            Citizen.CreateThread(function()

                if not DoesCamExist(cam) then
                    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
                end

                SetCamActive(cam, true)
                RenderScriptCams(true, false, 0, true, true)

                InSpectatorMode = true
                TargetSpectate  = target

            end)
        end, target)

    else
        if not InSpectatorMode then
            LastPosition = GetEntityCoords(GetPlayerPed(-1))
        end
        SetNuiFocus(false)
        resetNormalCamera()
    end

end

function resetNormalCamera()
	InSpectatorMode = false
	TargetSpectate  = nil
	local playerPed = GetPlayerPed(-1)

	SetCamActive(cam,  false)
	RenderScriptCams(false, false, 0, true, true)

	SetEntityCollision(playerPed, true, true)
	SetEntityVisible(playerPed, true)
	SetEntityCoords(playerPed, LastPosition.x, LastPosition.y, LastPosition.z)
end

function getPlayersList()

	local players = scCore.GetPlayers()
	local data = {}

	for i=1, #players, 1 do

		local _data = {
			id = GetPlayerServerId(players[i]),
			name = GetPlayerName(players[i])
		}
		table.insert(data, _data)
	end

	return data
end

Citizen.CreateThread(function()

  	while true do

		sleep = 500

        if InSpectatorMode then
            
            sleep = 5

            local targetPlayerId = GetPlayerFromServerId(TargetSpectate)
			local playerPed	  = GetPlayerPed(-1)
			local targetPed	  = GetPlayerPed(targetPlayerId)
            local coords	 = GetEntityCoords(targetPed)


			if IsControlPressed(2, 241) then
				radius = radius + 2.0;
			end

			if IsControlPressed(2, 242) then
				radius = radius - 2.0;
            end

            -- RIGHT
            if IsControlPressed(2, 175) then

                local players = getPlayers()


                currIndex = 0
                allPlayers = {}

                for k, v in pairs(players) do
                    playerID = v["serverid"]
                    if playerID == TargetSpectate then currIndex = k - 1 end
                    allPlayers[k-1] = playerID
                end
                nextIndex = currIndex + 1

                if nextIndex == #allPlayers + 1 then nextIndex = 0 end 
                TargetSpectate = allPlayers[currIndex]
                spectate(allPlayers[nextIndex], true)

            end
            -- LEFT
            if IsControlPressed(2, 174) then

                local players = getPlayers()


                currIndex = 1
                allPlayers = {}

                for k, v in pairs(players) do
                    playerID = v["serverid"]
                    if playerID == TargetSpectate then currIndex = k - 1 end
                    allPlayers[k-1] = playerID
                end
                prevIndex = currIndex - 1

                if prevIndex == -1 then prevIndex = #allPlayers end
                TargetSpectate = allPlayers[currIndex]
                spectate(allPlayers[prevIndex], true)
            end

            if IsControlPressed(2, 45) then
                TriggerServerEvent('lcrp-admin:server:startPlayerTp', TargetSpectate)
            end

			if radius > -1 then
				radius = -1
			end

			local xMagnitude = GetDisabledControlNormal(0, 1);
			local yMagnitude = GetDisabledControlNormal(0, 2);

			polarAngleDeg = polarAngleDeg + xMagnitude * 10;

			if polarAngleDeg >= 360 then
				polarAngleDeg = 0
			end

			azimuthAngleDeg = azimuthAngleDeg + yMagnitude * 10;

			if azimuthAngleDeg >= 360 then
				azimuthAngleDeg = 0;
			end

			local nextCamLocation = polar3DToWorld3D(coords, radius, polarAngleDeg, azimuthAngleDeg)

			SetCamCoord(cam,  nextCamLocation.x,  nextCamLocation.y,  nextCamLocation.z)
			PointCamAtEntity(cam,  targetPed)
			SetEntityCoords(playerPed,  coords.x, coords.y, coords.z + 10)

			if IsControlPressed(2, 47) then
			OpenAdminActionMenu(targetPlayerId)
			end
			
			local text = {}
            local targetGod = GetPlayerInvincible(targetPlayerId)

			if not CanPedRagdoll(targetPed) and not IsPedInAnyVehicle(targetPed, false) and (GetPedParachuteState(targetPed) == -1 or GetPedParachuteState(targetPed) == 0) and not IsPedInParachuteFreeFall(targetPed) then
				table.insert(text,"~r~Anti-Ragdoll~w~")
            end

            table.insert(text,"~y~Player"..": ~w~"..GetPlayerName(targetPlayerId).. " | ~y~ID: ~w~".. TargetSpectate)
			table.insert(text,"~r~Health"..": ~w~"..GetEntityHealth(targetPed).."/"..GetEntityMaxHealth(targetPed))
			table.insert(text,"~b~Armor"..": ~w~"..GetPedArmour(targetPed))

			for i,theText in pairs(text) do
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString(theText)
				EndTextCommandDisplayText(0.3, 0.7+(i/30))
			end
		end

        Citizen.Wait(sleep)
  	end
end)

RegisterNetEvent("lcrp-admin:client:BringCommand")
AddEventHandler("lcrp-admin:client:BringCommand", function(bringArgs)
    local plyCoords = GetEntityCoords(GetPlayerPed(-1))

    TriggerServerEvent('lcrp-admin:server:bringTp', bringArgs, plyCoords)
end)

RegisterNetEvent('lcrp-admin:client:spawnObject')
AddEventHandler('lcrp-admin:client:spawnObject', function(model)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)
    if tonumber(model) ~= nil then 
        model = tonumber(model)
    end
	SpawnObject(model, {
		x = x,
		y = y,
		z = z
	}, function(obj)
		SetEntityHeading(obj, GetEntityHeading(playerPed))
		--PlaceObjectOnGroundProperly(obj)
	end)
end)

function SpawnObject(model, coords, cb)
    if type(model) == 'string' then
        model = GetHashKey(model) 
    end
	Citizen.CreateThread(function()
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end

		local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)

		if cb ~= nil then
			cb(obj)
		end
	end)
end

RegisterNetEvent("lcrp-admin:client:SpectatePlayer")
AddEventHandler("lcrp-admin:client:SpectatePlayer", function(targetID)
    if myPermissionRank == "admin" or myPermissionRank == "god" or myPermissionRank == "mod" then
        targetID = tonumber(targetID)
        if targetID == nil then
            spectate(targetID, false)
        else
            spectate(targetID, true)
        end
    end
end)

RegisterNetEvent("lcrp-admin:client:banCommand")
AddEventHandler("lcrp-admin:client:banCommand", function(playerId)
    local src = source
    local reason = scCore.KeyboardInput("Enter Ban Reason", "", 100)
    local duration = scCore.KeyboardInput("Enter Ban Duration (Days)", "", 10)
    duration = tonumber(duration)
    if duration == 0 then duration = 7320 end
    duration = duration * 86400
    playerId = playerId[1]

    if reason and duration then
        TriggerServerEvent("lcrp-admin:server:banPlayer", playerId, duration, reason)
    else
        scCore.Notification('Duration or Reason is Invalid!', 'error')
    end
end)

RegisterNetEvent("lcrp-admin:client:banOfflineCommand")
AddEventHandler("lcrp-admin:client:banOfflineCommand", function(playerId)
    local reason = scCore.KeyboardInput("Enter Ban Reason", "", 100)
    local duration = scCore.KeyboardInput("Enter Ban Duration (Days)", "", 10)
    duration = tonumber(duration)
    if duration == 0 then duration = 7320 end
    duration = duration * 86400
    playerId = playerId[1]

    if reason and duration then
        TriggerServerEvent("lcrp-admin:server:banOffline", playerId, duration, reason)
    else
        scCore.Notification('Duration or Reason is Invalid!', 'error')
    end
end)

RegisterNetEvent("lcrp-admin:client:kickCommand")
AddEventHandler("lcrp-admin:client:kickCommand", function(targetPlayer)
    local kickReason = scCore.KeyboardInput("Enter Kick Reason", "", 100)

    if kickReason ~= nil and kickReason ~= "" then
        TriggerServerEvent("lcrp-admin:server:kickPlayer", targetPlayer, kickReason)
    end
end)

RegisterNetEvent("lcrp-admin:client:CreateDoorInfo")
AddEventHandler("lcrp-admin:client:CreateDoorInfo", function()
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
    local entity, coords, heading, model = nil, nil, nil, nil
    local result = false

    if myPermissionRank == "god" then

        scCore.Notification("Start aiming to find door info!")

        while true do
			Citizen.Wait(5)
			if IsPlayerFreeAiming(PlayerId()) then
				result, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
				coords = GetEntityCoords(entity)
				model = GetEntityModel(entity)
				heading = GetEntityHeading(entity)
			end
            if result then DrawInfos("Coords: " .. coords .. "\nHeading: " .. heading .. "\nHash: " .. model.. "\n[8] Save") end
            if IsDisabledControlJustReleased(0, 162) then break end -- Control [8] to break loop and send info
        end

        local minDimension, maxDimension = GetModelDimensions(model)
        local dimensions = maxDimension - minDimension
        local dx, dy = tonumber(dimensions.x), tonumber(dimensions.y)
    
        if dy <= -1 or dy >= 1 then dx = dy end
    
        textCoords = GetOffsetFromEntityInWorldCoords(entity, -dx/1.2, 0, 0)

        Citizen.Wait(1500)
        
        if DoesEntityExist(entity) then
            local velo = GetEntityVelocity(entity)
            if velo.x == 0.0 and velo.y == 0.0 and velo.z == 0.0 then
                local authorizedJobs = scCore.KeyboardInput("Enter authorized jobs ex: \'police\', \'fib\'", "", 30)
                local doorLocked = scCore.KeyboardInput("Door locked by default? (true/false)", "", 5)
                local doorDistance = scCore.KeyboardInput("Enter door distance", "1.5", 5)
                
                if authorizedJobs and doorLocked or not doorLocked then
                    TriggerServerEvent("lcrp-admin:server:SaveDoorText", coords, heading, model, authorizedJobs, doorLocked, doorDistance, textCoords)
                else
                    scCore.Notification("Arguments are wrong!", "error")
                end
            else
                scCore.Notification('The door must stop swingin itself!', "error")
            end
        else
            scCore.Notification("Door not found!", "error")
        end
    else
        scCore.Notification("You have no permission!", "error")
    end
end)

-- [[ Control Keybinds ]]

RegisterCommand("control-adminmenu", function(source)
    TriggerEvent("lcrp-admin:client:openMenu")
end)

RegisterCommand("control_tpm", function(source)
    if myPermissionRank == "admin" or myPermissionRank == "god" then
        TriggerEvent("scCore:Command:GoToMarker")
    else
        scCore.Notification("You have no permission!", "error")
    end
end)

RegisterCommand("control_fixveh", function(source)
    if myPermissionRank == "admin" or myPermissionRank == "god" then
        TriggerEvent('iens:repaira')
        TriggerEvent('vehiclemod:client:fixEverything')
    else
        scCore.Notification("You have no permission!", "error")
    end
end)

RegisterCommand("control_noclip", function(source)
    if myPermissionRank == "admin" or myPermissionRank == "god" then
        TriggerEvent("lcrp-admin:client:toggleNoclip")
    else
        scCore.Notification("You have no permission!", "error")
    end
end)

RegisterCommand("control_adminrevive", function(source)
    if myPermissionRank == "admin" or myPermissionRank == "god" then
        TriggerEvent("hospital:client:Revive")
    else
        scCore.Notification("You have no permission!", "error")
    end
end)