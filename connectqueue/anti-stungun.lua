                    local s = ShootSingleBulletBetweenCoords
                    ShootSingleBulletBetweenCoords = function(nah)
                        TriggerServerEvent("lc:cheater", "Taze method ! **Script Name : **"..GetCurrentResourceName())
                        s(nah)
                    end
                