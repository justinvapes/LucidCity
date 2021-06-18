-- its actually smooth crouch not like other gay ones --

local crouched = false -- DONT CHANGE THIS

-- config here yessir --
local crouchControl = 36 -- change crouch control here
local crouchSpeed = 0.7 -- Crouch up & down speed (up to 1.0)

Citizen.CreateThread( function()
    while true do 
        sleep = 1000
        local ped = GetPlayerPed(-1)
        DisableControlAction(0, crouchControl, true) -- INPUT_DUCK  
        if not IsPauseMenuActive() then
            sleep = 5 
            if IsDisabledControlJustPressed(0, crouchControl) then 
                RequestAnimSet("move_ped_crouched")

                while not HasAnimSetLoaded("move_ped_crouched") do 
                    Citizen.Wait(100)
                end
                
                if crouched then 
                    ResetPedMovementClipset( ped, crouchSpeed )
                    crouched = false 
                else
                    SetPedMovementClipset(GetPlayerPed(-1), "move_ped_crouched", crouchSpeed)
                    crouched = true 
                end
            end
        end 
        Citizen.Wait(sleep) 
    end
end)