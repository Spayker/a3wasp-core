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
params ["_side", "_group", "_defences"];
private ["_sideID", "_crewUnits"];

_sideID = _side call WFCO_FNC_GetSideID;

{
    _defence = _x;
	_crewUnits = _defence getVariable ["crewUnits", []];
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
		_soldier = _group createUnit [_gunnerType, _position, [], 0, 'NONE'];
		//_soldier = [_gunnerType, _group, _position, _sideID] call WFCO_FNC_CreateUnit;

		if(_side in [west, east]) then {
			_soldier setSkill 1;
			[_group, 1000, getPosATL _defence] spawn WFCO_FNC_RevealArea;
		};

		[str _side, 'UnitsCreated', 1] spawn WFCO_FNC_UpdateStatistics;
		_crewUnits pushBack _soldier;
	};

	//--Move soldier to a weapon--
	[_soldier] allowGetIn true;
	_soldier assignAsGunner _defence;
	[_soldier] orderGetIn true;
	_soldier moveInGunner _defence;	
    _defence setVariable ["crewUnits", _crewUnits, true];
} forEach _defences;
