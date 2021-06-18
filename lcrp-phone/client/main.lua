scCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if scCore == nil then
            TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code

local PlayerJob = {}


phoneMuted = false

PhoneData = {
    MetaData = {},
    isOpen = false,
    PlayerData = nil,
    Contacts = {},
    Tweets = {},
    MentionedTweets = {},
    Hashtags = {},
    Chats = {},
    Invoices = {},
    CallData = {},
    RecentCalls = {},
    Garage = {},
    Mails = {},
    Adverts = {},
    GarageVehicles = {},
    AnimationData = {
        lib = nil,
        anim = nil,
    },
    SuggestedContacts = {},
    CryptoTransactions = {},
    AnonChat = {}
}

RegisterCommand("togglenotifications", function(source, args, rawCommand)
    phoneMuted = not phoneMuted
    if phoneMuted then
        scCore.Notification("You have muted phone notifications")
    else
        scCore.Notification("You have unmuted phone notifications")
    end
end, false)


RegisterNetEvent('lcrp-phone:client:AddRecentCall')
AddEventHandler('lcrp-phone:client:AddRecentCall', function(data, time, type)
    table.insert(PhoneData.RecentCalls, {
        name = IsNumberInContacts(data.number),
        time = time,
        type = type,
        number = data.number,
        anonymous = data.anonymous
    })
    TriggerServerEvent('lcrp-phone:server:SetPhoneAlerts', "phone")
    Config.PhoneApplications["phone"].Alerts = Config.PhoneApplications["phone"].Alerts + 1
    SendNUIMessage({ 
        action = "RefreshAppAlerts",
        AppData = Config.PhoneApplications
    })
end)

RegisterNetEvent('scCore:Client:OnJobUpdate')
AddEventHandler('scCore:Client:OnJobUpdate', function(JobInfo)
    if JobInfo.name == "police" or JobInfo.name == "statepolice" then
        SendNUIMessage({
            action = "UpdateApplications",
            JobData = JobInfo,
            applications = Config.PhoneApplications
        })
    elseif PlayerJob.name == "police" or PlayerJob.name == "statepolice" and JobInfo.name == "unemployed" then
        SendNUIMessage({
            action = "UpdateApplications",
            JobData = JobInfo,
            applications = Config.PhoneApplications
        })
    end

    PlayerJob = JobInfo
end)

RegisterNUICallback('getCoinsValues', function(data, cb)
    scCore.TriggerServerCallback('crypto:getCoinsValues', function(values)
        cb(values)
    end)
end)

RegisterNUICallback('saveNotepad', function(data, cb)
    TriggerServerEvent('lcrp-phone:server:saveNotepad', {id = data.id, name = data.name, string = data.string})
end)

RegisterNUICallback('deleteNotes', function(data, cb)
    TriggerServerEvent('lcrp-phone:server:deleteNotes', data)
end)

RegisterNUICallback('newNote', function(data, cb)
    TriggerServerEvent('lcrp-phone:server:newNote')
end)

RegisterNUICallback('getNotepad', function(data, cb)
    scCore.TriggerServerCallback('lcrp-phone:server:getNotepad', function(data)
        if(data.text ~= true) then
            cb({})
        else
            cb(data.content)
        end
    end)
end)

RegisterNUICallback('getAssetValues', function(data, cb)
    scCore.TriggerServerCallback('crypto:graphValues', function(values)
        if(values ~= nil) then
            local a = {}
            for i = #values, 1, -1 do
                table.insert(a, values[i].value)
            end
            cb(a)
        else
            cb({0,0,0,0,0,0,0,0})
        end
    end, data.name)
end)

RegisterNUICallback('buyAsset', function(data, cb)
    scCore.TriggerServerCallback('crypto:buyStonks', function(stonks)
        cb(stonks)
    end, {value = data.value, name = data.name})
end)

RegisterNUICallback('sellAsset', function(data, cb)
    scCore.TriggerServerCallback('crypto:sellStonks', function(stonks)
        cb(stonks)
    end, {value = data.value, name = data.name})
end)

RegisterNUICallback('getPlayerValues', function(data, cb)
    scCore.TriggerServerCallback('crypto:getPlayerValues', function(plydata)
        cb(plydata)
    end, data.name)
end)

RegisterNUICallback('ClearRecentAlerts', function(data, cb)
    TriggerServerEvent('lcrp-phone:server:SetPhoneAlerts', "phone", 0)
    Config.PhoneApplications["phone"].Alerts = 0
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
end)

RegisterNUICallback('SetBackground', function(data)
    local background = data.background

    PhoneData.MetaData.background = background
    TriggerServerEvent('lcrp-phone:server:SaveMetaData', PhoneData.MetaData)
end)

RegisterNUICallback('GetMissedCalls', function(data, cb)
    cb(PhoneData.RecentCalls)
end)


RegisterNUICallback('GetSuggestedContacts', function(data, cb)
    cb(PhoneData.SuggestedContacts)
end)

function IsNumberInContacts(num)
    local retval = num
    for _, v in pairs(PhoneData.Contacts) do
        if num == v.number then
            retval = v.name
        end
    end
    return retval
end

local isLoggedIn = false

RegisterCommand("control_phone", function()
    if not PhoneData.isOpen then
        local IsHandcuffed = exports['police']:IsHandcuffed()
        if not IsHandcuffed then
            OpenPhone()
            Citizen.Wait(4000)
        else
            scCore.Notification("Action is currently not possible", "error")
        end
    end
end)

function CalculateTimeToDisplay()
	hour = GetClockHours()
    minute = GetClockMinutes()
    
    local obj = {}
    
	if minute <= 9 then
		minute = "0" .. minute
    end
    
    obj.hour = hour
    obj.minute = minute

    return obj
end

Citizen.CreateThread(function()
    while true do
        if PhoneData.isOpen then
            SendNUIMessage({
                action = "UpdateTime",
                InGameTime = CalculateTimeToDisplay(),
            })
        end
        Citizen.Wait(1000)
    end
end)

--[=====[
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)

        if isLoggedIn then
            scCore.TriggerServerCallback('lcrp-phone:server:GetPhoneData', function(pData)   
                if pData.PlayerContacts ~= nil and next(pData.PlayerContacts) ~= nil then 
                    PhoneData.Contacts = pData.PlayerContacts
                end

                SendNUIMessage({
                    action = "RefreshContacts",
                    Contacts = PhoneData.Contacts
                })
            end)
        end
    end
end)
--]=====]

function LoadPhone()
    Citizen.Wait(100)
    isLoggedIn = true
    scCore.TriggerServerCallback('lcrp-phone:server:GetPhoneData', function(pData)
        PlayerJob = scCore.Functions.GetPlayerData().job
        PhoneData.PlayerData = scCore.Functions.GetPlayerData()
        local PhoneMeta = PhoneData.PlayerData.metadata["phone"]
        PhoneData.MetaData = PhoneMeta

        if PhoneMeta.profilepicture == nil then
            PhoneData.MetaData.profilepicture = "default"
        else
            PhoneData.MetaData.profilepicture = PhoneMeta.profilepicture
        end

        if pData.Applications ~= nil and next(pData.Applications) ~= nil then
            for k, v in pairs(pData.Applications) do 
                Config.PhoneApplications[k].Alerts = v 
            end
        end

        if pData.MentionedTweets ~= nil and next(pData.MentionedTweets) ~= nil then 
            PhoneData.MentionedTweets = pData.MentionedTweets 
        end

        if pData.PlayerContacts ~= nil and next(pData.PlayerContacts) ~= nil then 
            PhoneData.Contacts = pData.PlayerContacts
        end
        if pData.Chats ~= nil and next(pData.Chats) ~= nil then
            local Chats = {}
            for k, v in pairs(pData.Chats) do
                Chats[v.number] = {
                    name = IsNumberInContacts(v.number),
                    number = v.number,
                    messages = json.decode(v.messages)
                }
            end

            PhoneData.Chats = Chats
        end

        if pData.Invoices ~= nil and next(pData.Invoices) ~= nil then
            for _, invoice in pairs(pData.Invoices) do
                invoice.name = IsNumberInContacts(invoice.number)
            end
            PhoneData.Invoices = pData.Invoices
        end

        if pData.Hashtags ~= nil and next(pData.Hashtags) ~= nil then
            PhoneData.Hashtags = pData.Hashtags
        end

        if pData.Tweets ~= nil and next(pData.Tweets) ~= nil then
            PhoneData.Tweets = pData.Tweets
        end

        if pData.Mails ~= nil and next(pData.Mails) ~= nil then
            PhoneData.Mails = pData.Mails
        end

        if pData.Adverts ~= nil and next(pData.Adverts) ~= nil then
            PhoneData.Adverts = pData.Adverts
        end

        if pData.CryptoTransactions ~= nil and next(pData.CryptoTransactions) ~= nil then
            PhoneData.CryptoTransactions = pData.CryptoTransactions
        end

        Citizen.Wait(300)
    
        SendNUIMessage({ 
            action = "LoadPhoneData", 
            PhoneData = PhoneData, 
            PlayerData = PhoneData.PlayerData,
            PlayerJob = PhoneData.PlayerData.job,
            applications = Config.PhoneApplications 
        })
    end)
