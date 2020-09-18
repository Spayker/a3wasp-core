/*
	Return the closest object among a list
	 Parameters:
		- Entity.
		- List.
*/
params ["_object","_objects"];
private["_distance","_nearest"];

_nearest = objNull;
_distance =  missionNamespace getVariable ["WF_C_BASE_DEFENSE_MANNING_RANGE_EXT", 50];
{if (_x distance _object < _distance) then {_nearest = _x;_distance = _x distance _object}} forEach _objects;

_nearest