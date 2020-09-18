/*
	File: booster.sqf
	Author: Joris-Jan van 't Land

	Description:
	Boosting the missile during launch.

	Parameter(s):
	_this select 0: the cruisemissile object.
*/

private ["_mis"];
_mis = _this select 0;

private ["_dX", "_dZ", "_i"];
_dX = 0.3;
_dZ = 0.1;
_i = 0;

while {!(_mis getVariable "cruisemissile_level")} do 
{
	_mis setPos [(position _mis) select 0, (((position _mis) select 1) - (_i * _dX)), (((position _mis) select 2) + (_i * _dZ))];

	sleep 0.01;

	if (((position _mis) select 2) < 20) then {_dZ = _dZ + 0.02} else {_dZ = (_dZ - 0.02) max 0};

	_i = _i + 0.1;
};

true