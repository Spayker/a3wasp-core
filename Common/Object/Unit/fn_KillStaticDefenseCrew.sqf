/*
	Kill vehicle crew when static defense is killed or deleted
*/
params ["_defense"];
private ["_crewUnits", "_publicFor"];

_crewUnits = _defense getVariable ["_crewUnits", []];

{
	if(!isNull _x) then {
		if(alive _x) then {
			_x setDamage 1;
		};
	};
} forEach _crewUnits;

_publicFor = [2];
if (missionNamespace getVariable ["WF_HEADLESSCLIENT_ID", 0] > 0) then {
    _publicFor pushBack (missionNamespace getVariable "WF_HEADLESSCLIENT_ID");
};

_defense setVariable ["_crewUnits", nil, _publicFor];