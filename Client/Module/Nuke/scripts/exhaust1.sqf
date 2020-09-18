/*
	File: exhaust1.sqf
	Author: Joris-Jan van 't Land

	Description:
	One of the missile's exhaust trails.

	Parameter(s):
	_this select 0: the cruisemissile object.
*/

private ["_object", "_weight", "_volume", "_rdmDir", "_rdmDirFac", "_density"];
_object = _this select 0;
_weight = 1.275;
_volume = 1.0;
_rdmDir = 0.0;
_rdmDirFac = 0.0;
_density = 0.01;

private ["_path", "_pathS"];
_path = "\ca\air2\cruisemissile\"; //"
_pathS = _path + "data\scripts\"; //"

private ["_l"];
while {!(_object getVariable "cruisemissile_level")} do 
{
	private ["_size1", "_lifeTime"];
	_size1 = [1 + (random 1), 20 + (random 60)];
	_lifeTime = 10 + (random 10);

	//ToDo: Should shine?
	drop ["\ca\data\cl_basic", "", "Billboard", 1, 0.1, [0, 0, -0.3], [0, _l / 25, -10], 1, _weight, _volume, 0, [2.0, 4.0, 0.5], [[0.9, 0.7, 0.7, 0.2]], [0, 1], _rdmDir, _rdmDirFac, "", _pathS + "exhaust2.sqs", _object];

	sleep _density;
	
	_l = _l + 1;
};

true