/*
	Create units in towns.
	 Parameters:
		- Town
		- Side
		- Groups
		- Spawn positions
		- Teams
*/
params ["_town", "_side", "_teams", "_positions", ["_camp", objNull]];
private ["_lock", "_position", "_sideID", "_team", "_teams", "_town_teams", "_town_vehicles", "_retVal", "_wf_active_vehicles", "_wf_town_teams"];

_sideID = (_side) call WFCO_FNC_GetSideID;
_built = 0;
_builtveh = 0;

_lock = if ((missionNamespace getVariable "WF_C_TOWNS_VEHICLES_LOCK_DEFENDER") == 0 && _side == WF_DEFENDER) then {false} else {true};

_town_teams = [];
_town_vehicles = [];
_wf_town_teams = [];
_wf_active_vehicles = [];
_units = [];
_vehicles = [];

_c = 0;
for '_i' from 0 to count(_teams)-1 do {
	_position = _positions # _i;

	_group = createGroup [_side, true];
	["INFORMATION", Format["fn_CreateTownUnits.sqf: Town [%1] [%2] will create a team template %3 at %4", _town, _group, _teams # _i,_position]] Call WFCO_FNC_LogContent;
	
	_retVal = [_teams # _i, _position, _side, _sideID, _lock, _group, true, _town] call WFCO_FNC_CreateTeam;
	_units = _units + _retVal # 0;
	_vehicles = _vehicles + _retVal # 1;

	_built = _built + count _units;
	_builtveh = _builtveh + (count _vehicles);

	{ _town_vehicles pushBack _x; } forEach _vehicles;
	_town_teams pushBack _group;
{
    if(isDedicated) then {
         _x enableSimulationGlobal true
    } else {
         _x enableSimulation true
    }
} foreach (_units + _vehicles);

    if (isNull _camp) then {
    [_town, _group, _sideID] spawn WFCO_FNC_SetPatrol;
    } else {
        [_town, _group, _sideID, _camp] spawn WFCO_FNC_SetPatrol;
    };
	sleep (count(_teams # _i))
};

if (_built > 0) then {[str _side,'UnitsCreated',_built] spawn WFCO_FNC_UpdateStatistics};
if (_builtveh > 0) then {[str _side,'VehiclesCreated',_builtveh] spawn WFCO_FNC_UpdateStatistics};

["INFORMATION", Format["fn_CreateTownUnits.sqf: Town [%1] held by [%2] was activated witha total of [%3] units.", _town, _side, _built + _builtveh]] Call WFCO_FNC_LogContent;

if(isHeadLessClient) then {
    _teamsFromServer = ["WFSE_FNC_GetTownActiveGroups", player, [_town], 6000] call WFCL_FNC_remoteExecServer;
    _wf_town_teams = _teamsFromServer # 0;
    _wf_active_vehicles = _teamsFromServer # 1;
} else {
    _wf_town_teams = _town getVariable ["wf_town_teams", []];
    _wf_active_vehicles = _town getVariable ["wf_active_vehicles", []];
};
_wf_active_vehicles = _wf_active_vehicles + _town_vehicles;
_wf_active_vehicles = _wf_active_vehicles - [objNull];
_town setVariable ["wf_active_vehicles", _wf_active_vehicles, 2];

_wf_town_teams = _wf_town_teams + _town_teams;
_wf_town_teams = _wf_town_teams - [grpNull];
_town setVariable ["wf_town_teams", _wf_town_teams, 2];

_town setVariable ['wf_unlocked', true, 2];