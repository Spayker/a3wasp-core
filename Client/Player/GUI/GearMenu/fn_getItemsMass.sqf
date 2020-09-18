private["_items", "_mass"];

_items = _this;

_mass = 0;
{if (_x != "") then {_mass = _mass + (_x call WFCL_fnc_getGenericItemMass)}} forEach _items;

_mass