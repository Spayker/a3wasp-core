/*
	File: explosion.sqf
	Author: Joris-Jan van 't Land

	Description:
	Explosion 1.

	Parameter(s):
	_this select 0: explosion's position.
*/

private ["_pos", "_color1", "_color2", "_color3", "_color", "_volume", "_rdmDir", "_rdmDirFac"];
_pos = _this select 0;
_color1 = [[0.9, 0.9, 0.9, 0.5], [0.9, 0.9, 0.9, 0.8], [0.9, 0.9, 0.9, 0]];
_color2 = [[0.77, 0.68, 0.55, 0.5], [0.77, 0.68, 0.55, 0.8], [0.77, 0.68, 0.55, 0.0]];
_color3 = [[0.2, 0.2, 0.2, 0.5], [0.1, 0.1, 0.1, 0.8], [0.2, 0.2, 0.2, 0.0]];
_color = _color1;
_volume = 1.0;
_rdmDir = 0.0;
_rdmDirFac = 0.0;

private ["_path", "_pathS"];
_path = "\ca\air2\cruisemissile\"; //"
_pathS = _path + "data\scripts\"; //"

//ToDo: implement.
//drop ["cl_shock5", "", "SpaceObject", 1, 0.2, _pos, [0, 0, 0], 0, 0.001, 0.001, 0, [1, 300], [[1, 1, 1, 0.3], [1, 1, 1, 0]], [0, 1, 0, 1, 0, 1], 0, 0, "", "", ""];

sleep 0.01;

//drop ["cl_shock5", "", "SpaceObject", 1, 0.15, _pos, [0, 0, 0], 0, 0.001, 0.001, 0, [1, 250], [[1, 1, 1, 0.3], [1, 1, 1, 0]], [0, 1, 0, 1, 0, 1], 0, 0, "", "", ""];

[_pos] execVM (_pathS + "explosion2.sqf");
[_pos] execVM (_pathS + "explosion3.sqf");

for "_l" from 0 to 5 do 
{
	private ["_size1", "_lifeTime", "_weight"];
	_size1 = [0.2 + (random 0.2), 3 + (random 3)];
	_lifeTime = 0.5;
	_weight = 10;
	
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 0, _size1, _color1, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 0, _size1, _color1, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 0, _size1, _color1, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 0, _size1, _color1, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 0, _size1, _color1, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 0, _size1, _color1, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 0, _size1, _color2, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 0, _size1, _color2, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 0, _size1, _color2, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 0, _size1, _color2, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 0, _size1, _color2, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 0, _size1, _color2, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 0, _size1, _color3, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 0, _size1, _color3, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 0, _size1, _color3, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 0, _size1, _color3, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 0, _size1, _color3, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	drop ["\ca\data\cl_basic", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 0, _size1, _color3, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
	
	sleep 0.01;
};

true