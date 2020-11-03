private ["_maxWaypoints","_pos","_rand1","_rand2","_type","_update","_wps","_z"];
params ["_team", "_destination", ["_radius", 30], ["_formation", "DIAMOND"]];

if (_destination isEqualType objNull) then {_destination = getPos _destination};

_team setCombatMode "RED";
_team setBehaviour "COMBAT";
_team setFormation _formation;
_team setSpeedMode "NORMAL";

_maxWaypoints = 8;
_wps = [];
for [{_z=0},{_z<=_maxWaypoints},{_z=_z+1}] do {
	_rand1 = random _radius - random _radius;
	_rand2 = random _radius - random _radius;
	_pos = [(_destination select 0)+_rand1,(_destination select 1)+_rand2,0];
	while {surfaceIsWater _pos} do {
		_rand1 = random _radius - random _radius;
		_rand2 = random _radius - random _radius;
		_pos = [(_destination select 0)+_rand1,(_destination select 1)+_rand2,0];
	};
	_type = ["CYCLE", "MOVE"] select (_z != _maxWaypoints);
	_wps pushBack ([_pos,_type,35,40,"",[]]);
};

["INFORMATION", Format ["AI_Patrol.sqf: [%1] Team [%2] is patrolling at [%3].", side _team,_team,_destination]] Call WFCO_FNC_LogContent;

[_team, true, _wps] Call WFCO_fnc_aiWpAdd;