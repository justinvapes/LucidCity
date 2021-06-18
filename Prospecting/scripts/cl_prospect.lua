scCore = nil
local blip_location = vector3(1580.9, 6592.204, 13.84828)
local blip = nil
local area_blip = nil
local area_size = 100.0

local DEBUG = false
local function debugLog() end
if DEBUG then debugLog = function(...)
    print(...)
end end

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

function EnsureAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end
function EnsureModel(model)
    if not IsModelInCdimage(model) then
        debugLog("model", model, "not in cd image")
    else
        if not HasModelLoaded(model) then
            debugLog("loading", model)
            RequestModel(model)
        	while not HasModelLoaded(model) do
        		Wait(0)
        	end
            debugLog("successfully loaded", model)
    	end
	end
end

local previousAnim = nil
function StopAnim(ped)
    if previousAnim then
        StopEntityAnim(ped, previousAnim[2], previousAnim[1], true)
        previousAnim = nil
    end
end
function PlayAnimFlags(ped, dict, anim, flags)
    StopAnim(ped)
    EnsureAnimDict(dict)
    local len = GetAnimDuration(dict, anim)
    TaskPlayAnim(ped, dict, anim, 1.0, -1.0, len, flags, 1, 0, 0, 0)
    previousAnim = {dict, anim}
end

function PlayAnimUpper(ped, dict, anim)
    PlayAnimFlags(ped, dict, anim, 49)
end
function PlayAnim(ped, dict, anim)
    PlayAnimFlags(ped, dict, anim, 0)
end

local targetPool = {
    {vector3(1600.185, 6622.714, 15.85106), 1.0},
}

local maxTargetRange = 200.0
local targets = {}


RegisterNetEvent("prospecting:setTargetPool")
AddEventHandler("prospecting:setTargetPool", function(pool)
    targetPool = {}
    debugLog("new targets", json.encode(pool))
    for n, pos in next, pool do
        targetPool[n] = {vector3(pos[1], pos[2], pos[3]), pos[4], n}
    end
end)

local isProspecting = false
local pauseProspecting = false
local didCancelProspecting = false
local scannerState = "none"
local scannerFrametime = 0.0
local scannerScale = 0.0
local scannerAudio = true

local CONTROLS = {
    ["dig"] = {
        label = "Dig",
        control = 58,
        input = "INPUT_THROW_GRENADE"
    },
    ["dig_hint"] = {
        label = "You found something!",
        control = 58,
        input = "INPUT_THROW_GRENADE"
    },
    ["stop"] = {
        label = "Stop prospecting",
        control = 75,
        input = "INPUT_VEH_EXIT"
    },
    ["audio_on"] = {
        label = "Enable scanner audio",
        control = 140,
        input = "INPUT_MELEE_ATTACK_LIGHT"
    },
    ["audio_off"] = {
        label = "Disable scanner audio",
        control = 140,
        input = "INPUT_MELEE_ATTACK_LIGHT"
    },
}

local entityOffsets = {
    ["w_am_digiscanner"] = {
		bone = 18905,
        offset = vector3(0.15, 0.1, 0.0),
        rotation = vector3(270.0, 90.0, 80.0),
	},
    -- cant get the fucking model to be standalone so im replacing the digiscanner
    -- nobody uses it anyways so w/e
    ["w_am_metaldetector"] = {
		bone = 18905,
        offset = vector3(0.15, 0.1, 0.0),
        rotation = vector3(270.0, 90.0, 80.0),
	},
    -- original digiscanner stuff
    -- ["w_am_digiscanner"] = {
	-- 	bone = 57005,
    --     offset = vector3(0.1, 0.1, 0.0),
    --     rotation = vector3(270.0, 90.0, 90.0),
	-- },
}

local attachedEntities = {}
local scannerEntity = nil
function AttachEntity(ped, model)
    if entityOffsets[model] then
        EnsureModel(model)
        local pos = GetEntityCoords(PlayerPedId())
    	local ent = CreateObjectNoOffset(model, pos, 1, 1, 0)
    	AttachEntityToEntity(ent, ped, GetPedBoneIndex(ped, entityOffsets[model].bone), entityOffsets[model].offset, entityOffsets[model].rotation, 1, 1, 0, 0, 2, 1)
        scannerEntity = ent
        table.insert(attachedEntities, ent)
    end
end

