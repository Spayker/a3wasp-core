disableSerialization;

_display = _this # 0;
WF_MenuAction = -1;

_currentVD = viewDistance;
_currentOD = getObjectViewDistance # 0;

if (votePopUp) then {
	ctrlSetText[13019, localize "STR_WF_VOTING_PopUpOffButton"];
} else {
	ctrlSetText[13019, localize "STR_WF_VOTING_PopUpOnButton"];
};

if (hudOn) then {
	ctrlSetText[13020, "HUD OFF"];
} else {
	ctrlSetText[13020, "HUD ON"];
};

ctrlSetText[13021, "HUD STYLE"];
ctrlSetText[13022, format["%1 %2", localize "STR_WF_FACS_ICONS", localize "STR_WF_OFF"]];
ctrlSetText [13101, Format [localize "STR_WF_TEAM_ObjectDistanceLabel",_currentOD]];
ctrlSetText [13002, Format [localize "STR_WF_TEAM_ViewDistanceLabel",_currentVD]];
ctrlSetText [130010, Format [localize "STR_WF_TEAM_ShadowsDistanceLabel",currentSD]];
ctrlSetText [13004, Format [localize "STR_WF_TEAM_TerrainGridLabel",currentTG]];


SliderSetRange[130039, 1, missionNamespace getVariable "WF_C_OBJECT_MAX_VIEW"];
SliderSetRange[13003, 1, missionNamespace getVariable "WF_C_ENVIRONMENT_MAX_VIEW"];
SliderSetRange[130011, 1, 200];
SliderSetRange[13005, 3.125, missionNamespace getVariable "WF_C_ENVIRONMENT_MAX_CLUTTER"];
SliderSetPosition[130039,_currentOD];
SliderSetPosition[13003,_currentVD];
SliderSetPosition[130011,currentSD];
SliderSetPosition[13005,currentTG];
_lastod = _currentOD;
_lastvd = _currentVD;
_lastsd = currentSD;
_lasttg = currentTG;
_need_save = false;

_units = ((units group player) Call WFCO_FNC_GetLiveUnits);
_units = _units - [player];
{
	_desc = [typeOf _x, 'displayName'] Call WFCO_FNC_GetConfigInfo;
	_finalNumber = (_x) Call WFCO_FNC_GetAIDigit;
	_isInVehicle = "";
	if (_x != vehicle _x) then {
		_descVehi = [typeOf (vehicle _x), 'displayName'] Call WFCO_FNC_GetConfigInfo;
		_isInVehicle = " [" + _descVehi + "] ";
	};
	_txt = "["+_finalNumber+"] "+ _desc + _isInVehicle;
	lbAdd[13013,_txt];
} forEach _units;
lbSetCurSel[13013,0];


