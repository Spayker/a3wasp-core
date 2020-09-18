private["_enemyTowns","_nearest"];
params ["_object", "_side", ["_cvar", ""]];

_enemyTowns = towns - ((_side) Call WFCO_FNC_GetSideTowns);
_nearest = objNull;

if (count _enemyTowns > 0) then {
	_nearests = [_object,_enemyTowns] Call WFCO_FNC_SortByDistance;
	if (_cvar != "") then {
		for '_i' from 0 to count(_nearests)-1 do {
			if ((_nearests # _i) getVariable _cvar) exitWith {_nearest = (_nearests # _i)};
		};
	} else {
		_nearest = _nearests # 0;
	}
};

_nearest