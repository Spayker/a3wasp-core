private ["_experience","_skilllist"];

if!(isNil 'WF_resetRoleRequest')then{
    if(WF_resetRoleRequest)then{
        _role = param [1, "",[""]];

        WF_gbl_boughtRoles = [];

        hint "Your skills have been reset.";

        [] call WFCL_fnc_updateRolesMenu;
        [] spawn WFCL_fnc_selectRole;

        if (!isNull (findDisplay 2800)) then {
            ctrlEnable[2804, true];
            ctrlEnable[2805, true];
        };
        WF_resetRoleRequest = false;
        WF_gbl_boughtRoles = [];
    };
};