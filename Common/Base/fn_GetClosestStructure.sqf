private ["_closest"];
params ["_type", "_center", "_structures", ["_distance", 0]];

_closest = objNull;
_structures = [_type, _structures] call WFCO_FNC_GetSideStructuresByType;

if (count _structures > 0) then { _closest = [_center, _structures] call WFCO_FNC_GetClosestEntity };

if (_distance > 0 && _closest distance _center > _distance) then { _closest = objNull };

_closest