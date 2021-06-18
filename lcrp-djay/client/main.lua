xSound = exports.xsound
scCore = nil
PlayerJob = nil
PlayerData = nil
onDuty = false

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = scCore.Functions.GetPlayerData()
    PlayerJob = scCore.Functions.GetPlayerData().job
    onDuty = PlayerJob.onduty
end)

local radioDuty = {
	[1] = {x = -433.86, y = 161.74, z = 78.86},
} 
local owner = {
	[1] = {x = -447.26, y = 150.14, z = 78.89}
}
local chosenBar = nil
local bars = {}
local maxDist = 32


local djIsPlaying = false

function toggleDj()
	if PlayerJob ~= nil and (PlayerJob.name == "vanilla" or PlayerJob.name == "galaxy" or PlayerJob.name == "cockatoos" or PlayerJob.name == "bahamas") and PlayerJob.grade == 3 then
		if djIsPlaying then
			TriggerServerEvent('lcrp-djay:server:destroyRadio', PlayerJob.name)
			xSound:Destroy(PlayerJob.name)
			djIsPlaying = false
		else
			TriggerServerEvent("lcrp-djay:server:toggleRadio", "play", PlayerJob.name, { position = Config.nightclubs[PlayerJob.name].dancefloor.pos, link = Config.nightclubs[PlayerJob.name].playlist})
			djIsPlaying = true
		end
	end
end

function syncDj()
	TriggerServerEvent("lcrp-djay:server:toggleRadio", "play", PlayerJob.name, { position = Config.nightclubs[PlayerJob.name].dancefloor.pos, link = Config.nightclubs[PlayerJob.name].playlist})
	djIsPlaying = true
end

function djVolume(input)
	if input then
		local volume = xSound:getVolume(PlayerJob.name) - 0.1
		if volume >= 0 then 
			TriggerServerEvent('lcrp-djay:server:setVolume', PlayerJob.name, volume)
		end
	else
		local volume = xSound:getVolume(PlayerJob.name) + 0.1
		if volume <= 1 then 
			TriggerServerEvent('lcrp-djay:server:setVolume', PlayerJob.name, volume)
		end
	end
end

RegisterNUICallback('sendMusic', function(data, cb)
    toggleDj()
    cb(djIsPlaying)
end)

RegisterNUICallback('changeVolume', function(data, cb)
    djVolume(data.input)
    cb('ok')
end)

RegisterNUICallback('posteDoRafa', function(data, cb)
    syncDj()
    cb('ok')
end)


RegisterNUICallback('poste', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

---------------------------------- CUSTOM MADE SOUND SCRIPT -----------------------------
local musics = {}
local inCar = nil
local inPlate = nil

--[[ Citizen.CreateThread(function()
    Citizen.Wait(1000)
    local pos
    while true do
        Citizen.Wait(500)
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped, false)
		local musicId =  GetVehicleNumberPlateText(vehicle)
		if musics[musicId] == 1 then
			if xSound:soundExists(musicId) then
				if xSound:isPlaying(musicId) then
					pos = GetEntityCoords(vehicle)
					TriggerServerEvent("lcrp-djay:server:toggleRadio", "position", musicId, { position = pos })
				else
					TriggerServerEvent('lcrp-djay:server:destroyRadio', musicId)
					xSound:Destroy(musicId)
					musics[musicId] = nil
					Citizen.Wait(1000)
				end
			else
				Citizen.Wait(1000)
			end
		elseif inCar ~= nil then
			pos = GetEntityCoords(inCar)
			musicId = inPlate
			TriggerServerEvent("lcrp-djay:server:toggleRadio", "position", musicId, { position = pos })
			inCar = nil
			inPlate = nil
		else
			Citizen.Wait(1000)
		end
    end
end) ]]

RegisterNetEvent('lcrp-djay:client:setVolume')
AddEventHandler('lcrp-djay:client:setVolume', function(musicId, volume)
	xSound:setVolumeMax(musicId, volume)
end)

local setupCasino = false
local setupCasino2 = false
Citizen.CreateThread(function()
	while true do
		sleep = 1000
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped, false)
		local musicId =  GetVehicleNumberPlateText(vehicle)
		if musics[musicId] then
			sleep = 5
			if IsControlJustReleased(0, 11) then
				local volume = xSound:getVolume(musicId) - 0.1
				if volume >= 0 then 
					TriggerServerEvent('lcrp-djay:server:setVolume', musicId, volume)
				end
			elseif IsControlJustReleased(0, 10) then
				local volume = xSound:getVolume(musicId) + 0.1
				if volume <= 1 then 
					TriggerServerEvent('lcrp-djay:server:setVolume', musicId, volume)
				end
			end
		end
		--[[ if not setupCasino then
			xSound:PlayUrlPos("casino", "http://45.13.58.102:8050/radio.mp3", 1, vector3(969.11, 48.85, 70.83))
			xSound:Distance("casino", 60)
			xSound:setVolumeMax("casino", 0.05)
			setupCasino = true
		end
		if not setupCasino2 then
			xSound:PlayUrlPos("casino2", "http://45.13.58.102:8050/radio.mp3", 1, vector3(-372.5, 209.67, 81.31))
			xSound:Distance("casino2", 15)
			xSound:setVolumeMax("casino2", 0.05)
			setupCasino2 = true
		end ]]
		Citizen.Wait(sleep) 
	end
end)

