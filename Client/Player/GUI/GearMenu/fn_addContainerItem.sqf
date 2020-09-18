//--- Add an item within a container.
private["_config", "_exists", "_gear", "_index", "_item", "_items", "_row"];

_item = _this select 0;
_index = _this select 1;

_gear = uiNamespace getVariable "wf_dialog_ui_gear_target_gear";

_items = ((_gear select 1) select _index) select 1;
_items = _items + [_item];
((_gear select 1) select _index) set [1, _items];

if (_index == uiNamespace getVariable "wf_dialog_ui_gear_items_tab") then {
    _exists = -1;
    for '_i' from 0 to ((lnbSize 70109) select 0)-1 do {
        if (lnbData[70109, [_i, 0]] == _item) exitWith {_exists = _i};
    };

    if (_exists != -1) then {
        lnbSetValue [70109, [_exists,0], lnbValue[70109,[_exists,0]] + 1];
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70109) lnbSetText [[_exists, 0], format["x%1", lnbValue[70109,[_exists,0]]]];
    } else {
        _config = (_item) call WFCO_FNC_GetConfigType;
        _row = lnbAddRow [70109, ["x1", format ["%1", getText(configFile >> _config >> _item >> 'displayName')]]];
        lnbSetPicture [70109, [_row, 0], getText(configFile >> _config >> _item >> 'picture')];
        lnbSetData [70109, [_row, 0], _item];
        lnbSetValue [70109, [_row, 0], 1];
    };
};