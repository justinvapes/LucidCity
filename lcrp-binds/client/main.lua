scCore = nil
myPermissionRank = "user"

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

RegisterNetEvent('lcrp-binds:client:LoadKeybinds')
AddEventHandler('lcrp-binds:client:LoadKeybinds', function(UserGroup)
    myPermissionRank = UserGroup
    LoadKeyBinds()
end)

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        Citizen.Wait(1000)
    
        scCore.TriggerServerCallback('lcrp-scoreboard:server:CheckPermissions', function(UserGroup)
            myPermissionRank = UserGroup
        end)
        LoadKeyBinds()
    end
end)

function LoadKeyBinds()
	RegisterKeybind("control_lockunlock", "[Vehicle] Lock/Unlock", "keyboard", "L")
    RegisterKeybind("control_engine", "[Vehicle] Engine", "keyboard", "")
    RegisterKeybind("control_rollw", "[Vehicle] Roll Window", "keyboard", "")

    RegisterKeybind("control_handsup", "[Animations] Hands Up", "keyboard", "Z")
    RegisterKeybind("control_animationcancel", "[Animations] Stop Animation", "keyboard", "X")

    RegisterKeybind("control_playerlist", "[General] Open Player List", "keyboard", "F10")
    RegisterKeybind("control_steal", "[General] Rob Player", "keyboard", "")
    RegisterKeybind("control_phone", "[General] Open Phone", "keyboard", "M")
    RegisterKeybind("control_fingerpoint", "[General] Point Finger", "keyboard", "B")
    RegisterKeybind("control_voiceRange", "[General] Voice Range", "keyboard", "F11")
    RegisterKeybind("control_resetVoice", "[General] Reset Voice", "keyboard", "")
    RegisterKeybind("control_escort", "[General] Escort", "keyboard", "")
    RegisterKeybind("+control_playerTarget", "[General] Interaction", "keyboard", "E")

    RegisterKeybind("control_pdsoftcuff", "[Police] Soft Cuff", "keyboard", "")
    RegisterKeybind("control_pdhardcuff", "[Police] Hard Cuff", "keyboard", "")
    RegisterKeybind("control_mdt", "[Police] MDT", "keyboard", "")
    RegisterKeybind("control_pdpanic", "[Police] Panic Button", "keyboard", "")

	RegisterKeybind("radar_key_lock", "[Police Radar] Keybind Lock", "keyboard", "")
    RegisterKeybind("radar_bk_cam", "[Police Radar] Plate Reader", "keyboard", "")
    RegisterKeybind("radar_fr_cam", "[Police Radar] Front Plate Reader", "keyboard", "")
	RegisterKeybind("radar_bk_ant", "[Police Radar] Rear Antenna", "keyboard", "")
    RegisterKeybind("radar_fr_ant", "[Police Radar] Front Antenna", "keyboard", "")
	RegisterKeybind("radar_remote", "[Police Radar] Remote Control", "keyboard", "F5")


    RegisterKeybind("control_emsheal", "[EMS] Heal", "keyboard", "")
    RegisterKeybind("control_emsrevive", "[EMS] Revive", "keyboard", "")

    if myPermissionRank == "mod" or myPermissionRank == "admin" or myPermissionRank == "god" then
        RegisterKeybind("control-adminmenu", "[Admin] Menu", "keyboard", "")
        RegisterKeybind("control_tpm", "[Admin] Teleport To Marker", "keyboard", "")
        RegisterKeybind("control_fixveh", "[Admin] Fix Vehicle", "keyboard", "")
        RegisterKeybind("control_adminrevive", "[Admin] Revive", "keyboard", "")
        RegisterKeybind("control_noclip", "[Admin] Noclip", "keyboard", "")
    end
end

function RegisterKeybind(key, keyDesc, type, defaultControl)
    RegisterKeyMapping(key, keyDesc, type, defaultControl)

    TriggerEvent("chat:removeSuggestion", "/" .. key)
end