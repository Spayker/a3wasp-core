Params ['_unit', '_group', '_side'];
Private ["_entitie", "_group", "_side", "_unit"];

_units = (units group _unit) Call WFCO_FNC_GetLiveUnits;
//--- Be aware, if the unit that is changing group is the only one left, the join command will erase the group. We fix it by adding a "temp" unit before the join.
_sideId = _side call WFCO_FNC_GetSideID;

if ((count _units) < 2) then {_entitie = [missionNamespace getVariable Format ["WF_%1SOLDIER", _side], group _unit, [0,0,0], _sideId, false] Call WFCO_FNC_CreateUnit};
[_unit] join _group;

if !(isNull _entitie) then {deleteVehicle _entitie};