local objects       = {}
Config              = {}
Config.MaxDistance = 4.5

local sitting = false
local lastPos = nil
local currentSitObj = nil

Config.Sitable = {
	{prop = GetHashKey('v_res_fa_chair01'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_picnictable_01'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_picnictable_02'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_ilev_m_dinechair'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},

	{prop = GetHashKey('prop_bench_01a'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_bench_01b'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_bench_01c'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_bench_02'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_bench_03'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_bench_04'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_bench_05'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_bench_06'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_bench_05'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_bench_08'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_bench_09'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_bench_10'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_bench_11'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_fib_3b_bench'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_ld_bench01'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_wait_bench_01'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},

    -- CHAIR
    {prop = GetHashKey('hei_Heist_din_chair_05'), verticalOffset = -1.0, forwardOffset = 0.0, leftOffset = 0.0},
    {prop = GetHashKey('bkr_Prop_Biker_BoardChair01'), verticalOffset = -1.0, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_serv_ct_chair02'), verticalOffset = -1.0, forwardOffset = 0.0, leftOffset = 0.0},

	{prop = GetHashKey('hei_prop_heist_off_chair'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('hei_prop_hei_skid_chair'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_chair_01a'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_chair_01b'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_chair_02'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_chair_03'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_chair_04a'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_chair_04b'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_chair_05'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_chair_06'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_chair_05'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_chair_08'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_chair_09'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_chair_10'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_chateau_chair_01'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_clown_chair'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_cs_office_chair'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_direct_chair_01'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_direct_chair_02'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_gc_chair02'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_off_chair_01'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_off_chair_03'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_off_chair_04'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_off_chair_04b'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_off_chair_04_s'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_off_chair_05'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_old_deck_chair'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_old_wood_chair'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_rock_chair_01'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_skid_chair_01'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_skid_chair_02'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_skid_chair_03'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_sol_chair'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_wheelchair_01'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_wheelchair_01_s'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('p_armchair_01_s'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('p_clb_officechair_s'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('p_dinechair_01_s'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('p_ilev_p_easychair_s'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('p_soloffchair_s'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('p_yacht_chair_01_s'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_club_officechair'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_corp_bk_chair3'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_corp_cd_chair'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_corp_offchair'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_ilev_chair02_ped'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_ilev_hd_chair'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_ilev_p_easychair'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_ret_gc_chair03'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_ld_farm_chair01'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_table_04_chr'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_table_05_chr'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_table_06_chr'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_ilev_leath_chr'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_table_01_chr_a'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_table_01_chr_b'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_table_02_chr'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_table_03b_chr'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_table_03_chr'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_torture_ch_01'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_ilev_fh_dineeamesa'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},


	{prop = GetHashKey('v_ilev_fh_kitchenstool'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_ilev_tort_stool'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_ilev_fh_kitchenstool'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_ilev_fh_kitchenstool'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_ilev_fh_kitchenstool'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_ilev_fh_kitchenstool'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},

	-- SEAT
	{prop = GetHashKey('hei_prop_yah_seat_01'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('hei_prop_yah_seat_02'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('hei_prop_yah_seat_03'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_waiting_seat_01'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_yacht_seat_01'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_yacht_seat_02'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_yacht_seat_03'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_hobo_seat_01'), verticalOffset = -0.65, forwardOffset = 0.0, leftOffset = 0.0},

	-- COUCH
	
	{prop = GetHashKey('v_club_stagechair'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_rub_couch01'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('miss_rub_couch_01'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_ld_farm_couch01'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_ld_farm_couch02'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_rub_couch02'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_rub_couch03'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_rub_couch04'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},

    -- SOFA
    {prop = GetHashKey('apa_mp_h_stn_sofaCorn_05'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
    {prop = GetHashKey('bkr_Prop_Clubhouse_Sofa_01a'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('p_lev_sofa_s'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('p_res_sofa_l_s'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('p_v_med_p_sofa_s'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('p_yacht_sofa_01_s'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_ilev_m_sofa'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_res_tre_sofa_s'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_tre_sofa_mess_a_s'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_tre_sofa_mess_b_s'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('v_tre_sofa_mess_c_s'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},

	-- MISC
	{prop = GetHashKey('prop_roller_car_01'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('prop_roller_car_02'), verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	{prop = GetHashKey('ex_prop_offchair_exec_04'), verticalOffset = -1.1, forwardOffset = 0.0, leftOffset = 0.0}
}

Citizen.CreateThread(function()
	for k,v in pairs(Config.Sitable) do
		table.insert(objects, v.prop)
	end
end)

RegisterNetEvent('animation:Chair')
AddEventHandler('animation:Chair', function(anim)	
	local ped = PlayerPedId()
	local list = {}

	for k,v in pairs(objects) do
		local obj = GetClosestObjectOfType(GetEntityCoords(ped).x, GetEntityCoords(ped).y, GetEntityCoords(ped).z, 3.0, v, false, true ,true)
		local dist = #(GetEntityCoords(ped) - GetEntityCoords(obj))
		list[#list+1]= {object = obj, distance = dist, name = v}
	end

	local closest = list[1]
	for k,v in pairs(list) do
		if v.distance < closest.distance then
			closest = v
		end
	end

	local distance = closest.distance
	local object = closest.object
	local name = closest.name

	if distance < Config.MaxDistance and DoesEntityExist(object) then
		SetEntityInvincible(object, true)
		sit(object, anim)
	end

end)

function sit(object, anim)
	local ped = PlayerPedId()
	scenario = "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER"
	lastPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -1.0)
	currentSitObj = object
	FreezeEntityPosition(object, true)
	local objinfo = {}
	for k,v in pairs(Config.Sitable) do
		if tostring(v.prop) == tostring(GetEntityModel(object)) then
			objinfo = v
		end
	end
	local objloc = GetEntityCoords(object)

	sitting = true

	if anim == 2 then
		scenario = "PROP_HUMAN_SEAT_ARMCHAIR"
	elseif anim == 3 then
		scenario = "PROP_HUMAN_SEAT_DECKCHAIR"
	end

	TaskStartScenarioAtPosition(ped, scenario, objloc.x, objloc.y, objloc.z+(1.0+objinfo.verticalOffset), GetEntityHeading(object)+180.0, 0, true, true)

	local ped = PlayerPedId()
	while sitting do
		AttachEntityToEntity(ped, object, 20, 0.0, 0.0, 1.0+objinfo.verticalOffset, 0.0, 0.0, 180.0, false, false, false, false, 1, true)

		Citizen.Wait(0)
	end
	ClearPedTasks(ped)
	Citizen.Wait(1400)
	SetEntityCoords(ped,lastPos)
end

RegisterNetEvent("turnoffsitting")
AddEventHandler("turnoffsitting", function()
	sitting = false
end)

RegisterNetEvent("scCore:client:LoadInteractions")
AddEventHandler("scCore:client:LoadInteractions", function()
	exports["lcrp-interact"]:AddTargetModel(objects, {
		options = {
			{
				event = "animation:Chair",
				icon = "fas fa-chair",
				label = "Sit Casual",
				duty = false,
			},
			{
				event = "animation:Chair",
				icon = "fas fa-chair",
				label = "Sit Tense",
				duty = false,
				parameters = 2,
			},
			{
				event = "animation:Chair",
				icon = "fas fa-chair",
				label = "Sit Relaxed",
				duty = false,
				parameters = 3,
			},
		},
	  job = {"all"}, distance = 1.5})
end)