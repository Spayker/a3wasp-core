/*
	Script: Skill Application System by Benny.
	Description: Skill Application.
*/

Private ["_unit"];

_unit = _this;

fnc_addFastRepairAction = {
    params ["_unit"];

	_unit addAction [
		("<t color='#f8d664'>" + localize "STR_WASP_actions_fastrep" + "</t>"),
		{call WFCL_fnc_processLiteRepairAction},
		[],
		80,
		false,
		true,
		"",
        '_veh = [player] call WFCO_FNC_GetNearestVehicle; (time - WF_SK_V_LastUse_LR > WF_SK_V_Reload_LR && isNull objectParent player && !(isNull _veh))'
	];
};

switch (WF_SK_V_Type) do {
	case WF_ENGINEER: {
		/* Repair Ability */
		_unit setUnitTrait ["explosiveSpecialist ", true];
		_unit addAction [
			("<t color='#f8d664'>" + localize 'STR_WF_ACTION_Repair'+ "</t>"),
			{call WFCL_fnc_processEngineerAction},
			[], 
			80, 
			false, 
			true, 
			"", 
			'_veh = [player] call WFCO_FNC_GetNearestVehicle; (time - WF_SK_V_LastUse_Repair > WF_SK_V_Reload_Repair && isNull objectParent player && !(isNull _veh))'
		];

		_unit addAction ["<t color='#11ec52'>" + localize 'STR_WF_Repair_Camp' + "</t>",{call WFCL_fnc_repairCampEngineer}, [], 97, false, true, '', '_camp = [player] call WFCL_FNC_GetNearestCamp; (!isNull _camp && (isObjectHidden _camp))'];
		_unit addAction ["<t color='#11ec52'>" + localize 'STR_WF_Destroy_Camp' + "</t>",{call WFCL_fnc_destroyCampEngineer}, [], 97, false, true, '', '_camp = [player] call WFCL_FNC_GetNearestCamp; (!isNull _camp && (!isObjectHidden _camp))'];
	};
	case WF_SPECOPS: {
		/* Lockpicking Ability */
		player setUnitTrait ["explosiveSpecialist ", true];
		_unit addAction [
			("<t color='#f8d664'>" + localize 'STR_WF_ACTION_Lockpick'+ "</t>"),
			{call WFCL_fnc_processSpecOpsAction},
			[], 
			80, 
			false, 
			true, 
			"", 
			"_veh = [player] call WFCO_FNC_GetNearestVehicle; (time - WF_SK_V_LastUse_Lockpick > WF_SK_V_Reload_Lockpick && vehicle player == player && !(isNull _veh))"
		];
		[_unit] call fnc_addFastRepairAction;
	};
	case WF_SNIPER: {
	    _unit setUnitTrait ["audibleCoef", true];
	    _unit setUnitTrait ["camouflageCoef", true];
		/* Spotting Ability */
		_unit addAction [
			("<t color='#f8d664'>" + localize 'STR_WF_ACTION_Spot'+ "</t>"),
			{call WFCL_fnc_processSniperAction},
			[], 
			80, 
			false, 
			true, 
			"", 
			"time - WF_SK_V_LastUse_Spot > WF_SK_V_Reload_Spot && (vehicle player == player)"
		];
		[_unit] call fnc_addFastRepairAction;
	};
    case WF_SOLDIER: {
        _unit setUnitTrait ["explosiveSpecialist ", true];
		_unit addAction ["<t color='#11ec52'>" + localize 'STR_WF_Repair_Camp' + "</t>",{call WFCL_fnc_repairCampEngineer}, [], 97, false, true, '', '_camp = [player] call WFCL_FNC_GetNearestCamp; (!isNull _camp && (isObjectHidden _camp))'];
		[_unit] call fnc_addFastRepairAction;
	};
	case WF_MEDIC: {
	    _unit setUnitTrait ["Medic", true];
		[_unit] call fnc_addFastRepairAction;
		_unit addEventHandler ["HandleHeal", {
        	_this spawn {
        		params ["_injured", "_healer"];
        		private _damage = damage _injured;
        		waitUntil {damage _injured != _damage};
        		if (_injured == _healer) then {
        			_healer setDamage 0
        		} else {
        		    _injured setDamage 0
        		}
        	};
        }];
	};
    case WF_SUPPORT: {
        _unit setUnitTrait ["UAVHacker", true];
        _unit setUnitTrait ["explosiveSpecialist ", true];
		[_unit] call fnc_addFastRepairAction;
	};
};

