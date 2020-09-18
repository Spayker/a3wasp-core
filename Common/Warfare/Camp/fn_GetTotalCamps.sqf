/*
	Get all of the camp from a town.
	 Parameters:
		- Town.
*/

Private ['_camps'];

_camps = _this getVariable "camps";
if (count _camps == 0) exitWith {1};

count _camps