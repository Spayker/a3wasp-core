#include "..\..\functions.h"

/*
	Author: [SA] Duda

	Description:
	Command Control Manager

	Parameter(s):
	None
		
	Returns: 
	Nothing
*/

["ALL_EAST"] call AIC_fnc_createCommandControl;
["ALL_WEST"] call AIC_fnc_createCommandControl;
["ALL_GUER"] call AIC_fnc_createCommandControl;

if(hasInterface) then {
		
	AIC_fnc_commandControlDrawHandler = {
		private ["_commandControls","_inputControls","_actionControlShown"];
		
		_commandControls = AIC_fnc_getCommandControls();
		_inputControls = AIC_fnc_getInputControls();

		if(!isNull(commanderTeam)) then {
            if (commanderTeam == group player) then {
                // Draw all visible input controls
                {
                    if(AIC_fnc_getMapElementVisible(_x)) then {
                        [_x] call AIC_fnc_drawInputControl;
                    };
                } forEach _inputControls;

                // Draw command controls
                {
                    // Move all command controls to the background if an action control is visible
                    [_x] call AIC_fnc_drawCommandControl;
                } forEach _commandControls;
            }
        }
	};

	// Setup UI event handlers

	["MAP_CONTROL","Draw", "_this call AIC_fnc_commandControlDrawHandler"] spawn AIC_fnc_addManagedEventHandler;
	
	// Check for command control group controls revision changes
	[] spawn {
		private ["_commandControls","_groupsRevision","_currentRevision"];
		while {true} do {
			_commandControls = AIC_fnc_getCommandControls();
			{
				_groupsRevision = AIC_fnc_getCommandControlGroupsRevision(_x);
				_currentRevision = AIC_fnc_getCommandControlGroupsControlsRevision(_x);
				if(_groupsRevision != _currentRevision) then {
					[_x,"REFRESH_GROUP_CONTROLS",[]] call AIC_fnc_commandControlEventHandler;
				};
			} forEach _commandControls;
			sleep 2;
		};
	};
	
};

