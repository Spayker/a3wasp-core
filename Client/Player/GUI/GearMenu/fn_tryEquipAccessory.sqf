private["_accessory", "_gear"];

_accessory = _this select 0;
_sub_type = _this select 1;

_gear = uiNamespace getVariable "wf_dialog_ui_gear_target_gear";

//--- Retrieve the matching config element
_config_properties_acc = ["MuzzleSlot","PointerSlot","CowsSlot","UnderBarrelSlot"];
_config_properties = ["Acc-Muzzle","Acc-Side","Acc-Optics","Acc-Bipod"];

_index_acc = _config_properties find _sub_type;
_config = _config_properties_acc select _index_acc;
_idcs_acc_start = [70014, 70019, 70024]; //--- Muzzle IDCs

//--- Check each weapons
_match = false;
{
    if (_x select 0 != "") then {
        //--- Check if the accessory is already equiped or not
        _do_check = true;
        if (count(_x select 1) > 0) then {
            if ((_x select 1) select _index_acc == _accessory) then {_do_check = false};
        };

        //--- Check if the accessory is compatible with this weapon
        if (_do_check) then {
            _compatibleItems = (getArray(configFile >> 'CfgWeapons' >> (_x select 0) >> 'WeaponSlotsInfo' >> _config >> 'compatibleItems') call WFCO_FNC_ArrayToLower);
            {_compatibleItems pushBack toLower(configName _x)} forEach (configProperties[configfile >> "CfgWeapons" >> (_x select 0) >> "WeaponSlotsInfo" >> _config >> "compatibleItems", "true", true]);

            if (_accessory in _compatibleItems) then { //--- On match, equip the accessory
                _match = true;
                (((_gear select 0) select _forEachIndex) select 1) set [_index_acc, _accessory];
                ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl ((_idcs_acc_start select _forEachIndex)+_index_acc)) ctrlSetText getText(configFile >> 'CfgWeapons' >> _accessory >> 'picture');
                ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl ((_idcs_acc_start select _forEachIndex)+_index_acc)) ctrlSetTooltip getText(configFile >> 'CfgWeapons' >> _accessory >> 'displayName');
            };
        };
    };

    if (_match) exitWith {};
} forEach (_gear select 0);

_match