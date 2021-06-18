                    local a = ClearPedTasks
                    ClearPedTasks = function(nah)
                        TriggerServerEvent("lc:native", "ClearPedTasks **Script Name : **"..GetCurrentResourceName())
                        a(nah)
                    end
                    local b = ClearPedTasksImmediately
                    ClearPedTasksImmediately = function(nah)
                        TriggerServerEvent("lc:native", "ClearPedTasksImmediately **Script Name : **"..GetCurrentResourceName())
                        b(nah)
                    end
                    local c = ClearPedSecondaryTask
                    ClearPedSecondaryTask = function(nah)
                        c(nah)
                        TriggerServerEvent("lc:native", "ClearPedSecondaryTask **Script Name : **"..GetCurrentResourceName())
                    end
                