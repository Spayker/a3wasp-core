//Changed in 0.6.0
//Changed in 0.5.0
//Changed in 0.4.0
//Changed in 0.3.0
//Changed in 0.2.0


private["_pos", "_obj","_cloudRadius", "_cloudBottom", "_cloudTop", "_lifetime", "_cap", "_capLifetime", "_capObj", "_vSpeed", "_h", "_cloudLifetime", "_color", "_colorTarget"];

if (!hasInterface) exitWith {};

_pos = _this select 0;
_radius = 1.5 * (_this select 1);
_cloudBottom = _this select 2;
_cloudTop = _this select 3;
_cloudLifetime = 300;

_color = [1,1,1,1];
_colorTarget = [1,1,1,0.7];

_vSpeed = 20;

_obj = "Sign_Sphere10cm_F" createVehicleLocal _pos;
_capObj = "Sign_Sphere10cm_F" createVehicleLocal [_pos select 0, _pos select 1,  (_pos select 2) + _radius * 2];

sleep 2;

if (isServer) then {_obj setPos [getPos _obj select 0,getPos _obj select 1,0]; 
_obj setVectorUp [0,0,1]};
if (isServer) then {_capObj setPos [getPos _capObj select 0,getPos _capObj select 1, getPos _capObj select 2]; 
_capObj setVectorUp [0,0,1]};