end

Citizen.CreateThread(function()
    Wait(500)
    LoadPhone()
end)

RegisterNetEvent('scCore:Client:OnPlayerUnload')
AddEventHandler('scCore:Client:OnPlayerUnload', function()
    PhoneData = {
        MetaData = {},
        isOpen = false,
        PlayerData = nil,
        Contacts = {},
        Tweets = {},
        MentionedTweets = {},
        Hashtags = {},
        Chats = {},
        Invoices = {},
        CallData = {},
        RecentCalls = {},
        Garage = {},
        Mails = {},
        Adverts = {},
        GarageVehicles = {},
        AnimationData = {
            lib = nil,
            anim = nil,
        },
        SuggestedContacts = {},
        CryptoTransactions = {},
    }

    isLoggedIn = false
end)

RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    LoadPhone()
end)

RegisterNUICallback('HasPhone', function(data, cb)
    scCore.TriggerServerCallback('lcrp-phone:server:HasPhone', function(HasPhone)
        cb(HasPhone.hasphone[1])
    end)
end)

local inAnim = "cellphone_text_in"
local outAnim = "cellphone_text_out"
local idleAnim = "cellphone_text_read_base"
local phoneProp = 0
local phoneModel = "prop_phone_proto"

function newPhoneProp()
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
	RequestModel(phoneModel)
	while not HasModelLoaded(phoneModel) do
		Citizen.Wait(100)
	end
	return CreateObject(phoneModel, 1.0, 1.0, 1.0, 1, 1, 0)
end

function OpenPhone()
    scCore.TriggerServerCallback('lcrp-phone:server:HasPhone', function(HasPhone)
        if HasPhone.hasphone[1] then
            PhoneData.PlayerData = scCore.Functions.GetPlayerData()

            if PhoneData.PlayerData.metadata["isdead"] then
                return
            end
            
            local bone = GetPedBoneIndex(GetPlayerPed(-1), 28422)
            local dict = "cellphone@"
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                dict = dict .. "in_car@ds"
            end
        
            RequestAnimDict(dict)
            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end
        
            TaskPlayAnim(GetPlayerPed(-1), dict, inAnim, 4.0, -1, -1, 50, 0, false, false, false)
            Citizen.Wait(157)
            phoneProp = newPhoneProp()
            AttachEntityToEntity(phoneProp, GetPlayerPed(-1), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)


            SetNuiFocus(true, true)
            SendNUIMessage({
                action = "open",
            })
            PhoneData.isOpen = true
        else
            scCore.Notification("You don't have a phone", "error")
        end
    end)
end

function ClosePhone()
    if not PhoneData.CallData.InCall then

        local dict = "cellphone@"
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            dict = dict .. "in_car@ds"
        end

        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(1)
        end

        StopAnimTask(GetPlayerPed(-1), dict, inAnim, 1.0)
		TaskPlayAnim(GetPlayerPed(-1), dict, outAnim, 5.0, -1, -1, 50, 0, false, false, false)

    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
        DoPhoneAnimation('cellphone_text_to_call')
    end
    Citizen.Wait(700)
	DeleteEntity(phoneProp)
	
    SetNuiFocus(false, false)
    -- SetNuiFocusKeepInput(false)
    SetTimeout(1000, function()
        PhoneData.isOpen = false
    end)
end

RegisterNUICallback('SetupGarageVehicles', function(data, cb)
    scCore.TriggerServerCallback('lcrp-phone:server:GetGarageVehicles', function(vehicles)
        cb(vehicles)
    end)
end)

RegisterNUICallback('getPhoneNumber', function(data, cb)
    cb(scCore.Functions.GetPlayerData().charinfo.phone)
end)

RegisterNUICallback('getPlyData', function(data, cb)
    local plyData = scCore.Functions.GetPlayerData()
    cb(json.encode(plyData))
end)

RegisterNUICallback('getGymData', function(data, cb)
    gymInfo = scCore.Functions.GetPlayerData().metadata.licences.gym
    if(gymInfo ~= nil) then
        scCore.TriggerServerCallback('lcrp-phone:server:getGymExpire', function(info)
            cb({has=true,content=info})
        end, gymInfo)

    else
        cb({has=false})
    end
end)

RegisterNUICallback('getGeneralDetails', function(data, cb)
    local playerData = scCore.Functions.GetPlayerData()
    local owner = false
    if(isOwner(playerData.job.name)) then
        owner = true
        scCore.TriggerServerCallback('lcrp-phone:server:GetSocietyFund', function(info)
            if(info[1].money == -1) then
                cb({isOwner = owner, jobinfo = playerData.job, playername = playerData.charinfo.firstname.." "..playerData.charinfo.lastname, society = playerData.job.label, funds = 0})
            else
                cb({isOwner = owner, jobinfo = playerData.job, playername = playerData.charinfo.firstname.." "..playerData.charinfo.lastname, society = playerData.job.label, funds = info[1].money})
            end
        end, playerData.job.name)
    else
        cb({isOwner = owner, jobinfo = playerData.job, playername = playerData.charinfo.firstname.." "..playerData.charinfo.lastname})
    end
end)

RegisterNUICallback('getMoneyWashDetails', function(data, cb)
    local playercid = scCore.Functions.GetPlayerData().citizenid
    scCore.TriggerServerCallback('lcrp-phone:server:getMoneyWashDetails', function(info)
        cb(info)
    end, playercid)
end)

function isOwner(name)
    local retval = false
    local roles = scCore.Shared.Jobs[name].roles
    highestGrade = 0
    if(roles ~= nil) then
        for k, v in pairs(roles) do
            if k > highestGrade then 
                highestGrade = k
            end
        end
        if PlayerJob.grade == highestGrade then
            retval = true
        else
            retval = false
        end
    end

    return retval
end

RegisterNUICallback('Close', function()
    if not PhoneData.CallData.InCall then
        DoPhoneAnimation('cellphone_text_out')
        SetTimeout(400, function()
            StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
            deletePhone()
            PhoneData.AnimationData.lib = nil
            PhoneData.AnimationData.anim = nil
        end)
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
        DoPhoneAnimation('cellphone_text_to_call')
    end
    SetNuiFocus(false, false)
    -- SetNuiFocusKeepInput(false)
    SetTimeout(1000, function()
        PhoneData.isOpen = false
    end)
end)

RegisterNUICallback('RemoveMail', function(data, cb)
    local MailId = data.mailId

    TriggerServerEvent('lcrp-phone:server:RemoveMail', MailId)
    cb('ok')
end)

RegisterNetEvent('lcrp-phone:client:UpdateMails')
AddEventHandler('lcrp-phone:client:UpdateMails', function(NewMails)
    SendNUIMessage({
        action = "UpdateMails",
        Mails = NewMails
    })
    PhoneData.Mails = NewMails
end)

RegisterNUICallback('AcceptMailButton', function(data)
    TriggerEvent(data.buttonEvent, data.buttonData)
    TriggerServerEvent('lcrp-phone:server:ClearButtonData', data.mailId)
end)

RegisterNUICallback('AddNewContact', function(data, cb)

    for i,v in ipairs(PhoneData.Contacts) do
        if v.number == data.ContactNumber then
            if data.ContactIban ~= nil and v.iban == "" then
                v.name = data.ContactName
                v.number = data.ContactNumber
                v.iban = data.ContactIban
                TriggerServerEvent('lcrp-phone:server:EditContact', data.ContactName, data.ContactNumber, data.ContactIban, v.name, v.number, v.iban)
                return
            else 
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Messages",
                        text = "You already have this contact ",
                        icon = "fas fa-comment-dots",
                        color = "#069de1",
                        timeout = 1500,
                    },
                })
                return
            end
        end
    end
    table.insert(PhoneData.Contacts, {
        name = data.ContactName,
        number = data.ContactNumber,
        iban = data.ContactIban
    })
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    if PhoneData.Chats[data.ContactNumber] ~= nil and next(PhoneData.Chats[data.ContactNumber]) ~= nil then
        PhoneData.Chats[data.ContactNumber].name = data.ContactName
    end
    TriggerServerEvent('lcrp-phone:server:AddNewContact', data.ContactName, data.ContactNumber, data.ContactIban)
end)

RegisterNUICallback('GetMails', function(data, cb)
    cb(PhoneData.Mails)
end)

