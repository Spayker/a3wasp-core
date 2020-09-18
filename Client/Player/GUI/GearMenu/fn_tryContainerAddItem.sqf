private ["_container", "_item", "_updated"];

_item = _this select 0;
_container = if (count _this > 1) then {_this select 1} else {uiNamespace getVariable "wf_dialog_ui_gear_items_tab"};
_tryAll = if (count _this > 2) then {_this select 2} else {true};
_updated = false;

if ([_item, _container] call WFCL_fnc_canAddItemWithMass) then {
    [_item, _container] call WFCL_fnc_addContainerItem;
    ["ContainerItem", "", _item, [_container]] call WFCL_fnc_updateMass; //--- Update the mass.
    [_container, 70301+_container] call WFCL_fnc_updateContainerProgress; //--- Update the Mass RscProgress
    _updated = true;
};
if (!_updated && _tryAll) then {
	{
		_updated = [_item, _x, false] call CTI_UI_Gear_TryContainerAddItem;
		if (_updated) exitWith {};
	} forEach [0,1,2];
};
_updated