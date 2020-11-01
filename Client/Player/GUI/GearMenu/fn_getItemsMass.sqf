private["_items", "_mass"];

_items = _this;

_mass = 0;

{if !(_x isEqualTo "") then {
    _item = _x;
    if(typeName _x == 'ARRAY') then { _item = _item # 0 };
    _mass = _mass + (_item call WFCL_fnc_getGenericItemMass)

}} forEach _items;

_mass