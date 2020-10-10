Private ["_upgrade","_level"];

_upgrade = _this select 0;
_level = _this select 1;

if (!isNull(commanderTeam)) then {
    if (commanderTeam != group player) then {
        _message = Format [Localize "STR_WF_CHAT_Upgrade_Started_Message",(missionNamespace getVariable "WF_C_UPGRADES_LABELS") select _upgrade, _level];
        [_message] spawn WFCL_fnc_handleMessage
    }
}