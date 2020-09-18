Private ['_confirm'];

if(!WF_isFirstRoleSelected && !WF_IsRoleSelectedDialogClosed)then{
    _confirm = [
        "You have not chosen one role for FREE",
        "Close the dialog?",
        "Yes, CLOSE",
        "No, WAIT"
    ] call BIS_fnc_guiMessage;

    if (_confirm) then {
        WF_IsRoleSelectedDialogClosed = true;
        closeDialog 0;
    }else{
        createDialog "WF_roles_menu";
        [] call WFCL_fnc_updateRolesMenu;
    };
}else{
    closeDialog 0;
}