params ["_type", "_position", "_sideId", "_direction", "_locked", ["_bounty", true], ["_global", true], ["_special", "NONE"], ["_description", ""]];
private ["_vehicle", "_unitskin"];

if (typeName _position == "OBJECT") then {_position = getPosATL _position};
if (typeName _sideId == "SIDE") then {_sideId = (_sideId) call WFCO_FNC_GetSideID};

if (_special == "FLY") then {
    _vehicle = createVehicle [_type, _position, [], 7, _special];
} else {
    _vehicle = createVehicle [_type, [_position # 0, _position # 1, 0.5], [], 10, _special];
    _vehicle removeAllEventHandlers "HandleDamage";
    _vehicleHandleDamageEventHandler = _vehicle addEventHandler ["HandleDamage", {false}];
    [_vehicle, _vehicleHandleDamageEventHandler]  spawn {
        params["_vehicle", "_eventHandler"];
        _vehicle allowDamage false;
        sleep 15;
        _vehicle removeEventHandler ["HandleDamage", _eventHandler];
        _vehicle allowDamage true;
    }
};

_vehicle setVectorUp surfaceNormal position _vehicle;

_vehicle spawn WFCO_FNC_BalanceInit;

//--Check the need for vehicle re-equip--
for "_x" from 0 to ((count WF_C_AIR_VEHICLE_TO_REQUIP) - 1) do
{	
	_currentElement = WF_C_AIR_VEHICLE_TO_REQUIP # _x;
	if ((typeOf _vehicle) in _currentElement || _description in _currentElement) exitWith {		
		[_vehicle, _currentElement # 1] call WFCO_FNC_Requip_AIR_VEH;
	};	
};

if (_special == "FLY") then {
	_vehicle setVelocity [50 * (sin _direction), 50 * (cos _direction), 0];
};

_vehicle setDir _direction;

_unitskin = -1;
_type = typeOf _vehicle;
_vehicleCoreArray = missionNamespace getVariable [_type, []];
if((count _vehicleCoreArray) > 10) then { _unitskin = _vehicleCoreArray # 10 };

[_vehicle, _sideId, _locked, true, _global, _unitskin] spawn WFCO_FNC_InitVehicle;

["INFORMATION", Format ["fn_CreateVehicle.sqf: [%1] Vehicle [%2] was created at [%3].", _sideId Call WFCO_FNC_GetSideFromID, _type, _position]] Call WFCO_FNC_LogContent;

_vehicle