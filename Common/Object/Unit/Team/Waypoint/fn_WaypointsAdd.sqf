/* 
	Add waypoints to a team.
	 Parameters:
		- Team.
		- Remove all existing WP.
		- WP List. (i.e: [_team, true, [[getPos _camp, 'MOVE', 10, 20, [], [10,20,30], ["COMBAT","RED","COLUMN","LIMITED"]],[[1560,2560,0], 'SAD', 50, 70, ["canComplete", "this sidechat 'lets roll'"], [], ["SAFE","","LINE",""]]...]] Call AddWP;)
*/

private ['_completionRadius','_position','_radius','_squad_prop','_statements','_timeout','_type','_waypoint','_WPCount'];
params ["_team", "_clear", "_waypoints"];

if (_clear) then {_team Call WFCO_FNC_WaypointsRemove};

{
	_position = _x select 0;
	_type = _x select 1;
	_radius = _x select 2;
	_completionRadius = _x select 3;
	_statements = _x select 4;
	_timeout = _x select 5;
	_squad_prop = _x select 6;
	if (typeName _position == 'OBJECT') then {_position = getPos _position};
	
	_WPCount = count (waypoints _team);	
	_waypoint = _team addWaypoint [_position, _radius];
	[_team, _WPCount] setWaypointType _type;
	[_team, _WPCount] setWaypointCompletionRadius _completionRadius;
	if (count _statements > 0) then {[_team, _WPCount] setWaypointStatements [_statements select 0, _statements select 1]};
	if (count _timeout > 0) then {[_team, _WPCount] setWaypointTimeout [_timeout select 0, _timeout select 1, _timeout select 2]};
	if (count _squad_prop > 0) then {if ((_squad_prop select 0) != "") then {[_team, _WPCount] setWaypointBehaviour (_squad_prop select 0)};if ((_squad_prop select 1) != "") then {[_team, _WPCount] setWaypointCombatMode (_squad_prop select 1)};if ((_squad_prop select 2) != "") then {[_team, _WPCount] setWaypointFormation (_squad_prop select 2)};	if ((_squad_prop select 3) != "") then {[_team, _WPCount] setWaypointSpeed (_squad_prop select 3)};};	
	if (_WPCount == 0) then {_team setCurrentWaypoint [_team, _WPCount]};
} forEach _waypoints;