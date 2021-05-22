class RscMenu_Tactical {
	movingEnable = 1;
	idd = 17000;
	onLoad = "_this spawn WFCL_fnc_displayTacticalMenu";

	class controlsBackground {
		class Background_M : RscText {
			x = 0.000960961;
			y = 0.00128125;
			w = 0.999759;
			h = 1.00023;
			moving = 1;
			colorBackground[] = WF_Background_Color;
		};
		class Background_H : RscText {
			x = 0.000960961;
			y = 0.00128125;
			w = 0.999759;
			h = 0.0525;
			moving = 1;
			colorBackground[] = WF_Background_Color_Header;
		};
		class Background_F : RscText {
			x = 0.000960961;
			y = 0.94901125;
			w = 0.999759;
			h = 0.0525;
			moving = 1;
			colorBackground[] = WF_Background_Color_Footer;
		};
		class Background_L : RscText {
			x = 0.000960961;
			y = 0.05278125;
			w = 0.999759;
			h = WF_Background_Border_Thick;
			colorBackground[] = WF_Background_Border;
		};
	};
	class controls {
		class WF_MiniMap : RscMapControl {
			idc = 17002;
			x = 0.374789;
			y = 0.0574369;
			w = 0.625427;
			h = 0.888975;
			ShowCountourInterval = 1;
			widthRailWay = 1;

			onMouseMoving = "mouseX = (_this Select 1);mouseY = (_this Select 2)";
			onMouseButtonDown = "mouseButtonDown = _this Select 1";
			onMouseButtonUp = "mouseButtonUp = _this Select 1";
		};
		class Title_Tactical : RscText_Title {
			idc = 17003;
			x = 0.00561695;
			y = 0.00999998;
			w = 0.3;
			text = $STR_WF_MAIN_TacticalMenu;
		};
		class CA_Artillery_SubTitle : RscText_SubTitle {
			idc = 17004;
			x = 0.00434637;
			y = 0.0596783;
			w = 0.2;
			text = $STR_WF_TACTICAL_Artillery;
		};
		class CA_Artillery_Label_Radius : RscText {
			idc = 17030;
			x = 0.00602637;
			y = 0.226604;
			w = 0.2;
			text = $STR_WF_TACTICAL_ArtilleryRadius;
		};
		class CA_Artillery_Label_Ammo_Type : RscText {
            idc = 17033;
            x = 0.00602637;
            y = 0.181795;
            w = 0.2;
            text = $STR_WF_TACTICAL_ArtilleryAmmoType;
        };
		class CA_Artillery_Label_Unit : RscText {
			idc = 17031;
			x = 0.00602637;
			y = 0.14259;
			w = 0.2;
			text = $STR_WF_TACTICAL_Artillery;
		};
		class CA_Artillery_Slider : RscXSliderH {
			idc = 17005;
			x = 0.14652;
			y = 0.226604;
			w = 0.224033;
			h = 0.029412;
		};
		class CA_Artillery_Ammo_Type_Combo : RscCombo {
            idc = 17033;
            x = 0.145945;
            y = 0.185795;
            w = 0.224033;
            h = 0.029412;
            onLBSelChanged = "WF_MenuAction = 200";
        };
		class CA_SetFMission_Button : RscButton {
			idc = 17006;
			x = 0.01334496;
			y = 0.566833;
			w = 0.15;
			text = $STR_WF_TACTICAL_ArtillerySetFireMission;
			action = "WF_MenuAction = 1";
		};
		class CA_FireMission_Button : RscButton {
			idc = 17007;
			x = 0.22047;
			y = 0.566833;
			w = 0.15;
			text = $STR_WF_TACTICAL_ArtilleryCallFireMission;
			colorBackground[] = {0.09,0.65,0.23,1};
            colorBackgroundActive[] = {0.1,0.72,0.25,1};
            colorFocused[] = {0.768627451, 1, 0.137254902, 1};
            colorShadow[] = {0,0,0,1};
            colorBorder[] = {0,0,0,1};
			action = "WF_MenuAction = 2";
		};
		class CA_Artillery_Combo : RscCombo {
			idc = 17008;
			x = 0.145945;
			y = 0.146217;
			w = 0.224033;
			h = 0.029412;
			onLBSelChanged = "WF_MenuAction = 200";
		};
		class CA_Support_SubTitle : RscText_SubTitle {
			idc = 17009;
			x = 0.00518464;
			y = 0.622955;
			w = 0.2;
			text = $STR_WF_TACTICAL_Support;
		};
		class CA_Artillery_Label_Status : RscText {
			idc = 17032;
			x = 0.00602637;
			y = 0.102254;
			w = 0.2;
			text = $STR_WF_TACTICAL_ArtilleryStatus;
		};
		class CA_ArtilleryTimeout : RscStructuredText {
			idc = 17016;
			x = 0.139245;
			y = 0.107786;
			w = 0.213025;
			size = 0.03;
			shadow = 2;
		};
		class SupportList : RscListBox {
			idc = 17019;
			x = 0.00602497;
			y = 0.663556;
			w = 0.365965;
			h = 0.237187;
			rowHeight = 0.01;
			sizeEx = 0.026;
		};
		class CA_Button_Use : RscButton {
			idc = 17020;
			x = 0.22021;
			y = 0.905171;
			w = 0.15;
			colorBackground[] = {0.09,0.65,0.23,1};
            colorBackgroundActive[] = {0.1,0.72,0.25,1};
            colorFocused[] = {0.768627451, 1, 0.137254902, 1};
            colorShadow[] = {0,0,0,1};
            colorBorder[] = {0,0,0,1};
			text = $STR_WF_TACTICAL_RequestButton;
			action = "WF_MenuAction = 20";
		};
		class CA_SupportCost_Label : RscText {
			idc = 17026;
			x = 0.0119054;
			y = 0.907169;
			w = 0.11;
			text = "$STR_WF_TACTICAL_Price";
			sizeEx = 0.032;
		};
		class CA_SupportCost : RscText {
			idc = 17021;
			x = 0.111905;
			y = 0.907169;
			w = 0.11;
			sizeEx = 0.032;
			colorText[] = {1, 0, 0, 1};
		};
		class CA_InformationText : RscStructuredText {
			idc = 17022;
			x = 0.380816;
			y = 0.0188458;
			w = 0.614286;
			h = 0.035;
			size = 0.03;
			class Attributes {
				align = "center";
			};
		};
		class CA_ArtilleryList : RscListBoxA {
			idc = 17024;
			x = 0.00459768;
			y = 0.321286;
			w = 0.365209;
			h = 0.235;
			columns[] = {0.02, 0.55};
			drawSideArrows = 0;
			idcRight = -1;
			idcLeft = -1;
			rowHeight = 0.05;
			sizeEx = 0.023;

			/* extra */
			colorSelectBackground[] = {0, 0, 0, 0.5};
			colorSelectBackground2[] = {0, 0, 0, 0.5};

			onLBSelChanged = "WF_MenuAction = 60";
		};
		class CA_ArtilleryTable_Label : RscText {
			idc = 17025;
			x = 0.00495766;
			y = 0.276604;
			w = 0.339999;

			text = $STR_WF_TACTICAL_ArtilleryOverview;
		};
		/* Separators */
		class LineTRH1 : RscText {
			x = 0.00638635;
			y = 0.61566;
			w = 0.364063;
			h = WF_SPT1;
			colorBackground[] = WF_SPC1;
		};
		/* Back */
		class Back_Button : RscButton_Back {
			x = 0.892328;
			y = 0.953825;
			action = "WF_MenuAction = 30";
			tooltip = $STR_WF_TOOLTIP_BackButton;
		};
		/* Exit */
		class Exit_Button : RscButton_Exit {
			x = 0.956614;
			y = 0.953825;
			onButtonClick = "closeDialog 0;";
			tooltip = $STR_WF_TOOLTIP_CloseButton;
		};
	};
};