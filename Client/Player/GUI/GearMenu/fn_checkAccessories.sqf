//--- Check whether accessories shall be kept after changing a weapon or not
private ["_defaults", "_defaults_process", "_gear", "_index", "_idcs", "_item"];

_item = _this select 0;
_index = _this select 1;
_idcs = _this select 2;

_defaults = ["\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_muzzle_gs.paa","\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_side_gs.paa","\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_top_gs.paa", "\A3\ui_f\data\gui\Rsc\RscDisplayGear\ui_gear_bipod_gs.paa"];
_defaults_process = [];

_gear = uiNamespace getVariable "wf_dialog_ui_gear_target_gear";
if (_item == "" || count(((_gear select 0) select _index) select 1) == 0) then {
    ((_gear select 0) select _index) set [1, []];
    _defaults_process = [0,1,2];
} else {
    _config_properties = ["MuzzleSlot","PointerSlot","CowsSlot","UnderBarrelSlot"];

    for '_i' from 0 to 3 do {
        _compatibleItems = (getArray(configFile >> 'CfgWeapons' >> _item >> 'WeaponSlotsInfo' >> _config_properties select _i >> 'compatibleItems') call WFCO_FNC_ArrayToLower);
        {_compatibleItems pushBack toLower(configName _x)} forEach (configProperties[configfile >> "CfgWeapons" >> _item >> "WeaponSlotsInfo" >> _config_properties select _i >> "compatibleItems", "true", true]);

        if !(toLower((((_gear select 0) select _index) select 1) select _i) in _compatibleItems) then {
            (((_gear select 0) select _index) select 1) set [_i, ""];
            _defaults_process = _defaults_process + [_i];
        };
    };
};

{
    ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl (_idcs select _x)) ctrlSetText (_defaults select _x);
    ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl (_idcs select _x)) ctrlSetTooltip "";
} forEach _defaults_process;