//--- Display the gear on the Gear UI
private ["_config_base", "_gear", "_load", "_startidc", "_startidc_current_mag", "_use", "_use_id"];

_gear = _this;

//--- Weapons
_startidc = 70013;
_startidc_current_mag = 70901;
_startidc_current_gp = 70992;

_default_weapons = ["\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_primary_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_secondary_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_hgun_gs.paa"];
_default_accs = ["\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_muzzle_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_side_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_top_gs.paa", "\A3\ui_f\data\gui\Rsc\RscDisplayGear\ui_gear_bipod_gs.paa"];
_default_clothes = ["\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_uniform_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_vest_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_backpack_gs.paa"];
_default_bin = ["\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_helmet_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_glasses_gs.paa"];
_default_items = [["\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_nvg_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_binocular_gs.paa"], ["\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_map_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_gps_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_radio_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_compass_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_watch_gs.paa"]];

{
    if !((_x select 0) isEqualTo "") then {
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetText getText(configFile >> 'CfgWeapons' >> _x select 0 >> 'picture');
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetTooltip getText(configFile >> 'CfgWeapons' >> _x select 0 >> 'displayName');
    } else {
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetText (_default_weapons select _forEachIndex);
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetTooltip "";
    };
    _startidc = _startidc + 1;

    if (count (_x select 1) > 0) then {
        for '_i' from 0 to 3 do {
            if !(((_x select 1) select _i) isEqualTo "") then {
                ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetText getText(configFile >> 'CfgWeapons' >> (_x select 1) select _i >> 'picture');
                ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetTooltip getText(configFile >> 'CfgWeapons' >> (_x select 1) select _i >> 'displayName');
            } else {
                ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetText (_default_accs select _i);
                ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetTooltip "";
            };
            _startidc = _startidc + 1;
        };
    } else {
        for '_i' from 0 to 3 do {
            ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetText (_default_accs select _i);
            ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetTooltip "";
            _startidc = _startidc + 1;
        };
    };

    if (count(_x select 2) > 0) then {
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc_current_mag+_forEachindex) ctrlSetText getText(configFile >> 'CfgMagazines' >> ((_x select 2) select 0) >> 'picture');
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc_current_mag+_forEachindex) ctrlSetTooltip getText(configFile >> 'CfgMagazines' >> ((_x select 2) select 0) >> 'displayName');
    } else {
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc_current_mag+_forEachindex) ctrlSetText "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_magazine_gs.paa";
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc_current_mag+_forEachindex) ctrlSetTooltip "";
    };

    if (count(_x select 2) > 0) then {
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc_current_gp+_forEachindex) ctrlSetText getText(configFile >> 'CfgMagazines' >> ((_x select 2) select 1) >> 'picture');
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc_current_gp+_forEachindex) ctrlSetTooltip getText(configFile >> 'CfgMagazines' >> ((_x select 2) select 1) >> 'displayName');
    } else {
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc_current_gp+_forEachindex) ctrlSetText "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_magazine_gs.paa";
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc_current_gp+_forEachindex) ctrlSetTooltip "";
    };
} forEach (_gear select 0);

//--- Uniform, Vest and backpack
{
    if !((_x select 0) isEqualTo "") then {
        _config_base = (_x select 0) call WFCO_FNC_GetConfigType;
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70001+_forEachIndex) ctrlSetText getText(configFile >> _config_base >> _x select 0 >> 'picture');
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70001+_forEachIndex) ctrlSetTooltip getText(configFile >> _config_base >> _x select 0 >> 'displayName');
    } else {
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70001+_forEachIndex) ctrlSetText (_default_clothes select _forEachIndex);
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70001+_forEachIndex) ctrlSetTooltip "";
    };
} forEach (_gear select 1);

//--- Accessories
{
    if !(_x isEqualTo "") then {
        _config = ["CfgGlasses", "CfgWeapons"] select (isClass(configFile >> 'CfgWeapons' >> _x));
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70004+_forEachIndex) ctrlSetText getText(configFile >> _config >> _x >> 'picture');
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70004+_forEachIndex) ctrlSetTooltip getText(configFile >> _config >> _x >> 'displayName');
    } else {
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70004+_forEachIndex) ctrlSetText (_default_bin select _forEachIndex);
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70004+_forEachIndex) ctrlSetTooltip "";
    };
} forEach (_gear select 2);

//--- Accessories - specials and items
_startidc = 70006;
{
    _def_root = _forEachIndex;
    {
        if (_x isEqualType []) then {
	    // We have a binocular array ["bino", "magazine"]
	    _x = _x select 0;
	};
        if !(_x isEqualTo "") then {
            ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetText getText(configFile >> 'CfgWeapons' >> _x >> 'picture');
            ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetTooltip getText(configFile >> 'CfgWeapons' >> _x >> 'displayName');
        } else {
            ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetText ((_default_items select _def_root) select _forEachIndex);
            ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetTooltip "";
        };
        _startidc = _startidc + 1;
    } forEach _x;
} forEach (_gear select 3);

//--- Unless told otherwise, load the vest content.
_idcs = [77001,77002,77003];
_load = [1,0,2];
_use = [];
_use_id = 0;
{
    if !((((_gear select 1) select _x) select 0) isEqualTo "") exitWith {_use = ((_gear select 1) select _x) select 1; _use_id = _x};
} forEach _load;

uiNamespace setVariable ["wf_dialog_ui_gear_items_tab", _use_id];
((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl (_idcs select _use_id)) ctrlSetBackgroundColor [1, 1, 1, 0.4];

{
    ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _x) ctrlSetBackgroundColor [1, 1, 1, 0.15];
} forEach (_idcs - [_idcs select _use_id]);

(_use) call WFCL_fnc_displayContainerItems;