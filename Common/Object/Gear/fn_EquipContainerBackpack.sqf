params ["_unit", "_backpack", "_items"];
private ["_added", "_count"];

if !(backpack _unit isEqualTo _backpack) then { removeBackpack _unit };
if (!(_backpack isEqualTo "") && backpack _unit isEqualTo "") then { _unit addBackpack _backpack };
if !(backpack _unit isEqualTo "") then { clearAllItemsFromBackpack _unit };

_added = [];
{
	_item = _x;
	if !(_item isEqualTo "") then {
		if !(_item in _added) then {
			_added pushBack _item;
			_count = {_x isEqualTo _item} count _items;
			
			(unitBackPack _unit) addItemCargoGlobal [_item, _count];
		};
	};
} forEach _items;