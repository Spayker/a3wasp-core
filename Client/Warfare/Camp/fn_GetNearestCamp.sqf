params ["_unit"];
private ["_camps","_range","_temp", "_camp"];

_camp = objNull;
_range = missionNamespace getVariable "WF_C_CAMPS_RANGE";

if(!(isNil "_unit") && (alive _unit)) then {
	//--- Attempt to get a nearby camp.
	_camps = nearestObjects [_unit, WF_C_CAMP_SEARCH_ARRAY, _range, true];

	//--- Only get the "real" camps, remove the possible undefined ones.
	_temp = _camps;
	{
		if (isNil {_x getVariable 'sideID'}) then {_camps deleteAt _forEachIndex};
	} forEach _temp;

	if (count _camps > 0) then {
	    //--- Get the closest camp then.
	    _camp = _camps # 0
	};
};

_camp