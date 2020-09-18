params ["_vehicle", "_gear"];
private ["_count", "_item", "_loaded"];

//--- Clear the vehicle before applying it's new cargo
clearItemCargoGlobal _vehicle;
clearMagazineCargoGlobal _vehicle;
clearWeaponCargoGlobal _vehicle;
clearBackpackCargoGlobal _vehicle;

_loaded = [];

{
	_item = _x;
	// if !(_item in _loaded) then {
	if (({_x isEqualTo _item} count _loaded) < 1) then {
		_count = {_x isEqualTo _item} count _gear;
		_loaded pushBack _item;

		if (isClass (configFile >> 'CfgVehicles' >> _item)) then {
			_vehicle addBackpackCargoGlobal [_item, _count]
		} else {
			_vehicle addItemCargoGlobal [_item, _count]
		}
	}
} forEach _gear