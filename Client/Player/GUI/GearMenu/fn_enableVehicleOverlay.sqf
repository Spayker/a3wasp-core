private ["_startidc"];

//--- Weapons
_startidc = 70013;

_default_weapons = ["\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_primary_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_secondary_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_hgun_gs.paa"];
_default_accs = ["\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_muzzle_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_side_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_top_gs.paa", "\A3\ui_f\data\gui\Rsc\RscDisplayGear\ui_gear_bipod_gs.paa"];
_default_clothes = ["\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_uniform_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_vest_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_backpack_gs.paa"];
_default_bin = ["\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_helmet_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_glasses_gs.paa"];
_default_items = [["\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_nvg_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_binocular_gs.paa"], ["\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_map_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_gps_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_radio_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_compass_gs.paa", "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_watch_gs.paa"]];

for '_i' from 0 to 2 do {
    ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetText (_default_weapons select _i);
    ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetTooltip "";
    _startidc = _startidc + 1;

    for '_j' from 0 to 3 do {
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetText (_default_accs select _j);
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetTooltip "";
        _startidc = _startidc + 1;
    };
};

//--- Uniform, Vest and backpack
for '_i' from 0 to 2 do {
    ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70001+_i) ctrlSetText (_default_clothes select _i);
    ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70001+_i) ctrlSetTooltip "";
};

//--- Accessories
for '_i' from 0 to 1 do {
    ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70004+_i) ctrlSetText (_default_bin select _i);
    ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70004+_i) ctrlSetTooltip "";
};

//--- Accessories - specials and items
_startidc = 70006;
{
    _index = _forEachIndex;
    {
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetText ((_default_items select _index) select _forEachIndex);
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _startidc) ctrlSetTooltip "";
        _startidc = _startidc + 1;
    } forEach _x;
} forEach _default_items;

//--- Load the vest/vehicle container
uiNamespace setVariable ["wf_dialog_ui_gear_items_tab", 0];
(uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 77001 ctrlSetBackgroundColor [1, 1, 1, 0.4];

{((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _x) ctrlSetBackgroundColor [1, 1, 1, 0.15]} forEach [77002, 77003];

//--- Mask the extra containers
{((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _x) progressSetPosition 0} forEach [70302, 70303];