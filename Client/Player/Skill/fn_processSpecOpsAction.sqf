/*
	Script: Spec Ops Skill System by Benny.
	Description: Add special skills to the defined spec ops unit.
*/
private ['_min','_ran','_vehicle','_vehicles','_forbiddenVehs','_z'];

_vehicles = player nearEntities [["Car","Motorcycle","Tank","Ship","Air"],5];
if (count _vehicles < 1) exitWith {};

if (isNil "WF_SK_V_LockpickChance") then {
	//--- Some units will have less troubles lockpicking than the others, negative means more chance
	WF_SK_V_LockpickChance = switch (WF_SK_V_Type) do {
		case WF_SPECOPS: {-20};
		default {0};
	};
};

_vehicle = [player,_vehicles] call WFCO_FNC_GetClosestEntity;

_forbiddenVehs = [];
{
    for '_i' from 0 to 3 do {
        _forbiddenVehs pushBack (((missionNamespace getVariable [format["WF_GUER_GROUPS_Air_%1_%2", _x, _i], [[""]]]) # 0) # 0);
        _forbiddenVehs pushBack (((missionNamespace getVariable [format["WF_EAST_GROUPS_Air_%1_%2", _x, _i], [[""]]]) # 0) # 0);
        _forbiddenVehs pushBack (((missionNamespace getVariable [format["WF_WEST_GROUPS_Air_%1_%2", _x, _i], [[""]]]) # 0) # 0);
    };
} forEach ["Light", "Heavy"];

if((typeOf _vehicle) in _forbiddenVehs) exitWith {
    [format["%1", localize "STR_WF_INFO_Lockpick_Forbidden"]] spawn WFCL_fnc_handleMessage;
};

if (locked _vehicle == 0) exitWith {};

WF_SK_V_LastUse_Lockpick = time;

for [{_z = 0},{_z < 5},{_z = _z + 1}] do {
	player playMove "Acts_carFixingWheel";
	sleep 5;
};

_min = 51;
switch (typeOf _vehicle) do {
	case "Motorcycle": {_min = 45};
	case "Car": {_min = 52};
	case "Tank": {_min = 53};
	case "Ship": {_min = 25};
	case "Air": {_min = 65};
};
_ran = ((random 100)- WF_SK_V_LockpickChance);

if (_ran >= _min) then {
	//--- Unlocked, gain experience.
	if (WF_SK_V_LockpickChance > -51) then {WF_SK_V_LockpickChance = WF_SK_V_LockpickChance - 1};
	[_vehicle, false] remoteExecCall ["WFSE_fnc_RequestVehicleLock",2];

	[format["%1", localize "STR_WF_INFO_Lockpick_Succeed"]] spawn WFCL_fnc_handleMessage
} else {
	[format["%1", localize "STR_WF_INFO_Lockpick_Failed"]] spawn WFCL_fnc_handleMessage
}