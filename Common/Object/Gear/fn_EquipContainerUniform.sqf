params ["_unit", "_uniform", "_items"];
private ["_added", "_count"];

if !(uniform _unit isEqualTo "") then {removeUniform _unit};
if (!(_uniform isEqualTo "") && uniform _unit isEqualTo "") then { _unit forceAddUniform _uniform };

_added = [];
{
	_item = _x;
	if !(_item isEqualTo "") then {
		if !(_item in _added) then {
			_added pushBack _item;
			_count = {_x isEqualTo _item} count _items;
			
			(uniformContainer _unit) addItemCargoGlobal [_item, _count];
		};
	};
} forEach _items;