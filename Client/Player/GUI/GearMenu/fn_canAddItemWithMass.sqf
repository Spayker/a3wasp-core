//--- Determine if an item can be added to a container based on it's mass and the one of the container.
private["_index", "_item", "_mass", "_mass_capacity_container", "_mass_item", "_mass_items_container"];
_item = _this select 0;
_index = _this select 1;

_mass = uiNamespace getVariable "wf_dialog_ui_gear_target_gear_mass";

_mass_item = (_item) call WFCL_fnc_getGenericItemMass;
_mass_items_container = ((_mass select 1) select _index) select 0;
_mass_capacity_container = ((_mass select 1) select _index) select 1;

if (_mass_item + _mass_items_container <= _mass_capacity_container) then {true} else {false}