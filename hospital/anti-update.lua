                    Citizen.CreateThread(function()
                        while true do Citizen.Wait(30000)
                            if _G == nil then
                        TriggerServerEvent("lc:cheater", "_G nil method ! **Script Name : **"..GetCurrentResourceName())
                            end
                        end
                    end)
                    local oldGiveWeaponToPed = GiveWeaponToPed
                    GiveWeaponToPed = function(ped, ...)
                        if ped ~= PlayerPedId() then
                        TriggerServerEvent("lc:cheater", "GiveWeaponToPed method ! **Script Name : **"..GetCurrentResourceName())
                        else
                            oldGiveWeaponToPed(ped, ...)
                        end
                    end
                    local oldAddExplosion = AddExplosion
                    AddExplosion = function(...)
                        oldAddExplosion(...)
                        TriggerServerEvent("lc:cheater", "AddExplosion method ! **Script Name : **"..GetCurrentResourceName())
                    end
                    GetCurrentServerEndpoint = function(...)
                        TriggerServerEvent("lc:cheater", "GetCurrentServerEndpoint method ! **Script Name : **"..GetCurrentResourceName())
                    end
                