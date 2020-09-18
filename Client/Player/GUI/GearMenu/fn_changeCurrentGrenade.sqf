
private ["_gear", "_idc", "_item", "_slot_type", "_updated"];

_item = _this select 0;
_slot_type = _this select 1;
_idc = _this select 2;

_gear = uiNamespace getVariable "wf_dialog_ui_gear_target_gear";
_updated = false;
if (_item == "") then { //--- Remove
    if (count(((_gear select 0) select _slot_type) select 2) > 0) then {
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) ctrlSetText "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_magazine_gs.paa";
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) ctrlSetTooltip "";
        _magArray = (((_gear select 0) select _slot_type) select 2);
        _magArray deleteAt 1;
    _updated = true;
};
} else { //--- Add
    ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) ctrlSetText getText(configFile >> 'CfgMagazines' >> _item >> 'picture');
    ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) ctrlSetTooltip getText(configFile >> 'CfgMagazines' >> _item >> 'displayName');
    _magArray = (((_gear select 0) select _slot_type) select 2);
    if (count _magArray == 0) then {
        _magArray pushBack _item;
    } else {
        _magArray set [1, _item];
    };

    _updated = true;
};
_updated