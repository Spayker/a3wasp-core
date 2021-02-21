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
        '(time - WF_SK_V_LastUse_LR > WF_SK_V_Reload_LR && isNull objectParent player && WF_VEHICLE_NEAR)'
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
			'(time - WF_SK_V_LastUse_Repair > WF_SK_V_Reload_Repair && isNull objectParent player && WF_VEHICLE_NEAR)'
		];

		_unit addAction ["<t color='#11ec52'>" + localize 'STR_WF_Repair_Camp' + "</t>",{call WFCL_fnc_repairCampEngineer}, [], 97, false, true, '', 'WF_CAMP_NEAR_HIDDEN'];
		_unit addAction ["<t color='#11ec52'>" + localize 'STR_WF_Destroy_Camp' + "</t>",{call WFCL_fnc_destroyCampEngineer}, [], 97, false, true, '', 'WF_CAMP_NEAR && !WF_CAMP_NEAR_HIDDEN'];
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
			"(time - WF_SK_V_LastUse_Lockpick > WF_SK_V_Reload_Lockpick && vehicle player == player && WF_VEHICLE_NEAR)"
		];
		_unit addAction ["<t color='#11ec52'>" + localize 'STR_WF_Hack_Tower' + "</t>",{[[player] call WFCL_FNC_GetNearestRadioTower] remoteExec ["WFSE_FNC_UpdateRadarTower", 2, true]}, [], 97, false, true, '', 'WF_RADIO_TOWER_NEAR'];
		[_unit] call fnc_addFastRepairAction;
	};
	case WF_RECON: {
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
    case WF_ASSAULT: {
        _unit setUnitTrait ["explosiveSpecialist ", true];
		_unit addAction ["<t color='#11ec52'>" + localize 'STR_WF_Repair_Camp' + "</t>",{call WFCL_fnc_repairCampEngineer}, [], 97, false, true, '', 'WF_CAMP_NEAR_HIDDEN'];
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
[
    _unit,					            						    // Object the action is attached to
    "<t color='#11ec52'>" + localize 'STR_WF_Take_Camp' + "</t>",        				// Title of the action
    "\A3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_requestLeadership_ca.paa",	                // Idle icon shown on screen
    "\A3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_requestLeadership_ca.paa",	                // Progress icon shown on screen
    "[vehicle _target] call WFCL_FNC_CheckObjectsAround",               // Condition for the action to be shown
    "WF_CAMP_NEAR",		   	                                        // Condition for the action to progress
    {},													            // Code executed when action starts
    {},													            // Code executed on every progress tick
    {call WFCL_FNC_TakeCamp},		                                // Code executed on completion
    {},													            // Code executed on interrupted
    [],			                                                    // Arguments passed to the scripts as _this select 3
    2,													            // Action duration [s]
    1000,													        // Priority
    false,												            // Remove on completion
    false												            // Show in unconscious state
] call BIS_fnc_holdActionAdd;

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
     '(((typeOf (vehicle _target)) in (missionNamespace getVariable "WF_REPAIRTRUCKS")) && WF_CAMP_NEAR)'
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

