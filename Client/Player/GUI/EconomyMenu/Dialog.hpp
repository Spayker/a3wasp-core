class RscMenu_Economy {
	movingEnable = 1;
	idd = 23000;
	onLoad = "_this spawn WFCL_fnc_displayEconomyMenu";

	class controlsBackground {
		class Background_M : RscText {
			x = 0.0318137;
			y = 0.2004;
			w = 0.938056;
			h = 0.59934;
			moving = 1;
			colorBackground[] = WF_Background_Color;
		};
		class Background_H : RscText {
			x = 0.0318137;
			y = 0.2004;
			w = 0.938056;
			h = 0.0525;
			moving = 1;
			colorBackground[] = WF_Background_Color_Header;
		};
		class Background_F : RscText {
			x = 0.0318137;
			y = 0.74724;
			w = 0.938056;
			h = 0.0525;
			moving = 1;
			colorBackground[] = WF_Background_Color_Footer;
		};
		class Background_L : RscText {
			x = 0.0318137;
			y = 0.2519;
			w = 0.938056;
			h = WF_Background_Border_Thick;
			colorBackground[] = WF_Background_Border;
		};
	};
	class controls {
		class WF_MiniMap : RscMapControl {
			idc = 23002;
			x = 0.5;
			y = 0.254636;
			w = 0.469125;
			h = 0.492337;
			ShowCountourInterval = 1;
			widthRailWay = 1;

			onMouseMoving = "mouseX = (_this Select 1);mouseY = (_this Select 2)";
			onMouseButtonDown = "mouseButtonDown = _this Select 1";
			onMouseButtonUp = "mouseButtonUp = _this Select 1";
		};
		class Title_CommanderMenu : RscText_Title {
			idc = 23003;
			x = 0.0367093;
			y = 0.207199;
			w = 0.3;
			text = $STR_WF_MAIN_EconomyMenu;
		};

		class CA_IC_SubTitle : RscText_SubTitle {
            idc = 13010;
            x = 0.3657093;
            y = 0.207199;
            w = 0.426891;
        };

		class CA_Slider_Income : RscXSliderH {
			idc = 23010;
			x = 0.0462772;
			y = 0.294119;
			w = 0.334;
			h = 0.029412;
		};
		class CA_LabelIncomePercent : RscText {
			idc = 23011;
			x = 0.394873;
			y = 0.290119;
			w = 0.15;
		};
		class CA_IncomeSet_Button : RscButton {
			idc = 23012;
			x = 0.0462772;
			y = 0.354873;
			w = 0.334;
			text = $STR_WF_ECONOMY_SetIncome;
			action = "WF_MenuAction = 3";
		};
		class CA_LabelIncomeCommander : RscText {
			idc = 23013;
			x = 0.0372772;
			y = 0.404608;
			w = 0.399999;
		};
		class CA_LabelPlayerCommander : CA_LabelIncomeCommander {
			idc = 23014;
			x = 0.284313;
			y = 0.404608;
			w = 0.399999;
		};

		/* Seperator */
        class Line_TRH1 : RscText {
            x = 0.0372772;
            y = 0.457535;
            w = 0.454486;
            h = WF_SPT1;
            colorBackground[] = WF_SPC1;
        };

        /* Transfer */
        class CA_Transfer_SubTitle1 : RscText_SubTitle {
            idc = 130122;
            x = 0.0372772;
            y = 0.465641;
            w = 0.3;
            text = $STR_WF_TEAM_MoneyTransferLabel;
        };

        class CA_TM_Combo : RscCombo {
            idc = 130088;
            x = 0.0472772;
            y = 0.515232;
            w = 0.219999;
            h = 0.035;
        };

        class CA_TM_Button : RscButton {
            idc = 130099;
            x = 0.284313;
            y = 0.566712;
            w = 0.208999;
            h = 0.035;
            colorBackground[] = {0.768627451, 1, 0.137254902, 0.7};
            colorBackgroundActive[] = {0.668627451, 0.9, 0.037254902, 1};
            colorFocused[] = {0.768627451, 1, 0.137254902, 1};
            colorBorder[] = {0,0,0,1};
            text = $STR_WF_TEAM_TransferButton;
            action = "WF_MenuAction = 1";
        };

        class CA_TM_Slider : RscXSliderH {
            idc = 130077;
            x = 0.0472772;
            y = 0.566712;
            w = 0.219999;
            h = 0.035;
        };

        class CA_TM_Label : RscText {
            idc = 130066;
            x = 0.0472772;
            y = 0.597846;
            w = 0.219999;
        };

        class CA_TA_Button : RscButton {
            idc = 131099;
            x = 0.284313;
            y = 0.515232;
            w = 0.208999;
            text = "Transfer (Adv)";
            action = "WF_MenuAction = 101";
        };

        /* Seperator */
        class Line_TRH2 : RscText {
            x = 0.0372772;
            y = 0.637846;
            w = 0.454486;
            h = WF_SPT1;
            colorBackground[] = WF_SPC1;
        };

        /* Supply Converter */
        class CA_Converter_SubTitle1 : RscText_SubTitle {
            idc = 1301221;
            x = 0.0372772;
            y = 0.637846;
            w = 0.3;
            text = $STR_WF_TEAM_SupplyConverterLabel;
        };

        class CA_SC_Slider : RscXSliderH {
            idc = 1300771;
            x = 0.0472772;
            y = 0.68;
            w = 0.219999;
            h = 0.035;
        };

        class CA_SC_Button : RscButton {
            idc = 1300991;
            x = 0.284313;
            y = 0.68;
            w = 0.208999;
            h = 0.035;
            colorBackground[] = {0.768627451, 1, 0.137254902, 0.7};
            colorBackgroundActive[] = {0.668627451, 0.9, 0.037254902, 1};
            colorFocused[] = {0.768627451, 1, 0.137254902, 1};
            colorBorder[] = {0,0,0,1};
            text = $STR_WF_Economy_Convert;
            action = "WF_MenuAction = 66";
        };

        class CA_SC_Supplies_Label : RscText {
            idc = 1300661;
            x = 0.0472772;
            y = 0.71;
            w = 0.219999;
        };

        class CA_SC_Money_Label : RscText {
            idc = 1300662;
            x = 0.284313;
            y = 0.71;
            w = 0.219999;
        };

		/* Selling Structures */
		class CA_Sell : RscButton {
			idc = 23015;
			x = 0.505;
			y = 0.757255;
			w = 0.459125;
			text = $STR_WF_ECONOMY_SellStructure;
			shortcuts[] = { 31 };
			action = "WF_MenuAction = 105";
		};
		/* Back */
		class Back_Button : RscButton_Back {
			x = 0.861415;
			y = 0.207199;
			action = "WF_MenuAction = 5";
			tooltip = $STR_WF_TOOLTIP_BackButton;
		};
		/* Exit */
		class Exit_Button : RscButton_Exit {
			x = 0.924681;
			y = 0.207199;
			onButtonClick = "closeDialog 0;";
			tooltip = $STR_WF_TOOLTIP_CloseButton;
		};
	};
};