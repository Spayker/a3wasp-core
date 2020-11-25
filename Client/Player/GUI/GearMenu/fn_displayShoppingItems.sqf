private ["_get", "_list", "_tab", "_upgrade_gear", "_upgrades"];

ctrlSetText [22556, ""];

_tab = _this;

(_tab) call WFCL_fnc_highlightTab;

lnbClear 70108;

for "_lnbIdx" from 0 to (((lnbSize 70108) # 1) - 1) do {
    lnbDeleteColumn [70108, _lnbIdx];
};

lnbAddColumn [70108,0];
lnbSetColumnsPos [70108, [0.26, 0.00075]];


_selectedRole = WF_gbl_boughtRoles select 0;
if!(isnil '_selectedRole')then{
    _list = switch (_tab) do {
        case WF_GEAR_TAB_PRIMARY: {
            _gearListPrimary = missionNamespace getVariable format["wf_gear_list_primary_%1",_selectedRole];
            if!(isNil '_gearListPrimary')then{
                (missionNamespace getVariable "wf_gear_list_primary") + _gearListPrimary
            } else {
                missionNamespace getVariable "wf_gear_list_primary"
            };
         };
        case WF_GEAR_TAB_SECONDARY: {
            _gear_list_secondary = missionNamespace getVariable format["wf_gear_list_secondary_%1",_selectedRole];
            if!(isNil '_gear_list_secondary')then{
                (missionNamespace getVariable "wf_gear_list_secondary") + _gear_list_secondary
            } else {
                missionNamespace getVariable "wf_gear_list_secondary"
            };
        };
        case WF_GEAR_TAB_HANDGUN: {
            _gear_list_pistol = missionNamespace getVariable format["wf_gear_list_pistol_%1",_selectedRole];
            if!(isNil '_gear_list_pistol')then{
                (missionNamespace getVariable "wf_gear_list_pistol") + _gear_list_pistol
            } else {
                missionNamespace getVariable "wf_gear_list_pistol"
            };
        };
        case WF_GEAR_TAB_UNIFORMS: {
            _gear_list_uniforms = missionNamespace getVariable format["wf_gear_list_uniforms_%1",_selectedRole];
            if(!(isNil '_gear_list_uniforms'))then{
                (missionNamespace getVariable "wf_gear_list_uniforms") + _gear_list_uniforms
            } else {
                (missionNamespace getVariable "wf_gear_list_uniforms")
            }
            };
        case WF_GEAR_TAB_BACKPACK: {
            _gear_list_backpacks = missionNamespace getVariable format["wf_gear_list_backpacks_%1",_selectedRole];
            if(!(isNil '_gear_list_backpacks'))then{
                (missionNamespace getVariable "wf_gear_list_backpacks") + _gear_list_backpacks
            } else {
                (missionNamespace getVariable "wf_gear_list_backpacks")
            }
        };
        case WF_GEAR_TAB_SPECIAL: {
            _gear_list_special = missionNamespace getVariable format["wf_gear_list_special_%1",_selectedRole];
            if(!(isNil '_gear_list_special'))then{
                (missionNamespace getVariable "wf_gear_list_special") + _gear_list_special
            } else {
                (missionNamespace getVariable "wf_gear_list_special")
            };
        };
        case WF_GEAR_TAB_EXPLOSIVES: {
            _gear_list_explosives = missionNamespace getVariable format["wf_gear_list_explosives_%1",_selectedRole];

            if(!(isNil '_gear_list_explosives'))then{
                (missionNamespace getVariable "wf_gear_list_explosives") + _gear_list_explosives
            } else {
                (missionNamespace getVariable "wf_gear_list_explosives")
            };
        };
        case WF_GEAR_TAB_HEADGEAR: {
            _gear_list_headgear = missionNamespace getVariable format["wf_gear_list_headgear_%1",_selectedRole];
            if(!(isNil '_gear_list_headgear'))then{
                (missionNamespace getVariable "wf_gear_list_headgear") + _gear_list_headgear
            } else {
                missionNamespace getVariable "wf_gear_list_headgear"
            }
        };
        case WF_GEAR_TAB_EQUIPMENT: {
            _gear_list_vests = missionNamespace getVariable format["wf_gear_list_vests_%1",_selectedRole];
            if(!(isNil '_gear_list_vests'))then{
                (missionNamespace getVariable "wf_gear_list_vests") + _gear_list_vests
            }else{
                (missionNamespace getVariable "wf_gear_list_vests")
            };
        };
        case WF_GEAR_TAB_GLASSES: {
            _gear_list_glasses = missionNamespace getVariable format["wf_gear_list_glasses_%1",_selectedRole];

            if(!(isNil '_gear_list_glasses'))then{
                (missionNamespace getVariable "wf_gear_list_glasses") + _gear_list_glasses
            }else{
                (missionNamespace getVariable "wf_gear_list_glasses")
            };
        };
        case WF_GEAR_TAB_MISC: {
            _gear_list_misc = missionNamespace getVariable format["wf_gear_list_misc_%1",_selectedRole];

            if(!(isNil '_gear_list_misc'))then{
                (missionNamespace getVariable "wf_gear_list_misc") + _gear_list_misc
            }else{
                (missionNamespace getVariable "wf_gear_list_misc")
            };
        };
        case WF_GEAR_TAB_MAGAZINES: {
            _gear_list_magazines = missionNamespace getVariable format["wf_gear_list_magazines_%1",_selectedRole];

            if(!(isNil '_gear_list_magazines'))then{
                (missionNamespace getVariable "wf_gear_list_magazines") + _gear_list_magazines
            }else{
                (missionNamespace getVariable "wf_gear_list_magazines")
            };
        };
    };
} else {
    _list = switch (_tab) do {
        case WF_GEAR_TAB_PRIMARY: {missionNamespace getVariable "wf_gear_list_primary"};
        case WF_GEAR_TAB_SECONDARY: {missionNamespace getVariable "wf_gear_list_secondary"};
        case WF_GEAR_TAB_HANDGUN: {missionNamespace getVariable "wf_gear_list_pistol"};
        case WF_GEAR_TAB_UNIFORMS: {missionNamespace getVariable "wf_gear_list_uniforms"};
        case WF_GEAR_TAB_BACKPACK: {missionNamespace getVariable "wf_gear_list_backpacks"};
        case WF_GEAR_TAB_SPECIAL: {(missionNamespace getVariable "wf_gear_list_special")};
        case WF_GEAR_TAB_EQUIPMENT: { (missionNamespace getVariable "wf_gear_list_vests") };
        case WF_GEAR_TAB_HEADGEAR: { (missionNamespace getVariable "wf_gear_list_headgear") };
        case WF_GEAR_TAB_GLASSES: { (missionNamespace getVariable "wf_gear_list_glasses") };
        case WF_GEAR_TAB_EXPLOSIVES: { (missionNamespace getVariable "wf_gear_list_explosives") };
        case WF_GEAR_TAB_MISC: { (missionNamespace getVariable "wf_gear_list_misc") };
        case WF_GEAR_TAB_MAGAZINES: { (missionNamespace getVariable "wf_gear_list_magazines") };
    };
};

_upgrades = (WF_Client_SideJoined) Call WFCO_FNC_GetSideUpgrades;
_upgrade_gear = _upgrades select WF_UP_GEAR;

if (_tab != WF_GEAR_TAB_TEMPLATES) then { //--- Generic items
    {
        _isRoleItem = false;
        _get = missionNamespace getVariable format["wf_%1", _x];

        if!(isnil '_selectedRole')then{
            _gearDetails = _get select 0;
            if(_gearDetails select 2 == _selectedRole)then{
                _isRoleItem = true;
            };
        };

        if !(isNil "_get") then {
            if (((_get select 0) select 0) <= _upgrade_gear) then { //--- Add the item if it's equal or below the upgrade level
                _row = lnbAddRow [70108, [getText(configFile >> _get select 2 >> _x >> 'displayName'), format ["$%1", (_get select 0) select 1]]];
                lnbSetPicture [70108, [_row, 1], getText(configFile >> _get select 2 >> _x >> 'picture')]; // shoplist pictures of guns
                lnbSetData [70108, [_row, 0], toLower(_x)];
                if(_isRoleItem)then{
                    lnbSetColor [70108,[_row,0],[0.6, 0.4, 0.6, 1.0]];
                    lnbSetColor [70108,[_row,1],[0.6, 0.4, 0.6, 1.0]];
                };
            };
        };
    } forEach _list;
} else { //--- Templates
    if(isNil "_selectedRole") then { _selectedRole = "" };

    _templates = missionNamespace getVariable [format["wf_player_gearTemplates_%1", _selectedRole], []];

    for "_lnbIdx" from 0 to (((lnbSize 70108) # 1) - 1) do {
        lnbDeleteColumn [70108, _lnbIdx];
    };

    lnbAddColumn [70108,0.09];
    lnbAddColumn [70108,0];
    lnbAddColumn [70108,0.255];
    lnbAddColumn [70108,0.405];

    {
        _tmplName = _x # 0;
        _primWeap = (((_x # 1) # 0) # 0) # 0;
        _secWeap = (((_x # 1) # 0) # 1) # 0;
        _vestGer = (((_x # 1) # 1) # 1) # 0;
        _tmplDesc = format["%1 | %2 | %3",
            [_primWeap, "displayName", "CfgWeapons"] Call WFCO_FNC_GetConfigInfo,
            [_secWeap, "displayName", "CfgWeapons"] Call WFCO_FNC_GetConfigInfo,
            [_vestGer, "displayName", (missionNamespace getVariable [format["wf_%1", _vestGer], [0,1,"CfgWeapons"]]) # 2] Call WFCO_FNC_GetConfigInfo];

        _row = lnbAddRow [70108, ["", "", "", format["[%1...]", [_tmplName, 0, 8] call BIS_fnc_trimString], _tmplDesc]];

        lnbSetColor [70108,[_row,3],[0.73,0.24,0.11,1]];

        lnbSetPicture [70108, [_row, 2], [_primWeap, "picture", "CfgWeapons"] Call WFCO_FNC_GetConfigInfo];
        lnbSetPicture [70108, [_row, 1], [_secWeap, "picture", "CfgWeapons"] Call WFCO_FNC_GetConfigInfo];
        lnbSetData [70108, [_row, 0], str(_forEachIndex)];
    } forEach _templates;
};

if (lnbCurSelRow 70108 != -1 && lnbCurSelRow 70108 < (lnbSize 70108) select 0) then {
    ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70108) lnbSetCurSelRow lnbCurSelRow 70108;
} else {
    lnbClear ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70601);
};