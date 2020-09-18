/*
	Equip a unit with a backpack or remove it.
	 Parameters:
		- Unit
		- Backpack
		- {Backpack content}
*/

private ["_backpack","_backpack_content","_counts","_items","_unit","_unit_bp"];
params ["_unit", "_backpack", ["_backpack_content", []]];

//--- Always remove the Backpack.
_unit_bp = unitBackpack _unit;
if !(isNull _unit_bp) then {removeBackpack _unit};

//--- Add Backpack if necessary.
if (_backpack != "") then {
	_unit addBackpack _backpack;
	_unit_bp = unitBackpack _unit;
	
	//--- Clear the existing default content.
	clearWeaponCargoGlobal _unit_bp;
	clearMagazineCargoGlobal _unit_bp;
	
	//--- Don't bother if there is no content.
	if (count _backpack_content == 0) exitWith {};
	
	//--- Weapons
	_items = (_backpack_content # 0) # 0;
	_counts = (_backpack_content # 0) # 1;
	
	for '_i' from 0 to count(_items) do {_unit_bp addWeaponCargoGlobal [_items # _i, _counts # _i]};
	
	//--- Ammo
	_items = (_backpack_content # 1) # 0;
	_counts = (_backpack_content # 1) # 1;
	
	for '_i' from 0 to count(_items) do {_unit_bp addMagazineCargoGlobal [_items # _i, _counts # _i]};
};