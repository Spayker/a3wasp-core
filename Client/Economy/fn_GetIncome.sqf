Private["_commanderTeam","_income","_incomeSystem","_side","_ply"];

_side = _this;

_income = (_side) Call WFCO_FNC_GetTownsIncome;
_commanderTeam = (_side) Call WFCO_FNC_GetCommanderTeam;
_income_commander = 0;
_income_player = 0;
_incomeCoef = missionNamespace getVariable "WF_C_ECONOMY_INCOME_COEF";
_divisor = missionNamespace getVariable "WF_C_ECONOMY_INCOME_DIVIDED";

if (isNull _commanderTeam) then {_commanderTeam = grpNull};

_logik = (_side) Call WFCO_FNC_GetSideLogic;
_team_count = (_logik getVariable "wf_teams_count");
					
_commanderPercent = missionNamespace getVariable "wf_commander_percent";
			
_income_player = round(_income + ((_income / 100) * (100 - _commanderPercent)));
_income_commander = round(((_income * _incomeCoef) / 100) * _commanderPercent);

if (_commanderTeam == group player) then {
	_income = _income_commander
} else {
	_income = _income_player
};

_income