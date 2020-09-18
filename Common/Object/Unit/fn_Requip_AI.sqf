Private ["_gear"];

_gear = [];
switch (typeOf _this) do 
{
    case "rhs_vdv_flora_at":{
		
		// toDo: adapt gear, inventory according to camo specification		
		_this addPrimaryWeaponItem "rhs_acc_1p63";
		removeBackpack _this;
		_this removeWeapon "rhs_acc_pgo7v3";		

		//comment "Add containers";		
		_this addBackpack "B_Carryall_oli";
		_this addItemToBackpack "Vorona_HEAT";
		_this addItemToBackpack "Vorona_HEAT";
		_this addItemToBackpack "Vorona_HEAT";		
		
		//comment "Add weapons";		
		_this addWeapon "launch_O_Vorona_green_F";
		_this linkItem "Vorona_HEAT";
		_this addItemToBackpack "Vorona_HEAT";
	};
	case "rhs_vdv_des_at":{
		
		// toDo: adapt gear, inventory according to camo specification		
		_this addPrimaryWeaponItem "rhs_acc_1p63";
		removeBackpack _this;
		_this removeWeapon "rhs_acc_pgo7v3";		

		//comment "Add containers";		
		_this addBackpack "B_Carryall_cbr";
		_this addItemToBackpack "Vorona_HEAT";
		_this addItemToBackpack "Vorona_HEAT";
		_this addItemToBackpack "Vorona_HEAT";
		
		//comment "Add weapons";		
		_this addWeapon "launch_O_Vorona_brown_F";
		_this linkItem "Vorona_HEAT";
		_this addItemToBackpack "Vorona_HEAT";
	};
		case "FGN_RuOMON_RiflemanAP_KamyshB":{
		
		// toDo: adapt gear, inventory according to camo specification		
		_this addPrimaryWeaponItem "rhs_acc_1p63";
		removeBackpack _this;
		_this removeWeapon "rhs_acc_pgo7v3";	
		
		//comment "Add containers";		
		_this addBackpack "B_Carryall_cbr";
		_this addItemToBackpack "Vorona_HEAT";
		_this addItemToBackpack "Vorona_HEAT";
		_this addItemToBackpack "Vorona_HEAT";		
		
		//comment "Add weapons";		
		_this addWeapon "launch_O_Vorona_brown_F";
		_this linkItem "Vorona_HEAT";
		_this addItemToBackpack "Vorona_HEAT";
	};
	case "rhs_msv_machinegunner":{
		removeVest _this;
		_this addVest "rhs_6b23_6sh116_od";
		_this addItemToVest "rhs_100Rnd_762x54mmR";
		_this addItemToVest "rhs_100Rnd_762x54mmR";
	};
	case "rhs_msv_arifleman":{
		_this addItemToVest "rhs_100Rnd_762x54mmR";
	};
	case "rhs_vdv_des_machinegunner":{
		removeVest _this;
		_this addVest "rhs_6b23_6sh116";
		_this addItemToVest "rhs_100Rnd_762x54mmR";
		_this addItemToVest "rhs_100Rnd_762x54mmR";
	};
	case "rhs_vdv_mflora_machinegunner":{
		_this addItemToVest "rhs_100Rnd_762x54mmR";
		_this addItemToVest "rhs_100Rnd_762x54mmR";
	};
	case "rhs_vdv_des_arifleman":{
		removeVest _this;
		_this addVest "rhs_6b23_6sh116";
		_this addItemToVest "rhs_100Rnd_762x54mmR";
		_this addItemToVest "rhs_100Rnd_762x54mmR";
	};
	case "rhs_msv_machinegunner_assistant":{
		removeVest _this;
		_this addVest "rhs_6b23_6sh116_od";
		_this addItemToVest "rhs_100Rnd_762x54mmR";
		_this addItemToVest "rhs_100Rnd_762x54mmR";
	};
};