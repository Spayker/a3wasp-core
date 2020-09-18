private["_localize","_txt","_side"];

_side = side player;
_localize = _this select 0;
_commandChat = true;
_txt = "";

switch (_localize) do {
	case "BuildingTeamkill": {_txt = Format [Localize "STR_WF_CHAT_Teamkill_Building",_this select 1, _this select 2,
	    (missionNamespace getVariable format["WF_%1STRUCTUREDESCRIPTIONS", _side]) # (_this # 3)]};
	case "Teamswap": {_txt = Format [Localize "STR_WF_CHAT_Teamswap",_this select 1, _this select 2, _this select 3, _this select 4]};
	case "Teamstack": {_txt = Format [Localize "STR_WF_CHAT_Teamstack",_this select 1, _this select 2, _this select 3, _this select 4]};
	case "CommanderDisconnected": {_txt = Localize "strwfcommanderdisconnected"};
	case "TacticalLaunch": {_txt = Localize "STR_WF_CHAT_ICBM_Launch"};
	case "Teamkill": {_txt = Format [Localize "STR_WF_CHAT_Teamkill",(missionNamespace getVariable "WF_C_PLAYERS_PENALTY_TEAMKILL")]; -(missionNamespace getVariable "WF_C_PLAYERS_PENALTY_TEAMKILL") Call WFCL_FNC_ChangePlayerFunds};
	case "FundsTransfer": {_txt = Format [Localize "STR_WF_CHAT_FundsTransfer",_this select 1,_this select 2];_commandChat = false;};
	case "StructureSold": {_txt = Format [Localize "STR_WF_CHAT_Structure_Sold",
	    (missionNamespace getVariable format["WF_%1STRUCTUREDESCRIPTIONS", _side]) # (_this # 1)]};
	case "StructureSell": {_txt = Format [Localize "STR_WF_CHAT_Structure_Sell",
	    (missionNamespace getVariable format["WF_%1STRUCTUREDESCRIPTIONS", _side]) # (_this # 1), _this select 2]};
	case "SecondaryAward": {_txt = Format [Localize "STR_WF_CHAT_Secondary_Award",_this select 1, _this select 2];(_this select 2) Call WFCL_FNC_ChangePlayerFunds};

    case "HeadHunterReceiveBounty":
    {
        _killer_name = _this select 1; // _killer
        _bounty = _this select 2;
		_structure_side = _this select 4;
        _structure_kind = (missionNamespace getVariable format["WF_%1STRUCTUREDESCRIPTIONS", _structure_side]) # (_this # 3);        

        if ((name player) == _killer_name) then
        {
            _txt = format [localize "STR_WF_HeadHunterReceiveBounty", _bounty,
                _structure_kind];
            _bounty call WFCL_FNC_ChangePlayerFunds;
            _commandChat = false;
        }
        else
        {
            if (_side == _structure_side) then
            {
                _txt = format [localize "STR_WF_HeadHunterReceiveBountyFriendly", _killer_name, _bounty,
                    _structure_kind];
            }
            else
            {
                _txt = format [localize "STR_WF_HeadHunterReceiveBountyEnemy", _killer_name, _bounty,
                    _structure_kind];
            };
            _commandChat = true;
        };
    };

    case "BuildingKilledByError":
    {
        _structure_kind = _this select 1;
        _structure_side = _this select 2;

        if (_side == _structure_side) then
        {
            _txt = format [localize "STR_WF_BuildingKilledByErrorFriendly",
                (missionNamespace getVariable format["WF_%1STRUCTUREDESCRIPTIONS", _side]) # (_this # 1)];
        }
        else
        {
            _txt = format [localize "STR_WF_BuildingKilledByErrorEnemy",
                (missionNamespace getVariable format["WF_%1STRUCTUREDESCRIPTIONS", _side]) # (_this # 1)];
        };
        _commandChat = true;
    };

    case "PlayerStats":
    {
        private _playername = _this # 1;
        private _messages = _this # 2;

        {
            if(_forEachIndex == 0) then {
                //--Games count, total playing time, commanding time--
                _txt = format[localize (_x # 0), _playername, _x # 1, _x # 2, _x # 3];
            } else {
                _txt = format[". %1%2%3", _txt, localize (_x # 0), _x # 1];
            };
        } forEach _messages;

        _commandChat = true;
    };

	case "CommonText":
    {
        _txt = _this select 1;
		_txt = localize _txt;
		if(count _this == 3) then { _txt = format[_txt, _this # 2]; };
		if(count _this == 4) then { _txt = format[_txt, _this # 2, _this # 3]; };
		if(count _this == 5) then { _txt = format[_txt, _this # 2, _this # 3, _this # 4]; };
		if(count _this == 6) then { _txt = format[_txt, _this # 2, _this # 3, _this # 4, _this # 5]; };
		if(count _this == 7) then { _txt = format[_txt, _this # 2, _this # 3, _this # 4, _this # 5, _this # 6]; };

		_commandChat = true;
    };
};

if (_commandChat) then {
	_txt Call WFCL_FNC_CommandChatMessage;
} else {
	_txt Call WFCL_FNC_GroupChatMessage;
};