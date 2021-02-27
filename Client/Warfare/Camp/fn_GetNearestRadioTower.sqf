params ["_unit"];
private ["_towers","_range", "_tower"];

_tower = objNull;
_range = missionNamespace getVariable "WF_C_RADIO_TOWER_RANGE";

if(!(isNil "_unit") && (alive _unit)) then {
	//--- Attempt to get a nearby camp.
	_towers = nearestObjects [_unit, WF_C_RADIO_OBJECTS, _range, true];

	//--- Only get the alive towers
	{
		if (!alive _x) then {_towers deleteAt _forEachIndex}
	} forEach _towers;

	if (count _towers > 0) then {
	    _tower = _towers # 0;
	    _newSID = WF_Client_SideJoined Call WFCO_FNC_GetSideID;
	    _tower setVariable ["sideID",_newSID,true];
	};


};

_tower