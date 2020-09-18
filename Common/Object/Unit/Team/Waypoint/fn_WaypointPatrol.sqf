/*
	Set a team on patrol.
	 Parameters:
		- Team.
		- Destination.
		- {Radius}.
*/

private ["_pos","_rand1","_rand2","_type","_wps"];
params ["_team", "_destination", "_radius", "_maxWaypoints", ["_behaviours", []]];

if (_destination isEqualType objNull) then {_destination = getPos _destination};

if (isNil '_maxWaypoints') then {
	_maxWaypoints = missionNamespace getVariable 'WF_C_TOWNS_UNITS_WAYPOINTS'
};

_wps = [];
for '_z' from 0 to _maxWaypoints do {
	_rand1 = random _radius - random _radius;
	_rand2 = random _radius - random _radius;
	_pos = [(_destination select 0)+_rand1,(_destination select 1)+_rand2,0];
	while {surfaceIsWater _pos} do {
		_rand1 = random _radius - random _radius;
		_rand2 = random _radius - random _radius;
		_pos = [(_destination select 0)+_rand1,(_destination select 1)+_rand2,0];
	};
	_type = ["CYCLE", "MOVE"] select (_z != _maxWaypoints);
	_wps pushBack [_pos,_type,35,40,[],[],_behaviours];
};

[_team, true, _wps] Call WFCO_FNC_WaypointsAdd;