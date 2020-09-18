class WF_UpgradeMenu {
	movingEnable = 1;
	idd = 504000;
	onLoad = "(_this) spawn WFCL_fnc_displayUpgradeMenu";

	class controlsBackground {
		class CA_Background : RscText {
			x = 0;
			y = 0;
			w = 1.2;
			h = 0.8;
			colorBackground[] = WF_Background_Color;
			moving = 1;
		};
		class CA_Background_Header : CA_Background {
			x = 0;
			y = 0;
			w = 1.2;
			h = 0.06;
			colorBackground[] = WF_Background_Color_Header;
		};
		class CA_Background_Footer : CA_Background {
			x = 0;
			y = 0.745;
			w = 1.2;
			h = 0.055;
			colorBackground[] = WF_Background_Color_Sub;
		};
		class CA_Menu_Title : RscText_Title {
			x = 0.007;
			y = 0.01;
			w = 0.5;
			text = $STR_WF_MAIN_UpgradeMenu;
			colorText[] = WF_Menu_Title_Color;
		};
		class CA_Quit_Button: RscButton_Exit {
			x = 1.15;
			y = 0.0075;
			w = 0.045;
			h = 0.045;
			text = "X";
			shadow = 2;
			sizeEx = 0.03;
			onButtonClick = "closeDialog 0;";
		};
		class CA_Back_Button : RscButton_Back {
			x = 1.095;
			y = 0.0075;
			w = 0.045;
            h = 0.045;
			text = "<<";
			onButtonClick = "WF_WF_MenuAction = 1000;";
			tooltip = $STR_WF_TOOLTIP_BackButton;
		};
		class CA_Menu_Details : RscText {
			x = 0.745;
			y = 0.075;
			w = 0.45;
			h = 0.20;
			colorBackground[] = {0.5, 0.5, 0.5, 0.15};
			style = ST_TEXT_BG;
		};
		class CA_Menu_Links : CA_Menu_Details {
			y = 0.29;
			h = 0.16;
		};
		class CA_Menu_Desc : CA_Menu_Details {
			y = 0.465;
			h = 0.28;
		};
	};

	class controls {
		class CA_UpgradeList : RscListnBox {
			idc = 504001;
			x = 0.000983551;
			y = 0.065;
			w = 0.74;
			h = 0.65;
			columns[] = {0.01, 0.1, 0.9};

			colorDisabled[] = {1,1,1,0.3};

			onLBDblClick = "WF_WF_MenuAction = 1";
			onLBSelChanged = "WF_WF_MenuAction = 2";
		};

		class CA_UpgradeDetails : RscStructuredText {
			idc = 504003;
			x = 0.75;
			y = 0.08;
			w = 0.32;
			h = 0.195;
			size = 0.0260;
			shadow = 1;

			class Attributes {
				font = "PuristaMedium";
				color = "#E8F0FF";
				align = "left";
				shadow = true;
			};
		};

		class CA_UpgradeLinks : CA_UpgradeDetails {
			idc = 504004;
			y = 0.295;
			h = 0.155;
			w = 0.45;
		};
		class CA_UpgradeDesc : CA_UpgradeLinks {
			idc = 504005;
			y = 0.47;
			h = 0.275;
		};
		class CA_Upgrade : RscButton {
			idc = 504007;
			x = 0.005083551;
			y = 0.75;
			w = 0.25;
			h = 0.045;
			shortcuts[] = { 31 };
			text = $STR_Start;
			action = "WF_WF_MenuAction = 1";
		};
		class CA_Details : CA_UpgradeDetails {
			idc = 504006;
			x = 0.75;
			y = 0.765;
			w = 0.4;
			h = 0.035;
			size = 0.0250;
			shadow = 2;
		};
	};
};