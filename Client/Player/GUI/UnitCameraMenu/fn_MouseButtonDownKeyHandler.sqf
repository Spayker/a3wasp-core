_button = _this select 1;
_coord_x = _this select 2;
_coord_y = _this select 3;

switch (_button) do {
    case 0: { //--- Left clicked
        _position = screenToWorld [_coord_x, _coord_y];
        _nearestObjects = [_position, _position nearEntities [["AllVehicles"], 40]] call WFCO_FNC_SortByDistance;

        _swapto = objNull;
        _groups = [group player];
        _isCommander = false;
        if (!isNull(commanderTeam)) then {if (commanderTeam == group player) then {_isCommander = true}};
        if(_isCommander) then {
            _groups = _groups + ([WF_Client_SideJoined] call WFCO_FNC_getHighCommandGroups)
        };

        {
            if (_x isKindOf "Man") then {
                if (group _x in _groups) exitWith { _swapto = _x };
            } else {
                {if (group _x in _groups) exitWith { _swapto = _x }} forEach crew _x;
            };
            if !(isNull _swapto) exitWith {};
        } forEach _nearestObjects;

        if !(isNull _swapto) then {
            uiNamespace setVariable ["wf_dialog_ui_unitscam_focus", _swapto];

            if (_swapto != leader group _swapto) then {uiNamespace setVariable ["wf_dialog_ui_unitscam_screenselect", _swapto]};

            ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180100) lbSetCurSel (_groups find group _swapto);
        };
    };
    case 1: { //--- Right clicked
        uiNamespace setVariable ["wf_dialog_ui_unitscam_anchor", [_coord_x, _coord_y]];
    };
};