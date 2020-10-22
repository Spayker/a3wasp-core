params ["_side", "_casPosition", "_playerTeam"];
private['_bd', '_built', '_currentUpgrades', '_casPosition', '_closestStartPos', '_greenlight',
    '_playerTeam', '_side', '_sideID', '_vehicle','_vehicle_cargo'];

if (isServer) exitWith {
    _hc = missionNamespace getVariable ["WF_HEADLESSCLIENT_ID", 0];
    if(_hc > 0) then {
        ["INFORMATION", Format["fn_CasRequest.sqf: delegating cas request to hc - %1", _hc]] Call WFCO_FNC_LogContent;
        [_side, _casPosition, _playerTeam] remoteExec ["WFCO_FNC_casRequest",_hc]
    }
};

_sideID = _side Call WFCO_FNC_GetSideID;
_greenlight = false;

["INFORMATION", Format["fn_CasRequest.sqf: [%1] Team [%2] has requested CAS.", _side, _playerTeam]] Call WFCO_FNC_LogContent;

//--- Determine a random spawn location.
_startPosArray = [];
_bd = missionNamespace getVariable 'WF_BOUNDARIESXY';
if !(isNil '_bd') then {
    _startPosArray = [
        [0+random(200),0+random(200),250],
        [0+random(200),_bd-random(200),250],
        [_bd-random(200),_bd-random(200),250],
        [_bd-random(200),0+random(200),250]
    ];
} else {
    _startPosArray = [[0+random(200),0+random(200),250],[500+random(20),0+random(200),250]];
};

//--- Create the vehicles.
_distance = 100000;
{
    _currentDistance = _x distance _casPosition;
    if (_currentDistance < _distance) then {_closestStartPos = _x;_distance = _currentDistance;};
} forEach _startPosArray;

_vehicleGrp = createGroup [_side, true];

//--- Spawn the vehicle.
_vehicleArray = [_closestStartPos, 0, missionNamespace getVariable Format["WF_%1CAS_HELI", _side], _vehicleGrp] call bis_fnc_spawnvehicle;
_vehicle = _vehicleArray # 0;
{
    [_x, typeOf _x,_vehicleGrp,_closestStartPos,_sideID] spawn WFCO_FNC_InitManUnit;
    _x setUnitLoadout (missionNamespace getVariable Format ['WF_%1PILOT',_side]);
} forEach crew _vehicle;
[_vehicle, _sideID, false, true, true, -1] call WFCO_FNC_InitVehicle;
[_vehicle, _sideID] remoteExec ["WFCO_FNC_initUnit"];

//--- Spawn the pilot.
_pilot = driver _vehicle;
_waypoint = _vehicleGrp addWaypoint [_casPosition,0];
_waypoint setWayPointBehaviour "CARELESS";
_waypoint setWayPointSpeed "FULL";
_waypoint setWayPointType "SAD";
_vehicleGrp setBehaviour 'COMBAT';
_vehicleGrp setCombatMode 'RED';

//--- Tell the group to move.
_built = 0;
_built = _built + 1;
_vehicle lockDriver true;
[str _side, 'VehiclesCreated', _built] Call WFCO_FNC_UpdateStatistics;

//--- Create the units.
_paraGroup = createGroup [_side, true];

[str _side,'UnitsCreated', _built] Call WFCO_FNC_UpdateStatistics;

//--- Tell the group to move.
_vehicleGrp setCurrentWaypoint [_vehicleGrp, 1];
_vehicle flyInHeight 250;

sleep 900;

if !(isNull _vehicle) then {
    if (alive _vehicle) then {
        _greenlight = true;

        if (_greenlight) then {
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
    }
}

















