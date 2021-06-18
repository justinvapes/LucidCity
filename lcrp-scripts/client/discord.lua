-- scCore = nil

-- ---- CONFIG ----
-- local ClientID = "742518094517239808"
-- local ResourceTimer = 5 -- seconds
-- local PlayerCount = 200
-- ---- CONFIG ----

-- ---- scCore ----
-- scCore = nil

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(10)
--         if scCore == nil then
--             TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
--             Citizen.Wait(200)
--         end
--     end
-- end)

-- Citizen.CreateThread(function()
--     Wait(100)
--     if scCore.Functions.GetPlayerData() ~= nil then
--         PlayerData = scCore.Functions.GetPlayerData()
--         PlayerJob = PlayerData.job
--     end
-- end)

-- RegisterNetEvent('scCore:Client:OnJobUpdate')
-- AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
--     PlayerData.job = JobInfo
-- end)
---- scCore ----

-- Citizen.CreateThread(function()
-- 	while true do			             
--         -- scCore.Functions.GetPlayerData(function(PlayerData)
--         -- if not PlayerData.job.name == nil then
--         --         SetDiscordRichPresenceAssetSmall(PlayerData.job.name)
--         --         job = PlayerData.job.name
--         --         SetDiscordRichPresenceAssetSmallText(job) -- job text
--         --     else			
--         --         Citizen.Wait(500)
--         --     end
--         -- end)	            
                
--         SetDiscordAppId(ClientID) -- application id

--         SetDiscordRichPresenceAsset('logo') -- large icon image name
        
--         SetRichPresence('ID:' .. GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1))) .. ' | ' .. GetPlayerName(PlayerId()) .. ' | ' ..' '.. "Players" ..' ' .. #GetActivePlayers() .. '/' .. tostring(PlayerCount))

--         SetDiscordRichPresenceAssetText('LUCIDCITY')-- Hover text for large icon.

--         Citizen.Wait(ResourceTimer*1000)
-- 	end
-- end)

Citizen.CreateThread(function()
	while true do
		SetDiscordAppId(820411685445304372)
		SetDiscordRichPresenceAsset('logo')
        SetDiscordRichPresenceAssetText('lucidcityrp.com')
		Citizen.Wait(60000)
	end
end)
Citizen.CreateThread(function()
	while true do
		local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
		if VehName == "NULL" then VehName = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))) end
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
		local StreetHash = GetStreetNameAtCoord(x, y, z)
		local pId = GetPlayerServerId(PlayerId())
		local pName = GetPlayerName(PlayerId())
		Citizen.Wait(15000)
		if StreetHash ~= nil then
			StreetName = GetStreetNameFromHashKey(StreetHash)
			if IsPedOnFoot(PlayerPedId()) and not IsEntityInWater(PlayerPedId()) then
				if IsPedSprinting(PlayerPedId()) then
					SetRichPresence("ID: "..pId.." | "..pName.." is sprinting down "..StreetName)
				elseif IsPedRunning(PlayerPedId()) then
					SetRichPresence("ID: "..pId.." | "..pName.." is running down "..StreetName)
				elseif IsPedWalking(PlayerPedId()) then
					SetRichPresence("ID: "..pId.." | "..pName.." is walking down "..StreetName)
				elseif IsPedStill(PlayerPedId()) then
					SetRichPresence("ID: "..pId.." | "..pName.." is standing on "..StreetName.."")
				end
			elseif GetVehiclePedIsUsing(PlayerPedId()) ~= nil and not IsPedInAnyHeli(PlayerPedId()) and not IsPedInAnyPlane(PlayerPedId()) and not IsPedOnFoot(PlayerPedId()) and not IsPedInAnySub(PlayerPedId()) and not IsPedInAnyBoat(PlayerPedId()) then
				local MPH = math.ceil(GetEntitySpeed(GetVehiclePedIsUsing(PlayerPedId())) * 2.236936)
				if MPH > 50 then
					SetRichPresence("ID: "..pId.." | "..pName.." is speeding down "..StreetName.." at "..MPH.."MPH in a "..VehName)
				elseif MPH <= 50 and MPH > 0 then
					SetRichPresence("ID: "..pId.." | "..pName.." is cruising down "..StreetName.." at "..MPH.."MPH in a "..VehName)
				elseif MPH == 0 then
					SetRichPresence("ID: "..pId.." | "..pName.." is parked on "..StreetName.." in a "..VehName)
				end
			elseif IsPedInAnyHeli(PlayerPedId()) or IsPedInAnyPlane(PlayerPedId()) then
				if IsEntityInAir(GetVehiclePedIsUsing(PlayerPedId())) or GetEntityHeightAboveGround(GetVehiclePedIsUsing(PlayerPedId())) > 5.0 then
					SetRichPresence("ID: "..pId.." | "..pName.." is flying over "..StreetName.." in a "..VehName)
				else
					SetRichPresence("ID: "..pId.." | "..pName.." is landed at "..StreetName.." in a "..VehName)
				end
			elseif IsEntityInWater(PlayerPedId()) then
				SetRichPresence("ID: "..pId.." | "..pName.." is swimming")
			elseif IsPedInAnyBoat(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
				SetRichPresence("ID: "..pId.." | "..pName.." is sailing in a "..VehName)
			elseif IsPedInAnySub(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
				SetRichPresence("ID: "..pId.." | "..pName.." is in a yellow submarine")
			end
		end
	end
end)