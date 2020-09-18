class RscMenu_TANK_MAGZ {
	movingEnable = 1;
	idd = 23002;
	onLoad = "_this spawn WFCL_fnc_displayTankMagzMenu";

	class controlsBackground {
		class Background_M : RscText {
			x = 0.157263;
			y = 0.200721;
			w = 0.8;
			h = 0.601349;
			moving = 1;
			colorBackground[] = WF_Background_Color;
		};
		class Background_H : RscText {
			x = 0.157263;
			y = 0.200721;
			w = 0.8;
			h = 0.0525;
			moving = 1;
			colorBackground[] = WF_Background_Color_Header;
		};
		class Background_F : RscText {
			x = 0.157263;
			y = 0.749570;
			w = 0.8;
			h = 0.0525;
			moving = 1;
			colorBackground[] = WF_Background_Color_Footer;
		};
		class Background_L : RscText {
			x = 0.157263;
			y = 0.252221;
			w = 0.8;
			h = WF_Background_Border_Thick;
			colorBackground[] = WF_Background_Border;
		};
	};
	class controls {
		class Title_TANK_MAGZ : RscText_Title {
			idc = 23002;
			x = 0.162105;
			y = 0.207843;
			w = 0.7;
			text = $STR_WF_TANK_MAGZ;
		};
		class Title_WEAPS : RscText_SubTitle {
			idc = 230002;
			x = 0.162186;
			y = 0.263187;
			w = 0.18085;
			text = $STR_WF_TANK_MAGZ_TURRETS;
		};
		class LB_TANK_WEAPS : RscListBoxA {
			idc = 230033;
			columns[] = {0.005};
			rowHeight = 0.036;
			drawSideArrows = 1;
			idcRight = -1;
			idcLeft = -1;
			x = 0.162186;
			y = 0.303187;
			w = 0.5575;
			h = 0.426481;
			onLBSelChanged = "WF_MenuAction = 111";
			onLBDblClick = "WF_MenuAction = 102";
		};
		class CA_LabelRearm: RscText {
			idc = 230005;
			x = 0.162186;
			y = 0.758018;
			w = 0.12;
		};
		class CA_Purchase : RscButton {
			idc = 22004;
			x = 0.25;
			y = 0.758018;
			w = 0.1;
			text = $STR_WF_Purchase;
			action = "WF_MenuAction = 101";
		};
		/* Exit */
		class Exit_Button : RscButton_Exit {
			x = 0.9125;
			y = 0.755506;
			onButtonClick = "closeDialog 0;";
			tooltip = $STR_WF_TOOLTIP_CloseButton;
		};
	};
};