if ((_radius / 1.5) <= 46) exitWith
{
	private _fragments = [];
	private _moves = [];
	
	for "_i" from 0 to 5 do 
	{
		drop [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",8,0,40,0], "", "Billboard", 1, _cloudLifetime, [0,0,0], [0,0,0], 0.1, 9.996,7.84, 0, [_radius * 5,_radius * 4.5], [_color,_colorTarget], [0.5,0.5], 1, 0.1, "", "", _obj, random(360)/(2 * pi), true, -1.0, [_color,_colorTarget]];
	};
	
	
	for "_i" from 1 to 20 do
	{
		_moves pushBack ((vectorNormalized [random(200) - 100, random(200) - 100, 120]));
		_fragments pushBack ("Sign_Sphere10cm_F" createVehicleLocal _pos);
	};
	for "_i" from 1 to (floor(_cloudTop / 16)) do
	{	
		{
			drop [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",8,0,40,0], "", "Billboard", 1, _cloudLifetime, [0,0,0], [0,0,0], 0.1, 10,7.84, 0.1, [5 * _radius / _i + _radius * 0.5,5 * _radius / _i +  _radius * 0.5], [_color,_colorTarget], [0.2,0.2], 1, 0.15, "", "", _x, random(360)/(2 * pi), false, 1, [_color,_colorTarget]];
		} forEach _fragments;
		
		for "_j" from 0 to (count _moves - 1) do
		{
			(_fragments # _j) setPos ((getPos (_fragments # _j)) vectorAdd ((_moves # _j) vectorMultiply ((5 * _radius / _i + _radius * 0.5)/ 2.5)));		
		};
		sleep 0.01;
	};
	{
		deleteVehicle _x;
	} forEach _fragments;

};



private _fragments = [];
private _moves = [];

for "_i" from 0 to 5 do 
{
	drop [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",8,0,40,0], "", "Billboard", 1, _cloudLifetime, [0,0,0], [0,0,0], 0.1, 9.996,7.84, 0, [_radius * 5,_radius * 4.5], [_color,_colorTarget], [0.5,0.5], 1, 0.1, "", "", _obj, random(360)/(2 * pi), true, -1.0, [_color,_colorTarget]];
};


for "_i" from 1 to 20 do
{
	_moves pushBack ((vectorNormalized [random(200) - 100, random(200) - 100, 120]));
	_fragments pushBack ("Sign_Sphere10cm_F" createVehicleLocal _pos);
};
for "_i" from 1 to (floor(_cloudTop / 32)) do
{	
	{
		private _moveDir = [(_pos vectorDiff (getPos _x)) # 0, (_pos vectorDiff (getPos _x)) # 1, 0];
		_moveDir = _moveDir vectorMultiply 0.85;
		_moveDir = (vectorNormalized _moveDir) vectorMultiply ((vectorMagnitude _moveDir) / (((getPos _x) # 2) / _vSpeed + 0.1));
		drop [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",8,0,40,0], "", "Billboard", 1, ((getPos _x) # 2) / _vSpeed, [0,0,0], _moveDir, 0.1, 10,7.84, 0, [5 * _radius / _i + _radius * 0.5,5 * _radius / _i +  _radius * 0.5], [_color,_colorTarget], [0.2,0.2], 1, 0, "", "", _x, random(360)/(2 * pi), false, 1, [_color,_colorTarget]];
	} forEach _fragments;
	
	for "_j" from 0 to (count _moves - 1) do
	{
		//{_moves set[_j , [0,0,0]];};
		(_fragments # _j) setPos ((getPos (_fragments # _j)) vectorAdd ((_moves # _j) vectorMultiply ((5 * _radius / _i + _radius * 0.5)/ 2.5)));		
	};
	
	private _c = 0;
	{
		if (((getPos _x) # 2) > _cloudTop) then {deleteVehicle _x; _fragments deleteAt _c; _moves deleteAt _c; _c = _c - 1;};
		_c = _c + 1;
	} forEach _fragments;
	
	sleep 0.01;
};
{
	deleteVehicle _x;
} forEach _fragments;




_source = "#particlesource" createVehicleLocal [0,0,0]; //creates the stem of the mushroom
_source attachTo [_obj,[0,0,0]];
_cap = "#particlesource" createVehicleLocal [0,0,0]; //creates the cap of the mushroom
_cap attachTo [_capObj, [0,0,0]];


//vertical speed is 20 m/s

_lifetime = (_cloudTop - _radius / 2) / _vSpeed;
_capLifetime = (_cloudTop - _cloudBottom) / _vSpeed;

_cap setParticleCircle [_radius, [0,0,0]];


_cap setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",8,0,40,1], "", "Billboard", 1, _capLifetime, [0,0,0], [0,0,_vSpeed], 0.1, 9.996,7.84, 0, [_radius * 2,_radius * 2], [_color,_colorTarget], [0.2,0.2], 1, 0.1, "", "", _capObj, 0.0, false, -1.0, [_color,_colorTarget]];
_cap setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0, 2 * pi];

_source setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",8,0,40,1], "", "Billboard", 1, _lifetime * 1.1, [0,0,0], [0,0,_vSpeed * 0.9], 0.1, 9.996,7.84, 0, [_radius * 2,_radius], [_color,_colorTarget], [0.2,0.2], 1, 0.1, "", "", _obj, 0.0, true, -1.0, [_color,_colorTarget]];
_source setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0, 2 * pi];


_source setDropInterval 0.4;
if ((_radius / (_vSpeed * 5)) < 0.4) then {_source setDropInterval (_radius / (_vSpeed * 5))};
_cap setDropInterval 0.02;

0 = [_source, _cloudLifetime] spawn { 
	sleep (_this select 1);
	deleteVehicle (_this select 0);
};
for "_i" from 0 to 15 do 
{
	drop [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",8,0,40,1], "", "Billboard", 1, _cloudLifetime / 2, [0,0,0], [0,0,0], 0.1, 9.996,7.84, 0, [_radius * 3,_radius * 2.5], [_color,_colorTarget], [0.5,0.5], 1, 0.1, "", "", _obj, random(360)/(2 * pi), true, -1.0, [_color,_colorTarget]];
};



while {((getPosATL _capObj) select 2) < _cloudTop} do 
{
_capObj setPosATL [getPosATL _capObj select 0, getPosATL _capObj select 1, (getPosATL _capObj select 2) + (_vSpeed / 10) ];
//Move cap upwards 
sleep 0.1;
};



_h = 0.0;

//Create the expanding cap of the mushroom
while {_h < 1.0} do 
{
	_cap setDropInterval 10000;
	_cap setParticleCircle [(_cloudTop - _cloudBottom) * _h * 3, [0,0,0]];
	_h = _h + 0.1;
	_cap setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",8,0,40,1], "", "Billboard", 1, _cloudLifetime, [0,0,0], [0,0,0], 0.1, 9.996,7.84, 0, [(-0.5 * (_h)^4 + 1) * (_cloudTop - _cloudBottom),(-0.5 * (_h - 1)^4 + 1) * (_cloudTop - _cloudBottom)], [_color,_colorTarget], [0.2,0.2], 1, 0.1, "", "", _capObj, 0.0, false, -1.0, [_color,_colorTarget]];
	_capObj setPosATL [getPosATL _capObj select 0, getPosATL _capObj select 1, _cloudBottom + (-0.5 * (_h)^4 + 1) * (_cloudTop - _cloudBottom)/2];
	_cap setDropInterval 0.05;
	sleep 2;
};


deleteVehicle _cap;
sleep (_cloudLifetime - 20) / 2;
deleteVehicle _source;
deleteVehicle _capObj;
deleteVehicle _obj;
//Example for Particle Array:
//[ShapeName, AnimationName, Type, TimerPeriod, LifeTime, Position, MoveVelocity, RotationVelocity, Weight, Volume, Rubbing, Size, Color, AnimationPhase, RandomDirectionPeriod, RandomDirectionIntensity, OnTimer, BeforeDestroy, Object, Angle, OnSurface, BounceOnSurface, EmissiveColor]


