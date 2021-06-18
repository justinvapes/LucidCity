local gracePeriod = nil
RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    gracePeriod = 30
end)

Citizen.CreateThread(function() 
	while true do
        local cam = GetRenderingCam()
        local playerPed = PlayerPedId()
        if gracePeriod ~= nil and gracePeriod > 0 then
            gracePeriod = gracePeriod - 1
        end
        if cam ~= -1 and gracePeriod ~= nil and gracePeriod <= 0 then
            local camCoord = GetCamCoord(cam)
            local myCoord = GetEntityCoords(PlayerPedId())
            local dist = Vdist(camCoord.x, camCoord.y, camCoord.z, myCoord.x, myCoord.y, myCoord.z)
            if dist > 20 then
                SetCamActive(cam,  false)
                RenderScriptCams(false, false, 0, true, true)
                SetEntityCollision(playerPed, true, true)
                SetEntityVisible(playerPed, true)
            end
        end
		Citizen.Wait(1000)
	end
end)