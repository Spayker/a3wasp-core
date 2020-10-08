//-- construction menu
WF_AutoWallConstructingEnabled = false;

//--Required addons list here. Push addon class name from config.bin in array--
WF_REQ_ADDONS = 	[
						["@AdWaspLite", ["wasp_vehicle_fix"]],
						["@CBA_A3", ["cba_xeh", "cba_help"]], 
						["@Enhanced Movement", ["BaBe_core"]],
						["@CUP Units", ["CUP_Creatures_People_Civil_Chernarus", "CUP_Creatures_People_Core"]],
						["@CUP Vehicles", ["CUP_AirVehicles_Core", "CUP_TrackedVehicles_Core"]],
						["@CUP Weapons", ["CUP_BaseData", "CUP_Weapons_AK"]]
				];

WF_C_GARBAGE_OBJECTS = ['Land_HBarrier_large','Land_HBarrier5','Land_GarbageWashingMachine_F','Land_GarbageBags_F',
                        	                            'Land_Garbage_square5_F','Land_BagFence_End_F','Land_Wreck_Skodovka_F','Land_GarbagePallet_F',
                        	                                'Land_Wreck_BMP2_F','Land_HelipadCircle_F', 'Land_HBarrier_1_F', 'Land_HBarrier_5_F', 'Land_HBarrier_3_F',
                        	                                    'Land_fort_bagfence_long','Land_fort_bagfence_round','Land_HBarrier1','Land_HBarrier3',
                        	                                        'Land_BagFence_Long_F','Land_BagFence_Round_F'];

WF_C_STATIC_DEFENCE_FOR_COMPOSITIONS = ['CUP_I_DSHKM_NAPA', 'CUP_I_2b14_82mm_TK_GUE'];

WF_C_UNITS_TO_BALANCE = ['CUP_B_AH1Z_Dynamic_USMC'];

WF_C_INFANTRY_TO_REQUIP = []; //--Example: ['rhs_vdv_des_at', ['AK-74M', '9M131'], ['7H10 30 AK-74 x8', 'RGN x1', '9M131 x1']]

WF_C_COMBAT_JETS_WITH_BOMBS = ['CUP_O_SU34_RU','CUP_O_L39_TK','CUP_B_L39_CZ','CUP_B_F35B_BAF','CUP_B_F35B_Stealth_BAF',
    'CUP_B_AV8B_DYN_USMC','CUP_B_A10_DYN_USA','CUP_O_Su25_Dyn_TKA'];

WF_C_BOMBS_TO_DISABLE_AUTOGUIDE = ["CUP_FAB250", "CUP_Mk_82", "CUP_Bo_GBU12_LGB", "CUP_Bo_KAB250_LGB",
    "CUP_PylonPod_1Rnd_GBU12_M","CUP_PylonPod_2Rnd_GBU12_M","CUP_PylonPod_3Rnd_GBU12_M",
	"CUP_Triple_Bomb_Rack_Dummy", "CUP_Dual_Bomb_Rack_Dummy"];

WF_C_ADV_AIR_DEFENCE = [
							["B_SAM_System_02_F", "B_SAM_System_03_F", "O_SAM_System_04_F", "B_Radar_System_01_F", "O_Radar_System_02_F"], //--Weapons--
							[                 10,					0,					 0,						0,					   0]	//--Reload time--
						];

WF_VEHICLES_WITH_EXTRA_SLOT_ISSUE = [
    // classname                        com,  gun,  not turret seats, turret seats
    ["CUP_B_Jackal2_GMG_GB_W",         [true, true, 0,                  0]],
    ["CUP_B_Jackal2_GMG_GB_D",         [true, true, 0,                  0]],
    ["CUP_B_BAF_Coyote_GMG_W",         [true, true, 0,                  0]],
    ["CUP_B_BAF_Coyote_GMG_D",         [true, true, 0,                  0]],
    ["CUP_B_M1A2_TUSK_MG_US_Army",     [true, true, 0,                  1]],
    ["CUP_B_M1A2_TUSK_MG_DES_US_Army", [true, true, 0,                  1]],
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

WF_STATIC_ARTILLERY = ['CUP_O_D30_RU', 'CUP_O_2b14_82mm_RU', 'CUP_B_M252_USMC', 'CUP_B_M119_US'];
WF_ADV_ARTILLERY = ['CUP_O_BM21_RU','CUP_B_M270_HE_USMC','CUP_B_M270_HE_USA','CUP_B_RM70_CZ'];