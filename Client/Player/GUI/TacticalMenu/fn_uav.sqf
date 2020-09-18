private ['_add','_buildings','_built','_checks','_closest','_d','_dir','_driver','_group','_gunner','_lastWP','_lastWPpos','_logic','_logicMARTA','_pos','_radius','_sorted','_spawn','_step','_uav','_waypoints','_wp','_wpcount'];
_logic = WF_Logic;

if (!isNull playerUAV) then {if (!alive playerUAV) then {playerUAV = objNull}};
if (!isNull playerUAV) exitWith {
	//--- Disable targetting.
	{(driver playerUAV) disableAI _x} forEach ["TARGET","AUTOTARGET"];
	call WFCL_fnc_uav_interface;
};

if (isNil {missionNamespace getVariable format ["WF_%1UAV",WF_Client_SideJoinedText]}) exitWith {};
if ((missionNamespace getVariable format ["WF_%1UAV",WF_Client_SideJoinedText]) == "") exitWith {};

_buildings = (WF_Client_SideJoined) call WFCO_FNC_GetSideStructures;
_checks = [WF_Client_SideJoined,missionNamespace getVariable format ["WF_%1COMMANDCENTERTYPE",WF_Client_SideJoinedText],_buildings] call WFCO_FNC_GetFactories;
_closest = objNull;
if (count _checks > 0) then { _closest = [player,_checks] call WFCO_FNC_GetClosestEntity; };

if (isNull _closest) exitWith {};

_uav = [missionNamespace getVariable format ["WF_%1UAV",WF_Client_SideJoinedText], getPos _closest, sideID, 0, true, true, true, "FLY"] call WFCO_FNC_CreateVehicle;

playerUAV = _uav;
call Compile format ["_uav addEventHandler ['Killed',{[_this # 0,_this # 1,%1] spawn WFCO_FNC_OnUnitKilled}]",sideID];

removeAllWeapons _uav;

_group = createGroup [WF_Client_SideJoined, true];
_driver = [missionNamespace getVariable format ["WF_%1SOLDIER",WF_Client_SideJoinedText],_group,getPos _uav,WF_Client_SideID] call WFCO_FNC_CreateUnit;
_driver moveInDriver _uav;

//--- Disable targetting.
{(driver playerUAV) disableAI _x} forEach ["TARGET","AUTOTARGET"];

_built = 1;
//--- OPFOR Uav has no gunner slot.
if (WF_Client_SideJoined == west) then {
	_gunner = [missionNamespace getVariable format ["WF_%1SOLDIER",WF_Client_SideJoinedText],_group,getPos _uav,WF_Client_SideID] call WFCO_FNC_CreateUnit;
	_gunner MoveInGunner _uav;
	_built = _built + 1;
};
[WF_Client_SideJoinedText,'UnitsCreated',_built] call WFCO_FNC_UpdateStatistics;
[WF_Client_SideJoinedText,'VehiclesCreated',1] call WFCO_FNC_UpdateStatistics;

-6500 call WFCL_FNC_ChangePlayerFunds;

sleep 0.02;

if ((count units _uav) > 1) then {[driver _uav] join grpnull};

_radius = 1000;
_wpcount = 4;
_step = 360 / _wpcount;
_add = 0;
_dir = 0;
if !(isNil "_lastWP") then {deleteWaypoint _lastWP};

//--- No need to preprocess those.
call WFCL_fnc_uav_interface;
[_uav] spawn WFCL_fnc_uav_spotter;

_spawn = [] spawn {};
while {alive _uav} do {
	waituntil {waypointDescription [group _uav,currentWaypoint group _uav] != ' ' || !alive _uav};
	terminate _spawn; //--- Terminate spawn from previous loop
	if !(alive _uav) exitWith {};

	_waypoints = waypoints _uav;
	if(count _waypoints > 0) then {
		_lastWP = _waypoints # (count _waypoints - 1);
		_lastWPpos = waypointPosition _lastWP;
		deleteWaypoint _lastWP;
		for "_d" from 0 to (360-_step) step _step do
		{
			_add = _d;
			_pos = [_lastWPpos, _radius, _dir+_add] call bis_fnc_relPos;
			_wp = (group _uav) addWaypoint [_pos,0];
			_wp setWaypointType "MOVE";
			_wp setWaypointDescription ' ';
			if(isNil '_wpcount')then{_wpcount = count waypoints _uav;};
			_wp setWaypointCompletionRadius (1000/_wpcount);
		};

		_spawn = [_uav,_add,_step,_lastWPpos,_radius,_dir, _wpcount] spawn {
			params ["_uav", "_add", "_step", "_lastWPpos", "_radius", "_dir", "_wpcount"];
			private ['_currentWP','_pos','_step','_wp'];
			scriptname "UAV Route planning";
			
			_currentWP = currentWaypoint group _uav;
			while {alive _uav} do {
				waitUntil {_currentWP != currentWaypoint group _uav};
				sleep .01;
				_add = _add + _step;
				_pos = [_lastWPpos, _radius, _dir+_add] call bis_fnc_relPos;
				_wp = (group _uav) addWaypoint [_pos,0];
				_wp setWaypointType "MOVE";
				_wp setWaypointDescription ' ';
				_wp setWaypointCompletionRadius (1000/_wpcount);
				_currentWP = currentWaypoint group _uav;
			};
		};

		_wpcount = count waypoints _uav;
		waitUntil {waypointDescription [group _uav,currentWaypoint group _uav] == ' ' || _wpcount != count waypoints _uav || !alive _uav};
	};
	if (!(alive _uav)||isNull _uav) exitWith {};
	sleep 1;
};