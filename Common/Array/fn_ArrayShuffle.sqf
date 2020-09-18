/*
	Shuffle an array.
	 Parameters:
		- Array.
*/

Private ["_array","_count","_ran","_selected","_shuffled"];

_array = +_this;
_shuffled = [];
_count = (count _array) -1;

for '_i' from 0 to _count do {
	_ran = floor(random(count _array));
	_selected = _array select _ran;
	_shuffled set [_i, _selected];
	_array = [_array, [_ran]] Call WFCO_FNC_ArrayShift;
};

_shuffled