private ["_action","_groups","_sideLetter"];
params ['_action'];

_map = nil;
_drawMarkerId = nil;

switch (_action) do {
	case "onLoad": {

        if (hudOn) then {
            hudOn = !hudOn;
            ctrlSetText[13020, "HUD OFF"];
        };

        _map =  (uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180010;
        _drawMarkerId = _map ctrlAddEventHandler ["Draw", WF_C_MAP_MARKER_HANDLER];

        _groups = [group player];
        _isCommander = false;
        if (!isNull(commanderTeam)) then {if (commanderTeam == group player) then {_isCommander = true}};
        if(_isCommander) then {
		    _groups = _groups + ([WF_Client_SideJoined] call WFCO_FNC_getHighCommandGroups)
        };
		_track = player;
		showCinemaBorder false;

		_pitch = 0;
		_dir = 180;
		_distance = 2.5;
		_pos = [(sin _dir)*(cos _pitch * _distance),(cos _pitch) * (cos _dir * _distance),1.5-(sin _pitch * _distance)];

		WF_UnitsCamera = "camera" camCreate getPosATL _track;
		WF_UnitsCamera camSetTarget _track;
		WF_UnitsCamera camSetRelPos _pos;
		WF_UnitsCamera camCommit 0;

		if (difficultyOption "thirdPersonView" == 1) then {
			uiNamespace setVariable ["wf_dialog_ui_unitscam_camview", "external"];
			WF_UnitsCamera cameraEffect ["EXTERNAL", "BACK"];
			vehicle _track switchCamera "EXTERNAL";

			((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180021) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.56), SafeZoneY + (SafeZoneH * 0.95), SafeZoneW * 0.1, SafeZoneH * 0.04]; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180021) ctrlCommit 0; //--- Bring back the button!
		} else {
			uiNamespace setVariable ["wf_dialog_ui_unitscam_camview", "internal"];
			vehicle _track switchCamera "INTERNAL";
		};

		uiNamespace setVariable ["wf_dialog_ui_unitscam_anchor", nil];
		uiNamespace setVariable ["wf_dialog_ui_unitscam_camview_in", cameraView];
		uiNamespace setVariable ["wf_dialog_ui_unitscam_screenselect", objNull];
		uiNamespace setVariable ["wf_dialog_ui_unitscam_pitch", 0];
		uiNamespace setVariable ["wf_dialog_ui_unitscam_dir", 180];
		uiNamespace setVariable ["wf_dialog_ui_unitscam_focus", _track];

		((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180001) ctrlAddEventHandler ["MouseButtonDown", "nullReturn = _this call WFCL_fnc_MouseButtonDownKeyHandler"];
		((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180001) ctrlAddEventHandler ["MouseButtonUp", "nullReturn = _this call WFCL_fnc_mouseButtonUpKeyHandler"];
		((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180001) ctrlAddEventHandler ["MouseMoving", "nullReturn = _this call WFCL_fnc_MouseMoveKeyHandler"];
		((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180001) ctrlAddEventHandler ["MouseHolding", "nullReturn = _this call WFCL_fnc_MouseMoveKeyHandler"];

		ctrlSetFocus ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180001);

		uiNamespace setVariable ["wf_dialog_ui_unitscam_groups", _groups];
		_origin = uiNamespace getVariable "wf_dialog_ui_unitscam_origin";
		if (isNil '_origin') then { _origin = objNull };
		{
			((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180100) lbAdd format ["%1 (%2)",groupID _x, if (isPlayer leader _x) then {name leader _x} else {"AI"}];
			if (isNull _origin) then {
				if (group _track == _x) then {((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180100) lbSetCurSel _forEachIndex};
			} else {
				if (group _origin == _x) then {if (_origin == leader _x) then {uiNamespace setVariable ["wf_dialog_ui_unitscam_origin", nil]}; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180100) lbSetCurSel _forEachIndex};
			};
		} forEach _groups;

		if (isNil {uiNamespace getVariable "wf_dialog_ui_unitscam_showgroups"}) then {uiNamespace setVariable ["wf_dialog_ui_unitscam_showgroups", true]};
		if (uiNamespace getVariable "wf_dialog_ui_unitscam_showgroups") then {
			((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180007) ctrlSetText "Hide Teams";
		} else {
			((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180007) ctrlSetText "Show Teams";
			{((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl _x) ctrlShow false} forEach [180002, 180003, 180004, 180005, 180006, 180100, 180101];
		};

		if (isNil {uiNamespace getVariable "wf_dialog_ui_unitscam_showmap"}) then {uiNamespace setVariable ["wf_dialog_ui_unitscam_showmap", true]};
		if (uiNamespace getVariable "wf_dialog_ui_unitscam_showmap") then {
			((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180008) ctrlSetText "Hide Map";
		} else {
			((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180008) ctrlSetText "Show Map";
			{((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl _x) ctrlShow false} forEach [180009, 180010];
		};

		((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180009) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.8), SafeZoneY + (SafezoneH * 0.62), SafeZoneW * 0.19, SafeZoneH * 0.32]; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180009) ctrlCommit 0;
		((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180010) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.805), SafeZoneY + (SafezoneH * 0.63), SafeZoneW * 0.18, SafeZoneH * 0.30]; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180010) ctrlCommit 0;

		((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180002) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.011), SafeZoneY + (SafezoneH * 0.06), SafeZoneW * 0.19, SafeZoneH * 0.55]; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180002) ctrlCommit 0;
		((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180003) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.015), SafeZoneY + (SafezoneH * 0.0605), SafeZoneW * 0.19, SafeZoneH * 0.03]; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180003) ctrlCommit 0;
		{((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl _x) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.015), SafeZoneY + (SafeZoneH * 0.10), SafeZoneW * 0.18, SafeZoneH * 0.3]; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl _x) ctrlCommit 0} forEach [180004, 180100];
		((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180005) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.015), SafeZoneY + (SafezoneH * 0.41), SafeZoneW * 0.19, SafeZoneH * 0.03]; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180005) ctrlCommit 0;
		{((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl _x) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.015), SafeZoneY + (SafezoneH * 0.45), SafeZoneW * 0.18, SafeZoneH * 0.15]; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl _x) ctrlCommit 0} forEach [180006, 180101];

        _isCommander = false;
        if (!isNull(commanderTeam)) then {if (commanderTeam == group player) then {_isCommander = true}};
		if (_isCommander) then {
			((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180023) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.23), SafeZoneY + (SafeZoneH * 0.95), SafeZoneW * 0.1, SafeZoneH * 0.04]; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180023) ctrlCommit 0; //--- Bring back the button!
		};

		if (isNil {uiNamespace getVariable "wf_dialog_ui_unitscam_viewmode"}) then {uiNamespace setVariable ["wf_dialog_ui_unitscam_viewmode", 0]};
		_mode = "Normal";
		switch (uiNamespace getVariable "wf_dialog_ui_unitscam_viewmode") do { case 1: {_mode = "NVG"; camUseNVG true }; };
		((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180013) ctrlSetText _mode;
		[] spawn WFCL_fnc_processUnitsCamera;
	};
	case "onGroupsLBSelChanged": {
		_changeto = _this select 1;
        uiNamespace setVariable ["wf_dialog_ui_unitscam_changeTo", _changeto];
		_group = (uiNamespace getVariable "wf_dialog_ui_unitscam_groups") select _changeto;
		lbClear ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180101);

		_origin = uiNamespace getVariable "wf_dialog_ui_unitscam_origin";
		if (isNil '_origin') then { _origin = objNull };

		//--- Load the AI Members
		_ais = (Units _group) call WFCO_FNC_GetLiveUnits;

        if !(isNull commanderTeam) then {
            if (commanderTeam == group player) then {
                {
                    if(side _x == WF_Client_SideJoined) then {
                        _isCasGroup = _x getVariable ['isCasGroup', false];
                        if(_isCasGroup) exitWith {
                            _casVehicle = vehicle (leader _x);
                            _ais =  _ais + [gunner _casVehicle];
                        }
                    }
                } forEach allGroups
            }
        };

		_groupLeader = leader _group;
		if(isPlayer _groupLeader) then { _ais = _ais - [_groupLeader] };

		uiNamespace setVariable ["wf_dialog_ui_unitscam_groups_ai", _ais];
		{
		    _unitInfoArray = missionNamespace getVariable (typeof _x);
		    if(vehicle _x != _x) then {
		        _vehicleInfoArray = missionNamespace getVariable (typeof (vehicle _x));
		        ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180101) lbAdd format["[%1]: %2 - %3", _forEachIndex, (_vehicleInfoArray # QUERYUNITLABEL), (_unitInfoArray # QUERYUNITLABEL)];
		    } else {
		        ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180101) lbAdd format["[%1]: %2", _forEachIndex, (_unitInfoArray # QUERYUNITLABEL)];
		    };

			if (alive _origin && _x == _origin) then {((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180101) lbSetCurSel _forEachIndex};
		} forEach (_ais);

		if !(isNil {uiNamespace getVariable "wf_dialog_ui_unitscam_origin"}) then {
			uiNamespace setVariable ["wf_dialog_ui_unitscam_origin", nil];
		} else {
			if !(isNull (uiNamespace getVariable "wf_dialog_ui_unitscam_screenselect")) then {
				((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180101) lbSetCurSel (_ais find (uiNamespace getVariable "wf_dialog_ui_unitscam_screenselect"));
				uiNamespace setVariable ["wf_dialog_ui_unitscam_screenselect", objNull];
			} else {
				if (alive leader _group) then {
					switch (uiNamespace getVariable "wf_dialog_ui_unitscam_camview") do {
						case "internal": {(vehicle leader _group) switchCamera "INTERNAL"};
						case "ironsight": {(vehicle leader _group) switchCamera "GUNNER"};
						case "external": {(vehicle leader _group) switchCamera "EXTERNAL"}
					};
					uiNamespace setVariable ["wf_dialog_ui_unitscam_focus", leader _group];
				};
			};
		};
	};
	case "onUnitsAILBSelChanged": {
		_changeto = _this select 1;

		_ai = (uiNamespace getVariable "wf_dialog_ui_unitscam_groups_ai") select _changeto;
		if (alive _ai) then {
			uiNamespace setVariable ["wf_dialog_ui_unitscam_focus", _ai];
			switch (uiNamespace getVariable "wf_dialog_ui_unitscam_camview") do {
				case "internal": {vehicle _ai switchCamera "INTERNAL"};
				case "ironsight": {vehicle _ai switchCamera "GUNNER"};
				case "external": {vehicle _ai switchCamera "EXTERNAL"}
			};
		};
	};
	case "onToggleGroup": {
		_changeto = !(uiNamespace getVariable "wf_dialog_ui_unitscam_showgroups");
		uiNamespace setVariable ["wf_dialog_ui_unitscam_showgroups", _changeTo];

		if (_changeto) then {
			((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180007) ctrlSetText "Hide Teams";
			{((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl _x) ctrlShow true} forEach [180002, 180003, 180004, 180005, 180006, 180100, 180101];
		} else {
			((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180007) ctrlSetText "Show Teams";
			{((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl _x) ctrlShow false} forEach [180002, 180003, 180004, 180005, 180006, 180100, 180101];
		};
	};
	case "onToggleMap": {
		_changeto = !(uiNamespace getVariable "wf_dialog_ui_unitscam_showmap");
		uiNamespace setVariable ["wf_dialog_ui_unitscam_showmap", _changeTo];

		if (_changeto) then {
			((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180008) ctrlSetText "Hide Map";
			{((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl _x) ctrlShow true} forEach [180009, 180010];
		} else {
			((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180008) ctrlSetText "Show Map";
			{((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl _x) ctrlShow false} forEach [180009, 180010];
		};
	};
	case "onViewModeChanged": {
		_mode = (uiNamespace getVariable "wf_dialog_ui_unitscam_viewmode") + 1;
		if (_mode > 1) then { _mode = 0 };
		uiNamespace setVariable ["wf_dialog_ui_unitscam_viewmode", _mode];
		switch (_mode) do {
			case 1: {_mode = "NVG"; camUseNVG true};
			default {_mode = "Normal"; camUseNVG false};
		};
		((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180013) ctrlSetText _mode;
	};
	case "onCamChange": {
		_changeto = _this select 1;
		_track = uiNamespace getVariable "wf_dialog_ui_unitscam_focus";

		if !(isNil '_track') then {
			switch (_changeto) do {
				case "ironsight": {
					WF_UnitsCamera cameraEffect["TERMINATE","BACK"];
					vehicle _track switchCamera "GUNNER";
					uiNamespace setVariable ["wf_dialog_ui_unitscam_camview", "ironsight"];
				};
				case "internal": {
					WF_UnitsCamera cameraEffect["TERMINATE","BACK"];
					vehicle _track switchCamera "INTERNAL";
					uiNamespace setVariable ["wf_dialog_ui_unitscam_camview", "internal"];
				};
				case "external": {
						WF_UnitsCamera cameraEffect ["TERMINATE", "BACK"];
						vehicle _track switchCamera "EXTERNAL";
						uiNamespace setVariable ["wf_dialog_ui_unitscam_camview", "external"];
					};
				};
			};
		};
	case "onUnitDisband": {
		_who = uiNamespace getVariable "wf_dialog_ui_unitscam_focus";
		if (alive _who) then {
			if !(isPlayer _who) then {
				_vehicle = vehicle _who;
                _destroy = [_who];
                if (_vehicle != _who) then {_destroy = _destroy + [_vehicle]};
                {
                    if !(isPlayer _x) then {
                        if (_x isKindOf 'Man') then {removeAllWeapons _x};
                        [typeOf _x, false] spawn WFCL_FNC_AwardBounty;
                        deleteVehicle _x;
                    };
                } forEach _destroy;

                _display = uiNamespace getVariable "wf_dialog_ui_unitscam_changeTo";
                if (isNil '_display') then {
                    ['onGroupsLBSelChanged'] call WFCL_fnc_displayUnitCameraMenu
                } else {
                    ['onGroupsLBSelChanged', _display] call WFCL_fnc_displayUnitCameraMenu
                }
			};
		};
	};
	case "onRemote": {
		_who = uiNamespace getVariable "wf_dialog_ui_unitscam_focus";
		_whoGroup = group _who;

		_dialog = uiNamespace getVariable 'WF_dialog_ui_unitscam';
		_hcGroups = [WF_Client_SideJoined] call WFCO_FNC_getHighCommandGroups;

		if(_whoGroup in _hcGroups) then {
            _fromUnit = missionNamespace getVariable ["AIC_Remote_Control_From_Unit",objNull];
            if(isNull _fromUnit || !alive _fromUnit) then {
                _fromUnit = leader WF_Client_Team;
                missionNamespace setVariable ["AIC_Remote_Control_From_Unit",_fromUnit];
            };

            if(!alive _who) exitWith {
                ["RemoteControl",[localize "STR_WF_HC_REMOTECONTROL", localize "STR_WF_HC_REMOTECONTROL_FAILED"]] call BIS_fnc_showNotification;
            };
            _exitingRcUnit = missionNamespace getVariable ["AIC_Remote_Control_To_Unit",objNull];
            if(!isNull _exitingRcUnit) then {
                _exitingRcUnit removeEventHandler ["HandleDamage", (missionNamespace getVariable ["AIC_Remote_Control_To_Unit_Event_Handler",-1])];
                ["MAIN_DISPLAY","KeyDown",(missionNamespace getVariable ["AIC_Remote_Control_Delete_Handler",-1])] call AIC_fnc_removeEventHandler;
            };
            missionNamespace setVariable ["AIC_Remote_Control_To_Unit",_who];
            _groupControlId = missionNamespace getVariable ["AIC_Remote_Control_To_GroupId", nil];
            missionNamespace setVariable ["AIC_Remote_Control_To_GroupId",_groupControlId];

            AIC_Remote_Control_From_Unit_Event_Handler = _fromUnit addEventHandler ["HandleDamage", "if ((_this # 2) > 0.5) then { [] call AIC_fnc_terminateRemoteControl }; _this # 2;"];
            AIC_Remote_Control_To_Unit_Event_Handler = _who addEventHandler ["HandleDamage", "if ((_this # 2) > 0.5) then { [] call AIC_fnc_terminateRemoteControl }; _this # 2;"];
            AIC_Remote_Control_Delete_Handler = ["MAIN_DISPLAY","KeyDown", "if(_this select 1 == 211) then { [] call AIC_fnc_terminateRemoteControl; }"] call AIC_fnc_addEventHandler;

            BIS_fnc_feedback_allowPP = false;

            if ((missionNamespace getVariable "WF_C_GAMEPLAY_FATIGUE_ENABLED") == 1) then {
                _who enableFatigue true;
                _who enableStamina true
            } else {
                _who enableFatigue false;
                _who enableStamina false
            };

            {
                _unit = _x;
                if(alive _unit) then {
                    {_unit disableAI _x} forEach ["MOVE","TEAMSWITCH","AUTOTARGET","TARGET"]
                }
            } forEach (units (group (leader WF_Client_Team)));


            selectPlayer _who;
            (vehicle _who) switchCamera "External";
            openMap false;

            if!(_who getVariable ["ASL_Actions_Loaded",false]) then {
                [_who] call ASL_Add_Player_Actions;
                _who setVariable ["ASL_Actions_Loaded",true];
            };

            _who addAction ["<t color='#7D1401'>" + (localize "STR_WF_Remote_Control_Terminate") + "</t>",{[] call AIC_fnc_terminateRemoteControl}, [], 95, false, true, '', '',10];

            (vehicle _who) addAction [localize "STR_WF_Unlock",{call WFCL_fnc_toggleLock}, [], 95, false, true, '', 'alive _target && (locked _target == 2)',10];
            (vehicle _who) addAction [localize "STR_WF_Lock",{call WFCL_fnc_toggleLock}, [], 94, false, true, '', 'alive _target && (locked _target == 0)',10];

            (vehicle _who) addAction ["<t color='#FFBD4C'>"+(localize "STR_ACT_LowGearOn")+"</t>",
                             "Client\Module\Valhalla\LowGear_Toggle.sqf",
                             [],
                             91,
                             false,
                             true,
                             "",
                             "((vehicle _target) isKindOf 'Tank' || (vehicle _target) isKindOf 'Car') &&  (_this == driver _target) && !Local_HighClimbingModeOn && canMove _target"
            ];

            (vehicle _who) addAction ["<t color='#FFBD4C'>"+(localize "STR_ACT_LowGearOff")+"</t>",
                             "Client\Module\Valhalla\LowGear_Toggle.sqf",
                             [],
                             91,
                             false,
                             true,
                             "",
                             "((vehicle _target) isKindOf 'Tank' || (vehicle _target) isKindOf 'Car') && (_this == driver _target) && Local_HighClimbingModeOn && canMove _target"
            ];

            ["RemoteControl",[localize "STR_WF_HC_REMOTECONTROL",localize "STR_WF_HC_REMOTECONTROL_PRESSDELETE"]] call BIS_fnc_showNotification;
            _dialog closeDisplay 1
		} else {
		if (alive _who ) then {
                if (player != _who && ((player == leader _who) || !(isPlayer leader _who)))then {

				_who spawn {
                        _this setVariable ["wf_remote_ctrl_eh", 1];
                        missionNamespace setVariable ["wf_remote_ctrl_unit", _this];

                        _fromUnit = missionNamespace getVariable ["AIC_Remote_Control_From_Unit",objNull];
                        if(isNull _fromUnit || !alive _fromUnit) then {
                            _fromUnit = leader WF_Client_Team;
                            missionNamespace setVariable ["AIC_Remote_Control_From_Unit",_fromUnit];
                        };

                        if(!alive _this) exitWith {
                            ["RemoteControl",[localize "STR_WF_HC_REMOTECONTROL", localize "STR_WF_HC_REMOTECONTROL_FAILED"]] call BIS_fnc_showNotification;
                        };
                        _exitingRcUnit = missionNamespace getVariable ["AIC_Remote_Control_To_Unit",objNull];
                        if(!isNull _exitingRcUnit) then {
                            _exitingRcUnit removeEventHandler ["HandleDamage", (missionNamespace getVariable ["AIC_Remote_Control_To_Unit_Event_Handler",-1])];
                            ["MAIN_DISPLAY","KeyDown",(missionNamespace getVariable ["AIC_Remote_Control_Delete_Handler",-1])] call AIC_fnc_removeEventHandler;
				};
                        missionNamespace setVariable ["AIC_Remote_Control_To_Unit",_this];
                        _groupControlId = missionNamespace getVariable ["AIC_Remote_Control_To_GroupId", nil];
                        missionNamespace setVariable ["AIC_Remote_Control_To_GroupId",_groupControlId];

                        AIC_Remote_Control_From_Unit_Event_Handler = _fromUnit addEventHandler ["HandleDamage", "if ((_this # 2) > 0.5) then { [] call AIC_fnc_terminateRemoteControl }; _this # 2;"];
                        AIC_Remote_Control_To_Unit_Event_Handler = _this addEventHandler ["HandleDamage", "if ((_this # 2) > 0.5) then { [] call AIC_fnc_terminateRemoteControl }; _this # 2;"];
                        AIC_Remote_Control_Delete_Handler = ["MAIN_DISPLAY","KeyDown", "if(_this select 1 == 211) then { [] call AIC_fnc_terminateRemoteControl; }"] call AIC_fnc_addEventHandler;

                        selectPlayer _this;
                        (vehicle _this) switchCamera cameraView;

                        if!(player getVariable ["ASL_Actions_Loaded",false]) then {
                            [_this] call ASL_Add_Player_Actions;
                            _this setVariable ["ASL_Actions_Loaded", true];
			};

                        _this addAction ["<t color='#7D1401'>" + (localize "STR_WF_Remote_Control_Terminate") + "</t>",{[] call AIC_fnc_terminateRemoteControl}, [], 95, false, true, '', '',10];

                        (vehicle _this) addAction [localize "STR_WF_Unlock",{call WFCL_fnc_toggleLock}, [], 95, false, true, '', 'alive _target && (locked _target == 2)',10];
                        (vehicle _this) addAction [localize "STR_WF_Lock",{call WFCL_fnc_toggleLock}, [], 94, false, true, '', 'alive _target && (locked _target == 0)',10];

                        (vehicle _this) addAction ["<t color='#FFBD4C'>"+(localize "STR_ACT_LowGearOn")+"</t>",
                                         "Client\Module\Valhalla\LowGear_Toggle.sqf",
                                         [],
                                         91,
                                         false,
                                         true,
                                         "",
                                         "((vehicle _target) isKindOf 'Tank' || (vehicle _target) isKindOf 'Car') &&  (_this == driver _target) && !Local_HighClimbingModeOn && canMove _target"
                        ];

                        (vehicle _this) addAction ["<t color='#FFBD4C'>"+(localize "STR_ACT_LowGearOff")+"</t>",
                                         "Client\Module\Valhalla\LowGear_Toggle.sqf",
                                         [],
                                         91,
                                         false,
                                         true,
                                         "",
                                         "((vehicle _target) isKindOf 'Tank' || (vehicle _target) isKindOf 'Car') && (_this == driver _target) && Local_HighClimbingModeOn && canMove _target"
                        ];

                        ["RemoteControl",[localize "STR_WF_HC_REMOTECONTROL", localize "STR_WF_HC_REMOTECONTROL_PRESSDELETE"]] call BIS_fnc_showNotification;
		};
                    _dialog closeDisplay 1
                }
            }
		}
	};
	case "onUnitUnflip": {
		_who = uiNamespace getVariable "wf_dialog_ui_unitscam_focus";
		_who_vehicle = vehicle _who;
		if (alive _who && speed _who_vehicle < 5 && (getPos _who_vehicle select 2) < 5 && !isPlayer _who) then {
			_unflip = false;
			_isCommander = false;
            if (!isNull(commanderTeam)) then {if (commanderTeam == group player) then {_isCommander = true}};
			if (_isCommander) then {
				_unflip = true
			} else {
				if (_who in units player) then {_unflip = true}
			};

			if (_unflip) then {
				_who_vehicle setPos [getPos _who_vehicle select 0, getPos _who_vehicle select 1, 1];
				_who_vehicle setVelocity [0,0,1];
			};
		};
	};
	case "onUnload": {
		WF_UnitsCamera cameraEffect["TERMINATE","BACK"];
		camDestroy WF_UnitsCamera;
		vehicle player switchCamera (uiNamespace getVariable "wf_dialog_ui_unitscam_camview_in");
		showCinemaBorder true;
		hudOn = true;
        shallResetDisplay = true;

        _map ctrlRemoveEventHandler ["Draw", _drawMarkerId];

        ctrlSetText[13020, "HUD ON"]
	};
};