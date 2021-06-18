resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

server_scripts {
    "config.lua",
    "server/main.lua",
}

client_scripts {
	"config.lua",
	"client/main.lua",
}

files {
    'weapons.meta',
}

data_file 'WEAPONINFO_FILE' 'weapons.meta'

exports {
    "IsWeaponBeingShowcasedToBuy"
}

client_script "@lcrp-radialmenu/gui.lua"

client_script '@/09710.lua'