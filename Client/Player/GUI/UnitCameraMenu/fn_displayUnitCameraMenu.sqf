disableSerialization;

params ["_display"];

WF_MenuAction = -1;
mouseButtonUp = -1;

_cameraModes = ["Internal","External","Gunner","Group"];

_n = 1;
{lbAdd[21002,Format["[%1] %2",_n,name (leader _x)]];_n = _n + 1} forEach WF_Client_Teams;
_id = WF_Client_Teams find WF_Client_Team;
lbSetCurSel[21002,_id];
_currentUnit = (player) Call WFCL_FNC_getUnitVehicle;
_currentUnitMan = objNull;
_currentMode = "Internal";
_currentUnit switchCamera _currentMode;
_casVehicle = objNull;
_casGunner = objNull;
_units = (Units (group player) - [player]) Call WFCO_FNC_GetLiveUnits;
private _track = 0;
{
    lbAdd[21004,Format["(%1) %2 %3",_x Call WFCO_FNC_GetAIDigit,getText (configFile >> "CfgVehicles" >> (typeOf (vehicle _x)) >> "displayName"),name _x]];
    _n = _n + 1;

    //--Check is there WF_A_Tracked variables--
    if(_track == 0) then {
        _track = (vehicle _x) getVariable ["WF_A_Tracked",0];
    };
} forEach _units;

_checkCasVehicle = {

    if !(isNull commanderTeam) then {
        if (commanderTeam == group player) then {
            {
                _group = _x;
                if(side _group == WF_Client_SideJoined) then {

                    _isCasGroup = _group getVariable ['isCasGroup', false];
                    if(_isCasGroup) exitWith {

                        _casVehicle = vehicle (leader _group);
                        _casGunner = gunner _casVehicle;
                        lbAdd[21004,Format["(%1) %2 ",getText (configFile >> "CfgVehicles" >> (typeOf _casVehicle) >> "displayName"),name _casGunner]];
                        _n = _n + 1;

                        //--Check is there WF_A_Tracked variables--
                        if(_track == 0) then {
                            _track = (_casVehicle) getVariable ["WF_A_Tracked",0];
                        };
                    }
                }
            } forEach allGroups
        }
    }
};

[] call _checkCasVehicle;

//--Don't check difficultyEnabled. Use three cam modes every time.--
_type = ["Internal","External","Ironsight"];
{lbAdd[21006,_x]} forEach _type;
lbSetCurSel[21006,0];

_map = _display displayCtrl 21007;
_drawMarkerId = _map ctrlAddEventHandler ["Draw", WF_C_MAP_MARKER_HANDLER];
_map ctrlMapAnimAdd [0,.25,getPos _currentUnit];
ctrlMapAnimCommit _map;

ctrlEnable [160003, false];

if(((WF_Client_SideJoined) call WFCO_FNC_GetSideUpgrades) # WF_UP_REMOTE_CONTROL == 0) then {
    ctrlEnable [160004, false];
};

if(cameraOn == (vehicle player)) then {
    missionNamespace setVariable ["wf_remote_ctrl_unit", nil];

    waitUntil {!isNull (findDisplay 46)};
    (findDisplay 46) displayRemoveEventHandler ["KeyDown", missionNamespace getVariable ["wf_remote_ctrl_displayEH", -1]];
};

