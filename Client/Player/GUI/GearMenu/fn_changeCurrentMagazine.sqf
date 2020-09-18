private ["_gear", "_idc", "_item", "_slot_type", "_updated"];

_item = _this select 0;
_slot_type = _this select 1;
_idc = _this select 2;

_gear = uiNamespace getVariable "wf_dialog_ui_gear_target_gear";
_updated = false;

	if (_item isEqualTo "") then { //--- Remove
    if (count(((_gear select 0) select _slot_type) select 2) > 0) then {
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) ctrlSetText "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_magazine_gs.paa";
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) ctrlSetTooltip "";
        ((_gear select 0) select _slot_type) set [2, []];
        _updated = true;
    };
} else { //--- Add
    ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) ctrlSetText getText(configFile >> 'CfgMagazines' >> _item >> 'picture');
    ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) ctrlSetTooltip getText(configFile >> 'CfgMagazines' >> _item >> 'displayName');

    ((_gear select 0) select _slot_type) set [2, [_item]];
    _updated = true;
};

_updated