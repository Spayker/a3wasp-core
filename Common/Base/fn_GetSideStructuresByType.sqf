private ["_found", "_structure_type", "_temp"];
params ["_type", "_structures", ["_sort", false], ["_distance", -1]];

_found = [];
{
	_structure_type = [_x getVariable "wf_structure_type" ,""] select (isNil{_x getVariable "wf_structure_type"});
	if (_structure_type == _type) then { _found pushBack _x };
} forEach _structures;

if (count _found > 0 && typeName _sort in ["OBJECT","POSITION"]) then { 
	if (_distance != -1) then { 
		_temp = [];
		{ if (_x distance _sort <= _distance) then { _temp pushBack _x } } forEach _found;
		_found = _temp;
	};
	_found = [_sort, _found] call WFCO_FNC_SortByDistance;
};

_found