RegisterNUICallback('GetWhatsappChat', function(data, cb)
    if PhoneData.Chats[data.phone] ~= nil then
        cb(PhoneData.Chats[data.phone])
    else
        cb(false)
    end
end)

RegisterNUICallback('getMailName', function(data, cb)
    cb(scCore.Functions.GetPlayerData().charinfo)
end)

--RegisterNUICallback('GetProfilePicture', function(data, cb)
    --local number = data.number

    --scCore.TriggerServerCallback('lcrp-phone:server:GetPicture', function(picture)
        --cb(picture)
    --end, number)
--end)

RegisterNUICallback('GetBankContacts', function(data, cb)
    cb(PhoneData.Contacts)
end)

RegisterNUICallback('GetInvoices', function(data, cb)
    if PhoneData.Invoices ~= nil and next(PhoneData.Invoices) ~= nil then
        cb(PhoneData.Invoices)
    else
        cb(nil)
    end
end)

function GetKeyByDate(Number, Date)
    local retval = nil
    if PhoneData.Chats[Number] ~= nil then
        if PhoneData.Chats[Number].messages ~= nil then
            for key, chat in pairs(PhoneData.Chats[Number].messages) do
                if chat.date == Date then
                    retval = key
                    break
                end
            end
        end
    end
    return retval
end

function GetKeyByNumber(Number)
    local retval = nil
    if PhoneData.Chats then
        for k, v in pairs(PhoneData.Chats) do
            if v.number == Number then
                retval = k
            end
        end
    end
    return retval
end

function ReorganizeChats(key)
    local ReorganizedChats = {}
    ReorganizedChats[1] = PhoneData.Chats[key]
    for k, chat in pairs(PhoneData.Chats) do
        if k ~= key then
            table.insert(ReorganizedChats, chat)
        end
    end
    PhoneData.Chats = ReorganizedChats
end

RegisterNUICallback('SendMessage', function(data, cb)
    scCore.TriggerServerCallback("lcrp-phone:server:GetServerTime", function(svTime)
        local ChatMessage = checkString(data.ChatMessage)
        local ChatDate = svTime.date
        local ChatNumber = data.ChatNumber
        local ChatTime = svTime.time
        local ChatType = data.ChatType

        local Ped = GetPlayerPed(-1)
        local Pos = GetEntityCoords(Ped)
        local NumberKey = GetKeyByNumber(ChatNumber)
        local ChatKey = GetKeyByDate(NumberKey, ChatDate)

        if PhoneData.Chats[NumberKey] ~= nil then
            if PhoneData.Chats[NumberKey].messages[ChatKey] ~= nil then
                if ChatType == "message" then
                    table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                        message = ChatMessage,
                        time = ChatTime,
                        sender = PhoneData.PlayerData.citizenid,
                        type = ChatType,
                        data = {},
                    })
                elseif ChatType == "location" then
                    table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                        message = "Shared location",
                        time = ChatTime,
                        sender = PhoneData.PlayerData.citizenid,
                        type = ChatType,
                        data = {
                            x = Pos.x,
                            y = Pos.y,
                        },
                    })
                end
                TriggerServerEvent('lcrp-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber)
                NumberKey = GetKeyByNumber(ChatNumber)
                ReorganizeChats(NumberKey)
            else
                table.insert(PhoneData.Chats[NumberKey].messages, {
                    date = ChatDate,
                    messages = {},
                })
                ChatKey = GetKeyByDate(NumberKey, ChatDate)
                if ChatType == "message" then
                    table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                        message = ChatMessage,
                        time = ChatTime,
                        sender = PhoneData.PlayerData.citizenid,
                        type = ChatType,
                        data = {},
                    })
                elseif ChatType == "location" then
                    table.insert(PhoneData.Chats[NumberKey].messages[ChatDate].messages, {
                        message = "Shared location",
                        time = ChatTime,
                        sender = PhoneData.PlayerData.citizenid,
                        type = ChatType,
                        data = {
                            x = Pos.x,
                            y = Pos.y,
                        },
                    })
                end
                TriggerServerEvent('lcrp-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber)
                NumberKey = GetKeyByNumber(ChatNumber)
                ReorganizeChats(NumberKey)
            end
        else
            table.insert(PhoneData.Chats, {
                name = IsNumberInContacts(ChatNumber),
                number = ChatNumber,
                messages = {},
            })
            NumberKey = GetKeyByNumber(ChatNumber)
            table.insert(PhoneData.Chats[NumberKey].messages, {
                date = ChatDate,
                messages = {},
            })
            ChatKey = GetKeyByDate(NumberKey, ChatDate)
            if ChatType == "message" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = ChatMessage,
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {},
                })
            elseif ChatType == "location" then
                table.insert(PhoneData.Chats[NumberKey].messages[ChatKey].messages, {
                    message = "Shared Location",
                    time = ChatTime,
                    sender = PhoneData.PlayerData.citizenid,
                    type = ChatType,
                    data = {
                        x = Pos.x,
                        y = Pos.y,
                    },
                })
            end
            TriggerServerEvent('lcrp-phone:server:UpdateMessages', PhoneData.Chats[NumberKey].messages, ChatNumber)
            NumberKey = GetKeyByNumber(ChatNumber)
            ReorganizeChats(NumberKey)
        end

        scCore.TriggerServerCallback('lcrp-phone:server:GetContactPicture', function(Chat)
            SendNUIMessage({
                action = "UpdateChat",
                chatData = Chat,
                chatNumber = ChatNumber,
            })
        end,  PhoneData.Chats[GetKeyByNumber(ChatNumber)])
    end)
end)

RegisterNUICallback('SharedLocation', function(data)
    local x = data.coords.x
    local y = data.coords.y

    SetNewWaypoint(x, y)
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = "Messages",
            text = "Location set!",
            icon = "fas fa-comment-dots",
            color = "#069de1",
            timeout = 1500,
        },
    })
end)

RegisterNetEvent('lcrp-phone:client:UpdateMessages')
AddEventHandler('lcrp-phone:client:UpdateMessages', function(ChatMessages, SenderNumber, New)
    local NumberKey = GetKeyByNumber(SenderNumber)
    if NumberKey == nil then NumberKey = SenderNumber end
    if New then
        PhoneData.Chats[NumberKey] = {
            name = IsNumberInContacts(SenderNumber),
            number = SenderNumber,
            messages = ChatMessages
        }

        if PhoneData.Chats[NumberKey].Unread ~= nil then
            PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
        else
            PhoneData.Chats[NumberKey].Unread = 1
        end

        if PhoneData.isOpen then
            if SenderNumber ~= PhoneData.PlayerData.charinfo.phone then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Messages",
                        text = "New message from "..IsNumberInContacts(SenderNumber).."!",
                        icon = "fas fa-comment-dots",
                        color = "#069de1",
                        timeout = 1500,
                    },
                })
            else
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Messages",
                        text = "Why are you sending messages to yourself?",
                        icon = "fas fa-comment-dots",
                        color = "#069de1",
                        timeout = 4000,
                    },
                })
            end

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)

            Wait(100)
            scCore.TriggerServerCallback('lcrp-phone:server:GetContactPictures', function(Chats)
                SendNUIMessage({
                    action = "UpdateChat",
                    chatData = Chats[GetKeyByNumber(SenderNumber)],
                    chatNumber = SenderNumber,
                    Chats = Chats,
                })
            end,  PhoneData.Chats)
        else
            SendNUIMessage({
                action = "Notification",
                NotifyData = {
                    title = "Messages", 
                    content = "You have received a new message from "..IsNumberInContacts(SenderNumber).."!", 
                    icon = "fas fa-comment-dots", 
                    timeout = 3500, 
                    color = "#069de1",
                    isMuted = phoneMuted
                },
            })
            Config.PhoneApplications['Messages'].Alerts = Config.PhoneApplications['Messages'].Alerts + 1
            TriggerServerEvent('lcrp-phone:server:SetPhoneAlerts', "Messages")
        end
    else
        PhoneData.Chats[NumberKey].messages = ChatMessages

        if PhoneData.Chats[NumberKey].Unread ~= nil then
            PhoneData.Chats[NumberKey].Unread = PhoneData.Chats[NumberKey].Unread + 1
        else
            PhoneData.Chats[NumberKey].Unread = 1
        end

        if PhoneData.isOpen then
            if SenderNumber ~= PhoneData.PlayerData.charinfo.phone then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Messages",
                        text = "New message from "..IsNumberInContacts(SenderNumber).."!",
                        icon = "fas fa-comment-dots",
                        color = "#069de1",
                        timeout = 1500,
                    },
                })
            else
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Messages",
                        text = "Sending messages to yourself? Go find friends",
                        icon = "fas fa-comment-dots",
                        color = "#069de1",
                        timeout = 4000,
                    },
                })
            end

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)
            
            Wait(100)
            scCore.TriggerServerCallback('lcrp-phone:server:GetContactPictures', function(Chats)
                SendNUIMessage({
                    action = "UpdateChat",
                    chatData = Chats[GetKeyByNumber(SenderNumber)],
                    chatNumber = SenderNumber,
                    Chats = Chats,
                })
            end,  PhoneData.Chats)
        else
            SendNUIMessage({
                action = "Notification",
                NotifyData = {
                    title = "Messages", 
                    content = "You have received a new message from "..IsNumberInContacts(SenderNumber).."!", 
                    icon = "fas fa-comment-dots", 
                    timeout = 3500, 
                    color = "#069de1",
                    isMuted = phoneMuted
                },
            })

            NumberKey = GetKeyByNumber(SenderNumber)
            ReorganizeChats(NumberKey)

            Config.PhoneApplications['Messages'].Alerts = Config.PhoneApplications['Messages'].Alerts + 1
            TriggerServerEvent('lcrp-phone:server:SetPhoneAlerts', "Messages")
        end
    end
