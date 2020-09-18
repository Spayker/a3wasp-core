//--- Item add attempt
private ["_current", "_get", "_gear", "_index", "_item", "_slot", "_sub_type", "_type", "_updated"];

_item = toLower(_this);

_get = missionNamespace getVariable format["wf_%1", _item];
_updated = false;

if !(isNil '_get') then {
    //--- Depending on the item, we do different checks.
    _type = if (typeName (_get select 1) == "STRING") then {_get select 1} else {(_get select 1) select 0};
    _gear = uiNamespace getVariable "wf_dialog_ui_gear_target_gear";

    switch (_type) do {
        case "Rifle": { //--- Primary
            [_item, 0] call WFCL_fnc_replaceWeapon;
            _updated = true;
        };
        case "Launcher": { //--- Secondary
            [_item, 1] call WFCL_fnc_replaceWeapon;
            _updated = true;
        };
        case "Pistol": { //--- Handgun
            [_item, 2] call WFCL_fnc_replaceWeapon;
            _updated = true;
        };
        case "Rifle 2H": { //--- Two handed rifle, no launchers
            [_item, 0] call WFCL_fnc_replaceWeapon;
            ["", 1] call WFCL_fnc_replaceWeapon;
            _updated = true;
        };
        case "Equipment": { //--- Binoc... NVG...
            //--- Simulation?
            _index = if (getText(configFile >> 'CfgWeapons' >> _item >> 'simulation') == "NVGoggles") then {0} else {1};
            _current = ((_gear select 3) select 0) select _index;

            if (_current != _item) then { //--- Replace
                ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl (70006+_index)) ctrlSetText getText(configFile >> 'CfgWeapons' >> _item >> 'picture');
                ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl (70006+_index)) ctrlSetTooltip getText(configFile >> 'CfgWeapons' >> _item >> 'displayName');

                ((_gear select 3) select 0) set [_index, _item];
                _updated = true;
            };
        };
        case "Item": { //--- Uniform, vest, helm, gps, compass, toolkit...
            _sub_type = if (typeName (_get select 1) == "STRING") then {_get select 1} else {(_get select 1) select 1};

            switch (true) do {
                case (_sub_type in ["","BaseItem"]): {
                    _slot = switch (getText(configFile >> 'CfgWeapons' >> _item >> 'simulation')) do {
                        case "ItemMap": {0};
                        case "ItemGPS": {1};
                        case "ItemRadio": {2};
                        case "ItemCompass": {3};
                        case "ItemWatch": {4};
                        default {-1};
                    };

                    if (_slot != -1) then { //--- Special item
                        _current = ((_gear select 3) select 1) select _slot;

                        if (_current != _item) then {
                            ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl (70008+_slot)) ctrlSetText getText(configFile >> 'CfgWeapons' >> _item >> 'picture');
                            ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl (70008+_slot)) ctrlSetTooltip getText(configFile >> 'CfgWeapons' >> _item >> 'displayName');

                            ((_gear select 3) select 1) set [_slot, _item];
                            _updated = true;
                        };
                    } else { //--- Stock item
                        _updated = [_item] call WFCL_fnc_tryContainerAddItem;
                    };
                };
                case (_sub_type in ["Acc-Muzzle","Acc-Optics","Acc-Side","Acc-Bipod"]): {
                    //--- Try to equip it.
                    _updated = [_item, _sub_type] call WFCL_fnc_tryEquipAccessory;

                };
                case (_sub_type == "Item"): {
                    _updated = [_item] call WFCL_fnc_tryContainerAddItem;
                };
                case (_sub_type == "Headgear"): {
                    _current = (_gear select 2) select 0;

                    if (_current != _item) then {
                        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70004) ctrlSetText getText(configFile >> 'CfgWeapons' >> _item >> 'picture');
                        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70004) ctrlSetTooltip getText(configFile >> 'CfgWeapons' >> _item >> 'displayName');

                        (_gear select 2) set [0, _item];
                        _updated = true;
                    };
                };
                case (_sub_type in ["Uniform","Vest"]): {
                    _updated = [_item, if (_sub_type == "Uniform") then {0} else {1}] call WFCL_fnc_replaceContainer;
                };
            };
        };
        case "Magazines": {
            _updated = [_item] call WFCL_fnc_tryContainerAddItem;
        };
        case "Backpack": {
            _updated = [_item, 2] call WFCL_fnc_replaceContainer;
        };
        case "Goggles": {
            _current = (_gear select 2) select 1;

            if (_current != _item) then {
                ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70005) ctrlSetText getText(configFile >> 'CfgGlasses' >> _item >> 'picture');
                ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70005) ctrlSetTooltip getText(configFile >> 'CfgGlasses' >> _item >> 'displayName');

                (_gear select 2) set [1, _item];
                _updated = true;
            };
        };
    };
};

_updated