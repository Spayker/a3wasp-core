/*
	File: exhaust3.sqf
	Author: Joris-Jan van 't Land

	Description:
	Third exhaust trail.

	Parameter(s):
	_this select 0: the cruisemissile object.
*/

private ["_object", "_color1", "_color2", "_color", "_volume", "_rdmDir", "_rdmDirFac", "_pos"];
_object = _this select 0;
_color1 = [[1, 1, 1, 0.1], [0.95, 0.95, 0.95, 0.5], [0.8, 0.8, 0.8, 0.0]];
_color2 = [[0.9, 0.9, 0.9, 0.2], [1, 1, 1, 0.5], [1, 1, 1, 0.0]];
_color = _color1;
_volume = 1.0;
_rdmDir = 0.0;
_rdmDirFac = 0.0;
_pos = position _object;

for "_l" from 0 to 80 do 
{
	private ["_size1", "_lifeTime", "_weight", "_rdm"];
	_size1 = [2 + (random 2), 40 + (random 60)];
	_lifeTime = 10 + (random 10);
	_weight = 1.1 + (random 1);
	_rdm = random 1;
	
	if (_rdm > 0.5) then 
	{
		_color = _color1;
	} 
	else 
	{
		_color = _color2;
	};
	
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, [_pos select 0, _pos select 1, _pos select 2], [(15 - (random 30)), (15 - (random 30)), -30 + (5 - (random 10))], 1, _weight, _volume, 1, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	
	sleep 0.1;
};

true