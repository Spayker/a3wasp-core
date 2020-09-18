params ["_name"];
private ["_votepopup"];

if(isNil "votePopUp") then {
    _votepopup = true;
} else {
    _votepopup = votePopUp;
};

if (_votepopup) then {
    waitUntil {!isNil {WF_Client_Logic getVariable "wf_votetime"}};
    if ((WF_Client_Logic getVariable "wf_votetime") > 0 && !voted) then {
        createDialog "WF_VoteMenu"
    };
    if (voted) then {voted = false};
};

if (isMultiplayer) then {[format[localize "STR_WF_CHAT_HasVotedForNewCommander", _name]] call WFCL_FNC_TitleTextMessage};