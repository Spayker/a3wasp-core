/* 
	Author: Benny
	Name: AI_WPAdd.sqf
	Parameters:
	  0 - Team
	  1 - Clear (Remove WPs)
	  2 - Waypoints (given in an Array)
	Description:
	  This file is used to give a detailed WP system.
	Exemple:
	  [_team, true, [[getPos _camp, 'MOVE', 10, 20, "", []],[[1560,2560,0], 'SAD', 50, 70, "", ["canComplete", "this sidechat 'lets roll'"]]...]] Call AddWP;
*/

private ["_completionRadius","_position","_radius","_scripted","_statements","_type","_waypoint","_WPCount"];
params ["_team", "_clear", "_waypoints"];

if (_clear) then {_team Call WFCO_fnc_aiWpRemove};

{
	_position = _x # 0;
	_type = _x # 1;
	_radius = _x # 2;
	_completionRadius = _x # 3;
	_scripted = _x # 4;
	_statements = _x # 5;
	if (_position isEqualType objNull) then {_position = getPos _position};
	
	_WPCount = count (waypoints _team);
	
	_waypoint = _team addWaypoint [_position,_radius];
	[_team, _WPCount] setWaypointType _type;
	[_team, _WPCount] setWaypointCompletionRadius _completionRadius;
	if (_type == "SCRIPTED") then {[_team, _WPCount] setWaypointScript _scripted};
	if (count _statements > 0) then {[_team, _WPCount] setWaypointStatements [_statements # 0, _statements # 1]};
	
	if (_WPCount == 0) then {_team setCurrentWaypoint [_team, _WPCount]};
} forEach _waypoints;