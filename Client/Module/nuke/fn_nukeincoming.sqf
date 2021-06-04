//--- Nuke launching.
params ["_target", "_nukeMarker"];
private ['_cruise','_dropPosition','_dropPosX','_dropPosY','_dropPosZ','_misFlare','_path','_pathS','_planespawnpos','_type'];

['TacticalLaunch'] remoteExecCall ["WFCL_FNC_LocalizeMessage"];

sleep (missionNamespace getVariable "WF_C_INCOME_TIME_OF_ICBM");

_dropPosition = getpos _target;
_type = 'Missile_AGM_01_F';
_cruise = createVehicle [_type,[(_dropPosition select 0) - 4000, (_dropPosition select 1) - 4000, 13000],[], 0, "FLY"];
_cruise setVectorDir [ 0.1,- 1,+ 0.5];
_cruise setVelocity [0,2,0];
_cruise flyInHeight 13000;
_cruise setSpeedMode "FULL";
_perSecondsChecks = 100;
_missileSpeed = 500;

[WF_Client_SideJoined,_target,_cruise,WF_Client_Team] remoteExec ["WFSE_FNC_processIcbmEvent",2];

sleep 1.5;

[_target, _cruise] remoteExec ["WFCL_FNC_initIcbmStrike"];

//create missile and setting pos
_pos = [(_dropPosition select 0) - 4000, (_dropPosition select 1) - 4000, 13000];

//ajusting missile pos while flying
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

		sleep (1/ _perSecondsChecks);
	};
};

[_cruise] execVM "Client\Module\Nuke\scripts\exhaust1.sqf";


sleep 7;

waitUntil {!alive _cruise};

sleep 50;
deleteMarkerLocal _nukeMarker;
