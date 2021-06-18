local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

scCore = nil

Citizen.CreateThread(function() 
    Citizen.Wait(10)
    while scCore == nil do
        TriggerEvent("scCore:GetObject", function(obj) scCore = obj end)    
        Citizen.Wait(200)
    end
end)

barberShops = {
	{1932.0756835938, 3729.6706542969, 32.844413757324}, --Feita
	{-278.19036865234, 6228.361328125, 31.695510864258}, --Feita
	{1211.9903564453, -472.77117919922, 66.207984924316}, --Feita
	{-33.224239349365, -152.62608337402, 57.076496124268},--Feita
	{136.7181854248, -1708.2673339844, 29.291622161865}, --Feita
	{-815.18896484375, -184.53868103027, 37.568943023682}, --Feita
	{-1283.2886962891, -1117.3210449219, 6.9901118278503} --Feita
}

clothingShops = {
	{1693.45667, 4823.17725, 42.1631294 }, -- Feita
	{-712.215881,-155.352982, 37.4151268,600}, -- Feita
	{-1192.94495,-772.688965, 17.3255997,1500}, -- Feita
	{ 425.236,-806.008,28.491 ,600}, --Feita
	{ -162.658,-303.397,38.733 ,600}, --Feita
	{ 75.950,-1392.891,28.376 ,600}, --Feita
	{ -822.194,-1074.134,10.328 ,600}, --Feita
	{ -1450.711,-236.83,48.809 ,600}, --Feita
	{ 4.254,6512.813,30.877 ,600}, --Feita
	{ 615.180,2762.933,41.088 ,600}, --Feita
	{ 1196.785,2709.558,37.222,600}, --Feita
	{ -3171.453,1043.857,19.863,600},-- Feita
	{ -1100.959,2710.211,18.107,600}, --Feita
	{ 121.76,-224.6,53.56,600}, --Feita
}

VipClothing = {
    -- {-716.06, -382.55, 34.82}  
    {-716.68, -371.59, 34.58}
}

healingShops = {}

local enabled = false
local player = false
local firstChar = false
local cam = false
local customCam = false
local oldPed = false
local startingMenu = false
local inMenu = false

local drawable_names = {"face", "masks", "hair", "torsos", "legs", "bags", "shoes", "neck", "undershirts", "vest", "decals", "jackets"}
local prop_names = {"hats", "glasses", "earrings", "mouth", "lhand", "rhand", "watches", "braclets"}
local head_overlays = {"Blemishes","FacialHair","Eyebrows","Ageing","Makeup","Blush","Complexion","SunDamage","Lipstick","MolesFreckles","ChestHair","BodyBlemishes","AddBodyBlemishes"}
local face_features = {"Nose_Width","Nose_Peak_Hight","Nose_Peak_Lenght","Nose_Bone_High","Nose_Peak_Lowering","Nose_Bone_Twist","EyeBrown_High","EyeBrown_Forward","Cheeks_Bone_High","Cheeks_Bone_Width","Cheeks_Width","Eyes_Openning","Lips_Thickness","Jaw_Bone_Width","Jaw_Bone_Back_Lenght","Chimp_Bone_Lowering","Chimp_Bone_Lenght","Chimp_Bone_Width","Chimp_Hole","Neck_Thikness"}
local tatCategory = GetTatCategs()
local tattooHashList = CreateHashList()

local StoreCost = 20;
local barberCost = 7;
local tattooCost = 30;
local isService = false;
local isVip = false
local PlayerData = nil


RegisterNetEvent('scCore:Client:OnPlayerLoaded')
AddEventHandler('scCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('lcrp-clothes:get_character_current')
    PlayerData =  scCore.Functions.GetPlayerData()
    if PlayerData.donations.hasClothing == 1 and PlayerData.fivem ~= nil then
        isVip = true
    end
    --TriggerServerEvent('lcrp-clothes:server:getWhitelistPeds')
end)

--[[ RegisterNetEvent('lcrp-clothes:client:getWhitelistPeds')
AddEventHandler('lcrp-clothes:client:getWhitelistPeds', function(pedList)
    for k, v in pairs(pedList) do
        pedWhitelist[GetHashKey(v.customPed)] = true
    end
end) ]]


--[[ function checkWhitelistPeds(ped)
    if pedWhitelist[ped] then
        return true
    end
    return false
end ]]

