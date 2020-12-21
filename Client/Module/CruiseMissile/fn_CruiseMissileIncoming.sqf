//--- Nuke launching.
params ["_ftarget", "_nukeMarker"];
private ['_cruise','_dropPosition','_dropPosX','_dropPosY','_dropPosZ','_misFlare','_path','_pathS','_planespawnpos','_type'];

_dropPosition = getpos _ftarget;
_distance = 4000;
_direction = 180;
_missileSpeed = 500;
_radiusSearch = 50;
_perSecondsChecks = 100;
_target = objNull;

_nearObj = nearestObjects [_ftarget, ["Car","Tank","Man","Building","Ship", "APC", "StaticWeapon"], _radiusSearch];
_target = selectRandom _nearObj;

_startPos =  _target getRelPos [_distance, _direction];
_cruise = "ammo_Missile_Cruise_01" createVehicle _startPos;

//Placing the misssile at the desired height
[_cruise, _distance, _dropPosition,"ASL"] call BIS_fnc_setHeight;

//Making the missile point the target
_dir = [_cruise, _target] call BIS_fnc_DirTo;
_cruise setDir _dir;

//Giving the missile the desired speed
_vel = velocity _cruise;
_cruise setVelocity
[
    (_vel select 0) + (sin _dir * _missileSpeed),
    (_vel select 1) + (cos _dir * _missileSpeed),
    (_vel select 2)
];

[WF_Client_SideJoined,_ftarget,_cruise,WF_Client_Team] remoteExec ["WFSE_FNC_processCruiseMissileEvent",2];

//ajusting missile pos while flying
while {alive _cruise} do {
	if (_cruise distance _ftarget > (_missileSpeed / 10)) then {
		_dirHor = [_cruise, _ftarget] call BIS_fnc_DirTo;
		_cruise setDir _dirHor;

		_dirVer = asin ((((getPosASL _cruise) select 2) - ((getPosASL _ftarget) select 2)) / (_ftarget distance _cruise));
		_dirVer = (_dirVer * -1);
		[_cruise, _dirVer, 0] call BIS_fnc_setPitchBank;

		_flyingTime = (_ftarget distance _cruise) / _missileSpeed;
		_velocityX = (((getPosASL _ftarget) select 0) - ((getPosASL _cruise) select 0)) / _flyingTime;
		_velocityY = (((getPosASL _ftarget) select 1) - ((getPosASL _cruise) select 1)) / _flyingTime;
		_velocityZ = (((getPosASL _ftarget) select 2) - ((getPosASL _cruise) select 2)) / _flyingTime;
		_cruise setVelocity [_velocityX, _velocityY, _velocityZ];

		sleep (1/ _perSecondsChecks)
	}
};

waitUntil {!alive _cruise};

deleteMarkerLocal _nukeMarker
