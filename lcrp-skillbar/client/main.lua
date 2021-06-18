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
Skillbar = {}
Skillbar.Data = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if scCore == nil then
            TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

Skillbar.Data = {
    Active = false,
    Data = {},
}
successCb = nil
failCb = nil

RegisterNUICallback('Check', function(data, cb)
    if successCb ~= nil then
        Skillbar.Data.Active = false
        TriggerEvent('progressbar:client:ToggleBusyness', false)
        if data.success then
            successCb()
        else
            failCb()
            SendNUIMessage({
                action = "stop"
            })
        end
    end
end)

Skillbar.Start = function(data, success, fail)
    if not Skillbar.Data.Active then
        Skillbar.Data.Active = true
        if success ~= nil then
            successCb = success
        end
        if fail ~= nil then
            failCb = fail
        end
        Skillbar.Data.Data = data

        SendNUIMessage({
            action = "start",
            duration = data.duration,
            pos = data.pos,
            width = data.width,
        })
        TriggerEvent('progressbar:client:ToggleBusyness', true)
    else
        scCore.Notification('You\'re already doing something', 'error')
    end
end

Skillbar.Repeat = function(data)
    Skillbar.Data.Active = true
    Skillbar.Data.Data = data
    Citizen.CreateThread(function()
        Wait(500)
        SendNUIMessage({
            action = "start",
            duration = Skillbar.Data.Data.duration,
            pos = Skillbar.Data.Data.pos,
            width = Skillbar.Data.Data.width,
        }) 
    end)
end

Citizen.CreateThread(function()
    while true do
        if Skillbar.Data.Active then
            if IsControlJustPressed(0, Keys["E"]) then
                SendNUIMessage({
                    action = "check",
                    data = Skillbar.Data.Data,
                })
            end
        end
        Citizen.Wait(1)
    end
end)

function GetSkillbarObject()
    return Skillbar
end