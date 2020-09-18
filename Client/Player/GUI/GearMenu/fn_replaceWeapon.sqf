//--- Replace or remove a weapon (Primary, Secondary or Pistol)
private ["_accessories", "_changed", "_defaults", "_gear", "_idc", "_index", "_item", "_item_old"];

_item = _this select 0;
_index = _this select 1;
_removeMagazines = if (count _this > 2) then {_this select 2} else {false};

_idc = [70013,70018,70023] select _index;
_gear = uiNamespace getVariable "wf_dialog_ui_gear_target_gear";

_accessories = ((_gear select 0) select _index) select 1;
_item_old = ((_gear select 0) select _index) select 0;

_changed = true;

if !(_item isEqualTo "") then { //--- Replace
    switch (_index) do {
        case 0: { //--- Adding a primary weapon
            if ((_item call WFCL_fnc_getItemConfigType) isEqualTo 5) then { ["", 1] call WFCL_fnc_replaceWeapon }; //--- The launcher is gone if the weapon is considered heavy
        };
        case 1: { //--- Adding a secondary weapon
            _primary = ((_gear select 0) select 0) select 0;
            if !(_primary isEqualTo "") then {
                if ((_primary call WFCL_fnc_getItemConfigType) isEqualTo 5) then { _changed = false }; //--- Heavy primary prevent the launcher from being picked
            };
        };
    };

    if (_changed) then {
        ((_gear select 0) select _index) set [0, _item];
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) ctrlSetText getText(configFile >> 'CfgWeapons' >> _item >> 'picture');
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) ctrlSetTooltip getText(configFile >> 'CfgWeapons' >> _item >> 'displayName');

        //--- Do we keep the ammunitions?
        if (!(_item_old isEqualTo "")) then {[_item_old, _item, _removeMagazines] call WFCL_fnc_checkMagazines};
    };
} else { //--- Remove
    _defaults = ["\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_primary_gs.paa","\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_secondary_gs.paa","\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_hgun_gs.paa"];
    (_gear select 0) set [_index, ["", [], [""]]];

    ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) ctrlSetText (_defaults select _index);
    ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) ctrlSetTooltip "";

    ["", _index, 70901+_index] call WFCL_fnc_changeCurrentMagazine;
    ["", _index, 70992+_index] call WFCL_fnc_changeCurrentGrenade;
};

if (_changed) then { [_item, _index, [_idc+1, _idc+2, _idc+3, _idc+4]] call WFCL_fnc_checkAccessories }; //--- Do we keep the accessories?