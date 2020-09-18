private["_lastSV","_startSV","_mode","_lastMode","_patrol_range","_defense_range"];
params ["_location", "_team", "_sideID", ["_focus", objNull]];

_lastSV = _location getVariable 'supplyValue';
_startSV = _location getVariable 'startingSupplyValue';
_mode = "patrol";
_lastMode = "nil";

_patrol_range = missionNamespace getVariable 'WF_C_TOWNS_PATROL_RANGE';
_defense_range = missionNamespace getVariable 'WF_C_TOWNS_DEFENSE_RANGE';
_aliveTeam = !(count ((units _team) Call WFCO_FNC_GetLiveUnits) == 0 || isNull _team);

	_currentSV = _location getVariable 'supplyValue';
	if (_currentSV < _lastSV || _currentSV < _startSV || _sideID != (_location getVariable 'sideID')) then {
		_mode = "defense";
	} else {
		_mode = "patrol";
	};

	_lastSV = _currentSV;
	
	if(_aliveTeam && _mode != _lastMode && !WF_GameOver) then {
		_lastMode = _mode;

		if (_mode == "patrol") then {
			if (isNull _focus) then {
				[_team,_location,_patrol_range] Spawn WFCO_FNC_WaypointPatrolTown;
			} else {
				[_team,_focus,_patrol_range/4] Spawn WFCO_FNC_WaypointPatrol;
			};
		} else {
			[_team,getPos _location,'SAD',_defense_range] Spawn WFCO_FNC_WaypointSimple;
		};
	};

