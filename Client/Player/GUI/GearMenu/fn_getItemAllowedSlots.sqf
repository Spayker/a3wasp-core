_item = _this;

_config_type = (_item) call WFCO_FNC_GetConfigType;
_allowedInto = [];
_type = getNumber(configFile >> _config_type >> _item >> "type");

switch (_config_type) do {
    case "CfgWeapons": {
        if (_type != WF_TYPE_ITEM) then {
            _allowedInto = getArray(configFile >> _config_type >> _item >> 'WeaponSlotsInfo' >> 'allowedSlots');
        } else {
            _sub_type = getNumber(configFile >> _config_type >> _item >> 'ItemInfo' >> 'type');
            _allowedInto = switch (true) do {
                case (_sub_type in [WF_SUBTYPE_VEST, WF_SUBTYPE_UNIFORM]): {getArray(configFile >> _config_type >> _item >> 'allowedSlots')};
                default {getArray(configFile >> _config_type >> _item >> 'ItemInfo' >> 'allowedSlots')};
            };
        };
    };
    case "CfgMagazines": {_allowedInto = [WF_SUBTYPE_VEST, WF_SUBTYPE_UNIFORM, WF_SUBTYPE_BACKPACK]};
    case "CfgVehicles": {_allowedInto = getArray(configFile >> _config_type >> _item >> 'allowedSlots')};
    case "CfgGlasses": {_allowedInto = [WF_SUBTYPE_VEST, WF_SUBTYPE_UNIFORM, WF_SUBTYPE_BACKPACK]};
};

if (count _allowedInto == 0) then {_allowedInto = [WF_SUBTYPE_VEST, WF_SUBTYPE_UNIFORM, WF_SUBTYPE_BACKPACK]}; //--- Default
[_allowedInto, _config_type]