private ["_confirm","_cost","_skillDetails"];

_isAutomaticReset = _this select 0;
WF_resetRoleRequest = true;

if(!_isAutomaticReset)then{
    _confirm = [
        "Please confirm reset of your current role?",
        "RESET ROLE?",
        "Yes, RESET",
        "No, WAIT"
    ] call BIS_fnc_guiMessage;

    if (!_confirm) exitWith {false};
};

ctrlEnable[2804, false];
ctrlEnable[2805, false];
hint "Refreshing your role, please wait..";

[player, WF_gbl_boughtRoles select 0] remoteExecCall ["WFSE_fnc_resetRoles", 2];
true