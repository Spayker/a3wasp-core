switch (typeOf _this) do 
{
	case "RHS_M2A2_BUSKI";
	case "RHS_M2A2";
	case "RHS_M2A3";
	case "RHS_M2A3_BUSKI";
	case "RHS_M2A3_BUSKIII";
	case "RHS_M2A2_BUSKI_wd";
	case "RHS_M2A2_wd";
	case "RHS_M2A3_wd";
	case "RHS_M2A3_BUSKI_wd";
	case "RHS_M2A3_BUSKIII_wd": {
		_this removeWeaponTurret ["Rhs_weap_TOW_Launcher",[0]];
		_this removeMagazineTurret ["rhs_mag_2Rnd_TOW2A",[0]];
		_this removeMagazineTurret ["rhs_mag_2Rnd_TOW2A",[0]];
		_this removeMagazineTurret ["rhs_mag_2Rnd_TOW2A",[0]];
		_this removeMagazineTurret ["rhs_mag_2Rnd_TOW2A",[0]];
		_this addMagazineTurret ["rhs_mag_9m133_2",[0]];
		_this addMagazineTurret ["rhs_mag_9m133_2",[0]];
		_this addMagazineTurret ["rhs_mag_9m133_2",[0]];
		_this addMagazineTurret ["rhs_mag_9m133_2",[0]];
		_this addWeaponTurret ["rhs_weap_9k133",[0]];
		_current_heavy_level = ((side player) Call WFCO_FNC_GetSideUpgrades) select WF_UP_HEAVY;
        if(_current_heavy_level < 2)then{
            _this disableTIEquipment true;
        };
	};
	
	case "CUP_B_LAV25_desert_USMC";
	case "CUP_B_LAV25_USMC":{
    	_current_light_level = ((side player) Call WFCO_FNC_GetSideUpgrades) select WF_UP_LIGHT;
        if(_current_light_level < 4)then{
            _this disableTIEquipment true;
    	};
    };
	
	case "rhs_bmd1pk":{
        _current_heavy_level = ((side player) Call WFCO_FNC_GetSideUpgrades) select WF_UP_HEAVY;
        if(_current_heavy_level < 1)then{
            _this removeMagazineTurret ["rhs_mag_pg15v_24",[0]];
            _this removeMagazineTurret ["rhs_mag_pg15v_24",[0]];
            _this removeMagazineTurret ["rhs_mag_pg15v_24",[0]];
            _this removeMagazineTurret ["rhs_mag_pg15v_24",[0]];
        };
    };
	
	case "CUP_O_D30_RU":{
        _this removeMagazineTurret ["CUP_30Rnd_122mmAT_D30_M",[0]];
        _this removeMagazineTurret ["CUP_30Rnd_122mmWP_D30_M",[0]];
        _this removeMagazineTurret ["CUP_30Rnd_122mmLASER_D30_M",[0]];
        _this removeMagazineTurret ["CUP_30Rnd_122mmSMOKE_D30_M",[0]];
        _this removeMagazineTurret ["CUP_30Rnd_122mmILLUM_D30_M",[0]];
        };

    case "CUP_B_M119_US":{
        _this removeMagazineTurret ["CUP_30Rnd_105mmWP_M119_M",[0]];
        _this removeMagazineTurret ["CUP_30Rnd_105mmLASER_M119_M",[0]];
        _this removeMagazineTurret ["CUP_30Rnd_105mmSMOKE_M119_M",[0]];
        _this removeMagazineTurret ["CUP_30Rnd_105mmILLUM_M119_M",[0]];
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
        if(_current_light_level < 4)then{
            _this disableTIEquipment true
    	}
    }
};



