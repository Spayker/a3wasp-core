private["_lastSV","_startSV","_mode","_lastMode","_patrol_range","_defense_range"];
params ["_location", "_group", "_sideID", "_focus"];

_lastSV = _location getVariable ['supplyValue', 10];
_startSV = _location getVariable ['startingSupplyValue', 10];
_mode = "patrol";
_lastMode = "nil";

_patrol_range = missionNamespace getVariable 'WF_C_TOWNS_PATROL_RANGE';
_defense_range = missionNamespace getVariable 'WF_C_TOWNS_DEFENSE_RANGE';
_aliveTeam = !(count ((units _group) Call WFCO_FNC_GetLiveUnits) == 0 || isNull _group);

	_currentSV = _location getVariable ['supplyValue', 10];
	if (_currentSV < _lastSV || _currentSV < _startSV || (_sideID == (_location getVariable 'sideID'))) then {
		_mode = "defense";
	};

	_lastSV = _currentSV;
	
	if(_aliveTeam && _mode != _lastMode) then {
		_lastMode = _mode;

		if (_mode == "patrol") then {
			if (isNull _focus) then {
				[_group,_location,_patrol_range] Spawn WFCO_FNC_WaypointPatrolTown;
			} else {
				[_group,_focus,_patrol_range/4] Spawn WFCO_FNC_WaypointPatrol;
			};
		} else {
			[_group,getPosATL _location,'SAD',_defense_range] Spawn WFCO_FNC_WaypointSimple;
		};
	};

