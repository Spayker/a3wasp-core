private ["_added", "_items", "_uniform", "_unit"];

_unit = _this select 0;
_uniform = _this select 1;
_items = _this select 2;

if (uniform _unit != "") then {removeUniform _unit};//todo clearAllItemsFromUniform if it ever gets added someday.
// if (uniform _unit != _uniform) then { removeUniform _unit }; //todo clearAllItemsFromUniform if it ever gets added someday.
if (_uniform != "" && uniform _unit == "") then { _unit addUniform _uniform };

_added = [];
{
	_item = _x;
	if (_item != "") then {
		if !(_item in _added) then {
			//_base = (_item) call WFCO_FNC_GetItemBaseConfig;
			_added pushBack _item;
			_count = {_x == _item} count _items;
			
			(uniformContainer _unit) addItemCargoGlobal [_item, _count];
			/*switch (_base) do { //todo figure out bout that goggle mystery
				case "CfgMagazines": { (uniformContainer _unit) addMagazineCargoGlobal [_item, _count] };
				case "CfgWeapons": { (uniformContainer _unit) addWeaponCargoGlobal [_item, _count] };
				case "Item": { (uniformContainer _unit) addItemCargoGlobal [_item, _count] };
				case "Goggles": { for '_i' from 1 to _count do {_unit addItemToUniform _item} };
			};*/
			// player sidechat format ["when bis will add the commands, maybe i'll be able to add a %1 in my uniform..", _item];
		};
	};
} forEach _items;