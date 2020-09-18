//--- An item from the purchase list is being dropped.
private ["_config_type", "_current", "_gear", "_gear_index", "_gear_set", "_idc", "_item", "_kind", "_path", "_updated"];

_idc = _this select 0;
_item = _this select 1;
_kind = _this select 2;
_path = _this select 3;

_gear = uiNamespace getVariable "wf_dialog_ui_gear_target_gear";

_updated = false;
if (_idc in (uiNamespace getVariable "wf_dialog_ui_gear_drag_colored_idc")) then { //--- Allowed action
    if (uiNamespace getVariable "wf_dialog_ui_gear_target" isKindOf "Man") then {
    _current = "!nil!";
    _gear_index = -1;
    _gear_set = [];
    switch (_kind) do {
        case "HeadAsset": {
            _current = (_gear select (_path select 0)) select (_path select 1);
            _gear_set = _gear select (_path select 0);
            _gear_index = _path select 1;
        };
        case "Item": {
            _current = ((_gear select (_path select 0)) select (_path select 1)) select (_path select 2);
            _gear_set = (_gear select (_path select 0)) select (_path select 1);
            _gear_index = _path select 2;
        };
        case "Accessory": {
            _current = ((_gear select (_path select 0)) select (_path select 1)) select (_path select 2);
                if (count _current == 0) then {_current = ["","","",""];((_gear select (_path select 0)) select (_path select 1)) set [_path select 2, ["","","",""]]};
            _current = _current select (_path select 3);
            _gear_set = ((_gear select (_path select 0)) select (_path select 1)) select (_path select 2);
            _gear_index = _path select 3;
        };
        case "Weapon": {
            [_item, _path] call WFCL_fnc_replaceWeapon;
            _updated = true;
        };
        case "Container": {
            if (([WF_SUBTYPE_UNIFORM, WF_SUBTYPE_VEST, WF_SUBTYPE_BACKPACK] select _path) == (_item call WFCL_fnc_getItemConfigType)) then { //--- Same type, replace
                _updated = [_item, _path] call WFCL_fnc_replaceContainer;
            } else { //--- Type differ, try to add
                _updated = [_item, _path] call WFCL_fnc_tryContainerAddItem;
            };
        };
        case "ListItems": { _updated = [_item] call WFCL_fnc_tryContainerAddItem };
        case "CurrentMagazine": { _updated = [_item, _path, _idc-7000] call WFCL_fnc_changeCurrentMagazine };
        case "CurrentGP":       { _updated = [_item, _path, _idc-7000] call WFCL_fnc_changeCurrentGrenade };
    };

    if (_current != _item && _gear_index != -1) then {
        _config_type = (_item) call WFCO_FNC_GetConfigType;
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc-7000) ctrlSetText getText(configFile >> _config_type >> _item >> 'picture');
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc-7000) ctrlSetTooltip getText(configFile >> _config_type >> _item >> 'displayName');

        _gear_set set [_gear_index, _item];
        _updated = true;
    };
    } else {
        _updated = [_gear, _item] call WFCL_fnc_addVehicleItem;
    };
};

_updated