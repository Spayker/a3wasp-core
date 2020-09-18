/*
	Script: Skill Application System by Benny.
	Description: Skill Application.
*/

Private ["_unit"];

_unit = _this;

switch (WF_SK_V_Type) do {
	case WF_ENGINEER: {
		/* Repair Ability */
		_unit addAction [
			("<t color='#f8d664'>" + localize 'STR_WF_ACTION_Repair'+ "</t>"),
			{call WFCL_fnc_processEngineerAction},
			[], 
			80, 
			false, 
			true, 
			"", 
			"time - WF_SK_V_LastUse_Repair > WF_SK_V_Reload_Repair && isNull objectParent player"
		];

		_unit addAction ["<t color='#11ec52'>" + localize 'STR_WF_Repair_Camp' + "</t>",{call WFCL_fnc_repairCampEngineer}, [], 97, false, true, '', '_camp = [player] call WFCL_FNC_GetNearestCamp; (!isNull _camp && (isObjectHidden _camp))'];
		_unit addAction ["<t color='#11ec52'>" + localize 'STR_WF_Destroy_Camp' + "</t>",{call WFCL_fnc_destroyCampEngineer}, [], 97, false, true, '', '_camp = [player] call WFCL_FNC_GetNearestCamp; (!isNull _camp && (!isObjectHidden _camp))'];
	};
	case WF_SPECOPS: {
		/* Lockpicking Ability */
		_unit addAction [
			("<t color='#f8d664'>" + localize 'STR_WF_ACTION_Lockpick'+ "</t>"),
			{call WFCL_fnc_processSpecOpsAction},
			[], 
			80, 
			false, 
			true, 
			"", 
			"(time - WF_SK_V_LastUse_Lockpick > WF_SK_V_Reload_Lockpick && vehicle player == player)"
		];
		[_unit] call fnc_addFastRepairAction;
	};
	case WF_SNIPER: {
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
		_unit addAction [
            ("<t color='#FF0000'>" + localize 'STR_WF_ACTION_Arty_Strike'+ "</t>"),
            {call WFCL_fnc_processArtyStrikeAction},
            [],
            80,
            false,
            true,
            "",
            "time - WF_SK_V_LastUse_ArtyStrike > WF_SK_V_Reload_Arty_Strike && (vehicle player == player)"
		];
		[_unit] call fnc_addFastRepairAction;
	};
    case WF_SOLDIER: {
		_unit addAction ["<t color='#11ec52'>" + localize 'STR_WF_Repair_Camp' + "</t>",{call WFCL_fnc_repairCampEngineer}, [], 97, false, true, '', '_camp = [player] call WFCL_FNC_GetNearestCamp; (!isNull _camp && (isObjectHidden _camp))'];
		[_unit] call fnc_addFastRepairAction;
	};
	case WF_ARTY_OPERATOR: {
		[_unit] call fnc_addFastRepairAction;
	};
    case WF_UAV_OPERATOR: {
		[_unit] call fnc_addFastRepairAction;
	};
};

	/*	_unit addAction [
    (localize "STR_WF_COMMAND_UnflipButton"),
    {call WFCO_fnc_unflipVehicle},
			[], 
			80, 
			false, 
			true, 
			"", 
    "WF_SHOW_FAST_REPAIR_ACTION && (vehicle player == player)"
		]; */

fnc_addFastRepairAction = {
    params ["_unit"];

	_unit addAction [
		(localize "STR_WASP_actions_fastrep"),
		{call WFCL_fnc_processLiteRepairAction},
		[],
		80,
		false,
		true,
		"",
        "time - WF_SK_V_LastUse_LR > WF_SK_V_Reload_LR && isNull objectParent player"
	];
};