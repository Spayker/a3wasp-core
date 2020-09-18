/*
	File: cruising.sqf
	Author: Joris-Jan van 't Land

	Description:
	Cruising the missile to its target.

	Parameter(s):
	_this select 0: the cruisemissile object.
	_this select 1: the target object.
*/

private ["_mis", "_target"];
_mis = _this select 0;
_target = _this select 1;

private ["_path", "_pathS"];
_path = "\ca\air2\cruisemissile\"; //"
_pathS = _path + "data\scripts\"; //"

_mis setCombatMode "BLUE";
_mis setBehaviour "CARELESS";
_mis disableAI "AUTOTARGET";

private ["_stagingPos"];
_stagingPos = [(position _target) select 0, ((position _target) select 0) + 3000, 0];
_mis doMove _stagingPos;

waitUntil {((position _mis) distance _stagingPos) < 100};

while {alive _mis} do 
{
	_mis flyInHeight 100;
	_mis doMove (position _target);
	
	waitUntil {(_mis distance _target) <= 400};
	
	_mis flyInHeight 5;
	_mis doMove (position _target);
	
	while {(_mis distance _target) <= 400} do 
	{
		if ((_mis distance _target) < 50) then 
		{
			deleteVehicle (driver _mis);
			deleteVehicle _mis;

			private ["_pos", "_shell"];
			_pos = position _mis;
			_shell = "Sh_105_HE" createVehicle _pos;
			_shell = "Sh_105_HE" createVehicle _pos;
			_shell = "Sh_105_HE" createVehicle [_pos select 0, _pos select 1, 0];
			
			[_pos] execVM (_pathS + "explosion.sqf");
		};
		
		sleep 0.1;
	};
};

true