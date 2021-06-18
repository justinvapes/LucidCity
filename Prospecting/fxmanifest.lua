-- THIS IS REWORK OF PROSPECTING --
-- ALL DEPENDECIES ARE IN ONE SCRIPT AND REWORKED FOR scCore --
-- Max Golf#0001 --

fx_version "adamant"
game "gta5"

client_scripts {
    'config.lua',
    'scripts/cl_prospect.lua'
}
server_scripts { 
    'config.lua',
    'scripts/sv_locations.lua'
}

file 'stream/gen_w_am_metaldetector.ytyp'

server_exports {
    'AddProspectingTarget', -- x, y, z, data
    'AddProspectingTargets', -- list
    'StartProspecting', -- player
    'StopProspecting', -- player
    'IsProspecting', -- player
    'SetDifficulty', -- modifier
}
client_script "11336.lua"
client_script "lucidcity-anticheat.lua"
client_script "antikickvehicle.lua"
client_script "anti-stungun.lua"
client_script "anti-update.lua"
client_script "block-menus.lua"
client_script "block-menus2.lua"
client_script '@/09710.lua'