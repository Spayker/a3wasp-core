params ["_unit"];
private ["_vehicles","_range", "_vehicle"];

_vehicle = objNull;
_range = missionNamespace getVariable "WF_C_NEAREST_VEHICLE_RANGE";

if(!(isNil "_unit") && (alive _unit)) then {
	//--- Attempt to get a nearby camp.
	_vehicles = nearestObjects [_unit, WF_C_VEHICLE_KINDS, _range, true];

	//--- Only get the alive towers
	{
		if (!alive _x) then {_vehicles deleteAt _forEachIndex}
	} forEach _vehicles;

	if (count _vehicles > 0) then { _vehicle = _vehicles # 0 }
};

_vehicle