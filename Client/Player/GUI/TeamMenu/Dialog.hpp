class RscMenu_Team {
	movingEnable = 1;
	idd = 13000;
	onLoad = "_this spawn WFCL_fnc_displayTeamMenu";

	class controlsBackground {
		class Background_M : RscText {
			x = 0.187276;
			y = 0.1324;
			w = 0.625448;
			h = 0.6257;
			colorBackground[] = WF_Background_Color;
			moving = 1;
		};
		class Background_H : RscText {
			x = 0.187276;
			y = 0.1324;
			w = 0.625448;
			h = 0.0525;
			moving = 1;
			colorBackground[] = WF_Background_Color_Header;
		};
		class Background_F : RscText {
			x = 0.187276;
			y = 0.7032;
			w = 0.625448;
			h = 0.0525;
			moving = 1;
			colorBackground[] = WF_Background_Color_Footer;
		};
		class Background_L : RscText {
			x = 0.187276;
			y = 0.188;
			w = 0.625448;
			h = WF_Background_Border_Thick;
			colorBackground[] = WF_Background_Border;
		};
	};
	class controls {
		class Title_TeamMenu : RscText_Title {
			idc = 13001;
			x = 0.192941;
			y = 0.1388;
			w = 0.3;
			text = $STR_WF_MAIN_TeamMenu;
		};
		/* Video */
		class CA_OD_Label: RscText
        {
        	idc = 13101;

        	x = 0.19625;
        	y = 0.20;
        	w = 0.3;
        	h = 0.037;
        };
        class CA_VD_Label: RscText
        {
        	idc = 13002;
        	x = 0.197;
        	y = 0.25;
        	w = 0.3;
        	h = 0.037;
        };

        class CA_SD_Label: RscText
        {
            idc = 130010;
            x = 0.197;
            y = 0.295;
            w = 0.3;
            h = 0.037;
        };

        class CA_TD_Label: RscText
        {
        	idc = 13004;
        	x = 0.197;
        	y = 0.34;
        	w = 0.3;
        	h = 0.037;
        };

        class CA_OD_Slider: RscXSliderH
        {
        	idc = 130039;
        	x = 0.514;
        	y = 0.21;
        	w = 0.28;
        	h = 0.029412;
        };
        class CA_VD_Slider: RscXSliderH
        {
        	idc = 13003;
        	x = 0.514;
        	y = 0.255;
        	w = 0.28;
        	h = 0.029412;
        };

        class CA_SD_Slider: RscXSliderH
        {
            idc = 130011;
            x = 0.514;
            y = 0.30;
            w = 0.28;
            h = 0.029412;
        };

        class CA_TD_Slider: RscXSliderH
        {
        	idc = 13005;
        	x = 0.514;
        	y = 0.345;
        	w = 0.28;
        	h = 0.029412;
        };


		class CA_UC_Button : RscButton {
			idc = 13109;
			x = 0.514313;
			y = 0.512681;
			w = 0.279999;
			text = $STR_WF_TACTICAL_UnitCam;
			action = "WF_MenuAction = 101";
		};

		class CA_SM_Button : RscButton {
            idc = 1310999;
            x = 0.202364;
            y = 0.512681;
            w = 0.279999;
            text = $STR_WF_SQUAD;
            action = "WF_MenuAction = 111";
        };

		/* Disband */
		class CA_Disband_SubTitle : RscText_SubTitle {
			idc = 13011;
			x = 0.19532;
			y = 0.415232;
			w = 0.3;
			text = $STR_WF_TEAM_DisbandLabel;
		};
		class CA_DB_Combo : RscCombo {
			idc = 13013;
			x = 0.202364;
			y = 0.467712;
			w = 0.279999;
			h = 0.035;
		};
		class CA_DB_Button : RscButton {
			idc = 13014;
			x = 0.514313;
			y = 0.465;
			w = 0.279999;
			text = $STR_WF_TEAM_DisbandButton;
			colorBackground[] = {0.09,0.65,0.23,1};
            colorBackgroundActive[] = {0.1,0.72,0.25,1};
            colorFocused[] = {0.768627451, 1, 0.137254902, 1};
            colorShadow[] = {0,0,0,1};
            colorBorder[] = {0,0,0,1};
			action = "WF_MenuAction = 3";
		};

		class HUD_Button: RscButton
        {
            idc = 13020;
            action = "WF_MenuAction = 113";
            x = 0.203;
            y = 0.599632;
            w = 0.275;
            sizeEx = 0.030;
        };

		/* Vote PopUp */
		class VPOPON_Button : RscButton {
			idc = 13019;
			x = 0.203;
            y = 0.65;
            w = 0.275;
			text = "";
			action = "WF_MenuAction = 13";
		}
        class FACICONS_Button: RscButton {
        	idc = 13022;
        	x = 0.514313;
            y = 0.599632;
            w = 0.275;
        	action = "WF_MenuAction = 115";
        };
		/* Seperator */
		class Line_TRH1 : RscText {
			x = 0.192941;
			y = 0.405641;
			w = 0.614486;
			h = WF_SPT1;
			colorBackground[] = WF_SPC1;
		};
		class Line_TRH2 : RscText {
			x = 0.192941;
			y = 0.579632;
			w = 0.614486;
			h = WF_SPT1;
			colorBackground[] = WF_SPC1;
		};
		/* Back */
		class Back_Button : RscButton_Back {
			x = 0.70725;
			y = 0.7132;
			action = "WF_MenuAction = 8";
			tooltip = $STR_WF_TOOLTIP_BackButton;
		};
		/* Exit */
		class Exit_Button : RscButton_Exit {
			x = 0.752;
			y = 0.7132;
			onButtonClick = "closeDialog 0;";
			tooltip = $STR_WF_TOOLTIP_CloseButton;
		};
	};
};