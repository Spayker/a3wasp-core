class WF_TransferMenu {
	movingEnable = 1;
	idd = 505000;
	onLoad = "(_this) spawn WFCL_fnc_displayTransferMenu";

	class controlsBackground {
		class CA_Background : RscText {
			x = 0;
			y = 0;
			w = 0.8;
			h = 0.6;
			colorBackground[] = WF_Background_Color;
			moving = 1;
		};
		class CA_Background_Header : CA_Background {
			x = 0;
			y = 0;
			w = 0.8;
			h = 0.06;
			colorBackground[] = WF_Background_Color_Header;
		};
		class CA_Background_Footer : CA_Background {
			x = 0;
			y = 0.56;
			w = 0.8;
			h = 0.04;
			colorBackground[] = WF_Background_Color_Sub;
		};
		class CA_Menu_Title : RscText_Title {
			x = 0.007;
			y = 0.01;
			w = 0.5;
			text = $STR_WF_MAIN_FundsMenu;
			colorText[] = WF_Menu_Title_Color;
		};
		class CA_Quit_Button: RscButton_Exit {
			x = 0.75;
			y = 0.0075;
			w = 0.045;
			h = 0.045;
			text = "X";
			shadow = 2;
			sizeEx = 0.03;

			onButtonClick = "closeDialog 0;";
		};
		class CA_Menu_Details : RscText {
			x = 0.405;
			y = 0.075;
			w = 0.385;
			h = 0.18;
			colorBackground[] = {0.5, 0.5, 0.5, 0.15};
			style = ST_TEXT_BG;
		};
		class CA_Edit_BG : RscText {
			x = 0.415;
			y = 0.165;
			w = 0.15;
			colorBackground[] = WF_Background_Color_Header;
		};
	};

	class controls {
		class CA_TransferList : RscListnBox {
			idc = 505001;
			x = 0.000983551;
			y = 0.065;
			w = 0.4;
			h = 0.488;
			columns[] = {0.01, 0.3, 0.75};
			rowHeight = 0.03;
			colorDisabled[] = {1,1,1,0.3};
			onLBDblClick = "WF_MenuAction = 1";
		};
		class CA_Send : RscButton {
			x = 0.595;
			y = 0.562;
			w = 0.2;
			h = 0.035;
			sizeEx = 0.035;
			text = $STR_WF_Send;
			action = "WF_MenuAction = 1";
		};
		class CA_AmountDetails : RscText {
			x = 0.415;
			y = 0.08;
			w = 0.2;
			sizeEx = 0.030;
			text = $STR_WF_Amount;
		};
		class CA_Funds_Slider : RscXSliderH {
			idc = 505002;
			x = 0.415;
			y = 0.12;
			w = 0.365;
			h = 0.029412;

			onSliderPosChanged = "WF_MenuAction = 2";
		};
		class CA_Funds_Edit : RscEdit {
			idc = 505003;
			x = 0.415;
			y = 0.165;
			w = 0.15;
			text = "0";
			sizeEx = 0.035;
			colorDisabled[] = {1,1,1,0.3};
		};
		class CA_Funds : RscStructuredText {
			idc = 505004;
			x = 0.415;
			y = 0.21;
			w = 0.3;
			h = 0.035;
			size = 0.03;

			colorText[] = {0.543, 0.5742, 0.4102, 1.0};
		};
	};
};