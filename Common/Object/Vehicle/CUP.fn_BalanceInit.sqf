switch (typeOf _this) do 
{	

	case "CUP_B_D30_CDF";
	case "CUP_O_D30_RU":{
        _this removeMagazineTurret ["CUP_30Rnd_122mmAT_D30_M",[0]];
        _this removeMagazineTurret ["CUP_30Rnd_122mmWP_D30_M",[0]];
        _this removeMagazineTurret ["CUP_30Rnd_122mmLASER_D30_M",[0]];
        _this removeMagazineTurret ["CUP_30Rnd_122mmSMOKE_D30_M",[0]];
        _this removeMagazineTurret ["CUP_30Rnd_122mmILLUM_D30_M",[0]];
    };

    case "CUP_B_M252_USMC";
    case "CUP_O_2b14_82mm_RU":{
        _this removeMagazineTurret ["8Rnd_82mm_Mo_Flare_white",[0]];
        _this removeMagazineTurret ["8Rnd_82mm_Mo_Smoke_white",[0]];
        _this removeMagazineTurret ["8Rnd_82mm_Mo_guided",[0]];
        _this removeMagazineTurret ["8Rnd_82mm_Mo_LG",[0]];
	};
	
	
	case "CUP_B_MCV80_GB_W";
	case "CUP_B_MCV80_GB_W_SLAT";
	case "CUP_B_MCV80_GB_D";
	case "CUP_B_MCV80_GB_D_SLAT";
	case "CUP_B_M7Bradley_USA_W";
	case "CUP_B_M2Bradley_USA_W";
	case "CUP_B_M7Bradley_USA_D";
	case "CUP_B_M2Bradley_USA_D":{ _this disableTIEquipment true };

	case "CUP_B_LAV25M240_USMC";
	case "CUP_B_LAV25M240_desert_USMC";
	case "CUP_B_LAV25_desert_USMC";
	case "CUP_B_LAV25_USMC":{
    	_current_light_level = ((side player) Call WFCO_FNC_GetSideUpgrades) select WF_UP_LIGHT;
        if(_current_light_level < 3) then { _this disableTIEquipment true }
    };
	
    case "CUP_B_AC47_Spooky_USA";
	case "CUP_O_MI6T_RU";
    case "CUP_O_MI6A_RU";
	case "CUP_O_L39_TK";
    case "CUP_B_L39_CZ_GREY";
    case "CUP_I_L39_AAF":{
        _this addWeapon "CMFlareLauncher";
        _this addmagazine "120Rnd_CMFlare_Chaff_Magazine";
    }
	
};