if(!hasInterface && !isDedicated) then {
	[] spawn {
		while {true} do {
			{
                if !(isPlayer(leader _x))then {
                    _side = side _x;
                    _isPurchased = _x getVariable["isHighCommandPurchased",false];
                    if(_isPurchased) then {
                        if(_side == east) then {
                            ["ALL_EAST",_x] call AIC_fnc_commandControlAddGroup
                        };
                        if(_side == west) then {
                            ["ALL_WEST",_x] call AIC_fnc_commandControlAddGroup
                        };
                        if(_side == resistance) then {
                            ["ALL_GUER",_x] call AIC_fnc_commandControlAddGroup
                        };
                    }
                }
			} forEach allGroups;
			sleep 5;
		};
	};

	// Check for empty groups associated with command controls and remove them
	[] spawn {
		private ["_commandControls","_commandControlId","_groups","_groupControls","_group","_units"];
		while {true} do {
			_commandControls = AIC_fnc_getCommandControls();
			{
				_commandControlId = _x;
				_groups = AIC_fnc_getCommandControlGroups(_commandControlId);
				{
					_group = _x;
					_units = [];
					{if (alive _x) then {_units pushBack _x}} foreach (units _group);
					if(count _units == 0) then {
						[_commandControlId, _group] call AIC_fnc_commandControlRemoveGroup
					}
				} forEach _groups;
			} forEach _commandControls;
			sleep 10;
		};
	};
	
	// Manage group waypoints
	[] spawn {
		while {true} do {
			private ["_group","_groupControl","_lastWpRevision","_groupWaypoints","_groupControlWaypoints","_currentWpRevision","_groupControlWaypointArray","_wp","_goCodeWpFound","_wpType","_waitForCode","_wpActionScript","_wpCondition","_wpTimeout"];
			{
				_group = _x;
				if (side _group != civilian && (_group getVariable["isHighCommandPurchased",false]) ) then {
				_lastWpRevision = _group getVariable ["AIC_Server_Last_Wp_Revision",0];
				_groupWaypoints = waypoints _group;
				_groupControlWaypoints = [_group] call AIC_fnc_getAllActiveWaypoints;
				_currentWpRevision = _groupControlWaypoints select 0;
				_groupControlWaypointArray = _groupControlWaypoints select 1;
				if( _currentWpRevision != _lastWpRevision) then {
					while {(count (waypoints _group)) > 0} do { 
						deleteWaypoint ((waypoints _group) select 0); 
					};
					private ["_priorWaypointDurationEnabled"];
					_priorWaypointDurationEnabled = false;
					{		
						if(!_priorWaypointDurationEnabled) then {
							_x params ["_wpIndex","_wpPosition","_wpDisabled",["_wpType","MOVE"],["_wpActionScript",""],["_wpCondition","true"],"_wpTimeout","_wpFormation","_wpCompletionRadius",["_wpDuration",0],"_wpLoiterRadius","_wpLoiterDirection"];
							if(_wpDuration > 0) then {
								_priorWaypointDurationEnabled = true;
							};
							_wp = _group addWaypoint [_x select 1, 0];
                                _groupLeader = leader _group;
                                if (_wpCondition == "true") then {
                                        _wp setWaypointStatements ["true", "[group this, "+str (_x select 0)+"] call AIC_fnc_disableWaypoint;" + _wpActionScript];
                                    } else {
							_wp setWaypointStatements [format ["true && ((group this) getVariable ['AIC_WP_DURATION_REMANING',0]) <= 0 && {%1}",_wpCondition], "[group this, "+str (_x select 0)+"] call AIC_fnc_disableWaypoint;" + _wpActionScript];
							};

							_wp setWaypointType _wpType;
							if(!isNil "_wpTimeout") then {
								_wp setWaypointTimeOut [_wpTimeout,_wpTimeout,_wpTimeout];
							}; 
							if(!isNil "_wpFormation") then {
								_wp setWaypointFormation _wpFormation;
							};
							if(!isNil "_wpCompletionRadius") then {
								_wp setWaypointCompletionRadius _wpCompletionRadius;
							};  
							if(!isNil "_wpLoiterRadius") then {
								_wp setWaypointLoiterRadius _wpLoiterRadius;
							};  
							if(!isNil "_wpLoiterDirection") then {
								_wp setWaypointLoiterType _wpLoiterDirection;
							};  
						};
					} forEach _groupControlWaypointArray;
					if(count (waypoints _group)==0) then {
						_group addWaypoint [position leader _group, 0];
					};
					_group setVariable ["AIC_Server_Last_Wp_Revision",_currentWpRevision];
				};
				
				private ["_nextActiveWaypoint"];
				if( count _groupControlWaypointArray > 0 ) then {
					_nextActiveWaypoint = _groupControlWaypointArray select 0;
					_nextActiveWaypoint params ["_wpIndex","_wpPosition","_wpDisabled",["_wpType","MOVE"],["_wpActionScript",""],["_wpCondition","true"],"_wpTimeout","_wpFormation","_wpCompletionRadius",["_wpDuration",0],"_wpLoiterRadius","_wpLoiterDirection"];
					if(_wpDuration > 0 && _group getVariable ["AIC_WP_DURATION_REMANING",0] <= 0) then {
						_group setVariable ["AIC_WP_DURATION_REMANING",_wpDuration];
					};
					if(_wpDuration <= 0 && _group getVariable ["AIC_WP_DURATION_REMANING",0] > 0) then {
						_group setVariable ["AIC_WP_DURATION_REMANING",0,true];
					};
					_group setVariable ["AIC_WP_DURATION_REMANING",(_group getVariable ["AIC_WP_DURATION_REMANING",0]) - 2,true];
					if(_wpDuration > 0 && _group getVariable ["AIC_WP_DURATION_REMANING",0] <= 0) then {
						_nextActiveWaypoint set [9,0];
						[_group, _nextActiveWaypoint] call AIC_fnc_setWaypoint;
					};
				};

                    {
                        _crewVehicle = vehicle _x;
                        if(_crewVehicle != _x) then {
                            if ((speed _crewVehicle)  == 0 && canMove _crewVehicle) then {
                            if (_x == driver _crewVehicle) then {
                                    if(vehicle (leader _group) != leader _group) then {
                                        _x doWatch objNull;
                                        _x doFollow (leader _group)
                                    };
                                }
                            }
                        }
                    } forEach (units _group);
				}
			} forEach allGroups;
			sleep 5
		}
	}
}