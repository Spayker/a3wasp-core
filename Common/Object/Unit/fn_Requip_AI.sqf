Private ["_gear"];

_gear = [];
switch (typeOf _this) do 
{
		
    case 'CUP_O_MVD_Soldier_MG':{

        removeVest _this;
        _this addVest "CUP_V_RUS_Smersh_2";
        _this addItemToVest "CUP_100Rnd_TE4_LRT4_762x54_PK_Tracer_Green_M";
        _this addItemToVest "CUP_100Rnd_TE4_LRT4_762x54_PK_Tracer_Green_M";

		removeBackpack _this;
        _this addBackpack "CUP_B_RUS_Pack_MG";
    };

    case 'CUP_B_USMC_Soldier_MG_FROG_WDL':{
		
        removeVest _this;
        _this addVest "CUP_V_B_Eagle_SPC_MG";
        _this addItemToVest "CUP_100Rnd_TE4_LRT4_Red_Tracer_762x51_Belt_M";

        removeBackpack _this;
        _this addBackpack "CUP_B_USMC_MOLLE_MG";
        _this addItemToVest "CUP_100Rnd_TE4_LRT4_Red_Tracer_762x51_Belt_M";
        _this addItemToVest "CUP_100Rnd_TE4_LRT4_Red_Tracer_762x51_Belt_M";
	};
		
    case 'CUP_B_USMC_Soldier_AR_FROG_WDL':{

        removeVest _this;
        _this addVest "CUP_V_B_Eagle_SPC_AR";
        _this addItemToVest "CUP_200Rnd_TE4_Red_Tracer_556x45_M249";
        _this addItemToVest "CUP_200Rnd_TE4_Red_Tracer_556x45_M249";

		removeBackpack _this;
        _this addBackpack "CUP_B_USMC_MOLLE_AR";
        _this addItemToVest "CUP_200Rnd_TE4_Red_Tracer_556x45_M249";
        _this addItemToVest "CUP_200Rnd_TE4_Red_Tracer_556x45_M249";
    };

    case "CUP_I_RACS_Soldier_HAT_Urban":{

        removeHeadgear _this;
        removeUniform _this;
        removeVest _this;
		
        _this forceAddUniform "CUP_U_I_GUE_Woodland1";
        _this addItemToUniform "FirstAidKit";
        _this addItemToUniform "SmokeShellRed";
        for "_i" from 1 to 5 do {_this addItemToUniform "CUP_30Rnd_556x45_Stanag"};
		
        _this addVest "CUP_V_B_GER_Tactical_Fleck";
        _this addItemToVest "B_IR_Grenade";
		removeBackpack _this;
		
        _this addBackpack "CUP_B_RPG_Backpack";
        _backpackCargo = backpackContainer _this;
        clearMagazineCargo _backpackCargo;
		
        _this addItemToBackpack "CUP_Dragon_EP1_M";
        _this addGoggles "CUP_G_Bandanna_khk"
	};

};