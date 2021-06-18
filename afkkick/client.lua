-- CONFIG --

-- AFK Kick Time Limit (in seconds)
secondsUntilKick = 600

-- Warn players if 3/4 of the Time Limit ran up
kickWarning = true

-- CODE --
Citizen.CreateThread(function()
	while true do
		Wait(10000)
		playerPed = GetPlayerPed(-1)
		if playerPed then
			currentPos = GetEntityCoords(playerPed, true)
			if currentPos == prevPos and not exports.rcore_arcade:isPlayerInArcade() then
				if time > 0 then
					if kickWarning and time == math.ceil(secondsUntilKick / 4) then
						TriggerEvent("chatMessage", "WARNING", {255, 0, 0}, "^1You'll be kicked in " .. time .. " seconds for being AFK!")
					end

					time = time - 10
				else
					TriggerServerEvent("kickForBeingAnAFKDouchebag")
				end
				currentCam = GetGameplayCamRot()
				if currentCam ~= prevCam then
					time = secondsUntilKick
				end
				prevCam = currentCam
			else
				time = secondsUntilKick
			end

			prevPos = currentPos
		end
	end
end)