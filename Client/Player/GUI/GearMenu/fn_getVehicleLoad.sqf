private ["_gear"];
_gear = _this;

_mass = 0;

{_mass = _mass + (_x call WFCL_fnc_getGenericItemMass)} forEach _gear;

_mass