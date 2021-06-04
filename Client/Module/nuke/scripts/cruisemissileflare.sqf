/*
	File: cruisemissileflare.sqf
	Author: Joris-Jan van 't Land

	Description:
	Keep the flare attached to the missile while it's launching.

	Parameter(s):
	_this select 0: the cruisemissile object.
	_this select 1: the flare object.
*/

private ["_mis", "_flare"];
_mis = _this select 0;
_flare = _this select 1;

while {!(_mis getVariable "cruisemissile_level")} do 
{
	_flare setPos [(position _mis select 0), (position _mis select 1), (position _mis select 2) - 1];
	
	sleep 0.1;
};

deleteVehicle _flare;

true