//------------------fn_baseBuildingRepAction--------------------------------------------------------------------------//
//	                                                                                                                  //
//------------------fn_baseBuildingRepAction--------------------------------------------------------------------------//
params ["_target", "_caller"];
private ["_currentHealth", "_maxHealth", "_totalFixed", "_side", "_index", "_diff"];

_side = side _caller;
_index = (missionNamespace getVariable format ["WF_%1STRUCTURENAMES", _side]) find (typeOf _target);

_totalFixed = 0;
_maxHealth = (missionNamespace getVariable format ["WF_%1STRUCTUREMAXHEALTH", _side]) # _index;
_currentHealth = _target getVariable ["wf_site_health", 0];

diag_log _currentHealth;

if(_currentHealth >= _maxHealth) exitWith {};

for [{_z = 0},{_z < 25},{_z = _z + 1}] do {
    _currentHealth = _target getVariable ["wf_site_health", 0];
	_caller playMove "Acts_carFixingWheel";
	if (!alive _caller || vehicle _caller != player || !alive _target
	    || _target distance _caller > 10 || _currentHealth <= 0 || _currentHealth >= _maxHealth) exitWith {};

    _diff = _maxHealth - _currentHealth;
    if(_diff > 100) then {
        _diff = 100;
    };

    if((_side call WFCO_FNC_GetSideSupply) < _diff) exitWith {};

    _totalFixed = _totalFixed + _diff;
    _target setVariable ["wf_site_health", _currentHealth + _diff, true];
    [_side, - (_diff / 10)] call WFCO_FNC_ChangeSideSupply;

	sleep 1;
};

["CommonText", "STR_WF_BaseBuildingRepaired", name _caller,
    (missionNamespace getVariable format ["WF_%1STRUCTURES", _side]) # _index,
    _totalFixed, _totalFixed / 10] remoteExec ["WFCL_FNC_LocalizeMessage", _side];