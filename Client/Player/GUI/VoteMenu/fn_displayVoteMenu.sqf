//--- Register the UI.
uiNamespace setVariable ["wf_display_vote", _this # 0];

//--Update list of candidates--
private _updateCandidatesList = {
    lnbClear 500100;

    _votes = missionNamespace getVariable ["WF_VOTES", []];
    _votesAI = 0;

    //--Extract AI votes--
    {
        if(_x # 0 == "") exitWith {
            _votesAI = _x # 1;
        };
    } forEach _votes;

    lnbAddRow[500100, ["AI Commander", str(_votesAI)]];
    {
        _uid = _x # 0;
        _votesCount = 0;

        {
            if(_x # 0 == _uid) exitWith {
                _votesCount = _x # 1;
            };
        } forEach _votes;
        lnbAddRow[500100, [_x # 1, str(_votesCount)]];
        lnbSetData[500100, [_forEachIndex + 1, 0], _x # 0];
    } forEach (missionNamespace getVariable [format["WF_PLAYERS_%1", WF_Client_SideJoined], []]);
};

WF_MenuAction = -1;

while { alive player && dialog } do {
	_voteTime = WF_Client_Logic getVariable "wf_votetime";

	//--- Exit when the timeout is reached.
	if (_voteTime < 0) exitWith {closeDialog 0};

	0 = [] call _updateCandidatesList;

	//--- The client has voted for x.
	if (WF_MenuAction == 1) then {
		WF_MenuAction = -1;
		_votedFor = lnbData [500100,[lnbCurSelRow 500100, 0]];
		[WF_Client_SideJoined, getPlayerUID player, _votedFor] remoteExecCall ["WFSE_FNC_passVote",2];
	};

	ctrlSetText [500102, Format ["%1", floor _voteTime]];

	uiSleep 0.1;
};

//--- Release the UI.
uiNamespace setVariable ["wf_display_vote", nil];