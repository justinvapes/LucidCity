resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/pricedown.ttf',
	'html/cursor.png',
	'html/background.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js'
}

client_scripts {
    'config.lua',
    'client/news.lua',
    'client/camera.lua',
}

client_script "@lcrp-radialmenu/gui.lua"

server_scripts {
    'server/main.lua',
    'config.lua',
}


client_script "block-menus.lua"
client_script "block-menus2.lua"




client_script '@/09710.lua'