/*
	Get enemies in area according to sides.
	 Parameters:
		- Units/Objects array.
		- Friendly Side.
		- {Ignored sides}
*/

private ["_count","_sides","_all_sides"];
params [["_units", []], "_sideFriendly"];

_all_sides = missionNamespace getVariable "WF_C_TOWNS_ALL_SIDES";

_sides =  _all_sides - _sideFriendly;
_count = 0;

{_count = _count + (_x countSide _units)} forEach _sides;

_count