while {alive player && dialog} do {
	uiSleep 0.05;
	
	if (Side player != WF_Client_SideJoined) exitWith {closeDialog 0};
	if (!dialog) exitWith {};
	
	_currentOD = Floor (SliderPosition 130039);
	_currentVD = Floor (SliderPosition 13003);
	currentSD = Floor (SliderPosition 130011);
	currentTG = SliderPosition 13005;
	
	ctrlSetText [13101, Format [localize "STR_WF_TEAM_ObjectDistanceLabel",_currentOD]];
	ctrlSetText [13002, Format [localize "STR_WF_TEAM_ViewDistanceLabel",_currentVD]];
	ctrlSetText [130010, Format [localize "STR_WF_TEAM_ShadowsDistanceLabel",currentSD]];
	ctrlSetText [13004, Format [localize "STR_WF_TEAM_TerrainGridLabel",currentTG]];
	
	if (WF_MenuAction == 3) then {
		WF_MenuAction = -1;
		_curUnitSel = lbCurSel 13013;
		if (_curUnitSel != -1) then {
			_vehicle = vehicle (_units # _curUnitSel);
			_destroy = [(_units # _curUnitSel)];
			if (_vehicle != (_units # _curUnitSel)) then {_destroy = _destroy + [_vehicle]};
			{
				if !(isPlayer _x) then {
					if (_x isKindOf 'Man') then {removeAllWeapons _x};
					_x setDammage 1;
				};
			} forEach _destroy;
			
			_units = (units group player) Call WFCO_FNC_GetLiveUnits;
			_units = _units - [leader group player];
			lbClear 13013;
			{
				_desc = [typeOf _x, 'displayName'] Call WFCO_FNC_GetConfigInfo;
				_finalNumber = (_x) Call WFCO_FNC_GetAIDigit;
				_isInVehicle = "";
				if (_x != vehicle _x) then {
					_descVehi = [typeOf (vehicle _x), 'displayName'] Call WFCO_FNC_GetConfigInfo;
					_isInVehicle = " [" + _descVehi + "] ";
				};
				_txt = "["+_finalNumber+"] "+ _desc + _isInVehicle;
				lbAdd[13013,_txt];
			} forEach _units;
			lbSetCurSel[13013,0];
		};
	};

	//--- Vote Pop-Up //added-MrNiceGuy
	if (WF_MenuAction == 13) then {
		WF_MenuAction = -1;
		if (votePopUp) then {
			votePopUp = false;
			ctrlSetText[13019, localize "STR_WF_VOTING_PopUpOnButton"];
		} else {
			votePopUp = true;
			ctrlSetText[13019, localize "STR_WF_VOTING_PopUpOffButton"];
		};
	};
	
	//--- HUD ON/OFF
	if (WF_MenuAction == 113) then {
		WF_MenuAction = -1;

		hudOn = !hudOn;

		if (hudOn) then {			
			ctrlSetText[13020, "HUD OFF"];
        } else {
        	ctrlSetText[13020, "HUD ON"];
		};
	};

	//--- HUD STYLE
    if (WF_MenuAction == 114) then {
    	WF_MenuAction = -1;

    	hudStyle = !hudStyle;
	};
	
    //--- FACS ICONS
    if (WF_MenuAction == 115) then {
        WF_MenuAction = -1;

        WF_STRCUCTURES_ICONS = !WF_STRCUCTURES_ICONS;

        if (WF_STRCUCTURES_ICONS) then {
        	ctrlSetText[13022, format["%1 %2", localize "STR_WF_FACS_ICONS", localize "STR_WF_OFF"]];
        } else {
        	ctrlSetText[13022, format["%1 %2", localize "STR_WF_FACS_ICONS", localize "STR_WF_ON"]];
        };
    };
	
	//--- Unit camera
	if (WF_MenuAction == 101) exitWith {
		WF_MenuAction = -1;
		closeDialog 0;
		createDialog "RscMenu_UnitCamera";
	};
	
	//--- Squad menu
    if (WF_MenuAction == 111) exitWith {
        WF_MenuAction = -1;
        closeDialog 0;
        createDialog "RscMenu_Squad";
    };
	
	if (_currentOD != _lastod) then {
		setObjectViewDistance _currentOD;
		setShadowDistance currentSD;
		if !(isNil 'WFCO_FNC_SetProfileVariable') then {['WF_PERSISTENT_CONST_OBJECT_DISTANCE', _currentOD] Call WFCO_FNC_SetProfileVariable; _need_save = true};
	};
	
	if (_currentVD != _lastvd) then {
		setViewDistance _currentVD;
		setShadowDistance currentSD;
		if !(isNil 'WFCO_FNC_SetProfileVariable') then {['WF_PERSISTENT_CONST_VIEW_DISTANCE', _currentVD] Call WFCO_FNC_SetProfileVariable; _need_save = true};
	};

    if (currentSD != _lastsd) then {
        setShadowDistance currentSD;
    	if !(isNil 'WFCO_FNC_SetProfileVariable') then {['WF_PERSISTENT_CONST_SHADOWS_DISTANCE', currentSD] Call WFCO_FNC_SetProfileVariable; _need_save = true};
    };

	if (currentTG != _lasttg) then {
		setTerrainGrid currentTG;
		if !(isNil 'WFCO_FNC_SetProfileVariable') then {['WF_PERSISTENT_TERRAIN_GRID', currentTG] Call WFCO_FNC_SetProfileVariable; _need_save = true};
	};

	_lastod = _currentOD;
	_lastvd = _currentVD;
	_lastsd = currentSD;
	_lasttg = currentTG;
	
	//--- Back Button.
	if (WF_MenuAction == 8) exitWith { //---added-MrNiceGuy
		WF_MenuAction = -1;
		closeDialog 0;
		createDialog "WF_Menu"
	};
};

if (_need_save) then {
	if !(isNil 'WFCO_FNC_SaveProfile') then {Call WFCO_FNC_SaveProfile};
};