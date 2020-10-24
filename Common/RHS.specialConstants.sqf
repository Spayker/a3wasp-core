//-- construction menu
WF_AutoWallConstructingEnabled = false;

//--Required addons list here. Push addon class name from config.bin in array--
WF_REQ_ADDONS = 	[	//["@Bornholm", ["Bornholm"]], 
						//["@AdWasp", ["wasp_vehicle_fix"]],
						["@CBA_A3", ["cba_xeh", "cba_help"]], 
						["@Enhanced Movement", ["BaBe_core"]], 
						//["@Napf Island V1.2", ["Napf"]], 
						//["@Tembelan Island", ["A3_Map_Tembelan"]],
						//["@Caucasus Insurgency", ["FGN_RU_Gear"]],
						//["@Chernarus winter With fixed footsteps", ["Chernarus_winter"]],
						["@CUP Terrains - Core", ["CUP_Core", "CUP_Terrains_Plants"]],
						["@CUP Terrains - Maps", ["CUP_Takistan_Data", "CUP_Bohemia_Data", "CUP_Chernarus_Data"]],
						//["@Fallujah V1.2", ["fallujah_v1_0"]],
						["@RHSAFRF", ["rhs_btr70", "rhs_c_t72"]],
						["@RHSGREF", ["rhsgref_c_air"]],
						["@RHSSAF", ["rhssaf_m_weapon_m70c", "rhssaf_main"]],
						["@RHSUSAF", ["rhsusf_cars", "rhsusf_c_mtvr"]],
						["@CUP Units", ["CUP_Creatures_People_Civil_Chernarus", "CUP_Creatures_People_Core"]],
						["@CUP Vehicles", ["CUP_AirVehicles_Core", "CUP_TrackedVehicles_Core"]],
						["@CUP Weapons", ["CUP_BaseData", "CUP_Weapons_AK"]]
				];

WF_C_GARBAGE_OBJECTS = ['Land_HBarrier_large','Land_HBarrier5','Land_GarbageWashingMachine_F','Land_GarbageBags_F',
                        'Land_Garbage_square5_F','Land_BagFence_End_F','Land_Wreck_Skodovka_F','Land_GarbagePallet_F',
                        'Land_Wreck_BMP2_F','Land_HelipadCircle_F', 'Land_HBarrier_1_F', 'Land_HBarrier_5_F',
                        'Land_HBarrier_3_F', 'Land_fort_bagfence_long','Land_fort_bagfence_round','Land_HBarrier1',
                        'Land_HBarrier3', 'Land_BagFence_Long_F','Land_BagFence_Round_F'];

WF_C_STATIC_DEFENCE_FOR_COMPOSITIONS = ['rhsgref_nat_DSHKM','CUP_I_2b14_82mm_TK_GUE'];

WF_C_UNITS_TO_BALANCE = ['RHS_AH64D', 'RHS_AH64D_AA', 'RHS_AH64D_CS', 'RHS_Ka52_UPK23_vvsc', 'RHS_Ka52_vvsc',
'CUP_B_AH1Z_Dynamic_USMC', 'RHS_M6','RHS_M6_wd','RHS_M2A2','RHS_M2A2_BUSKI','RHS_M2A3','RHS_M2A3_BUSKI',
'RHS_M2A3_BUSKIII','RHS_M2A2_wd','RHS_M2A2_BUSKI_wd','RHS_M2A3_wd','RHS_M2A3_BUSKI_wd','RHS_M2A3_BUSKIII_wd'];

WF_C_INFANTRY_TO_REQUIP = [['rhs_vdv_flora_at', ['AK-74M', 'Launch VORONA green'], ['7H10 30 AK-74 x8', 'RGN x1', 'Vorona_HEAT x1']],
    ['rhs_vdv_des_at', ['AK-74M', 'Launch VORONA brown'], ['7H10 30 AK-74 x8', 'RGN x1', 'Vorona_HEAT x1']],
    ['FGN_RuOMON_RiflemanAP_KamyshB', ['AK-74M', 'Launch VORONA brown'], ['7H10 30 AK-74 x8', 'RGN x1', 'Vorona_HEAT x1']],
	['rhs_vdv_flora_machinegunner', [], []],
	['rhs_vdv_machinegunner', [], []],
	['rhs_msv_machinegunner', [], []],
	['rhs_msv_arifleman', [], []],
	['rhs_vdv_des_machinegunner', [], []],
	['rhs_vdv_mflora_machinegunner', [], []],
	['rhs_vdv_des_arifleman', [], []],
	['rhs_msv_machinegunner_assistant', [], []]];

