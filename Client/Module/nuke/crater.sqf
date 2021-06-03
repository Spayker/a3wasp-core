//Created in 0.4.0


private["_pos", "_radius", "_type", "_objs", "_curPos", "_curRot", "_x", "_y", "_num", "_angleInc", "_curAngle", "_curRadius", "_rType", "_heightOffset"];


_pos = _this select 0;
_radius = _this select 1;

//calculate new radius depending on detonation height
_radius = ((_radius ^ 2) - ((_pos # 2) ^ 2))^ 0.5;

if (_radius == 0) exitWith {
	_pos = [_pos # 0, _pos # 1, 1.6];
	createVehicle ["Land_ShellCrater_02_extralarge_F", _pos, [], 0, "CAN_COLLIDE"];
};

if (_radius < 0) exitWith{};

//calculate height offset, used for smaller craters
_heightOffset = 0;
if (_radius < 50) then{
	_heightOffset = -50 + _radius;
	_heightOffset = _heightOffset / 10;
};




_pos = [_pos # 0, _pos # 1, _heightOffset];

_type = "Land_R_rock_general2";
_objs = [];

_num = floor(2 * pi * _radius / 15);
_angleInc = 360 / _num;
_curAngle = 0;

//create circle of stone "walls"
for "_i" from 0 to _num do {

	_curPos = [(_pos # 0) + (cos _curAngle) * _radius, (_pos # 1) + (sin _curAngle) * _radius, _pos # 2];
	_objs pushBack (createVehicle [_type, _curPos, [], 0, "CAN_COLLIDE"]);
	
	(_objs # _i) setVectorDir vectorNormalized([cos _curAngle, sin _curAngle, 0]);
	
	_curAngle = _curAngle + _angleInc;
};


_type = "Land_ShellCrater_02_decal_F";
_curRadius = 3;

//create decals on the ground inside the crater
while{_curRadius < _radius}  do {


	_objs = [];

	_num = floor(2 * pi * _curRadius / 3);
	_angleInc = 360 / _num;
	_curAngle = 0;

	for "_i" from 0 to _num do {

		_curPos = [(_pos # 0) + (cos _curAngle) * _curRadius, (_pos # 1) + (sin _curAngle) * _curRadius, 0];
		_objs pushBack (createVehicle [_type, _curPos, [], 0, "CAN_COLLIDE"]);	
		
		//randomly place debris inside crater
		if ((random 100) < 45) then{
			_rType = selectRandom ["Land_ShellCrater_02_debris_F", "Land_BluntStones_erosion", "Land_SharpStones_erosion", "Land_W_sharpStones_erosion"];
			createVehicle [_rType, _curPos, [], 0, "CAN_COLLIDE"];
		};
		
		//chance for large debris is increases from the center out
		if ((random 100) < (20 * (_curRadius ^ 2) / (_radius ^ 2))) then{
			_rType = selectRandom ["Land_SharpStone_02", "Land_W_sharpStone_02","Land_SharpStone_01", "Land_W_sharpStone_01", "Land_LavaStone_big_F", "Land_LavaStone_small_F"];
			createVehicle [_rType, _curPos, [], 0, "CAN_COLLIDE"];
		};
		
		_curAngle = _curAngle + _angleInc;
	};
	
	_curRadius = _curRadius + (3 min(_radius - _curRadius));
};