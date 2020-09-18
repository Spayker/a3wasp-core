//--------------------------fn_MultiArrayToSimple-----------------------------------------------------------------------//
//																														//
//	Recursive traversal of multidimension array and convert it to one dimension									        //
//																														//
//--------------------------fn_MultiArrayToSimple-----------------------------------------------------------------------//
params [["_array", []]];
private ["_result", "_recurseTravel"];

_result = [];

_recurseTravel = {
	params [["_array", []]];
	
	{
		if(_x isEqualType []) then {
			[_x] call _recurseTravel;
		} else {
			_result pushBack _x;
		};
	} forEach _array;
};

[_array] call _recurseTravel;

_result;