private ["_fuel","_vehicle","_ID"];
_vehicle = vehicle (_this select 0);

_ID = _this select 2;
_vehicle setVariable ["ID",_ID];
_vehicle EngineOn false;
_vehicle setVariable ["stopped",true];