end)

RegisterNetEvent("lcrp-phone-new:client:BankNotify")
AddEventHandler("lcrp-phone-new:client:BankNotify", function(text)
    SendNUIMessage({
        action = "Notification",
        NotifyData = {
            title = "Bank", 
            content = text, 
            icon = "fas fa-university", 
            timeout = 3500, 
            color = "#ff002f"
        },
    })
end)

RegisterNetEvent('lcrp-phone:client:NewMailNotify')
AddEventHandler('lcrp-phone:client:NewMailNotify', function(MailData)
    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Mail",
                text = "You have received a new Mail from "..MailData.sender,
                icon = "fas fa-envelope",
                color = "#ff002f",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Mail", 
                content = "You have received a new Mail from "..MailData.sender, 
                icon = "fas fa-envelope", 
                timeout = 3500, 
                color = "#ff002f",
                isMuted = phoneMuted
            },
        })
    end
    Config.PhoneApplications['mail'].Alerts = Config.PhoneApplications['mail'].Alerts + 1
    TriggerServerEvent('lcrp-phone:server:SetPhoneAlerts', "mail")
end)

RegisterNUICallback('PostAdvert', function(data)
    TriggerServerEvent('lcrp-phone:server:AddAdvert', data.message)
end)

RegisterNetEvent('lcrp-phone:client:UpdateAdverts')
AddEventHandler('lcrp-phone:client:UpdateAdverts', function(Adverts, LastAd)
    PhoneData.Adverts = Adverts

    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Advert",
                text = LastAd,
                icon = "fas fa-ad",
                color = "#ff8f1a",
                timeout = 2500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Advert", 
                content = LastAd,
                icon = "fas fa-ad", 
                timeout = 2500, 
                color = "#ff8f1a",
                isMuted = phoneMuted
            },
        })
    end

    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
end)

RegisterNUICallback('LoadAdverts', function()
    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
end)

RegisterNUICallback('ClearAlerts', function(data, cb)
    local chat = data.number
    local ChatKey = GetKeyByNumber(chat)

    if PhoneData.Chats[ChatKey].Unread ~= nil then
        local newAlerts = (Config.PhoneApplications['Messages'].Alerts - PhoneData.Chats[ChatKey].Unread)
        Config.PhoneApplications['Messages'].Alerts = newAlerts
        TriggerServerEvent('lcrp-phone:server:SetPhoneAlerts', "Messages", newAlerts)

        PhoneData.Chats[ChatKey].Unread = 0

        SendNUIMessage({
            action = "RefreshWhatsappAlerts",
            Chats = PhoneData.Chats,
        })
        SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    end
end)

RegisterNUICallback('PayInvoice', function(data, cb)
    local sender = data.sender
    local amount = data.amount
    local invoiceId = data.invoiceId

    scCore.TriggerServerCallback('lcrp-phone:server:PayInvoice', function(CanPay, Invoices)
        if CanPay then PhoneData.Invoices = Invoices end
        cb(CanPay)
    end, sender, amount, invoiceId)
end)

RegisterNUICallback('DeclineInvoice', function(data, cb)
    local sender = data.sender
    local amount = data.amount
    local invoiceId = data.invoiceId

    scCore.TriggerServerCallback('lcrp-phone:server:DeclineInvoice', function(CanPay, Invoices)
        PhoneData.Invoices = Invoices
        cb('ok')
    end, sender, amount, invoiceId)
end)

RegisterNUICallback('EditContact', function(data, cb)
    local NewName = data.CurrentContactName
    local NewNumber = data.CurrentContactNumber
    local NewIban = data.CurrentContactIban
    local OldName = data.OldContactName
    local OldNumber = data.OldContactNumber
    local OldIban = data.OldContactIban

    for k, v in pairs(PhoneData.Contacts) do
        if v.name == OldName and v.number == OldNumber then
            v.name = NewName
            v.number = NewNumber
            v.iban = NewIban
        end
    end
    if PhoneData.Chats[NewNumber] ~= nil and next(PhoneData.Chats[NewNumber]) ~= nil then
        PhoneData.Chats[NewNumber].name = NewName
    end
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    TriggerServerEvent('lcrp-phone:server:EditContact', NewName, NewNumber, NewIban, OldName, OldNumber, OldIban)
end)

local function escape_str(s)
	-- local in_char  = {'\\', '"', '/', '\b', '\f', '\n', '\r', '\t'}
	-- local out_char = {'\\', '"', '/',  'b',  'f',  'n',  'r',  't'}
	-- for i, c in ipairs(in_char) do
	--   s = s:gsub(c, '\\' .. out_char[i])
	-- end
	return s
end

function GenerateTweetId()
    local tweetId = "TWEET-"..math.random(11111111, 99999999)
    return tweetId
end

RegisterNetEvent('lcrp-phone:client:UpdateHashtags')
AddEventHandler('lcrp-phone:client:UpdateHashtags', function(Handle, msgData)
    if PhoneData.Hashtags[Handle] ~= nil then
        table.insert(PhoneData.Hashtags[Handle].messages, msgData)
    else
        PhoneData.Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        table.insert(PhoneData.Hashtags[Handle].messages, msgData)
    end

    SendNUIMessage({
        action = "UpdateHashtags",
        Hashtags = PhoneData.Hashtags,
    })
end)

RegisterNUICallback('GetHashtagMessages', function(data, cb)
    if PhoneData.Hashtags[data.hashtag] ~= nil and next(PhoneData.Hashtags[data.hashtag]) ~= nil then
        cb(PhoneData.Hashtags[data.hashtag])
    else
        cb(nil)
    end
end)

RegisterNUICallback('GetTweets', function(data, cb)
    cb(PhoneData.Tweets)
end)

RegisterNUICallback('UpdateProfilePicture', function(data)
    local pf = data.profilepicture

    PhoneData.MetaData.profilepicture = pf
    
    TriggerServerEvent('lcrp-phone:server:SaveMetaData', PhoneData.MetaData)
end)

local patt = "[?!@#]"

function checkString(msg)
    local nono = {"<",">"}
    if type(msg) == "string" then
        for i = 1, #msg do
            for j = 1, #nono do
                local c = string.sub(msg,i,i)
                if c == nono[j] then 
                    msg = msg:gsub(c, "")
                end
                
            end
        end
    end
    return msg
end



RegisterNUICallback('PostNewTweet', function(data, cb)
    data.Message = checkString(data.Message)
    data.Date = checkString(data.Date)
    data.Picture = checkString(data.Picture)
    local TweetMessage = {
        firstName = PhoneData.PlayerData.charinfo.firstname,
        lastName = PhoneData.PlayerData.charinfo.lastname,
        message = escape_str(data.Message),
        time = data.Date,
        tweetId = GenerateTweetId(),
        picture = data.Picture
    }
    
    local TwitterMessage = data.Message
    
    local MentionTag = TwitterMessage:split("@")
    local Hashtag = TwitterMessage:split("#")

    for i = 2, #Hashtag, 1 do
        local Handle = Hashtag[i]:split(" ")[1]
        if Handle ~= nil or Handle ~= "" then
            local InvalidSymbol = string.match(Handle, patt)
            if InvalidSymbol then
                Handle = Handle:gsub("%"..InvalidSymbol, "")
            end
            TriggerServerEvent('lcrp-phone:server:UpdateHashtags', Handle, TweetMessage)
        end
    end

    for i = 2, #MentionTag, 1 do
        local Handle = MentionTag[i]:split(" ")[1]
        if Handle ~= nil or Handle ~= "" then
            local Fullname = Handle:split("_")
            local Firstname = Fullname[1]
            table.remove(Fullname, 1)
            local Lastname = table.concat(Fullname, " ")

            if (Firstname ~= nil and Firstname ~= "") and (Lastname ~= nil and Lastname ~= "") then
                if Firstname ~= PhoneData.PlayerData.charinfo.firstname and Lastname ~= PhoneData.PlayerData.charinfo.lastname then
                    TriggerServerEvent('lcrp-phone:server:MentionedPlayer', Firstname, Lastname, TweetMessage)
                else
                    SetTimeout(2500, function()
                        SendNUIMessage({
                            action = "PhoneNotification",
                            PhoneNotify = {
                                title = "Twitter", 
                                text = "You cannot mention yourself!", 
                                icon = "fab fa-twitter",
                                color = "#1DA1F2",
                            },
                        })
                    end)
                end
            end
        end
    end
    table.insert(PhoneData.Tweets, TweetMessage)
    Citizen.Wait(100)
    cb(PhoneData.Tweets)

    TriggerServerEvent('lcrp-phone:server:UpdateTweets', PhoneData.Tweets, TweetMessage)
end)

