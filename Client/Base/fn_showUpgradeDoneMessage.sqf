Private ["_upgrade","_level"];
_upgrade = _this select 0;
_level = _this select 1;

[Format [Localize "STR_WF_CHAT_Upgrade_Complete_Message",(missionNamespace getVariable "WF_C_UPGRADES_LABELS") select _upgrade, _level]] spawn WFCL_fnc_handleMessage;

if !(isNull commanderTeam) then {
    if (commanderTeam == group player) then {
        [player, score player + (missionNamespace getVariable "WF_C_PLAYERS_COMMANDER_SCORE_UPGRADE")] remoteExecCall ["WFSE_fnc_RequestChangeScore",2];
    };
};