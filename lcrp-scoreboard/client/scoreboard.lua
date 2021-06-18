scCore = nil

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

CurrentCops = 0
EMSCount = 0
MechanicCount = 0

local onlinePlayers = 0
local isMenuOpen = false
local CurrentCopsText = "~r~OFFLINE"
local CurrentEMSText = "~r~OFFLINE"
local CurrentMechanicText = "~r~OFFLINE"
local jobsOnline = nil
local soulCooldown = GetGameTimer() - 25000
local metagaming = false
local metachecker = true

--[=====[ 
RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    if JobInfo.name == "police" then
		TriggerServerEvent("police:server:UpdateCurrentCops")
	elseif JobInfo.name == "mechanic" then
		TriggerServerEvent("lscustoms:server:UpdateCurrentMechanic")
	elseif JobInfo.name == "ambulance" or JobInfo.name == "doctor" then
		TriggerServerEvent("hospital:server:UpdateCurrentEMS")
    end
    PlayerJob.onduty = true
end)
--]=====]

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
	CurrentCops = amount

	if CurrentCops >= 3 and CurrentCops < 5 then
		CurrentCopsText = "~o~ONLINE"
	elseif CurrentCops >= 5 then
		CurrentCopsText = "~g~ONLINE"
	else
		CurrentCopsText = "~r~OFFLINE"
	end
end)

RegisterNetEvent("hospital:client:SetEMSCount")
AddEventHandler("hospital:client:SetEMSCount", function(amount)
	EMSCount = amount
	
	if EMSCount >= 2 then
		CurrentEMSText = "~g~ONLINE"
	else
		CurrentEMSText = "~r~OFFLINE"
	end
end)

RegisterNetEvent("lscustoms:client:SetMechanicCount")
AddEventHandler("lscustoms:client:SetMechanicCount", function(amount)
	MechanicCount = amount

	if MechanicCount >= 1 then
		CurrentMechanicText = "~g~ONLINE"
	else
		CurrentMechanicText = "~r~OFFLINE"
	end
end)

function DrawText3D(w,x,y,z,A,B,C)
	local D,E,F=World3dToScreen2d(w,x,y)
	local G,H,I=table.unpack(GetGameplayCamCoords())
	local J=GetDistanceBetweenCoords(G,H,I,w,x,y,1)
	local K=1/J*2.5
	local L=1/GetGameplayCamFov()*100;
	local K=K*L
	if D then 
		SetTextScale(0.0*K,0.55*K)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(A,B,C,255)
		SetTextDropshadow(0,0,0,0,255)
		SetTextEdge(2,0,0,0,150)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(z)
		DrawText(E,F)
	end 
end

Citizen.CreateThread(function()
	while true do
		sleep = 1000
		if isMenuOpen then
			for id = 0, 255 do
				sleep = 5
				if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= GetPlayerPed(-1) then
					ped = GetPlayerPed( id )
					x1, y1, z1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
					x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
					distance = math.floor(GetDistanceBetweenCoords(x1, y1, z1, x2,  y2,  z2,  true))
					if distance < 10 and NetworkIsPlayerTalking(id) then
						DrawMarker(27, x2,y2,z2 - 0.95, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 10.3, 64, 194, 99, 99, false, false, 2, true, nil, nil, false)
					end  
				end
			end
        end
        Citizen.Wait(sleep)
    end
end)

players = nil

RegisterNetEvent('scoreboard:getConnectedPlayers')
AddEventHandler('scoreboard:getConnectedPlayers', function(data)
	players = data
end)

RegisterCommand("control_playerlist", function(source)
	Wait(50)
	metagaming = true

	if not WarMenu.IsMenuOpened('PlayerList') then 
		isMenuOpen = true
		TriggerEvent('scoreboard:menuOpen')
		WarMenu.OpenMenu('PlayerList')
	else 
		isMenuOpen = false
		WarMenu.CloseMenu('PlayerList')
	end 
end)

CreateThread(function()
	WarMenu.CreateMenu('PlayerList','Player List')
	WarMenu.SetMenuWidth('PlayerList',0.23)
	WarMenu.SetMenuX('PlayerList',0.73)
	WarMenu.SetMenuY('PlayerList',0.20)
	WarMenu.SetTitleColor('PlayerList', 185, 185, 185, 255)
	WarMenu.SetTitleBackgroundColor('PlayerList',0,0,0,155)
	WarMenu.SetSubTitle('PlayerList','Players') 
	WarMenu.SetMenuBackgroundColor('PlayerList',0,0,0,155)
	WarMenu.SetMenuSubTextColor('PlayerList',255,255,255,255)
end)

Citizen.CreateThread(function()
	while true do 
		if WarMenu.IsMenuOpened('PlayerList') and players ~= nil then 
			waitTime = 5
			WarMenu.Button('Total Players:', #players, true)
			if WarMenu.CheckBox('View IDs', metachecker) then
				metachecker = not metachecker
			end

			if CurrentCopsText ~= nil then
				WarMenu.Button('LSPD: '.. CurrentCopsText)
			end

			if CurrentEMSText ~= nil then
				WarMenu.Button('EMS: '.. CurrentEMSText)
			end

			if CurrentMechanicText ~= nil then
				WarMenu.Button('Mechanics: '.. CurrentMechanicText)
			end

			WarMenu.Display()
		else 
			isMenuOpen = false
			metagaming = false
			waitTime = 500
		end 
		Citizen.Wait(waitTime)
	end 
end)

RegisterNetEvent('scoreboard:menuOpen')
AddEventHandler('scoreboard:menuOpen', function(group)
	TriggerServerEvent('scoreboard:sendConnectedPlayers')
	local M=PlayerPedId()
	while metagaming do 
		Wait(1)
		if metachecker then
			local N = GetEntityCoords(M)
			for f, g in ipairs(GetActivePlayers()) do 
				local l=GetPlayerPed(g)
				local n=GetEntityCoords(l)
				local O=GetDistanceBetweenCoords(N,n)
				if O<15 and IsEntityVisible(GetPlayerPed(g)) then 
					if HasEntityClearLosToEntity(M,l,17) then 
						local N=GetOffsetFromEntityInWorldCoords(l,0.0,0.0,1.0)
						if NetworkIsPlayerTalking(g) then 
							DrawText3D(N.x,N.y,N.z,GetPlayerServerId(g),137,207,240)
						else 
							DrawText3D(N.x,N.y,N.z,GetPlayerServerId(g),255,255,255)
						end 
					end 
				end 
			end 
			if GetGameTimer() >= (soulCooldown + 25000) then
	    		--TriggerServerEvent('scCore:Me:Display', 'Is looking into your soul')
				soulCooldown = GetGameTimer()
			end
		end
	end
end)