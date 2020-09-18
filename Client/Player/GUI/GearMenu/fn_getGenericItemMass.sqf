//--- Return the mass of an generic item
private["_config_type","_item","_mass"];

_item = _this;

_config_type = (_item) call WFCO_FNC_GetConfigType;
_mass = 0;
_type = getNumber(configFile >> _config_type >> _item >> "type");

switch (_config_type) do {
    case "CfgWeapons": {
        if (_type != WF_TYPE_ITEM) then {
            _mass = getNumber(configFile >> _config_type >> _item >> "WeaponSlotsInfo" >> "mass");
        } else {
            _mass = getNumber(configFile >> _config_type >> _item >> "ItemInfo" >> "mass");
        };
    };
    case "CfgMagazines": {_mass = getNumber(configFile >> _config_type >> _item >> "mass")};
    case "CfgVehicles": {_mass = getNumber(configFile >> _config_type >> _item >> "mass")};
    case "CfgGlasses": {_mass = getNumber(configFile >> _config_type >> _item >> "mass")};
};

_mass