Citizen.CreateThread(function()
    local vipShop = AddBlipForCoord(-715.53, -372.63, 35.10)
    SetBlipSprite(vipShop, 73)
    SetBlipColour(vipShop, 50)
    SetBlipScale  (vipShop, 0.7)
    SetBlipAsShortRange(vipShop, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("VIP Clothing Shop")
    EndTextCommandSetBlipName(vipShop)

    for i = 1, #clothingShops do
        clothingCoords = clothingShops[i]
        clothingShop = AddBlipForCoord(clothingCoords[1], clothingCoords[2], clothingCoords[3])
        SetBlipSprite(clothingShop, 73)
        SetBlipColour(clothingShop, 3)
        SetBlipScale  (clothingShop, 0.7)
        SetBlipAsShortRange(clothingShop, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Clothing Shop")
        EndTextCommandSetBlipName(clothingShop)
    end

    for i = 1, #barberShops do
        barberCoords = barberShops[i]
        local barberShop = AddBlipForCoord(barberCoords[1], barberCoords[2], barberCoords[3])
        SetBlipSprite(barberShop, 71)
        SetBlipColour(barberShop, 0)
        SetBlipScale  (barberShop, 0.7)
        SetBlipAsShortRange(barberShop, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Barbershop")
        EndTextCommandSetBlipName(barberShop)
    end

    for i = 1, #tattoosShops do
        TattooCoords = tattoosShops[i]
        local TattooShop = AddBlipForCoord(TattooCoords[1], TattooCoords[2], TattooCoords[3])
        SetBlipSprite(TattooShop, 75)
        SetBlipColour(TattooShop, 1)
        SetBlipScale(TattooShop, 0.8)
        SetBlipAsShortRange(TattooShop, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Tattoo Shop")
        EndTextCommandSetBlipName(TattooShop)
    end
end)

function RefreshUI(menu)
    hairColors = {}
    for i = 0, GetNumHairColors()-1 do
        local outR, outG, outB= GetPedHairRgbColor(i)
        hairColors[i] = {outR, outG, outB}
    end

    makeupColors = {}
    for i = 0, GetNumMakeupColors()-1 do
        local outR, outG, outB= GetPedMakeupRgbColor(i)
        makeupColors[i] = {outR, outG, outB}
    end
    local atVip = false
    if menu == "vipmenu" and isVip then atVip = true end
    SendNUIMessage({
        type="colors",
        hairColors=hairColors,
        makeupColors=makeupColors,
        hairColor=GetPedHair(),
        atVip = atVip
    })
    SendNUIMessage({
        type = "menutotals",
        drawTotal = GetDrawablesTotal(),
        propDrawTotal = GetPropDrawablesTotal(),
        textureTotal = GetTextureTotals(),
        headoverlayTotal = GetHeadOverlayTotals(),
        skinTotal = GetSkinTotal()
    })
    SendNUIMessage({
        type = "barbermenu",
        headBlend = GetPedHeadBlendData(),
        headOverlay = GetHeadOverlayData(),
        headStructure = GetHeadStructureData()
    })
    SendNUIMessage({
        type = "clothesmenudata",
        drawables = GetDrawables(),
        props = GetProps(),
        drawtextures = GetDrawTextures(),
        proptextures = GetPropTextures(),
        skin = GetSkin(),
        oldPed = oldPed,
    })
    SendNUIMessage({
        type = "tattoomenu",
        totals = tatCategory,
        values = GetTats()
    })
end

function GetSkin()
    for i = 1, #frm_skins do
        if (GetHashKey(frm_skins[i]) == GetEntityModel(PlayerPedId())) then
            return {name="skin_male", value=i}
        end
    end
    for i = 1, #fr_skins do
        if (GetHashKey(fr_skins[i]) == GetEntityModel(PlayerPedId())) then
            return {name="skin_female", value=i}
        end
    end
    return false
end

function GetDrawables()
    drawables = {}
    local model = GetEntityModel(PlayerPedId())
    local mpPed = false
    if (model == `mp_f_freemode_01` or model == `mp_m_freemode_01`) then
        mpPed = true
    end
    for i = 0, #drawable_names-1 do
        if mpPed and drawable_names[i+1] == "undershirts" and GetPedDrawableVariation(player, i) == -1 then
            SetPedComponentVariation(player, i, 15, 0, 2)
        end
        drawables[i] = {drawable_names[i+1], GetPedDrawableVariation(player, i)}
    end
    return drawables
end

function GetProps()
    props = {}
    for i = 0, #prop_names-1 do
        props[i] = {prop_names[i+1], GetPedPropIndex(player, i)}
    end
    return props
end

function GetDrawTextures()
    textures = {}
    for i = 0, #drawable_names-1 do
        table.insert(textures, {drawable_names[i+1], GetPedTextureVariation(player, i)})
    end
    return textures
end

function GetPropTextures()
    textures = {}
    for i = 0, #prop_names-1 do
        table.insert(textures, {prop_names[i+1], GetPedPropTextureIndex(player, i)})
    end
    return textures
end

function GetDrawablesTotal()
    drawables = {}
    for i = 0, #drawable_names - 1 do
        drawables[i] = {drawable_names[i+1], GetNumberOfPedDrawableVariations(player, i)}
    end
    return drawables
end

function GetPropDrawablesTotal()
    props = {}
    for i = 0, #prop_names - 1 do
        props[i] = {prop_names[i+1], GetNumberOfPedPropDrawableVariations(player, i)}
    end
    return props
end

function GetTextureTotals()
    local values = {}
    local draw = GetDrawables()
    local props = GetProps()

    for idx = 0, #draw-1 do
        local name = draw[idx][1]
        local value = draw[idx][2]
        values[name] = GetNumberOfPedTextureVariations(player, idx, value)
    end

    for idx = 0, #props-1 do
        local name = props[idx][1]
        local value = props[idx][2]
        values[name] = GetNumberOfPedPropTextureVariations(player, idx, value)
    end
    return values
end

function SetClothing(drawables, props, drawTextures, propTextures)
    for i = 1, #drawable_names do
        if drawables[0] == nil then
            if drawable_names[i] == "undershirts" and drawables[tostring(i-1)][2] == -1 then
                SetPedComponentVariation(player, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(player, i-1, drawables[tostring(i-1)][2], drawTextures[i][2], 2)
            end
        else
            if drawable_names[i] == "undershirts" and drawables[i-1][2] == -1 then
                SetPedComponentVariation(player, i-1, 15, 0, 2)
            else
                SetPedComponentVariation(player, i-1, drawables[i-1][2], drawTextures[i][2], 2)
            end
        end
    end

    for i = 1, #prop_names do
        local propZ = (drawables[0] == nil and props[tostring(i-1)][2] or props[i-1][2])
        ClearPedProp(player, i-1)
        SetPedPropIndex(
            player,
            i-1,
            propZ,
            propTextures[i][2], true)
    end
end

function GetSkinTotal()
	return {
        #frm_skins,
        #fr_skins
    }
end

local toggleClothing = {}
function ToggleProps(data)
    local name = data["name"]

    selectedValue = has_value(drawable_names, name)
    if (selectedValue > -1) then
        if (toggleClothing[name] ~= nil) then
            SetPedComponentVariation(
                player,
                tonumber(selectedValue),
                tonumber(toggleClothing[name][1]),
                tonumber(toggleClothing[name][2]), 2)
            toggleClothing[name] = nil
        else
            toggleClothing[name] = {
                GetPedDrawableVariation(player, tonumber(selectedValue)),
                GetPedTextureVariation(player, tonumber(selectedValue))
            }

            local value = -1
            if name == "undershirts" or name == "torsos" then
                value = 15
                if name == "undershirts" and GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
                    value = -1
                end
            end
            if name == "legs" then
                value = 14
            end

            SetPedComponentVariation(
                player,
                tonumber(selectedValue),
                value, 0, 2)
        end
    else
        selectedValue = has_value(prop_names, name)
        if (selectedValue > -1) then
            if (toggleClothing[name] ~= nil) then
                SetPedPropIndex(
                    player,
                    tonumber(selectedValue),
                    tonumber(toggleClothing[name][1]),
                    tonumber(toggleClothing[name][2]), true)
                toggleClothing[name] = nil
            else
                toggleClothing[name] = {
                    GetPedPropIndex(player, tonumber(selectedValue)),
                    GetPedPropTextureIndex(player, tonumber(selectedValue))
                }
                ClearPedProp(player, tonumber(selectedValue))
            end
        end
    end
end

local faceProps = {
	[1] = { ["Prop"] = -1, ["Texture"] = -1 },
	[2] = { ["Prop"] = -1, ["Texture"] = -1 },
	[3] = { ["Prop"] = -1, ["Texture"] = -1 },
	[4] = { ["Prop"] = -1, ["Palette"] = -1, ["Texture"] = -1 }, -- this is actually a pedtexture variations, not a prop
	[5] = { ["Prop"] = -1, ["Palette"] = -1, ["Texture"] = -1 }, -- this is actually a pedtexture variations, not a prop
	[6] = { ["Prop"] = -1, ["Palette"] = -1, ["Texture"] = -1 }, -- this is actually a pedtexture variations, not a prop
}

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

RegisterNetEvent("lcrp-clothes:client:adjustfacewear")
AddEventHandler("lcrp-clothes:client:adjustfacewear",function(type)
    if scCore.Functions.GetPlayerData().metadata["ishandcuffed"] then return end
	removeWear = not removeWear
	local AnimSet = "none"
	local AnimationOn = "none"
	local AnimationOff = "none"
	local PropIndex = 0

	local AnimSet = "mp_masks@on_foot"
	local AnimationOn = "put_on_mask"
	local AnimationOff = "put_on_mask"

	faceProps[6]["Prop"] = GetPedDrawableVariation(GetPlayerPed(-1), 0)
	faceProps[6]["Palette"] = GetPedPaletteVariation(GetPlayerPed(-1), 0)
	faceProps[6]["Texture"] = GetPedTextureVariation(GetPlayerPed(-1), 0)

	for i = 0, 3 do
		if GetPedPropIndex(GetPlayerPed(-1), i) ~= -1 then
			faceProps[i+1]["Prop"] = GetPedPropIndex(GetPlayerPed(-1), i)
		end
		if GetPedPropTextureIndex(GetPlayerPed(-1), i) ~= -1 then
			faceProps[i+1]["Texture"] = GetPedPropTextureIndex(GetPlayerPed(-1), i)
		end
	end

	if GetPedDrawableVariation(GetPlayerPed(-1), 1) ~= -1 then
		faceProps[4]["Prop"] = GetPedDrawableVariation(GetPlayerPed(-1), 1)
		faceProps[4]["Palette"] = GetPedPaletteVariation(GetPlayerPed(-1), 1)
		faceProps[4]["Texture"] = GetPedTextureVariation(GetPlayerPed(-1), 1)
	end

	if GetPedDrawableVariation(GetPlayerPed(-1), 11) ~= -1 then
		faceProps[5]["Prop"] = GetPedDrawableVariation(GetPlayerPed(-1), 11)
		faceProps[5]["Palette"] = GetPedPaletteVariation(GetPlayerPed(-1), 11)
		faceProps[5]["Texture"] = GetPedTextureVariation(GetPlayerPed(-1), 11)
	end

	if type == 1 then
		PropIndex = 0
	elseif type == 2 then
		PropIndex = 1

		AnimSet = "clothingspecs"
		AnimationOn = "take_off"
		AnimationOff = "take_off"

	elseif type == 3 then
		PropIndex = 2
	elseif type == 4 then
		PropIndex = 1
		if removeWear then
			AnimSet = "missfbi4"
			AnimationOn = "takeoff_mask"
			AnimationOff = "takeoff_mask"
		end
	elseif type == 5 then
		PropIndex = 11
		AnimSet = "oddjobs@basejump@ig_15"
		AnimationOn = "puton_parachute"
		AnimationOff = "puton_parachute"	
		--mp_safehouseshower@male@ male_shower_idle_d_towel
		--mp_character_creation@customise@male_a drop_clothes_a
		--oddjobs@basejump@ig_15 puton_parachute_bag
	end

	loadAnimDict( AnimSet )
	if type == 5 then
		if removeWear then
			SetPedComponentVariation(GetPlayerPed(-1), 3, 2, faceProps[6]["Texture"], faceProps[6]["Palette"])
		end
	end
	if removeWear then
		TaskPlayAnim( GetPlayerPed(-1), AnimSet, AnimationOff, 4.0, 3.0, -1, 49, 1.0, 0, 0, 0 )
		Citizen.Wait(500)
		if type ~= 5 then
			if type == 4 then
				SetPedComponentVariation(GetPlayerPed(-1), PropIndex, -1, -1, -1)
			else
				if type ~= 2 then
					ClearPedProp(GetPlayerPed(-1), tonumber(PropIndex))
				end
			end
		end
	else
		TaskPlayAnim( GetPlayerPed(-1), AnimSet, AnimationOn, 4.0, 3.0, -1, 49, 1.0, 0, 0, 0 )
		Citizen.Wait(500)
		if type ~= 5 and type ~= 2 then
			if type == 4 then
				SetPedComponentVariation(GetPlayerPed(-1), PropIndex, faceProps[type]["Prop"], faceProps[type]["Texture"], faceProps[type]["Palette"])
			else
				SetPedPropIndex( GetPlayerPed(-1), tonumber(PropIndex), tonumber(faceProps[PropIndex+1]["Prop"]), tonumber(faceProps[PropIndex+1]["Texture"]), false)
			end
		end
	end
	if type == 5 then
		if not removeWear then
			SetPedComponentVariation(GetPlayerPed(-1), 3, 1, faceProps[6]["Texture"], faceProps[6]["Palette"])
			SetPedComponentVariation(GetPlayerPed(-1), PropIndex, faceProps[type]["Prop"], faceProps[type]["Texture"], faceProps[type]["Palette"])
		else
			SetPedComponentVariation(GetPlayerPed(-1), PropIndex, -1, -1, -1)
		end
		Citizen.Wait(1800)
	end
	if type == 2 then
		Citizen.Wait(600)
		if removeWear then
			ClearPedProp(GetPlayerPed(-1), tonumber(PropIndex))
		end

		if not removeWear then
			Citizen.Wait(140)
			SetPedPropIndex( GetPlayerPed(-1), tonumber(PropIndex), tonumber(faceProps[PropIndex+1]["Prop"]), tonumber(faceProps[PropIndex+1]["Texture"]), false)
		end
	end
	if type == 4 and removeWear then
		Citizen.Wait(1200)
	end
	ClearPedTasks(GetPlayerPed(-1))
end)

function SaveToggleProps()
    for k in pairs(toggleClothing) do
        local name  = k
        selectedValue = has_value(drawable_names, name)
        if (selectedValue > -1) then
            SetPedComponentVariation(
                player,
                tonumber(selectedValue),
                tonumber(toggleClothing[name][1]),
                tonumber(toggleClothing[name][2]), 2)
            toggleClothing[name] = nil
        else
            selectedValue = has_value(prop_names, name)
            if (selectedValue > -1) then
                SetPedPropIndex(
                    player,
                    tonumber(selectedValue),
                    tonumber(toggleClothing[name][1]),
                    tonumber(toggleClothing[name][2]), true)
                toggleClothing[name] = nil
            end
        end
    end
end

function LoadPed(data)
    SetSkin(data.model, true)
    --print(data.model)
    SetClothing(data.drawables, data.props, data.drawtextures, data.proptextures)
    --print(data.drawables)
    Citizen.Wait(500)
    SetPedHairColor(player, tonumber(data.hairColor[1]), tonumber(data.hairColor[2]))
    SetPedHeadBlend(data.headBlend)
    SetHeadStructure(player, data.headStructure)
    SetHeadOverlayData(data.headOverlay)
    --PlayerModel(data.sex)
    return
end

function GetCurrentPed()
    player = GetPlayerPed(-1)
    return {
        model = GetEntityModel(PlayerPedId()),
        hairColor = GetPedHair(),
        headBlend = GetPedHeadBlendData(),
        headOverlay = GetHeadOverlayData(),
        headStructure = GetHeadStructure(),
        drawables = GetDrawables(),
        props = GetProps(),
        drawtextures = GetDrawTextures(),
        proptextures = GetPropTextures(),
    }
end

function PlayerModel(data)
    local skins = nil

    if (data['name'] == 'skin_male') then
        skins = frm_skins
    else
        skins = fr_skins
    end

    local skin = skins[tonumber(data['value'])]

    --[[ if checkWhitelistPeds(GetHashKey(skin)) then
        table.remove(skins, tonumber(data['value']))
        scCore.Notification("The ped was locked. Skipping to the next!", "error")
        RefreshUI()
        return
    end ]]
    rotation(180.0)
    SetSkin(GetHashKey(skin), true)
    Citizen.Wait(1)
    rotation(180.0)
end

function SetSkin(model, setDefault)
        SetEntityInvincible(PlayerPedId(),true)
        if IsModelInCdimage(model) and IsModelValid(model) then
            RequestModel(model)
            while (not HasModelLoaded(model)) do
                Citizen.Wait(0)
            end
            hp = GetEntityHealth(PlayerPedId())
            SetPlayerModel(PlayerId(), model)
            SetEntityHealth(PlayerPedId(), hp)
            SetModelAsNoLongerNeeded(model)
            player = GetPlayerPed(-1)
            FreezePedCameraRotation(player, true)
            if setDefault and model ~= nil and not isCustomSkin(model) then
                if (model ~= `mp_f_freemode_01` and model ~= `mp_m_freemode_01`) then
                    SetPedRandomComponentVariation(GetPlayerPed(-1), true)
                else
                    SetPedHeadBlendData(player, 0, 0, 0, 15, 0, 0, 0, 1.0, 0, false)
                    SetPedComponentVariation(player, 11, 0, 11, 0)
                    SetPedComponentVariation(player, 8, 0, 1, 0)
                    SetPedComponentVariation(player, 6, 1, 2, 0)
                    SetPedHeadOverlayColor(player, 1, 1, 0, 0)
                    SetPedHeadOverlayColor(player, 2, 1, 0, 0)
                    SetPedHeadOverlayColor(player, 4, 2, 0, 0)
                    SetPedHeadOverlayColor(player, 5, 2, 0, 0)
                    SetPedHeadOverlayColor(player, 8, 2, 0, 0)
                    SetPedHeadOverlayColor(player, 10, 1, 0, 0)
                    SetPedHeadOverlay(player, 1, 0, 0.0)
                    SetPedHairColor(player, 1, 1)
                end
            end
        end
        SetEntityInvincible(PlayerPedId(),false)
end

local godUser = {'steam:11000010e041c22'}
RegisterNetEvent('lcrp-admin:client:SetModel')
AddEventHandler('lcrp-admin:client:SetModel', function(skin)
    --[[ if not checkWhitelistPeds(GetHashKey(skin)) then
        SetSkin(GetHashKey(skin), false)
        local data = GetCurrentPed()
        TriggerServerEvent("lcrp-clothes:insert_character_current", data)
    else
        scCore.Notification("This ped is locked!", "error")
    end ]]
    local isGod = false
    for k,v in pairs(godUser) do
        if PlayerData.steam == v then
            isGod = true
        end
    end
    if GetHashKey(skin) == GetHashKey(PlayerData.donations.customPed) or isGod then
        SetSkin(GetHashKey(skin), false)
        local data = GetCurrentPed()
        TriggerServerEvent("lcrp-clothes:insert_character_current", data)
    else
        scCore.Notification("This ped is not locked to you! To lock a ped check https://store.lucidcityrp.com/ or contact support on Discord", "error", 10000)
    end
end)

RegisterNUICallback('updateclothes', function(data, cb)
    toggleClothing[data["name"]] = nil
    selectedValue = has_value(drawable_names, data["name"])
    if (selectedValue > -1) then
        SetPedComponentVariation(player, tonumber(selectedValue), tonumber(data["value"]), tonumber(data["texture"]), 2)
        cb({
            GetNumberOfPedTextureVariations(player, tonumber(selectedValue), tonumber(data["value"]))
        })
    else
        selectedValue = has_value(prop_names, data["name"])
        if (tonumber(data["value"]) == -1) then
            ClearPedProp(player, tonumber(selectedValue))
        else
            SetPedPropIndex(
                player,
                tonumber(selectedValue),
                tonumber(data["value"]),
                tonumber(data["texture"]), true)
        end
        cb({
            GetNumberOfPedPropTextureVariations(
                player,
                tonumber(selectedValue),
                tonumber(data["value"])
            )
        })
    end
end)

RegisterNUICallback('customskin', function(data, cb)
    if canUseCustomSkins() then
        local valid_model = isInSkins(data)
        if valid_model then
            SetSkin(GetHashKey(data), true)
        end
    end
end)

RegisterNUICallback('setped', function(data, cb)
    PlayerModel(data)
    RefreshUI()
    cb('ok')
end)

RegisterNUICallback('resetped', function(data, cb)
    LoadPed(oldPed)
    cb('ok')
end)

function GetPedHeadBlendData()
    local blob = string.rep("\0\0\0\0\0\0\0\0", 6 + 3 + 1) -- Generate sufficient struct memory.
    if not Citizen.InvokeNative(0x2746BD9D88C5C5D0, player, blob, true) then -- Attempt to write into memory blob.
        return nil
    end

    return {
        shapeFirst = string.unpack("<i4", blob, 1),
        shapeSecond = string.unpack("<i4", blob, 9),
        shapeThird = string.unpack("<i4", blob, 17),
        skinFirst = string.unpack("<i4", blob, 25),
        skinSecond = string.unpack("<i4", blob, 33),
        skinThird = string.unpack("<i4", blob, 41),
        shapeMix = string.unpack("<f", blob, 49),
        skinMix = string.unpack("<f", blob, 57),
        thirdMix = string.unpack("<f", blob, 65),
        hasParent = string.unpack("b", blob, 73) ~= 0,
    }
end

function SetPedHeadBlend(data)
    SetPedHeadBlendData(player,
        tonumber(data['shapeFirst']),
        tonumber(data['shapeSecond']),
        tonumber(data['shapeThird']),
        tonumber(data['skinFirst']),
        tonumber(data['skinSecond']),
        tonumber(data['skinThird']),
        tonumber(data['shapeMix']),
        tonumber(data['skinMix']),
        tonumber(data['thirdMix']),
        false)
end

function GetHeadOverlayData()
    local headData = {}
    for i = 1, #head_overlays do
        local retval, overlayValue, colourType, firstColour, secondColour, overlayOpacity = GetPedHeadOverlayData(player, i-1)
        if retval then
            headData[i] = {}
            headData[i].name = head_overlays[i]
            headData[i].overlayValue = overlayValue
            headData[i].colourType = colourType
            headData[i].firstColour = firstColour
            headData[i].secondColour = secondColour
            headData[i].overlayOpacity = overlayOpacity
        end
    end
    return headData
end

function SetHeadOverlayData(data)
    if json.encode(data) ~= "[]" then
        for i = 1, #head_overlays do
            SetPedHeadOverlay(player,  i-1, tonumber(data[i].overlayValue),  tonumber(data[i].overlayOpacity))
            -- SetPedHeadOverlayColor(player, i-1, data[i].colourType, data[i].firstColour, data[i].secondColour)
        end

        SetPedHeadOverlayColor(player, 0, 0, tonumber(data[1].firstColour), tonumber(data[1].secondColour))
        SetPedHeadOverlayColor(player, 1, 1, tonumber(data[2].firstColour), tonumber(data[2].secondColour))
        SetPedHeadOverlayColor(player, 2, 1, tonumber(data[3].firstColour), tonumber(data[3].secondColour))
        SetPedHeadOverlayColor(player, 3, 0, tonumber(data[4].firstColour), tonumber(data[4].secondColour))
        SetPedHeadOverlayColor(player, 4, 2, tonumber(data[5].firstColour), tonumber(data[5].secondColour))
        SetPedHeadOverlayColor(player, 5, 2, tonumber(data[6].firstColour), tonumber(data[6].secondColour))
        SetPedHeadOverlayColor(player, 6, 0, tonumber(data[7].firstColour), tonumber(data[7].secondColour))
        SetPedHeadOverlayColor(player, 7, 0, tonumber(data[8].firstColour), tonumber(data[8].secondColour))
        SetPedHeadOverlayColor(player, 8, 2, tonumber(data[9].firstColour), tonumber(data[9].secondColour))
        SetPedHeadOverlayColor(player, 9, 0, tonumber(data[10].firstColour), tonumber(data[10].secondColour))
        SetPedHeadOverlayColor(player, 10, 1, tonumber(data[11].firstColour), tonumber(data[11].secondColour))
        SetPedHeadOverlayColor(player, 11, 0, tonumber(data[12].firstColour), tonumber(data[12].secondColour))
    end
end

function GetHeadOverlayTotals()
    local totals = {}
    for i = 1, #head_overlays do
        totals[head_overlays[i]] = GetNumHeadOverlayValues(i-1)
    end
    return totals
end

function GetPedHair()
    local hairColor = {}
    hairColor[1] = GetPedHairColor(player)
    hairColor[2] = GetPedHairHighlightColor(player)
    return hairColor
end

function GetHeadStructureData()
    local structure = {}
    for i = 1, #face_features do
        structure[face_features[i]] = GetPedFaceFeature(player, i-1)
    end
    return structure
end

function GetHeadStructure(data)
    local structure = {}
    for i = 1, #face_features do
        structure[i] = GetPedFaceFeature(player, i-1)
    end
    return structure
end

function SetHeadStructure(ped, data)
    for i = 1, #face_features do
        SetPedFaceFeature(ped, i-1, data[i])
    end
end


RegisterNUICallback('saveheadblend', function(data, cb)
    SetPedHeadBlendData(player,
    tonumber(data.shapeFirst),
    tonumber(data.shapeSecond),
    tonumber(data.shapeThird),
    tonumber(data.skinFirst),
    tonumber(data.skinSecond),
    tonumber(data.skinThird),
    tonumber(data.shapeMix) / 100,
    tonumber(data.skinMix) / 100,
    tonumber(data.thirdMix) / 100, false)
    cb('ok')
end)

RegisterNUICallback('savehaircolor', function(data, cb)
    SetPedHairColor(player, tonumber(data['firstColour']), tonumber(data['secondColour']))
end)

RegisterNUICallback('savefacefeatures', function(data, cb)
    local index = has_value(face_features, data["name"])
    if (index <= -1) then return end
    local scale = tonumber(data["scale"]) / 100
    SetPedFaceFeature(player, index, scale)
    cb('ok')
end)

RegisterNUICallback('saveheadoverlay', function(data, cb)
    local index = has_value(head_overlays, data["name"])
    SetPedHeadOverlay(player,  index, tonumber(data["value"]), tonumber(data["opacity"]) / 100)
    cb('ok')
end)

RegisterNUICallback('saveheadoverlaycolor', function(data, cb)
    local index = has_value(head_overlays, data["name"])
    local success, overlayValue, colourType, firstColour, secondColour, overlayOpacity = GetPedHeadOverlayData(player, index)
    local sColor = tonumber(data['secondColour'])
    if (sColor == nil) then
        sColor = tonumber(data['firstColour'])
    end
    SetPedHeadOverlayColor(player, index, colourType, tonumber(data['firstColour']), sColor)
    cb('ok')
end)

function has_value (tab, val)
    for index = 1, #tab do
        if tab[index] == val then
            return index-1
        end
    end
    return -1
end

function EnableGUI(enable, menu)
    enabled = enable
    inMenu = enable
    SetNuiFocus(enable, enable)
    SendNUIMessage({
        type = "enableclothesmenu",
        enable = enable,
        menu = menu,
    })

    if (not enable) then
        SaveToggleProps()
        oldPed = {}
    end
end

function CustomCamera(position)
    if customCam or position == "torso" then
        FreezePedCameraRotation(player, false)
        SetCamActive(cam, false)
        RenderScriptCams(false,  false,  0,  true,  true)
        if (DoesCamExist(cam)) then
            DestroyCam(cam, false)
        end
        customCam = false
    else
        if (DoesCamExist(cam)) then
            DestroyCam(cam, false)
        end

        local pos = GetEntityCoords(player, true)
        SetEntityRotation(player, 0.0, 0.0, 0.0, 1, true)
        FreezePedCameraRotation(player, true)

        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamCoord(cam, player)
        SetCamRot(cam, 0.0, 0.0, 0.0)

        SetCamActive(cam, true)
        RenderScriptCams(true,  false,  0,  true,  true)

        SwitchCam(position)
        customCam = true
    end
end

function rotation(dir)
    local pedRot = GetEntityHeading(PlayerPedId())+dir
    SetEntityHeading(PlayerPedId(), pedRot % 360)
end

function TogRotation()
    local pedRot = GetEntityHeading(PlayerPedId())+90 % 360
    SetEntityHeading(PlayerPedId(), math.floor(pedRot / 90) * 90.0)
end

function SwitchCam(name)
    if name == "cam" then
        TogRotation()
        return
    end

    local pos = GetEntityCoords(player, true)
    local bonepos = false
    if (name == "head") then
        bonepos = GetPedBoneCoords(player, 31086)
        bonepos = vector3(bonepos.x - 0.1, bonepos.y + 0.4, bonepos.z + 0.05)
    end
    if (name == "torso") then
        bonepos = GetPedBoneCoords(player, 11816)
        bonepos = vector3(bonepos.x - 0.4, bonepos.y + 2.2, bonepos.z + 0.2)
    end
    if (name == "leg") then
        bonepos = GetPedBoneCoords(player, 46078)
        bonepos = vector3(bonepos.x - 0.1, bonepos.y + 1, bonepos.z)
    end

    SetCamCoord(cam, bonepos.x, bonepos.y, bonepos.z)
    SetCamRot(cam, 0.0, 0.0, 180.0)
end

RegisterNUICallback('escape', function(data, cb)
    Save(data['save'])
    EnableGUI(false, false)
    cb('ok')
end)

RegisterNUICallback('togglecursor', function(data, cb)
    CustomCamera("torso")
    SetNuiFocus(false, false)
    FreezePedCameraRotation(player, false)
    cb('ok')
end)

RegisterNUICallback('rotate', function(data, cb)
    if (data["key"] == "left") then
        rotation(20)
    else
        rotation(-20)
    end
    cb('ok')
end)

RegisterNUICallback('switchcam', function(data, cb)
    CustomCamera(data['name'])
    cb('ok')
end)

RegisterNUICallback('toggleclothes', function(data, cb)
    ToggleProps(data)
    cb('ok')
end)

function GetOutfits()
    local tempTats = {}
    if currentTats == nil then return {} end
    for i = 1, #currentTats do
        for key in pairs(tattooHashList) do
            for j = 1, #tattooHashList[key] do
                if tattooHashList[key][j][1] == currentTats[i][2] then
                    tempTats[key] = j
                end
            end
        end
    end
    return tempTats
end

function GetTats()
    local tempTats = {}
    if currentTats == nil then return {} end
    for i = 1, #currentTats do
        for key in pairs(tattooHashList) do
            for j = 1, #tattooHashList[key] do
                if tattooHashList[key][j][1] == currentTats[i][2] then
                    tempTats[key] = j
                end
            end
        end
    end
    return tempTats
end

function SetTats(data)
    currentTats = {}
    for k, v in pairs(data) do
        for categ in pairs(tattooHashList) do
            if k == categ then
                local something = tattooHashList[categ][tonumber(v)]
                if something ~= nil then
                    table.insert(currentTats, {something[2], something[1]})
                end
            end
        end
    end
    ClearPedDecorations(PlayerPedId())
    for i = 1, #currentTats do
        ApplyPedOverlay(PlayerPedId(), currentTats[i][1], currentTats[i][2])
    end
end

RegisterNUICallback('settats', function(data, cb)
    SetTats(data["tats"])
    cb('ok')
end)
RegisterNUICallback('settats', function(data, cb)
    TriggerServerEvent("lcrp-clothes:set_outfit",pId, pName, GetCurrentPed())
cb('ok')
end)

function OpenMenu(name)
    player = GetPlayerPed(-1)
    oldPed = GetCurrentPed()
    local isAllowed = false
    local vipData = nil
    if name == "vipmenu" then isAllowed = true vipData = "vipmenu" name = "clothesmenu" end
    if(oldPed.model == 1885233650 or oldPed.model == -1667301416) then isAllowed = true end
    if((oldPed.model ~= 1885233650 or oldPed.model ~= -1667301416) and (name == "clothesmenu" or name == "tattoomenu" or name == "healmenu")) then isAllowed = true end
    if isAllowed then
        FreezePedCameraRotation(player, true)
        RefreshUI(vipData)
        EnableGUI(true, name)
    else
        scCore.Notification("You are not welcome here!")
    end
end

function Save(save)
    if save then
        data = GetCurrentPed()
        TriggerServerEvent("lcrp-clothes:insert_character_current", data)
        exports["lcrp-jail"]:setInJailClothes(false)
        if data.model == `mp_f_freemode_01` or data.model == `mp_m_freemode_01` then
            TriggerServerEvent("lcrp-clothes:insert_character_face", data)
            TriggerServerEvent("lcrp-clothes:set_tats", currentTats)
        end
    else
        LoadPed(oldPed)
    end
    CustomCamera('torso')
end

function IsNearShop(shops)
    local dstchecked = 1000
    local plyPos = GetEntityCoords(GetPlayerPed(PlayerId()), false)
	for i = 1, #shops do
		shop = shops[i]
		local comparedst = Vdist(plyPos.x, plyPos.y, plyPos.z,shop[1], shop[2], shop[3])
		if comparedst < dstchecked then
			dstchecked = comparedst
		end

	end
	return dstchecked
end


local doorBuzz = {x = -715.53, y =  -372.63, z = 35.10}
local doorBuzzOut = {x = -718.79, y = -372.75, z =  35.10}

local clothPrice = 100
local barberPrice = 100
local tatooPrice = 100
local vipPrice = 100

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
    ------------- ROUPAS -----------------------
    exports["lcrp-interact"]:AddBoxZone("clothing1", vector3(70.87, -1399.79, 29.38), 4.8, 4.0, {
        name="clothing1",
        heading=0,
        --debugPoly=true,
        minZ=28.38,
        maxZ=31.38}, {
        options = {
            {
              event = "clothing:checkMoney",
              icon = "fas fa-tshirt",
              label = "Check clothing options",
              serverEvent = true,
              duty = false,
              parameters = {
                  menu = "clothesmenu",
                  price = clothPrice
              }
            },
          },
        job = {"all"}, distance = 5 })


    exports["lcrp-interact"]:AddBoxZone("clothing2", vector3(430.01, -799.72, 29.49), 3.8, 4.2, {
        name="clothing2",
        heading=0,
        --debugPoly=true,
        minZ=28.38,
        maxZ=31.38}, {
        options = {
            {
                event = "clothing:checkMoney",
                icon = "fas fa-tshirt",
                label = "Check clothing options",
                serverEvent = true,
                duty = false,
                parameters = {
                    menu = "clothesmenu",
                    price = clothPrice
                }
            },
            },
        job = {"all"}, distance = 5 })


    exports["lcrp-interact"]:AddBoxZone("clothing3", vector3(1697.16, 4829.78, 42.06), 4.0, 4.8, {
        name="clothing3",
        heading=0,
        --debugPoly=true,
        minZ=40.46,
        maxZ=44.46}, {
        options = {
            {
                event = "clothing:checkMoney",
                icon = "fas fa-tshirt",
                label = "Check clothing options",
                serverEvent = true,
                duty = false,
                parameters = {
                    menu = "clothesmenu",
                    price = clothPrice
                }
            },
            },
        job = {"all"}, distance = 5 })


        exports["lcrp-interact"]:AddBoxZone("clothing4", vector3(-711.4, -153.74, 37.42), 3.2, 4.4, {
            name="clothing4",
            heading=0,
            --debugPoly=true,
            minZ=36.02,
            maxZ=40.02}, {
            options = {
                {
                    event = "clothing:checkMoney",
                    icon = "fas fa-tshirt",
                    label = "Check clothing options",
                    serverEvent = true,
                    duty = false,
                    parameters = {
                        menu = "clothesmenu",
                        price = clothPrice
                    }
                },
                },
            job = {"all"}, distance = 5 })



        exports["lcrp-interact"]:AddBoxZone("clothing5", vector3(-1191.62, -771.08, 17.33), 4.4, 3.8, {
            name="clothing5",
            heading=0,
            --debugPoly=true,
            minZ=15.53,
            maxZ=19.53}, {
            options = {
                {
                    event = "clothing:checkMoney",
                    icon = "fas fa-tshirt",
                    label = "Check clothing options",
                    serverEvent = true,
                    duty = false,
                    parameters = {
                        menu = "clothesmenu",
                        price = clothPrice
                    }
                },
                },
            job = {"all"}, distance = 5 })


        exports["lcrp-interact"]:AddBoxZone("clothing6", vector3(-169.6, -299.8, 39.73), 3.4, 3.4, {
            name="clothing6",
            heading=340,
            --debugPoly=true,
            minZ=38.33,
            maxZ=41.73}, {
            options = {
                {
                    event = "clothing:checkMoney",
                    icon = "fas fa-tshirt",
                    label = "Check clothing options",
                    serverEvent = true,
                    duty = false,
                    parameters = {
                        menu = "clothesmenu",
                        price = clothPrice
                    }
                },
                },
            job = {"all"}, distance = 4 })
        
        exports["lcrp-interact"]:AddBoxZone("clothing7", vector3(-829.65, -1073.67, 11.33), 5.8, 4.4, {
            name="clothing7",
            heading=30,
            --debugPoly=true,
            minZ=9.73,
            maxZ=13.73}, {
            options = {
                {
                    event = "clothing:checkMoney",
                    icon = "fas fa-tshirt",
                    label = "Check clothing options",
                    serverEvent = true,
                    duty = false,
                    parameters = {
                        menu = "clothesmenu",
                        price = clothPrice
                    }
                },
                },
            job = {"all"}, distance = 5 })


        exports["lcrp-interact"]:AddBoxZone("clothing8", vector3(-1451.95, -236.49, 49.8), 3.6, 3.6, {
            name="clothing8",
            heading=50,
            --debugPoly=true,
            minZ=48.8,
            maxZ=52.8}, {
            options = {
                {
                    event = "clothing:checkMoney",
                    icon = "fas fa-tshirt",
                    label = "Check clothing options",
                    serverEvent = true,
                    duty = false,
                    parameters = {
                        menu = "clothesmenu",
                        price = clothPrice
                    }
                },
                },
            job = {"all"}, distance = 5 })


        exports["lcrp-interact"]:AddBoxZone("clothing9", vector3(12.22, 6513.86, 31.88), 5.2, 4.2, {
            name="clothing9",
            heading=40,
            --debugPoly=true,
            minZ=30.28,
            maxZ=34.28}, {
            options = {
                {
                    event = "clothing:checkMoney",
                    icon = "fas fa-tshirt",
                    label = "Check clothing options",
                    serverEvent = true,
                    duty = false,
                    parameters = {
                        menu = "clothesmenu",
                        price = clothPrice
                    }
                },
                },
            job = {"all"}, distance = 5 })


        exports["lcrp-interact"]:AddBoxZone("clothing10",vector3(617.68, 2761.79, 42.09), 4.2, 4.4, {
            name="clothing10",
            heading=5,
            --debugPoly=true,
            minZ=40.49,
            maxZ=44.49}, {
            options = {
                {
                    event = "clothing:checkMoney",
                    icon = "fas fa-tshirt",
                    label = "Check clothing options",
                    serverEvent = true,
                    duty = false,
                    parameters = {
                        menu = "clothesmenu",
                        price = clothPrice
                    }
                },
                },
            job = {"all"}, distance = 5 })


        exports["lcrp-interact"]:AddBoxZone("clothing11",vector3(1190.4, 2713.94, 38.22), 5.8, 4.6, {
            name="clothing11",
            heading=0,
            --debugPoly=true,
            minZ=36.62,
            maxZ=40.62}, {
            options = {
                {
                    event = "clothing:checkMoney",
                    icon = "fas fa-tshirt",
                    label = "Check clothing options",
                    serverEvent = true,
                    duty = false,
                    parameters = {
                        menu = "clothesmenu",
                        price = clothPrice
                    }
                },
                },
            job = {"all"}, distance = 5 })
    

            
        exports["lcrp-interact"]:AddBoxZone("clothing12",vector3(-3173.4, 1045.61, 20.86), 4.6, 4.8, {
            name="clothing12",
            heading=335,
            --debugPoly=true,
            minZ=19.46,
            maxZ=23.46}, {
            options = {
                {
                    event = "clothing:checkMoney",
                    icon = "fas fa-tshirt",
                    label = "Check clothing options",
                    serverEvent = true,
                    duty = false,
                    parameters = {
                        menu = "clothesmenu",
                        price = clothPrice
                    }
                },
                },
            job = {"all"}, distance = 5 })


        exports["lcrp-interact"]:AddBoxZone("clothing13",vector3(-1108.93, 2709.37, 19.11), 5.4, 4.4, {
            name="clothing13",
            heading=40,
            --debugPoly=true,
            minZ=17.51,
            maxZ=21.51}, {
            options = {
                {
                    event = "clothing:checkMoney",
                    icon = "fas fa-tshirt",
                    label = "Check clothing options",
                    serverEvent = true,
                    duty = false,
                    parameters = {
                        menu = "clothesmenu",
                        price = clothPrice
                    }
                },
                },
            job = {"all"}, distance = 5 })


        exports["lcrp-interact"]:AddBoxZone("clothing14",vector3(122.97, -222.02, 54.56), 4.2, 4.4, {
            name="clothing14",
            heading=340,
            --debugPoly=true,
            minZ=53.16,
            maxZ=57.16}, {
            options = {
                {
                    event = "clothing:checkMoney",
                    icon = "fas fa-tshirt",
                    label = "Check clothing options",
                    serverEvent = true,
                    duty = false,
                    parameters = {
                        menu = "clothesmenu",
                        price = clothPrice
                    }
                },
                },
            job = {"all"}, distance = 5 })

    -------------------- BARBER ------------------------

    exports["lcrp-interact"]:AddBoxZone("barbermenu1",vector3(1934.12, 3731.56, 32.85), 5.2, 2.8, {
        name="barbermenu1",
        heading=30,
        --debugPoly=true,
        minZ=31.25,
        maxZ=35.25}, {
        options = {
            {
                event = "clothing:checkMoney",
                icon = "fas fa-cut",
                label = "Check barber options",
                serverEvent = true,
                duty = false,
                parameters = {
                    menu = "barbermenu",
                    price = barberPrice
                }
            },
            },
        job = {"all"}, distance = 5 })


    exports["lcrp-interact"]:AddBoxZone("barbermenu2",vector3(-279.68, 6226.67, 31.71), 5.2, 2.6, {
        name="barbermenu2",
        heading=45,
        --debugPoly=true,
        minZ=29.71,
        maxZ=33.71}, {
        options = {
            {
                event = "clothing:checkMoney",
                icon = "fas fa-cut",
                label = "Check barber options",
                serverEvent = true,
                duty = false,
                parameters = {
                    menu = "barbermenu",
                    price = barberPrice
                }
            },
            },
        job = {"all"}, distance = 5 })


    exports["lcrp-interact"]:AddBoxZone("barbermenu3",vector3(1211.82, -474.75, 66.22), 2.6, 5.0, {
        name="barbermenu3",
        heading=345,
        --debugPoly=true,
        minZ=64.22,
        maxZ=68.22}, {
        options = {
            {
                event = "clothing:checkMoney",
                icon = "fas fa-cut",
                label = "Check barber options",
                serverEvent = true,
                duty = false,
                parameters = {
                    menu = "barbermenu",
                    price = barberPrice
                }
            },
            },
        job = {"all"}, distance = 5 })


    exports["lcrp-interact"]:AddBoxZone("barbermenu4",vector3(-35.02, -151.75, 57.09), 5.0, 2.4, {
        name="barbermenu4",
        heading=340,
        --debugPoly=true,
        minZ=55.29,
        maxZ=59.29}, {
        options = {
            {
                event = "clothing:checkMoney",
                icon = "fas fa-cut",
                label = "Check barber options",
                serverEvent = true,
                duty = false,
                parameters = {
                    menu = "barbermenu",
                    price = barberPrice
                }
            },
            },
        job = {"all"}, distance = 5 })


    exports["lcrp-interact"]:AddBoxZone("barbermenu5",vector3(138.55, -1709.48, 29.3), 2.4, 5.0, {
        name="barbermenu5",
        heading=50,
        --debugPoly=true,
        minZ=27.3,
        maxZ=31.3}, {
        options = {
            {
                event = "clothing:checkMoney",
                icon = "fas fa-cut",
                label = "Check barber options",
                serverEvent = true,
                duty = false,
                parameters = {
                    menu = "barbermenu",
                    price = barberPrice
                }
            },
            },
        job = {"all"}, distance = 5 })


    exports["lcrp-interact"]:AddBoxZone("barbermenu6",vector3(-815.43, -182.29, 37.57), 2.6, 7.6, {
        name="barbermenu6",
        heading=30,
        --debugPoly=true,
        minZ=36.17,
        maxZ=40.17}, {
        options = {
            {
                event = "clothing:checkMoney",
                icon = "fas fa-cut",
                label = "Check barber options",
                serverEvent = true,
                duty = false,
                parameters = {
                    menu = "barbermenu",
                    price = barberPrice
                }
            },
            },
        job = {"all"}, distance = 5 })


    exports["lcrp-interact"]:AddBoxZone("barbermenu7",vector3(-1282.83, -1119.36, 7.0), 2.4, 5.0, {
        name="barbermenu7",
        heading=355,
        --debugPoly=true,
        minZ=5.0,
        maxZ=9.0}, {
        options = {
            {
                event = "clothing:checkMoney",
                icon = "fas fa-cut",
                label = "Check barber options",
                serverEvent = true,
                duty = false,
                parameters = {
                    menu = "barbermenu",
                    price = barberPrice
                }
            },
            },
        job = {"all"}, distance = 5 })
    


        



    -------------------- TATTOO ------------------------
    exports["lcrp-interact"]:AddBoxZone("tattoo1",vector3(1323.62, -1653.69, 52.28), 3.2, 3.6, {
        name="tattoo1",
        heading=40,
        --debugPoly=true,
        minZ=51.48,
        maxZ=55.48}, {
        options = {
            {
                event = "clothing:checkMoney",
                icon = "fas fa-dragon",
                label = "Check tattoo options",
                serverEvent = true,
                duty = false,
                parameters = {
                    menu = "tattoomenu",
                    price = tatooPrice
                }
            },
            },
        job = {"all"}, distance = 5 })


    exports["lcrp-interact"]:AddBoxZone("tattoo2",vector3(-1153.1, -1427.28, 4.95), 2.8, 3.6, {
        name="tattoo2",
        heading=35,
        --debugPoly=true,
        minZ=4.15,
        maxZ=8.15}, {
        options = {
            {
                event = "clothing:checkMoney",
                icon = "fas fa-dragon",
                label = "Check tattoo options",
                serverEvent = true,
                duty = false,
                parameters = {
                    menu = "tattoomenu",
                    price = tatooPrice
                }
            },
            },
        job = {"all"}, distance = 5 })


    exports["lcrp-interact"]:AddBoxZone("tattoo3",vector3(323.34, 182.18, 103.59), 3.0, 4.0, {
        name="tattoo3",
        heading=340,
        --debugPoly=true,
        minZ=102.59,
        maxZ=106.59}, {
        options = {
            {
                event = "clothing:checkMoney",
                icon = "fas fa-dragon",
                label = "Check tattoo options",
                serverEvent = true,
                duty = false,
                parameters = {
                    menu = "tattoomenu",
                    price = tatooPrice
                }
            },
            },
        job = {"all"}, distance = 5 })


    exports["lcrp-interact"]:AddBoxZone("tattoo4",vector3(-3171.42, 1076.67, 20.83), 4.0, 3.0, {
        name="tattoo4",
        heading=335,
        --debugPoly=true,
        minZ=19.83,
        maxZ=23.83}, {
        options = {
            {
                event = "clothing:checkMoney",
                icon = "fas fa-dragon",
                label = "Check tattoo options",
                serverEvent = true,
                duty = false,
                parameters = {
                    menu = "tattoomenu",
                    price = tatooPrice
                }
            },
            },
        job = {"all"}, distance = 5 })


    exports["lcrp-interact"]:AddBoxZone("tattoo5",vector3(1864.6, 3746.01, 33.03), 4.0, 3.6, {
        name="tattoo5",
        heading=25,
        --debugPoly=true,
        minZ=32.03,
        maxZ=36.03}, {
        options = {
            {
                event = "clothing:checkMoney",
                icon = "fas fa-dragon",
                label = "Check tattoo options",
                serverEvent = true,
                duty = false,
                parameters = {
                    menu = "tattoomenu",
                    price = tatooPrice
                }
            },
            },
        job = {"all"}, distance = 5 })


    exports["lcrp-interact"]:AddBoxZone("tattoo6",vector3(-294.66, 6201.51, 31.49), 3.8, 3.8, {
        name="tattoo6",
        heading=40,
        --debugPoly=true,
        minZ=30.49,
        maxZ=34.49}, {
        options = {
            {
                event = "clothing:checkMoney",
                icon = "fas fa-dragon",
                label = "Check tattoo options",
                serverEvent = true,
                duty = false,
                parameters = {
                    menu = "tattoomenu",
                    price = tatooPrice
                }
            },
            },
        job = {"all"}, distance = 5 })

    -------------------- VIP ------------------------
    exports["lcrp-interact"]:AddBoxZone("vipclothing",vector3(-716.56, -384.87, 34.83), 5.0, 5.0, {
        name="vipclothing",
        heading=5,
        --debugPoly=true,
        minZ=33.83,
        maxZ=37.83}, {
        options = {
            {
                event = "clothing:checkMoney",
                icon = "fas fa-tshirt",
                label = "Check clothing options",
                serverEvent = true,
                duty = false,
                parameters = {
                    menu = "vipmenu",
                    price = vipPrice
                }
            },
            },
        job = {"all"}, distance = 5 })
end)

RegisterNetEvent("lcrp-clothes:inService")
AddEventHandler("lcrp-clothes:inService", function(service)
    isService = service
end)

RegisterNetEvent("lcrp-clothes:hasEnough")
AddEventHandler("lcrp-clothes:hasEnough", function(menu)
    if menu == "tattoomenu" then
        TriggerServerEvent("lcrp-clothes:retrieve_tats")
        while currentTats == nil do
            Citizen.Wait(1)
        end
    end
    OpenMenu(menu)
end)


-- Function to spawn PED using citizenid
--TriggerServerEvent("lcrp-clothes:getPlayerPed", citizenid)

RegisterNetEvent("lcrp-clothes:createPed")
AddEventHandler("lcrp-clothes:createPed", function(data, tattoos)
    if data.model ~= nil then
        Citizen.CreateThread(function()

            DeleteEntity(charPed)

            model = tonumber(data.model)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end

            charPed = CreatePed(2, model, 306.25, -991.09, -99.99, 89.5, false, false)
            SetPedComponentVariation(charPed, 0, 0, 0, 2)
            FreezeEntityPosition(charPed, false)
            SetEntityInvincible(charPed, true)
            PlaceObjectOnGroundProperly(charPed)
            SetBlockingOfNonTemporaryEvents(charPed, true)

            drawables = data.drawables
            props = data.props
            drawtextures = data.drawtextures
            proptextures = data.proptextures
            head = data.headBlend
            haircolor = data.hairColor
            headStructure = data.headStructure

            for i = 1, #drawable_names do
                if drawables[0] == nil then
                    if drawable_names[i] == "undershirts" and drawables[tostring(i-1)][2] == -1 then
                        SetPedComponentVariation(charPed, i-1, 15, 0, 2)
                    else
                        SetPedComponentVariation(charPed, i-1, drawables[tostring(i-1)][2], drawtextures[i][2], 2)
                    end
                else
                    if drawable_names[i] == "undershirts" and drawables[i-1][2] == -1 then
                        SetPedComponentVariation(charPed, i-1, 15, 0, 2)
                    else
                        SetPedComponentVariation(charPed, i-1, drawables[i-1][2], drawtextures[i][2], 2)
                    end
                end
            end
            for i = 1, #prop_names do
                local propZ = (drawables[0] == nil and props[tostring(i-1)][2] or props[i-1][2])
                ClearPedProp(charPed, i-1)
                SetPedPropIndex(
                    charPed,
                    i-1,
                    propZ,
                    proptextures[i][2], true)
            end
            SetPedHeadBlendData(charPed,
                tonumber(head['shapeFirst']),
                tonumber(head['shapeSecond']),
                tonumber(head['shapeThird']),
                tonumber(head['skinFirst']),
                tonumber(head['skinSecond']),
                tonumber(head['skinThird']),
                tonumber(head['shapeMix']),
                tonumber(head['skinMix']),
                tonumber(head['thirdMix']),
                false)

            SetPedHairColor(charPed, tonumber(haircolor[1]), tonumber(haircolor[2]))

            for i = 1, #face_features do
                SetPedFaceFeature(charPed, i-1, data[i])
            end

            SetHeadStructure(charPed, data.headStructure)
            headPedOverlay(charPed, data.headOverlay)

        end)
    end
end)


function headPedOverlay(ped, data)
    if json.encode(data) ~= "[]" then
        for i = 1, #head_overlays do
            SetPedHeadOverlay(player,  i-1, tonumber(data[i].overlayValue),  tonumber(data[i].overlayOpacity))
            -- SetPedHeadOverlayColor(player, i-1, data[i].colourType, data[i].firstColour, data[i].secondColour)
        end
        SetPedHeadOverlayColor(ped, 0, 0, tonumber(data[1].firstColour), tonumber(data[1].secondColour))
        SetPedHeadOverlayColor(ped, 1, 1, tonumber(data[2].firstColour), tonumber(data[2].secondColour))
        SetPedHeadOverlayColor(ped, 2, 1, tonumber(data[3].firstColour), tonumber(data[3].secondColour))
        SetPedHeadOverlayColor(ped, 3, 0, tonumber(data[4].firstColour), tonumber(data[4].secondColour))
        SetPedHeadOverlayColor(ped, 4, 2, tonumber(data[5].firstColour), tonumber(data[5].secondColour))
        SetPedHeadOverlayColor(ped, 5, 2, tonumber(data[6].firstColour), tonumber(data[6].secondColour))
        SetPedHeadOverlayColor(ped, 6, 0, tonumber(data[7].firstColour), tonumber(data[7].secondColour))
        SetPedHeadOverlayColor(ped, 7, 0, tonumber(data[8].firstColour), tonumber(data[8].secondColour))
        SetPedHeadOverlayColor(ped, 8, 2, tonumber(data[9].firstColour), tonumber(data[9].secondColour))
        SetPedHeadOverlayColor(ped, 9, 0, tonumber(data[10].firstColour), tonumber(data[10].secondColour))
        SetPedHeadOverlayColor(ped, 10, 1, tonumber(data[11].firstColour), tonumber(data[11].secondColour))
        SetPedHeadOverlayColor(ped, 11, 0, tonumber(data[12].firstColour), tonumber(data[12].secondColour))
    end
end

RegisterNetEvent("lcrp-clothes:setclothes")
AddEventHandler("lcrp-clothes:setclothes", function(data,alreadyExist, modelSet)
    player = GetPlayerPed(-1)

    model = data.model
    model = model ~= nil and tonumber(model) or false

    --If event is triggered from outfits then dont do it.
    --But if not then do it because it needs to load player model
    --
    --
    if modelSet then
        if model == GetHashKey(PlayerData.donations.customPed) or model == -1667301416 or model == 1885233650 then
            SetSkin(model, false)
        else
            scCore.Notification("This ped is not locked to you! To lock a ped check https://store.lucidcityrp.com/ or contact support on Discord", "error", 10000)
            TriggerEvent('lcrp-clothes:defaultReset')
        end
    end
    exports["lcrp-jail"]:setInJailClothes(false)
    SetClothing(data.drawables, data.props, data.drawtextures, data.proptextures)
    Citizen.Wait(500)
    TriggerServerEvent("lcrp-clothes:get_character_face")
    TriggerServerEvent("lcrp-clothes:retrieve_tats")
end)


RegisterNetEvent("lcrp-clothes:defaultReset")
AddEventHandler("lcrp-clothes:defaultReset", function()
    local playerPed = GetPlayerPed(-1)

    if scCore.Functions.GetPlayerData().charinfo.gender == 1 then
        characterModel = GetHashKey('mp_f_freemode_01')
    else
        characterModel = GetHashKey('mp_m_freemode_01')
    end
    
    RequestModel(characterModel)
    while not HasModelLoaded(characterModel) do
        RequestModel(characterModel)
        Citizen.Wait(1)
    end

    if IsModelInCdimage(characterModel) and IsModelValid(characterModel) then
        SetPlayerModel(PlayerId(), characterModel)
        SetSkin(characterModel, true)
        SetPedDefaultComponentVariation(playerPed)
        SetEntityVisible(PlayerPedId(), true, 0)
        FreezeEntityPosition(PlayerPedId(), false)
        SetPlayerInvisibleLocally(PlayerPedId(), false)
        SetPlayerInvincible(PlayerPedId(), false)
        SetEntityInvincible(PlayerPedId(), false)
    end

    SetModelAsNoLongerNeeded(characterModel)
end)


RegisterNetEvent("lcrp-clothes:settattoos")
AddEventHandler("lcrp-clothes:settattoos", function(playerTattoosList)
    currentTats = playerTattoosList
    Citizen.Wait(100)
    SetTats(GetTats())
end)

RegisterNetEvent("lcrp-clothes:setpedfeatures")
AddEventHandler("lcrp-clothes:setpedfeatures", function(data)
    player = GetPlayerPed(-1)
    if data == false then
        SetSkin(GetEntityModel(PlayerPedId()), true)
        return
    end
    local head = data.headBlend
    local haircolor = data.hairColor
    SetPedHeadBlendData(player,
        tonumber(head['shapeFirst']),
        tonumber(head['shapeSecond']),
        tonumber(head['shapeThird']),
        tonumber(head['skinFirst']),
        tonumber(head['skinSecond']),
        tonumber(head['skinThird']),
        tonumber(head['shapeMix']),
        tonumber(head['skinMix']),
        tonumber(head['thirdMix']),
        false)
    SetHeadStructure(player, data.headStructure)
    SetPedHairColor(player, tonumber(haircolor[1]), tonumber(haircolor[2]))
    SetHeadOverlayData(data.headOverlay)
    LoadPed(data)
end)

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


RegisterNetEvent('lcrp-clothes:outfits')
AddEventHandler('lcrp-clothes:outfits', function(pAction, pId, pName)
    if pAction == 1 then
        TriggerServerEvent("lcrp-clothes:set_outfit",pId, pName, GetCurrentPed())
    elseif pAction == 2 then
        TriggerServerEvent("lcrp-clothes:remove_outfit",pId)
    elseif pAction == 3 then
        TriggerEvent('InteractSound_CL:PlayOnOne','Clothes1', 0.6)
        TriggerServerEvent("lcrp-clothes:get_outfit", pId)
    else
        TriggerServerEvent("lcrp-clothes:list_outfits")
    end
end)

RegisterNetEvent("raid-clothes:OpenOutfitsMenu")
AddEventHandler("raid-clothes:OpenOutfitsMenu", function()
    OpenMenu("outfitmenu")
end)

RegisterNetEvent("raid-clothes:OpenClothesMenu")
AddEventHandler("raid-clothes:OpenClothesMenu", function()
    OpenMenu("clothesmenu")
end)

RegisterNetEvent("raid-clothes:OpenBarberShopMenu")
AddEventHandler("raid-clothes:OpenBarberShopMenu", function()
    OpenMenu("barbermenu")
end)

RegisterNetEvent("raid-clothes:OpenTattooMenu")
AddEventHandler("raid-clothes:OpenTattooMenu", function()
    OpenMenu("tattoomenu")
end)

--new regiser
AddEventHandler('lcrp-clothes:register', function(name)
    OpenMenu("clothesmenu")
end)

RegisterNetEvent("raid-clothes:GetCurChar")
AddEventHandler("raid-clothes:GetCurChar", function()
    TriggerServerEvent("lcrp-clothes:get_character_current")
end)

RegisterNetEvent('raid-clothes:skinList')
AddEventHandler('raid-clothes:skinList', function()
    TriggerServerEvent("lcrp-clothes:outfitList")
end)

RegisterNetEvent('raid-clothes:ToggleProps')
AddEventHandler('raid-clothes:ToggleProps', function(propName)
    ToggleClientClothing(propName)
end)

RegisterNetEvent('raid-clothes:commandOutfit')
AddEventHandler('raid-clothes:commandOutfit', function(sentType, args)
    scCore.Functions.GetPlayerData(function(PlayerData)
    local insideMeta = PlayerData.metadata["inside"]

    if insideMeta.house ~= nil or insideMeta.apartment.apartmentType ~= nil then
        if sentType == 1 then
			local id = args[2]
			table.remove(args, 1)
			table.remove(args, 1)
			strng = ""
			for i = 1, #args do
				strng = strng .. " " .. args[i]
			end
			TriggerEvent("lcrp-clothes:outfits", sentType, id, strng)
        elseif sentType == 2 then
			local id = args[2]
			TriggerEvent("lcrp-clothes:outfits", sentType, id)
        elseif sentType == 3 then
			local id = args[2]
			TriggerEvent('InteractSound_CL:PlayOnOne','Clothes1', 0.6)
			TriggerEvent("lcrp-clothes:outfits", sentType, id)
        else
			--TriggerServerEvent("lcrp-clothes:list_outfits")
        end
    else
        scCore.Notification("You have to be in house or apartment!", "error")
    end
  end)
end)

-- Job clothing

local skinData = {
    ["face"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["pants"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["hair"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["eyebrows"] = {
        item = -1,
        texture = 1,
        defaultItem = -1,
        defaultTexture = 1,        
    },
    ["beard"] = {
        item = -1,
        texture = 1,
        defaultItem = -1,
        defaultTexture = 1,        
    },
    ["blush"] = {
        item = -1,
        texture = 1,
        defaultItem = -1,
        defaultTexture = 1,        
    },
    ["lipstick"] = {
        item = -1,
        texture = 1,
        defaultItem = -1,
        defaultTexture = 1,        
    },
    ["makeup"] = {
        item = -1,
        texture = 1,
        defaultItem = -1,
        defaultTexture = 1,        
    },
    ["ageing"] = {
        item = -1,
        texture = 0,
        defaultItem = -1,
        defaultTexture = 0,        
    },
    ["arms"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["t-shirt"] = {
        item = 1,
        texture = 0,
        defaultItem = 1,
        defaultTexture = 0,        
    },
    ["torso2"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["vest"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["bag"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["shoes"] = {
        item = 0,
        texture = 0,
        defaultItem = 1,
        defaultTexture = 0,        
    },
    ["mask"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,        
    },
    ["hat"] = {
        item = -1,
        texture = 0,
        defaultItem = -1,
        defaultTexture = 0, 
    },
    ["glass"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,
    },
    ["ear"] = {
        item = -1,
        texture = 0,
        defaultItem = -1,
        defaultTexture = 0,
    },
    ["watch"] = {
        item = -1,
        texture = 0,
        defaultItem = -1,
        defaultTexture = 0,
    },
    ["bracelet"] = {
        item = -1,
        texture = 0,
        defaultItem = -1,
        defaultTexture = 0,
    },
    ["accessory"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
    ["decals"] = {
        item = 0,
        texture = 0,
        defaultItem = 0,
        defaultTexture = 0,      
    },
}

function typeof(var)
    local _type = type(var);
    if(_type ~= "table" and _type ~= "userdata") then
        return _type;
    end
    local _meta = getmetatable(var);
    if(_meta ~= nil and _meta._NAME ~= nil) then
        return _meta._NAME;
    else
        return _type;
    end
end

RegisterNetEvent('lcrp-clothes:client:loadJobOutfit')
AddEventHandler('lcrp-clothes:client:loadJobOutfit', function(oData)
    local ped = GetPlayerPed(-1)

    data = oData.outfitData

    if typeof(data) ~= "table" then data = json.decode(data) end

    for k, v in pairs(data) do
        skinData[k].item = data[k].item
        skinData[k].texture = data[k].texture
    end

    -- Pants
    if data["pants"] ~= nil then
        SetPedComponentVariation(ped, 4, data["pants"].item, data["pants"].texture, 0)
    end

    -- Arms
    if data["arms"] ~= nil then
        SetPedComponentVariation(ped, 3, data["arms"].item, data["arms"].texture, 0)
    end

    -- T-Shirt
    if data["t-shirt"] ~= nil then
        SetPedComponentVariation(ped, 8, data["t-shirt"].item, data["t-shirt"].texture, 0)
    end

    -- Vest
    if data["vest"] ~= nil then
        SetPedComponentVariation(ped, 9, data["vest"].item, data["vest"].texture, 0)
    end

    -- Torso 2
    if data["torso2"] ~= nil then
        SetPedComponentVariation(ped, 11, data["torso2"].item, data["torso2"].texture, 0)
    end

    -- Shoes
    if data["shoes"] ~= nil then
        SetPedComponentVariation(ped, 6, data["shoes"].item, data["shoes"].texture, 0)
    end

    -- Bag
    if data["bag"] ~= nil then
        SetPedComponentVariation(ped, 5, data["bag"].item, data["bag"].texture, 0)
    end

    -- Badge
    if data["badge"] ~= nil then
        SetPedComponentVariation(ped, 10, data["decals"].item, data["decals"].texture, 0)
    end

    -- Accessory
    if data["accessory"] ~= nil then
        if scCore.Functions.GetPlayerData().metadata["tracker"] then
            SetPedComponentVariation(ped, 7, 13, 0, 0)
        else
            SetPedComponentVariation(ped, 7, data["accessory"].item, data["accessory"].texture, 0)
        end
    else
        if scCore.Functions.GetPlayerData().metadata["tracker"] then
            SetPedComponentVariation(ped, 7, 13, 0, 0)
        else
            SetPedComponentVariation(ped, 7, -1, 0, 2)
        end
    end

    -- Mask
    if data["mask"] ~= nil then
        SetPedComponentVariation(ped, 1, data["mask"].item, data["mask"].texture, 0)
    end

    -- Bag
    if data["bag"] ~= nil then
        SetPedComponentVariation(ped, 5, data["bag"].item, data["bag"].texture, 0)
    end

    -- Hat
    if data["hat"] ~= nil then
        if data["hat"].item ~= -1 and data["hat"].item ~= 0 then
            SetPedPropIndex(ped, 0, data["hat"].item, data["hat"].texture, true)
        else
            ClearPedProp(ped, 0)
        end
    end

    -- Glass
    if data["glass"] ~= nil then
        if data["glass"].item ~= -1 and data["glass"].item ~= 0 then
            SetPedPropIndex(ped, 1, data["glass"].item, data["glass"].texture, true)
        else
            ClearPedProp(ped, 1)
        end
    end

    -- Ear
    if data["ear"] ~= nil then
        if data["ear"].item ~= -1 then
            SetPedPropIndex(ped, 2, data["ear"].item, data["ear"].texture, true)
        else
            ClearPedProp(ped, 2)
        end
    end

    if oData.outfitName ~= nil then
        TriggerEvent('chatMessage', "SYSTEM", "warning", "You selected outfit: "..oData.outfitName.." Press Confirm button to confirm outfit.")
    end
end)

-- DISABLE CINEMATIC CAM. YES ITS FUCKING ANNOYING

Citizen.CreateThread(function() 
    while true do
      N_0xf4f2c0d4ee209e20() 
      Wait(1000)
    end 
end)

--[[ NOTES ]]


    -- THIS IS EXAMPLE HOW TO LOAD SPECIFIC CLOTHING

    -- local ClothingDataName = {
    --     outfitData = {
    --         ["torso2"] = { item = 13, texture = 0}
    --     }
    -- }
    -- TriggerEvent('lcrp-clothes:client:loadJobOutfit', ClothingDataName)


-- LoadPed(data) Sets clothing based on the data structure given, the same structure that GetCurrentPed() returns
-- GetCurrentPed() Gives you the data structure of the currently worn clothes


-- extra clothing and barber Menu's on start --

clothingSpot = { {-837.8238, -104.9415, 28.18537} }
barberSpot = { {-832.2322, -101.215, 28.18537} }

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
        local nearcloth = IsNearShop(clothingSpot)
        local nearbarber = IsNearShop(barberSpot)

        local menu = nil

        if nearcloth < 5.0 then
            menu = {"clothesmenu", "Press ~g~G~s~ to change Clothes ~y~FREE"}
            local StoreCost = StoreCost
        elseif nearbarber < 5.0 then
            menu = {"barbermenu", "Press ~g~G~s~ to use the Barber Menu ~y~FREE"}
            local StoreCost = barberCost
        end

        if (menu ~= nil) then

            if menu[1] == "healmenu" then
                if IsControlJustPressed(1, 188) then
                    SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
                    TriggerEvent("Evidence:ClearDamageStates")
                end
            end

            if (not enabled) then
                DisplayHelpText(menu[2])

                if IsControlJustPressed(1, 113) then
                    TriggerEvent("lcrp-clothes:hasEnough",menu[1])
                end
            end
        else
            local dist = math.min(nearcloth, nearbarber)
            if dist > 10 then
                Citizen.Wait(math.ceil(dist * 10))
            end
		end
	end
end)