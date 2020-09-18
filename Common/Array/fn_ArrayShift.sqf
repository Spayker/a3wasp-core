/*
	Shift an array.
	 Parameters:
		- Array.
		- Index Array.
*/

Private ["_array","_i","_remove","_shifted"];

_array = +(_this select 0);
_remove = _this select 1;

_shifted = [];
_i = 0;
for '_j' from 0 to count(_array)-1 do {
	if !(_j in _remove) then {
		_shifted set [_i, _array select _j];
		_i = _i + 1;
	};
};

_shifted