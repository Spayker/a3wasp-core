//--- Display a vehicle's content in the Gear UI
private ["_gear", "_item"];
_gear = _this select 0;
_item = _this select 1;

_gear pushBack _item;

//--- Update the vehicle's mass
[_item, "add"] call WFCL_fnc_updateVehicleLoad;

//--- Update the Vehicle container along with the mass
call WFCL_fnc_updateVehicleContainerProgress;
(_gear) call WFCL_fnc_displayInventoryVehicle;

true