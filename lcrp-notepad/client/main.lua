Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

scCore = nil
local Notes = {}
local NotesNear = {}
local closestNote = 0
local currentNote = 0
Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

RegisterNetEvent("lcrp-notepad:client:OpenNotepad")
AddEventHandler("lcrp-notepad:client:OpenNotepad", function(noteId, text)
    if currentNote == 0 then
        TriggerEvent('animations:client:EmoteCommandStart', {"notepad"})
        currentNote = noteId
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "open",
            text = text,
            noteid = noteId,
        })
    end
end)

RegisterNetEvent("lcrp-notepad:client:SetActiveStatus")
AddEventHandler("lcrp-notepad:client:SetActiveStatus", function(noteId, status)
    if noteId ~= nil and status ~= nil then
        if Notes[noteId] == nil then Notes[noteId] = {} end
        Notes[noteId].active = status
    end
end)

RegisterNetEvent("lcrp-notepad:client:AddNoteDrop")
AddEventHandler("lcrp-notepad:client:AddNoteDrop", function(noteId, player)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player)))
    local forward = GetEntityForwardVector(GetPlayerPed(-1))
	local x, y, z = table.unpack(coords + forward * 0.5)
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z) < 1 and player ~= GetPlayerServerId(PlayerId()) then return end
    Notes[noteId] = {
        id = noteId,
        coords = {
            x = x,
            y = y,
            z = z - 0.98,
        },
        active = false,
    }
end)

RegisterNetEvent("lcrp-notepad:client:RemoveNote")
AddEventHandler("lcrp-notepad:client:RemoveNote", function(noteId)
    Notes[noteId] = nil
    NotesNear[noteId] = nil
end)

RegisterNUICallback("DropNote", function(data, cb)
    TriggerServerEvent("lcrp-notepad:server:SaveNoteData", data.text, data.noteid)

    TriggerServerEvent("scCore:Server:RemoveItem", "notepad", 1)
end)

RegisterNUICallback("CloseNotepad", function(data, cb)
    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    currentNote = 0
    SetNuiFocus(false, false)
    if data ~= nil and data.noteid ~= nil then
        TriggerServerEvent("lcrp-notepad:server:SetActiveStatus", data.noteid, false)
    end
end)

