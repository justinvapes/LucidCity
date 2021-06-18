--scCore = nil
--Player = nil

--local requiredItemsShowed = false
--local bruteForceEnd
--local inRangeBruteForce = false
--local requiredItems = {}

--local isBruteForcing = false
--local timeRemaining = 60


function registerCryptostick(status)
    local password = scCore.KeyboardInput("Enter Crypto Password", "", 10)

    if password == nil then
        scCore.Notification('Password cannot be empty', 'error')
    else
        scCore.Functions.GetPlayerData(function(PlayerData)
            if status == 'Registered' then
                local info = {
                    ['type'] = 'Registered',
                    ['password'] = password,
                    ['firstname'] = PlayerData.charinfo.firstname,
                    ['lastname'] = PlayerData.charinfo.lastname
                }
                TriggerServerEvent('cryptostick:server:registerCryptostick', 0, info)
            elseif status == 'Unregistered' then
                for k,v in pairs(PlayerData.items) do
                    if v ~= nil then
                        if v.info.type ~= 'Registered' and v.name == 'cryptostick' then
                            local info = {
                                ['type'] = 'Registered',
                                ['password'] = password,
                                ['firstname'] = PlayerData.charinfo.firstname,
                                ['lastname'] = PlayerData.charinfo.lastname
                            }
                            TriggerServerEvent(
                                'cryptostick:server:registerCryptostick',
                                v.slot, info)
                            break
                        end
                    end
                end
            else
                scCore.Notification('An error ocurred. Please try again',
                                    'error')
            end
        end)
    end
end

RegisterNetEvent('cryptostick:client:startBruteForceGame')
AddEventHandler('cryptostick:client:startBruteForceGame', function(item)
    local finishHGame = false
    local wonGames = 0

    TriggerEvent("mhacking:seqstart",{8,6,4,2},90,function(sucess, remainingtime, finish)
        if sucess then
            wonGames = wonGames + 1
        else
            TriggerEvent("mhacking:hide")
            finishHGame = true
        end
    end)
    while not finishHGame do
        if finish then
            finishHGame = true
        end
        Citizen.Wait(1000)
    end
    if wonGames > 0 then
        if scCore ~= nil then
            scCore.Notification('Brute force initialized!','success')
        end
        TriggerServerEvent('cryptostick:server:startBruteForce', wonGames, item)
        TriggerEvent("lcrp-interact:client:updateInteractionOptions", "zone", "bruteforceCryptostick", setBruteForceInteract(1))
        TriggerEvent("lcrp-interact:client:updateInteractionOptions", "zone", "bruteforce2Cryptostick", setBruteForceInteract(1))
    else
        if scCore ~= nil then
            scCore.Notification('Brute force failed to initialize','error')
        end
    end
    
end)

local function startCountDown(startTime, endTime)
    Citizen.CreateThread(function()
        isBruteForcing = true
        while isBruteForcing do
            Citizen.Wait(1000)
            endTime = endTime - 1
            print(startTime.." - "..endTime)
            if endTime <= startTime then
                isBruteForcing = false
            end
        end
        scCore.Functions.GetPlayerData(function(PlayerData)
            TriggerServerEvent('lcrp-phone:server:sendNewMailToOffline', PlayerData.citizenid, {
                sender = "Lester",
                subject = "Cryptostick",
                message = "The servers are done with your cryptostick. Go check the result. <br><br> bye"
            })
            TriggerEvent("lcrp-interact:client:updateInteractionOptions", "zone", "bruteforceCryptostick", setBruteForceInteract(2))
            TriggerEvent("lcrp-interact:client:updateInteractionOptions", "zone", "bruteforce2Cryptostick", setBruteForceInteract(2))
        end)
    end)
