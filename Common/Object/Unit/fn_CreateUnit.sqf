/*
	Create a unit.
	 Parameters:
		- Classname
		- Group
		- Position
		- Side ID
		- {Global Init}
		- {PLacement}
*/

params ["_type", "_group", "_position", "_side", ["_global", true], ["_special", "FORM"]];
private ["_get", "_unit"];

if(isNil '_group') then { _group = createGroup [_side, true]};

_unit = _group createUnit [_type, _position, [], 0, _special];
[_unit, _type, _group, _position, _side, _global, _special] spawn WFCO_fnc_InitManUnit;

_unit