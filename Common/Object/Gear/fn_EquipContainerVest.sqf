params ["_unit", "_vest", "_items"];
private ["_added", "_count"];

if !(vest _unit isEqualTo "") then {removeVest _unit};
if (!(_vest isEqualTo "") && vest _unit isEqualTo "") then { _unit addVest _vest };

_added = [];
{
	_item = _x;
	if !(_item isEqualTo "") then {
		if !(_item in _added) then {
			_added pushBack _item;
			_count = {_x isEqualTo _item} count _items;
			
			(vestContainer _unit) addItemCargoGlobal [_item, _count];
		};
	};
} forEach _items;