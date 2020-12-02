params ["_side", "_position"];

sleep 30;
_objectsToFind = WF_C_GARBAGE_OBJECTS + WF_C_STATIC_DEFENCE_FOR_COMPOSITIONS;
_objects = nearestObjects [_position, _objectsToFind, 150];

{
    if (_x isKindOf "StaticWeapon") then {
        _unit = gunner _x;
        if (alive _unit) then { deleteVehicle _unit }
    };
    deleteVehicle _x
} forEach _objects