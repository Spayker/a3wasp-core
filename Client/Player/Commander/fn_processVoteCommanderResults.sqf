params ["_commander"];
private ["_text"];

_text = localize "STR_WF_CHAT_AI_Commander";

if (!isNull _commander) then {
    _text = format[localize "STR_WF_CHAT_VoteForNewCommander", name _commander];
    if (player == _commander) then {_text = localize "STR_WF_CHAT_PlayerCommander"}
};

[_text] spawn WFCL_fnc_handleMessage