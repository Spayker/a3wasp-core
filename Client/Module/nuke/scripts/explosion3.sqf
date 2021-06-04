/*
	File: explosion3.sqf
	Author: Joris-Jan van 't Land

	Description:
	Explosion 3.

	Parameter(s):
	_this select 0: explosion's position.
*/

private ["_color1", "_color2", "_color", "_volume", "_rdmDir", "_rdmDirFac", "_pos"];
_color1 = [[0.9, 0.9, 0.9, 0.2], [0.9, 0.9, 0.9, 0.3], [0.9, 0.9, 0.9, 0]];
_color2 = [[0.77, 0.68, 0.55, 0.2], [0.77, 0.68, 0.55, 0.4], [0.77, 0.68, 0.55, 0.0]];
_color = _color1;
_volume = 1.0;
_rdmDir = 0.0;
_rdmDirFac = 0.0;
_pos = [((_this select 0) select 0), ((_this select 0) select 1), 0];

for "_l" from 0 to 10 do 
{
	private ["_size1", "_lifeTime", "_weight", "_rdm"];
	_size1 = [(1 + (random 1)), (2 + (random 2))];
	_lifeTime = 3;
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
	
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, [(_pos select 0) + (10 - (random 20)), (_pos select 1) + (10 - (random 20)), 0], [0,0,1 + (random 3)], 1, _weight, _volume, 1, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, [(_pos select 0) + (10 - (random 20)), (_pos select 1) + (10 - (random 20)), 0], [0,0,1 + (random 3)], 1, _weight, _volume, 1, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, [(_pos select 0) + (10 - (random 20)), (_pos select 1) + (10 - (random 20)), 0], [0,0,1 + (random 3)], 1, _weight, _volume, 1, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, [(_pos select 0) + (10 - (random 20)), (_pos select 1) + (10 - (random 20)), 0], [0,0,1 + (random 3)], 1, _weight, _volume, 1, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, [(_pos select 0) + (10 - (random 20)), (_pos select 1) + (10 - (random 20)), 0], [0,0,1 + (random 3)], 1, _weight, _volume, 1, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, [(_pos select 0) + (10 - (random 20)), (_pos select 1) + (10 - (random 20)), 0], [0,0,1 + (random 3)], 1, _weight, _volume, 1, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, [(_pos select 0) + (10 - (random 20)), (_pos select 1) + (10 - (random 20)), 0], [0,0,1 + (random 3)], 1, _weight, _volume, 1, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, [(_pos select 0) + (10 - (random 20)), (_pos select 1) + (10 - (random 20)), 0], [0,0,1 + (random 3)], 1, _weight, _volume, 1, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, [(_pos select 0) + (10 - (random 20)), (_pos select 1) + (10 - (random 20)), 0], [0,0,1 + (random 3)], 1, _weight, _volume, 1, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, [(_pos select 0) + (10 - (random 20)), (_pos select 1) + (10 - (random 20)), 0], [0,0,1 + (random 3)], 1, _weight, _volume, 1, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	
	sleep 0.01;
};

true