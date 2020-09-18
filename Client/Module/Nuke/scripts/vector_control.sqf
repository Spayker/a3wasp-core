/*
	File: vector_control.sqf
	Author: Joris-Jan van 't Land

	Description:
	Vector control during launch.

	Parameter(s):
	_this select 0: the cruisemissile object.
*/

private ["_mis", "_dZ", "_i", "_vector_start"];
_mis = _this select 0;
_dZ = 0.1;
_i = 0;
_vector_start = [0, 0, 1];

while {!(_mis getVariable "cruisemissile_level")} do 
{
	_mis setVectorDir [0, 1, 0];
	_mis setVectorUp [_vector_start select 0, (_vector_start select 1) - (_i * _dZ), _vector_start select 2];
	
	sleep 0.01;
	
	if (((position _mis) select 2) > 20) then {_dZ = 0.25};
	
	_i = _i + 0.1;	
};

true