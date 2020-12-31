//-- construction menu
WF_AutoWallConstructingEnabled = false;

//--Required addons list here. Push addon class name from config.bin in array--
WF_REQ_ADDONS = 	[
						["@CBA_A3", ["cba_xeh", "cba_help"]], 
						["@CUP Units", ["CUP_Creatures_People_Civil_Chernarus", "CUP_Creatures_People_Core"]],
						["@CUP Vehicles", ["CUP_AirVehicles_Core", "CUP_TrackedVehicles_Core"]],
						["@CUP Weapons", ["CUP_BaseData", "CUP_Weapons_AK"]]
				];

WF_C_GARBAGE_OBJECTS = ['Land_HBarrier_large','Land_HBarrier5','Base_WarfareBBarrier10xTall', 'Land_BagBunker_Small_F',
'Land_BagBunker_01_small_green_F', 'Land_HBarrier_01_wall_6_green_F', 'Land_HBarrier_01_wall_corner_green_F', 'Land_fort_artillery_nest',
'Land_fort_rampart', 'Hedgehog', 'Land_Razorwire_F', 'Wire', 'Hhedgehog_concreteBig', 'Concrete_Wall_EP1', 'Land_CamoConcreteWall_01_l_4m_v2_F',
'Land_Vez_svetla', 'Land_HBarrier_large', 'Land_fort_bagfence_long','Land_fort_bagfence_round',  'CamoNet_INDP_F',
'CamoNet_INDP_open_F', 'CamoNet_INDP_big_F', 'CamoNet_BLUFOR_F', 'CamoNet_BLUFOR_open_F', 'CamoNet_BLUFOR_big_F', 'Land_StoneWall_01_s_d_F'];

WF_C_STATIC_DEFENCE_FOR_COMPOSITIONS = ['CUP_I_DSHKM_NAPA', 'CUP_I_2b14_82mm_TK_GUE', 'CUP_I_ZU23_NAPA'];

WF_C_INFANTRY_TO_REQUIP = [
    ['CUP_O_MVD_Soldier_MG', ['PKP'], ['7.62mm 100Rnd PKM (Green TE4) Box x4']],
    ['CUP_B_USMC_Soldier_MG_FROG_WDL', ['M240G'], ['7.62mm 100Rnd M240 (White TE4) Box x4']],
    ['CUP_B_USMC_Soldier_AR_FROG_WDL', ['M249 PIP'], ['5.56mm 200Rnd M249 (Red TE4) Box x4']],
    ['CUP_I_RACS_Soldier_HAT_Urban', ['M16A2'], ['30Rnd_556x45 x6', 'Smoke GR x1', 'Dragon Launcher x1']]

]; //--Example: ['rhs_vdv_des_at', ['AK-74M', '9M131'], ['7H10 30 AK-74 x8', 'RGN x1', '9M131 x1']]

WF_C_COMBAT_JETS_WITH_BOMBS = ['CUP_O_SU34_RU','CUP_O_L39_TK','CUP_B_L39_CZ','CUP_B_F35B_BAF','CUP_B_F35B_Stealth_BAF',
    'CUP_B_AV8B_DYN_USMC','CUP_B_A10_DYN_USA','CUP_O_Su25_Dyn_TKA'];

WF_C_BOMBS_TO_DISABLE_AUTOGUIDE = ["CUP_FAB250", "CUP_Mk_82", "CUP_Bo_GBU12_LGB", "CUP_Bo_KAB250_LGB",
    "CUP_PylonPod_1Rnd_GBU12_M","CUP_PylonPod_2Rnd_GBU12_M","CUP_PylonPod_3Rnd_GBU12_M",
	"CUP_Triple_Bomb_Rack_Dummy", "CUP_Dual_Bomb_Rack_Dummy"];

WF_C_ADV_AIR_DEFENCE = [
							["B_SAM_System_02_F", "B_SAM_System_03_F", "O_SAM_System_04_F", "B_Radar_System_01_F", "O_Radar_System_02_F", "CUP_WV_B_CRAM", "CUP_WV_B_CRAM_OPFOR"], //--Weapons--
							[                 10,					0,					 0,						0,					   0,               0,                     0]	//--Reload time--
						];

WF_VEHICLES_WITH_EXTRA_SLOT_ISSUE = [
    // classname                        com,  gun,  not turret seats, turret seats
    ["CUP_B_Jackal2_GMG_GB_W",         [true, true, 0,                  0]],
    ["CUP_B_Jackal2_GMG_GB_D",         [true, true, 0,                  0]],
    ["CUP_B_BAF_Coyote_GMG_W",         [true, true, 0,                  0]],
    ["CUP_B_BAF_Coyote_GMG_D",         [true, true, 0,                  0]],
    ["CUP_B_M1A2_TUSK_MG_US_Army",     [true, true, 0,                  1]],
    ["CUP_B_M1A2_TUSK_MG_DES_US_Army", [true, true, 0,                  1]],
    ["CUP_B_Leopard2A6_GER",           [true, true, 0,                  1]],
    ["CUP_B_Leopard2A6DST_GER",        [true, true, 0,                  1]],
    ["CUP_O_BTR80_TK",                 [false, true, 0,                 0]],
    ["CUP_O_BTR80A_TK",                [false, true, 0,                 0]],
    ["CUP_O_BTR80_GREEN_RU",                [false, true, 0,            0]],
    ["CUP_O_BTR80A_CAMO_RU",                [false, true, 0,            0]],
    ["CUP_O_Ka52_RU",                  [false,true, 0,                  0]]
];

