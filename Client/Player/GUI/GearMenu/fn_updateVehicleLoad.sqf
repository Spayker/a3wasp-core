private ["_item"];
_item = _this select 0;
_operation = _this select 1;

_mass_item = _item call WFCL_fnc_getGenericItemMass;
_mass = uiNamespace getVariable "wf_dialog_ui_gear_target_gear_mass";
_mass set [1, if (_operation isEqualTo "delete") then {(_mass select 1) - _mass_item} else {(_mass select 1) + _mass_item}];