private["_lastCommanderTeam","_changeCommander"];

_lastCommanderTeam = commanderTeam;
_changeCommander = false;
_repHQAction = nil;

	commanderTeam = (WF_Client_SideJoined) Call WFCO_FNC_GetCommanderTeam;
	if (IsNull commanderTeam && !IsNull _lastCommanderTeam) then {_changeCommander = true};
	if (!IsNull commanderTeam && IsNull _lastCommanderTeam) then {_changeCommander = true};
	if (!isNull commanderTeam && !isNull _lastCommanderTeam) then {
		if (commanderTeam != _lastCommanderTeam) then {_changeCommander = true};
	};

_isConstructionMenuRunning = player getVariable ["bis_coin_logic",nil];
if(isNil "_isConstructionMenuRunning") then {

		_lastCommanderTeam = commanderTeam;
_mhqs = (WF_Client_SideJoined) Call WFCO_FNC_GetSideHQ;
_MHQ = [player,_mhqs] call WFCO_FNC_GetClosestEntity;


    if (IsNull _lastCommanderTeam) then {
			if (!IsNull _MHQ) then {
				_MHQ RemoveAction 0;
				_MHQ RemoveAction 1;
				_MHQ RemoveAction 2;
				_MHQ RemoveAction 3;
			};
			if (!isNil "HQAction") then {player removeAction HQAction};
		};

    if (!isNull(_lastCommanderTeam)) then {
        if (_lastCommanderTeam == Group player) then {
            if(_changeCommander) then {
                _changeCommander = false;
				if (!IsNull _MHQ) then {
					_MHQ addAction [localize "STR_WF_Unlock_MHQ",{call WFCL_fnc_toggleLock}, [], 95, false, true, '', 'alive _target && (locked _target == 2)',10];
					_MHQ addAction [localize "STR_WF_Lock_MHQ",{call WFCL_fnc_toggleLock}, [], 94, false, true, '', 'alive _target && (locked _target == 0)',10];
                };
                ["INFORMATION", Format ["Player %1 has become a new commander in %2 team).", name player, side player]] Call WFCO_FNC_LogContent;

        player removeAction HQAction;
				HQAction = leader(group player) addAction [localize "STR_WF_BuildMenu",{call WFCL_fnc_callBuildMenu}, [_MHQ], 1000, false, true, "", "hqInRange && canBuildWHQ && (_target == player)"];
            };
			} else {
				if (!isNil "HQAction") then {player removeAction HQAction};
        }
    }
}


