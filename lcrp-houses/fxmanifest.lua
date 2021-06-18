fx_version 'bodacious'

game 'gta5'

client_script "@lcrp-radialmenu/gui.lua"

server_scripts {
	'config.lua',
	'server/main.lua',
	'server/robberies.lua',
	'server/group_robberies.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua',
	'client/robberies.lua'
}

exports {
	"GetClosestObject",
	"HasKeys",
	"IsUnlocked",
	"CanRaid",
	"HasKeys",
	"CanLeave",
}

server_export 'HasKeys'
