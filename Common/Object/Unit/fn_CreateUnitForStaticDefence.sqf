/*
	Create units for static defence.
	 Parameters:
		- Side
		- Groups
		- Spawn positions
		- Teams
		- Defence
		- Move In Gunner immidietly or not
*/
params ["_side", "_team", "_defences"];
private ["_sideID", "_crewUnits", "_hc"];

_sideID = _side call WFCO_FNC_GetSideID;
_soldiers = [];
{
    _defence = _x;
	_crewUnits = _defence getVariable ["_crewUnits", []];
	_crewUnits = _crewUnits - [objNull];

	_soldier = objNull;

	{
		if (alive _x) exitWith { _soldier = _x };
	} forEach _crewUnits;

	_position = getPosATL _defence;
	_gunnerType = missionNamespace getVariable format ["WF_%1SOLDIER", _side];

	if (!isNull _soldier) then {
		["INFORMATION", format["fn_CreateUnitForstaticDefence.sqf: %2 [%1] will be assigned to %3", _side, _gunnerType, _defence]] spawn WFCO_FNC_LogContent;
	} else {
		["INFORMATION", format["fn_CreateUnitForstaticDefence.sqf: [%1] will create %2 at %3", _side, _gunnerType, _position]] spawn WFCO_FNC_LogContent;
		_soldier = [_gunnerType, _team, _position, _sideID] call WFCO_FNC_CreateUnit;

		if(isDedicated) then {
		   _soldier enableSimulationGlobal false;
		} else {
		   _soldier enableSimulation false;
		};

		if(_side in [west, east]) then {
			_soldier setSkill 1;
			[_team, 1000, getPosATL _defence] spawn WFCO_FNC_RevealArea;
		};

		[str _side, 'UnitsCreated', 1] spawn WFCO_FNC_UpdateStatistics;
		_crewUnits pushBack _soldier;
		_soldiers pushBack _soldier;
	};

	//--Move soldier to a weapon--
	_soldier setPosATL (getPosATL _defence);
	[_soldier] allowGetIn true;
	_soldier assignAsGunner _defence;
	[_soldier] orderGetIn true;
	_soldier moveInGunner _defence;	

	_publicFor = [2];
	if(isHeadLessClient) then {
		_publicFor pushBack clientOwner;
	} else {
		_hc = missionNamespace getVariable ["WF_HEADLESSCLIENT_ID", 0];
		if(_hc > 0) then {
			_publicFor pushBack _hc;
		};
	};

	//--Publi this var for all scopes (server and HC)--
    _defence setVariable ["_crewUnits", _crewUnits, _publicFor];
    sleep 1;
} forEach _defences;

{
    if(isDedicated) then {
       _x enableSimulationGlobal true;
   } else {
       _x enableSimulation true;
   };
} forEach _soldiers;
