params ["_side", "_position", "_playerTeam"];
private ['_bd','_cargo','_cargoVehicle','_grp','_pilot','_positionCoord','_ran','_ranDir','_ranPos','_sideID',
'_timeStart','_vehicle','_vehicleCoord'];

if (isServer) exitWith {
    _hc = missionNamespace getVariable ["WF_HEADLESSCLIENT_ID", 0];
    if(_hc > 0) then {
        ["INFORMATION", Format["fn_ParaVehicles.sqf: delegating para vehicle request to hc - %1", _hc]] Call WFCO_FNC_LogContent;
        [_side, _position, _playerTeam] remoteExec ["WFCO_FNC_ParaVehicles",_hc]
    }
};

_sideID = _side call WFCO_FNC_GetSideID;

["INFORMATION", format ["fn_ParaVehicles.sqf: [%1] Team [%2] [%3] called in a Vehicle Paradrop.", str _side, _playerTeam,
    name (leader _playerTeam)]] call WFCO_FNC_LogContent;
_ranPos = [];
_ranDir = [];

_bd = missionNamespace getVariable 'WF_BOUNDARIESXY';
if !(isNil '_bd') then {
	_ranPos = [
		[0+random(200),0+random(200),400+random(200)],
		[0+random(200),_bd-random(200),400+random(200)],
		[_bd-random(200),_bd-random(200),400+random(200)],
		[_bd-random(200),0+random(200),400+random(200)]
	];
	_ranDir = [45,145,225,315];
} else {
	_ranPos = [[0+random(200),0+random(200),400+random(200)],[15000+random(200),0+random(200),400+random(200)]];
	_ranDir = [45,315];
};

_timeStart = time;
_ran = round(random((count _ranPos)-1));
_grp = createGroup [_side, true];
_vehicle = createVehicle [missionNamespace getVariable format ["WF_%1PARAVEHI",str _side],(_ranPos select _ran), [], (_ranDir select _ran), "FLY"];
[str _side,'VehiclesCreated',1] call WFCO_FNC_UpdateStatistics;
[str _side,'UnitsCreated',1] call WFCO_FNC_UpdateStatistics;
_pilot = [missionNamespace getVariable format ["WF_%1PILOT",str _side],_grp,[100,12000,0],_sideID] call WFCO_FNC_CreateUnit;
_pilot moveInDriver _vehicle;
_pilot doMove _position;
_grp setBehaviour 'CARELESS';
_grp setCombatMode 'STEALTH';
_pilot disableAI 'AUTOTARGET';
_pilot disableAI 'TARGET';
[_grp,_position,"MOVE",10] call WFSE_fnc_aiMoveTo;
call compile format ["_vehicle addEventHandler ['Killed',{[_this select 0,_this # 1,%1] spawn WFCO_FNC_OnUnitKilled}]",_sideID];

_vehicle flyInHeight (300 + random(75));
_cargo = (crew _vehicle) - [driver _vehicle, gunner _vehicle, commander _vehicle];
_cargoVehicle = [missionNamespace getVariable format ["WF_%1PARAVEHICARGO", _side], [0,0,50] ,_sideID, 0, false] call WFCO_FNC_CreateVehicle;
_cargoVehicle attachTo [_vehicle,[0,0,-3]];

while {true} do {
	sleep 1;
	if (!alive _pilot || !alive _vehicle || isNull _vehicle || isNull _pilot || !alive _cargoVehicle) exitWith {};
	if (!(isPlayer (leader _playerTeam)) || time - _timeStart > 500) exitWith {{_x setDammage 1} forEach (_cargo+[_pilot,_vehicle,_cargoVehicle]);deleteGroup _grp};
	_vehicleCoord = [getPos _pilot select 0,getpos _pilot select 1];
	_positionCoord = [_position # 0,_position # 1];
	if (_vehicleCoord distance _positionCoord < 100) exitWith {};
};

detach _cargoVehicle;

[_cargoVehicle,_side] spawn {
    params ["_vehicle", "_side"];
	private ['_chute'];

	sleep 2;
	if (!alive _vehicle) exitWith {};
	_chute = (missionNamespace getVariable format['WF_%1PARACHUTE',str _side]) createVehicle [0,0,20];
	_chute setPos [getPos _vehicle select 0, getPos _vehicle select 1, (getPos _vehicle select 2) - 11];
	_chute setDir (getDir _vehicle);
	_vehicle attachTo [_chute,[0,0,0]];
	waitUntil {getPos _vehicle select 2 < 10 || !alive _vehicle};
	detach _vehicle;
	sleep 10;
	deleteVehicle _chute;
};

[_grp,(_ranPos select _ran),"MOVE",10] call WFSE_fnc_aiMoveTo;

while {true} do {
	sleep 1;
	if (!alive _pilot || !alive _vehicle || isNull _vehicle || isNull _pilot) exitWith {};
	_vehicleCoord = [getPos _pilot select 0,getpos _pilot select 1];
	_positionCoord = [(_ranPos select _ran) select 0,(_ranPos select _ran) select 1];
	if (_vehicleCoord distance _positionCoord < 200) exitWith {};
};

deleteVehicle _pilot;
deleteVehicle _vehicle;
deleteGroup _grp;