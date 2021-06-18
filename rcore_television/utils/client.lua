PlayerData = {}
permissionGroup = 'user'
scCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if scCore == nil then
            TriggerEvent("scCore:GetObject", function(obj)
                scCore = obj
            end)
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded',function() 
    PlayerData = scCore.Functions.GetPlayerData()    
end)

RegisterNetEvent('lcrp-binds:client:LoadKeybinds')
AddEventHandler('lcrp-binds:client:LoadKeybinds', function(UserGroup)
    permissionGroup = UserGroup
end)

RegisterNetEvent('scCore:Client:OnPermissionUpdate')
AddEventHandler('scCore:Client:OnPermissionUpdate', function(UserGroup)
    permissionGroup = UserGroup
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo) 
    PlayerData.job = JobInfo 
end)

function isAtJob(name)
    if name == "staff" then
        print(UserGroup)
        if Config.CinemaPermissions[permissionGroup] then return true end
    elseif PlayerData ~= nil then
        job = PlayerData.job
        if job ~= nil then
            local plyCoords = GetEntityCoords(GetPlayerPed(-1))
            local dist = GetDistanceBetweenCoords(plyCoords,
                                                  Config.AllowChangeTv[job.name])
            print(job.name, name, dist)
            if dist < 40 and job.name == name then
                if job.name == "casinounderground" then
                    if job.grade > 3 then
                        return true
                    else
                        return false
                    end
                end
                return true
            else
                return false
            end
        end
        return false
    else
        return false
    end
end

------------------------
-- Optional to change --
------------------------

function showNotification(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(0, 1)
end

---------------------------------
-- Do not change anything here --
---------------------------------

local cinemaLook = false
local cameras = {}

function createCamera(name, pos, rot, fov)
    fov = fov or 60.0
    rot = rot or vector3(0, 0, 0)
    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y,
                                    pos.z, rot.x, rot.y, rot.z, fov, false, 0)
    local try = 0
    while cam == -1 or cam == nil do
        Citizen.Wait(10)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y,
                                  pos.z, rot.x, rot.y, rot.z, fov, false, 0)
        try = try + 1
        if try > 20 then return nil end
    end
    local self = {}
    self.cam = cam
    self.position = pos
    self.rotation = rot
    self.fov = fov
    self.name = name
    self.lastPointTo = nil
    self.pointTo = function(pos)
        self.lastPointTo = pos
        PointCamAtCoord(self.cam, pos.x, pos.y, pos.z)
    end
    self.render = function()
        SetCamActive(self.cam, true)
        RenderScriptCams(true, true, 1, true, true)
    end
    self.changeCam = function(newCam, duration)
        duration = duration or 3000
        SetCamActiveWithInterp(newCam, self.cam, duration, true, true)
    end
    self.destroy = function()
        SetCamActive(self.cam, false)
        DestroyCam(self.cam)
        cameras[name] = nil
    end
    self.changePosition = function(newPos, newPoint, newRot, duration)
        newRot = newRot or vector3(0, 0, 0)
        duration = duration or 4000
        if IsCamRendering(self.cam) then
            local tempCam = createCamera(string.format('tempCam-%s', self.name),
                                         newPos, newRot, self.fov)
            tempCam.render()
            if self.lastPointTo ~= nil then tempCam.pointTo(newPoint) end
            self.changeCam(tempCam.cam, duration)
            Citizen.Wait(duration)
            self.destroy()
            local newMain = deepCopy(tempCam)
            newMain.name = self.name
            self = newMain
            tempCam.destroy()
        else
            createCamera(self.name, newPos, newRot, self.fov)
        end
    end

    cameras[name] = self
    return self
end

function stopRendering() RenderScriptCams(false, false, 1, false, false) end

function cinematicLook(toggle) cinemaLook = toggle end

function disableControls(toggle) blockInput = toggle end

CreateThread(function()
    while true do
        Wait(5)
        if cinemaLook == true then
            DrawRect(0.5, 0.075, 1.0, 0.15, 0, 0, 0, 255)
            DrawRect(0.5, 0.925, 1.0, 0.15, 0, 0, 0, 255)
            SetDrawOrigin(0.0, 0.0, 0.0, 0)
            DisplayRadar(false)
        else
            Wait(500)
        end
    end
end)
