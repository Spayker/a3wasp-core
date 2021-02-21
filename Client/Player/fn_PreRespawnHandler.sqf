Private ["_hq","_unit"];

_unit = _this;

(_unit) Call WFCL_fnc_applySkill;

if (!isNull commanderTeam) then {
	_mhqs = (WF_Client_SideJoined) Call WFCO_FNC_GetSideHQ;
    _hqs = [player,_mhqs] call WFCO_FNC_GetClosestEntity;
	if (commanderTeam == group _unit) then {
		HQAction = _unit addAction [localize "STR_WF_BuildMenu",{call WFCL_fnc_callBuildMenu}, [_hqs], 1000, false, true, "", "hqInRange && canBuildWHQ && (_target == player)"];
	};
};

// adjusting fatigue
if ((missionNamespace getVariable "WF_C_GAMEPLAY_FATIGUE_ENABLED") == 1) then {
    player setCustomAimCoef 0.35;
    player setUnitRecoilCoefficient 0.75;
    player enablestamina false;
};

[WF_Client_SideJoinedText,'UnitsCreated',1] Call WFCO_FNC_UpdateStatistics;