RegisterNetEvent('lcrp-phone:client:TransferMoney')
AddEventHandler('lcrp-phone:client:TransferMoney', function(amount, newmoney)
    PhoneData.PlayerData.money.bank = newmoney
    if PhoneData.isOpen then
        SendNUIMessage({ action = "PhoneNotification", PhoneNotify = { title = "Bank", text = "&dollar;"..amount.." credited!", icon = "fas fa-university", color = "#8c7ae6", }, })
        SendNUIMessage({ action = "UpdateBank", NewBalance = PhoneData.PlayerData.money.bank })
    else
        SendNUIMessage({ action = "Notification", NotifyData = { title = "Bank", content = "&dollar;"..amount.." credited!", icon = "fas fa-university", timeout = 2500, color = nil, }, })
    end
end)

RegisterNetEvent('lcrp-phone:client:UpdateTweets')
AddEventHandler('lcrp-phone:client:UpdateTweets', function(src, Tweets, NewTweetData)
    PhoneData.Tweets = Tweets
    if NewTweetData ~= nil then
        if PhoneData.PlayerData ~= nil then
            local MyPlayerId = PhoneData.PlayerData.source
            if src ~= MyPlayerId then
                if not PhoneData.isOpen then
                    SendNUIMessage({
                        action = "Notification",
                        NotifyData = {
                            title = "@"..NewTweetData.firstName.." "..NewTweetData.lastName,
                            content = NewTweetData.message, 
                            icon = "fab fa-twitter", 
                            timeout = 3500,
                            color = "#1DA0F2",
                            isMuted = phoneMuted
                        },
                    })
                else
                    SendNUIMessage({
                        action = "PhoneNotification",
                        PhoneNotify = {
                            title = "@"..NewTweetData.firstName.." "..NewTweetData.lastName,
                            text = NewTweetData.message, 
                            icon = "fab fa-twitter",
                            color = "#1DA1F2",
                        },
                    })
                end
            else
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Twitter",
                        text = "The tweet has been posted!",
                        icon = "fab fa-twitter",
                        color = "#1DA1F2",
                        timeout = 1000,
                    },
                })
            end
        end
    end
end)

--Anon Chat Client--
RegisterNetEvent('lcrp-phone:client:UpdateAnonChat')
AddEventHandler('lcrp-phone:client:UpdateAnonChat', function(src, newAnonChat)
    PhoneData.AnonChat = newAnonChat
    SendNUIMessage({
        action = "UpdateAnonChat",
        AnonChat = newAnonChat,
    })
end)

RegisterNUICallback('PostNewAnonChatMessage', function(data, cb)
    TriggerServerEvent('lcrp-phone:server:PostAnonChat', data)
end)

RegisterNUICallback('getAnonChat', function(data, cb)
    Citizen.Wait(100)
    TriggerServerEvent('lcrp-phone:server:GetAnonChat')
    cb(json.encode(PhoneData.AnonChat))
end)

--End of Anon Chat Client

RegisterNUICallback('GetMentionedTweets', function(data, cb)
    cb(PhoneData.MentionedTweets)
end)

RegisterNUICallback('GetHashtags', function(data, cb)
    if PhoneData.Hashtags ~= nil and next(PhoneData.Hashtags) ~= nil then
        cb(PhoneData.Hashtags)
    else
        cb(nil)
    end
end)



RegisterNetEvent('lcrp-phone:client:GetMentioned')
AddEventHandler('lcrp-phone:client:GetMentioned', function(TweetMessage, AppAlerts)
    Config.PhoneApplications["twitter"].Alerts = AppAlerts
    if not PhoneData.isOpen then
        SendNUIMessage({ action = "Notification", NotifyData = { title = "You are mentioned in a Tweet above!", content = TweetMessage.message, icon = "fab fa-twitter", timeout = 3500, color = nil, isMuted = phoneMuted }, })
    else
        SendNUIMessage({ action = "PhoneNotification", PhoneNotify = { title = "You are mentioned in a Tweet!", text = TweetMessage.message, icon = "fab fa-twitter", color = "#1DA1F2", }, })
    end
    local TweetMessage = {firstName = TweetMessage.firstName, lastName = TweetMessage.lastName, message = escape_str(TweetMessage.message), time = TweetMessage.time, picture = TweetMessage.picture}
    table.insert(PhoneData.MentionedTweets, TweetMessage)
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    SendNUIMessage({ action = "UpdateMentionedTweets", Tweets = PhoneData.MentionedTweets })
end)

RegisterNUICallback('ClearMentions', function()
    Config.PhoneApplications["twitter"].Alerts = 0
    SendNUIMessage({
        action = "RefreshAppAlerts",
        AppData = Config.PhoneApplications
    })
    TriggerServerEvent('lcrp-phone:server:SetPhoneAlerts', "twitter", 0)
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
end)

RegisterNUICallback('ClearGeneralAlerts', function(data)
    SetTimeout(400, function()
        Config.PhoneApplications[data.app].Alerts = 0
        SendNUIMessage({
            action = "RefreshAppAlerts",
            AppData = Config.PhoneApplications
        })
        TriggerServerEvent('lcrp-phone:server:SetPhoneAlerts', data.app, 0)
        SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
    end)
end)

function string:split(delimiter)
    local result = { }
    local from  = 1
    local delim_from, delim_to = string.find( self, delimiter, from  )
    while delim_from do
      table.insert( result, string.sub( self, from , delim_from-1 ) )
      from  = delim_to + 1
      delim_from, delim_to = string.find( self, delimiter, from  )
    end
    table.insert( result, string.sub( self, from  ) )
    return result
end

RegisterNUICallback('TransferMoney', function(data, cb)
    data.amount = tonumber(data.amount)
    if tonumber(PhoneData.PlayerData.money.bank) >= data.amount then
        local amaountata = PhoneData.PlayerData.money.bank - data.amount
        TriggerServerEvent('lcrp-phone:server:TransferMoney', data.iban, data.amount)
        local cbdata = {
            CanTransfer = true,
            NewAmount = amaountata 
        }
        cb(cbdata)
    else
        local cbdata = {
            CanTransfer = false,
            NewAmount = nil,
        }
        cb(cbdata)
    end
end)

RegisterNUICallback('GetWhatsappChats', function(data, cb)
    scCore.TriggerServerCallback('lcrp-phone:server:GetContactPictures', function(Chats)
        cb(Chats)
    end, PhoneData.Chats)
end)

RegisterNUICallback('CallContact', function(data, cb)
    scCore.TriggerServerCallback('lcrp-phone:server:GetCallState', function(CanCall, IsOnline)
        local status = { 
            CanCall = CanCall, 
            IsOnline = IsOnline,
            InCall = PhoneData.CallData.InCall,
        }
        cb(status)
        if CanCall and not status.InCall and (data.ContactData.number ~= PhoneData.PlayerData.charinfo.phone) then
            CallContact(data.ContactData, data.Anonymous)
        end
    end, data.ContactData)
end)

function GenerateCallId(caller, target)
    local CallId = math.ceil(((tonumber(caller) + tonumber(target)) / 100 * 1))
    return CallId
end

CallContact = function(CallData, AnonymousCall)
    local RepeatCount = 0
    PhoneData.CallData.CallType = "outgoing"
    PhoneData.CallData.InCall = true
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.CallId = GenerateCallId(PhoneData.PlayerData.charinfo.phone, CallData.number)


    TriggerServerEvent('lcrp-phone:server:CallContact', PhoneData.CallData.TargetData, PhoneData.CallData.CallId, AnonymousCall)
    TriggerServerEvent('lcrp-phone:server:SetCallState', true)
    
    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                if PhoneData.CallData.InCall then
                    RepeatCount = RepeatCount + 1
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "demo", 0.1)
                else
                    break
                end
                Citizen.Wait(Config.RepeatTimeout)
            else
                CancelCall()
                break
            end
        else
            break
        end
    end
end

