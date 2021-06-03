//Changed in 0.6.0
//Changed in 0.5.0
//Changed in 0.3.0
//Changed in 0.2.0


private["_light", "_pos", "_obj", "_brigthness","_radius", "_vSpeed"];

if (!hasInterface) exitWith {};

_pos = _this select 0;
_radius = _this select 1;
_airMode = _this select 2;

_obj = "Sign_Sphere10cm_F" createVehicleLocal _pos;
_brigthness = 10050;


playSound3D ["A3\Sounds_F\sfx\explosion3.wss", _obj,false, _pos,5, 0.3, 0];


_vSpeed = 20;

if (isServer) then {_obj setPos _pos; //if (isServer) then {_obj setPos [getPos _obj select 0,getPos _obj select 1, getPos _obj select 2]; 
_obj setVectorUp [0,0,1]};
_light = "#lightpoint" createVehicleLocal [0,0,0];
_light lightAttachObject [_obj,[0,0,0]];
_light setLightBrightness _brigthness;
_light setLightColor [1,1,1];
_light setLightUseFlare true;
_light setLightFlareSize 1500;
_light setLightDayLight true;
_light setLightFlareMaxDistance 100000;


//create fireball
//drop [["\a3\structures_f_heli\vr\helpers\sign_sphere200cm_f.p3d",16,12,8,0], "", "SpaceObject", 1, 10, [0,0,0], [0,0,0], 10.0, 1, 1, 1.0, [_radius * 0.2,_radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 0.2], [[1,1,1,1],[1,0.4,0,1]], [1,1], 1, 0, "", "", _obj, 0.0, false, -1.0, [[1,1,1,1],[1,0.4,0,1]]];	
if (_airMode) then {_radius = _radius * 2;};
drop [["\A3\data_f\ParticleEffects\Universal\Universal.p3d",16,2,16,0], "", "Billboard", 1, 10, [0,0,0], [0,0,0], 1.0, 1, 1, 1.0, [_radius * 0.2,_radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 2, _radius * 0.2], [[1,1,1,1],[1,0.4,0,1]], [1,1], 1, 0, "", "", _obj, 0.0, false, -1.0, [[1,1,1,1],[1,0.4,0,1]]];	


//create initial flash
sleep 0.1;
while{_brigthness > 150} do {
	_brigthness = _brigthness - 1000;
	_light setLightBrightness _brigthness;
	sleep 0.01;
};

//reduce brigthness to create double flash
while{_brigthness < 10050} do {
	_brigthness = _brigthness + 200;
	_light setLightBrightness _brigthness;
	sleep 0.01;
};

//create second flash
while{_brigthness > 50} do {
	_obj setPos [getPos _obj select 0, getPos _obj select 1, (getPos _obj select 2) + 1 ];
	_brigthness = _brigthness - 800;
	_light setLightBrightness _brigthness;
	sleep 0.03;
};

//set color to orange to illuminate the fireball/effects
_light setLightColor [1,0.3,0];
_light setLightDayLight true;

while{_brigthness < 200} do {
	_obj setPos [getPos _obj select 0, getPos _obj select 1, (getPos _obj select 2) + (_vSpeed / 50) ];
	_brigthness = _brigthness + 50;
	_light setLightBrightness _brigthness;
	sleep 0.02;
};


if (_airMode) then 
{
	drop [["\A3\data_f\ParticleEffects\Universal\Universal.p3d",16,7,48,0], "", "Billboard", 1, 180, [0,0,0], [0,0,0.1], 0, 9.996,7.84, 0, [_radius * 2,_radius * 15,_radius * 20], [[0.2,0.2,0.2,1],[0.2,0.2,0.2,1]], [1,1], 1, 0, "", "", _obj, 0.0, false, -1.0, [[1,1,1,1],[1,1,1,0]]];
};


//let lightsource rise with the mushroomcloud
while {((getPosATL _obj) select 2) < _radius * 2} do 
{
	_obj setPosATL [getPosATL _obj select 0, getPosATL _obj select 1, (getPosATL _obj select 2) + (_vSpeed / 10) ];
	sleep 0.1;
};


while{_brigthness > 0} do 
{
		_brigthness = _brigthness + (random [-5, -2, -1]);
		_light setLightBrightness _brigthness;
		sleep 0.3;
};



deleteVehicle _light;
if (_airMode) then 
{
	sleep 180;
};
deleteVehicle _obj;
