//Changed in 0.6.0
//Changed in 0.3.0
//Changed in 0.2.0

private["_ring", "_pos", "_obj","_radius", "_heigth"];

if (!hasInterface) exitWith {};

_pos = _this select 0;
_heigth = _this select 1;
_radius = _this select 2;

_obj = "Sign_Sphere10cm_F" createVehicleLocal [_pos select 0, _pos select 1, (_pos select 2) + _heigth];
//_pos = getPos _obj;

if (isServer) then {_obj setPos [getPos _obj select 0,getPos _obj select 1,(_pos select 2) + _heigth]; 
_obj setVectorUp [0,0,1]};


private _num = 2 * 3.141 * _radius / 2;
private _curAngle = 0;
private _angleInc = 360 / _num;
for "_i" from 0 to _num do {

	_curPos = [(_pos # 0) + (cos _curAngle) * _radius, (_pos # 1) + (sin _curAngle) * _radius, _pos # 2];
	
	drop [["\A3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,8,0], "", "Billboard", 1, 180, (_curPos vectorDiff _pos), (vectorNormalized(_curPos vectorDiff _pos)) vectorMultiply 7, 0, 9.996,7.84, 0, [10,10], [[1,1,1,1],[1,1,1,0]], [1,1], 1, 0, "", "", _obj, random(360)/(2 * pi), false, -1.0, [[1,1,1,1],[1,1,1,0]]];
	
	_curAngle = _curAngle + _angleInc;
};

deleteVehicle _obj;
