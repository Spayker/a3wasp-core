/*
	Return pos1 direction to pos2. (BIS Fnc)
	 Parameters:
		- Entity.
		- Entity.
*/

private ["_ret"];
params ["_pos1", "_pos2"];

if(typename _pos1 == "OBJECT") then {_pos1 = getpos _pos1};
if(typename _pos2 == "OBJECT") then {_pos2 = getpos _pos2};

_ret = ((_pos2 select 0) - (_pos1 select 0)) atan2 ((_pos2 select 1) - (_pos1 select 1));
_ret = _ret % 360;
_ret