private ["_config_type", "_get", "_item", "_magazines","_upgrade_gear", "_upgrades", "_dspl", "_dsplCtrl", "_info",
"_index", "_gear", "_gearExcludes", "_abdomen", "_body", "_chest", "_diaphragm", "_mass", "_maxload", "_head"];

ctrlSetText [22556, ""];

_item = _this;
_upgrades = (WF_Client_SideJoined) Call WFCO_FNC_GetSideUpgrades;
_upgrade_gear = _upgrades select WF_UP_GEAR;

_config_type = (_item) call WFCO_FNC_GetConfigType;

if ((lnbSize 70601) select 0 > 0) then {lnbClear 70601};

if (_config_type == "CfgWeapons") then {
    //--- Add the linked magazines
    _magazines = [];
    {
        if (_x == "this") then {
            _magazines = _magazines + getArray(configFile >> 'CfgWeapons' >> _item >> 'magazines');
        } else {
            _magazines = _magazines + getArray(configfile >> 'CfgWeapons' >> _item >> _x >> 'magazines')
        };
    } forEach (getArray(configFile >> 'CfgWeapons' >> _item >> 'muzzles'));

    //--- Add the compatible accessories (bistery over here, one time the config 'compatibleItems' is property, one time it's an array, so fuck it, we add both).
    _compatible_acc = [];

    _muzzleAccessories = ([_item, 101] call BIS_fnc_compatibleItems);
    _opticAccessories = ([_item, 201] call BIS_fnc_compatibleItems);
    _pointerAccessories = ([_item, 301] call BIS_fnc_compatibleItems);
    _bipodAccessories = ([_item, 302] call BIS_fnc_compatibleItems);

    _compatible_acc = _muzzleAccessories + _opticAccessories + _pointerAccessories +  _bipodAccessories;

    {
        _get = missionNamespace getVariable format["wf_%1", _x];

        if (!(isNil "_get") &&((_get select 0) select 0) <= _upgrade_gear) then {

            _row = lnbAddRow [70601, [getText(configFile >> _get select 2 >> _x >> 'displayName'), format ["$%1", (_get select 0) select 1]]];
            lnbSetPicture [70601, [_row, 1], getText(configFile >> _get select 2 >> _x >> 'picture')];
            lnbSetData [70601, [_row, 0], toLower(_x)];
        };
    } forEach (_magazines call WFCO_FNC_ArrayToLower) + _compatible_acc;
};

_dspl = findDisplay 503000;
_dsplCtrl = _dspl displayCtrl 22556;

_info = "";

if (uiNamespace getVariable "wf_dialog_ui_gear_shop_tab" == 7) then {
    _index = lnbCurSelRow 70108;
    _gear = missionNamespace getVariable [format["wf_player_gearTemplates_%1", WF_SK_V_Type], []];

    if(count _gear > 0) then {
        _gear = _gear # _index;
        _info = "<t size='1.2' color='#efe898'>" + (_gear # 0) + ":</t><br />";
        _gear = _gear # 1;
        _gearExcludes = [_gear, _upgrade_gear, WF_SK_V_Type] call WFCO_FNC_proccedLoadOutForSide;
        _gearExcludes = _gearExcludes # 1;

        _gear = [_gear] call WFCO_FNC_MultiArrayToSimple;

        {
            if(_x != "") then {
                _config_type = [_x] call WFCO_FNC_GetConfigType;
                _color = "#ffffff";
                if(_x in _gearExcludes) then { _color = "#ee2222"; };
                _info = _info + ("<t align='left'><img image='" + ([_x, "picture", _config_type] Call WFCO_FNC_GetConfigInfo) + "' size='1.5'/></t>   <t color='" + _color + "'>" +
                          ([_x, "displayName", _config_type] Call WFCO_FNC_GetConfigInfo) + "</t><br />");
            };
        } forEach _gear;
    };
} else {
    _info = [_item, "descriptionShort", _config_type] Call WFCO_FNC_GetConfigInfo;

    _head = getNumber(configfile >> _config_type >> _item >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Head" >> "armor");
    _body = getNumber(configfile >> _config_type >> _item >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Body" >> "armor");
    _chest = getNumber(configfile >> _config_type >> _item >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Chest" >> "armor");
    _diaphragm = getNumber(configfile >> _config_type >> _item >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Diaphragm" >> "armor");
    _abdomen = getNumber(configfile >> _config_type >> _item >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Abdomen" >> "armor");
    _mass = getNumber(configfile >>  _config_type >> _item >> "ItemInfo" >> "mass");
    _maxload = -1;
    try { _maxload = getContainerMaxLoad _item } catch {};

    if(_head > 0 || _body > 0 || _chest > 0 || _diaphragm > 0 || _abdomen > 0) then {
        if(count _info > 0) then {
            _info = _info + "<br /><br />";
        };

        _info = _info + "<t size='1.1'>" + (localize "STR_WF_UNITS_ArmorLabel") + "</t><br />";
        if(_head > 0) then {
            _info = format["%1%2%3%4%5",_info,localize "STR_WF_BodyParts_Head",": ",_head,"<br />"];
        };
        if(_body > 0) then {
            _info = format["%1%2%3%4%5",_info,localize "STR_WF_BodyParts_Body",": ",_body,"<br />"];
        };
        if(_chest > 0) then {
            _info = format["%1%2%3%4%5",_info,localize "STR_WF_BodyParts_Chest",": ",_chest,"<br />"];
        };
        if(_diaphragm > 0) then {
            _info = format["%1%2%3%4%5",_info,localize "STR_WF_BodyParts_Diaphragm",": ",_diaphragm,"<br />"];
        };
        if(_abdomen > 0) then {
            _info = format["%1%2%3%4%5",_info,localize "STR_WF_BodyParts_Abdomen",": ",_abdomen,"<br />"];
        };
    };

    if(count _info > 0) then {
        _info = _info + "<br />";
    };

    if(_mass > 0) then {
        _info = format["%1%2%3%4",_info,localize "STR_WF_Mass",": ",_mass];
    };
    if(_maxload > 0) then {
        _info = format["%1%2%3%4%5",_info,"<br />",localize "STR_WF_MaxLoad",": ",_maxload];
    };
};

_dsplCtrl ctrlSetStructuredText parseText _info;