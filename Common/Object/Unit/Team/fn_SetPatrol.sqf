private["_lastSV","_startSV","_patrol_range","_defense_range"];
params ["_location", "_group", "_sideID", "_focus"];

_lastSV = _location getVariable ['supplyValue', 10];
_startSV = _location getVariable ['startingSupplyValue', 10];

_patrol_range = missionNamespace getVariable 'WF_C_TOWNS_PATROL_RANGE';
_defense_range = missionNamespace getVariable 'WF_C_TOWNS_DEFENSE_RANGE';
_aliveTeam = !(count ((units _group) Call WFCO_FNC_GetLiveUnits) == 0 || isNull _group);

_lastSV = _location getVariable ['supplyValue', 10];

if(_aliveTeam) then {
			if (isNull _focus) then {
				[_group,_location,_patrol_range] Spawn WFCO_FNC_WaypointPatrolTown;
			} else {
				[_group,_focus,_patrol_range/4] Spawn WFCO_FNC_WaypointPatrol;
			};
}

