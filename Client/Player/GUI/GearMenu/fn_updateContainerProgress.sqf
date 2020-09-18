//--- Update the corresponding RscProgress bar
private["_container_capacity", "_container_items_mass", "_idc", "_index", "_mass", "_progress"];

_index = _this select 0;
_idc = _this select 1;

_mass = uiNamespace getVariable "wf_dialog_ui_gear_target_gear_mass";
_container_items_mass = ((_mass select 1) select _index) select 0;
_container_capacity = ((_mass select 1) select _index) select 1;

_progress = if (_container_capacity != 0) then {_container_items_mass / _container_capacity} else {0};
((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) progressSetPosition _progress;
((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) ctrlSetTooltip (if (_container_capacity != 0) then {Format ["Mass: %1 / %2", ((_mass select 1) select _index) select 0, ((_mass select 1) select _index) select 1]} else {""});