WF_C_COMBAT_JETS_WITH_BOMBS = ['rhs_mig29s_vmf','RHS_T50_vvs_generic_ext','rhsusf_f22','CUP_O_SU34_RU',
	'CUP_O_L39_TK','CUP_B_L39_CZ','CUP_B_F35B_BAF','CUP_B_F35B_Stealth_BAF','CUP_B_AV8B_DYN_USMC',
	'CUP_B_A10_DYN_USA','CUP_O_Su25_Dyn_TKA','JS_JC_FA18E','JS_JC_FA18F'];

WF_C_BOMBS_TO_DISABLE_AUTOGUIDE = ["CUP_FAB250","CUP_Mk_82","CUP_Bo_GBU12_LGB","CUP_Bo_KAB250_LGB","CUP_Triple_Bomb_Rack_Dummy",
	"CUP_PylonPod_1Rnd_GBU12_M","CUP_PylonPod_2Rnd_GBU12_M","CUP_PylonPod_3Rnd_GBU12_M","CUP_Dual_Bomb_Rack_Dummy"];

WF_C_ADV_AIR_DEFENCE = [
							["B_SAM_System_02_F", "B_SAM_System_03_F", "O_SAM_System_04_F", "B_Radar_System_01_F", "O_Radar_System_02_F"], //--Weapons--
							[ 				  10,					0,					 0,					    0,					   0]	//--Reload time--
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
	                            [3, "rhs_mag_AGM114L_4", true, [0], 4],
	                            [4, "rhs_mag_AGM114L_4", true, [0], 4],
	                            [2, "CUP_PylonPod_19Rnd_Rocket_FFAR_M", false, [1]],
	                            [6, "CUP_PylonPod_1Rnd_AIM_9L_Sidewinder_M", true, [0]]]
	],
	['CUP_B_USMC_DYN_MQ9', 			[	[1,"",true,[]],
										[2,"",true,[]],
										[3,"",true,[]],
										[4,"",true,[]]
									]
	],
	['RHS_AH64D_CS', 			[["pylon2","rhs_mag_AGM114L_4",true,[0]],
								["pylon5","rhs_mag_AGM114L_4",true,[0]]]
	],
	['RHS_AH64D_AA', 			[["pylon4","rhs_mag_AGM114L_4",true,[0]]]],
	['RHS_AH64D', 			[["pylon4","rhs_mag_AGM114L_4",true,[0]],
							 ["pylonTip1","CUP_PylonPod_1Rnd_AIM_120_AMRAAM_M",true,[0]],
							 ["pylonTip6","CUP_PylonPod_1Rnd_AIM_120_AMRAAM_M",true,[0]]
							]
	],
	['CUP_O_SU34_RU',			[["pylons1","CUP_PylonPod_1Rnd_R73_Vympel",true,[]],
								["pylons12","CUP_PylonPod_1Rnd_R73_Vympel",true,[]]]
	],
	['rhs_mig29sm_vmf',			[["pylon1","rhs_mag_R73M_APU73",true,[]],
								["pylon2","rhs_mag_R73M_APU73",true,[]],
								["pylon7","rhs_mag_ptb1500",true,[]]]
	],
	['rhs_mig29sm_vvsc',			[["pylon1","rhs_mag_R73M_APU73",true,[]],
								["pylon2","rhs_mag_R73M_APU73",true,[]],
								["pylon7","rhs_mag_ptb1500",true,[]]]
	],
	['RHS_T50_vvs_generic_ext',	[["pylons1","rhs_mag_R74M2_int",true,[]],
								["pylons2","rhs_mag_R74M2_int",true,[]],
								["pylons3","rhs_mag_R74M2_int",true,[]],
								["pylons4","rhs_mag_R74M2_int",true,[]]]
	],
	['FIR_F35B_Standard',		[["pylons1","FIR_AIM120_P_1rnd_M",true,[]],
								["pylons2","FIR_AIM120_P_1rnd_M",true,[]],
								["pylons3","FIR_AIM9X_P_1rnd_M",true,[]],
								["pylons4","FIR_AIM9X_P_1rnd_M",true,[]],
								["pylons5","FIR_AIM9X_P_1rnd_M",true,[]],
								["pylons6","FIR_AGM65H_P_3rnd_M",true,[]],
								["pylons7","FIR_Mk82_GP_P_3rnd_M",true,[]],
								["pylons8","FIR_Mk82_GP_P_3rnd_M",true,[]],
								["pylons9","FIR_AGM65H_P_3rnd_M",true,[]],
								["pylons10","FIR_AIM9X_P_1rnd_M",true,[]],
								["pylons11","FIR_Gunpod_Nomodel_P_1rnd_M",true,[]]]
	],
	['FIR_F15SE_LA',			[["Pylons1","FIR_Empty_P_1rnd_M",true,[0]],
								["pylons2","FIR_Empty_P_1rnd_M",true,[0]],
								["pylons3","FIR_Empty_P_1rnd_M",true,[0]],
								["pylons4","FIR_Empty_P_1rnd_M",true,[0]],
								["pylons5","FIR_AIM9X_P_1rnd_M",true,[0]],
								["pylons6","FIR_AIM9X_P_1rnd_M",true,[0]],
								["pylons7","FIR_AIM120_P_1rnd_M",true,[0]],
								["pylons8","FIR_AIM120_P_1rnd_M",true,[0]],
								["pylons9","FIR_Mk82_GP_P_1rnd_M",true,[0]],
								["pylons11","FIR_Mk82_GP_P_1rnd_M",true,[0]],
								["pylons12","FIR_Mk82_GP_P_1rnd_M",true,[0]],
								["pylons14","FIR_Mk82_GP_P_1rnd_M",true,[0]],
								["pylons15","FIR_Mk82_GP_P_1rnd_M",true,[0]],
								["pylons16","FIR_Mk82_GP_P_1rnd_M",true,[0]],
								["pylons17","FIR_Mk82_GP_P_1rnd_M",true,[0]],
								["pylons23","FIR_Mk82_GP_P_1rnd_M",true,[0]],
								["pylons26","FIR_F15SE_CWB_P_1rnd_M",true,[0]]]
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
	['RHS_MELB_AH6M',		[["pylon4","rhs_mag_M229_7",true,[]],
							["pylon1","rhs_mag_M229_7",true,[]],
							["pylon2","",true,[]],
							["pylon3","",true,[]]]
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

WF_STATIC_ARTILLERY = ['RHS_M119_WD','CUP_B_M252_USMC','rhs_D30_vdv','rhs_2b14_82mm_msv'];
WF_ADV_ARTILLERY = ['I_Truck_02_MRL_F','rhs_2s3_tv','rhsusf_m109d_usarmy','rhsusf_m109_usarmy',
'rhs_9k79','CUP_O_BM21_RU','CUP_B_M270_HE_USMC','CUP_B_M270_HE_USA','CUP_B_RM70_CZ','I_Truck_02_MRL_F_OPFOR'];

WF_AR2_UAVS = ['O_UAV_01_F', 'B_UAV_01_F', 'I_UAV_01_F'];
WF_FLY_UAVS = ['CUP_O_Pchela1T_RU', 'O_UAV_02_dynamicLoadout_F', 'O_T_UAV_04_CAS_F', 'CUP_B_USMC_DYN_MQ9', 'B_UAV_05_F', 'B_UAV_02_dynamicLoadout_F'];

profileNameSpace setVariable ["rhs_voiceAnnouncer", 0];