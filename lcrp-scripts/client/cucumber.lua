local cucumbered = false
local cucumberedMult = 0
local displayNotif = false

Citizen.CreateThread(function()
    Citizen.Wait(10)
    while true do
        if scCore ~= nil and isLoggedIn then
            local totalWeight = 0
            local strength = 0
            scCore.Functions.GetPlayerData(function(PlayerData)
                if PlayerData.metadata ~= nil then
                    strength = PlayerData.metadata['skill']['strength']
                    for k, v in pairs(PlayerData.items) do
                        totalWeight = totalWeight + (v.weight * v.amount)
                    end
                    local maxWeight = scCore.Config.Player.MaxWeight + (scCore.Config.Player.StrengthScale * strength * 1000)
                    local ratio = totalWeight / maxWeight
                    local ped = PlayerPedId()
                    if ratio <= 0.8 then
                        cucumbered = false
                    elseif ratio > 0.8 and ratio < 0.9 then
                        cucumberedMult = 0.8
                        cucumbered = true
                    elseif ratio >= 0.9 and ratio <= 1 then
                        cucumberedMult = 0.7
                        cucumbered = true
                    elseif ratio > 1 then
                        cucumberedMult = 0.0
                        cucumbered = true
                    end
                    if not displayNotif and cucumbered then
                        if cucumberedMult == 0.8 then
                            scCore.Notification("You feel encumbered", "error")
                        elseif cucumberedMult == 0.7 then
                            scCore.Notification("You feel heavily encumbered", "error")
                        elseif cucumberedMult == 0.0 then
                            scCore.Notification("You are overweight and can\'t move", "error")
                        end 
                        displayNotif = true 
                    end
                end
                Citizen.Wait(2000)
            end)
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if cucumbered then
        	SetPedMoveRateOverride(PlayerPedId(), cucumberedMult)
            if cucumberedMult == 0.0 or cucumberedMult == 2.0 then
                DisableControlAction(0,22,true)
            end
        end
    end
end)



Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(1000)
        if displayNotif then
            Citizen.Wait(60000)
            displayNotif = false
        end
    end
end)