//--- Repair Trucks.
_unit addAction [localize 'STR_WF_BuildMenu_Repair',
                 {call WFCL_fnc_callBuildMenuForRepairTruck},
                 [],
                 1000,
                 false,
                 true,
                 '',
                 format['((typeOf (vehicle _target)) in (missionNamespace getVariable "WF_REPAIRTRUCKS")) && side player == side _target && alive _target && player distance _target <= %1',
                 missionNamespace getVariable 'WF_C_UNITS_REPAIR_TRUCK_RANGE']
];

_unit addAction [localize 'STR_WF_Repair_Camp',
                 {call WFCL_fnc_RepairCamp},
                 [],
                 97,
                 false,
                 true,
                 '',
                 '_camp = [_target] call WFCL_FNC_GetNearestCamp; (((typeOf (vehicle _target)) in (missionNamespace getVariable "WF_REPAIRTRUCKS")) && !isNull _camp && (isObjectHidden _camp))'
];

_unit addAction ["<t color='#FFBD4C'>"+(localize "STR_ACT_LowGearOn")+"</t>",
                 "Client\Module\Valhalla\LowGear_Toggle.sqf",
                 [],
                 91,
                 false,
                 true,
                 "",
                 "((vehicle _target) isKindOf 'Tank' || (vehicle _target) isKindOf 'Car') &&  (player==driver _target) && !Local_HighClimbingModeOn && canMove _target"
];

_unit addAction ["<t color='#FFBD4C'>"+(localize "STR_ACT_LowGearOff")+"</t>",
                 "Client\Module\Valhalla\LowGear_Toggle.sqf",
                 [],
                 91,
                 false,
                 true,
                 "",
                 "((vehicle _target) isKindOf 'Tank' || (vehicle _target) isKindOf 'Car') && (player==driver _target) && Local_HighClimbingModeOn && canMove _target"
];

//--- Boats Push action.
_unit addAction [localize "STR_WF_Push",
                 {call WFCL_fnc_pushVehicle},
                 [], 93, false,
                 true,
                 "",
                 "(vehicle _target) isKindOf 'Ship' && driver _target == _this && alive _target && speed _target < 30"
];

_unit addAction [localize "STR_WF_TaxiReverse",
                 {call WFCL_fnc_taxiReverse},
                 [],
                 92,
                 false,
                 true,
                 "",
                 "(vehicle _target) isKindOf 'Ship' && driver _target == _this && alive _target && speed _target < 4 && speed _target > -4 && getPos _target # 2 < 4"
];

//--- Air units.
//--- HALO action.
_unit addAction ['HALO',
    {call WFCL_fnc_doHalo},
    [],
    97,
    false,
    true,
    '',
    format["(vehicle _target) isKindOf 'Air' && (getNumber (configFile >> 'CfgVehicles' >> typeOf (vehicle _target) >> 'transportSoldier')) > 0 && getPos _target # 2 >= %1 && alive _target", missionNamespace getVariable 'WF_C_PLAYERS_HALO_HEIGHT']
];

//--- Cargo Eject action.
_unit addAction [localize 'STR_WF_Cargo_Eject',
    {call WFCL_fnc_ejectCargo},
    [],
    99,
    false,
    true,
    '',
    "(vehicle _target) isKindOf 'Air' && (getNumber (configFile >> 'CfgVehicles' >> typeOf (vehicle _target) >> 'transportSoldier')) > 0 && driver _target == _this && alive _target"
];

