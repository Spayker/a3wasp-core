params ["_buildingType", "_buildings", "_range", "_unit", ['_side', sideUnknown]];
private ["_checks","_closest"];

_closest = objNull;
_checks = [];


if(isHeadLessClient) then {
    _checks = [_side,missionNamespace getVariable format ["WF_%1%2",str _side,_buildingType],_buildings] call WFCO_FNC_GetFactories;
} else {
_logic = (WF_Client_SideJoined) Call WFCO_FNC_GetSideLogic;
_friendlySides = _logic getVariable ["wf_friendlySides", []];
{
    _side = _x;
    _checks = _checks + [_side,missionNamespace getVariable format ["WF_%1%2",str _side,_buildingType],_buildings] call WFCO_FNC_GetFactories;
    } forEach _friendlySides
};

if (count _checks > 0) then {
	_closest = [_unit,_checks] Call WFCO_FNC_GetClosestEntity;
	if (_unit distance _closest > _range) then {_closest = objNull};
};

_closest