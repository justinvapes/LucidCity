local inCasino              = false
local videoWallRenderTarget = nil
local showBigWin            = false

--
-- Threads
--

function startCasinoThreads()
    RequestStreamedTextureDict('Prop_Screen_Vinewood')

    while not HasStreamedTextureDictLoaded('Prop_Screen_Vinewood') do
        Citizen.Wait(100)
    end

    RegisterNamedRendertarget('casinoscreen_01')

    LinkNamedRendertarget(`vw_vwint01_video_overlay`)

    videoWallRenderTarget = GetNamedRendertargetRenderId('casinoscreen_01')

    Citizen.CreateThread(function()
        local lastUpdatedTvChannel = 0

        while true do
            Citizen.Wait(0)

            if not inCasino then
                ReleaseNamedRendertarget('casinoscreen_01')

                videoWallRenderTarget = nil
                showBigWin            = false

                break
            end

            if videoWallRenderTarget then
                local currentTime = GetGameTimer()

                if showBigWin then
                    setVideoWallTvChannelWin()

                    lastUpdatedTvChannel = GetGameTimer() - 33666
                    showBigWin           = false
                else
                    if (currentTime - lastUpdatedTvChannel) >= 42666 then
                        setVideoWallTvChannel()

                        lastUpdatedTvChannel = currentTime
                    end
                end

                SetTextRenderId(videoWallRenderTarget)
                SetScriptGfxDrawOrder(4)
                SetScriptGfxDrawBehindPausemenu(true)
                DrawInteractiveSprite('Prop_Screen_Vinewood', 'BG_Wall_Colour_4x4', 0.25, 0.5, 0.5, 1.0, 0.0, 255, 255, 255, 255)
                DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
                SetTextRenderId(GetDefaultScriptRendertargetRenderId())
            end
        end
    end)
end

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        local ply = PlayerPedId()
        if ply ~= nil then
            local plyCoords = GetEntityCoords(ply)
            if plyCoords ~= nil then
                local casinoPoint = vector3(955.68, 36.60, 71.43)
                local distance = #(plyCoords - casinoPoint)
                if distance <= 60 and not inCasino then
                    inCasino = true
                    startCasinoThreads()
                elseif distance > 60 and inCasino then
                    inCasino = false
                end
                Citizen.Wait(1000)
            end
        end
    end
end)

--
-- Functions
--

function setVideoWallTvChannel()
    SetTvChannelPlaylist(0, Config.VideoType, true)
    SetTvAudioFrontend(true)
    SetTvVolume(-100.0)
    SetTvChannel(0)
end

function setVideoWallTvChannelWin()
    SetTvChannelPlaylist(0, 'CASINO_WIN_PL', true)
    SetTvAudioFrontend(true)
    SetTvVolume(-100.0)
    SetTvChannel(-1)
    SetTvChannel(0)
end