Private ['_action_leave','_defaultTeamswitch','_displayEH_keydown','_displayEH_mousebuttondown','_locked','_logic','_mapEH_mousebttondown','_ppColor','_uav'];
_defaultTeamswitch = teamswitchenabled;

startLoadingScreen ["UAV","RscDisplayLoadMission"];

_uav = playerUAV;
//--- UAV destroyed
if (isnull _uav) exitwith {
    endLoadingScreen;
    [format [localize "strwfbasestructuredestroyed",localize "str_uav_action"]] spawn WFCL_fnc_handleMessage
};

//--- Switch view
gunner _uav removeweapon "nvgoggles";
_uav switchcamera "internal";
player remoteControl gunner _uav;

_locked = locked _uav;
_uav lock true;
_uav selectweapon (weapons _uav select 0);
enableteamswitch false;

titletext ["","black in"];
BIS_UAV_TIME = 0;
BIS_UAV_PLANE = _uav;

//--- RSC
progressLoadingScreen 0.5;

//--- Detect pressed keys (temporary solution)
BIS_UAV_HELI_keydown = {
	Private ['_id','_key','_marker','_markertime','_newHeight','_uav','_worldpos'];
	_key = _this select 1;
	_uav = BIS_UAV_PLANE;

	//--- END
	if (_key in (actionkeys 'ingamePause')) then {bis_uav_terminate = true};

	//--- MARKER
	if (_key in (actionkeys 'binocular') && !visiblemap) then {
		_id = 1;
		while {markertype format ['_user_defined_UAV_MARKER_%1',_id] != ''} do {
			_id = _id + 1;
		};
		_worldpos = screentoworld [0.5,0.5];
		_marker = createmarker [format ['_user_defined_UAV_MARKER_%1',_id],_worldpos];
		_marker setmarkertype 'mil_destroy';
		_marker setmarkercolor 'colorred';
		_marker setmarkersize [0.5,0.5];
		_markertime = [daytime] call bis_fnc_timetostring;
		_marker setmarkertext format ['UAV %1: %2',_id,_markertime];
	};

	//--- UP
	if (_key in (actionkeys 'HeliUp')) then {
		_newHeight = (position _uav select 2) + 50;
		if (_newHeight > 1000) then {_newHeight = 1000};
		if (speed _uav < 1) then {_uav domove position _uav;};
		_uav land 'none';
		_uav flyinheight _newHeight;
	};

	//--- DOWN
	if (_key in (actionkeys 'HeliDown')) then {
		_newHeight = (position _uav select 2) - 50;
		if (_newHeight < 100) then {_newHeight = 100};
		_uav land 'none';
		_uav flyinheight _newHeight;
	};
};
_displayEH_keydown = (finddisplay 46) displayaddeventhandler ["keydown","Private['_sqf']; _sqf = _this spawn BIS_UAV_HELI_keydown"];

//--- Detect pressed mouse buttons
_displayEH_mousebuttondown = (finddisplay 46) displayaddeventhandler ["mousebuttondown","
	disableserialization;
	Private ['_button','_control','_controls','_display'];
	_button = _this select 1;
	if (_button == 007 && !visiblemap) then {comment 'DISABLED';
		_display = uinamespace getvariable 'BIS_UAV_DISPLAY';
		_controls = [112401,112402,112403,112404];
		{
			_control = _display displayctrl _x;
			_control ctrlshow !(ctrlshown _control);
			_control ctrlcommit 0;
		} foreach _controls;
	};
"];

_mapEH_mousebttondown = ((findDisplay 12) displayCtrl 51) ctrladdeventhandler ["mousebuttondown", "
	Private ['_button','_uav','_worldpos','_wp'];
	_button = _this select 1;
	if (_button == 0) then {
		_uav = BIS_UAV_PLANE;

		while {count (waypoints _uav) > 0} do {deletewaypoint ((waypoints _uav) select 0)};

		_worldpos = (_this select 0) posscreentoworld [_this select 2,_this select 3];
		_wp = (group _uav) addwaypoint [_worldpos,0];
		_wp setWaypointType 'MOVE';
		(group _uav) setcurrentwaypoint _wp;
	};
"];

//////////////////////////////////////////////////
endLoadingScreen;
//////////////////////////////////////////////////


//--- TERMINATE
waituntil {!isnil "bis_uav_terminate" || !alive _uav || !alive player};
if (!alive _uav) then {
	[format [localize "strwfbasestructuredestroyed",localize "str_uav_action"]] spawn WFCL_fnc_handleMessage;
} else {
	{(driver playerUAV) enableAI _x} forEach ["TARGET","AUTOTARGET"];
};

_uav lock _locked;
titletext ["","black in"];
bis_uav_terminate = nil;
BIS_UAV_TIME = nil;
BIS_UAV_PLANE = nil;
objnull remoteControl gunner _uav;
player switchcamera "internal";
enableteamswitch _defaultTeamswitch;

1124 cuttext ["","plain"];
(finddisplay 46) displayremoveeventhandler ["keydown",_displayEH_keydown];
(finddisplay 46) displayremoveeventhandler ["mousebuttondown",_displayEH_mousebuttondown];
((findDisplay 12) displayCtrl 51) ctrlremoveeventhandler ["mousebuttondown",_mapEH_mousebttondown];