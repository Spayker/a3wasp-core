_structures = (WF_Client_SideJoined) call WFCO_FNC_GetSideStructures;
_list = [];

_vehicles = [];

{
    _manRange = missionNamespace getVariable "WF_C_BASE_DEFENSE_MANNING_RANGE";
    _nearest = ['BARRACKSTYPE', _x, _structures, _manRange] call WFCO_FNC_GetClosestStructure;

    if (!isNull _nearest || _x == player || gearInRange) then {
        _list pushBack _x;
        ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70201) lbAdd Format["[%1] %2", _x Call WFCO_FNC_GetAIDigit, getText(configFile >> "CfgVehicles" >> typeOf _x >> "displayName")];
    };
    if (vehicle _x != _x && !(vehicle _x in _vehicles)) then { //--- Vehicle check
        if (getNumber(configFile >> "CfgVehicles" >> typeOf vehicle _x >> "maximumLoad") > 0) then {
            if (!isNull _nearest || gearInRange) then {
                _list pushBack vehicle _x;
                ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70201) lbAdd Format["[%1] %2", _x Call WFCO_FNC_GetAIDigit, getText(configFile >> "CfgVehicles" >> typeOf vehicle _x >> "displayName")];
                _vehicles pushBack vehicle _x;
            };
        };
    };
} forEach ((units player) call WFCO_FNC_GetLiveUnits);

{
    _manRange = missionNamespace getVariable "WF_C_BASE_DEFENSE_MANNING_RANGE";
    _nearest = ['BARRACKSTYPE', _x, _structures, _manRange] call WFCO_FNC_GetClosestStructure;

    if !(_x in _vehicles) then { //--- Vehicle check
        if (getNumber(configFile >> "CfgVehicles" >> typeOf _x >> "maximumLoad") > 0 && local _x) then {
            if (!isNull _nearest || gearInRange) then {
                _list pushBack _x;
                ((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70201) lbAdd Format["%1", getText(configFile >> "CfgVehicles" >> typeOf _x >> "displayName")];
                _vehicles pushBack _x;
            };
        };
    };
} forEach (vehicle player nearEntities [["Car", "Ship", "Motorcycle", "Tank", "Air", "StaticWeapon"], WF_C_BASE_AREA_RANGE]);

uiNamespace setVariable ["wf_dialog_ui_gear_units", _list];

((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70201) lbSetCurSel 0;