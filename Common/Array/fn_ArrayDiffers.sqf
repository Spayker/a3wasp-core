private ["_array1", "_array2", "_different", "_item"];

_array1 = _this select 0;
_array2 = _this select 1;

_different = false;

if (count _array1 != count _array2) then { 
	_different = true;
} else {
	{
		_item = _x;
		if (({_x == _item} count _array1) != ({_x == _item} count _array2)) exitWith { _different = true };
	} forEach _array1;
};

_different