/* Elements to sort etc ... */

_preformat = {
	private ["_get","_output","_units"];
	_units = _this;
	_output = [];

	for '_i' from 0 to count(_units)-1 do {
		_get = missionNamespace getVariable (_units # _i);
		if !(isNil "_get") then {
			_output set [_i, _get # QUERYUNITLABEL];
		} else {
			_output set [_i, (_units # _i)];
		};
	};
	
	_output
};

_preformat_gear = {
	Private ["_content","_get","_output"];
	_content = _this # 0;
	_prefix = ["", _this # 1] select (count _this > 1);
	_output = [];

	for '_i' from 0 to count(_content)-1 do {
		_get = missionNamespace getVariable Format ["%1%2",_prefix,(_content # _i)];
		if !(isNil "_get") then {
			_output set [_i, _get # 1];
		} else {
			_output set [_i, (_content # _i)];
		};
	};
	
	_output
};
//--- Sort upgrades.
_content = [+(missionNamespace getVariable "WF_C_UPGRADES_LABELS")] Call WFCO_fnc_sortArrayIndex;
missionNamespace setVariable ["WF_C_UPGRADES_SORTED", _content # 1];