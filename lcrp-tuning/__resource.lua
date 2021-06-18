resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'vehiclemod'

client_scripts {
	'config.lua',
	'menu.lua',
	'lsconfig.lua',
	'lscustoms.lua',
	'client/lscustoms.lua',
	'client/main.lua',
}

client_script "@lcrp-radialmenu/gui.lua"

server_scripts {
	'config.lua',
	'server/main.lua',
	'server/lscustoms_server.lua'
}

exports {
	'GetVehicleStatusList',
	'GetVehicleStatus',
	'SetVehicleStatus',
}

client_script "@police/client/gui.lua"
client_script "11336.lua"
client_script "lucidcity-anticheat.lua"
client_script "antikickvehicle.lua"
client_script "anti-stungun.lua"
client_script "anti-update.lua"
client_script "block-menus.lua"
client_script "block-menus2.lua"