CancelCall = function()
    TriggerServerEvent('lcrp-phone:server:CancelCall', PhoneData.CallData)
    if PhoneData.CallData.CallType == "ongoing" then
        exports["pma-voice"]:setCallChannel(0)
    end
    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}
    PhoneData.CallData.CallId = nil

    if not PhoneData.isOpen then
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end

    TriggerServerEvent('lcrp-phone:server:SetCallState', false)

    if not PhoneData.isOpen then
        SendNUIMessage({ 
            action = "Notification", 
            NotifyData = { 
                title = "Phone",
                content = "The call has ended", 
                icon = "fas fa-phone", 
                timeout = 3500, 
                color = "#e84118"
            }, 
        })            
    else
        SendNUIMessage({ 
            action = "PhoneNotification", 
            PhoneNotify = { 
                title = "Phone", 
                text = "The call has ended", 
                icon = "fas fa-phone", 
                color = "#e84118", 
            }, 
        })

        SendNUIMessage({
            action = "SetupHomeCall",
            CallData = PhoneData.CallData,
        })

        SendNUIMessage({
            action = "CancelOutgoingCall",
        })
    end
end

RegisterNetEvent('lcrp-phone:client:CancelCall')
AddEventHandler('lcrp-phone:client:CancelCall', function()
    if PhoneData.CallData.CallType == "ongoing" then
        SendNUIMessage({
            action = "CancelOngoingCall"
        })
        exports["pma-voice"]:setCallChannel(0)
    end
    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}

    if not PhoneData.isOpen then
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end

    TriggerServerEvent('lcrp-phone:server:SetCallState', false)

    if not PhoneData.isOpen then
        SendNUIMessage({ 
            action = "Notification", 
            NotifyData = { 
                title = "Phone",
                content = "The call has ended", 
                icon = "fas fa-phone", 
                timeout = 3500, 
                color = "#e84118",
            }, 
        })            
    else
        SendNUIMessage({ 
            action = "PhoneNotification", 
            PhoneNotify = { 
                title = "Phone", 
                text = "The call has ended", 
                icon = "fas fa-phone", 
                color = "#e84118", 
            }, 
        })

        SendNUIMessage({
            action = "SetupHomeCall",
            CallData = PhoneData.CallData,
        })

        SendNUIMessage({
            action = "CancelOutgoingCall",
        })
    end
end)

RegisterNetEvent('lcrp-phone:client:GetCalled')
AddEventHandler('lcrp-phone:client:GetCalled', function(CallerNumber, CallId, AnonymousCall)
    local RepeatCount = 0
    local CallData = {
        number = CallerNumber,
        name = IsNumberInContacts(CallerNumber),
        anonymous = AnonymousCall
    }


    if AnonymousCall then
        CallData.name = "Anonymous"
    end

    PhoneData.CallData.CallType = "incoming"
    PhoneData.CallData.InCall = true
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.CallId = CallId

    TriggerServerEvent('lcrp-phone:server:SetCallState', true)
    SendNUIMessage({
        action = "SetupHomeCall",
        CallData = PhoneData.CallData,
    })

    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                if PhoneData.CallData.InCall then
                    RepeatCount = RepeatCount + 1
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "ringing", 0.2)

                    if not PhoneData.isOpen then
                        SendNUIMessage({
                            action = "IncomingCallAlert",
                            CallData = PhoneData.CallData.TargetData,
                            Canceled = false,
                            AnonymousCall = AnonymousCall,
                        })
                    end
                else
                    SendNUIMessage({
                        action = "IncomingCallAlert",
                        CallData = PhoneData.CallData.TargetData,
                        Canceled = true,
                        AnonymousCall = AnonymousCall,
                    })
                    TriggerServerEvent('lcrp-phone:server:AddRecentCall', "missed", CallData)
                    break
                end
                Citizen.Wait(Config.RepeatTimeout)
            else
                SendNUIMessage({
                    action = "IncomingCallAlert",
                    CallData = PhoneData.CallData.TargetData,
                    Canceled = true,
                    AnonymousCall = AnonymousCall,
                })
                TriggerServerEvent('lcrp-phone:server:AddRecentCall', "missed", CallData)
                break
            end
        else
            TriggerServerEvent('lcrp-phone:server:AddRecentCall', "missed", CallData)
            break
        end
    end
end)

RegisterNUICallback('CancelOutgoingCall', function()
    CancelCall()
end)

RegisterNUICallback('DenyIncomingCall', function()
    CancelCall()
end)

RegisterNUICallback('CancelOngoingCall', function()
    CancelCall()
end)

RegisterNUICallback('AnswerCall', function()
    AnswerCall()
end)

function AnswerCall()
    if (PhoneData.CallData.CallType == "incoming" or PhoneData.CallData.CallType == "outgoing") and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = "ongoing"
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0

        SendNUIMessage({ action = "AnswerCall", CallData = PhoneData.CallData})
        SendNUIMessage({ action = "SetupHomeCall", CallData = PhoneData.CallData})

        TriggerServerEvent('lcrp-phone:server:SetCallState', true)

        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end

        Citizen.CreateThread(function()
            while true do
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = "UpdateCallTime",
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end

                Citizen.Wait(1000)
            end
        end)

        TriggerServerEvent('lcrp-phone:server:AnswerCall', PhoneData.CallData)

        exports["pma-voice"]:setCallChannel(PhoneData.CallData.CallId + 1)

    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false

        SendNUIMessage({ 
            action = "PhoneNotification", 
            PhoneNotify = { 
                title = "Phone", 
                text = "You have no incoming call...", 
                icon = "fas fa-phone", 
                color = "#e84118", 
            }, 
        })
    end
end

RegisterNetEvent('lcrp-phone:client:AnswerCall')
AddEventHandler('lcrp-phone:client:AnswerCall', function()
    if (PhoneData.CallData.CallType == "incoming" or PhoneData.CallData.CallType == "outgoing") and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = "ongoing"
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0

        SendNUIMessage({ action = "AnswerCall", CallData = PhoneData.CallData})
        SendNUIMessage({ action = "SetupHomeCall", CallData = PhoneData.CallData})

        TriggerServerEvent('lcrp-phone:server:SetCallState', true)

        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end

        Citizen.CreateThread(function()
            while true do
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = "UpdateCallTime",
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end

                Citizen.Wait(1000)
            end
        end)

        exports["pma-voice"]:setCallChannel(PhoneData.CallData.CallId + 1)
    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false

        SendNUIMessage({ 
            action = "PhoneNotification", 
            PhoneNotify = { 
                title = "Phone", 
                text = "You have no incoming call...", 
                icon = "fas fa-phone", 
                color = "#e84118", 
            }, 
        })
    end
end)

-- AddEventHandler('onResourceStop', function(resource)
--     if resource == GetCurrentResourceName() then
--         -- SetNuiFocus(false, false)
--     end
-- end)

--[=====[
RegisterNUICallback('FetchSearchResults', function(data, cb)
    scCore.TriggerServerCallback('lcrp-phone:server:FetchResult', function(result)
        print('test')
        cb(result)
    end, data.input)
end)

RegisterNUICallback('FetchVehicleResults', function(data, cb)
    scCore.TriggerServerCallback('lcrp-phone:server:GetVehicleSearchResults', function(result)
        if result ~= nil then 
            for k, v in pairs(result) do
                scCore.TriggerServerCallback('police:IsPlateFlagged', function(flagged)
                    result[k].isFlagged = flagged
                end, result[k].plate)
                Citizen.Wait(50)
            end
        end
        cb(result)
    end, data.input)
end)

RegisterNUICallback('FetchVehicleScan', function(data, cb)
    local vehicle = scCore.Functions.GetClosestVehicle()
    local plate = GetVehicleNumberPlateText(vehicle)
    local model = GetEntityModel(vehicle)

    scCore.TriggerServerCallback('lcrp-phone:server:ScanPlate', function(result)
        scCore.TriggerServerCallback('police:IsPlateFlagged', function(flagged)
            result.isFlagged = flagged
            local vehicleInfo = scCore.Shared.Vehicles[scCore.Shared.VehicleModels[model]["model"]] ~= nil and scCore.Shared.Vehicles[scCore.Shared.VehicleModels[model]["model"]] or {["brand"] = "Brand..", ["name"] = ""}
            result.label = vehicleInfo["name"]
            cb(result)
        end, plate)
    end, plate)
end) --]=====]

RegisterNetEvent('lcrp-phone:client:addPoliceAlert')
AddEventHandler('lcrp-phone:client:addPoliceAlert', function(alertData)
    if PlayerJob.name == 'police' and PlayerJob.onduty then
        SendNUIMessage({
            action = "AddPoliceAlert",
            alert = alertData,
        })
    end
end)