--[[ RegisterNetEvent('lcrp-djay:client:toggleRadio')
AddEventHandler('lcrp-djay:client:toggleRadio', function()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	local musicId =  GetVehicleNumberPlateText(vehicle)
	if vehicle ~= 0 then
		if GetPedInVehicleSeat(vehicle, -1) == ped then
			if musics[musicId] and musics[musicId] == 1 then
				TriggerServerEvent('lcrp-djay:server:destroyRadio', musicId)
				xSound:Destroy(musicId)
				musics[musicId] = nil
			else
				local pos = GetEntityCoords(vehicle)
				TriggerServerEvent("lcrp-djay:server:toggleRadio", "play", musicId, { position = pos})
			end
		else
			scCore.Notification('Only the driver can choose the station.', 'error')
		end
	else
		scCore.Notification('You must be in a car. Use your phone to listen to your own radio', 'error')
	end
end) ]]

RegisterNetEvent("lcrp-djay:soundStatus")
AddEventHandler("lcrp-djay:soundStatus", function(type, musicId, data)
    if type == "position" then
        if xSound:soundExists(musicId) then
            xSound:Position(musicId, data.position)
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(ped, false)
			local plate =  GetVehicleNumberPlateText(vehicle)
			local distance = 10
			if plate == musicId then 
				distance = 1000
				inCar = vehicle
				inPlate = plate
			end
			xSound:Distance(musicId, distance)
        end
    end

    if type == "play" then
		if data.link then
			song = data.link
			distance = 32
			data.position = vector3(data.position.x, data.position.y, data.position.z)
		else
			song = "http://45.13.58.102:8070/radio.mp3"
			distance = 5
		end
        xSound:PlayUrlPos(musicId, song, 1, data.position)
        xSound:Distance(musicId, distance)
		xSound:setVolumeMax(musicId, 0.5)
		musics[musicId] = 1
    end

	if type == "destroy" then
		xSound:Destroy(musicId)
	end
end)

function round(num, dec)
  local mult = 10^(dec or 0)
  return math.floor(num * mult + 0.5) / mult
end


RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()

	exports["lcrp-interact"]:AddBoxZone("radioDuty", vector3(-434.77, 161.77, 78.86), 1.5, 1.2, {
		name="radioDuty",
		heading=2,
		--debugPoly=true,
		minZ=77.86,
		maxZ=79.06
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
		job = {"radio"}, distance = 2.0 })

	exports["lcrp-interact"]:AddBoxZone("radioBoss", vector3(-446.27, 150.99, 78.89), 2.4, 1.4, {
		name="radioBoss",
		heading=0,
		--debugPoly=true,
		minZ=77.89,
		maxZ=79.29 }, {
		options = {
			{
				event = "police:server:OpenSocietyMenu",
				icon = "fas fa-user-secret",
				label = "Boss Actions",
				duty = true,
				parameters = 'radio'
			},
		},
	job = {"radio"}, distance = 2.0})

	exports["lcrp-interact"]:AddBoxZone("cockatoosDJBooth", vector3(-419.48, -27.34, 41.3), 2.4, 0.6, {
		name="cockatoosDJBooth",
		heading=356,
		--debugPoly=true,
		minZ=40.3,
		maxZ=41.7 }, {
		options = {
			{
				event = "lcrp-djay:client:openDJBooth",
				icon = "fas fa-headphones",
				label = "DJ Booth",
				duty = false,
				djGrade = 3,
				parameters = 'cockatoos'
			},
		},
	job = {"cockatoos"}, distance = 4.0})

	exports["lcrp-interact"]:AddBoxZone("bahamasDJBooth", vector3(-1378.99, -628.3, 30.63), 2.2, 1.0, {
		name="bahamasDJBooth",
		heading=303,
		--debugPoly=true,
		minZ=29.63,
		maxZ=31.03 }, {
		options = {
			{
				event = "lcrp-djay:client:openDJBooth",
				icon = "fas fa-headphones",
				label = "DJ Booth",
				duty = false,
				djGrade = 3,
				parameters = 'bahamas'
			},
		},
	job = {"bahamas"}, distance = 4.0})

	exports["lcrp-interact"]:AddBoxZone("galaxyDJBooth", vector3(375.0, 275.96, 92.4), 2.2, 1.4, {
		name="galaxyDJBooth",
		heading=345,
		--debugPoly=true,
		minZ=91.4,
		maxZ=93.0 }, {
		options = {
			{
				event = "lcrp-djay:client:openDJBooth",
				icon = "fas fa-headphones",
				label = "DJ Booth",
				duty = false,
				djGrade = 3,
				parameters = 'galaxy'
			},
		},
	job = {"galaxy"}, distance = 4.0})

	exports["lcrp-interact"]:AddBoxZone("vanillaDJBooth", vector3(120.4, -1281.62, 29.48), 1.4, 2.4, {
		name="vanillaDJBooth",
		heading=300,
		--debugPoly=true,
		minZ=28.48,
		maxZ=29.88 }, {
		options = {
			{
				event = "lcrp-djay:client:openDJBooth",
				icon = "fas fa-headphones",
				label = "DJ Booth",
				duty = false,
				djGrade = 3,
				parameters = 'vannila'
			},
		},
	job = {"vannila"}, distance = 4.0})

end)

RegisterNetEvent("lcrp-djay:client:openDJBooth")
AddEventHandler("lcrp-djay:client:openDJBooth", function(bar)
	local myBar = PlayerJob.name
	if myBar == bar and PlayerJob.grade == 3 then
		SetNuiFocus(true, true)
		SendNUIMessage({action = "openmenu"})
	else
		scCore.Notification("If you are a dj, this is the wrong bar", "error")
	end
end)


