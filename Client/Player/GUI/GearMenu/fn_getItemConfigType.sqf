//--- Get the config type of an item.
private ["_config_type", "_item", "_type", "_type_returned"];

_item = _this;

_config_type = (_item) call WFCO_FNC_GetConfigType;
_type_returned = -1;

switch (_config_type) do {
    case "CfgMagazines": {_type_returned = 60000}; //--- Extended, no value in the config
    case "CfgGlasses": {_type_returned = 60001}; //--- Extended, no value in the config
    case "CfgVehicles": {
        if (getNumber(configFile >> _config_type >> _item >> 'isbackpack') == 1) then {_type_returned = WF_SUBTYPE_BACKPACK};
    };
    case "CfgWeapons": {
        _type_returned = getNumber(configFile >> _config_type >> _item >> "type");
        if (_type_returned == WF_TYPE_ITEM) then {
            _type_returned = getNumber(configFile >> _config_type >> _item >> 'ItemInfo' >> 'type');
            if (_type_returned == 0) then {_type_returned = WF_TYPE_ITEM};
        };
    };
};

_type_returned