params ["_buildingType", "_buildings", "_range", "_side", "_unit"];
private ["_checks","_closest"];

_closest = objNull;

_checks = [_side,missionNamespace getVariable format ["WF_%1%2",str _side,_buildingType],_buildings] call WFCO_FNC_GetFactories;
if (count _checks > 0) then {
	_closest = [_unit,_checks] Call WFCO_FNC_GetClosestEntity;
	if (_unit distance _closest > _range) then {_closest = objNull};
};

_closest