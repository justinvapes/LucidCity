scCore = nil

TriggerEvent('scCore:GetObject', function(obj) scCore = obj end)

local function checkExistenceClothes(cid, cb)
        exports['ghmattimysql']:execute('SELECT cid FROM character_current WHERE cid = @cid LIMIT 1', {['@cid'] = cid}, function(result)
        local exists = result and result[1] and true or false
        cb(exists)
    end)
end

local function checkExistenceFace(cid, cb)
        exports['ghmattimysql']:execute('SELECT citizenid FROM players WHERE citizenid = @citizenid LIMIT 1', {['@citizenid'] = cid}, function(result)
        local exists = result and result[1] and true or false
        cb(exists)
    end)
end


RegisterServerEvent("lcrp-clothes:insert_character_current")
AddEventHandler("lcrp-clothes:insert_character_current",function(data)
    if not data then
        return
    end
    local src = source
    local Player = scCore.Functions.GetPlayer(source)
    local characterId = Player.PlayerData.citizenid

    if not characterId then
        return
    end
    exports['ghmattimysql']:execute("UPDATE players SET model = @model,drawables = @drawables,props = @props,drawtextures = @drawtextures,proptextures = @proptextures WHERE citizenid = @citizenid", {
        ["@citizenid"] = characterId,
        ["@model"] = json.encode(data.model),
        ["@drawables"] = json.encode(data.drawables),
        ["@props"] = json.encode(data.props),
        ["@drawtextures"] = json.encode(data.drawtextures),
        ["@proptextures"] = json.encode(data.proptextures)
    })

end)

RegisterServerEvent("lcrp-clothes:insert_character_face")
AddEventHandler("lcrp-clothes:insert_character_face",function(data)
    if not data then
        return
    end

    local src = source
    local Player = scCore.Functions.GetPlayer(source)
    local characterId = Player.PlayerData.citizenid

    if not characterId then
        return
    end

    exports['ghmattimysql']:execute("UPDATE players SET hairColor = @hairColor,headBlend = @headBlend,headOverlay = @headOverlay,headStructure = @headStructure WHERE citizenid = @citizenid", {
        ["@citizenid"] = characterId,
        ["@hairColor"] = json.encode(data.hairColor),
        ["@headBlend"] = json.encode(data.headBlend),
        ["@headOverlay"] = json.encode(data.headOverlay),
        ["@headStructure"] = json.encode(data.headStructure)
    })
end)


RegisterServerEvent("lcrp-clothes:get_character_face")
AddEventHandler("lcrp-clothes:get_character_face",function()
    local src = source
    local Player = scCore.Functions.GetPlayer(source)

    citizenid = Player.PlayerData.citizenid

    exports['ghmattimysql']:execute('SELECT hairColor, headBlend, headOverlay, headStructure, drawables, props, drawtextures, proptextures, model FROM players WHERE citizenid = @citizenid', {['@citizenid'] = citizenid}, function(result)
        local temp_data = {
            hairColor = json.decode(result[1].hairColor),
            headBlend = json.decode(result[1].headBlend),
            headOverlay = json.decode(result[1].headOverlay),
            headStructure = json.decode(result[1].headStructure),
            ---Below codes is added to fix the spawn ped.
            drawables = json.decode(result[1].drawables),
            props = json.decode(result[1].props),
            drawtextures = json.decode(result[1].drawtextures),
            proptextures = json.decode(result[1].proptextures),
            sex = result[1].sex,
        }
        local model = tonumber(result[1].model)
        if model == 1885233650 or model == -1667301416 then -- CHECKS IF MODEL IS FREEMODE
            TriggerClientEvent("lcrp-clothes:setpedfeatures", src, temp_data)
        end
	end)
end)

RegisterServerEvent("lcrp-clothes:get_character_current")
AddEventHandler("lcrp-clothes:get_character_current",function()
    local src = source
    local pData = scCore.Functions.GetPlayer(src)

    exports['ghmattimysql']:execute('SELECT model, drawables, props, drawtextures, proptextures FROM players WHERE citizenid = @citizenid', {['@citizenid'] = pData.PlayerData.citizenid}, function(result)
        
        -- if result[1].model == nil then
        --     TriggerClientEvent("raid-clothes:OpenClothesMenu", src)
        --     TriggerClientEvent('chatMessage', src, "SYSTEM", "error", "Selected character doesn\'t have skin saved, opening skin menu")
        -- return
        -- end

        if result[1].model == nil then
        return
        end

        local temp_data = {
            model = result[1].model,
            drawables = json.decode(result[1].drawables),
            props = json.decode(result[1].props),
            drawtextures = json.decode(result[1].drawtextures),
            proptextures = json.decode(result[1].proptextures),
        }

        TriggerClientEvent("lcrp-clothes:setclothes", src, temp_data,0,true)
    end)
end)

