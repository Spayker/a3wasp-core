//--- Nuke launching.
params ["_target"];
private ['_cruise','_dropPosition','_dropPosX','_dropPosY','_dropPosZ','_misFlare','_path','_pathS','_planespawnpos','_type'];

['TacticalLaunch'] remoteExecCall ["WFCL_FNC_LocalizeMessage", -2];

sleep 15;

_dropPosition = getpos _target;
_distance = 4000;
_cruise = "cwr3_scud_ammo" createVehicle ([(getPos _target) # 0, (getPos _target) # 1, _distance]);

_missileSpeed = 400;
_perSecondsChecks = 100;

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

[WF_Client_SideJoined,_target,_cruise,WF_Client_Team] remoteExec ["WFSE_FNC_processTacticalNukeMissileEvent",2];

//create missile and setting pos
while {alive _cruise} do {
	if (_cruise distance _target > (_missileSpeed / 10)) then {
		_dirHor = [_cruise, _target] call BIS_fnc_DirTo;
		_cruise setDir _dirHor;

		_dirVer = asin ((((getPosASL _cruise) select 2) - ((getPosASL _target) select 2)) / (_target distance _cruise));
		_dirVer = (_dirVer * -1);
		[_cruise, _dirVer, 0] call BIS_fnc_setPitchBank;

		_flyingTime = (_target distance _cruise) / _missileSpeed;
		_velocityX = (((getPosASL _target) select 0) - ((getPosASL _cruise) select 0)) / _flyingTime;
		_velocityY = (((getPosASL _target) select 1) - ((getPosASL _cruise) select 1)) / _flyingTime;
		_velocityZ = (((getPosASL _target) select 2) - ((getPosASL _cruise) select 2)) / _flyingTime;
		_cruise setVelocity [_velocityX, _velocityY, _velocityZ];

		sleep (1/ _perSecondsChecks)
	}
};

[_cruise] execVM "Client\Module\Nuke\scripts\exhaust1.sqf";
