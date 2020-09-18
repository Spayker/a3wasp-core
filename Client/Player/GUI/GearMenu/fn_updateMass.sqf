//--- Update the mass of an inventory's part (+/-). TODO: Find the thin-air value that's used to define infantry maximum load
private["_extra","_item_new","_item_old","_mass","_mass_new","_mass_old","_part"];

_part = _this select 0;
_item_old = _this select 1;
_item_new = _this select 2;
_extra = if (count _this > 3) then {_this select 3} else {[]};

_mass = uiNamespace getVariable "wf_dialog_ui_gear_target_gear_mass";
_mass_old = if (_item_old != "") then {(_item_old) call WFCL_fnc_getGenericItemMass} else {0};
_mass_new = if (_item_new != "") then {(_item_new) call WFCL_fnc_getGenericItemMass} else {0};

switch (_part) do {
    case "Container": { //--- Update either, the uniform, vest or backpack
        _extra_index = _extra select 0;
        _extra_items = _extra select 1;

        _mass_recal = [_item_new, _extra_items] call WFCL_fnc_getContainerMass;
        _extra_items_mass = _mass_recal select 1;
        _extra_items_capacity = _mass_recal select 2;

        _mass_delta = _extra_items_mass - (((_mass select 1) select _extra_index) select 0);

        _mass set [0, (_mass select 0) + _mass_delta];
        ((_mass select 1) select _extra_index) set [0, _mass_delta];
        ((_mass select 1) select _extra_index) set [1, _extra_items_capacity];
    };
    case "ContainerItem": {
        _extra_index = _extra select 0;

        ((_mass select 1) select _extra_index) set [0, (((_mass select 1) select _extra_index) select 0) - _mass_old + _mass_new];
    };
};