RegisterNUICallback('SetAlertWaypoint', function(data)
    local coords = data.alert.coords

    scCore.Notification('GPS Location: '..data.alert.title)
    SetNewWaypoint(coords.x, coords.y)
end)

RegisterNUICallback('RemoveSuggestion', function(data, cb)
    local data = data.data

    if PhoneData.SuggestedContacts ~= nil and next(PhoneData.SuggestedContacts) ~= nil then
        for k, v in pairs(PhoneData.SuggestedContacts) do
            if (data.name[1] == v.name[1] and data.name[2] == v.name[2]) and data.number == v.number and data.bank == v.bank then
                table.remove(PhoneData.SuggestedContacts, k)
            end
        end
    end
end)

function GetClosestPlayer()
    local closestPlayers = scCore.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

RegisterNetEvent('lcrp-phone:server:newContactNotify')
AddEventHandler('lcrp-phone:server:newContactNotify', function(number)
    scCore.Notification('You have new contact!')
    SendNUIMessage({
        task = "suggestedNumberNotify",
        number = number
    })
    local PlayerData = scCore.Functions.GetPlayerData()
end)

RegisterNetEvent('lcrp-phone:server:newBankNotify')
AddEventHandler('lcrp-phone:server:newBankNotify', function(nr)
    scCore.Notification('You have new bank account contact')
    SendNUIMessage({
        task = "suggestedBankAccountNotify",
        nr = nr
    })
end)

RegisterNetEvent('lcrp-phone:client:giveNumber')
AddEventHandler('lcrp-phone:client:giveNumber', function(data)
    local ped = GetPlayerPed(-1)

    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent('lcrp-phone:server:giveNumber', playerId)
    else
        scCore.Notification("No one is nearby!", "error")
    end
end)

RegisterNetEvent('lcrp-phone:client:giveBankAccount')
AddEventHandler('lcrp-phone:client:giveBankAccount', function(data)
    local ped = GetPlayerPed(-1)
    local PlayerData = scCore.Functions.GetPlayerData()

    local player, distance = GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent('lcrp-phone:server:giveBankAccount', playerId, PlayerData)
    else
        scCore.Notification("No one is nearby!", "error")
    end
end)



RegisterNUICallback('DeleteContact', function(data, cb)
    local Name = data.CurrentContactName
    local Number = data.CurrentContactNumber
    local Account = data.CurrentContactIban

    for k, v in pairs(PhoneData.Contacts) do
        if v.name == Name and v.number == Number then
            table.remove(PhoneData.Contacts, k)
            if PhoneData.isOpen then
                SendNUIMessage({
                    action = "PhoneNotification",
                    PhoneNotify = {
                        title = "Phone",
                        text = "You have removed a contact!", 
                        icon = "fa fa-phone-alt",
                        color = "#04b543",
                        timeout = 1500,
                    },
                })
            else
                SendNUIMessage({
                    action = "Notification",
                    NotifyData = {
                        title = "Phone", 
                        content = "You have removed a contact!", 
                        icon = "fa fa-phone-alt", 
                        timeout = 3500, 
                        color = "#04b543",
                    },
                })
            end
            break
        end
    end
    Citizen.Wait(100)
    cb(PhoneData.Contacts)
    if PhoneData.Chats[Number] ~= nil and next(PhoneData.Chats[Number]) ~= nil then
        PhoneData.Chats[Number].name = Number
    end
    TriggerServerEvent('lcrp-phone:server:RemoveContact', Name, Number)
end)

RegisterNetEvent('lcrp-phone:client:AddNewSuggestion')
AddEventHandler('lcrp-phone:client:AddNewSuggestion', function(SuggestionData)
    table.insert(PhoneData.SuggestedContacts, SuggestionData)

    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Phone",
                text = "You have a newly suggested contact!", 
                icon = "fa fa-phone-alt",
                color = "#04b543",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Phone", 
                content = "You have a newly suggested contact!", 
                icon = "fa fa-phone-alt", 
                timeout = 3500, 
                color = "#04b543",
            },
        })
    end

    Config.PhoneApplications["phone"].Alerts = Config.PhoneApplications["phone"].Alerts + 1
    TriggerServerEvent('lcrp-phone:server:SetPhoneAlerts', "phone", Config.PhoneApplications["phone"].Alerts)
end)

RegisterNUICallback('GetCryptoData', function(data, cb)
    scCore.TriggerServerCallback('lcrp-crypto:server:GetCryptoData', function(CryptoData)
        cb(CryptoData)
    end, data.crypto)
end)

RegisterNUICallback('BuyCrypto', function(data, cb)
    scCore.TriggerServerCallback('lcrp-crypto:server:BuyCrypto', function(CryptoData)
        cb(CryptoData)
    end, data)
end)

RegisterNUICallback('SellCrypto', function(data, cb)
    scCore.TriggerServerCallback('lcrp-crypto:server:SellCrypto', function(CryptoData)
        cb(CryptoData)
    end, data)
end)

RegisterNUICallback('TransferCrypto', function(data, cb)
    scCore.TriggerServerCallback('lcrp-crypto:server:TransferCrypto', function(CryptoData)
        cb(CryptoData)
    end, data)
end)

RegisterNetEvent('lcrp-phone:client:RemoveBankMoney')
AddEventHandler('lcrp-phone:client:RemoveBankMoney', function(amount)
    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Bank",
                text = "$"..amount..",- debited from your bank!", 
                icon = "fas fa-university", 
                color = "#ff002f",
                timeout = 3500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Bank",
                content = "$"..amount..",- debited from your bank!", 
                icon = "fas fa-university",
                timeout = 3500, 
                color = "#ff002f",
            },
        })
    end
end)

