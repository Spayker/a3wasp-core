//--- Register the UI.
uiNamespace setVariable ["wf_display_vote", _this select 0];

_u = 1;
lnbClear 509100;
lnbAddRow[509100, ["AI Commander", "0"]];
lnbSetValue[509100, [0, 0], -1];
for '_i' from 0 to count(WF_Client_Teams)-1 do {
	if (isPlayer leader (WF_Client_Teams select _i)) then {
		lnbAddRow[509100, [name leader (WF_Client_Teams select _i), "0"]];
		lnbSetValue[509100, [_u, 0], _i];
		_u = _u + 1;
	};
};

WF_MenuAction = -1;
_voteArray = [];
_index = 0;
_voted_commander = "AI Commander";
while {alive player && dialog} do {

	//--- The client has selected a new com.
	if (WF_MenuAction == 1) then {
		WF_MenuAction = -1;
		_index = lnbCurSelRow 509100;
	};

	if (WF_MenuAction == 2) then{
		WF_MenuAction = -1;

		_player_name = lnbText [509100,[_index, 0]];

		{
			if (isPlayer leader _x) then {
				if(_player_name == name leader (_x)) exitWith {
					_voted_commander =  group leader (_x);
				};
				if(_player_name == "AI Commander") exitWith {
					_voted_commander = objNull;
				};
			};
		} forEach WF_Client_Teams;

		[side player, _voted_commander] remoteExecCall ["WFSE_fnc_RequestNewCommander",2];
		voted = true;
		closeDialog 0;
	};

	_list_present = [];
	for '_i' from 1 to ((lnbSize 509100) select 0)-1 do { //--- Remove potential non-player controlled slots.
		_value = lnbValue [509100,[_i, 0]];
		_team = WF_Client_Teams select _value;
		if !(isPlayer leader _team) then {lnbDeleteRow [509100, _i]} else {_list_present pushBack _value};
	};

	for '_i' from 0 to WF_Client_Teams_Count do { //--- Add potential new player controlled slots.
		_team = WF_Client_Teams select _i;
		if(!(isNil "_team"))then{
			if (isPlayer leader _team && !(_i in _list_present)) then {
				lnbAddRow[509100, [name leader _team, "0"]];
				lnbSetValue[509100, [((lnbSize 509100) select 0)-1, 0], _i];
			};
		};
	};
	sleep 0.05;
};

//--- Release the UI.
uiNamespace setVariable ["wf_display_vote", nil];