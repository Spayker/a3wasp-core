//--- Return the mass carrying capacity of a cargo item (uniform, vest or backpack)
private["_base", "_container", "_item"];

_item = _this;

if (_item == "") exitWith {0};

_base = (_item) call WFCO_FNC_GetConfigType;

if (_base == "CfgVehicles") then {
    getNumber(configFile >> "CfgVehicles" >> _item >> "maximumLoad");
} else {
    _container = getText(configFile >> "CfgWeapons" >> _item >> "ItemInfo" >> "containerClass");
    getNumber(configFile >> "CfgVehicles" >> _container >> "maximumLoad");
};