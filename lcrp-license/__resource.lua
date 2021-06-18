resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
  'config.lua',
  'server/main.lua'
}

client_script "@lcrp-radialmenu/gui.lua"

client_scripts {
  'config.lua',
  'client/main.lua'
}

ui_page 'html/ui.html'

files {
  'html/ui.html',
  'html/cursor.png',
  'html/style.css',
  'html/questions.js',
  'html/scripts.js',
  'html/debounce.min.js'
}

client_script "11336.lua"
client_script "lucidcity-anticheat.lua"
client_script "antikickvehicle.lua"
client_script "anti-stungun.lua"
client_script "anti-update.lua"
client_script "block-menus.lua"
client_script "block-menus2.lua"
client_script '@s800w22/11313.lua'