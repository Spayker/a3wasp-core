/*
	Reveal an entire area for a unit/team.
	 Parameters:
		- Unit/Team
		- Range
		- Center Position
*/

Private ["_pos","_range","_reveal","_team","_unit"];

_unit = _this select 0;
_range = _this select 1;
_pos = _this select 2;

{
	_reveal = [_x];
	if (_x != vehicle _x) then {_reveal = _reveal + (crew _x);};
	{_unit reveal _x} forEach _reveal;
} forEach (_pos nearEntities _range);