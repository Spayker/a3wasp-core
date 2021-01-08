/*
	Initialize a unit for clients (JIP Compatible).
*/

params ["_unit", "_sideID"];
private ["_get","_isMan","_logik","_side","_unit_kind"];

_unit_kind = typeOf _unit;

if !(alive _unit) exitWith {}; //--- Abort if the unit is null or dead.

waitUntil{!isNil "commonInitComplete"};
waitUntil {commonInitComplete}; //--- Wait for the common part.
_side = (_sideID) call WFCO_FNC_GetSideFromID;
_logik = (_side) call WFCO_FNC_GetSideLogic;

// --- [Generic Vehicle initialization] (Run on all clients AND server)
if !(local player) exitWith {}; //--- We don't need the server to process it.
if!(isHeadLessClient) then {
waitUntil {clientInitComplete}; //--- Wait for the client part.
};

_isMan = (_unit isKindOf 'Man');
// --- [Generic Vehicle initialization] (Run on all clients)

if(_isMan) then {
    if ((missionNamespace getVariable "WF_C_GAMEPLAY_FATIGUE_ENABLED") == 1) then {
        _unit enableFatigue true;
        _unit enableStamina true
    } else {
        _unit enableFatigue false;
        _unit enableStamina false
    }
};

if(local _unit && !(_unit hasWeapon "CUP_NVG_PVS14_Hide_WASP")) then {
	_unit addWeapon "CUP_NVG_PVS14_Hide_WASP";
};
