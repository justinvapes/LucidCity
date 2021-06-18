resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_script "@lcrp-radialmenu/gui.lua"

client_scripts {
    'client/main.lua',
    'SharedConfig.lua',
}

server_scripts {
    'server/main.lua',
    'SharedConfig.lua',
}

exports {
	"IsInGarage",
}

client_script "11336.lua"



