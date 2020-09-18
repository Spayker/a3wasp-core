class WF_roles_menu
{
    idd = 2800;
    name = "WF_roles_menu";
    movingEnable = false;
    enableSimulation = true;
    onLoad = "[] spawn WFCL_fnc_updateRolesMenu;";
    onUnload="[] spawn WFCL_fnc_closeRoleSelectDialog;";
    class controlsBackground
    {
        class WF_roles_menu_frame: RscFrame
        {
            idc = -1;
            x = 0.29375 * safezoneW + safezoneX;
            y = 0.225 * safezoneH + safezoneY;
            w = 0.4125 * safezoneW;
            h = 0.55 * safezoneH;

        };
        class WF_roles_menu_background: Box
        {
            idc = -1;
            x = 0.29375 * safezoneW + safezoneX;
            y = 0.225 * safezoneH + safezoneY;
            w = 0.4125 * safezoneW;
            h = 0.55 * safezoneH;
            colorBackground[] = WF_Background_Color;
        };
        class WF_roles_menu_header: RscText_Title
        {
            idc = -1;
            text = "ROLE SELECTOR";
            x = 0.29375 * safezoneW + safezoneX;
            y = 0.192 * safezoneH + safezoneY;
            w = 0.4125 * safezoneW;
            h = 0.033 * safezoneH;
            colorBackground[] = WF_Background_Color;
        };
    };

    class controls
    {
        class WF_roles_menu_list: Skill_RscListbox
        {
            idc = 2801;
            x = 0.298906 * safezoneW + safezoneX;
            y = 0.236 * safezoneH + safezoneY;
            w = 0.149531 * safezoneW;
            h = 0.418 * safezoneH;
            sizeEx = 0.044;
            onLBSelChanged = "[] spawn WFCL_fnc_selectRole;";
        };
        class WF_roles_menu_details_role_name: Skill_RscStructuredText
        {
            idc = 2806;
            x = 0.453594 * safezoneW + safezoneX;
            y = 0.236 * safezoneH + safezoneY;
            w = 0.2475 * safezoneW;
            h = 0.1 * safezoneH;
        };
        class WF_roles_menu_details_slots: Skill_RscStructuredText
        {
            idc = 2822;
            x = 0.453594 * safezoneW + safezoneX;
            y = 0.336 * safezoneH + safezoneY;
            w = 0.2475 * safezoneW;
            h = 0.05 * safezoneH;
        };
        class WF_roles_menu_details: Skill_RscStructuredText
        {
            idc = 2802;
            x = 0.453594 * safezoneW + safezoneX;
            y = 0.386 * safezoneH + safezoneY;
            w = 0.2475 * safezoneW;
            h = 0.453 * safezoneH;
        };

        class WF_roles_menu_info: Skill_RscStructuredText
        {
            idc = 2803;
            text = "";
            x = 0.298906 * safezoneW + safezoneX;
            y = 0.665 * safezoneH + safezoneY;
            w = 0.149531 * safezoneW;
            h = 0.044 * safezoneH;
            colorBackground[] = {0,0,0,0};
        };
        class WF_roles_menu_learn: RscButton
        {
            idc = 2804;
            text = "BUY ROLE";
            x = 0.298906 * safezoneW + safezoneX;
            y = 0.72 * safezoneH + safezoneY;
            w = 0.149531 * safezoneW;
            h = 0.044 * safezoneH;
            onButtonClick = "[] spawn WFCL_fnc_buyRole;";
        };
        class WF_roles_menu_reset: RscButton
        {
            idc = 2805;
            text = "RESET ROLE";
            x = 0.618594 * safezoneW + safezoneX;
            y = 0.72 * safezoneH + safezoneY;
            w = 0.0825 * safezoneW;
            h = 0.044 * safezoneH;
            onButtonClick = "[false] spawn WFCL_fnc_resetRoles;";
        };
        class WF_roles_menu_close: RscButton_Exit
        {
            idc = -1;
            text = "X";
            x = 0.681219 * safezoneW + safezoneX;
            y = 0.193 * safezoneH + safezoneY;
            h = 0.03 * safezoneH;
            onButtonClick = "[] spawn WFCL_fnc_closeRoleSelectDialog;";
        };
    };
};