params ["_team","_side","_uid","_isteamAdding"];
private["_teams", "_sideJoined", "_logic", "_needToAdd"];

_sideJoined = side player;
_logic = nil;

waitUntil { !isNil "commonInitComplete" };
waitUntil { commonInitComplete };

if(_sideJoined == _side) then {
	while {isNil "_logic"} do {
		_logic = _sideJoined Call WFCO_FNC_GetSideLogic; 
		if (isNil "_logic") then {sleep 1};
	};

	_teams = _logic getVariable ["wf_teams", []];
	_teams pushBackUnique _team;
	{
		if !(isNil '_x') then {
            Private ["_group"];
            _group = nil;
            if (typeName _team == "OBJECT") then {
                _group = group _team
            } else {
                _group = group (leader _team)
            };

            if(_team == _group)then{
                _group setVariable ["wf_side", _side];
                _group setVariable ["wf_persistent", true];
                _group setVariable ["wf_queue", []];
                _group setVariable ["wf_vote", -1, true];
                _group setVariable ["wf_uid", _uid];
                _group setVariable ["wf_teamleader", leader _group];
            };
		};
	} forEach (_teams);
	
	_logic setVariable ["wf_teams", _teams, true];
	_logic setVariable ["wf_teams_count", count _teams];
	
	missionNamespace setVariable [Format["WF_%1TEAMS",_sideJoined], _logic getVariable "wf_teams", true];
	WF_Client_Teams = missionNamespace getVariable Format['WF_%1TEAMS',_sideJoined];
	WF_Client_Teams_Count = count WF_Client_Teams;
};