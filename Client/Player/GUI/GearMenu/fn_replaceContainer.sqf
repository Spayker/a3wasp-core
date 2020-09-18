//--- Replace a container (Uniform, Vest or Backpack)
private ["_config_base", "_container", "_current", "_defaults", "_gear", "_item", "_updated"];

_item = _this select 0;
_container = _this select 1;
_updated = false;

_gear = uiNamespace getVariable "wf_dialog_ui_gear_target_gear";

if !(_item isEqualTo "") then {
    _current = ((_gear select 1) select _container) select 0;
    _config_base = (_item) call WFCO_FNC_GetConfigType;

    if (_current != _item) then {
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70001 + _container) ctrlSetText getText(configFile >> _config_base >> _item >> 'picture');
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70001 + _container) ctrlSetTooltip getText(configFile >> _config_base >> _item >> 'displayName');

        _contents = ((_gear select 1) select _container) select 1;
        _contentsmass = _contents call WFCL_fnc_getItemsMass;
        _containercapacity = _item call WFCL_fnc_getContainerMassCapacity;

            ["Container", "", _item, [_container, _contents]] call WFCL_fnc_updateMass;
            [_container, 70301+_container] call WFCL_fnc_updateContainerProgress; //--- Update the Mass RscProgress

        if (_contentsmass <= _containercapacity) then {
            (_gear select 1) set [_container, [_item, _contents]];
        } else {
            (_gear select 1) set [_container, [_item, []]];
        };

            ["Container", "", _item, [_container, ((_gear select 1) select _container) select 1]] call WFCL_fnc_updateMass;
        [_container, 70301+_container] call WFCL_fnc_updateContainerProgress; //--- Update the Mass RscProgress

        uiNamespace setVariable ["cti_dialog_ui_gear_target_gear", _gear];

        _updated = true;
    };
} else {
    if !((((_gear select 1) select _container) select 0) isEqualTo "") then {
        _defaults = ["\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_uniform_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_vest_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_backpack_gs.paa"];

        ["Container", "", _item, [_container, ((_gear select 1) select _container) select 1]] call WFCL_fnc_updateMass;

        (_gear select 1) set [_container, [_item,[]]];

        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70001 + _container) ctrlSetText (_defaults select _container);
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70001 + _container) ctrlSetTooltip "";

        [_container, 70301+_container] call WFCL_fnc_updateContainerProgress;
        _updated = true;
    };
};

if ((uiNamespace getVariable "wf_dialog_ui_gear_items_tab") isEqualTo _container) then {(((_gear select 1) select _container) select 1) call WFCL_fnc_displayContainerItems};

_updated