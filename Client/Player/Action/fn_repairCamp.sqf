/*
	The client or an AI attempt to repair a camp.
	  todo, action can be reused after x time.
*/

params ["_unit"];
private ["_camp","_camp_sideID","_camps","_delay","_range","_temp","_townModel"];

_vehicle = vehicle _unit;
_range = missionNamespace getVariable "WF_C_CAMPS_REPAIR_RANGE";

//--- Attempt to get a nearby camp.
_camps = nearestObjects [_vehicle, [WF_C_CAMP], _range];

//--- Only get the "real" camps, remove the possible undefined ones.
_temp = _camps;
{
	if (isNil {_x getVariable 'sideID'}) then {_camps deleteAt _forEachIndex};
} forEach _temp;

//--- Make sure that there is at least one camp nearby, abort otherwise.
if (count _camps == 0) exitWith {
    [format["%1", localize "STR_WF_Repair_Camp_None"]] spawn WFCL_fnc_handleMessage
};

//--- Now, we need to check if one of those camp is destroyed at least, remove the living ones.
_temp = _camps;
{
	if (!isObjectHidden _x) then {_camps deleteAt _forEachIndex};
} forEach _temp;

//--- If we have no repairable camps in range, abort with a message.
if (count _camps == 0) exitWith {
    [(parseText (localize "STR_WF_Repair_Camp_None_Dead"))] spawn WFCL_fnc_handleMessage;
};

//--- Check if the repair is free or if it need to be paid.
if ((missionNamespace getVariable "WF_C_CAMPS_REPAIR_PRICE") > 0) then {
	//--- Check that the player has enough funds for a repair.
	if ((Call WFCL_FNC_GetPlayerFunds) < (missionNamespace getVariable "WF_C_CAMPS_REPAIR_PRICE")) exitWith {
        [Format [localize "STR_WF_Repair_Camp_NoFunds", (missionNamespace getVariable "WF_C_CAMPS_REPAIR_PRICE") - (Call WFCL_FNC_GetPlayerFunds)]] spawn WFCL_fnc_handleMessage
	};

	//--- Purchase a repair.
	-(missionNamespace getVariable "WF_C_CAMPS_REPAIR_PRICE") Call WFCL_FNC_ChangePlayerFunds;
};
	
//--- Get the closest camp then.
_camp = [_vehicle, _camps] Call WFCO_FNC_GetClosestEntity;

[format["%1", localize "STR_WF_Repair_Camp_IsBeingRepaired"]] spawn WFCL_fnc_handleMessage;

//--- Begin the repair.
_delay = missionNamespace getVariable "WF_C_CAMPS_REPAIR_DELAY";

while {_delay > 0} do {
	if (!alive _vehicle || !isObjectHidden _camp || (_vehicle distance _camp > _range)) exitWith {};
	
	sleep 1;
	_delay = _delay - 1;
}; 

if (!(alive _vehicle) || (_vehicle distance _camp > _range)) exitWith {
    [format["%1", localize "STR_WF_Repair_TruckIsDeadOrTooFar"]] spawn WFCL_fnc_handleMessage
};

if (!isObjectHidden _camp) exitWith {
	[format["%1", localize "STR_WF_Repair_Camp_IsAlive"]] spawn WFCL_fnc_handleMessage;
	//--- Refunds the player.
	(missionNamespace getVariable "WF_C_CAMPS_REPAIR_PRICE") Call WFCL_FNC_ChangePlayerFunds;
};

//--- Repair order is sent to the server.
[_camp, WF_Client_SideID] remoteExecCall ["WFSE_FNC_repairCamp",2];

[format["%1", localize "STR_WF_Repair_Camp_IsRepaired"]] spawn WFCL_fnc_handleMessage