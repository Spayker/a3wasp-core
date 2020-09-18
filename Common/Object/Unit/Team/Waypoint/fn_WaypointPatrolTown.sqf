/*
	Set a team on town patrol.
	 Parameters:
		- Team.
		- Town.
		- {Radius}.
*/

private ['_camps','_insert','_insertObject','_insertStep','_maxWaypoints','_pos','_rand1','_rand2','_townPos','_type','_update','_usable','_wpcompletionRadius','_wpradius','_wps'];
params ["_team", "_town", ["_radius", 30]];

if (!(_town isEqualType objNull)) exitWith {};
if (isNull _team) exitWith {};
_townPos = getPos _town;

_camps = _town getVariable 'camps';//wf2

_usable = [_town] + _camps;
_maxWaypoints = (missionNamespace getVariable 'WF_C_TOWNS_UNITS_WAYPOINTS') + count(_usable);
_wps = [];

//--- Randomize the behaviours.
if (random 100 > 50) then {_team setFormation "DIAMOND"} else {_team setFormation "STAG COLUMN"};
if (random 100 > 50) then {_team setCombatMode "YELLOW"} else {_team setCombatMode "RED"};
if (random 100 > 50) then {_team setBehaviour "AWARE"} else {_team setBehaviour "COMBAT"};
if (random 100 > 50) then {_team setSpeedMode "NORMAL"} else {_team setSpeedMode "LIMITED"};

//--- Dyn insert.
_insertStep = [-1, floor(_maxWaypoints / count(_usable))] select (count(_usable) != 0);
_insert = _insertStep;
_insertObject = objNull;
_wpradius = -1;
_wpcompletionRadius = -1;

for '_z' from 0 to _maxWaypoints do {
	if (_z == _insert && count _usable > 0) then {
		_insert = _insert + _insertStep;
		_insertObject = _usable # (round(random((count _usable)-1)));
		_index = _usable find _insertObject;
		if(_index > -1)then{_usable deleteAt _index};
	};

	if (isNull _insertObject) then {
		_rand1 = random _radius - random _radius;
		_rand2 = random _radius - random _radius;
		_pos = [(_townPos # 0)+_rand1,(_townPos # 1)+_rand2,0];
		while {surfaceIsWater _pos} do {
			_rand1 = random _radius - random _radius;
			_rand2 = random _radius - random _radius;
			_pos = [(_townPos # 0)+_rand1,(_townPos # 1)+_rand2,0];
		};
		_wpradius = 32;
		_wpcompletionRadius = 44;
	} else {
		_pos = getPos _insertObject;
		_wpradius = 35;
		_wpcompletionRadius = 68;
	};
	
	_type = ["CYCLE", "MOVE"] select (_z != _maxWaypoints);
	_wps pushBack [_pos,_type,_wpradius,_wpcompletionRadius, [], [], []];
};

[_team, true, _wps] Call WFCO_FNC_WaypointsAdd;