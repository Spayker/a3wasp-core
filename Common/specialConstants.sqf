//-- construction menu
WF_AutoWallConstructingEnabled = false;

//--Required addons list here. Push addon class name from config.bin in array--
WF_REQ_ADDONS = 	[
						//["@Enhanced Movement", ["BaBe_core"]]
				];

WF_C_GARBAGE_OBJECTS = [];

WF_C_STATIC_DEFENCE_FOR_COMPOSITIONS = [];

WF_C_UNITS_TO_BALANCE = ['O_Heli_Attack_02_dynamicLoadout_F'];

WF_C_INFANTRY_TO_REQUIP = [
    ['CUP_O_MVD_Soldier_MG', ['PKP'], ['7.62mm 100Rnd PKM (Green TE4) Box x4']],
    ['CUP_B_USMC_Soldier_MG_FROG_WDL', ['M240G'], ['7.62mm 100Rnd M240 (White TE4) Box x4']],
    ['CUP_B_USMC_Soldier_AR_FROG_WDL', ['M249 PIP'], ['5.56mm 200Rnd M249 (Red TE4) Box x4']],
    ['CUP_I_RACS_Soldier_HAT_Urban', ['M16A2'], ['30Rnd_556x45 x6', 'Smoke GR x1', 'Dragon Launcher x1']]

]; //--Example: ['rhs_vdv_des_at', ['AK-74M', '9M131'], ['7H10 30 AK-74 x8', 'RGN x1', '9M131 x1']]

WF_C_COMBAT_JETS_WITH_BOMBS = [];

WF_C_BOMBS_TO_DISABLE_AUTOGUIDE = [];

WF_C_ADV_AIR_DEFENCE = [
							["B_SAM_System_02_F", "B_SAM_System_03_F", "O_SAM_System_04_F", "B_Radar_System_01_F", "O_Radar_System_02_F"], //--Weapons--
							[                 10,				    0,					 0,				        0,					   0]	//--Reload time--
						];

WF_VEHICLES_WITH_EXTRA_SLOT_ISSUE = [];

//--Parameters: 1 - pylon num, 2 - ammo class name, 3 - pylot direction, 4 - turret num, 5 - count--
//--ATTENTION: In case when "count" parameter has been set, the first parameter must be a number!--
WF_C_AIR_VEHICLE_TO_REQUIP = [
	/* ['AH-1Z (Multirole)', [[1, "CUP_PylonPod_1Rnd_AIM_9L_Sidewinder_M", true, [0]],
	                            [2, "CUP_PylonPod_19Rnd_Rocket_FFAR_M", false, [1]],
	                            [3, "rhs_mag_AGM114L_4", true, [0], 4],
	                            [4, "rhs_mag_AGM114L_4", true, [0], 4],
	                            [2, "CUP_PylonPod_19Rnd_Rocket_FFAR_M", false, [1]],
	                            [6, "CUP_PylonPod_1Rnd_AIM_9L_Sidewinder_M", true, [0]]]
	], */
];

WF_AR2_UAVS = ['O_UAV_01_F', 'B_UAV_01_F', 'I_UAV_01_F'];
WF_FLY_UAVS = ['O_UAV_02_dynamicLoadout_F', 'O_T_UAV_04_CAS_F', 'B_UAV_05_F', 'B_UAV_02_dynamicLoadout_F'];

WF_STATIC_ARTILLERY = [];
WF_ADV_ARTILLERY = [];

WF_NightVisionDevices = [ 'O_NVGoggles_ghex_F', 'O_NVGoggles_hex_F'];