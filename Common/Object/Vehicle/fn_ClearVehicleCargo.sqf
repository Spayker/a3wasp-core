/*
	Clear the Cargo of a vehicle (Vanilla).
	 Parameters:
		- Vehicle
*/

private ["_vehicle"];

_vehicle = _this;

clearMagazineCargoGlobal _vehicle;
clearWeaponCargoGlobal _vehicle;
clearBackpackCargoGlobal _vehicle;
clearItemCargoGlobal  _vehicle;