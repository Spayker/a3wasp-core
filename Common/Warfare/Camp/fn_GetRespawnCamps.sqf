private ['_availableSpawn','_camps','_closestCamp','_enemySide','_get','_hostiles','_nearestCamps','_respawnCampsRuleMode','_respawnMinRange','_town','_townSID'],;
params ["_deathLoc", "_side"];

_availableSpawn = [];
_respawnCampsRuleMode = missionNamespace getVariable "WF_C_RESPAWN_CAMPS_RULE_MODE";
_respawnMinRange = missionNamespace getVariable "WF_C_RESPAWN_CAMPS_SAFE_RADIUS";
_enemySide = sideEnemy;

switch (missionNamespace getVariable "WF_C_RESPAWN_CAMPS_MODE") do {
	case 1: {
		/* Classic Respawn */
		_town = [_deathLoc] Call WFCO_FNC_GetClosestLocation;
		if !(isNull _town) then {
			if (_town distance _deathLoc  < (missionNamespace getVariable "WF_C_RESPAWN_CAMPS_RANGE")) then {
				_camps = [_town,_side,true] Call WFCO_FNC_GetFriendlyCamps;
				if (count _camps > 0) then {
					if (_respawnCampsRuleMode > 0) then {
						_closestCamp = [_deathLoc,_camps] Call WFCO_FNC_GetClosestEntity;

						_enemySide = [];
                        if(_side == west) then {
                            _enemySide pushBack east;
                            _enemySide pushBack resistance
                        };

                        if(_side == east) then {
                            _enemySide pushBack west;
                            _enemySide pushBack resistance
                        };

                        if(_side == resistance) then {
                            _enemySide pushBack east;
                            _enemySide pushBack west
                        };

						_hostiles = [_closestCamp,_enemySide,_respawnMinRange] Call WFCO_FNC_GetHostilesInArea;
						if (_deathLoc distance _closestCamp < _respawnMinRange && _hostiles > 0) then {
							_index = _camps find _closestCamp;
							if(_index > -1)then{_camps deleteAt _index};
						};
					};
					_availableSpawn = _availableSpawn + _camps;
				};
			};
		};
	};
	
	case 2: {
		/* Enhanced Respawn - Get the camps around the unit */
		_nearestCamps = nearestObjects [_deathLoc, WF_C_CAMP_SEARCH_ARRAY, (missionNamespace getVariable "WF_C_RESPAWN_CAMPS_RANGE")];
		{
			if !(isNil {_x getVariable 'sideID'}) then {
				if ((_side Call WFCO_FNC_GetSideID) == (_x getVariable 'sideID') && !isObjectHidden _x) then {
					if (_respawnCampsRuleMode > 0) then {
						if (_deathLoc distance _x < _respawnMinRange) then {
                            _enemySide = [];

                            if(_side == west) then {
                                _enemySide pushBack east;
                                _enemySide pushBack resistance
                            };

                            if(_side == east) then {
                                _enemySide pushBack west;
                                _enemySide pushBack resistance
                            };

                            if(_side == resistance) then {
                                _enemySide pushBack east;
                                _enemySide pushBack west
                            };

							_hostiles = [_x,_enemySide,_respawnMinRange] Call WFCO_FNC_GetHostilesInArea;
							if (_hostiles == 0) then {_availableSpawn pushBack _x};
						} else {
							_availableSpawn pushBack (_x);
						};
					} else {
						_availableSpawn pushBack (_x);
					};
				};
			};
		} forEach _nearestCamps;
	};
	
	case 3: {
		/* Defender Only Respawn - Get the camps around the unit only if the town is friendly to the unit. */
		_nearestCamps = nearestObjects [_deathLoc, WF_C_CAMP_SEARCH_ARRAY, (missionNamespace getVariable "WF_C_RESPAWN_CAMPS_RANGE")];
		{
			if !(isNil {_x getVariable 'sideID'}) then {
				_town = _x getVariable 'town';
				_townSID = _town getVariable 'sideID';
				if ((_side Call WFCO_FNC_GetSideID) == _townSID && (_x getVariable 'sideID') == _townSID && !isObjectHidden _x) then {
					if (_respawnCampsRuleMode > 0) then {
						if (_deathLoc distance _x < _respawnMinRange) then {
                            _enemySide = [];

                            if(_side == west) then {
                                _enemySide pushBack east;
                                _enemySide pushBack resistance
                            };

                            if(_side == east) then {
                                _enemySide pushBack west;
                                _enemySide pushBack resistance
                            };

                            if(_side == resistance) then {
                                _enemySide pushBack east;
                                _enemySide pushBack west
                            };
							_hostiles = [_x,_enemySide,_respawnMinRange] Call WFCO_FNC_GetHostilesInArea;
							if (_hostiles == 0) then {_availableSpawn pushBack _x};
						} else {
							_availableSpawn pushBack _x;
						};
					} else {
						_availableSpawn pushBack _x;
					};
				};
			};
		} forEach _nearestCamps;
	};
};
/* Return the available camps */
_availableSpawn