//--Parameters: 1 - pylon num, 2 - ammo class name, 3 - pylot direction, 4 - turret num, 5 - count--
//--ATTENTION: In case when "count" parameter has been set, the first parameter must be a number!--
WF_C_AIR_VEHICLE_TO_REQUIP = [
	['AH-1Z (Multirole)', [[1, "CUP_PylonPod_1Rnd_AIM_9L_Sidewinder_M", true, [0]],
	                            [2, "CUP_PylonPod_19Rnd_Rocket_FFAR_M", false, [1]],
	                            [2, "CUP_PylonPod_19Rnd_Rocket_FFAR_M", false, [1]],
	                            [6, "CUP_PylonPod_1Rnd_AIM_9L_Sidewinder_M", true, [0]]]
	],
	['CUP_B_USMC_DYN_MQ9', 			[	[1,"",true,[]],
										[2,"",true,[]],
										[3,"",true,[]],
										[4,"",true,[]]
									]
	],
	['CUP_O_SU34_RU',			[["pylons1","CUP_PylonPod_1Rnd_R73_Vympel",true,[]],
								["pylons12","CUP_PylonPod_1Rnd_R73_Vympel",true,[]]]
	],
	['CUP_B_AV8B_DYN_USMC',		[["RightWingOut","CUP_PylonPod_1Rnd_AIM_120_AMRAAM_M",true,[]],
								["RightWingMid","CUP_PylonPod_19Rnd_CRV7_HE_plane_M",true,[]],
								["LeftWingOut","CUP_PylonPod_1Rnd_AIM_120_AMRAAM_M",true,[]],
								["LeftWingMid","CUP_PylonPod_19Rnd_CRV7_HE_plane_M",true,[]]]
	],
	['CUP_B_GR9_DYN_GB',		[["Center","CUP_PylonPod_19Rnd_CRV7_HE_plane_M",true,[]]]
	],
	['CUP_B_A10_DYN_USA',		[["RightWingOut","CUP_PylonPod_1Rnd_AIM_120_AMRAAM_M",true,[]],
								["RightWingMiddle","CUP_PylonPod_19Rnd_CRV7_HE_plane_M",true,[]],
								["RightWingInner","CUP_PylonPod_19Rnd_CRV7_HE_plane_M",true,[]],
								["Center","CUP_PylonPod_19Rnd_CRV7_HE_plane_M",true,[]],
								["LeftWingInner","CUP_PylonPod_19Rnd_CRV7_HE_plane_M",true,[]],
								["LefttWingMiddle","CUP_PylonPod_19Rnd_CRV7_HE_plane_M",true,[]],
								["LeftWingOut","CUP_PylonPod_1Rnd_AIM_120_AMRAAM_M",true,[]]]
	],
	['CUP_O_Mi24_V_Dynamic_RU',		[["pylons1","CUP_PylonPod_2Rnd_AT6_M",true,[0]],
									["pylons6","CUP_PylonPod_2Rnd_AT6_M",true,[0]],
									["pylons5","CUP_PylonPod_2Rnd_AT6_M",true,[0]],
									["pylons2","CUP_PylonPod_2Rnd_AT6_M",true,[0]]]
	],
	['CUP_O_Mi24_P_Dynamic_RU',		[["pylons3","CUP_PylonPod_20Rnd_S8N_CCIP_M",true,[]],
									["pylons4","CUP_PylonPod_20Rnd_S8N_CCIP_M",true,[]],
									["pylons6","CUP_PylonPod_2Rnd_AT6_M",true,[0]],
									["pylons1","CUP_PylonPod_2Rnd_AT6_M",true,[0]]]
	]
];

WF_AR2_UAVS = ['O_UAV_01_F', 'B_UAV_01_F', 'I_UAV_01_F'];
WF_FLY_UAVS = ['CUP_O_Pchela1T_RU', 'O_UAV_02_dynamicLoadout_F', 'O_T_UAV_04_CAS_F', 'CUP_B_USMC_DYN_MQ9', 'B_UAV_05_F', 'B_UAV_02_dynamicLoadout_F', 'B_UGV_01_rcws_F', 'O_UGV_01_rcws_F'];

WF_STATIC_ARTILLERY = ['CUP_O_D30_RU', 'CUP_O_2b14_82mm_RU', 'CUP_B_M252_USMC', 'CUP_B_M252_US','CUP_B_M119_US', 'CUP_B_D30_CDF'];
WF_ADV_ARTILLERY = ['CUP_O_BM21_RU','CUP_B_M270_HE_USMC','CUP_B_M270_HE_USA','CUP_B_RM70_CZ'];