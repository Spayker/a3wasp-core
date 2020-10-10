Private ['_isOnMap','_timeToKill'];

_timeToKill = missionNamespace getVariable "WF_C_PLAYERS_OFFMAP_TIMEOUT";
paramBoundariesRunning = true;

while {true} do {
	sleep 5;
	_isOnMap = Call WFCL_FNC_IsOnMap;
	if !(_isOnMap) then {
		[Format["%1", localize 'STR_WF_INFO_OffmapWarning',_timeToKill]] spawn WFCL_fnc_handleMessage;
		_timeToKill = _timeToKill - 1;
	};
	if (_timeToKill < 0 || _isOnMap || !(alive player)) exitWith {
		if !(_isOnMap && alive player) then {(vehicle player) setDamage 1};
		paramBoundariesRunning = false;
	};
};