function CleanupModels()
    for _, ent in next, attachedEntities do
        DetachEntity(ent, 0, 0)
        DeleteEntity(ent)
    end
    attachedEntities = {}
    scannerEntity = nil
end

function DisableAllInstructions()
    for _, inst in next, CONTROLS do
        SetInstructionalButton(inst["label"], inst["control"], false)
    end
end

function DigSequence()
    DisableAllInstructions()
    CleanupModels()
    local ped = PlayerPedId()
    StopEntityAnim(ped, "wood_idle_a", "mini@golfai", true)
    PlayAnim(ped, "amb@world_human_gardener_plant@male@enter", "enter")
    Wait(100)
    while IsEntityPlayingAnim(ped, "amb@world_human_gardener_plant@male@enter", "enter", 3) do
        Wait(0)
    end
    PlayAnim(ped, "amb@world_human_gardener_plant@male@base", "base")
    Wait(100)
    while IsEntityPlayingAnim(ped, "amb@world_human_gardener_plant@male@base", "base", 3) do
        Wait(0)
    end
    PlayAnim(ped, "amb@world_human_gardener_plant@male@exit", "exit")
    Wait(100)
    while IsEntityPlayingAnim(ped, "amb@world_human_gardener_plant@male@exit", "exit", 3) do
        Wait(0)
    end
    AttachEntity(PlayerPedId(), "w_am_digiscanner")
end

function ShowHelp(text, n)
    BeginTextCommandDisplayHelp(text)
    EndTextCommandDisplayHelp(n or 0, false, true, -1)
end
function ShowFloatingHelp(text, pos)
    SetFloatingHelpTextWorldPosition(1, pos)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    ShowHelp(text, 2)
end

function getClosestTarget(pos)
    local closest, index, closestdist, difficulty
    for n, target in next, targets do
        local dist = #(pos.xy - target[1].xy)
        if (not closest) or closestdist > dist then
            closestdist = dist
            index = n
            closest = target
            difficulty = target[2]
        end
    end
    -- Return 0,0,0 if no targets
    return closest or vector3(0.0, 0.0, 0.0), closestdist, index, difficulty
end

function DigTarget(index)
    local target = table.remove(targets, index)
    local pos = target[1]
    TriggerServerEvent("prospecting:userCollectedNode", index, pos.x, pos.y, pos.z)
    pauseProspecting = false
end

function StopProspecting()
    if not didCancelProspecting then
        didCancelProspecting = true
        CleanupModels()
        local ped = PlayerPedId()
        StopEntityAnim(ped, "wood_idle_a", "mini@golfai", true)
        circleScale = 0.0
        scannerScale = 0.0
        scannerState = "none"
        isProspecting = false
        TriggerServerEvent("prospecting:userStoppedProspecting")
    end
end

RegisterNetEvent("Prospecting:stopProspecting")
AddEventHandler("Prospecting:stopProspecting", function()
    CleanupModels()
    StopProspecting()
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        CleanupModels()
        StopProspecting()
    end
end)

function StartProspecting()
    debugLog("trying to start")
    if not isProspecting then
        debugLog("starting")
        ProspectingThreads()
    end
end

RegisterNetEvent("prospecting:forceStart")
AddEventHandler("prospecting:forceStart", function()
    StartProspecting()
end)
RegisterNetEvent("prospecting:forceStop")
AddEventHandler("prospecting:forceStop", function()
    StopProspecting()
end)

Citizen.CreateThread(function()
    Wait(1000)
    -- init
    TriggerServerEvent("prospecting:userRequestsLocations")
end)

