_index = _this;
_indexGears = parseNumber (lnbData [70108, [_index, 0]]);

_gear = [];

_gear = ((missionNamespace getVariable format["wf_player_gearTemplates_%1", WF_SK_V_Type]) # _indexGears) # 1;
_upgrades = (WF_Client_SideJoined) Call WFCO_FNC_GetSideUpgrades;
_resultGear = [_gear, _upgrades # WF_UP_GEAR, WF_SK_V_Type] call WFCO_FNC_proccedLoadOutForSide;
_gear = _resultGear # 0;

uiNamespace setVariable ["wf_dialog_ui_gear_target_gear", _gear];

_mass = (_gear) call WFCL_fnc_getTotalMass;
uiNamespace setVariable ["wf_dialog_ui_gear_target_gear_mass", _mass];

{[_forEachIndex, _x] call WFCL_fnc_updateContainerProgress} forEach [70301,70302,70303];

call WFCL_fnc_updatePrice;
(_gear) call WFCL_fnc_displayInventory;

if(count (_resultGear # 1) > 0) then {
    _resultMessage = localize "STR_WF_GEARTEMPLATE_LOAD_EXCLUDES";

    _resultMessage = _resultMessage + "<br /><br />";

    {
        _config_type = [_x] call WFCO_FNC_GetConfigType;

        _resultMessage = _resultMessage + format["<t align='left'><img image='%1' size='1.5'/></t><t color='#ee2222' size='1.1'>%2</t><br />", [_x, "picture", _config_type] Call WFCO_FNC_GetConfigInfo, [_x, "displayName", _config_type] Call WFCO_FNC_GetConfigInfo];
    } forEach (_resultGear # 1);

    [format ["%1" _resultMessage]] spawn WFCL_fnc_handleMessage
};