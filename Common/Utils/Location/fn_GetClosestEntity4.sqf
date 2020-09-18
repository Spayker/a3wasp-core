/*
	Return the closest object among a list
	 Parameters:
		- Entity.
		- List.
*/

Private["_distance","_nearest","_object","_objects"];

_object = _this select 0;
_objects = _this select 1;

_nearest = objNull;
_distance =  missionNamespace getVariable "WF_C_BASE_DEFENSE_MANNING_RANGE";
{if (_x distance _object < _distance) then {_nearest = _x;_distance = _x distance _object}} forEach _objects;

_nearest