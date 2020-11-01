//--- Return the initial mass of a unit from it's stored gear along with the separate containers mass
private["_backpack_items_capacity", "_backpack_items_mass", "_gear", "_generic_mass", "_item", "_mass", "_uniform_items_capacity", "_uniform_items_mass", "_vest_items_capacity", "_vest_items_mass"];

_gear = _this;
_generic_mass = 0;

//--- Equipment
_mass = [((_gear select 1) select 0) select 0, ((_gear select 1) select 0) select 1] call WFCL_fnc_getContainerMass;
_uniform_items_mass = _mass select 1;
_uniform_items_capacity = _mass select 2;
_generic_mass = _generic_mass + (_mass select 0) + _uniform_items_mass;

_mass = [((_gear select 1) select 1) select 0, ((_gear select 1) select 1) select 1] call WFCL_fnc_getContainerMass;
_vest_items_mass = _mass select 1;
_vest_items_capacity = _mass select 2;
_generic_mass = _generic_mass + (_mass select 0) + _vest_items_mass;

_mass = [((_gear select 1) select 2) select 0, ((_gear select 1) select 2) select 1] call WFCL_fnc_getContainerMass;
_backpack_items_mass = _mass select 1;
_backpack_items_capacity = _mass select 2;
_generic_mass = _generic_mass + (_mass select 0) + _backpack_items_mass;

//--- Headgear
_item = (_gear select 2) select 0;
_generic_mass = _generic_mass + (if (_item != "") then {getNumber(configFile >> "CfgWeapons" >> _item >> "ItemInfo" >> "mass")} else {0});

//--- Glasses
_item = (_gear select 2) select 1;
_generic_mass = _generic_mass + (if (_item != "") then {getNumber(configFile >> "CfgGlasses" >> _item >> "mass")} else {0});

//--- Special and items
_nvg_mass = [(((_gear select 3) select 0) select 0)] call WFCL_fnc_getItemsMass;
_bino_w_mag_mass = (((_gear select 3) select 0) select 1);
if(_bino_w_mag_mass isEqualType "") then {_bino_w_mag_mass = [_bino_w_mag_mass];};
_bino_w_mag_mass = _bino_w_mag_mass call WFCL_fnc_getItemsMass;
_generic_mass = _generic_mass + _nvg_mass + _bino_w_mag_mass;

//--- Weapons
for '_i' from 0 to 2 do {
    _item = ((_gear select 0) select _i) select 0;
    if (_item != "") then {
        _generic_mass = _generic_mass + getNumber(configFile >> "CfgWeapons" >> _item >> "WeaponSlotsInfo" >> "mass");

        {
            if (_x != "") then {_generic_mass = _generic_mass + getNumber(configFile >> "CfgWeapons" >> _x >> "ItemInfo" >> "mass")};
        } forEach (((_gear select 0) select _i) select 1);
    };
};

[_generic_mass, [[_uniform_items_mass, _uniform_items_capacity], [_vest_items_mass, _vest_items_capacity], [_backpack_items_mass, _backpack_items_capacity]]]