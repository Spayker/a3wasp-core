/*
	File: explosion2.sqf
	Author: Joris-Jan van 't Land

	Description:
	Explosion 2.

	Parameter(s):
	_this select 0: explosion's position.
*/

private ["_pos", "_color1", "_color2", "_color", "_volume", "_rdmDir", "_rdmDirFac", "_size1", "_lifeTime", "_weight", "_rdm"];
_pos = _this select 0;
_color1 = [[1, 1, 1, 0.5]];
_color2 = [[1, 1, 1, 0.5]];
_color = _color1;
_volume = 1.0;
_rdmDir = 0.0;
_rdmDirFac = 0.0;
_size1 = [1 + (random 1), 10 + (random 20)];
_lifeTime = 0.4;
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

drop ["\ca\data\cl_fire", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 1, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
drop ["\ca\data\cl_fire", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 1, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
drop ["\ca\data\cl_fire", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 1, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
drop ["\ca\data\cl_fire", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 1, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];

drop ["\ca\data\cl_fire", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 1, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
drop ["\ca\data\cl_fire", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 1, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
drop ["\ca\data\cl_fire", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 1, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
drop ["\ca\data\cl_fire", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 1, _size1, _color, [0, 1], _rdmDir, _rdmDirFac, "", "", ""];

drop ["\ca\data\cl_fire", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 1, _size1, [[0.2, 0.2, 0.2, 0.3]], [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
drop ["\ca\data\cl_fire", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 1, _size1, [[0.2, 0.2, 0.2, 0.3]], [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
drop ["\ca\data\cl_fire", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 1, _size1, [[0.2, 0.2, 0.2, 0.3]], [0, 1], _rdmDir, _rdmDirFac, "", "", ""];
drop ["\ca\data\cl_fire", "", "Billboard", 1, _lifeTime, _pos, [(20 - (random 40)),(20 - (random 40)),(20 - (random 40))], 1, _weight, _volume, 1, _size1, [[0.2, 0.2, 0.2, 0.3]], [0, 1], _rdmDir, _rdmDirFac, "", "", ""];

true