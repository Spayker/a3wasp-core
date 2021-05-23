switch (typeOf _this) do 
{	
	case "CUP_B_MCV80_GB_W";
	case "CUP_B_MCV80_GB_W_SLAT";
	case "CUP_B_MCV80_GB_D";
	case "CUP_B_MCV80_GB_D_SLAT":{ _this disableTIEquipment true };
	
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



