AnimSet = "default";
local isInvisible = false

RegisterNetEvent('AnimSet:default');
AddEventHandler('AnimSet:default', function()
    ResetPedMovementClipset(PlayerPedId(), 0)
    AnimSet = "default";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:Hurry');
AddEventHandler('AnimSet:Hurry', function()
    RequestAnimSet("move_m@hurry@a")
    while not HasAnimSetLoaded("move_m@hurry@a") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@hurry@a", true)
    AnimSet = "move_m@hurry@a";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:Business');
AddEventHandler('AnimSet:Business', function()
    RequestAnimSet("move_m@business@a")
    while not HasAnimSetLoaded("move_m@business@a") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@business@a", true)
    AnimSet = "move_m@business@a";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:Brave');
AddEventHandler('AnimSet:Brave', function()
    RequestAnimSet("move_m@brave")
    while not HasAnimSetLoaded("move_m@brave") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@brave", true)
    AnimSet = "move_m@brave";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:Tipsy');
AddEventHandler('AnimSet:Tipsy', function()
    RequestAnimSet("move_m@drunk@slightlydrunk")
    while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
        Citizen.Wait(0)
    end
    SetPedMovementClipset(PlayerPedId(), "move_m@drunk@slightlydrunk", true)
    AnimSet = "move_m@drunk@slightlydrunk";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:Injured');
AddEventHandler('AnimSet:Injured', function()
    RequestAnimSet("move_m@injured")
    while not HasAnimSetLoaded("move_m@injured") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@injured", true)
    AnimSet = "move_m@injured";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:ToughGuy');
AddEventHandler('AnimSet:ToughGuy', function()
    RequestAnimSet("move_m@tough_guy@")
    while not HasAnimSetLoaded("move_m@tough_guy@") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@tough_guy@", true)
    AnimSet = "move_m@tough_guy@";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:Sassy');
AddEventHandler('AnimSet:Sassy', function()
    RequestAnimSet("move_m@sassy")
    while not HasAnimSetLoaded("move_m@sassy") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@sassy", true)
    AnimSet = "move_m@sassy";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:Sad');
AddEventHandler('AnimSet:Sad', function()
    RequestAnimSet("move_m@sad@a")
    while not HasAnimSetLoaded("move_m@sad@a") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@sad@a", true)
    AnimSet = "move_m@sad@a";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:Posh');
AddEventHandler('AnimSet:Posh', function()
    RequestAnimSet("move_m@posh@")
    while not HasAnimSetLoaded("move_m@posh@") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@posh@", true)
    AnimSet = "move_m@posh@";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:Alien');
AddEventHandler('AnimSet:Alien', function()
    RequestAnimSet("move_m@alien")
    while not HasAnimSetLoaded("move_m@alien") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@alien", true)
    AnimSet = "move_m@alien";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:NonChalant');
AddEventHandler('AnimSet:NonChalant', function()
    RequestAnimSet("move_m@non_chalant")
    while not HasAnimSetLoaded("move_m@non_chalant") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@non_chalant", true)
    AnimSet = "move_m@non_chalant";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:Hobo');
AddEventHandler('AnimSet:Hobo', function()
    RequestAnimSet("move_m@hobo@a")
    while not HasAnimSetLoaded("move_m@hobo@a") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@hobo@a", true)
    AnimSet = "move_m@hobo@a";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:Money');
AddEventHandler('AnimSet:Money', function()
    RequestAnimSet("move_m@money")
    while not HasAnimSetLoaded("move_m@money") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@money", true)
    AnimSet = "move_m@money";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:Swagger');
AddEventHandler('AnimSet:Swagger', function()
    RequestAnimSet("move_m@swagger")
    while not HasAnimSetLoaded("move_m@swagger") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@swagger", true)
    AnimSet = "move_m@swagger";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:Joy');
AddEventHandler('AnimSet:Joy', function()
    RequestAnimSet("move_m@joy")
    while not HasAnimSetLoaded("move_m@joy") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@joy", true)
    AnimSet = "move_m@joy";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:Moon');
AddEventHandler('AnimSet:Moon', function()

    RequestAnimSet("move_m@powerwalk")
    while not HasAnimSetLoaded("move_m@powerwalk") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@powerwalk", true)
    AnimSet = "move_m@powerwalk";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:Shady');
AddEventHandler('AnimSet:Shady', function()
    RequestAnimSet("move_m@shadyped@a")
    while not HasAnimSetLoaded("move_m@shadyped@a") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@shadyped@a", true)
    AnimSet = "move_m@shadyped@a";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:Tired');
AddEventHandler('AnimSet:Tired', function()
    RequestAnimSet("move_m@tired")
    while not HasAnimSetLoaded("move_m@tired") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_m@tired", true)
    AnimSet = "move_m@tired";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:Sexy');
AddEventHandler('AnimSet:Sexy', function()
    RequestAnimSet("move_f@sexy")
    while not HasAnimSetLoaded("move_f@sexy") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_f@sexy", true)
    AnimSet = "move_f@sexy";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:ManEater');
AddEventHandler('AnimSet:ManEater', function()
    RequestAnimSet("move_f@maneater")
    while not HasAnimSetLoaded("move_f@maneater") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_f@maneater", true)
    AnimSet = "move_f@maneater";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

RegisterNetEvent('AnimSet:ChiChi');
AddEventHandler('AnimSet:ChiChi', function()
    RequestAnimSet("move_f@chichi")
    while not HasAnimSetLoaded("move_f@chichi") do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), "move_f@chichi", true)
    AnimSet = "move_f@chichi";
    TriggerServerEvent("police:setAnimData", AnimSet)
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

RegisterNetEvent("expressions")
AddEventHandler("expressions", function(pArgs)
    if #pArgs ~= 1 then return end
    local expressionName = pArgs[1]
    SetFacialIdleAnimOverride(PlayerPedId(), expressionName, 0)
    return
end)

RegisterNetEvent("expressions:clear")
AddEventHandler("expressions:clear",function() 
    ClearFacialIdleAnimOverride(PlayerPedId()) 
end)

RegisterNetEvent("lcrp-radialmenu:client:openMDT")
AddEventHandler("lcrp-radialmenu:client:openMDT",function()
    TriggerEvent("menu:menuexit")
    Citizen.Wait(500) 
    TriggerServerEvent("mdt:openMDT", source)
end)

RegisterNetEvent("lcrp-radialmenu:client:PoliceRevive")
AddEventHandler("lcrp-radialmenu:client:PoliceRevive", function()
    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 5.0 then
        local playerId = GetPlayerServerId(player)
        
        TriggerServerEvent("hospital:server:RevivePlayer", playerId, false)
    else
        scCore.Notification("No player close by", "error")
    end
end)

function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle

    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)    
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1

        if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 25 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end

--[[ DEBUG ]]

RegisterNetEvent("lcrp-radialmenu:Debug:CloseRadial")
AddEventHandler("lcrp-radialmenu:Debug:CloseRadial", function()

    SetNuiFocus(false, false)
    inRadialMenu = bool
    TriggerServerEvent('lcrp-clothes:get_character_current')

end)

-- TRUNK --

local inTrunk = false
local isKidnapped = false
local isKidnapping = false

local disabledTrunk = {
    [1] = "penetrator",
    [2] = "vacca",
    [3] = "monroe",
    [4] = "turismor",
    [5] = "osiris",
    [6] = "comet",
    [7] = "ardent",
    [8] = "jester",
    [9] = "nero",
    [10] = "nero2",
    [11] = "vagner",
    [12] = "infernus",
    [13] = "zentorno",
    [14] = "comet2",
    [15] = "comet3",
    [16] = "comet4",
    [17] = "lp700r",
    [18] = "r8ppi",
    [19] = "911turbos",
    [20] = "rx7rb",
    [21] = "fnfrx7",
    [22] = "delsoleg",
    [23] = "s15rb",
    [24] = "gtr",
    [25] = "fnf4r34",
    [26] = "ap2",
    [27] = "bullet",
}

function loadDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
end

function disabledCarCheck(veh)
    for i=1,#disabledTrunk do
        if GetEntityModel(veh) == GetHashKey(disabledTrunk[i]) then
            return true
        end
    end
    return false
end

RegisterNetEvent('lcrp-radialmenu:client:SetKidnapping')
AddEventHandler('lcrp-radialmenu:client:SetKidnapping', function(bool)
    isKidnapping = bool
end)


local cam = nil

function getNearestVeh()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)

    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
    return vehicleHandle
end

function TrunkCam(bool)
    local ped = GetPlayerPed(-1)
    local vehicle = GetEntityAttachedTo(PlayerPedId())
    local drawPos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -5.5, 0)

    local vehHeading = GetEntityHeading(vehicle)

    if bool then
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        if not DoesCamExist(cam) then
            cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
            SetCamActive(cam, true)
            SetCamCoord(cam, drawPos.x, drawPos.y, drawPos.z + 2)
            SetCamRot(cam, -2.5, 0.0, vehHeading, 0.0)
            RenderScriptCams(true, false, 0, true, true)
        end
    else
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        cam = nil
    end
end

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local vehicle = GetEntityAttachedTo(PlayerPedId())
        local drawPos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -5.5, 0)
    
        local vehHeading = GetEntityHeading(vehicle)

        if cam ~= nil then
            SetCamRot(cam, -2.5, 0.0, vehHeading, 0.0)
            SetCamCoord(cam, drawPos.x, drawPos.y, drawPos.z + 2)
        else
            Citizen.Wait(1000)
        end

        Citizen.Wait(1)
    end
end)

RegisterNetEvent('lcrp-trunk:client:KidnapTrunk')
AddEventHandler('lcrp-trunk:client:KidnapTrunk', function()
    closestPlayer, distance = scCore.Functions.GetClosestPlayer()
    local closestPlayerPed = GetPlayerPed(closestPlayer)
    if (distance ~= -1 and distance < 2) then
        if isKidnapping then
            local closestVehicle = getNearestVeh()
            if closestVehicle ~= 0 then
                TriggerEvent('police:client:KidnapPlayer')
                TriggerServerEvent("police:server:CuffPlayer", GetPlayerServerId(closestPlayer), false)
                Citizen.Wait(50)
                TriggerServerEvent("lcrp-trunk:server:KidnapTrunk", GetPlayerServerId(closestPlayer), closestVehicle)
            end
        else
            scCore.Notification('You can\'t kidnap this person!', 'error')
        end
    end
end)

function getPlayerInTrunk(veh)
    local OffSet = TrunkOffset(veh)
    local d1,d2 = GetModelDimensions(GetEntityModel(veh))
    if OffSet > 0 then
        AttachEntityToEntity(PlayerPedId(), veh, 0, -0.1,(d1["y"]+0.85) + Config.offsets[OffSet]["yoffset"],(d2["z"]-0.87) + Config.offsets[OffSet]["zoffset"], 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
    else
        AttachEntityToEntity(PlayerPedId(), veh, 0, -0.1,d1["y"]+0.85,d2["z"]-0.87, 0, 0, 40.0, 1, 1, 1, 1, 1, 1)

    end
end

function TrunkOffset(veh)

    for i=1,#Config.offsets do
        if GetEntityModel(veh) == GetHashKey(Config.offsets[i]["name"]) then
            return i
        end
    end
    
    return 0
end

RegisterNetEvent('lcrp-trunk:client:KidnapGetIn')
AddEventHandler('lcrp-trunk:client:KidnapGetIn', function(veh)
    local ped = GetPlayerPed(-1)
    local closestVehicle = veh
    local vehClass = GetVehicleClass(closestVehicle)
    local plate = GetVehicleNumberPlateText(closestVehicle)

    if Config.TrunkClasses[vehClass].allowed then
        scCore.TriggerServerCallback('lcrp-trunk:server:getTrunkBusy', function(isBusy)
            if not disabledCarCheck(closestVehicle) then
                if not inTrunk then
                    if not isBusy then
                        if not isKidnapped then
                                --[[ offset = {
                                    x = Config.TrunkClasses[vehClass].x,
                                    y = Config.TrunkClasses[vehClass].y,
                                    z = Config.TrunkClasses[vehClass].z,
                                } ]]
                                loadDict("fin_ext_p1-7")
                                TaskPlayAnim(ped, "fin_ext_p1-7", "cs_devin_dual-7", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
                                
                                --AttachEntityToEntity(ped, closestVehicle, 0, offset.x, offset.y, offset.z, 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
                                getPlayerInTrunk(closestVehicle)
                                TriggerServerEvent('lcrp-trunk:server:setTrunkBusy', plate, true)
                                inTrunk = true
                                Citizen.Wait(500)
                                SetVehicleDoorShut(closestVehicle, 5, false)
                                --[[ if not isInvisible then
                                    SetEntityVisible(ped, false, false)
                                else
                                    SetEntityVisible(ped, true, false)
                                end ]]
                                --TrunkCam(true)

                                isKidnapped = true
                        else
                            local ped = GetPlayerPed(-1)
                            local vehicle = GetEntityAttachedTo(PlayerPedId())
                            local plate = GetVehicleNumberPlateText(vehicle)
            
                            if GetVehicleDoorAngleRatio(vehicle, 5) > 0 then
                                local vehCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0, -5.0, 0)
                                DetachEntity(ped, true, true)
                                ClearPedTasks(ped)
                                inTrunk = false
                                TriggerServerEvent('lcrp-scripts:trunk:server:setTrunkBusy', plate, nil)
                                SetEntityCoords(ped, vehCoords.x, vehCoords.y, vehCoords.z)
                                SetEntityCollision(PlayerPedId(), true, true)
                                --TrunkCam(false)
                            else
                                scCore.Notification('Trunk is closed', 'error', 2500)
                            end
                        end
                    else
                        scCore.Notification('Person is already inside', 'error', 2500)
                    end 
                else
                    scCore.Notification('You are already in the trunk', 'error', 2500)
                end 
            else
                scCore.Notification('You can\'t get in this vehicle\'s trunk', 'error', 2500)
            end
        end, plate)
    else
        scCore.Notification('You can\'t get in this vehicle\'s trunk', 'error', 2500)
    end
end)

RegisterNetEvent('lcrp-trunk:client:GetIn')
AddEventHandler('lcrp-trunk:client:GetIn', function(isKidnapped)
    local ped = GetPlayerPed(-1)
    local closestVehicle = scCore.Functions.GetClosestVehicle()
    local vehpos = GetEntityCoords(closestVehicle, false)
    local pos = GetEntityCoords(ped, true)

    if closestVehicle ~= 0 and GetDistanceBetweenCoords(pos.x, pos.y, pos.z, vehpos.x, vehpos.y, vehpos.z, true) < 3.5 then
        local vehClass = GetVehicleClass(closestVehicle)
        local plate = GetVehicleNumberPlateText(closestVehicle)
        if Config.TrunkClasses[vehClass].allowed then
            scCore.TriggerServerCallback('lcrp-trunk:server:getTrunkBusy', function(isBusy)
                if not disabledCarCheck(closestVehicle) then
                    if not inTrunk then
                        if not isBusy then
                            if GetVehicleDoorAngleRatio(closestVehicle, 5) > 0 then
                                --[[ offset = {
                                    x = Config.TrunkClasses[vehClass].x,
                                    y = Config.TrunkClasses[vehClass].y,
                                    z = Config.TrunkClasses[vehClass].z,
                                } ]]
                                loadDict("fin_ext_p1-7")
                                TaskPlayAnim(ped, "fin_ext_p1-7", "cs_devin_dual-7", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
                                --AttachEntityToEntity(ped, closestVehicle, 0, offset.x, offset.y, offset.z, 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
                                getPlayerInTrunk(closestVehicle)
                                TriggerServerEvent('lcrp-trunk:server:setTrunkBusy', plate, true)
                                inTrunk = true
                                Citizen.Wait(500)
                                SetVehicleDoorShut(closestVehicle, 5, false)
                                --[[ if not isInvisible then
                                    SetEntityVisible(ped, true, false)
                                else
                                    SetEntityVisible(ped, true, false)
                                end
                                TrunkCam(true) ]]
                            else
                                scCore.Notification('Trunk is closed', 'error', 2500)
                            end
                        else
                            scCore.Notification('Person is already inside', 'error', 2500)
                        end 
                    else
                        scCore.Notification('You are already in the trunk', 'error', 2500)
                    end 
                else
                    scCore.Notification('You can\'t get in this vehicle\'s trunk', 'error', 2500)
                end
            end, plate)
        else
            scCore.Notification('You can\'t get in this vehicle\'s trunk', 'error', 2500)
        end
    else
        scCore.Notification('No vehicle nearby', 'error', 2500)
    end
end)

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}


RegisterNetEvent('lcrp-radialmenu:client:leaveTrunk')
AddEventHandler('lcrp-radialmenu:client:leaveTrunk', function()
    if IsInTrunkAndNotKidnapped() then
        local ped = GetPlayerPed(-1)
        local vehicle = GetEntityAttachedTo(PlayerPedId())
        local plate = GetVehicleNumberPlateText(vehicle)

        if GetVehicleDoorAngleRatio(vehicle, 5) > 0 then
            local vehCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0, -5.0, 0)
            DetachEntity(ped, true, true)
            ClearPedTasks(ped)
            inTrunk = false
            TriggerServerEvent('lcrp-trunk:server:setTrunkBusy', plate, false)
            SetEntityCoords(ped, vehCoords.x, vehCoords.y, vehCoords.z)
            SetEntityCollision(PlayerPedId(), true, true)
            --TrunkCam(false)
        else
            scCore.Notification('Is the trunk closed?', 'error', 2500)
        end
    else
        scCore.Notification('Action unavailable', 'error', 2500)
        scCore.Notification('You are either kidnapped or not inside a trunk', 'error', 2500)
    end
end)

RegisterNetEvent('lcrp-radialmenu:client:toggleTrunk')
AddEventHandler('lcrp-radialmenu:client:toggleTrunk', function()
    local vehicle = GetEntityAttachedTo(PlayerPedId())
    local plate = GetVehicleNumberPlateText(vehicle)

    if IsInTrunkAndNotKidnapped() then
        if IsTrunkOpened() then
            if not IsVehicleSeatFree(vehicle, -1) then
                TriggerServerEvent('lcrp-radialmenu:trunk:server:Door', false, plate, 5)
            else
                SetVehicleDoorShut(vehicle, 5, false)
                --[[ if not isInvisible then
                    SetEntityVisible(PlayerPedId(), false, false)
                else
                    SetEntityVisible(PlayerPedId(), true, false)
                end ]]
            end 
        else
            if not IsVehicleSeatFree(vehicle, -1) then
                TriggerServerEvent('lcrp-radialmenu:trunk:server:Door', true, plate, 5)
            else
                 SetVehicleDoorOpen(vehicle, 5, false, false)
                --[[if isInvisible then
                    SetEntityVisible(PlayerPedId(), false, false)
                else
                    SetEntityVisible(PlayerPedId(), true, false)
                end ]]
            end
        end
    else
        scCore.Notification('Action unavailable', 'error', 2500)
        scCore.Notification('You are either kidnapped or not inside a trunk', 'error', 2500)
    end
    
end)


function IsInTrunkAndNotKidnapped()
    if inTrunk and not isKidnapped then
        return true
    end
    return false
end

function IsTrunkOpened()
    local vehicle = GetEntityAttachedTo(PlayerPedId())
    if GetVehicleDoorAngleRatio(vehicle, 5) > 0.0 then
        return true
    end
    return false
end

function IsInTrunk()
    return inTrunk
end