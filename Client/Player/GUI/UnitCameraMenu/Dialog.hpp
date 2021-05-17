class Rsc_UnitCamera {
	movingEnable = 0;
	idd = 180000;
	onLoad = "uiNamespace setVariable ['WF_dialog_ui_unitscam', _this select 0];['onLoad'] call WFCL_fnc_displayUnitCameraMenu";
	onUnload = "uiNamespace setVariable ['WF_dialog_ui_unitscam', nil]; ['onUnload'] call WFCL_fnc_displayUnitCameraMenu";

	class controlsBackground {
		class WF_MouseArea : RscText {
			idc = 180001;
			style = ST_MULTI;

			x = "safezoneX";
			y = "safezoneY";
			w = "safezoneW";
			h = "safezoneH";
			linespacing = 1;

			text = "";
		};
	};

	class controls {
		class WF_Background : RscText { //--- Render out.
			idc = 180002;

			x = "SafeZoneX + (SafeZoneW * 0.01)";
			y = "SafeZoneY + (SafezoneH * 0.06)";
			w = "SafeZoneW * 0.19";
			h = "SafeZoneH * 0.55";

			colorBackground[] = {0, 0, 0, 0.5};
		};
		class WF_Menu_Control_UnitsList_Label : RscText { //--- Render out.
			idc = 180003;

			x = "SafeZoneX + (SafeZoneW * 0.015)";
			y = "SafeZoneY + (SafezoneH * 0.0605)";
			w = "SafeZoneW * 0.19";
			h = "SafeZoneH * 0.03";

			text = $STR_Menu_Control_UnitsList_Label;
			colorText[] = {0.231372549, 0.580392157, 0.929411765, 1};
			sizeEx = "0.9 * (			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
		};
		class WF_Menu_Control_UnitsList_Frame : RscFrame { //--- Render out.
			idc = 180004;

			x = "SafeZoneX + (SafeZoneW * 0.015)";
			y = "SafeZoneY + (SafeZoneH * 0.10)";
			h = "SafeZoneH * 0.3";
			w = "SafeZoneW * 0.18";
		};
		class WF_Menu_Control_UnitsAIList_Label : WF_Menu_Control_UnitsList_Label { //--- Render out.
			idc = 180005;

			x = "SafeZoneX + (SafeZoneW * 0.015)";
			y = "SafeZoneY + (SafezoneH * 0.41)";
			w = "SafeZoneW * 0.19";
			h = "SafeZoneH * 0.03";

			text = $STR_Menu_Control_UnitsAIList_Label;
		};
		class WF_Menu_Control_UnitsAIList_Frame : WF_Menu_Control_UnitsList_Frame { //--- Render out.
			idc = 180006;

			x = "SafeZoneX + (SafeZoneW * 0.015)";
			y = "SafeZoneY + (SafeZoneH * 0.45)";
			h = "SafeZoneH * 0.15";
			w = "SafeZoneW * 0.18";
		};
		class WF_Menu_Control_ToggleGroups : RscButton {
			idc = 180007;

			x = "SafeZoneX + (SafeZoneW * 0.01)";
			y = "SafeZoneY + (SafeZoneH * 0.01)";
			h = "SafeZoneH * 0.04";
			w = "SafeZoneW * 0.19";

			text = "Hide Teams";
			action = "['onToggleGroup'] call WFCL_fnc_displayUnitCameraMenu";
		};
		class WF_Menu_Control_ToggleMap : WF_Menu_Control_ToggleGroups {
			idc = 180008;
            x = "SafeZoneX + (SafeZoneW * 0.8)";
			y = "SafeZoneY + (SafeZoneH * 0.95)";

			text = "Hide Map";
			action = "['onToggleMap'] call WFCL_fnc_displayUnitCameraMenu";
		};
		class WF_Background_Map : WF_Background { //--- Render out.
			idc = 180009;
            x = "SafeZoneX + (SafeZoneW * 0.8)";
			y = "SafeZoneY + (SafezoneH * 0.62)";
			h = "SafeZoneH * 0.32";
		};
		class WF_Menu_Map : RscMapControl { //--- Render out.
			idc = 180010;

			x = "SafeZoneX + (SafeZoneW * 0.805)";
			y = "SafeZoneY + (SafezoneH * 0.63)";
			w = "SafeZoneW * 0.18";
			h = "SafeZoneH * 0.30";
			widthRailWay = 1;

			showCountourInterval = 1;
		};
		class WF_Menu_Control_Exit : RscButton {
			idc = 180012;

			x = "SafeZoneX + (SafeZoneW * 0.01)";
			y = "SafeZoneY + (SafeZoneH * 0.95)";
			h = "SafeZoneH * 0.04";
			w = "SafeZoneW * 0.1";

			text = $STR_Menu_Control_Exit;
			action = "closeDialog 0";
		};
		class WF_Menu_Control_Mode : WF_Menu_Control_Exit {
			idc = 180013;

			x = "SafeZoneX + (SafeZoneW * 0.12)";
			w = "SafeZoneW * 0.1";

			text = "Normal";
			action = "['onViewModeChanged'] call WFCL_fnc_displayUnitCameraMenu";
		};
		class WF_Menu_Control_Internal : RscButton {
			idc = 180020;

			x = "SafeZoneX + (SafeZoneW * 0.67)";
            y = "SafeZoneY + (SafeZoneH * 0.95)";
            w = "SafeZoneW * 0.1";
			h = "SafeZoneH * 0.04";

			text = $STR_Menu_Control_Internal;
			action = "['onCamChange', 'internal'] call WFCL_fnc_displayUnitCameraMenu";
		};
		class WF_Menu_Control_External : WF_Menu_Control_Internal { //--- Render out.
			idc = 180021;

			x = "SafeZoneX + (SafeZoneW * 0.56)";
            y = "SafeZoneY + (SafeZoneH * 0.95)";
            w = "SafeZoneW * 0.1";

			text = $STR_Menu_Control_External;
			action = "['onCamChange', 'external'] call WFCL_fnc_displayUnitCameraMenu";
		};
		class WF_Menu_Control_Unflip : WF_Menu_Control_Internal {
			idc = 180022;

            x = "SafeZoneX + (SafeZoneW * 0.45)";
			y = "SafeZoneY + (SafeZoneH * 0.95)";
            w = "SafeZoneW * 0.1";

			text = $STR_Menu_Control_Unflip;
			action = "['onUnitUnflip'] call WFCL_fnc_displayUnitCameraMenu";
		};
		class WF_Menu_Control_Remote : WF_Menu_Control_Internal {
            idc = 180024;

            x = "SafeZoneX + (SafeZoneW * 0.34)";
            y = "SafeZoneY + (SafeZoneH * 0.95)";
            w = "SafeZoneW * 0.1";

            text = $STR_WF_UPGRADE_REMOTE_CONTROL;
            action = "['onRemote'] call WFCL_fnc_displayUnitCameraMenu";
        };

		class WF_Menu_Control_UnitsList : RscListBox { //--- Render out.
			idc = 180100;

			x = "SafeZoneX + (SafeZoneW * 0.015)";
			y = "SafeZoneY + (SafeZoneH * 0.10)";
			h = "SafeZoneH * 0.3";
			w = "SafeZoneW * 0.18";

			rowHeight = "1 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			sizeEx = "0.78 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";

			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};

			onLBSelChanged = "['onGroupsLBSelChanged', _this select 1] call WFCL_fnc_displayUnitCameraMenu";
		};
		class WF_Menu_Control_UnitsAIList : WF_Menu_Control_UnitsList { //--- Render out.
			idc = 180101;

			y = "SafeZoneY + (SafeZoneH * 0.45)";
			h = "SafeZoneH * 0.15";

			onLBSelChanged = "['onUnitsAILBSelChanged', _this select 1] call WFCL_fnc_displayUnitCameraMenu";
		};
	};
};