/*
	Kill vehicle crew when static defense is killed or deleted
*/
params ["_defense"];
private ["_crewUnits"];

_crewUnits = _defense getVariable ["crewUnits", []];

{
	if(!isNull _x) then {
		if(alive _x) then {
			_x setDamage 1;
		};
	};
} forEach _crewUnits;

_defense setVariable ["crewUnits", nil, true];