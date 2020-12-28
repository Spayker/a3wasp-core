//--- Nuke launching.
params ["_ftarget", "_chemicalMarker"];
private ['_cruise','_dropPosition','_dropPosX','_dropPosY','_dropPosZ','_misFlare','_path','_pathS','_planespawnpos','_type'];

_dropPosition = getpos _ftarget;
_distance = 4000;
_missileSpeed = 400;
_perSecondsChecks = 100;

_cruise = "ammo_Missile_Cruise_01" createVehicle ([(getPos _ftarget) # 0, (getPos _ftarget) # 1, _distance]);

//Making the missile point the target
_dir = [_cruise, _ftarget] call BIS_fnc_DirTo;
_cruise setDir _dir;

//Giving the missile the desired speed
_vel = velocity _cruise;
_cruise setVelocity
[
    (_vel select 0) + (sin _dir * _missileSpeed),
    (_vel select 1) + (cos _dir * _missileSpeed),
    (_vel select 2)
];

[WF_Client_SideJoined, _dropPosition, _cruise, WF_Client_Team] remoteExec ["WFSE_FNC_processCruiseMissileEvent",2];

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

deleteMarkerLocal _chemicalMarker
