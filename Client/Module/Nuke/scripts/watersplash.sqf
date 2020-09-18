/*
	File: watersplash.sqf
	Author: Joris-Jan van 't Land

	Description:
	The watersplash caused by the underwater cruisemissile launch.

	Parameter(s):
	_this select 0: the cruisemissile object.
*/

//ToDo: check the object passed is a cruisemissile? Same for other scripts.

private ["_object", "_color1", "_color2", "_color", "_volume", "_rdmDir", "_rdmDirFac", "_pos"];
_object = _this select 0;
_color1 = [[0.05, 0.6, 0.6, 0.1], [0.05, 0.6, 0.6, 0.5], [0.05, 0.4, 0.4, 0.0]];
_color2 = [[1.0, 1.0, 1.0, 0.1], [1.0, 1.0, 1.0, 0.5], [1.0, 1.0, 1.0, 0.0]];
_color = _color1;
_volume = 1.0;
_rdmDir = 0.0;
_rdmDirFac = 0.0;
_pos = position _object;

for "_l" from 0 to 40 do 
{
	private ["_size1", "_lifeTime", "_weight", "_rdm"];
	_size1 = [1 + (random 1), 6 + (random 6)];
	_lifeTime = 5 + (random 5);
	_weight = 5 + (random 1);
	_rdm = random 1;
	
	if (_rdm > 0.5) then 
	{
		_color = _color1;
	} 
	else 
	{
		_color = _color2;
	};
	
	drop ["\ca\data\cl_water", "", "Billboard", 1, _lifeTime, [(_pos select 0) + (1 - (random 2)), (_pos select 1) + (1 - (random 2)), 0], [(1 - (random 2)), (1 - (random 2)), 3 + (random 5)], 1, _weight, _volume, 0, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	
	sleep 0.01;
};

true