end
RegisterNetEvent('cryptostick:client:sendBruteForceEndDate')
AddEventHandler('cryptostick:client:sendBruteForceEndDate', function(startDate,endDate)
    startCountDown(startDate,endDate)
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    exports["lcrp-interact"]:AddBoxZone("registerCryptostick", vector3(1276.46, -1709.76, 54.77), 2.0, 1.4, {
        name="registerCryptostick",
        heading=23,
        --debugPoly=true,
        minZ=53.37,
        maxZ=55.37
        }, {
		options = {
			{
				event = "cryptostick:client:register",
				icon = "fas fa-usb-drive",
				label = "Register Cryptostick",
				duty = false,
			},
		},
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("bruteforceCryptostick", vector3(941.71, -1465.29, 34.47), 2.2, 3.8, {
        name="bruteforceCryptostick",
        heading=0,
        --debugPoly=true,
        minZ=32.87,
        maxZ=34.47
        }, {
		options = setBruteForceInteract(0),
	job = {"all"}, distance = 2.0 })

    exports["lcrp-interact"]:AddBoxZone("bruteforce2Cryptostick", vector3(946.5, -1465.32, 34.44), 2.2, 5.0, {
        name="bruteforce2Cryptostick",
        heading=0,
        --debugPoly=true,
        minZ=33.44,
        maxZ=34.44
        }, {
		options = setBruteForceInteract(0),
	job = {"all"}, distance = 2.0 })
end)
function setBruteForceInteract(status)
    if status == 0 then
        return {{
                event = "cryptostick:client:bruteforce",
                icon = "fab fa-usb",
                label = "Brute force Cryptostick",
                duty = false,
                }}
    elseif status == 1 then
        return {{
                event = "",
                icon = "",
                label = "Brute forcing...",
                duty = false,
                }}
    elseif status == 2 then
        return {{
                event = "cryptostick:client:bruteforceResult",
                icon = "fab fa-usb",
                label = "Check brute force result",
                duty = false,
                }}
    end
end

RegisterNetEvent('cryptostick:client:register')
AddEventHandler('cryptostick:client:register', function()
    scCore.Functions.GetPlayerData(function(PlayerData)
        for k,v in pairs(PlayerData.items) do
            if v ~= nil then
                if v.name == 'cryptostick' and v.info.type == nil then
                    hasUnregCstick = true
                end
            end
        end

        if hasUnregCstick then
            registerCryptostick('Unregistered')
            hasUnregCstick = false
        else
            scCore.Notification("You don't have Cryptosticks to register","error")
        end
    end)
end)

RegisterNetEvent('cryptostick:client:bruteforce')
AddEventHandler('cryptostick:client:bruteforce', function()
    scCore.Functions.GetPlayerData(function(PlayerData)
        playerName = PlayerData.charinfo.firstname..PlayerData.charinfo.lastname
        found = false
        for k,v in pairs(PlayerData.items) do
            if v ~= nil then
                if v.name == 'cryptostick' and v.info.type == "Registered" then
                    if playerName ~= v.info.firstname..v.info.lastname then
                        TriggerEvent('cryptostick:client:startBruteForceGame', v)
                        found = true
                        break
                    end
                end
            end
        end
        if not found then
            scCore.Notification("You have no cryptosticks to bruteforce!","error")
        end
    end)
end)

RegisterNetEvent('cryptostick:client:bruteforceResult')
AddEventHandler('cryptostick:client:bruteforceResult', function()
    scCore.TriggerServerCallback("cryptostick:server:endBruteForce",
        function(finish, succeed)
            if finish then
                if succeed then
                    scCore.Notification(
                        'Cryptostick Brute Forced successfully!',
                        'success')
                    registerCryptostick('Registered')
                else
                    scCore.Notification('Brute Force Failed!',
                                        'error')
                end
                TriggerEvent("lcrp-interact:client:updateInteractionOptions", "zone", "bruteforceCryptostick", setBruteForceInteract(0))
                TriggerEvent("lcrp-interact:client:updateInteractionOptions", "zone", "bruteforce2Cryptostick", setBruteForceInteract(0))
            else
                scCore.Notification(
                    'Servers are still trying to brute force the cryptostick!',
                    'error')
            end
        end)
end)




    