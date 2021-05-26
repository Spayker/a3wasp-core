Private ['_oldListPrimary', '_oldListSecondary', '_oldListPistol', '_oldListMagazines', '_oldListAccessories', '_oldListMisc', '_oldListSpecial', '_oldListUniforms', '_oldListVests', '_oldListBackpacks', '_oldListHeadgear', '_oldListGlasses', '_oldListExplosives', '_oldGear', '', '', '', '', '', '', '', '', '', '', '', '', ''];

{ WF_C_GEAR_LIST deleteAt _forEachIndex } forEach WF_C_GEAR_LIST;

_oldListPrimary = missionNamespace getVariable ['wf_gear_list_primary', []];
_oldListSecondary = missionNamespace getVariable ['wf_gear_list_secondary', []];
_oldListPistol = missionNamespace getVariable ['wf_gear_list_pistol', []];
_oldListMagazines = missionNamespace getVariable ['wf_gear_list_magazines', []];
_oldListAccessories = missionNamespace getVariable ['wf_gear_list_accessories', []];
_oldListMisc = missionNamespace getVariable ['wf_gear_list_misc', []];
_oldListSpecial = missionNamespace getVariable ['wf_gear_list_special', []];
_oldListUniforms = missionNamespace getVariable ['wf_gear_list_uniforms', []];
_oldListVests = missionNamespace getVariable ['wf_gear_list_vests', []];
_oldListBackpacks = missionNamespace getVariable ['wf_gear_list_backpacks', []];
_oldListHeadgear = missionNamespace getVariable ['wf_gear_list_headgear', []];
_oldListGlasses = missionNamespace getVariable ['wf_gear_list_glasses', []];
_oldListExplosives = missionNamespace getVariable ['wf_gear_list_explosives', []];

{
    _oldGear = missionNamespace getVariable [format["wf_%1", _x], nil];
    if!(isNil '_oldGear') then { missionNamespace setVariable [format["wf_%1", _x], nil] }
} forEach (_oldListPrimary + _oldListSecondary + _oldListPistol + _oldListMagazines + _oldListAccessories +
    _oldListMisc + _oldListSpecial + _oldListUniforms + _oldListVests + _oldListBackpacks + _oldListHeadgear +
        _oldListGlasses + _oldListExplosives);

missionNamespace setVariable ['wf_gear_list_primary', nil];
missionNamespace setVariable ['wf_gear_list_secondary', nil];
missionNamespace setVariable ['wf_gear_list_pistol', nil];
missionNamespace setVariable ['wf_gear_list_magazines', nil];
missionNamespace setVariable ['wf_gear_list_accessories', nil];
missionNamespace setVariable ['wf_gear_list_misc', nil];
missionNamespace setVariable ['wf_gear_list_special', nil];
missionNamespace setVariable ['wf_gear_list_uniforms', nil];
missionNamespace setVariable ['wf_gear_list_vests', nil];
missionNamespace setVariable ['wf_gear_list_backpacks', nil];
missionNamespace setVariable ['wf_gear_list_headgear', nil];
missionNamespace setVariable ['wf_gear_list_glasses', nil];
missionNamespace setVariable ['wf_gear_list_explosives', nil];


{
    _oldListPrimary = missionNamespace getVariable [format ['wf_gear_list_primary_%1', _x], []];
    _oldListSecondary = missionNamespace getVariable [format ['wf_gear_list_secondary_%1', _x], []];
    _oldListPistol = missionNamespace getVariable [format ['wf_gear_list_pistol_%1', _x], []];
    _oldListMagazines = missionNamespace getVariable [format ['wf_gear_list_magazines_%1', _x], []];
    _oldListAccessories = missionNamespace getVariable [format ['wf_gear_list_accessories_%1', _x], []];
    _oldListMisc = missionNamespace getVariable [format ['wf_gear_list_misc_%1', _x], []];
    _oldListSpecial = missionNamespace getVariable [format ['wf_gear_list_special_%1', _x], []];
    _oldListUniforms = missionNamespace getVariable [format ['wf_gear_list_uniforms_%1', _x], []];
    _oldListVests = missionNamespace getVariable [format ['wf_gear_list_vests_%1', _x], []];
    _oldListBackpacks = missionNamespace getVariable [format ['wf_gear_list_backpacks_%1', _x], []];
    _oldListHeadgear = missionNamespace getVariable [format ['wf_gear_list_headgear_%1', _x], []];
    _oldListGlasses = missionNamespace getVariable [format ['wf_gear_list_glasses_%1', _x], []];
    _oldListExplosives = missionNamespace getVariable [format ['wf_gear_list_explosives_%1', _x], []];

    {
        _oldGear = missionNamespace getVariable [format["wf_%1", _x], nil];
        if!(isNil '_oldGear') then { missionNamespace setVariable [format["wf_%1", _x], nil] }
    } forEach (_oldListPrimary + _oldListSecondary + _oldListPistol + _oldListMagazines + _oldListAccessories +
        _oldListMisc + _oldListSpecial + _oldListUniforms + _oldListVests + _oldListBackpacks + _oldListHeadgear +
            _oldListGlasses + _oldListExplosives);

    missionNamespace setVariable [format ['wf_gear_list_primary_%1', _x], nil];
    missionNamespace setVariable [format ['wf_gear_list_secondary_%1', _x], nil];
    missionNamespace setVariable [format ['wf_gear_list_pistol_%1', _x], nil];
    missionNamespace setVariable [format ['wf_gear_list_magazines_%1', _x], nil];
    missionNamespace setVariable [format ['wf_gear_list_accessories_%1', _x], nil];
    missionNamespace setVariable [format ['wf_gear_list_misc_%1', _x], nil];
    missionNamespace setVariable [format ['wf_gear_list_special_%1', _x], nil];
    missionNamespace setVariable [format ['wf_gear_list_uniforms_%1', _x], nil];
    missionNamespace setVariable [format ['wf_gear_list_vests_%1', _x], nil];
    missionNamespace setVariable [format ['wf_gear_list_backpacks_%1', _x], nil];
    missionNamespace setVariable [format ['wf_gear_list_headgear_%1', _x], nil];
    missionNamespace setVariable [format ['wf_gear_list_glasses_%1', _x], nil];
    missionNamespace setVariable [format ['wf_gear_list_explosives_%1', _x], nil];
} forEach [WF_RECON, WF_SUPPORT];

{
    _x setVariable ["TER_VASS_cargo_default", nil];
    _x setVariable ["TER_VASS_cargo", nil];
} forEach WF_C_GEAR_CARGO_OBJECTS;