RegisterServerEvent("lcrp-clothes:retrieve_tats")
AddEventHandler("lcrp-clothes:retrieve_tats", function()
    local src = source
    local Player = scCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
        exports['ghmattimysql']:execute("SELECT tattoos FROM playersTattoos WHERE identifier = @identifier", {['@identifier'] = citizenid}, function(result)
        if(result and #result == 1) then
			TriggerClientEvent("lcrp-clothes:settattoos", src, json.decode(result[1].tattoos))
		else
			local tattooValue = "{}"
		  --exports['ghmattimysql']:execute("INSERT INTO playerstattoos (identifier, tattoos) VALUES (@identifier, @tattoo)", {['identifier'] = char.id, ['tattoo'] = tattooValue})
            exports['ghmattimysql']:execute("INSERT INTO playerstattoos (identifier, tattoos) VALUES  (@identifier, @tattoo)", {['@identifier'] = citizenid, ['@tattoo'] = tattooValue})
		end
	end)
end)

RegisterServerEvent("lcrp-clothes:set_tats")
AddEventHandler("lcrp-clothes:set_tats", function(tattoosList)
	local src = source
    local Player = scCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    exports['ghmattimysql']:execute('UPDATE playerstattoos SET tattoos = @tattoos WHERE identifier = @identifier', {
		['@tattoos'] = json.encode(tattoosList),
		['@identifier'] = citizenid
	})
end)

RegisterServerEvent("lcrp-clothes:outfitList")
AddEventHandler("lcrp-clothes:outfitList", function()
    local src = source
    local Player = scCore.Functions.GetPlayer(source)
    local characterId = Player.PlayerData.citizenid

    exports['ghmattimysql']:execute("SELECT * FROM character_outfits WHERE cid = @cid", {
        ['@cid'] = characterId
    }, function(result)

        if result == nil then
            TriggerClientEvent('scCore:Notification', src, 'You don\'t have any saved outfits!','error')
            return
        end

        for i = 1, (#result), 1 do
            slotResult = result[1].slot.. result[2].slot
            TriggerClientEvent('chatMessage', src, "OUTFITS", "warning", "Outfits: ".. slotResult)
        end
        
    end)
end)

scCore.Functions.CreateCallback("lcrp-clothes:outfitList", function(source, cb)

    local src = source
    local Player = scCore.Functions.GetPlayer(source)
    local characterId = Player.PlayerData.citizenid

    exports['ghmattimysql']:execute("SELECT * FROM character_outfits WHERE cid = @cid ORDER BY slot ASC", {
        ['@cid'] = characterId
    }, function(result)

        if result == nil then
            TriggerClientEvent('scCore:Notification', src, 'You don\'t have any saved outfits!','error')
            cb(nil)
        else
            cb(result)
        end
    end)
end)

RegisterServerEvent("lcrp-clothes:get_outfit")
AddEventHandler("lcrp-clothes:get_outfit", function(slot)
    if not slot then return end
    local src = source

    local Player = scCore.Functions.GetPlayer(source)
    local characterId = Player.PlayerData.citizenid

    if not characterId then return end

    exports['ghmattimysql']:execute("SELECT * FROM character_outfits WHERE cid = @cid and slot = @slot", {
        ['@cid'] = characterId,
        ['@slot'] = slot
    }, function(result)
        if result and result[1] then
            if result[1].model == nil then
                TriggerClientEvent('scCore:Notification', src, 'Can not use','error')
                return
            end

            local data = {
                model = tonumber(result[1].model),
                drawables = json.decode(result[1].drawables),
                props = json.decode(result[1].props),
                drawtextures = json.decode(result[1].drawtextures),
                proptextures = json.decode(result[1].proptextures)
            }

            TriggerClientEvent("lcrp-clothes:setclothes", src, data,0, false)

            exports['ghmattimysql']:execute("UPDATE players SET drawables = @drawables,props = @props,drawtextures = @drawtextures,proptextures = @proptextures WHERE citizenid = @citizenid", {
                ["@citizenid"] = characterId,
                ["@drawables"] = json.encode(data.drawables),
                ["@props"] = json.encode(data.props),
                ["@drawtextures"] = json.encode(data.drawtextures),
                ["@proptextures"] = json.encode(data.proptextures)
            })

        else
            TriggerClientEvent('scCore:Notification', src, 'No outfit on slot ' .. slot, "error")
            return
        end
	end)
end)

RegisterServerEvent("lcrp-clothes:set_outfit")
AddEventHandler("lcrp-clothes:set_outfit",function(slot, name, data)
    if not slot then return end
    local src = source

    local user = scCore.Functions.GetPlayer(source)
    local Player = scCore.Functions.GetPlayer(source)
    local characterId = Player.PlayerData.citizenid

    if not characterId then return end

    exports['ghmattimysql']:execute("SELECT slot FROM character_outfits WHERE cid = @cid and slot = @slot", {
        ['@cid'] = characterId,
        ['@slot'] = slot
    }, function(result)
        if result and result[1] then
            local values = {
                ["@cid"] = characterId,
                ["@slot"] = slot,
                ["@name"] = name,
                ["@model"] = json.encode(data.model),
                ["@drawables"] = json.encode(data.drawables),
                ["@props"] = json.encode(data.props),
                ["@drawtextures"] = json.encode(data.drawtextures),
                ["@proptextures"] = json.encode(data.proptextures),
            }

            local set = "model = @model,name = @name,drawables = @drawables,props = @props,drawtextures = @drawtextures,proptextures = @proptextures"
            exports['ghmattimysql']:execute("UPDATE character_outfits SET "..set.." WHERE cid = @cid and slot = @slot",values)
        else
            local cols = "cid, model, name, slot, drawables, props, drawtextures, proptextures"
            local vals = "@cid, @model, @name, @slot, @drawables, @props, @drawtextures, @proptextures"

            local values = {
                ["@cid"] = characterId,
                ["@name"] = name,
                ["@slot"] = slot,
                ["@model"] = data.model,
                ["@drawables"] = json.encode(data.drawables),
                ["@props"] = json.encode(data.props),
                ["@drawtextures"] = json.encode(data.drawtextures),
                ["@proptextures"] = json.encode(data.proptextures)
            }

            exports['ghmattimysql']:execute("INSERT INTO character_outfits ("..cols..") VALUES ("..vals..")", values, function()
               -- TriggerClientEvent("DoLongHudText", src, name .. " stored in slot " .. slot,1)
               TriggerClientEvent('scCore:Notification', src, name .. ' stored in slot ' .. slot, "primary") 
            end)
        end
	end)
end)

RegisterServerEvent("lcrp-clothes:getPlayerPed")
AddEventHandler("lcrp-clothes:getPlayerPed", function(cid)
    local src = source
    local citizenid = cid

    exports['ghmattimysql']:execute('SELECT hairColor, headBlend, headOverlay, headStructure, model, drawables, props, drawtextures, proptextures  FROM players WHERE citizenid = @citizenid', {['@citizenid'] = citizenid}, function(result)
        local temp_data = {
            hairColor = json.decode(result[1].hairColor),
            headBlend = json.decode(result[1].headBlend),
            headOverlay = json.decode(result[1].headOverlay),
            headStructure = json.decode(result[1].headStructure),
            model = result[1].model,
            drawables = json.decode(result[1].drawables),
            props = json.decode(result[1].props),
            drawtextures = json.decode(result[1].drawtextures),
            proptextures = json.decode(result[1].proptextures),
        }

        exports['ghmattimysql']:execute("SELECT tattoos FROM playersTattoos WHERE identifier = @identifier", {['@identifier'] = citizenid}, function(tattooResult)
        
        tattoos = tattooResult[1].tattoos
        TriggerClientEvent("lcrp-clothes:createPed", src, temp_data, tattoos)
        end)
    end)
end)

RegisterServerEvent("lcrp-clothes:remove_outfit")
AddEventHandler("lcrp-clothes:remove_outfit",function(slot)

    local src = source
    local Player = scCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid

    if not cid then
        return
    end

    exports['ghmattimysql']:execute("DELETE FROM character_outfits WHERE cid = @cid AND slot = @slot", { ['@cid'] = cid,  ["@slot"] = slot } )
    TriggerClientEvent('scCore:Notification', src, 'Removed outfit slot: ' .. slot, "primary") 
end)

RegisterServerEvent("lcrp-clothes:list_outfits")
AddEventHandler("lcrp-clothes:list_outfits",function()
    local src = source
    local Player = scCore.Functions.GetPlayer(source)
    local cid = Player.PlayerData.citizenid
    local slot = slot
    local name = name

    if not cid then
        return
    end

    exports['ghmattimysql']:execute("SELECT slot, name FROM character_outfits WHERE cid = @cid", {['cid'] = cid}, function(skincheck)
        TriggerClientEvent("raid-clothes:skinList", src, skincheck)
	end)
end)

RegisterServerEvent("clothing:checkIfNew")
AddEventHandler("clothing:checkIfNew", function()
    local src = source
    local Player = scCore.Functions.GetPlayer(source)
    local cid = Player.PlayerData.citizenid
    local dateCreated = user:getCurrentCharacter()

    exports['ghmattimysql']:execute("SELECT count(rank) whitelist FROM jobs_whitelist WHERE cid = @cid LIMIT 1", {
        ['@cid'] = cid
    }, function(isWhitelisted)
        exports.ghmattimysql:scalar("SELECT count(model) FROM character_current WHERE cid = @cid LIMIT 1", {
            ['@cid'] = cid
        }, function(result)
            local isService = false;
            if(isWhitelisted[1].whitelist >= 1) then isService = true end


            if result == 0 then
                exports['ghmattimysql']:execute("select count(cid) assExist from (select cid  from character_current union select cid from players_clothes) a where cid =  @cid", {['@cid'] = cid}, function(clothingCheck)
                    local existsClothing = clothingCheck[1].assExist
                    TriggerClientEvent('lcrp-clothes:setclothes',src,{},existsClothing, true)
                end)
                return
            else
                TriggerEvent("lcrp-clothes:get_character_current", src)
            end
            TriggerClientEvent("lcrp-clothes:inService",src,isService)
    	end)
    end)
end)


RegisterServerEvent("lcrp-clothes:server:getWhitelistPeds")
AddEventHandler("lcrp-clothes:server:getWhitelistPeds", function()
    local src = source

    exports['ghmattimysql']:execute("SELECT customPed from donations where customPed IS NOT NULL", {
    }, function(pedList)
        TriggerClientEvent('lcrp-clothes:client:getWhitelistPeds', src, pedList)
    end)
end)


RegisterCommand("refreshWhitelistPeds", function()
    exports['ghmattimysql']:execute("SELECT customPed from donations where customPed IS NOT NULL", {
    }, function(pedList)
        TriggerClientEvent('lcrp-clothes:client:getWhitelistPeds', -1, pedList)
    end)
end, true)


RegisterServerEvent("clothing:checkMoney")
AddEventHandler("clothing:checkMoney", function(data)
    local src = source
    local Player = scCore.Functions.GetPlayer(source)

    local askingPrice = data.price
    local menu = data.menu
    if Player.PlayerData.money.cash >= askingPrice then
        TriggerClientEvent("lcrp-clothes:hasEnough",src,menu)
        Player.Functions.RemoveMoney("cash", askingPrice, "id-purchased")
    else
        TriggerClientEvent('scCore:Notification', src, "You don\'t have enough money!", "error") 
	end
end)

-- scCore.RegisterCommand("helm", "Put your helmet/hat on/off", {}, false, function(source, args)
--     TriggerClientEvent("lcrp-clothes:client:adjustfacewear", source, 1)
-- end)

-- scCore.RegisterCommand("glasses", "Put your glasses on/off", {}, false, function(source, args)
-- 	TriggerClientEvent("lcrp-clothes:client:adjustfacewear", source, 2)
-- end)

-- scCore.RegisterCommand("mask", "Put your mask on/off", {}, false, function(source, args)
-- 	TriggerClientEvent("lcrp-clothes:client:adjustfacewear", source, 4)
-- end)

--[[ scCore.RegisterCommand("outfit", "Change, save, remove outfit", {{name="Action", help="1 - Save outfit, 2 - remove outfit, 3 - Select outfit"}, {name="slot", help="Outfit slot"}, {name="name", help="Outfit name, only use if you are creating"}}, false, function(source, args)
    src = source
    sentType = tonumber(args[1])
    TriggerClientEvent("raid-clothes:commandOutfit", src, sentType, args)
end) ]]


scCore.RegisterCommand("resetPed", "Reset your ped to default", {}, false, function(source, args)
    local src = source
    TriggerClientEvent('lcrp-clothes:defaultReset', src)
end)

-- scCore.RegisterCommand("pedtest", "Create ped test", {}, false, function(source, args)
-- 	TriggerClientEvent("lcrp-clothes:createPed", source)
-- end, admin)