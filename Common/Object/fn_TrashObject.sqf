/*
	Trash an entity. Groups can only be removed once that all it's units are DELETED!
	 Parameters:
		- Object.
*/

private ["_delay","_group","_isMan","_object","_crew"];

_object = _this;

if !(isNull _object) then {
	_isMan = (_object isKindOf "Man");

	_group = [grpNull, group _object] select (_isMan);

	_delay = missionNamespace getVariable ["WF_C_UNITS_CLEAN_TIMEOUT", 120];

	sleep _delay;

    if !(isNull _object) then {
        ["INFORMATION", Format["fn_TrashObject.sqf: Deleting [%1], it has been [%2] seconds.", _object, _delay]] Call WFCO_FNC_LogContent;

        if (_isMan) then {
            if (!isNull (objectParent _object)) then {
                (objectParent _object) deleteVehicleCrew _object;
            } else {
                deleteVehicle _object;
            };

            if !(isNull _group) then {
                if (isNil {_group getVariable "wf_persistent"}) then {if (count (units _group) <= 0) then {deleteGroup _group}};
            };
        } else {
            _crew = crew _object;
            if (count _crew > 0) then {
                {
                    ["INFORMATION", Format["fn_TrashObject.sqf: Deleting crew unit [%1] of trashed object [%2].", _x, _object]] Call WFCO_FNC_LogContent;
                    _object deleteVehicleCrew _x;
                } forEach _crew;
            };
        
            deleteVehicle _object;
        };
    };
};