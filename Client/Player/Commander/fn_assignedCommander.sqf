Private["_commanderTeam","_text"];

_commanderTeam = _this select 0;
_text = Localize "STR_WF_CHAT_AI_Commander";

if (!isNull _commanderTeam) then {
    _text = Format[localize "STR_WF_CHAT_VoteForNewCommander",name (leader _commanderTeam)];
    if (group player == _commanderTeam) then {_text = localize "STR_WF_CHAT_PlayerCommander"};
}else{
    _logic = (side player) Call WFCO_FNC_GetSideLogic;
    _logic setVariable ["wf_commander", _commanderTeam, true];
};

[_text] spawn WFCL_fnc_handleMessage;