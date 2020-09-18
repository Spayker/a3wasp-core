private ["_role","_cost","_roleDetails","_c","_l"];
_role = lbData [2801, lbCurSel(2801)];
_cost = lbValue [2801, lbCurSel(2801)];
WF_newBuyRolerequest = true;
if (_role == "") exitWith {};

ctrlEnable[2804, false];

// get the skill details
_roleDetails = [_role, side player] call WFCO_fnc_getRoleDetails;

// Role not found/invalid
if ((count _roleDetails) == 0) exitWith {
    ctrlEnable[2804, true];
};

// check if the user already have that role
if (_role in WF_gbl_boughtRoles) exitWith {
    [_role,"owned",_funds,WF_gbl_boughtRoles] spawn WFCL_fnc_buyRoleConfirm;
};

_result = true;
if ((count WF_gbl_boughtRoles) >= 1) then {
    _result = [false] call WFCL_fnc_resetRoles;
};

if(_result)then{
    waituntil{count WF_gbl_boughtRoles == 0};
    // Check if the player have the required skills.
    _c = 0;
    _l = 0;
    {
        _c = _c + 1;
        if (_x in WF_gbl_boughtRoles) then {
            _l = _l + 1;
        };
    } foreach (_roleDetails select 3);

    if(!WF_isFirstRoleSelected)then{
        hint "Buying role first time for FREE...";
        WF_IsRoleSelectedDialogClosed = true;
    }else{
        // check if the user have enough money
        _funds = call WFCL_FNC_GetPlayerFunds;
        if (_funds < _cost) exitWith {
            [_role,"money",_funds,WF_gbl_boughtRoles] spawn WFCL_fnc_buyRoleConfirm;
        };
        -(_cost) Call WFCL_FNC_ChangePlayerFunds;
        hint "Buying role, please wait..";
    };

    [player,_role] remoteExecCall ["WFSE_fnc_buyRole", 2];
};