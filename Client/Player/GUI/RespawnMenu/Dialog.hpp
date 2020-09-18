class WF_RespawnMenu {
	movingEnable = 1;
	idd = 511000;
	onLoad = "(_this) spawn WFCL_fnc_displayRespawnMenu";

	class controlsBackground {
		class CA_Background : RscText {
			x = 0;
			y = 0;
			w = 1;
			h = 1;
			colorBackground[] = WF_Background_Color;
			moving = 1;
		};
		class CA_Background_Header : CA_Background {
			x = 0;
			y = 0;
			w = 1;
			h = 0.06;
			colorBackground[] = WF_Background_Color_Header;
		};
		class CA_Background_Footer : CA_Background {
			x = 0;
			y = 0.96;
			w = 1;
			h = 0.04;
			colorBackground[] = WF_Background_Color_Sub;
		};
		class CA_Menu_Title : RscText_Title {
			x = 0.007;
			y = 0.01;
			w = 0.5;
			text = $STR_WF_RESPAWN_Title;
			colorText[] = WF_Menu_Title_Color;
		};
		class CA_Quit_Button: RscButton_Exit {
			x = 0.95;
			y = 0.0075;
			w = 0.045;
			h = 0.045;
			text = "X";
			shadow = 2;
			sizeEx = 0.03;

			onButtonClick = "closeDialog 0;";
		};
	};

	class controls {
		class WF_MiniMap : RscMapControl {
			idc = 511001;
			x = 0.01;
			y = 0.07;
			w = 0.98;
			h = 0.8;
			ShowCountourInterval = 1;
			widthRailWay = 1;

			onMouseMoving = "mouseX = (_this Select 1);mouseY = (_this Select 2)";
			onMouseButtonDown = "mouseButtonDown = _this select 1;";
			onMouseButtonUp = "mouseButtonUp = _this select 1;";
		};
		class CA_RespawnDetails : RscStructuredText {
			idc = 511002;
			x = 0.01;
			y = 0.965;
			w = 0.49;
			h = 0.13;

			size = 0.0275;
			shadow = 2;
		};
		class CA_RespawnDelay : CA_RespawnDetails {
			idc = 511003;
			x = 0.5;
			w = 0.49;
			h = 0.13;
		};
		class CA_Gear_Button : RscButton {
			idc = 511004;
			x = 0.68;
			y = 0.00940119;
			w = 0.25;
			sizeEx = 0.03221;

			colorBackground[] = WF_Menu_Button_Sub_Color;
			colorBackgroundActive[] = WF_Menu_Button_Sub_Color;
			colorFocused[] = WF_Menu_Button_Sub_Focused_Color;

			tooltip = $STR_WF_TOOLTIP_RespawnDefault;
			onButtonClick = "WF_MenuAction = 1;";
		};
	};
};