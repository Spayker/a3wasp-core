/*
	Return the closest object among a list
	 Parameters:
		- Entity.
		- List.
*/

private["_distance","_nearest"];
params ["_object", "_objects", ["_distance", 100000]];

_nearest = objNull;
{
    _spawnLoc = _x;
    if(_x isEqualType []) then { _spawnLoc = _x select 0; };
    if!(isNil '_spawnLoc')then{
        _currentDistance = _spawnLoc distance _object;
        if (_currentDistance < _distance) then {_nearest = _spawnLoc;_distance = _currentDistance;};
    };
} forEach _objects;

_nearest