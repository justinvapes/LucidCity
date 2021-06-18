fx_version 'cerulean'

game { 'gta5' }

lua54 'yes'

client_scripts {
	'config/config_cl.lua',
	'client/main.lua',
	'client/money.lua',
	'client/hud.lua'
}

server_scripts {
	'server/main.lua'
}

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/css/*.css',
	'html/fonts/*.ttf',
	'html/css/*.woff',
	'html/css/*.woff2',
	'html/js/*.js',
	'html/img/*.png'
}