function ProspectingThreads()
    if IsProspecting then return false end
    debugLog("thread init")
    TriggerServerEvent("prospecting:userStartedProspecting")
    isProspecting = true
    didCancelProspecting = false
    pauseProspecting = false

    -- Prospecting handler
    Citizen.CreateThread(function()
        AttachEntity(PlayerPedId(), "w_am_digiscanner")
        while isProspecting do
            Wait(0)
            local ped = PlayerPedId()
            local ply = PlayerId()
            local canProspect = true
            for _, control in next, CONTROLS do
                DisableControlAction(0, control["control"], true)
            end
            if not IsEntityPlayingAnim(ped, "mini@golfai", "wood_idle_a", 3) then
                PlayAnimUpper(PlayerPedId(), "mini@golfai", "wood_idle_a")
            end

            -- Actions that halt prospecting animations and scanning
            local restrictedMovement = false
            restrictedMovement = restrictedMovement or IsPedFalling(ped)
            restrictedMovement = restrictedMovement or IsPedJumping(ped)
            restrictedMovement = restrictedMovement or IsPedSprinting(ped)
            restrictedMovement = restrictedMovement or IsPedRunning(ped)
            restrictedMovement = restrictedMovement or IsPlayerFreeAiming(ply)
            restrictedMovement = restrictedMovement or IsPedRagdoll(ped)
            restrictedMovement = restrictedMovement or IsPedInAnyVehicle(ped)
            restrictedMovement = restrictedMovement or IsPedInCover(ped)
            restrictedMovement = restrictedMovement or IsPedInMeleeCombat(ped)

            if restrictedMovement then canProspect = false end
            if canProspect then
                local pos = GetEntityCoords(ped) + vector3(GetEntityForwardX(ped) * 0.75, GetEntityForwardY(ped) * 0.75, -0.75)
                -- local pos = GetWorldPositionOfEntityBone(scannerEntity, 0)
                local target, dist, index, difficulyModifier = getClosestTarget(pos)
                if index then
                    local dist = dist * difficulyModifier
                    if dist < 3.0 then
                        SetInstructionalButton(CONTROLS["dig"]["label"], CONTROLS["dig"]["control"], true)
                        ShowFloatingHelp("You found something!", pos)
                        if IsDisabledControlJustPressed(0, CONTROLS["dig"]["control"]) then
                            scannerState = "none"
                            pauseProspecting = true
                        
                            scCore.TaskBar("prospecting_dig", "Digging", 7000, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                                disableCancel = true,
                            }, {}, {}, {}, function() -- Done
                                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                DigTarget(index)
                            end)

                            DigSequence()
                        end
                    else
                        SetInstructionalButton(CONTROLS["dig"]["label"], CONTROLS["dig"]["control"], false)
                    end
                    if dist < 3.0 then
                        circleScale = 0.0
                        scannerScale = 0.0
                        scannerState = "ultra"
                    elseif dist < 4.0 then
                        scannerFrametime = 0.35
                        scannerScale = 4.50
                        scannerState = "fast"
                    elseif dist < 5.0 then
                        scannerFrametime = 0.4
                        scannerScale = 3.75
                        scannerState = "fast"
                    elseif dist < 6.5 then
                        scannerFrametime = 0.425
                        scannerScale = 3.00
                        scannerState = "fast"
                    elseif dist < 7.5 then
                        scannerFrametime = 0.45
                        scannerScale = 2.50
                        scannerState = "fast"
                    elseif dist < 10.0 then
                        scannerFrametime = 0.5
                        scannerScale = 1.75
                        scannerState = "fast"
                    elseif dist < 12.5 then
                        scannerFrametime = 0.75
                        scannerScale = 1.25
                        scannerState = "medium"
                    elseif dist < 15.0 then
                        scannerFrametime = 1.0
                        scannerScale = 1.00
                        scannerState = "medium"
                    elseif dist < 20.0 then
                        scannerFrametime = 1.25
                        scannerScale = 0.875
                        scannerState = "medium"
                    elseif dist < 25.0 then
                        scannerFrametime = 1.5
                        scannerScale = 0.75
                        scannerState = "slow"
                    elseif dist < 30.0 then
                        scannerFrametime = 2.0
                        scannerScale = 0.5
                        scannerState = "slow"
                    else
                        circleScale = 0.0
                        scannerScale = 0.0
                        scannerState = "none"
                    end
                    scannerDistance = dist
                else
                    circleScale = 0.0
                    scannerScale = 0.0
                    scannerState = "none"
                end
                SetInstructionalButton(CONTROLS["stop"]["label"], CONTROLS["stop"]["control"], true)
                if IsDisabledControlJustPressed(0, CONTROLS["stop"]["control"]) then
                    isProspecting = false
                end
                if not scannerAudio then
                    SetInstructionalButton(CONTROLS["audio_on"]["label"], CONTROLS["audio_on"]["control"], true)
                    SetInstructionalButton(CONTROLS["audio_off"]["label"], CONTROLS["audio_off"]["control"], false)
                else
                    SetInstructionalButton(CONTROLS["audio_on"]["label"], CONTROLS["audio_on"]["control"], false)
                    SetInstructionalButton(CONTROLS["audio_off"]["label"], CONTROLS["audio_off"]["control"], true)
                end
                if IsDisabledControlJustPressed(0, CONTROLS["audio_on"]["control"]) then
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                    scannerAudio = not scannerAudio
                end
            end
            if not canProspect then
                -- Ped is busy and can't prospect at this time (like falling or w/e)
                StopEntityAnim(ped, "wood_idle_a", "mini@golfai", true)
                circleScale = 0.0
                scannerScale = 0.0
                scannerState = "none"
            end
            if not isProspecting then
                -- We stopped prospecting mid-frame
                CleanupModels()
                StopEntityAnim(ped, "wood_idle_a", "mini@golfai", true)
                circleScale = 0.0
                scannerScale = 0.0
                scannerState = "none"
            end
        end
        DisableAllInstructions()
        StopProspecting()
    end)

    -- Marker rendering
    -- Audio
    Citizen.CreateThread(function()
        local framecount = 0
        local frametime = 0
        local circleScale = 0.0
        local circleR, circleG, circleB, circleA = 255, 255, 255, 255
        local _circleR, _circleG, _circleB = 255, 255, 255
        local circleScaleMultiplier = 1.5
        local renderCircle = false
        while isProspecting do
            Wait(0)
            if not pauseProspecting then
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped) + vector3(GetEntityForwardX(ped) * 0.75, GetEntityForwardY(ped) * 0.75, -0.75)
                -- local pos = GetWorldPositionOfEntityBone(scannerEntity, 0)
                if scannerState == "none" then
                    renderCircle = false
                    circleR, circleG, circleB = 150, 255, 150
                    _circleR, _circleG, _circleB = 150, 255, 150
                elseif scannerState == "slow" then
                    renderCircle = true
                    circleScale = circleScale + scannerScale
                    circleR, circleG, circleB = 150, 255, 150
                    if frametime > scannerFrametime then
                        frametime = 0.0
                    end
                    -- circleSize = (circleScale % 100) / 100
                    -- circleA = math.floor(255 - ((circleScale % 100) / 100) * 255)
                    -- DrawMarker(1, pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, circleSize, circleSize, 0.1, circleR, circleG, circleB, circleA)
                elseif scannerState == "medium" then
                    renderCircle = true
                    circleScale = circleScale + scannerScale
                    circleR, circleG, circleB = 255, 255, 150
                    if frametime > scannerFrametime then
                        frametime = 0.0
                    end
                    -- circleSize = (circleScale % 100) / 100
                    -- circleA = math.floor(255 - ((circleScale % 100) / 100) * 255)
                    -- DrawMarker(1, pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, circleSize, circleSize, 0.1, circleR, circleG, circleB, circleA)
                elseif scannerState == "fast" then
                    renderCircle = true
                    circleScale = circleScale + scannerScale
                    circleR, circleG, circleB = 255, 150, 150
                    if frametime > scannerFrametime then
                        frametime = 0.0
                    end
                elseif scannerState == "ultra" then
                    renderCircle = false
                    circleScale = circleScale + scannerScale
                    circleR, circleG, circleB = 255, 100, 100
                    if frametime > 0.125 then
                        frametime = 0.0
                        if scannerAudio then PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0) end
                        -- PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 0)
                        if scannerAudio then PlaySoundFrontend(-1, "BOATS_PLANES_HELIS_BOOM", "MP_LOBBY_SOUNDS", 0) end
                    end
                    -- Draw the triple "found it" marker
                    circleA = 150
                    circleSize = 1.20 * circleScaleMultiplier
                    DrawMarker(1, pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, circleSize, circleSize, 0.2, circleR, circleG, circleB, circleA)
                    DrawMarker(6, pos, 0.0, 0.0, 0.0, 270.0, 0.0, 0.0, circleSize, 0.1, circleSize, circleR, circleG, circleB, circleA)
                    circleA = 200
                    circleSize = 0.70 * circleScaleMultiplier
                    DrawMarker(1, pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, circleSize, circleSize, 0.2, circleR, circleG, circleB, circleA)
                    DrawMarker(6, pos, 0.0, 0.0, 0.0, 270.0, 0.0, 0.0, circleSize, 0.1, circleSize, circleR, circleG, circleB, circleA)
                    circleA = 255
                    circleSize = 0.20 * circleScaleMultiplier
                    DrawMarker(1, pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, circleSize, circleSize, 0.2, circleR, circleG, circleB, circleA)
                    DrawMarker(6, pos, 0.0, 0.0, 0.0, 270.0, 0.0, 0.0, circleSize, 0.1, circleSize, circleR, circleG, circleB, circleA)
                end
                if renderCircle then
                    if circleScale > 100 then
                        while circleScale > 100 do
                            circleScale = circleScale - 100
                        end
                        _circleR, _circleG, _circleB = circleR, circleG, circleB
                        -- PlaySoundFrontend(-1, "BOATS_PLANES_HELIS_BOOM", "MP_LOBBY_SOUNDS", 0)
                        if scannerAudio then PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0) end
                    end
                    circleSize = ((circleScale % 100) / 100) * circleScaleMultiplier
                    circleA = math.floor(255 - ((circleScale % 100) / 100) * 155)
                    DrawMarker(1, pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, circleSize, circleSize, 0.2, _circleR, _circleG, _circleB, circleA)
                    DrawMarker(6, pos, 0.0, 0.0, 0.0, 270.0, 0.0, 0.0, circleSize, 0.1, circleSize, _circleR, _circleG, _circleB, circleA)
                end

                framecount = (framecount + 1) % 120
                frametime = frametime + Timestep()
            end
        end
    end)

    -- Location updater
    -- Adds nearby targets to the target pool
    -- Prevents client from doing frame-checks on targets across the map
    Citizen.CreateThread(function()
        while isProspecting do
            local pos = GetEntityCoords(PlayerPedId())
            local newTargets = {}
            for n, target in next, targetPool do
                --if #(pos.xy - target[1].xy) < maxTargetRange then
                    newTargets[#newTargets + 1] = {target[1], target[2], n}
                --end
            end
            targets = newTargets
            Wait(10000)
        end
    end)
    return true
end


-- INSTRUCTIONAL BUTTONS

local instructionals = {}
function SetInstructionalButton(text, control, toggle)
    if toggle then
        if not instructionals[text] then
            instructionals[text] = true
            SetInstructionalButton(text, control, toggle)
        end
    else
        if instructionals[text] then
            instructionals[text] = false
            SetInstructionalButton(text, control, toggle)
        end
    end
end




local function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

local function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

local function setupScaleform(scaleform, data)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    for n, btn in next, data do
        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(n)
        Button(GetControlInstructionalButton(2, btn.control, true))
        ButtonMessage(btn.name)
        PopScaleformMovieFunctionVoid()
    end

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

local form = nil
local data = {}

local entries = {}

function SetInstructions()
    form = setupScaleform("instructional_buttons", entries)
end

function SetInstructionalButton(name, control, enabled)
    local found = false
    for k, entry in next, entries do
        if entry.name == name and entry.control == control then
            found = true
            if not enabled then
                table.remove(entries, k)
                SetInstructions()
            end
            break
        end
    end
    if not found then
        if enabled then
            table.insert(entries, {name = name, control = control})
            SetInstructions()
        end
    end
end

Citizen.CreateThread(function()
    sleep = 500
    while true do
        if isProspecting then
        sleep = 5
        if form then
            DrawScaleformMovieFullscreen(form, 255, 255, 255, 255, 0)
        end
    else
        sleep = 500
    end
        Citizen.Wait(sleep)
    end
end)


-- FRAMEWORK SHIT --

Citizen.CreateThread(function()
    AddTextEntry("Scanning", Config.ProspectingBlipText)
    blip = AddBlipForCoord(blip_location)
    SetBlipSprite(blip, Config.ProspectingBlipSprite)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("Scanning")
    EndTextCommandSetBlipName(blip)
    area_blip = AddBlipForRadius(blip_location, area_size)
    SetBlipSprite(area_blip, 10)
end)

RegisterNetEvent("lcrp-prospecting:startProspecting")
AddEventHandler("lcrp-prospecting:startProspecting", function()
    local pos = GetEntityCoords(PlayerPedId())

    -- Make sure the player is within the prospecting zone before they start
    local dist = #(pos - blip_location)
    if dist < area_size then
        TriggerServerEvent("lcrp-prospecting:activateProspecting")
    else
		scCore.Notification("You are not in a prospecting area!", "error", 5000)
	end
end, false)

RegisterNetEvent("lcrp-prospecting:useDetector")
AddEventHandler("lcrp-prospecting:useDetector", function()
	if IsPedInAnyVehicle(PlayerPedId()) then
		scCore.Notification("You can not prospect from a vehicle!", "error", 5000)
	else
		TriggerEvent("lcrp-prospecting:startProspecting")
	end
end)
