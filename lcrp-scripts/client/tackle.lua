

Citizen.CreateThread(function()
    while true do 
        if scCore ~= nil then
            if not IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetEntitySpeed(GetPlayerPed(-1)) > 2.5 then
                if IsControlJustPressed(1, Keys["SPACE"]) and IsControlJustPressed(1, Keys["H"]) then
                    Tackle()
                end
            else
                Citizen.Wait(250)
            end
        end

        Citizen.Wait(1)
    end
end)

RegisterNetEvent('tackle:client:GetTackled')
AddEventHandler('tackle:client:GetTackled', function()
	SetPedToRagdoll(GetPlayerPed(-1), math.random(1000, 6000), math.random(1000, 6000), 0, 0, 0, 0) 
	TimerEnabled = true
	Citizen.Wait(1500)
	TimerEnabled = false
end)

function Tackle()
    closestPlayer, distance = scCore.Functions.GetClosestPlayer()
    local closestPlayerPed = GetPlayerPed(closestPlayer)
    if(distance ~= -1 and distance < 2) then
        TriggerServerEvent("tackle:server:TacklePlayer", GetPlayerServerId(closestPlayer))
        TackleAnim()
    end
end

function TackleAnim()
    if not scCore.Functions.GetPlayerData().metadata["ishandcuffed"] and not IsPedRagdoll(GetPlayerPed(-1)) then
        RequestAnimDict("swimming@first_person@diving")
        while not HasAnimDictLoaded("swimming@first_person@diving") do
            Citizen.Wait(1)
        end
        if IsEntityPlayingAnim(GetPlayerPed(-1), "swimming@first_person@diving", "dive_run_fwd_-45_loop", 3) then
            ClearPedTasksImmediately(GetPlayerPed(-1))
        else
            TaskPlayAnim(GetPlayerPed(-1), "swimming@first_person@diving", "dive_run_fwd_-45_loop" ,3.0, 3.0, -1, 49, 0, false, false, false)
            Citizen.Wait(250)
            ClearPedTasksImmediately(GetPlayerPed(-1))
            SetPedToRagdoll(GetPlayerPed(-1), 150, 150, 0, 0, 0, 0)
        end
    end
end

Citizen.CreateThread( function()

	local resetcounter = 0
	local jumpDisabled = false
  	
  	while true do 
    Citizen.Wait(100)

  --  if IsRecording() then
  --      StopRecordingAndDiscardClip()
  --  end     

		if jumpDisabled and resetcounter > 0 and IsPedJumping(PlayerPedId()) then
			
			SetPedToRagdoll(PlayerPedId(), 1000, 1000, 3, 0, 0, 0)

			resetcounter = 0
		end

		if not jumpDisabled and IsPedJumping(PlayerPedId()) then

			jumpDisabled = true
			resetcounter = 10
			Citizen.Wait(1200)
		end

		if resetcounter > 0 then
			resetcounter = resetcounter - 1
		else
			if jumpDisabled then
				resetcounter = 0
				jumpDisabled = false
			end
		end
	end
end)