while {true} do {
	sleep 0.1;

	_cameraSwap = false;
	if (Side player != WF_Client_SideJoined || !dialog) exitWith {};

	//--- Map click.
	if (mouseButtonUp == 0) then {
		mouseButtonUp = -1;
		_near = _map PosScreenToWorld[mouseX,mouseY];
		_list = _near nearEntities [["Man","Car","Motorcycle","Ship","Tank","Air"],200];
		if (count _list > 0) then {
			_objects = [];
			{if (!(_x isKindOf "Man") && side _x != WF_Client_SideJoined) then {if (count (crew _x) == 0) then {_objects = _objects - [_x]}};if (side _x == WF_Client_SideJoined) then {_objects = _objects + [_x]}} forEach _list;
			if (count _objects > 0) then {
				_currentUnit = ([_near,_objects] Call WFCO_FNC_GetClosestEntity) Call WFCL_FNC_getUnitVehicle;
				_currentUnitMan = [_near,_objects] Call WFCO_FNC_GetClosestEntity;
				_cameraSwap = true;
			};
		};
	};

	//--- Leader Selection.
	if (WF_MenuAction == 101) then {
		WF_MenuAction = -1;
		_selected = leader (WF_Client_Teams select (lbCurSel 21002));
		_currentUnit = (_selected) Call WFCL_FNC_getUnitVehicle;
		_currentUnitMan = _selected;
		_n = 0;
		_units = (Units (group _selected) - [_selected]) Call WFCO_FNC_GetLiveUnits;

		lbClear 21004;
		{
		    lbAdd[21004,Format["(%1) %2 %3",_x Call WFCO_FNC_GetAIDigit, GetText (configFile >> "CfgVehicles" >> (typeOf (vehicle _x)) >> "displayName"),name _x]];
		    _n = _n + 1
		} forEach _units;

		[] call _checkCasVehicle;
		_cameraSwap = true;
	};

	//--- Leader commands AIs.
	if (WF_MenuAction == 102) then {
		WF_MenuAction = -1;
		_currentUnit = (_units # (lbCurSel 21004)) Call WFCL_FNC_getUnitVehicle;
		_currentUnitMan = _units # (lbCurSel 21004);

		if(isNil '_currentUnit') then {
		    _currentUnit = _casVehicle;
		    _currentUnitMan = _casGunner
		};

		_vehicle = vehicle _currentUnit;
		_crew = crew _vehicle;
		{
			if(_x in (units group player)) then {
				ctrlEnable [160003, true];
				}
				else
				{
					ctrlEnable [160003, false];
				};
		} forEach _crew;
		_cameraSwap = true;
	};

	//--- Camera Modes
	if (WF_MenuAction == 103) then {
		WF_MenuAction = -1;
		_currentMode = (_cameraModes select (lbCurSel 21006));
		_cameraSwap = true;
	};

	//--Remote control clicked--
    if (WF_MenuAction == 141 && !(isNil "_currentUnitMan")) then {
    	WF_MenuAction = -1;
    	if(!(isPlayer (_currentUnitMan)) && ((group player == group _currentUnitMan) || ((group _currentUnitMan) getVariable ['isCasGroup', false]))
    	    && !alive (missionNamespace getVariable ["wf_remote_ctrl_unit", objNull])) then {
    	    if(_currentUnitMan getVariable ["wf_remote_ctrl_eh", 0] == 0) then { //--Avoid stacked EH--
    	        _currentUnitMan setVariable ["wf_remote_ctrl_eh", 1];
                _currentUnitMan addEventHandler ["Killed", {
                    params ["_unit"];

                    [_unit] spawn WFCL_FNC_abortRemoteControl;
                }];
            };

            //--Exec remote control--
            missionNamespace setVariable ["wf_remote_ctrl_unit", _currentUnitMan];
            player remoteControl _currentUnitMan;
            ["RemoteControl",[localize "STR_WF_HC_REMOTECONTROL", localize "STR_WF_HC_REMOTECONTROL_PRESSDEL"]] call BIS_fnc_showNotification;

            waitUntil {!isNull (findDisplay 46)};
            _eventId = (findDisplay 46) displayAddEventHandler ["KeyDown",
                {
                    if(_this # 1 == 211) then {
                        _controledUnit = missionNamespace getVariable ["wf_remote_ctrl_unit", objNull];
                        if(!isNull _controledUnit) then {
                            [_controledUnit] spawn WFCL_FNC_abortRemoteControl;
                        };
                    };
                    false
                }];

            missionNamespace setVariable ["wf_remote_ctrl_displayEH", _eventId];
                _map ctrlRemoveEventHandler ["Draw", _drawMarkerId];
            closeDialog 0;
    	};
    };

	//--- Unflip button clicked
	if (WF_MenuAction == 140 && !(isNil "_currentUnit")) then {
		WF_MenuAction = -1;
		if(!(isNil "_currentUnit")) then {
			if(!(isPlayer (_currentUnit))) then {
				_vehicle = vehicle _currentUnit;

				[_vehicle] Call WFCO_FNC_BrokeTerObjsAround;

				_vehicle setPos [getPos _vehicle select 0, getPos _vehicle select 1, 0.5];
				_vehicle setVelocity [0,0,-0.5];
			};
		};
		_cameraSwap = true;
	};

    if(isNil '_currentUnit') then {
        _currentUnit = _casVehicle;
        _currentUnitMan = _casGunner
    };

	if !(alive _currentUnit) then {
		_currentUnit = (player) Call WFCL_FNC_getUnitVehicle;
		_cameraSwap = true;
	};

	//--- Update the Camera.
	if (_cameraSwap) then {
		ctrlMapAnimClear _map;
		_map ctrlMapAnimAdd [1,.25,getPos _currentUnit];
		ctrlMapAnimCommit _map;
		_currentUnit switchCamera _currentMode;
	};
};

_map ctrlRemoveEventHandler ["Draw", _drawMarkerId];
closeDialog 0;

//--If we have some WF_A_Tracked variables, then delete arti markers--
if(_track > 0) then {
    for "_i" from 0 to 2500 do {
        deleteMarkerLocal format ["WF_A_Large%1", _i];
        deleteMarkerLocal format ["WF_A_Small%1", _i];
    };
};

if(WF_C_GAMEPLAY_THIRDVIEW == 0) then {
    _currentMode = "INTERNAL";
};

_controledUnit = missionNamespace getVariable ["wf_remote_ctrl_unit", objNull];
if(alive _controledUnit) then {
    _controledUnit switchCamera _currentMode;
} else {
    ((player) call WFCL_FNC_getUnitVehicle) switchCamera _currentMode;
};