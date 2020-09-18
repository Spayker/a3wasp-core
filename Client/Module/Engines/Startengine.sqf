private ["_fuel","_vehicle","_ID"];
_vehicle = vehicle (_this select 0);
_ID = _this select 2;
_fuel = _vehicle getVariable 'Fuel';
_vehicle setFuel _fuel;
_vehicle removeAction _ID;
_vehicle setVariable ["stopped",false];