
//  Author: Pizza Man
//  File: fn_insertElement.sqf
//  Description: Inserts an element at given index of an array

// Parameters
if !(params[["_array", [], [[]]], ["_element", nil], ["_index", -1, [0]]]) exitWith {};

// Insert element
private _return = [];
{_return append _x} forEach [_array select [0, _index], [_element], _array select [_index, count _array]];

// Exit
_return;