RegisterNetEvent('lcrp-phone:client:AddTransaction')
AddEventHandler('lcrp-phone:client:AddTransaction', function(SenderData, TransactionData, Message, Title)
    local Data = {
        TransactionTitle = Title,
        TransactionMessage = Message,
    }
    
    table.insert(PhoneData.CryptoTransactions, Data)

    if PhoneData.isOpen then
        SendNUIMessage({
            action = "PhoneNotification",
            PhoneNotify = {
                title = "Crypto",
                text = Message, 
                icon = "fas fa-chart-pie",
                color = "#04b543",
                timeout = 1500,
            },
        })
    else
        SendNUIMessage({
            action = "Notification",
            NotifyData = {
                title = "Crypto",
                content = Message, 
                icon = "fas fa-chart-pie",
                timeout = 3500, 
                color = "#04b543",
            },
        })
    end

    SendNUIMessage({
        action = "UpdateTransactions",
        CryptoTransactions = PhoneData.CryptoTransactions
    })

    TriggerServerEvent('lcrp-phone:server:AddTransaction', Data)
end)
--[=====[ 
RegisterNUICallback('GetCryptoTransactions', function(data, cb)
    local Data = {
        CryptoTransactions = PhoneData.CryptoTransactions
    }
    cb(Data)
end)

RegisterNUICallback('GetAvailableRaces', function(data, cb)
    scCore.TriggerServerCallback('lcrp-lapraces:server:GetRaces', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('JoinRace', function(data)
    TriggerServerEvent('lcrp-lapraces:server:JoinRace', data.RaceData)
end)

RegisterNUICallback('LeaveRace', function(data)
    TriggerServerEvent('lcrp-lapraces:server:LeaveRace', data.RaceData)
end)

RegisterNUICallback('StartRace', function(data)
    TriggerServerEvent('lcrp-lapraces:server:StartRace', data.RaceData.RaceId)
end)

RegisterNetEvent('lcrp-phone:client:UpdateLapraces')
AddEventHandler('lcrp-phone:client:UpdateLapraces', function()
    SendNUIMessage({
        action = "UpdateRacingApp",
    })
end)

RegisterNUICallback('GetRaces', function(data, cb)
    scCore.TriggerServerCallback('lcrp-lapraces:server:GetListedRaces', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('GetTrackData', function(data, cb)
    scCore.TriggerServerCallback('lcrp-lapraces:server:GetTrackData', function(TrackData, CreatorData)
        TrackData.CreatorData = CreatorData
        cb(TrackData)
    end, data.RaceId)
end)

RegisterNUICallback('SetupRace', function(data, cb)
    TriggerServerEvent('lcrp-lapraces:server:SetupRace', data.RaceId, tonumber(data.AmountOfLaps))
end)

RegisterNUICallback('HasCreatedRace', function(data, cb)
    scCore.TriggerServerCallback('lcrp-lapraces:server:HasCreatedRace', function(HasCreated)
        cb(HasCreated)
    end)
end)

RegisterNUICallback('IsInRace', function(data, cb)
    local InRace = exports['lcrp-lapraces']:IsInRace()
    print(InRace)
    cb(InRace)
end)

RegisterNUICallback('IsAuthorizedToCreateRaces', function(data, cb)
    scCore.TriggerServerCallback('lcrp-lapraces:server:IsAuthorizedToCreateRaces', function(IsAuthorized, NameAvailable)
        local data = {
            IsAuthorized = IsAuthorized,
            IsBusy = exports['lcrp-lapraces']:IsInEditor(),
            IsNameAvailable = NameAvailable,
        }
        cb(data)
    end, data.TrackName)
end)

RegisterNUICallback('StartTrackEditor', function(data, cb)
    TriggerServerEvent('lcrp-lapraces:server:CreateLapRace', data.TrackName)
end)

RegisterNUICallback('GetRacingLeaderboards', function(data, cb)
    scCore.TriggerServerCallback('lcrp-lapraces:server:GetRacingLeaderboards', function(Races)
        cb(Races)
    end)
end)

RegisterNUICallback('RaceDistanceCheck', function(data, cb)
    scCore.TriggerServerCallback('lcrp-lapraces:server:GetRacingData', function(RaceData)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local checkpointcoords = RaceData.Checkpoints[1].coords
        local dist = GetDistanceBetweenCoords(coords, checkpointcoords.x, checkpointcoords.y, checkpointcoords.z, true)
        if dist <= 115.0 then
            if data.Joined then
                TriggerEvent('lcrp-lapraces:client:WaitingDistanceCheck')
            end
            cb(true)
        else
            scCore.Notification('You are too far from the race. Your navigation is set to the race.', 'error', 5000)
            SetNewWaypoint(checkpointcoords.x, checkpointcoords.y)
            cb(false)
        end
    end, data.RaceId)
end)

RegisterNUICallback('IsBusyCheck', function(data, cb)
    if data.check == "editor" then
        cb(exports['lcrp-lapraces']:IsInEditor())
    else
        cb(exports['lcrp-lapraces']:IsInRace())
    end
end)

RegisterNUICallback('CanRaceSetup', function(data, cb)
    scCore.TriggerServerCallback('lcrp-lapraces:server:CanRaceSetup', function(CanSetup)
        cb(CanSetup)
    end)
end)

RegisterNUICallback('GetPlayerHouses', function(data, cb)
    scCore.TriggerServerCallback('lcrp-phone:server:GetPlayerHouses', function(Houses)
        cb(Houses)
    end)
end)

RegisterNUICallback('SetHouseLocation', function(data, cb)
    SetNewWaypoint(data.HouseData.HouseData.coords.enter.x, data.HouseData.HouseData.coords.enter.y)
    scCore.Notification("GPS has been set " .. data.HouseData.HouseData.adress)
end)

RegisterNUICallback('SetApartmentLocation', function(data, cb)
    local ApartmentData = data.data.appartmentdata
    local TypeData = Apartments.Locations[ApartmentData.type]

    SetNewWaypoint(TypeData.coords.enter.x, TypeData.coords.enter.y)
    scCore.Notification('GPS has been set')
end)

RegisterNUICallback('RemoveKeyholder', function(data)
    TriggerServerEvent('lcrp-houses:server:removeHouseKey', data.HouseData.name, {
        citizenid = data.HolderData.citizenid,
        firstname = data.HolderData.charinfo.firstname,
        lastname = data.HolderData.charinfo.lastname,
    })
end)

RegisterNUICallback('TransferCid', function(data, cb)
    local TransferedCid = data.newBsn

    scCore.TriggerServerCallback('lcrp-phone:server:TransferCid', function(CanTransfer)
        cb(CanTransfer)
    end, TransferedCid, data.HouseData)
end)

--[=====[
RegisterNUICallback('FetchPlayerHouses', function(data, cb)
    scCore.TriggerServerCallback('lcrp-phone:server:MeosGetPlayerHouses', function(result)
        cb(result)
    end, data.input)
end)--]=====]
--]=====]
--[=====[ 
RegisterNUICallback('SetGPSLocation', function(data, cb)
    local ped = GetPlayerPed(-1)

    SetNewWaypoint(data.coords.x, data.coords.y)
    scCore.Notification('GPS is set!', 'success')
end)
--]=====]
xSound = exports.xsound
local i = 0

RegisterNUICallback('toggleRadio', function(data, cb)
    if data.player == 1 then
        i = i + 1
        xSound:PlayUrl(GetPlayerName(PlayerId())..i, "http://45.13.58.102:8070/radio.mp3", 0.5)
    else
        xSound:Destroy(GetPlayerName(PlayerId())..i)
    end
    cb("ok")
end)

RegisterNUICallback('volume', function(data, cb)
    local audioInfo = xSound:getAllAudioInfo()
    local i = 0
    for k in pairs(audioInfo) do i = i + 1 end
    if i > 0 then
        local volume = xSound:getVolume(GetPlayerName(PlayerId())..i)
        if data.volume == "plus" then
            volume = volume + 0.1
            if volume <= 1 then 
                xSound:setVolume(GetPlayerName(PlayerId())..i, volume)
            end
        else
            local volume = volume - 0.1
            if volume >= 0 then 
                xSound:setVolume(GetPlayerName(PlayerId())..i, volume)
            end
        end
    end
    cb("ok")
end)

RegisterNUICallback('GetCurrentLawyers', function(data, cb)
    scCore.TriggerServerCallback('police:server:getEmployeeStatus', function(emps)
        local data = {}
        for k, v in pairs(emps) do
            table.insert(data, v)
        end
        cb(data)
    end, "lawyer")
end)

RegisterNUICallback('GetCurrentTaxi', function(data, cb)
    scCore.TriggerServerCallback('police:server:getEmployeeStatus', function(emps)
        local data = {}
        for k, v in pairs(emps) do
            table.insert(data, v)
        end
        cb(data)
    end, "taxi")
end)

RegisterNUICallback('GetCurrentRealEstate', function(data, cb)
    scCore.TriggerServerCallback('police:server:getEmployeeStatus', function(emps)
        local data = {}
        for k, v in pairs(emps) do
            table.insert(data, v)
        end
        cb(data)
    end, "realestate")
end)

RegisterNUICallback('GetPlayerSkills', function(data, cb)
    scCore.TriggerServerCallback('player:CheckSkill', function(skills)
        cb(skills)
    end)
end)

RegisterNUICallback('registerFlight', function (data,cb)
    TriggerServerEvent('airlines:server:registerFlight', data.price, data.seats, data.departs, data.destination)
    cb(true)
end)


RegisterNUICallback('GetFlights', function(data, cb)
    scCore.TriggerServerCallback('airlines:GetFlights', function(data)
        cb({flights = data.flights, time = data.time })
    end)
end)

RegisterNUICallback('GetPassengers', function(data, cb)
    scCore.TriggerServerCallback('airlines:GetPassengers', function(passengersList)
        cb(passengersList)
    end, data.flightId)
end)

RegisterNUICallback('BuyTicket', function(data, cb)
    scCore.TriggerServerCallback('airlines:buyTicket', function(ticket)
        cb(ticket)
    end, data.flightId)
end)

RegisterNUICallback('GetValetCars', function(data, cb)
    scCore.TriggerServerCallback('lcrp-garages:server:GetValetVehicles', function(cars)
        for k, v in pairs(cars) do
            if v.vehicle ~= nil then
                cars[k].carName = scCore.Shared.Vehicles[v.vehicle].name
            end
        end
        cb(cars)
    end)
end)

RegisterNUICallback('ValetService', function(data, cb)
    local islandVec = vector3(4840.571, -5174.425, 2.0)
    scCore.TriggerServerCallback('lcrp-garages:server:ValetService', function(status)
        if status[2] == "Requesting service..." then
            local pos = GetEntityCoords(PlayerPedId())
            local distance1 = #(pos - islandVec)
            local r1, r2, r3 = GetClosestRoad(pos.x, pos.y, pos.z, 1.0, 1, false)
            if #(r2 - pos) > 50 or distance1 < 2000 then
                status[1] = false
                status[2] = "You need to be near a suitable road for the valet to reach you."
            else
                TriggerEvent('lcrp-valet:client:requestService', status[3])
            end
        end
        cb(status)
    end, data.state, data.plate)
end)

local isLf = false
RegisterNUICallback('findRace', function(data, cb)
    isLf = data.join
    TriggerServerEvent('lcrp-activities:server:LFRace', data.join)
    cb()
end)


RegisterNetEvent("lcrp-activities:client:setupWaypoint")
AddEventHandler("lcrp-activities:client:setupWaypoint", function(coords)
    if isLf then
        local startBlip = AddBlipForCoord(coords[1], coords[2], coords[3])
        SetBlipRoute(startBlip, true)
        SetBlipRouteColour(startBlip, 69)
        SendNUIMessage({ 
            action = "raceNotification",
        })
        isLf = false
        Citizen.Wait(600000)
        RemoveBlip(startBlip)
    end
end)

