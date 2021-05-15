private ["_action","_groups","_sideLetter"];
_action = _this select 0;

switch (_action) do {
	case "onLoad": {
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

			((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180021) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.01), SafeZoneY + (SafeZoneH * 0.80), SafeZoneW * 0.14, SafeZoneH * 0.04]; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180021) ctrlCommit 0; //--- Bring back the button!
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

        diag_log format ['fn_displayUnitCameraMenu.sqf: going to run WFCL_fnc_MouseButtonDownKeyHandler _track: %1', _track];
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

		if (isNil {uiNamespace getVariable "wf_dialog_ui_unitscam_showinfo"}) then {uiNamespace setVariable ["wf_dialog_ui_unitscam_showinfo", false]};
		if (uiNamespace getVariable "wf_dialog_ui_unitscam_showinfo") then {
			((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180015) ctrlSetText "Hide Info";
		} else {
			((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180015) ctrlSetText "Show Info";
			{((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl _x) ctrlShow false} forEach [180016, 180018];
		};

		{((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl _x) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.01), SafeZoneY + (SafezoneH * 0.06), SafeZoneW * 0.31, SafeZoneH * 0.6]; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl _x) ctrlCommit 0} forEach [180016, 180018];
		((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180009) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.8), SafeZoneY + (SafezoneH * 0.62), SafeZoneW * 0.19, SafeZoneH * 0.32]; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180009) ctrlCommit 0;
		((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180010) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.805), SafeZoneY + (SafezoneH * 0.63), SafeZoneW * 0.18, SafeZoneH * 0.30]; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180010) ctrlCommit 0;
		((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180002) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.8), SafeZoneY + (SafezoneH * 0.06), SafeZoneW * 0.19, SafeZoneH * 0.55]; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180002) ctrlCommit 0;
		((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180003) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.805), SafeZoneY + (SafezoneH * 0.0605), SafeZoneW * 0.19, SafeZoneH * 0.03]; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180003) ctrlCommit 0;
		{((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl _x) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.805), SafeZoneY + (SafeZoneH * 0.10), SafeZoneW * 0.18, SafeZoneH * 0.3]; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl _x) ctrlCommit 0} forEach [180004, 180100];
		((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180005) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.805), SafeZoneY + (SafezoneH * 0.41), SafeZoneW * 0.19, SafeZoneH * 0.03]; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180005) ctrlCommit 0;
		{((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl _x) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.805), SafeZoneY + (SafezoneH * 0.45), SafeZoneW * 0.18, SafeZoneH * 0.15]; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl _x) ctrlCommit 0} forEach [180006, 180101];

        _isCommander = false;
        if (!isNull(commanderTeam)) then {if (commanderTeam == group player) then {_isCommander = true}};
		if (_isCommander) then {
			((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180023) ctrlSetPosition [SafeZoneX + (SafeZoneW * 0.01), SafeZoneY + (SafeZoneH * 0.70), SafeZoneW * 0.14, SafeZoneH * 0.04]; ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180023) ctrlCommit 0; //--- Bring back the button!
		};

		if (isNil {uiNamespace getVariable "wf_dialog_ui_unitscam_viewmode"}) then {uiNamespace setVariable ["wf_dialog_ui_unitscam_viewmode", 0]};
		_mode = "Normal";
		switch (uiNamespace getVariable "wf_dialog_ui_unitscam_viewmode") do { case 1: {_mode = "NVG"; camUseNVG true }; };
		((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180013) ctrlSetText _mode;

		//--- Load the AI Members
        _ais = ((Units (Group player)) - [player]) call WFCO_FNC_GetLiveUnits;
        uiNamespace setVariable ["wf_dialog_ui_unitscam_groups_ai", _ais];
        {
            ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180101) lbAdd format["%1", _x];
            if (alive _origin && _x == _origin) then {((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180101) lbSetCurSel _forEachIndex};
        } forEach (_ais);

		[] spawn WFCL_fnc_processUnitsCamera;
	};
	case "onUnitsLBSelChanged": {
		_changeto = _this select 1;

		_group = (uiNamespace getVariable "wf_dialog_ui_unitscam_groups") select _changeto;
		lbClear ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180101);

		_origin = uiNamespace getVariable "wf_dialog_ui_unitscam_origin";
		if (isNil '_origin') then { _origin = objNull };

		//--- Load the AI Members
		_ais = ((Units (Group player)) - [leader _group]) call WFCO_FNC_GetLiveUnits;
		uiNamespace setVariable ["wf_dialog_ui_unitscam_groups_ai", _ais];
		{
			((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180101) lbAdd format["%1", _x];
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
					((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180011) ctrlSetText format["Feed: %1", leader _group];
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
			((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180011) ctrlSetText format["Feed: %1", _ai];
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
	case "onToggleInfo": {
		_changeto = !(uiNamespace getVariable "wf_dialog_ui_unitscam_showinfo");
		uiNamespace setVariable ["wf_dialog_ui_unitscam_showinfo", _changeTo];

		if (_changeto) then {
			((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180015) ctrlSetText "Hide Info";
			{((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl _x) ctrlShow true} forEach [180016, 180018];
		} else {
			((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180015) ctrlSetText "Show Info";
			{((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl _x) ctrlShow false} forEach [180016, 180018];
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
					if (difficultyOption "thirdPersonView" == 1) then {
						WF_UnitsCamera cameraEffect ["TERMINATE", "BACK"];
						vehicle _track switchCamera "EXTERNAL";
						uiNamespace setVariable ["wf_dialog_ui_unitscam_camview", "external"];
					};
				};
			};
		};
	};
	case "onUnitDisband": {
		_who = uiNamespace getVariable "wf_dialog_ui_unitscam_focus";
		if (alive _who) then {
			if !(isPlayer _who) then {
				_who setDammage 1
			};
		};
	};
	case "onRemote": {
		_who = uiNamespace getVariable "wf_dialog_ui_unitscam_focus";
		_dialog = uiNamespace getVariable 'WF_dialog_ui_unitscam';
		if (alive _who ) then {
		    _isCommander = false;
            if (!isNull(commanderTeam)) then {if (commanderTeam == group player) then {_isCommander = true}};
			if ((player == leader _who) || !(isPlayer leader _who) && _isCommander )then {
				_who spawn {
					waitUntil {cameraOn == player};
					sleep 0.5;
					player remoteControl _this;
					_this switchCamera "Internal";
				};
				_dialog closeDisplay 1;
			};
		};
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
				if (_who in units player) then {_unflip = true};
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
	};
};