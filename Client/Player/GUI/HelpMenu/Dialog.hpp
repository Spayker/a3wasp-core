class RscMenu_Help {
	movingEnable = 1;
	idd = 508000;
	onLoad = "uiNamespace setVariable ['dialog_HelpPanel', _this select 0];['onLoad'] spawn WFCL_fnc_displayHelpMenu";
	onUnload = "uiNamespace setVariable ['WF_dialog_ui_onlinehelpmenu', nil]; ['onUnload'] spawn WFCL_fnc_displayHelpMenu";
	class controlsBackground {
		class WF_Background : RscText {
			x = "SafeZoneX + (SafeZoneW * 0.1)";
			y = "SafeZoneY + (SafezoneH * 0.105)";
			w = "SafeZoneW * 0.8";
			h = "SafeZoneH * 0.8";
			colorBackground[] = WF_Background_Color;
			moving = 1;
		};
		class WF_Background_Header : WF_Background {
			x = "SafeZoneX + (SafeZoneW * 0.1)";
			y = "SafeZoneY + (SafezoneH * 0.105)";
			w = "SafeZoneW * 0.8";
			h = "SafeZoneH * 0.05"; //0.06 stock
			colorBackground[] = WF_Background_Color_Header;
		};
		class Footer: RscText {
			x = "SafeZoneX + (SafeZoneW * 0.1)";
			y = 0.871195 * safezoneH + safezoneY;
			w = "SafeZoneW * 0.8";
			h = 0.034396 * safezoneH;
			colorBackground[] = WF_Background_Color_Footer;
		};
		class WF_Menu_Title : RscText_Title {
			style = ST_LEFT;
			x = "SafeZoneX + (SafeZoneW * 0.12)";
			y = "SafeZoneY + (SafezoneH * 0.11)";
			w = "SafeZoneW * 0.78";
			h = "SafeZoneH * 0.037";
			text = "Warfare Information Panel";
			sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
		};
		class WF_Menu_InfoListFrame : RscFrame {
			x = "SafeZoneX + (SafeZoneW * 0.12)";
			y = "SafeZoneY + (SafezoneH * 0.175)";
			w = "SafeZoneW * 0.2";
			h = 0.676391 * safezoneH;
		};
		class WF_Menu_InfoResourcesFrame : RscFrame {
			x = "SafeZoneX + (SafeZoneW * 0.34)";
			y = "SafeZoneY + (SafezoneH * 0.175)";
			w = "SafeZoneW * 0.54";
			h = 0.676391 * safezoneH;
		};
		class WF_Menu_Info_Background : RscText {
			x = "SafeZoneX + (SafeZoneW * 0.34)";
			y = "SafeZoneY + (SafezoneH * 0.175)";
			w = "SafeZoneW * 0.54";
			h = 0.676391 * safezoneH;
			colorBackground[] = {0.5, 0.5, 0.5, 0.25};
		};
	};
	class controls {
		class WF_Menu_Help_Topics : RscListBox {
			idc = 160001;

			x = "SafeZoneX + (SafeZoneW * 0.12)";
			y = "SafeZoneY + (SafezoneH * 0.175)";
			w = "SafeZoneW * 0.2";
			h = 0.676389 * safezoneH;

			rowHeight = "1.5 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			sizeEx = "0.78 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			colorDisabled[] = {1,1,1,0.3};
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
			onLBSelChanged = "['onHelpLBSelChanged', _this select 1] spawn WFCL_fnc_displayHelpMenu";
		};

		class Menu_Help_ControlsGroup : RscControlsGroup {
			x = "SafeZoneX + (SafeZoneW * 0.34)";
			y = "SafeZoneY + (SafezoneH * 0.175)";
			w = "SafeZoneW * 0.54";
			h = 0.670389 * safezoneH;

			class controls {
				class WF_Menu_Help_Explanation : RscStructuredText {
					idc = 160002;
					x = "0";
					y = "0";
					w = "SafeZoneW * 0.53";
					h = "SafeZoneH * 2.71";
					size = "0.85 * (			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
				};
			};
		};
		/* Separators */
		class Exit_Button : RscButton_Exit {
			x = 0.868374 * safezoneW + safezoneX;
			y = 0.873751 * safezoneH + safezoneY;
			onButtonClick = "closeDialog 0;";
			tooltip = $STR_WF_TOOLTIP_CloseButton;
		};
	};
};