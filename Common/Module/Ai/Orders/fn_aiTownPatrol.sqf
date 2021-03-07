Params ["_team",["_destinations", []], ["_radius", 30], ["_formation", "COLUMN"], ["_isInfantry", false]];
Private ["_destination","_maxWaypoints","_pos","_radius","_rand1","_rand2","_team","_type","_update","_wps","_z"];

_team setCombatMode "YELLOW";
_team setBehaviour "AWARE";
_team setFormation _formation;
_team setSpeedMode "NORMAL";

if(_isInfantry)then{
    _team setCombatMode "YELLOW";
    _team setBehaviour "AWARE";
    _team setFormation "WEDGE";
    _team setSpeedMode "FULL"
};

_wps = [];
for [{_z=0},{_z<=(count _destinations)-1},{_z=_z+1}] do {
	_rand1 = random _radius - random _radius;
	_rand2 = random _radius - random _radius;
	_destination = getPosATL (_destinations # _z);
	_pos = [(_destination # 0)+_rand1,(_destination # 1)+_rand2,0];
	while {surfaceIsWater _pos} do {
		_rand1 = random _radius - random _radius;
		_rand2 = random _radius - random _radius;
		_pos = [(_destination # 0)+_rand1,(_destination # 1)+_rand2,0];
	};
	_type = if (_z != (count _destinations)-1) then {'MOVE'} else {'SAD'};
	_wps pushBack ([_pos, _type, 35, 40, "", []])
};

["INFORMATION", Format ["aiTownPatrol.sqf: [%1] Team [%2] is patrolling at [%3].", side _team,_team,_destination]] Call WFCO_FNC_LogContent;

[_team, true, _wps] Call WFCO_fnc_aiWpAdd;