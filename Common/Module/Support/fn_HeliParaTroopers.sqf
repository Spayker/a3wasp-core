private['_bd','_built','_built_inf','_currentLevel','_currentUpgrades','_destination','_greenlight','_vehicleGrp',
    '_paratroopers','_playerTeam','_closestStartPos','_side','_sideID','_units',
    '_vehicle','_vehicle_cargo','_vehicle_model'];
params ["_side","_destination","_playerTeam", ["_allowedGroupSize", 10]];

if (isServer) exitWith {
    _hc = missionNamespace getVariable ["WF_HEADLESSCLIENT_ID", 0];
    if(_hc > 0) then {
        ["INFORMATION", Format["fn_HeliParaTroopers.sqf: delegating heli para troopers request to hc - %1", _hc]] Call WFCO_FNC_LogContent;
        [_side, _destination, _playerTeam, _allowedGroupSize] remoteExec ["WFCO_FNC_HeliParatroopers",_hc]
    }
};

_sideID = _side Call WFCO_FNC_GetSideID;
_greenlight = false;

["INFORMATION", Format["fn_HeliParaTroopers.sqf : [%1] Team [%2] has requested heli paratroopers.", _side, _playerTeam]] Call WFCO_FNC_LogContent;

//--- Determine a random spawn location.
_startPosArray = [];
_bd = missionNamespace getVariable 'WF_BOUNDARIESXY';
if !(isNil '_bd') then {
    _startPosArray = [
        [0+random(200),0+random(200),15],
        [0+random(200),_bd-random(200),15],
        [_bd-random(200),_bd-random(200),15],
        [_bd-random(200),0+random(200),15]
    ];
} else {
    _startPosArray = [[0+random(200),0+random(200),15],[500+random(20),0+random(200),15]];
};

//--- Get the units and the air vehicle, exit if nil.
_currentUpgrades = (_side) Call WFCO_FNC_GetSideUpgrades;
_currentLevel = _currentUpgrades select WF_UP_PARATROOPERS;
_units = missionNamespace getVariable Format ["WF_%1PARACHUTELEVEL%2", str _side, _currentLevel];
_vehicle_model = missionNamespace getVariable Format ["WF_%1PARACARGO_HELI", str _side];

if (isNil '_units' || isNil '_vehicle_model') exitWith {["ERROR", Format["Support_Paratroopers.sqf : [%1] Paratrooping vehicle or units are not defined.", _side]] Call WFCO_FNC_LogContent};

//--- Determine how many vehicles do we need.
_vehicle_cargo = getNumber(configFile >> 'CfgVehicles' >> _vehicle_model >> 'transportSoldier');
if (_vehicle_cargo == 0) exitWith {["ERROR", Format["Support_Paratroopers.sqf : [%1] Paratrooping vehicle [%2] has no cargo capacity.", _side, _vehicle_model]] Call WFCO_FNC_LogContent};

//--- Create the vehicles.
_distance = 100000;
{
    _currentDistance = _x distance _destination;
    if (_currentDistance < _distance) then {_closestStartPos = _x;_distance = _currentDistance;};
} forEach _startPosArray;

_vehicleGrp = createGroup [_side, true];

//--- Spawn the vehicle.
_vehicleArray = [_closestStartPos, 0, missionNamespace getVariable Format["WF_%1PARACARGO_HELI", _side], _vehicleGrp] call bis_fnc_spawnvehicle;
_vehicle = _vehicleArray # 0;
{
    [_x, typeOf _x,_vehicleGrp,_closestStartPos,_sideID] spawn WFCO_FNC_InitManUnit;
    _x setUnitLoadout (missionNamespace getVariable Format ['WF_%1PILOT',_side]);
} forEach crew _vehicle;
[_vehicle, _sideID, false, true, true, -1] call WFCO_FNC_InitVehicle;
[_vehicle, _sideID] remoteExec ["WFCO_FNC_initUnit"];

//--- Spawn the pilot.
_pilot = driver _vehicle;
_waypoint = _vehicleGrp addWaypoint [_destination,0];
_waypoint setWayPointBehaviour "CARELESS";
_waypoint setWayPointSpeed "FULL";
_waypoint setWayPointType "MOVE";
_waypoint setWaypointStatements ["true", "[vehicle this, 15, [(getPosASL this) # 0, (getPosASL this) # 1, ((getPosASL this) # 2) - 30] ] call AR_Rappel_ALL_Cargo;"];

_vehicleGrp setBehaviour 'COMBAT';
_vehicleGrp setCombatMode 'RED';
{_pilot disableAI _x} forEach ["AUTOTARGET","TARGET"];

//--- Tell the group to move.
_built = 0;
_built = _built + 1;
_vehicle lockDriver true;
[str _side, 'VehiclesCreated', _built] Call WFCO_FNC_UpdateStatistics;

//--- Create the units.
_built_inf = 0;
_paratroopers = [];
_paraGroup = createGroup [_side, true];
{
    if (_built_inf <= _vehicle_cargo && _built_inf <= _allowedGroupSize) then {
        //--- Spawn the unit.
        _unit = [_x, _paraGroup, [100,12000,0], _sideID] Call WFCO_FNC_CreateUnit;
        _unit moveInCargo _vehicle;
        _built_inf = _built_inf + 1;
        _paratroopers pushBack _unit;

        //--- If the unit amount exceed the cargo cap, swap to the next vehicle then.
        _built = _built + 1; _built_inf = 0;
    };
} forEach _units;

[str _side,'UnitsCreated', _built] Call WFCO_FNC_UpdateStatistics;

//--- Tell the group to move.
_vehicleGrp setCurrentWaypoint [_vehicleGrp, 1];

while {!_greenlight} do {
    if ((vehicle (leader _paraGroup) == leader _paraGroup)) exitWith { _greenlight = true};
    sleep 3;
};

//--- Units are ready to bail!
if (_greenlight) then {
    {
        [_x] join (leader _playerTeam);
        sleep 0.8;
    } forEach _paratroopers;
    //--- Once done, the air units can fly back to their source.
    sleep 15;
    [_vehicleGrp, _closestStartPos, "MOVE", 5] Call WFSE_fnc_aiMoveTo;

    //--- Loop until death or arrival.
    while {true} do {
        sleep 5;
        if (!alive _vehicle) exitWith { };//--- Vehicle destruction.
        if (!alive driver _vehicle) exitWith { };//--- Pilots are dead.
        _vehicleCoord = [(getPosASL _vehicle) # 0, (getPosASL _vehicle) # 1];
        if (_vehicleCoord distance _closestStartPos < 300) exitWith { };//--- Destination reached.
    };
};

//--- In any case, cleanup the transporters.
{deleteVehicle _x} forEach crew _vehicle;//--- Remove the crew.
deleteVehicle _vehicle;//--- Remove the vehicle.
//---- Clear the group.
deleteGroup _vehicleGrp;