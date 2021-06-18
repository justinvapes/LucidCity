Config = {}

Config.CurrencyIcon = '$' -- ADJUST TO YOUR CURRENCY ICON

Config.ModelWaitTicks = 500 -- MODEL WAIT TIME( 500 IS DEFAULT ENOUGH TIME, IF YOU EXPERIENCE "MODEL FAILED TO LOAD, PLEASE ATTEMPT RELOGGIN" CONSTANTLY, THEN INCREASE THIS TIMER

Config.Parking = {
	ScriptParking = true, -- SET TRUE TO USE SCRIPT PARKING FOR EACH HOME(SELECT PARKING TYPE PER HOUSE IN GAME), SET FALSE TO USE A PRIVATE PARKING SYSTEM(FUNCTION CHOSEN IN CONFIG.CREATION TABLE)
	AllowAll = false, -- SET TRUE TO ALLOW ANYONE TO PARK IN ANY OWNED PARKING SPOT, FALSE TO ALLOW ONLY THE OWNER OR KEY HOLDER
	AllowNil = false, -- SET TRUE TO ALLOW PLAYERS TO USE NON-OWNED HOME PARKING SPOTS
	GarageStoreEvent = function(ped, veh)
		TriggerEvent('SSCompleteHousing:garageCarEvent', ped, veh)
	end,
	GarageOpenEvent = function(location)
		TriggerEvent('SSCompleteHousing:openGarageEvent', location)
	end
}

Config.DisableMLOMarkersUntilUnlocked = true -- SET FALSE TO ALLOW USING MLO STORAGE WHILE A HOUSE IS LOCKED SET TRUE TO MAKE AN MLO BE UNLOCKED TO OPEN STORAGE

Config.BlinkOnRefresh = false -- SET TRUE TO HAVE ALL PLAYERS 'BLINK' WHEN MARKERS/LOCKS UPDATE, SET FALSE TO REMOVE 'BLINK'

Config.BoughtHouseLimit = 2 -- SET LIMIT OF HOMES A PLAYER CAN BUY(0 IS UNLIMITED)

Config.ReconnectInside = false -- SET TRUE TO ALLOW THE PLAYER WHO SPAWNS A HOME TO RETURN TO THE HOME ON RECONNECT
-- IF YOU HAVE ISSUES SPAWNING INTO THE HOME ON CONNECT, THERE IS NO FIX THEY SIMPLY MUST BE SPAWNED AT THE DOOR INSTEAD, SET THE VALUE FALSE

Config.Weather = { -- SET ALL IN-HOME WEATHER OPTIONS HERE: SETHOUSEWEATHER(SHOULD SCRIPT RUN A WEATHER SYNC IN HOMES), RAININTENSITY(AMOUNT OF RAIN IN HOME), WEATHERTYPE(WEATHER TYPE IN HOME), CLOCKTIME(IN-GAME TIME IN HOME)
	SetHouseWeather = true,
	RainIntensity = 0.0,
	WeatherType = 'overcast',
	ClockTime = vector3(0, 0, 0) -- HOURS, MINUTES, SECONDS
}

Config.Keys = { -- KEYS TO REGISTER FOR COMMANDS: KEYBOARD KEY TO HAVE AS INITIALLY MAPPED COMMAND KEY
	UnLock = 'l',
}

Config.HelpText = { -- SET DISPLAY LOCATION OF FURNISHING HELP TEXT, VALUES RANGE FROM 0.0 TO 1.0, 0.0 AT TOP/LEFT 1.0 AT BOTTOM/RIGHT
	X = 0.01,
	Y = 0.01
}

Config.SpecialProperties = { -- SET SPECIAL PROPERY OPTIONS HERE: USE(SHOULD SCRIPT USE PROPERTIES PURCHASABLE WITH SPECIAL MONEY), ACCOUNT(SPECIAL MONEY ACCOUNT NAME),
	-- ACCOUNTLABEL(NAME TO DISPLAY IN GAME FOR ACCOUNT), PERCETNAGE(PERCENTAGE OF SALE PRICE TO CHARGE FOR SPECIAL MONEY)
	Use = true,
	Account = 'black_money',
	AccountLabel = 'Real Dollars',
	Percentage = 0.1
}

Config.MonthlyContracts = { -- WIP I THINK: SET IF HOMES ARE REQUIRED TO BE RE-BOUGHT EVERY 30 DAYS < REAL LIFE DAYS
	Use = false,
	Percent = 15
}

Config.OwnedVehicleTable = { -- SET OWNED_VEHICLE DATABASE TABLE 'STATE' NAME: USUALLY 'state' OR 'stored'
	name = 'stored',
	notParked = 0, -- SET OWNED_VEHICLE DATABASE TABLE NOT PARKED 'STATE' VALUE: TYPICALLY A NUMBER 0/1, NOTICED ADVANCED GARAGE USES TRUE/FALSE
}

Config.Markers = { -- SET ALL MARKER INFORMATION HERE: ENTER/EXIT FURN STORE, EXITS FOR HOMES, STORAGE/WARDROBE LOCATIONS, OWNED HOUSE DOORS/PARKINGS, UNOWNED HOUSE DOORS/PARKINGS, OTHER PLAYER HOUSE DOORS/PARKINGS
	FurnMarkers = true,
	ExitMarkers = true,
	IntMarkers = true,
	OwnedMarkers = true,
	UnOwnedMarks = true,
	OtherMarkers = true
}

Config.Blips = { -- SET ALL BLIP INFORMATION HERE: USE(SHOULD THESE BLIPS EVEN TRY TO BE MADE), SPRITE(PICTURE ON MAP), COLOR(COLOR OF PICTURE ON MAP THERE IS A LIST ONLINE AT https://docs.fivem.net/docs/game-references/blips/,
	-- SCALE(SIZE OF PICTURE ON MAP), DISPLAY(MAP DISPLAY TYPE DETAILS FOLLOWING OR HERE https://runtime.fivem.net/doc/natives/?_0x9029B2F3DA924928,
	-- TEXT(WHAT NAME TO SHOW ON MAP, SCRIPT REPLACES 'USEADDRESS' STRING WITH PROPERTY ADDRESS, CREATES NEW BLIP FOR EACH PROPERTY)
	Furniture = {
		Use = true,
		Sprite = 566, -- GET SPRITE/COLOR VALUES HERE https://docs.fivem.net/docs/game-references/blips/
		Color = 0,
		Scale = 1.0,
		Display = 4, -- MAP DISPLAY TYPE: 4 IS VIEWABLE ON BOTH MAIN AND MINI-MAP
		Text = 'Furniture Store'
	},
	OwnedHome = {
		Use = true,
		Sprite = 40,
		Color = 68,
		Scale = 0.8,
		Display = 4,
		Text = 'useaddress'
	},
	UnOwnedHome = {
		Use = true,
		Sprite = 350,
		Color = 0,
		Scale = 1.0,
		Display = 5, -- MAP DISPLAY TYPE: 5 IS VIEWABLE ON MINI-MAP ONLY
		Text = 'Unowned Property'
	},
	OtherOwnedHome = {
		Use = true,
		Sprite = 40,
		Color = 1,
		Scale = 1.0,
		Display = 5,
		Text = 'useaddress ~r~Owned'
	}
}

Config.KeyOptions = { -- SET KEY ACCESS HERE: ITEM(KEY ITEM INFORMATION(REQUIRE(SHOULD PLAYERS NEED AN ITEM), NAME(DATABASE NAME FOR KEY ITEM), LABEL(NAME SHOWN FOR DATABASE ITEM))),
	-- CANDO(WHAT NON OWNERS WITH KEYS ARE ALLOWED TO DO(FURNISH(ADD FURNITURE TO HOME), UNFURNISH(REMOVE FURNITURE FROM HOME), LETIN(ALLOW OTHER PLAYERS INTO HOME),
	-- SETLOCK(CHANGE LOCK STATE OF HOME), GIVEKEYS(GIVE KEY TO ANOTHER NON OWNER PLAYER), INVENTORY(ACCESS HOME INVENTORY)))
	Item = {
		Require = false,
		Name = ''
	},
	CanDo = {
		Furnish = true,
		Unfurnish = false,
		LetIn = true,
		SetLock = true,
		GiveKeys = false,
		Inventory = true
	}
}

Config.Defaults = { -- SET ALL DEFAULT VALUES HERE: SPAWNSPOTS(HOUSE SPAWN LOCATIONS IF NO SAFE LOCATION FOUND), SHELL(CREATED HOUSE SHELL),
	-- PRICE(CREATED HOUSE PRICE), DRAW(CREATED HOUSE LAND SIZE)
	SpawnSpots = {
		vector3(0.0, 0.0, -20.0),
		vector3(50.0, 50.0, -20.0),
		vector3(-50.0, -50.0, -20.0),
		vector3(100.0, 100.0, -20.0),
		vector3(-100.0, -100.0, -20.0),
		vector3(-150.0, -150.0, -20.0),
		vector3(150.0, 150.0, -20.0),
		vector3(-200.0, -200.0, -20.0),
		vector3(200.0, 200.0, -20.0),
		vector3(-250.0, -250.0, -20.0)
	},
	Shell = 'shell_lester', 
	Price = 60000,
	Draw = 15
}

Config.MaxSellPrice = 999999999 -- MAXIMUM ALLOWED SALE PRICE MARKET SOLD HOMES

Config.BuyBack = { -- SET ALL BANK BUY BACK INFORMATION HERE: ROLL/WIN(MAX ROLL/WINNING ROLLS), PERCENT(PERCENT OF PURCHASE PRICE GIVEN BACK IF BOUGHT)
	Roll = 30,
	Win = {1, 6, 19, 26},
	Percent = 100
}

Config.Auction = { -- SET ALL AUCTION INFORMATION HERE: STARTPERCENT/MAXPERCENT(START/STOP PERCENT OF PURCHASE PRICE), MAXTIME(LONGEST TIME AUCTION CAN RUN, IN MILLISECONDS),
	--  DECLINEFEE(AMOUNT TAKEN FROM PLAYER FOR DECLING AUCTION OFFER AND KEEPING HOME), ROLL/WIN(MAX ROLL/WINNING ROLLS), FIRSTNAMES/LASTNAMES(NPC BUYER NAMES, MAKE SURE TO KEEP AN EQUAL AMOUNT IN BOTH TABLES)
	StartPercent = 15,
	MaxPercent = 200,
	MaxTime = 550000,
	DeclineFee = 750,
	Roll = 50,
	Win = {1, 2, 5, 6, 12, 15, 19, 22, 25, 26, 29, 34, 37, 39, 41, 46, 50},
	FirstNames = {'Sarah', 'Jeff', 'Jim', 'Astro', 'Clarissa', 'Sammy', 'Emanuel', 'George', 'Elizabeth', 'Tiffany', 'Alfred'}, -- Make sure there are same number of first and last names
	LastNames = {'Henderson', 'Appleton', 'Marsalla', 'Hemrose', 'Kinwater', 'Sagalla', 'Dephins', 'Yetsorgna', 'Himblesore', 'Prindochton', 'Johannsen'} -- Can be however many you want just need to be equal
}

Config.LandSize = {  -- ALLOWABLE SELECTABLE DRAW RANGES FOR PROPERTY(WHERE PLAYERS CAN CREATE PARKING AND PLACE OUTSIDE FURNITURE)
	5, 10, 15, 20, 30, 50, 75, 100, 105
}

Config.Creation = { -- SET ALL HOME CREATION INFORMATION HERE: JOBS(JOBS ALLOWED TO CREATE HOMES), IDS(PLAYER IDENTIFIERS WHO ARE ALLOWED TO CREATE HOMES), ALLOWOWNER(ALLOW HOME OWNERS TO CREATE THINGS)
	-- PAYOUT(CHOOSE IF HOME CREATORS RECEIVE A PERCENTAGE OF THE SET SALE PRICE, MONEY IS GIVEN ON CREATION), PERCENT(PAYOUT PERCENTAGE OF SALE PRICE FOR NEW HOMES)
	Commands = {
		AddHouse = 'addHome',
		AddParking = 'addParking',
		ChangeRange = 'updateLand',
		DeleteHouse = 'removeHome',
		DeleteParking = 'removeParking',
		AddDoor = 'addDoor',
		AddGarage = 'addGarage',
		DeleteDoor = 'removeDoor',
		SetStorage = 'moveStorage',
		SetWardrobe = 'moveWardrobe',
		TestShell = 'testShell',
		ClearShell = 'clearShell',
		SpawnProp = 'spawnProp',
		Offset = 'houseOffset'
	},
	Jobs = {
		'realestate'
	},
	IDs = {
	},
	AllowOwner = true,
	Payout = false,
	Percent = 10,
}

Config.Mailboxes = { -- SET ALL MAILBOX INFORMATION HERE: USE(SHOULD THE SCRIPT USE MAILBOXES AT HOUSE DOORS)
  -- (MUST REPLACE property.lua IF USING STANDARD INVENTORYHUD, OR UPDATE MY FORK HERE: https://github.com/JiminyKroket/Invhud)
	Use = true,
}

Config.Raids = { -- SET ALL RAID INFORMATION HERE: JOBS(JOBS AND MINIMUM JOB GRADE ALLOWED TO RAID), OFFLINE(CAN HOMES BE RAIDED WHILE OWNER IS OFFLINE)
	Jobs = {
		['lspd'] = 3,
		['bcso'] = 3,
		['police'] = 3
	},
	Offline = false
}

Config.BandE = { -- SET ALL BREAKING AND ENTERING INFORMATION HERE: ALLOW(CAN PLAYERS BREAKANDENTER HOMES), REQITEMS(ITEMS REQUIRED TO ATTEMPT BREAKANDENTER),
	-- SUCCESSCHANCE(CHANCE OF SUCCESSFUL BREAKANDENTER)
	Allow = true, -- ALLOW BREAKING AND ENTERING?
	AllowOffline = true,
	ReqItems = {['lockpick'] = 1, ['tumblekeeper'] = 1}, -- ITEMS REQUIRED TO ATTEMPT B&E AND THE AMOUNT NEEDED
	AnimDict = 'amb@prop_human_bum_bin@base',
	AnimName = 'base',
	BlendIn = 8.0,
	BlendOut = 8.0,
	AnimFlag = 1,
	AnimTime = 0.0,
	WinAmount = 20,
	Revolutions = 50,
	EventKeys = {['Z/D-Pad Down'] = 20, ['F/Y Button'] = 23, ['C/R3'] = 26, ['G/D-Pad Left'] = 47, ['R/B Button'] = 45, ['E/D-Pad Right'] = 51, ['X/A Button'] = 73, ['U/D-Pad Up'] = 303}
}

Config.Shells = {
	shell_trailer = {
		door = vector3(-1.43, -1.80, -1.48), spawnHead = 0.0, shellsize = 10.0, rank = 1
	},
	shell_lester = {
		door = vector3(-1.61, -5.83, -1.37), spawnHead = 0.0, shellsize = 10.0, rank = 2
	},
	shell_v16low = {
		door = vector3(4.64, -6.29, -2.65), spawnHead = 0.0, shellsize = 10.0, rank = 3
	},
	shell_frankaunt = {
		door = vector3(-0.32, -5.69, -1.57), spawnHead = 0.0, shellsize = 10.0, rank = 4
	},
	shell_trevor = {
		door = vector3(0.29, -3.53, -1.41), spawnHead = 0.0, shellsize = 10.0, rank = 5
	},
	shell_medium2 = {
		door = vector3(6.02, 0.33, -1.66), spawnHead = 0.0, shellsize = 10.0, rank = 6
	},
	shell_medium3 = {
		door = vector3(5.67, -1.72, 0.20), spawnHead = 0.0, shellsize = 10.0, rank = 7
	},
	shell_v16mid = {
        door = vector3(1.40, -13.90, -1.49), spawnHead = 0.0, shellsize = 15.0, rank = 8
    },
	shell_office1 = {
		door = vector3(1.20, 5.03, -1.72), spawnHead = 0.0, shellsize = 20.0, rank = 9
	},
	shell_office2 = {
		door = vector3(3.65, -1.86, -1.87), spawnHead = 0.0, shellsize = 25.0, rank = 10
	},
	shell_michael = {
		door = vector3(-9.39, 5.63, -5.06), spawnHead = 0.0, shellsize = 15.0, rank = 11
	},
	shell_ranch = {
		door = vector3(-1.19, -5.48, -2.10), spawnHead = 0.0, shellsize = 20.0, rank = 12
	},
	--[[
	shell_warehouse1 = {
		door = vector3(-8.44, 0.15, -1.94), spawnHead = 0.0, shellsize = 10.0, rank = 13
	},
	shell_warehouse3 = {
		door = vector3(2.19, -1.60, -1.94), spawnHead = 0.0, shellsize = 10.0, rank = 14
	}, ]]

	-- VIP

	shell_highend = {
		door = vector3(-22.27, -0.42, 6.20), spawnHead = 0.0, shellsize = 25.0, rank = 13
	},
	shell_highendv2 = {
		door = vector3(-10.38, 0.95, 0.93), spawnHead = 0.0, shellsize = 20.0, rank = 14
	},
	shell_apartment1 = {
		door = vector3(-2.08, 8.95, 2.20), spawnHead = 0.0, shellsize = 20.0, rank = 15
	},
	shell_apartment2 = {
		door = vector3(-2.11, 9.04, 2.20), spawnHead = 0.0, shellsize = 20.0, rank = 16
	},
	shell_apartment3 = {
		door = vector3(11.69, 4.53, 1.00), spawnHead = 0.0, shellsize = 25.0, rank = 17
	},
	shell_banham = {
		door = vector3(-3.60, -1.56, 0.23), spawnHead = 0.0, shellsize = 25.0, rank = 18
	},
	shell_westons = {
		door = vector3(4.35, 10.24, 0.34), spawnHead = 0.0, shellsize = 25.0, rank = 19
	},
	shell_westons2 = {
		door = vector3(-1.69, 10.24, 0.34), spawnHead = 0.0, shellsize = 25.0, rank = 20
	},
}

Config.Furnishing = {
	Store = {
		name = 'Furniture Store',
		isMLO = true,
		range = 35.0,
		heading = 242.43,
		shopPos = vector3(2748.87, 3476.24, 55.67),
		propPos = vector3(2751.406, 3475.10, 55.68),
		enter = vector3(2748.87, 3476.24, 55.67),
		exitt = vector3(2753.23, 3452.30, 55.97),
		exthead = 242.43
	},
	
	Props = { 
		['Couches'] = {
			items = {
				{ prop = 'miss_rub_couch_01', price = 300, label = 'Old Flowered Couch' },
				{ prop = 'prop_fib_3b_bench', price = 700, label = '3 Seat Chair' },
				{ prop = 'prop_ld_farm_chair01', price = 250, label = 'Old 1 Seat Couch' },
				{ prop = 'prop_ld_farm_couch01', price = 300, label = 'Old 3 Seat Couch' },
				{ prop = 'prop_ld_farm_couch02', price = 300, label = 'Old Striped Couch' },
				{ prop = 'v_res_d_armchair', price = 300, label = 'Old 1 Seat Couch Yellow' },
				{ prop = 'v_res_fh_sofa', price = 3000, label = 'Corner Sofa' },
				{ prop = 'v_res_mp_sofa', price = 3000, label = 'Corner Sofa 2' },
				{ prop = 'v_res_d_sofa', price = 700, label = 'Sofa 1' },
				{ prop = 'v_res_j_sofa', price = 700, label = 'Sofa 2' },
				{ prop = 'v_res_mp_stripchair', price = 700, label = 'Sofa 3' },
				{ prop = 'v_res_m_h_sofa_sml', price = 700, label = 'Sofa 4' },
				{ prop = 'v_res_r_sofa', price = 700, label = 'Sofa 5' },
				{ prop = 'v_res_tre_sofa', price = 700, label = 'Sofa 6' },
				{ prop = 'v_res_tre_sofa_mess_a', price = 700, label = 'Sofa 7' },
				{ prop = 'v_res_tre_sofa_mess_b', price = 700, label = 'Sofa 8' },
				{ prop = 'v_res_tre_sofa_mess_c', price = 700, label = 'Sofa 9' },
				{ prop = 'v_res_tt_sofa', price = 700, label = 'Sofa 10' },
				{ prop = 'prop_rub_couch02', price = 700, label = 'Sofa 11' },
				{ prop = 'v_ilev_m_sofa', price = 700, label = 'Sofa 12' },
				{ prop = 'v_res_tre_sofa_s', price = 700, label = 'Sofa 13' },
			}
		},

		['Couches 2'] = {
			items = {
				{ prop = 'apa_mp_h_stn_foot_stool_02', price = 250, label = 'Foot Stool 1' },
				{ prop = 'apa_mp_h_stn_foot_stool_01', price = 250, label = 'Foot Stool 2' },
				{ prop = 'p_v_med_p_sofa_s', price = 700, label = 'Leather sofa' },
				{ prop = 'v_tre_sofa_mess_c_s', price = 500, label = 'Used sofa' },
				{ prop = 'p_res_sofa_l_s', price = 700, label = 'Fabric sofa' },
				{ prop = 'p_yacht_sofa_01_s', price = 700, label = 'Yacht sofa' },
				{ prop = 'v_ilev_m_sofa', price = 700, label = 'Sofa 14' },
				{ prop = 'v_res_tre_sofa_s', price = 700, label = 'Sofa 15' },
				{ prop = 'apa_mp_h_stn_sofacorn_01', price = 700, label = 'Corner Sofa 1' },
				{ prop = 'apa_mp_h_stn_sofacorn_05', price = 700, label = 'Corner Sofa 2' },
				{ prop = 'apa_mp_h_stn_sofacorn_06', price = 700, label = 'Corner Sofa 3' },
				{ prop = 'apa_mp_h_stn_sofacorn_07', price = 700, label = 'Corner Sofa 4' },
				{ prop = 'apa_mp_h_stn_sofacorn_08', price = 700, label = 'Corner Sofa 5' },
				{ prop = 'apa_mp_h_stn_sofacorn_09', price = 700, label = 'Corner Sofa 6' },
				{ prop = 'apa_mp_h_stn_sofacorn_10', price = 700, label = 'Corner Sofa 7' },
				{ prop = 'apa_mp_h_stn_sofa_daybed_01', price = 700, label = 'Daybed 1' },
				{ prop = 'apa_mp_h_stn_sofa_daybed_02', price = 700, label = 'Daybed 2' },
				{ prop = 'apa_mp_h_stn_sofa2seat_02', price = 700, label = 'Sofa 2 Seat' },
				{ prop = 'ex_mp_h_off_sofa_01', price = 700, label = 'White Leather Sofa' },
				{ prop = 'ex_mp_h_off_sofa_02', price = 700, label = 'Black Leather Sofa' },
				{ prop = 'ex_mp_h_off_sofa_003', price = 700, label = 'Grey Leather Sofa' },
			}
		},

		['Chairs'] = {
			items = {
				{ prop = 'v_res_d_highchair', price = 700, label = 'High Chair' },
				{ prop = 'v_res_fa_chair01', price = 700, label = 'Chair 1' },
				{ prop = 'v_res_fa_chair02', price = 700, label = 'Chair 2' },
				{ prop = 'v_res_fh_barcchair', price = 700, label = 'High Chair' },
				{ prop = 'v_res_fh_dineeamesa', price = 700, label = 'Dine Chair 1' },
				{ prop = 'v_res_fh_dineeamesb', price = 700, label = 'Dine Chair 2' },
				{ prop = 'v_res_fh_dineeamesc', price = 700, label = 'Dine Chair 3' },
				{ prop = 'v_res_fh_easychair', price = 700, label = 'Chair' },
				{ prop = 'v_res_fh_kitnstool', price = 700, label = 'Stool' },
				{ prop = 'v_res_fh_singleseat', price = 700, label = 'High Chair' },
				{ prop = 'v_res_jarmchair', price = 700, label = 'Arm Chair' },
				{ prop = 'v_res_j_dinechair', price = 700, label = 'Dining Chair' },
				{ prop = 'v_res_j_stool', price = 700, label = 'Stool' },
				{ prop = 'v_res_mbchair', price = 700, label = 'MB Chair' },
				{ prop = 'v_res_m_armchair', price = 700, label = 'Arm Chair' },
				{ prop = 'v_res_m_dinechair', price = 700, label = 'Dine Chair' },
				{ prop = 'v_res_study_chair', price = 700, label = 'Study Chair' },
				{ prop = 'v_res_trev_framechair', price = 700, label = 'Frame Chair' },
				{ prop = 'v_res_tre_chair', price = 700, label = 'Chair' },
				{ prop = 'v_res_tre_officechair', price = 700, label = 'Office Chair' },
				{ prop = 'v_res_tre_stool', price = 700, label = 'Stool' },
				{ prop = 'v_res_tre_stool_leather', price = 700, label = 'Stool Leather' },
			}
		},

		['Chairs 2'] = {
			items = {
				{ prop = 'prop_gc_chair02', price = 700, label = 'Chair 1' },
				{ prop = 'v_ilev_chair02_ped', price = 250, label = 'Chair 2' },
				{ prop = 'v_corp_cd_chair', price = 250, label = 'Chair 3' },
				{ prop = 'v_corp_bk_chair3', price = 250, label = 'Chair 4' },
				{ prop = 'prop_skid_chair_03', price = 250, label = 'Chair 5' },
				{ prop = 'prop_table_01_chr_a', price = 250, label = 'Table Chair 1' },
				{ prop = 'prop_table_01_chr_b', price = 250, label = 'Table Chair 2' },
				{ prop = 'prop_table_02_chr', price = 250, label = 'Table Chair 3' },
				{ prop = 'prop_table_03_chr', price = 250, label = 'Table Chair 4' },
				{ prop = 'prop_table_03b_chr', price = 250, label = 'Table Chair 5' },
				{ prop = 'prop_table_04_chr', price = 250, label = 'Table Chair 6' },
				{ prop = 'prop_table_05_chr', price = 250, label = 'Table Chair 7' },
				{ prop = 'apa_mp_h_din_chair_04', price = 250, label = 'Dining Chair 1' },
				{ prop = 'apa_mp_h_din_chair_08', price = 250, label = 'Dining Chair 2' },
				{ prop = 'apa_mp_h_din_chair_09', price = 250, label = 'Dining Chair 3' },
				{ prop = 'apa_mp_h_din_chair_12', price = 250, label = 'Dining Chair 4' },
				{ prop = 'apa_mp_h_din_stool_04', price = 250, label = 'Dining Stool' },
				{ prop = 'p_ilev_p_easychair_s', price = 250, label = 'Chair 16' },
				{ prop = 'v_ilev_fh_dineeamesa', price = 250, label = 'Chair 17' },
				{ prop = 'sm_prop_smug_offchair_01a', price = 250, label = 'Office Chair 8' },
				{ prop = 'hei_prop_heist_off_chair', price = 250, label = 'Office Chair 9' },
				{ prop = 'apa_mp_h_din_stool_04', price = 250, label = 'Dining Stool' },
			}
		},

		['Beds'] = {
			items = {
				{ prop = 'v_res_d_bed', price = 700, label = 'D Bed' },  
				{ prop = 'v_res_lestersbed', price = 700, label = 'L Bed' }, 
				{ prop = 'v_res_mbbed', price = 700, label = 'MB Bed' }, 
				{ prop = 'v_res_mdbed', price = 700, label = 'MD Bed' }, 
				{ prop = 'v_res_msonbed', price = 700, label = 'Mason Bed' },  
				{ prop = 'v_res_tre_bed1', price = 700, label = 'T Bed' }, 
				{ prop = 'v_res_tre_bed2', price = 700, label = 'T Bed 2' }, 
				{ prop = 'v_res_tt_bed', price = 700, label = 'TT Bed' },
				{ prop = 'apa_mp_h_bed_double_08', price = 700, label = 'Double Bed' },  
				{ prop = 'apa_mp_h_bed_double_09', price = 700, label = 'Double Bed 2' },
				{ prop = 'apa_mp_h_bed_wide_05', price = 700, label = 'Double Bed 3' },
				{ prop = 'apa_mp_h_bed_with_table_02', price = 1000, label = 'Bed with table' },
				{ prop = 'gr_prop_bunker_bed_01', price = 500, label = 'Single bed' },
			}
		},

		['Wall Decor'] = {
			items = {
				{ prop = 'v_ilev_ra_doorsafe', price = 500, label = 'Painting' },
				{ prop = 'v_res_mchalkbrd', price = 300, label = 'Chalk Board' },
				{ prop = 'apa_p_h_acc_artwallm_04', price = 300, label = 'Wall Art 1' },
				{ prop = 'apa_p_h_acc_artwallm_03', price = 300, label = 'Wall Art 2' },
				{ prop = 'apa_p_h_acc_artwallm_01', price = 300, label = 'Wall Art 3' },
				{ prop = 'apa_p_h_acc_artwalll_04', price = 300, label = 'Wall Art 4' },
				{ prop = 'apa_p_h_acc_artwalll_03', price = 300, label = 'Wall Art 5' },
				{ prop = 'hei_prop_hei_pic_hl_valkyrie', price = 300, label = 'Valkyrie' },
				{ prop = 'hei_prop_hei_pic_pb_plane', price = 300, label = 'Plane' },
				{ prop = 'hei_prop_hei_pic_pb_station', price = 300, label = 'MRPD' },
				{ prop = 'hei_prop_hei_pic_ps_bike', price = 300, label = 'Lost MC' },
				{ prop = 'hei_prop_hei_pic_ps_job', price = 300, label = 'Pacific Standard' },
				{ prop = 'hei_prop_heist_pic_06', price = 300, label = 'Plane' },
				{ prop = 'hei_prop_heist_pic_12', price = 300, label = 'Motorcycle' },
				{ prop = 'hei_prop_heist_pic_13', price = 300, label = 'Jetskis' },
				{ prop = 'prop_j_heist_pic_04', price = 300, label = 'Jewelry Store' },
				{ prop = 'prop_j_heist_pic_03', price = 300, label = 'Tunnel' },
				{ prop = 'v_ilev_ra_doorsafe', price = 300, label = 'Painting' },
				{ prop = 'hei_heist_acc_artwalll_01', price = 300, label = 'Painting 2' },
				{ prop = 'hei_heist_acc_artwallm_01', price = 300, label = 'Wall Art' },
			}
		},

		['Decorations'] = {
			items = {
				{ prop = 'apa_mp_h_acc_bottle_01', price = 700, label = 'Bottle' },  
				{ prop = 'apa_mp_h_acc_candles_01', price = 700, label = 'Candles' }, 
				{ prop = 'p_int_jewel_mirror', price = 700, label = 'Mirror' }, 
				{ prop = 'apa_mp_h_acc_dec_plate_01', price = 700, label = 'Decorative Plate' }, 
				{ prop = 'apa_mp_h_acc_vase_01', price = 700, label = 'Vase' },  
				{ prop = 'v_res_desktidy', price = 700, label = 'Desk Supplies' },  
				{ prop = 'ex_prop_ashtray_luxe_02', price = 700, label = 'Ashtray' },
				{ prop = 'prop_bong_01', price = 700, label = 'Bong' },
				{ prop = 'prop_acc_guitar_01', price = 1000, label = 'Guitar' },
				{ prop = 'p_planning_board_04', price = 500, label = 'Planning Board' },
				{ prop = 'prop_hotel_clock_01', price = 500, label = 'Hotel Clock' },
				{ prop = 'p_cs_pamphlet_01_s', price = 700, label = 'Pamphlet' },
				{ prop = 'prop_big_clock_01', price = 500, label = 'Big Clock' },
				{ prop = 'prop_ld_greenscreen_01', price = 100, label = 'Green Screen' },
				{ prop = 'prop_dart_bd_cab_01', price = 500, label = 'Dart' },
				{ prop = 'v_res_cherubvase', price = 500, label = 'White Vase' },
				{ prop = 'v_res_d_paddedwall', price = 500, label = 'Padded Wall' },
				{ prop = 'prop_el_guitar_01', price = 100, label = 'E Guitar' },
				{ prop = 'prop_ld_greenscreen_01', price = 100, label = 'Green Screen' },
				{ prop = 'v_res_mbronzvase', price = 300, label = 'Bronze Vase' },
				{ prop = 'prop_ceramic_jug_01', price = 100, label = 'Ceramic Jug' },
				{ prop = 'v_res_m_candle', price = 300, label = 'Candle Large' },
				{ prop = 'apa_mp_h_acc_candles_06', price = 50, label = 'Candles' },
			}
		},

		['Decorations 2'] = {
			items = {
				{ prop = 'apa_mp_h_acc_rugwools_01', price = 300, label = 'Rug 1' },
				{ prop = 'apa_mp_h_acc_rugwoolm_01', price = 300, label = 'Rug 2' },
				{ prop = 'apa_mp_h_acc_rugwooll_04', price = 300, label = 'Rug 3' },
				{ prop = 'apa_mp_h_acc_rugwooll_03', price = 300, label = 'Rug 4' },
				{ prop = 'apa_mp_h_acc_rugwoolm_04', price = 300, label = 'Rug 5' },
				{ prop = 'apa_mp_h_acc_rugwools_03', price = 300, label = 'Rug 6' },
				{ prop = 'v_res_fh_pouf', price = 300, label = 'Pouf' },
				{ prop = 'v_res_fh_sculptmod', price = 300, label = 'Sculpture' },
				{ prop = 'prop_ceramic_jug_01', price = 100, label = 'Ceramic Jug' },
				{ prop = 'prop_v_5_bclock', price = 300, label = 'Vintage Clock' },
				{ prop = 'prop_v_15_cars_clock', price = 300, label = 'American Flag Clock' },
				{ prop = 'prop_sm_19_clock', price = 300, label = 'Modern Clock' },
				{ prop = 'prop_sports_clock_01', price = 300, label = 'Sports Clock' },
				{ prop = 'prop_mem_candle_01', price = 300, label = 'Candle 1' },
				{ prop = 'prop_game_clock_01', price = 300, label = 'Crown Clock' },
				{ prop = 'prop_game_clock_02', price = 300, label = 'Kronos Clock' },
				{ prop = 'prop_id2_20_clock', price = 300, label = 'Modern Clock 2' },
				{ prop = 'ex_office_citymodel_01', price = 300, label = 'CIty Model' },
				{ prop = 'apa_mp_h_acc_dec_head_01', price = 300, label = 'Mask' },
				{ prop = 'ex_mp_h_acc_vase_06', price = 300, label = 'Vase 1' },
				{ prop = 'ex_mp_h_acc_vase_02', price = 300, label = 'Red Vase' },
				{ prop = 'hei_prop_hei_bust_01', price = 300, label = 'Bust' },
				{ prop = 'prop_arcade_01', price = 300, label = 'Arcade Machine' },
			}
		},

		['Storage'] = {
			items = {
				{ prop = 'v_res_cabinet', price = 2500, label = 'Cabinet Large' },
				{ prop = 'v_res_d_dressingtable', price = 2500, label = 'Dressing Table' },
				{ prop = 'v_res_d_sideunit', price = 2500, label = 'Side Unit' },
				{ prop = 'v_res_fh_sidebrddine', price = 2500, label = 'Side Unit' },
				{ prop = 'v_res_fh_sidebrdlngb', price = 2500, label = 'Side Unit' },
				{ prop = 'v_res_mbbedtable', price = 2500, label = 'Bed Unit' },
				{ prop = 'v_res_mbdresser', price = 2500, label = 'Dresser Unit' },
				{ prop = 'v_res_mbottoman', price = 2500, label = 'Bottoman Unit' },
				{ prop = 'v_res_mconsolemod', price = 2500, label = 'Console Unit' },
				{ prop = 'v_res_mcupboard', price = 2500, label = 'Cupboard Unit' },
				{ prop = 'v_res_mdchest', price = 2500, label = 'Chest Unit' },
				{ prop = 'v_res_m_sidetable', price = 2500, label = 'Side Unit' },
				{ prop = 'v_res_tre_bedsidetable', price = 2500, label = 'Side Unit' },
				{ prop = 'v_res_tre_bedsidetableb', price = 2500, label = 'Side Unit 2' },
				{ prop = 'v_res_tre_smallbookshelf', price = 2500, label = 'Book Unit' },
				{ prop = 'v_res_tre_storageunit', price = 2500, label = 'Storage Unit (Personal stash)' },
				{ prop = 'v_res_tre_storagebox', price = 2500, label = 'Storage Box (Personal stash)' },
				{ prop = 'v_res_tre_wardrobe', price = 2500, label = 'Wardrobe Unit (Outfits)' },
				{ prop = 'v_res_tre_wdunitscuz', price = 2500, label = 'Wood Unit' },
				{ prop = 'prop_devin_box_closed', price = 2500, label = 'Wicker Chest' },
				{ prop = 'prop_toolchest_05', price = 5000, label = 'Crafting Bench' },
			}
		},

		['Storage 2'] = {
			items = {
				{ prop = 'prop_ld_int_safe_01', price = 2500, label = 'Safe' },
				{ prop = 'p_v_43_safe_s', price = 2500, label = 'Safe 2' },
				{ prop = 'p_cs_locker_01_s', price = 2500, label = 'Locker' },
				{ prop = 'p_cs_locker_02', price = 2500, label = 'Locker 2' },
				{ prop = 'p_cs_locker_01', price = 2500, label = 'Locker 3' },
				{ prop = 'prop_cs_lester_crate', price = 2500, label = 'Crate' },
				{ prop = 'prop_cabinet_02b', price = 2500, label = 'Cabinet' },
				{ prop = 'prop_cabinet_01b', price = 2500, label = 'Cabinet 2' },
				{ prop = 'apa_mp_h_bed_chestdrawer_02', price = 2500, label = 'Chest Drawer' },
				{ prop = 'apa_mp_h_str_shelffreel_01', price = 500, label = 'Shelf Large 1' },
				{ prop = 'apa_mp_h_str_shelffloorm_02', price = 500, label = 'Shelf Large 2' },
				{ prop = 'apa_mp_h_str_shelfwallm_01', price = 500, label = 'Shelf' },
			}
		},

		['Electronics'] = {
			items = {
				{ prop = 'deskpc_model', price = 3000, label = 'High End Computer' },
				{ prop = 'prop_portable_hifi_01', price = 300, label = 'Radio' },
				{ prop = 'v_res_fh_speaker', price = 300, label = 'Speaker' },
				{ prop = 'v_res_fh_speakerdock', price = 300, label = 'Speaker Dock' },
				{ prop = 'v_res_fh_bedsideclock', price = 300, label = 'Bedside Clock' },
				{ prop = 'v_res_fa_phone', price = 300, label = 'Phone 1' },
				{ prop = 'p_amb_phone_01', price = 300, label = 'Phone 2' },
				{ prop = 'prop_v_m_phone_o1s', price = 300, label = 'Old Phone' },
				{ prop = 'prop_office_phone_tnt', price = 300, label = 'Office Phone' },
				{ prop = 'prop_cs_phone_01', price = 300, label = 'CS Phone' },
				{ prop = 'v_res_fh_towerfan', price = 300, label = 'Tower Fan' },
				{ prop = 'v_res_fa_fan', price = 300, label = 'Fan' },
				{ prop = 'v_res_lest_bigscreen', price = 300, label = 'Bigscreen' },
				{ prop = 'v_res_tre_mixer', price = 300, label = 'Mixer' },
				{ prop = 'xm_prop_x17_tv_flat_02', price = 500, label = 'Flatscreen TV' },
				{ prop = 'prop_tv_flat_02', price = 1000, label = 'Flat TV' },
				{ prop = 'prop_tv_06', price = 1000, label = 'Fat TV' },
				{ prop = 'prop_tv_02', price = 1000, label = 'Small Fat TV' },
				{ prop = 'apa_mp_h_str_avunitl_01_b', price = 1000, label = 'TV set 1' },
				{ prop = 'apa_mp_h_str_avunitl_04', price = 1000, label = 'TV set 2' },
				{ prop = 'apa_mp_h_str_avunitm_03', price = 1000, label = 'TV set 3' },
				{ prop = 'apa_mp_h_str_avunits_01', price = 1000, label = 'TV set 4' },
				{ prop = 'apa_mp_h_str_avunits_04', price = 1000, label = 'TV set 5' },
				{ prop = 'apa_mp_h_str_avunitm_01', price = 1000, label = 'TV set 6' },
			}
		},

		['Electronics 2'] = {
			items = {
				{ prop = 'bkr_prop_clubhouse_jukebox_02a', price = 1000, label = 'Jukebox' },
				{ prop = 'bkr_prop_weed_fan_floor_01a', price = 300, label = 'Floor fan' },
				{ prop = 'ex_mp_h_acc_coffeemachine_01', price = 500, label = 'Coffee Machine' },
				{ prop = 'prop_dyn_pc_02', price = 500, label = 'New Computer' },
				{ prop = 'prop_pc_01a', price = 500, label = 'Old Computer' },
				{ prop = 'prop_dyn_pc', price = 500, label = 'PC 1' },
				{ prop = 'hei_prop_heist_pc_01', price = 500, label = 'PC 2' },
				{ prop = 'prop_pc_02a', price = 500, label = 'PC 3' },
				{ prop = 'prop_cs_mouse_01', price = 500, label = 'Mouse 1' },
				{ prop = 'prop_mouse_01a', price = 500, label = 'Mouse 2' },
				{ prop = 'v_res_mousemat', price = 500, label = 'Mousepad' },
				{ prop = 'hei_prop_hei_cs_keyboard', price = 500, label = 'Keyboard 1' },
				{ prop = 'prop_cs_keyboard_01', price = 500, label = 'Keyboard 2' },
				{ prop = 'v_res_lest_monitor', price = 300, label = 'Monitor 1' },
				{ prop = 'prop_ld_monitor_01', price = 100, label = 'Monitor 2' },
				{ prop = 'prop_monitor_01c', price = 100, label = 'Monitor 3' },
				{ prop = 'prop_monitor_03b', price = 100, label = 'Monitor' },
				{ prop = 'prop_ld_monitor_01', price = 100, label = 'Monitor' },
				{ prop = 'prop_ld_lap_top', price = 100, label = 'Laptop 1' },
				{ prop = 'p_amb_lap_top_02', price = 100, label = 'Laptop 2' },
				{ prop = 'p_cs_laptop_02', price = 100, label = 'Laptop 3' },
				{ prop = 'p_cs_laptop_02_w', price = 100, label = 'Laptop Closed' },
			}
		},

		['Lighting'] = {
			items = {
				{ prop = 'v_corp_cd_desklamp', price = 100, label = 'Desk Corp Lamp' },
				{ prop = 'v_res_desklamp', price = 100, label = 'Desk Lamp' },
				{ prop = 'v_res_d_lampa', price = 100, label = 'Lamp AA' },
				{ prop = 'v_res_fa_lamp1on', price = 100, label = 'Lamp 1' },
				{ prop = 'v_res_fh_lampa_on', price = 100, label = 'Lamp 2' },
				{ prop = 'v_res_fh_floorlamp', price = 100, label = 'Floor Lamp' },
				{ prop = 'v_res_j_tablelamp1', price = 100, label = 'Table Lamp' },
				{ prop = 'v_res_j_tablelamp2', price = 100, label = 'Table Lamp 2' },
				{ prop = 'v_res_mdbedlamp', price = 100, label = 'Bed Lamp' },
				{ prop = 'v_res_mplanttongue', price = 100, label = 'Plant Tongue Lamp' },
				{ prop = 'v_res_mtblelampmod', price = 100, label = 'Table Lamp 3' },
				{ prop = 'v_res_m_lampstand', price = 100, label = 'Lamp Stand' },
				{ prop = 'v_res_m_lampstand2', price = 100, label = 'Lamp Stand 2' },
				{ prop = 'v_res_m_lamptbl', price = 100, label = 'Table Lamp 4' },
				{ prop = 'apa_mp_h_lit_lamptable_005', price = 100, label = 'Table Lamp 1' },
				{ prop = 'apa_mp_h_lit_lamptable_02', price = 100, label = 'Table Lamp 2' },
				{ prop = 'apa_mp_h_lit_lamptable_09', price = 100, label = 'Table Lamp 3' },
				{ prop = 'apa_mp_h_lit_lamptable_04', price = 100, label = 'Table Lamp 4' },
				{ prop = 'apa_mp_h_lit_lamptable_14', price = 100, label = 'Table Lamp 5' },
			}
		},

		['Lighting 2'] = {
			items = {
				{ prop = 'v_res_tre_lightfan', price = 100, label = 'Light Fan' },
				{ prop = 'v_res_tre_talllamp', price = 100, label = 'Tall Lamp' },
				{ prop = 'v_ret_fh_walllighton', price = 100, label = 'Wall Light' },
				{ prop = 'prop_ld_cont_light_01', price = 100, label = 'Side Wall Light' },
				{ prop = 'prop_construcionlamp_01', price = 100, label = 'Light 1' },
				{ prop = 'hei_prop_bank_ornatelamp', price = 100, label = 'Light 2' },
				{ prop = 'prop_kino_light_03', price = 100, label = 'Light 3' },
				{ prop = 'prop_oldlight_01c', price = 100, label = 'Light 4' },
				{ prop = 'prop_recycle_light', price = 100, label = 'Light 5' },
				{ prop = 'prop_studio_light_01', price = 100, label = 'Light 6' },
				{ prop = 'prop_studio_light_02', price = 100, label = 'Light 7' },
				{ prop = 'prop_wall_light_02a', price = 100, label = 'Light 8' },
				{ prop = 'prop_wall_light_03a', price = 100, label = 'Light 9' },
				{ prop = 'prop_wall_light_04a', price = 100, label = 'Light 10' },
				{ prop = 'prop_wall_light_05a', price = 100, label = 'Light 11' },
				{ prop = 'prop_wall_light_05c', price = 100, label = 'Light 12' },
			}
		},

		['Tables'] = {
			items = {
				{ prop = 'v_res_d_coffeetable', price = 500, label = 'Coffee Table 1' },
				{ prop = 'v_res_d_roundtable', price = 500, label = 'Round Table' },
				{ prop = 'v_res_d_smallsidetable', price = 500, label = 'Small Side Table' },
				{ prop = 'v_res_fh_diningtable', price = 500, label = 'Dining Table' },
				{ prop = 'v_res_j_coffeetable', price = 500, label = 'Coffee Table 2' },
				{ prop = 'v_res_msidetblemod', price = 500, label = 'Side Table' },
				{ prop = 'v_res_m_dinetble_replace', price = 500, label = 'Dining Table 2' },
				{ prop = 'v_res_tre_sideboard', price = 500, label = 'Sideboard Table' },
				{ prop = 'v_res_tre_table2', price = 500, label = 'Table 2' },
				{ prop = 'v_res_tre_tvstand', price = 500, label = 'Tv Table' },
				{ prop = 'v_res_tre_tvstand_tall', price = 500, label = 'Tv Table Tall' },
				{ prop = 'v_med_p_coffeetable', price = 500, label = 'Med Coffee Table' },
				{ prop = 'prop_tv_cabinet_03', price = 500, label = 'TV Table' },
				{ prop = 'prop_ld_farm_table02', price = 500, label = 'Farm table' },
				{ prop = 'prop_ld_farm_table01', price = 500, label = 'Farm table 2' },
				{ prop = 'prop_fbi3_coffee_table', price = 500, label = 'Coffee table' },
				{ prop = 'prop_t_coffe_table', price = 500, label = 'Coffee table 2' },
				{ prop = 'prop_t_coffe_table_02', price = 500, label = 'Coffee table 3' },
				{ prop = 'v_res_son_desk', price = 500, label = 'Desk 1' },
				{ prop = 'v_res_mddesk', price = 500, label = 'Desk 2' },
			}
		},

		['Tables 2'] = {
			items = {
				{ prop = 'prop_chateau_table_01', price = 500, label = 'Table 1' },
				{ prop = 'prop_patio_lounger1_table', price = 500, label = 'Table 2' },
				{ prop = 'prop_picnictable_01', price = 500, label = 'Table 3' },
				{ prop = 'prop_proxy_chateau_table', price = 500, label = 'Table 4' },
				{ prop = 'prop_rub_table_01', price = 500, label = 'Table 5' },
				{ prop = 'prop_rub_table_02', price = 500, label = 'Table 6' },
				{ prop = 'prop_table_01', price = 500, label = 'Table 7' },
				{ prop = 'prop_table_02', price = 500, label = 'Table 8' },
				{ prop = 'prop_table_03', price = 500, label = 'Table 9' },
				{ prop = 'prop_table_03b', price = 500, label = 'Table 10' },
				{ prop = 'prop_table_04', price = 500, label = 'Table 11' },
				{ prop = 'prop_table_05', price = 500, label = 'Table 12' },
				{ prop = 'prop_table_06', price = 500, label = 'Table 13' },
				{ prop = 'prop_table_07', price = 500, label = 'Table 14' },
				{ prop = 'prop_table_08', price = 500, label = 'Table 15' },
				{ prop = 'prop_table_08_chr', price = 500, label = 'Table 16' },
				{ prop = 'prop_ven_market_table1', price = 500, label = 'Table 17' },
				{ prop = 'v_ilev_liconftable_sml', price = 500, label = 'Table 18' },
				{ prop = 'v_res_fh_coftablea', price = 500, label = 'Table A' },
				{ prop = 'v_res_fh_coftableb', price = 500, label = 'Table B' },
				{ prop = 'v_res_fh_coftbldisp', price = 500, label = 'Table C' },
				{ prop = 'v_res_j_lowtable', price = 500, label = 'Low Table' },
				{ prop = 'v_res_mdbedtable', price = 500, label = 'Bed Table' },
			}
		},

		['Plants'] = {
			items = {
				{ prop = 'v_res_mflowers', price = 170, label = 'Plant Flowers' }, 
				{ prop = 'v_res_mvasechinese', price = 170, label = 'Plant Chinese' }, 
				{ prop = 'v_res_m_bananaplant', price = 170, label = 'Plant Banana' }, 
				{ prop = 'v_res_m_palmplant1', price = 170, label = 'Plant Palm' },  
				{ prop = 'v_res_m_palmstairs', price = 170, label = 'Plant Palm 2' },  
				{ prop = 'v_res_rubberplant', price = 170, label = 'Plant Rubber' }, 
				{ prop = 'v_res_tre_plant', price = 170, label = 'Plant' }, 
				{ prop = 'v_res_tre_tree', price = 170, label = 'Plant Tree' }, 
				{ prop = 'v_med_p_planter', price = 170, label = 'Planter' }, 
				{ prop = 'v_ret_flowers', price = 100, label = 'Flowers' },
				{ prop = 'v_ret_j_flowerdisp', price = 100, label = 'Flowers 1' },
				{ prop = 'v_ret_j_flowerdisp_white', price = 100, label = 'Flowers 2' },
				{ prop = 'apa_mp_h_acc_vase_flowers_01', price = 100, label = 'Flowers 3' },
				{ prop = 'apa_mp_h_acc_vase_flowers_02', price = 100, label = 'Flowers 4' },
				{ prop = 'xm_prop_x17_xmas_tree_int', price = 500, label = 'Christmas Tree' },
				{ prop = 'p_int_jewel_plant_02', price = 170, label = 'Plant 1' },
				{ prop = 'p_int_jewel_plant_01', price = 170, label = 'Plant 2' },
				{ prop = 'prop_fbibombplant', price = 170, label = 'Plant 3' },
				{ prop = 'prop_fib_plant_02', price = 170, label = 'Plant 4' },
				{ prop = 'prop_ld_dstplanter_01', price = 170, label = 'Plant 5' },
			}
		},

		['Kitchen'] = {
			items = {
				{ prop = 'prop_washer_01', price = 150, label = 'Washer 1' },
				{ prop = 'prop_washer_02', price = 150, label = 'Washer 2' },
				{ prop = 'prop_washer_03', price = 150, label = 'Washer 3' },
				{ prop = 'v_res_fridgemoda', price = 150, label = 'Fridge 1' },
				{ prop = 'v_res_fridgemodsml', price = 150, label = 'Fridge 2' },
				{ prop = 'prop_fridge_01', price = 150, label = 'Fridge 3' },
				{ prop = 'prop_fridge_03', price = 150, label = 'Fridge 4' },
				{ prop = 'prop_cooker_03', price = 150, label = 'Cooker' },
				{ prop = 'prop_micro_01', price = 150, label = 'Microwave' },
				{ prop = 'v_res_fa_chopbrd', price = 150, label = 'Chopping Board' },
				{ prop = 'v_res_pestle', price = 150, label = 'Pestle' },
				{ prop = 'prop_pot_rack', price = 150, label = 'Pot Rack' },
				{ prop = 'prop_kitch_juicer', price = 150, label = 'Juicer' },
				{ prop = 'apa_mp_h_acc_coffeemachine_01', price = 500, label = 'Coffee Machine' },
				{ prop = 'hei_heist_kit_bin_01', price = 500, label = 'Bin' },
				{ prop = 'hei_heist_str_sideboardl_03', price = 500, label = 'Sideboard' },
				{ prop = 'hei_prop_hei_paper_bag', price = 500, label = 'Bag' },
			}
		},

		['Kitchen 2'] = {
			items = {
				{ prop = 'p_new_j_counter_02', price = 500, label = 'Counter' },
				{ prop = 'apa_mp_h_acc_fruitbowl_01', price = 500, label = 'Fruit Bowl' },
				{ prop = 'prop_bar_fruit', price = 500, label = 'Fruit' },
				{ prop = 'prop_bar_sink_01', price = 500, label = 'Sink' },
				{ prop = 'v_ilev_fh_kitchenstool', price = 500, label = 'Stool' },
				{ prop = 'prop_trailr_fridge', price = 500, label = 'Old Fridge' },
				{ prop = 'prop_watercooler', price = 500, label = 'Water Cooler' },
				{ prop = 'v_res_tt_bowlpile02', price = 500, label = 'Bowl Pile' },
				{ prop = 'v_res_tt_platepile', price = 500, label = 'Plate Pile' },
				{ prop = 'v_res_mcofcup', price = 500, label = 'Tea Cup' },
				{ prop = 'v_ilev_m_pitcher', price = 500, label = 'Pitcher' },
				{ prop = 'v_res_fa_grater', price = 500, label = 'Cheese Grater' },
				{ prop = 'v_res_fa_chopbrd', price = 500, label = 'Chopping Board' },
				{ prop = 'apa_prop_cs_plastic_cup_01', price = 500, label = 'Red Solo Cup' },
				{ prop = 'prop_plate_01', price = 500, label = 'Plates' },
				{ prop = 'prop_micro_04', price = 500, label = 'Microwave 3' },
			}
		},
		
		['Bathroom'] = {
			items = {
				{ prop = 'prop_ld_toilet_01', price = 100, label = 'Toilet 1' },
				{ prop = 'prop_toilet_01', price = 100, label = 'Toilet 2' },
				{ prop = 'prop_toilet_02', price = 100, label = 'Toilet 3' },
				{ prop = 'prop_sink_02', price = 100, label = 'Sink 1' },
				{ prop = 'prop_sink_04', price = 100, label = 'Sink 2' },
				{ prop = 'prop_sink_05', price = 100, label = 'Sink 3' },
				{ prop = 'prop_sink_06', price = 100, label = 'Sink 4' },
				{ prop = 'prop_sink_03', price = 100, label = 'Sink 5' },
				{ prop = 'v_res_mbsink', price = 100, label = 'Sink 6' },
				{ prop = 'prop_soap_disp_01', price = 100, label = 'Soap Dispenser' },
				{ prop = 'prop_shower_rack_01', price = 100, label = 'Shower Rack' },
				{ prop = 'prop_handdry_01', price = 100, label = 'Hand Dryer 1' },
				{ prop = 'prop_handdry_02', price = 100, label = 'Hand Dryer 2' },
				{ prop = 'prop_towel_rail_01', price = 100, label = 'Towel Rail 1' },
				{ prop = 'prop_towel_rail_02', price = 100, label = 'Towel Rail 2' },
				{ prop = 'prop_towel_01', price = 100, label = 'Towel 1' },
				{ prop = 'v_res_mbtowel', price = 100, label = 'Towel 2' },
				{ prop = 'v_res_mbtowelfld', price = 100, label = 'Towel 3' },
				{ prop = 'prop_shower_towel', price = 100, label = 'Towel 4' },
				{ prop = 'p_shower_towel_s', price = 100, label = 'Towel 5' },
				{ prop = 'v_res_mbath', price = 100, label = 'Bath' },
				{ prop = 'apa_mp_h_bathtub_01', price = 100, label = 'Bathtub' },
			}
		},

		['Bathroom 2'] = {
			items = {
				{ prop = 'prop_toilet_brush_01', price = 100, label = 'Toilet Brush' },
				{ prop = 'prop_toilet_roll_01', price = 100, label = 'Toilet Paper 1' },
				{ prop = 'prop_toilet_roll_02', price = 100, label = 'Toilet Paper 2' },
				{ prop = 'prop_toilet_roll_05', price = 100, label = 'Toilet Paper 3' },
				{ prop = 'prop_toilet_shamp_01', price = 100, label = 'Shampoo 1' },
				{ prop = 'prop_toilet_shamp_02', price = 100, label = 'Shampoo 2' },
				{ prop = 'prop_toilet_soap_01', price = 100, label = 'Soap 1' },
				{ prop = 'prop_toilet_soap_02', price = 100, label = 'Soap 2' },
				{ prop = 'prop_toilet_soap_03', price = 100, label = 'Soap 3' },
				{ prop = 'prop_toilet_soap_04', price = 100, label = 'Soap 4' },
				{ prop = 'v_hair_d_gel', price = 100, label = 'Hair Gel 2' },
				{ prop = 'v_haird_mousse', price = 100, label = 'Bottles 1' },
				{ prop = 'v_hair_d_shave', price = 100, label = 'Bottles 2' },
				{ prop = 'v_hair_d_bcream', price = 100, label = 'Bottles 3' },
				{ prop = 'p_new_j_counter_02', price = 100, label = 'Counter' },
			}
		},

		['Gym'] = {
			items = {
				{ prop = 'apa_p_apdlc_treadmill_s', price = 750, label = 'Treadmill' },
				{ prop = 'v_ilev_exball_blue', price = 750, label = 'Exercise Ball Blue' },
				{ prop = 'v_ilev_exball_grey', price = 750, label = 'Exercise Ball Grey' },
				{ prop = 'prop_rolled_yoga_mat', price = 750, label = 'Yoga Mat Rolled' },
				{ prop = 'v_res_fa_yogamat002', price = 300, label = 'Yoga Mat 1' },
				{ prop = 'v_res_fa_yogamat1', price = 300, label = 'Yoga Mat 2' },
				{ prop = 'p_yoga_mat_01_s', price = 750, label = 'Yoga Mat 3' },
				{ prop = 'p_yoga_mat_02_s', price = 750, label = 'Yoga Mat 4' },
				{ prop = 'p_yoga_mat_03_s', price = 750, label = 'Yoga Mat 5' },
				{ prop = 'prop_yoga_mat_01', price = 750, label = 'Yoga Mat 6' },
				{ prop = 'prop_yoga_mat_02', price = 750, label = 'Yoga Mat 7' },
				{ prop = 'prop_yoga_mat_03', price = 750, label = 'Yoga Mat 8' },
				{ prop = 'prop_barbell_01', price = 750, label = 'Barbell 1' },
				{ prop = 'prop_barbell_02', price = 750, label = 'Barbell 2' },
				{ prop = 'prop_barbell_10kg', price = 750, label = 'Barbell 10kg' },
				{ prop = 'prop_barbell_20kg', price = 750, label = 'Barbell 20kg' },
				{ prop = 'prop_barbell_30kg', price = 750, label = 'Barbell 30kg' },
				{ prop = 'prop_barbell_40kg', price = 750, label = 'Barbell 40kg' },
				{ prop = 'prop_barbell_50kg', price = 750, label = 'Barbell 50kg' },
				{ prop = 'prop_barbell_60kg', price = 750, label = 'Barbell 60kg' },
				{ prop = 'prop_barbell_80kg', price = 750, label = 'Barbell 80kg' },
				{ prop = 'prop_barbell_100kg', price = 750, label = 'Barbell 100kg' },
			}
		},

		['Gym'] = {
			items = {
				{ prop = 'prop_freeweight_01', price = 750, label = 'Freeweight 1' },
				{ prop = 'prop_freeweight_02', price = 750, label = 'Freeweight 2' },
				{ prop = 'prop_weight_1_5k', price = 750, label = 'Weight 1.5k' },
				{ prop = 'prop_weight_2_5k', price = 750, label = 'Weight 2.5k' },
				{ prop = 'prop_weight_5k', price = 750, label = 'Weight 5k' },
				{ prop = 'prop_weight_10k', price = 750, label = 'Weight 10k' },
				{ prop = 'prop_weight_15k', price = 750, label = 'Weight 15k' },
				{ prop = 'prop_weight_20k', price = 750, label = 'Weight 20k' },
				{ prop = 'prop_weight_bench_02', price = 750, label = 'Bench' },
				{ prop = 'prop_weight_rack_01', price = 750, label = 'Weight Rack 1' },
				{ prop = 'prop_weight_rack_02', price = 750, label = 'Weight Rack 2' },
				{ prop = 'prop_weight_squat', price = 750, label = 'Squat Rack' },
				{ prop = 'prop_muscle_bench_01', price = 750, label = 'Bench 1' },
				{ prop = 'prop_muscle_bench_02', price = 750, label = 'Bench 2' },
				{ prop = 'prop_muscle_bench_03', price = 750, label = 'Bench 3' },
				{ prop = 'prop_muscle_bench_04', price = 750, label = 'Bench 4' },
				{ prop = 'prop_muscle_bench_05', price = 750, label = 'Bench 5' },
				{ prop = 'prop_muscle_bench_06', price = 750, label = 'Bench 6' },
				{ prop = 'prop_exer_bike_01', price = 750, label = 'Exercise Bike 1' },
				{ prop = 'prop_exer_bike_mg', price = 750, label = 'Exercise Bike 2' },
				{ prop = 'prop_exercisebike', price = 750, label = 'Exercise Bike 3' },
			}
		},
	},
}

Config.Stash = {-2047530477, -1705306415}

Config.Wardrobe = {914205402}

Config.FurnishedHouses = {
	-- shell_lester = {
		-- {label = 'Living Room Chair', prop = 'v_res_mp_stripchair', pos = vector3(4.0, -0.14, -1.35), heading = 330.0},
		-- {label = 'Living Room Sidetable 1', prop = 'V_Res_Tre_SideBoard', pos = vector3(4.15, -2.75, -1.35), heading = 180.0},
		-- {label = 'Living Room Sidetable 2', prop = 'V_Res_Tre_SideBoard', pos = vector3(1.0, -2.75, -1.35), heading = 180.0},
		-- {label = 'Table Plant', prop = 'Prop_Plant_Int_04a', pos = vector3(4.35, -2.75, -0.45), heading = nil},
		-- {label = 'Table Lamp', prop = 'v_res_d_lampa', pos = vector3(1.00, -2.75, -0.45), heading = nil},
		-- {label = 'Wardrobe Sidetable', prop = 'V_Res_Tre_BedSideTable', pos = vector3(-0.15, 1.05, -1.35), heading = 180.0},
		-- {label = 'Dining Table', prop = 'V_Res_M_DineTble_replace', pos = vector3(2.60, 3.14, -1.35), heading = 45.0},
		-- {label = 'Dining Room Plant', prop = 'v_res_tre_tree', pos = vector3(4.60, 5.54, -1.35), heading = nil},
		-- {label = 'Dining Room Plant 2', prop = 'v_res_tre_plant', pos = vector3(4.60, 1.14, -0.35), heading = nil},
		-- {label = 'TV', prop = 'Prop_TV_Flat_01', pos = vector3(2.60, -2.90, 0.05), heading = 180.0},
		-- {label = 'Dining Room Chair 1', prop = 'v_res_m_dinechair', pos = vector3(2.60, 2.14, -1.35), heading = 180.0},
		-- {label = 'Dining Room Chair 2', prop = 'v_res_m_dinechair', pos = vector3(3.60, 3.14, -1.35), heading = 270.0},
		-- {label = 'Dining Room Chair 3', prop = 'v_res_m_dinechair', pos = vector3(1.60, 3.14, -1.35), heading = 90.0},
		-- {label = 'Dining Room Chair 4', prop = 'v_res_m_dinechair', pos = vector3(2.60, 4.14, -1.35), heading = 0.0},
		-- {label = 'Toilet', prop = 'prop_toilet_01', pos = vector3(-4.60, -5.15, -1.35), heading = 180.0},
	-- },
}

Config.Strings = {
	doorLockCom = 'doorlock',
	--SERVER STRINGS--
	trigEv = 'esx:getSharedObject',
	payLeas = 'Your lease is up at %s. The money was pulled from your bank',
	leaseUp = 'Your lease is up at %s. You will need to re-lease this property',
	notHome = 'Nobody seems to be home',
	houCrea = 'House created with address: %s at vector3(%s,%s,%s) with shell: %s for '..Config.CurrencyIcon..'%s',
	pspCrea = 'Parking spot created for address: %s at vector3(%s,%s,%s)',
	strCrea = 'Storage spot set for address: %s',
	warCrea = 'Wardrobe spot set for address: %s',
	noPerms = 'You do not have permission to use this command',
	furPrch = 'You purchased an %s for '..Config.CurrencyIcon..'%s with %s',
	noMoney = 'You do not have enough money to purchase this',
	offMark = 'You have taken %s off the selling market',
	houSold = 'Your house %s has sold for '..Config.CurrencyIcon..'%s',
	houBawt = 'You have paid '..Config.CurrencyIcon..'%s for %s',
	notFwnd = 'No house found, please try again',
	aucCanc = 'You have paid '..Config.CurrencyIcon..'%s for wasting the auctioneers time',
	aftrTst = 'This is only meant to be used after a test shell is created',
	unlkDor = 'You have unlocked the door for %s',
	lockDor = 'You have locked the door for %s',
	gaveKey = 'You have given a set of keys to %s for %s',
	gotKeys = 'You were given a set of keys for house\n%s by player %s',
	tookKey = 'You have taken a set of keys from %s for %s',
	lostKeys = 'Your keys were taken for house\n%s by player %s',
	uNtEnuf = 'You do not have that much of %s',
	noWeapo = 'You do not have that weapon',
	misCash = 'You do not have enough cash to do that',
	inNtNuf = 'There is not enough of that in the inventory',
	notRoom = 'You do not have enough room to carry %s',
	hasWeap = 'You already have this weapon',
	tooMany = 'You already have too many houses',
	--CLIENT STRINGS--
	parkCar = 'You can park/unpark you car by pressing E',
	ntrFurn = 'Press E to enter furniture store',
	l0ckTxt = '~r~Locked',
	unlkTxt = '~g~Unlocked',
	buyText = 'Buy: '..Config.CurrencyIcon..'%s',
	buySpec = 'Buy: '..Config.CurrencyIcon..'%s with %s',
	viewTxt = 'View House',
	leavTxt = 'Leave',
	entrTxt = 'Enter',
	sellTxt = 'Sell',
	nokText = 'Knock',
	raidTxt = 'Raid',
	confTxt = 'Yes',
	decText = 'Cancel',
	autoFrn = 'Buy Auto-Refurnished?',
	prevFrn = 'Buy With Prev-Own Furniture?',
	letNTxt = 'Let In House',
	furnTxt = 'Furnish',
	unfnTxt = 'Unfurnish',
	gvKyTxt = 'Give Key',
	tkKyTxt = 'Take Key',
	chkMail = 'Check Mailbox',
	cancTxt = 'Nevermind',
	frnMenu = 'Choose Item',
	prchTxt = 'Purchase?',
	xitFurn = 'Press E to exit the store',
	mnuScll = 'Scroll through Category with E',
	sellMrk = 'Market',
	sellBnk = 'Bank Buy-Back',
	sellAuc = 'Auction',
	sellTtl = 'Sell House?',
	setPryc = 'Set Price For Home',
	needNum = 'You must input a number value',
	lowPryc = 'The sale price must be lower than '..Config.CurrencyIcon..'%s',
	noPrice = 'No price was set, sale cancelled',
	onMarkt = '%s is now on the market for '..Config.CurrencyIcon..'%s',
	buyBack = 'Contacting bank to request buy-back of %s',
	bawtBck = '%s was sold back for '..Config.CurrencyIcon..'%s',
	dntWant = 'The bank does not want this house anymore',
	acptTtl = 'Accept Offer for '..Config.CurrencyIcon..'%s? Decline Fee: '..Config.CurrencyIcon..'%s',
	npcBawt = '%s has purchased %s for '..Config.CurrencyIcon..'%s',
	strtAuc = 'Starting online auction for %s at '..Config.CurrencyIcon..'%s',
	cancAuc = 'Press E any time to end auction at next offer',
	newOffr = '%s has offered '..Config.CurrencyIcon..'%s for %s',
	notWant = 'Nobody wanted your house, you can try another auction',
	frnHelp1 = 'Use NUMPAD keys 7 and 9 to slide left right\n8 and 5 to slide forward and back\n4 and 6 rotate it',
	frnHelp2 = 'Scroll Wheel for height\nCAPS increases movement speed Shift decreases it, E key snaps to ground.',
	frnHelp3 = "Press ENTER To Place \n Press X To Cancel",
	confPlc = 'Confirm Placement?',
	failFnd = 'No furniture found to furnish',
	confRem = 'Confirm Removal?',
	storOut = 'Store Outfit',
	warMenu = 'Wardrobe',
	wearRem = 'Remove or Wear?',
	wearTxt = 'Wear',
	remText = 'Remove',
	wntRong = 'Something went wrong, please try again',
	nameSel = 'Select Name For Outfit',
	needNam = 'You must input a name',
	nameLng = 'The name length must be between %s and %s characters',
	dorKnok = 'Someone has knocked at your door',
	nokAcpt = 'Knock Accepted: Enter?',
	conRaid = 'Raid Home: Confirm',
	dorOptn = 'You can access house options here',
	noShell = 'You are not inside a shell interior',
	frntDor = 'You must be at an owned door/garage to use this',
	keyHelp = 'Locks/Unlocks an MLO house door/garage when close enough',
	bneText = 'Break In',
	modNtFd = 'Model not found in server files',
	uTooFar = 'You are too far from the house you are trying to select',
	clstAdd = 'Select From Closest Addresses',
	dorNtFd = 'Door object not found, try again?',
	getClsr = 'Stand at the WALL touching the door. Do not stand in the center of the door frame, do not stand at the door handle, stand at the door hinges, the spot it rotates, THE ROTATION POINT',
	grgODis = 'Set Garage Open Distance',
	delPark = 'Delete Closest Parking Space',
	prk2Cls = 'This parking is too close to another',
	lndSize = 'Set Land Size For Parking',
	chsShll = 'Choose Shell',
	add2Sht = 'Address must be less than 55 characters, you are at %d',
	noAddrs = 'Failed to supply address, random address created',
	addAdrs = 'Type Out House Address Fully',
	amBlink = 'Blinking',
	amEnter = 'Entering home',
	amClose = 'Closing door',
	amExitt = 'Exiting home',
	giveKey = 'Give/Take Key',
	mstBNCr = 'You must be in a vehicle to do this action',
	mstBOwn = 'The car must be owned to store it in this garage',
	uNoKeys = 'You do not have a key to use',
	noBreak = 'You can not break into this home right now',
	isPecil = 'Should Home Have Special Price'
}

Config.TimeCycleMods = {
	['0'] = 'li',
	['1'] = 'underwater',
	['2'] = 'underwater_deep',
	['3'] = 'NoAmbientmult',
	['4'] = 'superDARK',
	['5'] = 'CAMERA_BW',
	['6'] = 'Forest',
	['7'] = 'micheal',
	['8'] = 'TREVOR',
	['9'] = 'FRANKLIN',
	['10'] = 'Tunnel',
	['11'] = 'carpark',
	['12'] = 'NEW_abattoir',
	['13'] = 'Vagos',
	['14'] = 'cops',
	['15'] = 'Bikers',
	['16'] = 'BikersSPLASH',
	['17'] = 'VagosSPLASH',
	['18'] = 'CopsSPLASH',
	['19'] = 'VAGOS_new_garage',
	['20'] = 'VAGOS_new_hangout',
	['21'] = 'NEW_jewel',
	['22'] = 'frankilnsAUNTS_new',
	['23'] = 'frankilnsAUNTS_SUNdir',
	['24'] = 'StreetLighting',
	['25'] = 'NEW_tunnels',
	['26'] = 'NEW_yellowtunnels',
	['27'] = 'NEW_tunnels_hole',
	['28'] = 'NEW_tunnels_ditch',
	['29'] = 'Paleto',
	['30'] = 'new_bank',
	['31'] = 'ReduceDrawDistance',
	['32'] = 'ReduceDrawDistanceMission',
	['33'] = 'lightpolution',
	['34'] = 'NEW_lesters',
	['35'] = 'ReduceDrawDistanceMAP',
	['36'] = 'reducewaterREF',
	['37'] = 'garage',
	['38'] = 'LightPollutionHills',
	['39'] = 'NewMicheal',
	['40'] = 'NewMichealupstairs',
	['41'] = 'NewMichealstoilet',
	['42'] = 'NewMichealgirly',
	['43'] = 'WATER_port',
	['44'] = 'WATER_salton',
	['45'] = 'WATER_river',
	['46'] = 'FIB_interview',
	['47'] = 'NEW_station_unfinished',
	['48'] = 'cashdepot',
	['49'] = 'cashdepotEMERGENCY',
	['50'] = 'FrankilinsHOUSEhills',
	['51'] = 'HicksbarNEW',
	['52'] = 'NOdirectLight',
	['53'] = 'SALTONSEA',
	['54'] = 'TUNNEL_green',
	['55'] = 'NewMicheal_night',
	['56'] = 'WATER_muddy',
	['57'] = 'WATER_shore',
	['58'] = 'damage',
	['59'] = 'hitped',
	['60'] = 'dying',
	['61'] = 'overwater',
	['62'] = 'whitenightlighting',
	['63'] = 'TUNNEL_yellow',
	['64'] = 'buildingTOP',
	['65'] = 'WATER_lab',
	['66'] = 'cinema',
	['67'] = 'fireDEPT',
	['68'] = 'ranch',
	['69'] = 'TUNNEL_white',
	['70'] = 'V_recycle_mainroom',
	['71'] = 'V_recycle_dark',
	['72'] = 'V_recycle_light',
	['73'] = 'lightning_weak',
	['74'] = 'lightning_strong',
	['75'] = 'lightning_cloud',
	['76'] = 'gunclubrange',
	['77'] = 'NoAmbientmult_interior',
	['78'] = 'FullAmbientmult_interior',
	['79'] = 'StreetLightingJunction',
	['80'] = 'StreetLightingtraffic',
	['81'] = 'Multipayer_spectatorCam',
	['82'] = 'INT_NoAmbientmult',
	['83'] = 'INT_NoAmbientmult_art',
	['84'] = 'INT_FullAmbientmult',
	['85'] = 'INT_FULLAmbientmult_art',
	['86'] = 'INT_FULLAmbientmult_both',
	['87'] = 'INT_NoAmbientmult_both',
	['88'] = 'Sniper',
	['89'] = 'ReduceSSAO',
	['90'] = 'scope_zoom_in',
	['91'] = 'scope_zoom_out',
	['92'] = 'crane_cam',
	['93'] = 'WATER_silty',
	['94'] = 'Trevors_room',
	['95'] = 'Hint_cam',
	['96'] = 'venice_canal_tunnel',
	['97'] = 'blackNwhite',
	['98'] = 'projector',
	['99'] = 'paleto_opt',
	['100'] = 'warehouse',
	['101'] = 'pulse',
	['102'] = 'sleeping',
	['103'] = 'INT_garage',
	['104'] = 'nextgen',
	['105'] = 'crane_cam_cinematic',
	['106'] = 'TUNNEL_orange',
	['107'] = 'traffic_skycam',
	['108'] = 'powerstation',
	['109'] = 'SAWMILL',
	['110'] = 'LODmult_global_reduce',
	['111'] = 'LODmult_HD_orphan_reduce',
	['112'] = 'LODmult_HD_orphan_LOD_reduce',
	['113'] = 'LODmult_LOD_reduce',
	['114'] = 'LODmult_SLOD1_reduce',
	['115'] = 'LODmult_SLOD2_reduce',
	['116'] = 'LODmult_SLOD3_reduce',
	['117'] = 'NewMicheal_upstairs',
	['118'] = 'micheals_lightsOFF',
	['119'] = 'telescope',
	['120'] = 'WATER_silverlake',
	['122'] = 'baseTONEMAPPING',
	['123'] = 'WATER_salton_bottom',
	['124'] = 'new_stripper_changing',
	['125'] = 'underwater_deep_clear',
	['126'] = 'prologue_ending_fog',
	['127'] = 'graveyard_shootout',
	['128'] = 'morebloom',
	['129'] = 'LIGHTSreduceFALLOFF',
	['130'] = 'INT_posh_hairdresser',
	['131'] = 'V_strip_office',
	['132'] = 'sunglasses',
	['133'] = 'vespucci_garage',
	['134'] = 'half_direct',
	['135'] = 'carpark_dt1_03',
	['136'] = 'tunnel_id1_11',
	['137'] = 'reducelightingcost',
	['138'] = 'NOrain',
	['139'] = 'morgue_dark',
	['140'] = 'CS3_rail_tunnel',
	['141'] = 'new_tunnels_entrance',
	['142'] = 'spectator1',
	['143'] = 'spectator2',
	['144'] = 'spectator3',
	['145'] = 'spectator4',
	['146'] = 'spectator5',
	['147'] = 'spectator6',
	['148'] = 'spectator7',
	['149'] = 'spectator8',
	['150'] = 'spectator9',
	['151'] = 'spectator10',
	['152'] = 'INT_NOdirectLight',
	['153'] = 'WATER_resevoir',
	['154'] = 'WATER_hills',
	['155'] = 'WATER_militaryPOOP',
	['156'] = 'NEW_ornate_bank',
	['157'] = 'NEW_ornate_bank_safe',
	['158'] = 'NEW_ornate_bank_entrance',
	['159'] = 'NEW_ornate_bank_office',
	['160'] = 'LODmult_global_reduce_NOHD',
	['161'] = 'interior_WATER_lighting',
	['162'] = 'gorge_reflectionoffset',
	['163'] = 'eyeINtheSKY',
	['164'] = 'resvoire_reflection',
	['165'] = 'NO_weather',
	['166'] = 'prologue_ext_art_amb',
	['167'] = 'prologue_shootout',
	['168'] = 'heathaze',
	['169'] = 'KT_underpass',
	['170'] = 'INT_nowaterREF',
	['171'] = 'carMOD_underpass',
	['172'] = 'refit',
	['173'] = 'NO_streetAmbient',
	['174'] = 'NO_coronas',
	['175'] = 'epsilion',
	['176'] = 'WATER_refmap_high',
	['177'] = 'WATER_refmap_med',
	['178'] = 'WATER_refmap_low',
	['179'] = 'WATER_refmap_verylow',
	['180'] = 'WATER_refmap_poolside',
	['181'] = 'WATER_refmap_silverlake',
	['182'] = 'WATER_refmap_venice',
	['183'] = 'FORdoron_delete',
	['184'] = 'NO_fog_alpha',
	['185'] = 'V_strip_nofog',
	['186'] = 'METRO_Tunnels',
	['187'] = 'METRO_Tunnels_entrance',
	['188'] = 'METRO_platform',
	['189'] = 'STRIP_stage',
	['190'] = 'STRIP_office',
	['191'] = 'STRIP_changing',
	['192'] = 'INT_NO_fogALPHA',
	['193'] = 'STRIP_nofog',
	['194'] = 'INT_streetlighting',
	['195'] = 'ch2_tunnel_whitelight',
	['196'] = 'AmbientPUSH',
	['197'] = 'ship_lighting',
	['198'] = 'powerplant_nightlight',
	['199'] = 'paleto_nightlight',
	['200'] = 'militarybase_nightlight',
	['201'] = 'sandyshore_nightlight',
	['202'] = 'jewel_gas',
	['203'] = 'WATER_refmap_off',
	['204'] = 'trailer_explosion_optimise',
	['205'] = 'nervousRON_fog',
	['206'] = 'DONT_overide_sunpos',
	['207'] = 'gallery_refmod',
	['208'] = 'prison_nightlight',
	['209'] = 'multiplayer_ped_fight',
	['210'] = 'ship_explosion_underwater',
	['211'] = 'EXTRA_bouncelight',
	['212'] = 'secret_camera',
	['213'] = 'canyon_mission',
	['214'] = 'gorge_reflection_gpu',
	['215'] = 'subBASE_water_ref',
	['216'] = 'poolsidewaterreflection2',
	['217'] = 'CUSTOM_streetlight',
	['218'] = 'ufo',
	['220'] = 'lab_none_exit',
	['221'] = 'FinaleBankexit',
	['222'] = 'prologue_reflection_opt',
	['223'] = 'tunnel_entrance',
	['224'] = 'tunnel_entrance_INT',
	['225'] = 'id1_11_tunnel',
	['226'] = 'reflection_correct_ambient',
	['227'] = 'scanline_cam_cheap',
	['228'] = 'scanline_cam',
	['229'] = 'VC_tunnel_entrance',
	['230'] = 'WATER_REF_malibu',
	['231'] = 'carpark_dt1_02',
	['232'] = 'FIB_interview_optimise',
	['233'] = 'Prologue_shootout_opt',
	['234'] = 'hangar_lightsmod',
	['235'] = 'plane_inside_mode',
	['236'] = 'eatra_bouncelight_beach',
	['237'] = 'downtown_FIB_cascades_opt',
	['238'] = 'jewel_optim',
	['239'] = 'gorge_reflectionoffset2',
	['240'] = 'ufo_deathray',
	['241'] = 'PORT_heist_underwater',
	['242'] = 'TUNNEL_orange_exterior',
	['243'] = 'hillstunnel',
	['244'] = 'jewelry_entrance_INT',
	['245'] = 'jewelry_entrance',
	['246'] = 'jewelry_entrance_INT_fog',
	['247'] = 'TUNNEL_yellow_ext',
	['248'] = 'NEW_jewel_EXIT',
	['249'] = 'services_nightlight',
	['250'] = 'CS1_railwayB_tunnel',
	['251'] = 'TUNNEL_green_ext',
	['252'] = 'CAMERA_secuirity',
	['253'] = 'CAMERA_secuirity_FUZZ',
	['254'] = 'int_hospital_small',
	['255'] = 'int_hospital_dark',
	['256'] = 'plaza_carpark',
	['257'] = 'gen_bank',
	['258'] = 'nightvision',
	['259'] = 'WATER_cove',
	['260'] = 'glasses_Darkblue',
	['261'] = 'glasses_VISOR',
	['262'] = 'heist_boat',
	['263'] = 'heist_boat_norain',
	['264'] = 'heist_boat_engineRoom',
	['265'] = 'buggy_shack',
	['266'] = 'mineshaft',
	['267'] = 'NG_first',
	['268'] = 'glasses_Scuba',
	['269'] = 'mugShot',
	['270'] = 'Glasses_BlackOut',
	['271'] = 'winning_room',
	['272'] = 'mugShot_lineup',
	['273'] = 'MPApartHigh_palnning',
	['274'] = 'v_dark',
	['275'] = 'vehicle_subint',
	['276'] = 'Carpark_MP_exit',
	['277'] = 'EXT_FULLAmbientmult_art',
	['278'] = 'new_MP_Garage_L',
	['279'] = 'fp_vig_black',
	['280'] = 'fp_vig_brown',
	['281'] = 'fp_vig_gray',
	['282'] = 'fp_vig_blue',
	['283'] = 'fp_vig_red',
	['284'] = 'fp_vig_green',
	['285'] = 'INT_trailer_cinema',
	['286'] = 'heliGunCam',
	['287'] = 'INT_smshop',
	['288'] = 'INT_mall',
	['289'] = 'Mp_Stilts',
	['290'] = 'Mp_Stilts_gym',
	['291'] = 'Mp_Stilts2',
	['292'] = 'Mp_Stilts_gym2',
	['293'] = 'MPApart_H_01',
	['294'] = 'MPApart_H_01_gym',
	['295'] = 'MP_H_01_Study',
	['296'] = 'MP_H_01_Bedroom',
	['297'] = 'MP_H_01_Bathroom',
	['298'] = 'MP_H_01_New',
	['299'] = 'MP_H_01_New_Bedroom',
	['300'] = 'MP_H_01_New_Bathroom',
	['301'] = 'MP_H_01_New_Study',
	['302'] = 'INT_smshop_inMOD',
	['303'] = 'NoPedLight',
	['304'] = 'morgue_dark_ovr',
	['305'] = 'INT_smshop_outdoor_bloom',
	['306'] = 'INT_smshop_indoor_bloom',
	['307'] = 'MP_H_02',
	['308'] = 'MP_H_04',
	['309'] = 'Mp_Stilts2_bath',
	['310'] = 'mp_h_05',
	['311'] = 'mp_h_07',
	['312'] = 'MP_H_06',
	['313'] = 'mp_h_08',
	['314'] = 'yacht_DLC',
	['315'] = 'mp_exec_office_01',
	['316'] = 'mp_exec_warehouse_01',
	['317'] = 'mp_exec_office_02',
	['318'] = 'mp_exec_office_03',
	['319'] = 'mp_exec_office_04',
	['320'] = 'mp_exec_office_05',
	['321'] = 'mp_exec_office_06',
	['322'] = 'mp_exec_office_03_blue',
	['323'] = 'mp_exec_office_03C',
	['324'] = 'mp_bkr_int01_garage',
	['325'] = 'mp_bkr_int01_transition',
	['326'] = 'mp_bkr_int01_small_rooms',
	['327'] = 'mp_bkr_int02_garage',
	['328'] = 'mp_bkr_int02_hangout',
	['329'] = 'mp_bkr_int02_small_rooms',
	['330'] = 'mp_bkr_ware01',
	['331'] = 'mp_bkr_ware02_standard',
	['332'] = 'mp_bkr_ware02_upgrade',
	['333'] = 'mp_bkr_ware02_dry',
	['334'] = 'mp_bkr_ware03_basic',
	['335'] = 'mp_bkr_ware03_upgrade',
	['336'] = 'mp_bkr_ware04',
	['337'] = 'mp_bkr_ware05',
	['338'] = 'mp_lad_night',
	['339'] = 'mp_lad_day',
	['340'] = 'mp_lad_judgment',
	['341'] = 'mp_imx_intwaremed',
	['342'] = 'mp_imx_intwaremed_office',
	['343'] = 'mp_imx_mod_int_01',
	['344'] = 'IMpExt_Interior_02',
	['345'] = 'ImpExp_Interior_01',
	['346'] = 'impexp_interior_01_lift',
	['347'] = 'IMpExt_Interior_02_stair_cage',
	['348'] = 'mp_gr_int01_white',
	['349'] = 'mp_gr_int01_grey',
	['350'] = 'mp_gr_int01_black',
	['351'] = 'grdlc_int_02',
	['352'] = 'mp_nightshark_shield_fp',
	['353'] = 'grdlc_int_02_trailer_cave',
	['354'] = 'mp_smg_int01_han',
	['355'] = 'mp_smg_int01_han_red',
	['356'] = 'mp_smg_int01_han_blue',
	['357'] = 'mp_smg_int01_han_yellow',
	['358'] = 'mp_x17dlc_in_sub',
	['359'] = 'mp_x17dlc_in_sub_no_reflection',
	['360'] = 'mp_x17dlc_base',
	['361'] = 'mp_x17dlc_base_dark',
	['362'] = 'mp_x17dlc_base_darkest',
	['363'] = 'mp_x17dlc_lab',
	['364'] = 'mp_x17dlc_lab_loading_bay',
	['365'] = 'mp_x17dlc_facility',
	['366'] = 'mp_x17dlc_facility_conference',
	['367'] = 'mp_x17dlc_int_01',
	['368'] = 'mp_x17dlc_int_01_tint1',
	['369'] = 'mp_x17dlc_int_01_tint2',
	['370'] = 'mp_x17dlc_int_01_tint3',
	['371'] = 'mp_x17dlc_int_01_tint4',
	['372'] = 'mp_x17dlc_int_01_tint5',
	['373'] = 'mp_x17dlc_int_01_tint6',
	['374'] = 'mp_x17dlc_int_01_tint7',
	['375'] = 'mp_x17dlc_int_01_tint8',
	['376'] = 'mp_x17dlc_int_01_tint9',
	['377'] = 'mp_x17dlc_facility2',
	['378'] = 'mp_x17dlc_int_02',
	['379'] = 'mp_x17dlc_int_02_tint1',
	['380'] = 'mp_x17dlc_int_02_tint2',
	['381'] = 'mp_x17dlc_int_02_tint3',
	['382'] = 'mp_x17dlc_int_02_tint4',
	['383'] = 'mp_x17dlc_int_02_tint5',
	['384'] = 'mp_x17dlc_int_02_tint6',
	['385'] = 'mp_x17dlc_int_02_tint7',
	['386'] = 'mp_x17dlc_int_02_tint8',
	['387'] = 'mp_x17dlc_int_02_tint9',
	['388'] = 'mp_x17dlc_int_02_vehicle_workshop_camera',
	['389'] = 'mp_x17dlc_int_02_vehicle_avenger_camera',
	['390'] = 'mp_x17dlc_int_02_weapon_avenger_camera',
	['391'] = 'mp_x17dlc_int_02_outdoor_intro_camera',
	['392'] = 'mp_x17dlc_int_silo',
	['393'] = 'mp_x17dlc_int_silo_escape',
	['394'] = 'mp_battle_int01',
	['395'] = 'mp_battle_int01_entry',
	['396'] = 'mp_battle_int01_office',
	['397'] = 'mp_battle_int01_dancefloor',
	['398'] = 'mp_battle_int01_dancefloor_OFF',
	['399'] = 'mp_battle_int01_garage',
	['400'] = 'mp_battle_int02',
	['401'] = 'mp_battle_int03',
	['402'] = 'mp_battle_int03_tint1',
	['403'] = 'mp_battle_int03_tint2',
	['404'] = 'mp_battle_int03_tint3',
	['405'] = 'mp_battle_int03_tint4',
	['406'] = 'mp_battle_int03_tint5',
	['407'] = 'mp_battle_int03_tint6',
	['408'] = 'mp_battle_int03_tint7',
	['409'] = 'mp_battle_int03_tint8',
	['410'] = 'mp_battle_int03_tint9',
	['411'] = 'Drone_FishEye_Lens',
	['412'] = 'int_arena_Mod',
	['413'] = 'int_arena_01',
	['414'] = 'int_arena_VIP',
	['415'] = 'MP_Arena_VIP',
	['416'] = 'int_arena_Mod_garage',
	['417'] = 'MP_Arena_theme_midday',
	['418'] = 'MP_Arena_theme_morning',
	['419'] = 'MP_Arena_theme_evening',
	['420'] = 'MP_Arena_theme_night',
	['421'] = 'MP_Arena_theme_atlantis',
	['422'] = 'MP_Arena_theme_toxic',
	['423'] = 'MP_Arena_theme_storm',
	['424'] = 'MP_Arena_theme_sandstorm',
	['425'] = 'MP_Arena_theme_saccharine',
	['426'] = 'MP_Arena_theme_hell',
	['427'] = 'MP_Arena_theme_scifi_night',
	['428'] = 'polluted',
	['429'] = 'lightning',
	['430'] = 'torpedo',
	['431'] = 'NEW_shrinksOffice',
	['432'] = 'Facebook_NEW',
	['433'] = 'NEW_trevorstrailer',
	['434'] = 'New_sewers',
	['435'] = 'facebook_serveroom',
	['436'] = 'V_Office_smoke_Fire',
	['437'] = 'V_FIB_IT3_alt5',
	['438'] = 'int_Hospital_DM',
	['439'] = 'int_Hospital2_DM',
	['440'] = 'int_Barber1',
	['441'] = 'int_tattoo_B',
	['442'] = 'glasses_black',
	['443'] = 'glasses_brown',
	['444'] = 'glasses_blue',
	['445'] = 'glasses_red',
	['446'] = 'glasses_green',
	['447'] = 'glasses_yellow',
	['448'] = 'glasses_purple',
	['449'] = 'glasses_pink',
	['450'] = 'glasses_orange',
	['451'] = 'WATER_ID2_21',
	['452'] = 'WATER_RichmanStuntJump',
	['453'] = 'CH3_06_water',
	['454'] = 'WATER_refmap_hollywoodlake',
	['455'] = 'WATER_CH2_06_01_03',
	['456'] = 'WATER_CH2_06_02',
	['457'] = 'WATER_CH2_06_04',
	['458'] = 'RemoteSniper',
	['459'] = 'V_Office_smoke',
	['460'] = 'V_Office_smoke_ext',
	['461'] = 'V_FIB_IT3',
	['462'] = 'V_FIB_IT3_alt',
	['463'] = 'V_FIB_stairs',
	['464'] = 'v_abattoir',
	['465'] = 'V_Abattoir_Cold',
	['466'] = 'v_recycle',
	['467'] = 'v_strip3',
	['468'] = 'v_strpchangerm',
	['469'] = 'v_jewel2',
	['470'] = 'v_foundry',
	['471'] = 'V_Metro_station',
	['472'] = 'v_metro',
	['473'] = 'V_Metro2',
	['474'] = 'v_torture',
	['475'] = 'v_sweat',
	['476'] = 'v_sweat_entrance',
	['477'] = 'v_sweat_NoDirLight',
	['478'] = 'Barry1_Stoned',
	['479'] = 'v_rockclub',
	['480'] = 'v_michael',
	['481'] = 'v_michael_lounge',
	['482'] = 'v_janitor',
	['483'] = 'int_amb_mult_large',
	['484'] = 'int_extlight_large',
	['485'] = 'ext_int_extlight_large',
	['486'] = 'int_extlight_small',
	['487'] = 'int_extlight_small_clipped',
	['488'] = 'int_extlight_large_fog',
	['489'] = 'int_extlight_small_fog',
	['490'] = 'int_extlight_none',
	['491'] = 'int_extlight_none_dark',
	['492'] = 'int_extlight_none_dark_fog',
	['493'] = 'int_extlight_none_fog',
	['494'] = 'int_clean_extlight_large',
	['495'] = 'int_clean_extlight_small',
	['496'] = 'int_clean_extlight_none',
	['497'] = 'prologue',
	['498'] = 'vagos_extlight_small',
	['499'] = 'FinaleBank',
	['500'] = 'FinaleBankMid',
	['501'] = 'v_cashdepot',
	['502'] = 'V_Solomons',
	['503'] = 'int_methlab_small',
	['504'] = 'int_Lost_small',
	['505'] = 'int_Lost_none',
	['506'] = 'int_ControlTower_small',
	['507'] = 'int_ControlTower_none',
	['508'] = 'int_dockcontrol_small',
	['509'] = 'int_hanger_small',
	['510'] = 'int_hanger_none',
	['511'] = 'int_cluckinfactory_small',
	['512'] = 'int_cluckinfactory_none',
	['513'] = 'int_FranklinAunt_small',
	['514'] = 'stc_franklinsHouse',
	['515'] = 'stc_coroners',
	['516'] = 'stc_trevors',
	['517'] = 'stc_deviant_lounge',
	['518'] = 'stc_deviant_bedroom',
	['519'] = 'int_carshowroom',
	['520'] = 'int_Farmhouse_small',
	['521'] = 'int_Farmhouse_none',
	['522'] = 'int_carmod_small',
	['523'] = 'SP1_03_drawDistance',
	['524'] = 'int_clotheslow_large',
	['525'] = 'v_bahama',
	['526'] = 'gunclub',
	['527'] = 'int_GasStation',
	['528'] = 'PoliceStation',
	['529'] = 'PoliceStationDark',
	['530'] = 'Shop247',
	['531'] = 'Shop247_none',
	['532'] = 'Hicksbar',
	['533'] = 'cBank_back',
	['534'] = 'cBank_front',
	['535'] = 'int_office_Lobby',
	['536'] = 'int_office_LobbyHall',
	['537'] = 'SheriffStation',
	['538'] = 'LifeInvaderLOD',
	['539'] = 'int_motelroom',
	['540'] = 'metro',
	['541'] = 'int_ClothesHi',
	['542'] = 'FIB_5',
	['543'] = 'int_chopshop',
	['544'] = 'int_tattoo',
	['545'] = 'gunstore',
	['546'] = 'int_Hospital_Blue',
	['547'] = 'FIB_6',
	['548'] = 'FIB_B',
	['549'] = 'FIB_A',
	['550'] = 'lab_none',
	['551'] = 'lab_none_dark',
	['552'] = 'lab_none_dark_fog',
	['553'] = 'MP_Garage_L',
	['554'] = 'MP_Studio_Lo',
	['555'] = 'StadLobby',
	['556'] = 'Hanger_INTmods',
	['557'] = 'MPApartHigh',
	['558'] = 'int_Hospital_BlueB',
	['559'] = 'int_tunnel_none_dark',
	['560'] = 'MP_lowgarage',
	['561'] = 'MP_MedGarage',
	['562'] = 'shades_yellow',
	['563'] = 'shades_pink',
	['564'] = 'Mp_apart_mid',
	['565'] = 'yell_tunnel_nodirect',
	['566'] = 'int_carrier_hanger',
	['567'] = 'int_carrier_stair',
	['568'] = 'int_carrier_rear',
	['569'] = 'int_carrier_control',
	['570'] = 'int_carrier_control_2',
	['571'] = 'AP1_01_C_NoFog',
	['572'] = 'AP1_01_B_IntRefRange',
	['573'] = 'rply_saturation',
	['574'] = 'rply_saturation_neg',
	['575'] = 'rply_vignette',
	['576'] = 'rply_vignette_neg',
	['577'] = 'rply_contrast',
	['578'] = 'rply_contrast_neg',
	['579'] = 'rply_brightness',
	['580'] = 'rply_brightness_neg',
	['581'] = 'rply_motionblur',
	['582'] = 'V_CIA_Facility',
	['583'] = 'default',
	['584'] = 'gunshop',
	['585'] = 'MichaelsDirectional',
	['586'] = 'Bank_HLWD',
	['587'] = 'MichaelsNODirectional',
	['588'] = 'MichaelsDarkroom',
	['589'] = 'int_lesters',
	['590'] = 'Tunnel_green1',
	['591'] = 'cinema_001',
	['592'] = 'exile1_plane',
	['593'] = 'player_transition',
	['594'] = 'player_transition_no_scanlines',
	['595'] = 'player_transition_scanlines',
	['596'] = 'switch_cam_1',
	['597'] = 'switch_cam_2',
	['598'] = 'Bloom',
	['599'] = 'BloomLight',
	['600'] = 'BloomMid',
	['601'] = 'DrivingFocusLight',
	['602'] = 'DrivingFocusDark',
	['603'] = 'RaceTurboLight',
	['604'] = 'RaceTurboDark',
	['605'] = 'BulletTimeLight',
	['606'] = 'BulletTimeDark',
	['607'] = 'REDMIST',
	['608'] = 'REDMIST_blend',
	['609'] = 'MP_Bull_tost',
	['610'] = 'MP_Bull_tost_blend',
	['611'] = 'MP_Powerplay',
	['612'] = 'MP_Powerplay_blend',
	['613'] = 'MP_Killstreak',
	['614'] = 'MP_Killstreak_blend',
	['615'] = 'MP_Loser',
	['616'] = 'MP_Loser_blend',
	['617'] = 'CHOP',
	['618'] = 'FranklinColorCode',
	['619'] = 'MichaelColorCode',
	['620'] = 'TrevorColorCode',
	['621'] = 'NeutralColorCode',
	['622'] = 'NeutralColorCodeLight',
	['623'] = 'FranklinColorCodeBasic',
	['624'] = 'MichaelColorCodeBasic',
	['625'] = 'TrevorColorCodeBasic',
	['626'] = 'NeutralColorCodeBasic',
	['627'] = 'DefaultColorCode',
	['628'] = 'PlayerSwitchPulse',
	['629'] = 'PlayerSwitchNeutralFlash',
	['630'] = 'hud_def_lensdistortion',
	['631'] = 'hud_def_lensdistortion_subtle',
	['632'] = 'hud_def_blur',
	['633'] = 'hud_def_blur_switch',
	['634'] = 'hud_def_colorgrade',
	['635'] = 'hud_def_flash',
	['636'] = 'hud_def_desatcrunch',
	['637'] = 'hud_def_desat_switch',
	['638'] = 'hud_def_desat_cold',
	['639'] = 'hud_def_desat_cold_kill',
	['640'] = 'hud_def_desat_Neutral',
	['641'] = 'hud_def_focus',
	['642'] = 'hud_def_desat_Franklin',
	['643'] = 'hud_def_desat_Michael',
	['644'] = 'hud_def_desat_Trevor',
	['645'] = 'hud_def_Franklin',
	['646'] = 'hud_def_Michael',
	['647'] = 'hud_def_Trevor',
	['648'] = 'michealspliff',
	['649'] = 'michealspliff_blend',
	['650'] = 'michealspliff_blend02',
	['651'] = 'trevorspliff',
	['652'] = 'trevorspliff_blend',
	['653'] = 'trevorspliff_blend02',
	['654'] = 'BarryFadeOut',
	['655'] = 'stoned',
	['656'] = 'stoned_cutscene',
	['657'] = 'stoned_monkeys',
	['658'] = 'stoned_aliens',
	['659'] = 'Drunk',
	['660'] = 'drug_flying_base',
	['661'] = 'drug_flying_01',
	['662'] = 'drug_flying_02',
	['663'] = 'DRUG_gas_huffin',
	['664'] = 'Drug_deadman',
	['665'] = 'Drug_deadman_blend',
	['666'] = 'DRUG_2_drive',
	['667'] = 'drug_drive_blend01',
	['668'] = 'drug_drive_blend02',
	['669'] = 'drug_wobbly',
	['670'] = 'Dont_tazeme_bro',
	['671'] = 'dont_tazeme_bro_b',
	['672'] = 'int_extlght_sm_cntrst',
	['673'] = 'MP_heli_cam',
	['674'] = 'helicamfirst',
	['675'] = 'introblue',
	['676'] = 'MP_select',
	['677'] = 'PERSHING_water_reflect',
	['678'] = 'exile1_exit',
	['679'] = 'phone_cam',
	['680'] = 'ExplosionJosh',
	['681'] = 'RaceTurboFlash',
	['682'] = 'MP_death_grade',
	['683'] = 'MP_death_grade_blend01',
	['684'] = 'MP_death_grade_blend02',
	['685'] = 'NG_deathfail_BW_base',
	['686'] = 'NG_deathfail_BW_blend01',
	['687'] = 'NG_deathfail_BW_blend02',
	['688'] = 'MP_job_win',
	['689'] = 'MP_job_lose',
	['690'] = 'MP_corona_tournament',
	['691'] = 'MP_corona_tournament_DOF',
	['692'] = 'MP_corona_heist',
	['693'] = 'MP_corona_heist_blend',
	['694'] = 'MP_corona_heist_DOF',
	['695'] = 'MP_corona_heist_BW',
	['696'] = 'MP_corona_selection',
	['697'] = 'WhiteOut',
	['698'] = 'BlackOut',
	['699'] = 'MP_job_load',
	['700'] = 'MP_intro_logo',
	['701'] = 'MP_corona_switch',
	['702'] = 'MP_race_finish',
	['703'] = 'phone_cam3_REMOVED',
	['704'] = 'phone_cam8_REMOVED',
	['705'] = 'phone_cam1',
	['706'] = 'phone_cam2',
	['707'] = 'phone_cam3',
	['708'] = 'phone_cam4',
	['709'] = 'phone_cam5',
	['710'] = 'phone_cam6',
	['711'] = 'phone_cam7',
	['712'] = 'phone_cam8',
	['713'] = 'phone_cam9',
	['714'] = 'phone_cam10',
	['715'] = 'phone_cam11',
	['716'] = 'phone_cam12',
	['717'] = 'phone_cam13',
	['718'] = 'FranklinColorCodeBright',
	['719'] = 'MichaelColorCodeBright',
	['720'] = 'TrevorColorCodeBright',
	['721'] = 'NeutralColorCodeBright',
	['722'] = 'Kifflom',
	['723'] = 'MP_job_load_01',
	['724'] = 'MP_job_load_02',
	['725'] = 'MP_job_preload',
	['726'] = 'MP_job_preload_blend',
	['727'] = 'NG_filmnoir_BW01',
	['728'] = 'NG_filmnoir_BW02',
	['729'] = 'lab_none_exit_OVR',
	['730'] = 'lab_none_dark_OVR',
	['731'] = 'LectroLight',
	['732'] = 'LectroDark',
	['733'] = 'NG_filmic01',
	['734'] = 'NG_filmic02',
	['735'] = 'NG_filmic03',
	['736'] = 'NG_filmic04',
	['737'] = 'NG_filmic05',
	['738'] = 'NG_filmic06',
	['739'] = 'NG_filmic07',
	['740'] = 'NG_filmic08',
	['741'] = 'NG_filmic09',
	['742'] = 'NG_filmic10',
	['743'] = 'NG_filmic11',
	['744'] = 'NG_filmic12',
	['745'] = 'NG_filmic13',
	['746'] = 'NG_filmic14',
	['747'] = 'NG_filmic15',
	['748'] = 'NG_filmic16',
	['749'] = 'NG_filmic17',
	['750'] = 'NG_filmic18',
	['751'] = 'NG_filmic19',
	['752'] = 'NG_filmic20',
	['753'] = 'NG_filmic21',
	['754'] = 'NG_filmic22',
	['755'] = 'NG_filmic23',
	['756'] = 'NG_filmic24',
	['757'] = 'NG_filmic25',
	['758'] = 'NG_blackout',
	['759'] = 'MP_deathfail_night',
	['760'] = 'lodscaler',
	['761'] = 'maxlodscaler',
	['762'] = 'MP_job_preload_night',
	['763'] = 'MP_job_end_night',
	['764'] = 'MP_corona_heist_BW_night',
	['765'] = 'MP_corona_heist_night',
	['766'] = 'MP_corona_heist_night_blend',
	['767'] = 'PennedInLight',
	['768'] = 'PennedInDark',
	['769'] = 'BeastLaunch01',
	['770'] = 'BeastLaunch02',
	['771'] = 'BeastIntro01',
	['772'] = 'BeastIntro02',
	['773'] = 'CrossLine01',
	['774'] = 'CrossLine02',
	['775'] = 'InchOrange01',
	['776'] = 'InchOrange02',
	['777'] = 'InchPurple01',
	['778'] = 'InchPurple02',
	['779'] = 'TinyPink01',
	['780'] = 'TinyPink02',
	['781'] = 'TinyGreen01',
	['782'] = 'TinyGreen02',
	['783'] = 'InchPickup01',
	['784'] = 'InchPickup02',
	['785'] = 'PPOrange01',
	['786'] = 'PPOrange02',
	['787'] = 'PPPurple01',
	['788'] = 'PPPurple02',
	['789'] = 'PPGreen01',
	['790'] = 'PPGreen02',
	['791'] = 'PPPink01',
	['792'] = 'PPPink02',
	['793'] = 'StuntSlowLight',
	['794'] = 'StuntSlowDark',
	['795'] = 'StuntFastLight',
	['796'] = 'StuntFastDark',
	['797'] = 'PPFilter',
	['798'] = 'BikerFilter',
	['799'] = 'LostTimeLight',
	['800'] = 'LostTimeDark',
	['801'] = 'LostTimeFlash',
	['802'] = 'DeadlineNeon01',
	['803'] = 'BikerFormFlash',
	['804'] = 'BikerForm01',
	['805'] = 'VolticBlur',
	['806'] = 'VolticFlash',
	['807'] = 'VolticGold',
	['808'] = 'BleepYellow01',
	['809'] = 'BleepYellow02',
	['810'] = 'TinyRacerMoBlur',
	['811'] = 'WeaponUpgrade',
	['812'] = 'AirRaceBoost01',
	['813'] = 'AirRaceBoost02',
	['814'] = 'TransformRaceFlash',
	['815'] = 'BombCamFlash',
	['816'] = 'BombCam01',
	['817'] = 'WarpCheckpoint',
	['818'] = 'TransformFlash',
	['819'] = 'SmugglerFlash',
	['820'] = 'SmugglerCheckpoint01',
	['821'] = 'SmugglerCheckpoint02',
	['822'] = 'OrbitalCannon',
	['823'] = 'Broken_camera_fuzz',
	['824'] = 'RemixDrone',
	['825'] = 'ArenaWheelPurple01',
	['826'] = 'ArenaWheelPurple02',
	['827'] = 'ArenaEMP',
	['828'] = 'ArenaEMP_Blend'
}


-------------------------------

--Config.MinZOffsetRobberies = 45
Config.MinimumHouseRobberyPolice = 0 -------
Config.MinimumTime = 22
Config.MaximumTime = 4
Config.ResetRobberyHouses = 17

Config.RobberyBuyerLocations = {
    [1] = {
        model = "ig_terry", 
        x = 894.28, 
        y = -915.92, 
        z = 25.38, 
        h = 89.61,
    },
    [2] = {
        model = "s_m_y_dealer_01", 
        x = 512.54, 
        y = -532.60, 
        z = 24.71, 
        h = 263.44,
    },
    [3] = {
        model = "csb_prologuedriver", 
        x = -1169.70, 
        y = -2162.59, 
        z = 12.34, 
        h = 37.22,
    },
    [4] = {
        model = "cs_chengsr", 
        x = -478.69, 
        y = -2688.48, 
        z = 7.86, 
        h = 318.92,
    },
    [5] = {
        model = "a_m_m_mlcrisis_01", 
        x = -133.98, 
        y = -2377.39, 
        z = 8.41, 
        h = 248.22,
    },
    [6] = {
        model = "a_m_m_eastsa_02", 
        x = 1176.10, 
        y = -2996.51, 
        z = 5.0, 
        h = 169.637,
    },
    [7] = {
        model = "u_m_y_proldriver_01", 
        x = 3859.85, 
        y = 4458.40, 
        z = 0.93, 
        h = 66.63,
    },
    [8] = {
        model = "u_m_m_edtoh", 
        x = 1378.52, 
        y = 4301.99, 
        z = 35.61, 
        h = 28.09,
    },
}

Config.Rewards = {
    [1] = {
        ["cabin"] = {
            ["plastic"] = { probability = 350/1000, amount = 18 },
            ["diamond_ring"] = { probability = 300/1000, amount = 1 },
            ["goldchain"] = { probability = 300/1000, amount = 6 },
			["cash"] = { probability = 300/1000, amount = 2000 },
			["painkillers"] = { probability = 25/1000, amount = 1 },
			["weapon_knife"] = { probability = 25/1000, amount = 1 }
        },
        ["kitchen"] = {
            ["tosti"] = { probability = 350/1000, amount = 2 },
            ["sandwich"] = { probability = 350/1000, amount = 2 },
            ["goldchain"] = { probability = 275/1000, amount = 4 },
			["weapon_knife"] = { probability = 25/1000, amount = 1 }
        },
        ["chest"] = {
            ["plastic"] = { probability = 100/1000, amount = 25 },
            ["rolex"] = { probability = 200/1000, amount = 1 },
            ["diamond_ring"] = { probability = 200/1000, amount = 1 },
            ["goldchain"] = { probability = 100/1000, amount = 8 },
            ["pc"] = { probability = 250/1000, amount = 1 },
			["cash"] = { probability = 100/1000, amount = 2500 },
			["weapon_combatpistol"] = { probability = 50/1000, amount = 1 }
        },
    },
	[2] = {
        ["cabin"] = {
            ["rubber"] = { probability = 100/1000, amount = 2 },
            ["diamond_ring"] = { probability = 300/1000, amount = 1 },
            ["goldchain"] = { probability = 300/1000, amount = 10 },
			["cash"] = { probability = 200/1000, amount = 4000 },
			["painkillers"] = { probability = 100/1000, amount = 1 }
        },
        ["kitchen"] = {
            ["tosti"] = { probability = 350/1000, amount = 1 },
            ["sandwich"] = { probability = 350/1000, amount = 1 },
            ["goldchain"] = { probability = 300/1000, amount = 6 },
        },
        ["chest"] = {
            ["rolex"] = { probability = 175/1000, amount = 1 },
            ["diamond_ring"] = { probability = 175/1000, amount = 1 },
            ["goldchain"] = { probability = 150/1000, amount = 10 },
			["rubber"] = { probability = 50/1000, amount = 6 },
            ["pc"] = { probability = 150/1000, amount = 1 },
			["cash"] = { probability = 150/1000, amount = 4500 },
			["electronickit"] = { probability = 75/1000, amount = 1 },
			["pistol_suppressor"] = { probability = 50/1000, amount = 1 },
			["weapon_microsmg"] = { probability = 25/1000, amount = 1 }
        },
    },
	[3] = {
        ["cabin"] = {
            ["rubber"] = { probability = 100/1000, amount = 6 },
            ["diamond_ring"] = { probability = 300/1000, amount = 1 },
            ["goldchain"] = { probability = 300/1000, amount = 13 },
			["cash"] = { probability = 200/1000, amount = 5000 },
			["painkillers"] = { probability = 100/1000, amount = 1 }
        },
        ["kitchen"] = {
            ["tosti"] = { probability = 350/1000, amount = 1 },
            ["sandwich"] = { probability = 350/1000, amount = 1 },
            ["goldchain"] = { probability = 300/1000, amount = 8 },
        },
        ["chest"] = {
            ["rolex"] = { probability = 175/1000, amount = 1 },
            ["diamond_ring"] = { probability = 175/1000, amount = 1 },
            ["goldchain"] = { probability = 150/1000, amount = 16 },
			["rubber"] = { probability = 50/1000, amount = 10 },
            ["pc"] = { probability = 150/1000, amount = 1 },
			["cash"] = { probability = 150/1000, amount = 5500 },
			["electronickit"] = { probability = 75/1000, amount = 1 },
			["smg_suppressor"] = { probability = 50/1000, amount = 1 },
			["weapon_assaultrifle"] = { probability = 25/1000, amount = 1 }
        },
    }
}

Config.RobberyHouses = {
	['JamestownSt'] = {
		['coords'] = {
			["x"] = 495.41,
            ["y"] = -1823.35,
            ["z"] = 28.86,
            ["h"] = 142.80
		},
		['tier'] = 1,
		['opened'] = false,
		["pickableItems"] = {
			['tv1'] = {
				['model'] = "prop_tv_02" ,
				["coords"] = {
					["x"] = 2.78,
					["y"] = -2.17,
					["z"] = -20.0,
					["h"] = 0.0
				},
				['stolen'] = false
			},
			['painting1'] = {
				['model'] = "h4_prop_h4_painting_01e" ,
				["coords"] = {
					["x"] = -3.11,
					["y"] = 0.3,
					["z"] = -20.0,
					["h"] = 180.0
				},
				['stolen'] = false
			}
		},
		["furniture"] = {
            [1] = {
                ["type"] = "cabin", --cabin next to bed
                ["coords"] = {
                    ["x"] = 1.05,
                    ["y"] = -2.63,
                    ["z"] = -20.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.106,
                    ["y"] = 4.04,
                    ["z"] = -20.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 4.07,
                    ["y"] = 4.37,
                    ["z"] = -20.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [4] = {
                ["type"] = "cabin", -- cabin next to door
                ["coords"] = {
                    ["x"] = 6.3,
                    ["y"] = 0.5,
                    ["z"] = -20.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
        },
		['ped']= {
			['coords'] = {
				["x"] = 2.64,
				["y"] = -4.64,
				["z"] = 10.0,
				['h'] = 179.0
				}
        }
	},
	['BayCityAve'] = {
		['coords'] = {
			["x"] = -1225.88,
            ["y"] = -1209.10,
            ["z"] = 8.33,
            ["h"] = 98.74,
		},
		['tier'] = 1,
		['opened'] = false,
		["pickableItems"] = {
			['tv1'] = {
				['model'] = "prop_tv_02" ,
				["coords"] = {
					["x"] = 2.78,
					["y"] = -2.17,
					["z"] = -20.0,
					["h"] = 0.0
				},
				['stolen'] = false
			},
			['painting1'] = {
				['model'] = "h4_prop_h4_painting_01e" ,
				["coords"] = {
					["x"] = -3.11,
					["y"] = 0.3,
					["z"] = -20.0,
					["h"] = 180.0
				},
				['stolen'] = false
			}
		},
		["furniture"] = {
            [1] = {
                ["type"] = "cabin", --cabin next to bed
                ["coords"] = {
                    ["x"] = 1.05,
                    ["y"] = -2.63,
                    ["z"] = -20.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.106,
                    ["y"] = 4.04,
                    ["z"] = -20.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 4.07,
                    ["y"] = 4.37,
                    ["z"] = -20.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [4] = {
                ["type"] = "cabin", -- cabin next to door
                ["coords"] = {
                    ["x"] = 6.3,
                    ["y"] = 0.5,
                    ["z"] = -20.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
        }
	},
	['ProcopioDr'] = {
		['coords'] = {
			["x"] = -272.50,
            ["y"] = 6400.97,
            ["z"] = 31.50,
            ["h"] = 39.99,
		},
		['tier'] = 1,
		['opened'] = false,
		["pickableItems"] = {
			['tv1'] = {
				['model'] = "prop_tv_02" ,
				["coords"] = {
					["x"] = 2.78,
					["y"] = -2.17,
					["z"] = -20.0,
					["h"] = 0.0
				},
				['stolen'] = false
			},
			['painting1'] = {
				['model'] = "h4_prop_h4_painting_01e" ,
				["coords"] = {
					["x"] = -3.11,
					["y"] = 0.3,
					["z"] = -20.0,
					["h"] = 180.0
				},
				['stolen'] = false
			}
		},
		["furniture"] = {
            [1] = {
                ["type"] = "cabin", --cabin next to bed
                ["coords"] = {
                    ["x"] = 1.05,
                    ["y"] = -2.63,
                    ["z"] = -20.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.106,
                    ["y"] = 4.04,
                    ["z"] = -20.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 4.07,
                    ["y"] = 4.37,
                    ["z"] = -20.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [4] = {
                ["type"] = "cabin", -- cabin next to door
                ["coords"] = {
                    ["x"] = 6.3,
                    ["y"] = 0.5,
                    ["z"] = -20.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
        }
	},
    ["PicturePerfectDrive"] = {
        ["coords"] = {
            ["x"] = -784.45,
            ["y"] = 459.3,
            ["z"] = 100.17,
            ["h"] = 229.5,
        },
        ["opened"] = false,
        ["tier"] = 2,
		["pickableItems"] = {
			["tv2"] = {
				['model'] = 'prop_tv_flat_02b' ,
				["coords"] = {
					["x"] = 6.13,
					["y"] = 3.05,
					["z"] = -20.0,
					["h"] = 180.0
				},
				['stolen'] = false
			},
			['painting2'] = {
				['model'] = "ch_prop_vault_painting_01b" ,
				["coords"] = {
					["x"] = 4.23,
					["y"] = 10.3,
					["z"] = -20.0,
					["h"] = 0.0
				},
				['stolen'] = false
			}
		},
		['hackdesk'] = {
			['model'] = 'v_corp_desksetb' ,
			["coords"] = {
				["x"] = 5.4,
				["y"] = -4.52,
				["z"] = -20,
				["h"] = 272.0
			},
			["searched"] = false,
			["isBusy"] = false,
			["text"] = "Hack"
		},
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin", -- cabin next to bed
                ["coords"] = {
                    ["x"] = 4.4,
                    ["y"] = 7.83,
                    ["z"] = -20,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [2] = {
                ["type"] = "cabin", -- cabin
                ["coords"] = {
                    ["x"] = 1.25,
                    ["y"] = 1.42,
                    ["z"] = -20,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [3] = {
                ["type"] = "kitchen", -- kitchen
                ["coords"] = {
                    ["x"] = -2.14,
                    ["y"] = -0.23,
                    ["z"] = -20,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [4] = {
                ["type"] = "chest", --chest in bedroom
                ["coords"] = {
                    ["x"] = 7.08,
                    ["y"] = 3.97,
                    ["z"] = -20.8,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search chest"
            },
            [5] = {
                ["type"] = "cabin", --
                ["coords"] = {
                    ["x"] = -6.73,
                    ["y"] = 4.52,
                    ["z"] = -20,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
        }
    },
    ["MiltonRD"] = {
        ["coords"] = {
            ["x"] = -536.63,
            ["y"] = 818.51,
            ["z"] = 197.51,
            ["h"] = 229.5,
        },
        ["opened"] = false,
        ["tier"] = 2,
		["pickableItems"] = {
			["tv2"] = {
				['model'] = 'prop_tv_flat_02b' ,
				["coords"] = {
					["x"] = 6.13,
					["y"] = 3.05,
					["z"] = -20,
					["h"] = 180.0
				},
				['stolen'] = false
			},
			['painting2'] = {
				['model'] = "ch_prop_vault_painting_01b" ,
				["coords"] = {
					["x"] = 4.23,
					["y"] = 10.3,
					["z"] = -20,
					["h"] = 0.0
				},
				['stolen'] = false
			}
		},
		['hackdesk'] = {
			['model'] = 'v_corp_desksetb' ,
			["coords"] = {
				["x"] = 4.9,
				["y"] = -4.52,
				["z"] = -20,
				["h"] = 272.0
			},
			["searched"] = false,
			["isBusy"] = false,
			["text"] = "Hack"
		},
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin", -- cabin next to bed
                ["coords"] = {
                    ["x"] = 4.4,
                    ["y"] = 7.83,
                    ["z"] = -20,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [2] = {
                ["type"] = "cabin", -- cabin
                ["coords"] = {
                    ["x"] = 1.25,
                    ["y"] = 1.42,
                    ["z"] = -20,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [3] = {
                ["type"] = "kitchen", -- kitchen
                ["coords"] = {
                    ["x"] = -2.14,
                    ["y"] = -0.23,
                    ["z"] = -20,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [4] = {
                ["type"] = "chest", --chest in bedroom
                ["coords"] = {
                    ["x"] = 7.08,
                    ["y"] = 3.97,
                    ["z"] = -20.8,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search chest"
            },
            [5] = {
                ["type"] = "cabin", --
                ["coords"] = {
                    ["x"] = -6.73,
                    ["y"] = 4.52,
                    ["z"] = -20,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
        }
    },
    ["EastMirrorDr"] = {
        ["coords"] = {
            ["x"] = 1229.64, 
            ["y"] = -725.33, 
            ["z"] = 60.95, 
            ["h"] = 97.5
        },
        ["opened"] = false,
        ["tier"] = 2,
		["pickableItems"] = {
			["tv2"] = {
				['model'] = 'prop_tv_flat_02b' ,
				["coords"] = {
					["x"] = 6.13,
					["y"] = 3.05,
					["z"] = -20,
					["h"] = 180.0
				},
				['stolen'] = false
			},
			['painting2'] = {
				['model'] = "ch_prop_vault_painting_01b" ,
				["coords"] = {
					["x"] = 4.23,
					["y"] = 10.3,
					["z"] = -20,
					["h"] = 0.0
				},
				['stolen'] = false
			}
		},
		['hackdesk'] = {
			['model'] = 'v_corp_desksetb' ,
			["coords"] = {
				["x"] = 4.9,
				["y"] = -4.52,
				["z"] = -20,
				["h"] = 272.0
			},
			["searched"] = false,
			["isBusy"] = false,
			["text"] = "Hack"
		},
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin", -- cabin next to bed
                ["coords"] = {
                    ["x"] = 4.4,
                    ["y"] = 7.83,
                    ["z"] = -20,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [2] = {
                ["type"] = "cabin", -- cabin
                ["coords"] = {
                    ["x"] = 1.25,
                    ["y"] = 1.42,
                    ["z"] = -20,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [3] = {
                ["type"] = "kitchen", -- kitchen
                ["coords"] = {
                    ["x"] = -2.14,
                    ["y"] = -0.23,
                    ["z"] = -20,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [4] = {
                ["type"] = "chest", --chest in bedroom
                ["coords"] = {
                    ["x"] = 7.08,
                    ["y"] = 3.97,
                    ["z"] = -20.8,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search chest"
            },
            [5] = {
                ["type"] = "cabin", --
                ["coords"] = {
                    ["x"] = -6.73,
                    ["y"] = 4.52,
                    ["z"] = -20,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
        }
    },
	["RockfordHills"] = {
        ["coords"] = {
            ["x"] = -771.97, 
            ["y"] = 351.59, 
            ["z"] = 87.99, 
            ["h"] = 97.5
        },
		["spawn"] = {
			["x"] = -785.07, 
            ["y"] = 323.66, 
            ["z"] = 211.99, 
            ["h"] = 97.5
		},
        ["opened"] = false,
        ["tier"] = 3,
		["pickableItems"] = {
			["bust"] = {
				['model'] = 'v_corp_bk_bust' , --change
				["coords"] = {
					["x"] = -787.08 + 771.97,
					["y"] = 334.48 - 351.59,
					["z"] = 211.19 - 87.99,
					["h"] = 90.0
				},
				['stolen'] = false
			},
			['painting3'] = {
				['model'] = "ch_prop_vault_painting_01g" ,
				["coords"] = {
					["x"] = -772.3 + 771.97,
					["y"] = 333.41 - 351.59,
					["z"] = 211.39 - 87.99,
					["h"] = 270.0
				},
				['stolen'] = false
			},
			['painting2'] = {
				['model'] = "ch_prop_vault_painting_01b" ,
				["coords"] = {
					["x"] = -761.70 + 771.97,
					["y"] = 330.39 - 351.59,
					["z"] = 211.39 - 87.99,
					["h"] = 270.0
				},
				['stolen'] = false
			},
			['painting1'] = {
				['model'] = "h4_prop_h4_painting_01e" ,
				["coords"] = {
					["x"] = -787.49 + 771.97,
					["y"] = 341.57 - 351.59,
					["z"] = 211.19 - 87.99,
					["h"] = 90.0
				},
				['stolen'] = false
			}
		},
		['hackdesk'] = {
			["coords"] = {
				["x"] = -765.15  + 771.97,
				["y"] = 332.75 - 351.59,
				["z"] = 211.39 - 87.99,
				["h"] = 272.0
			},
			["searched"] = false,
			["isBusy"] = false,
			["text"] = "Hack"
		},
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -763.02 + 771.97,
                    ["y"] = 327.08 - 351.59,
                    ["z"] = 211.39 - 87.99,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -786.28 + 771.97,
                    ["y"] = 337.31 - 351.59,
                    ["z"] = 211.19 - 87.99,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [3] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = -790.54 + 771.97,
                    ["y"] = 330.62 - 351.59,
                    ["z"] = 210.79 - 87.99,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = -789.54 + 771.97,
                    ["y"] = 334.02 - 351.59,
                    ["z"] = 210.83 - 87.99,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [5] = {
                ["type"] = "cabin", --
                ["coords"] = {
                    ["x"] = -794.32 + 771.97,
                    ["y"] = 325.78 - 351.59,
                    ["z"] = 210.79 - 87.99,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
			[6] = {
                ["type"] = "chest", --
                ["coords"] = {
                    ["x"] = -794.41 + 771.97,
                    ["y"] = 335.55 - 351.59,
                    ["z"] = 210.79 - 87.99,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
			[7] = {
                ["type"] = "chest", --
                ["coords"] = {
                    ["x"] = -794.38 + 771.97,
                    ["y"] = 332.21 - 351.59,
                    ["z"] = 210.79 - 87.99,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
			[8] = {
                ["type"] = "kitchen", --
                ["coords"] = {
                    ["x"] = -769.56 + 771.97,
                    ["y"] = 339.95 - 351.59,
                    ["z"] = 211.39 - 87.99,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
			[9] = {
                ["type"] = "kitchen", --
                ["coords"] = {
                    ["x"] = -769.60 + 771.97,
                    ["y"] = 335.14 - 351.59,
                    ["z"] = 211.39 - 87.99,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
        }
    },
	["DidionDr"] = {
        ["coords"] = {
            ["x"] = -102.85, 
            ["y"] = 397.47, 
            ["z"] = 112.42, 
            ["h"] = 97.5
        },
		["spawn"] = {
			["x"] = -781.90, 
            ["y"] = 321.50, 
            ["z"] = 176.80, 
            ["h"] = 97.5
		},
        ["opened"] = false,
        ["tier"] = 3,
		["pickableItems"] = {
			["bust"] = {
				['model'] = 'v_corp_bk_bust' , --change
				["coords"] = {
					["x"] = -769.40 + 102.85,
					["y"] = 316.48 - 397.47,
					["z"] = 170.59 - 112.42,
					["h"] = 90.0
				},
				['stolen'] = false
			},
			['painting3'] = {
				['model'] = "ch_prop_vault_painting_01g" ,
				["coords"] = {
					["x"] = -776.03 + 102.85,
					["y"] = 322.80 - 397.47,
					["z"] = 173.00 - 112.42,
					["h"] = 0.0
				},
				['stolen'] = false
			},
			['painting2'] = {
				['model'] = "ch_prop_vault_painting_01b" ,
				["coords"] = {
					["x"] = -757.30 + 102.85,
					["y"] = 324.75 - 397.47,
					["z"] = 175.40 - 112.42,
					["h"] = 90.0
				},
				['stolen'] = false
			},
			['painting1'] = {
				['model'] = "h4_prop_h4_painting_01e" ,
				["coords"] = {
					["x"] = -766.57 + 102.85,
					["y"] = 322.78 - 397.47,
					["z"] = 170.59 - 112.42,
					["h"] = 90.0
				},
				['stolen'] = false
			}
		},
		['hackdesk'] = {
			["coords"] = {
				["x"] = -777.96 + 102.85,
				["y"] = 327.87 - 397.47,
				["z"] = 176.80 - 112.42,
				["h"] = 272.0
			},
			["searched"] = false,
			["isBusy"] = false,
			["text"] = "Hack"
		},
        ["furniture"] = {
            [1] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = -772.30 + 102.85,
                    ["y"] = 329.36 - 397.47,
                    ["z"] = 176.8 - 112.42,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -758.41 + 102.85,
                    ["y"] = 315.11 - 397.47,
                    ["z"] = 175.40 - 112.42,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [3] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = -753.51 + 102.85,
                    ["y"] = 315.11 - 397.47,
                    ["z"] = 175.40 - 112.42,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = -754.41 + 102.85,
                    ["y"] = 331.09 - 397.47,
                    ["z"] = 175.40 - 112.42,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [5] = {
                ["type"] = "chest", --
                ["coords"] = {
                    ["x"] = -762.82 + 102.85,
                    ["y"] = 321.53 - 397.47,
                    ["z"] = 170.59 - 112.42,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
			[6] = {
                ["type"] = "cabin", --
                ["coords"] = {
                    ["x"] = -759.53 + 102.85,
                    ["y"] = 316.65 - 397.47,
                    ["z"] = 170.59 - 112.42,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
			[7] = {
                ["type"] = "cabin", --
                ["coords"] = {
                    ["x"] = -760.78 + 102.85,
                    ["y"] = 326.87 - 397.47,
                    ["z"] = 170.59 - 112.42,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
			[8] = {
                ["type"] = "kitchen", --
                ["coords"] = {
                    ["x"] = -769.16 + 102.85,
                    ["y"] = 328.90 - 397.47,
                    ["z"] = 175.40 - 112.42,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
			[9] = {
                ["type"] = "kitchen", --
                ["coords"] = {
                    ["x"] = -764.71 + 102.85,
                    ["y"] = 326.90 - 397.47,
                    ["z"] = 175.40 - 112.42,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
			}
        }
    },
	["StrangewaysDr"] = {
        ["coords"] = {
            ["x"] = -635.60, 
            ["y"] = 44.13, 
            ["z"] = 42.69, 
            ["h"] = 97.5
        },
		["spawn"] = {
			["x"] = -774.05 , 
            ["y"] = 334.05, 
            ["z"] = 160.00, 
            ["h"] = 97.5
		},
        ["opened"] = false,
        ["tier"] = 3,
		["pickableItems"] = {
			["bust"] = {
				['model'] = 'v_corp_bk_bust' ,
				["coords"] = {
					["x"] = -780.43 + 635.60,
					["y"] = 335.09 - 44.13,
					["z"] = 156.19 - 42.69,
					["h"] = 180.0
				},
				['stolen'] = false
			},
			['painting3'] = {
				['model'] = "ch_prop_vault_painting_01g" ,
				["coords"] = {
					["x"] = -786.77 + 635.60,
					["y"] = 341.5 - 44.13,
					["z"] = 153.79 - 42.69,
					["h"] = 270.0
				},
				['stolen'] = false
			},
			['painting2'] = {
				['model'] = "ch_prop_vault_painting_01b" ,
				["coords"] = {
					["x"] = -780.71 + 635.60,
					["y"] = 342.90 - 44.13,
					["z"] = 156.20 - 42.69,
					["h"] = 0.0
				},
				['stolen'] = false
			},
			['painting1'] = {
				['model'] = "h4_prop_h4_painting_01e" ,
				["coords"] = {
					["x"] = -798.18 + 635.60,
					["y"] = 332.03 - 44.13,
					["z"] = 158.59 - 42.69,
					["h"] = 0.0
				},
				['stolen'] = false
			}
		},
		['hackdesk'] = {
			["coords"] = {
				["x"] = -778.50 + 635.60,
				["y"] = 329.78 - 44.13,
				["z"] = 160.00 - 42.69,
				["h"] = 272.0
			},
			["searched"] = false,
			["isBusy"] = false,
			["text"] = "Hack"
		},
        ["furniture"] = {
            [1] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = -784.18 + 635.60,
                    ["y"] = 328.79 - 44.13,
                    ["z"] = 160.0 - 42.69,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [2] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = -796.019 + 635.60,
                    ["y"] = 338.82 - 44.13,
                    ["z"] = 158.59 - 42.69,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [3] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -800.91 + 635.60,
                    ["y"] = 342.53 - 44.13,
                    ["z"] = 158.59 - 42.69,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = -801.75 + 635.60,
                    ["y"] = 326.59 - 44.13,
                    ["z"] = 158.59 - 42.69,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
            [5] = {
                ["type"] = "chest", --
                ["coords"] = {
                    ["x"] = -793.92 + 635.60,
                    ["y"] = 336.15 - 44.13,
                    ["z"] = 153.79 - 42.69,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
			[6] = {
                ["type"] = "cabin", --
                ["coords"] = {
                    ["x"] = -796.94 + 635.60,
                    ["y"] = 340.64 - 44.13,
                    ["z"] = 153.79 - 42.69,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
			[7] = {
                ["type"] = "cabin", --
                ["coords"] = {
                    ["x"] = -795.63 + 635.60,
                    ["y"] = 330.74 - 44.13,
                    ["z"] = 153.79 - 42.69,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
			[8] = {
                ["type"] = "kitchen", --
                ["coords"] = {
                    ["x"] = -792.17 + 635.60,
                    ["y"] = 330.67 - 44.13,
                    ["z"] = 158.59 - 42.69,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
            },
			[9] = {
                ["type"] = "kitchen", --
                ["coords"] = {
                    ["x"] = -787.28 + 635.60,
                    ["y"] = 329.48 - 44.13,
                    ["z"] = 158.59 - 42.69,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Search"
			}
        }
    }
}

Config.MaleNoHandshoes = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [16] = true,
    [18] = true,
    [26] = true,
    [52] = true,
    [53] = true,
    [54] = true,
    [55] = true,
    [56] = true,
    [57] = true,
    [58] = true,
    [59] = true,
    [60] = true,
    [61] = true,
    [62] = true,
    [112] = true,
    [113] = true,
    [114] = true,
    [118] = true,
    [125] = true,
    [132] = true,
}

Config.FemaleNoHandshoes = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [19] = true,
    [59] = true,
    [60] = true,
    [61] = true,
    [62] = true,
    [63] = true,
    [64] = true,
    [65] = true,
    [66] = true,
    [67] = true,
    [68] = true,
    [69] = true,
    [70] = true,
    [71] = true,
    [129] = true,
    [130] = true,
    [131] = true,
    [135] = true,
    [142] = true,
    [149] = true,
    [153] = true,
    [157] = true,
    [161] = true,
    [165] = true,
}