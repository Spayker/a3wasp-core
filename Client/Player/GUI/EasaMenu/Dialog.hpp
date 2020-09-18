class RscMenu_EASA {
	movingEnable = 1;
	idd = 23001;
	onLoad = "_this spawn WFCL_fnc_displayEasaMenu";

	class controlsBackground {
		class Background_M : RscText {
			x = 0.157263;
			y = 0.200721;
			w = 0.687155;
			h = 0.601349;
			moving = 1;
			colorBackground[] = WF_Background_Color;
		};
		class Background_H : RscText {
			x = 0.157263;
			y = 0.200721;
			w = 0.687155;
			h = 0.0525;
			moving = 1;
			colorBackground[] = WF_Background_Color_Header;
		};
		class Background_F : RscText {
			x = 0.157263;
			y = 0.749570;
			w = 0.687155;
			h = 0.0525;
			moving = 1;
			colorBackground[] = WF_Background_Color_Footer;
		};
		class Background_L : RscText {
			x = 0.157263;
			y = 0.252221;
			w = 0.687155;
			h = WF_Background_Border_Thick;
			colorBackground[] = WF_Background_Border;
		};
	};
	class controls {
		class Title_EASA : RscText_Title {
			idc = 23002;
			x = 0.162105;
			y = 0.207843;
			w = 0.6;
			text = $STR_WF_EASA;
		};
		class Title_PYLONS : RscText_SubTitle {
			idc = 230002;
			x = 0.162186;
			y = 0.263187;
			w = 0.18075;
			text = $STR_WF_EASA_PYLONS;
		};
		class LB_EASA_PYLONS : RscListBoxA {
			idc = 230033;
			columns[] = {0.005};
			rowHeight = 0.036;
			drawSideArrows = 1;
			idcRight = -1;
			idcLeft = -1;
			x = 0.162186;
			y = 0.303187;
			w = 0.18075;
			h = 0.426481;
			onLBSelChanged = "WF_MenuAction = 111";
			onLBDblClick = "WF_MenuAction = 102";
		};
		class Title_PYLONS_AMMO : RscText_SubTitle {
			idc = 230003;
			x = 0.352186;
			y = 0.263187;
			w = 0.32689;
			text = $STR_WF_EASA_PYLONS_AMMO;
		};
		class LB_EASA_PYLONS_AMMO : RscListBoxA {
			idc = 230034;
			columns[] = {0.005};
			rowHeight = 0.036;
			drawSideArrows = 1;
			idcRight = -1;
			idcLeft = -1;
			x = 0.350186;
			y = 0.303187;
			w = 0.32689;
			h = 0.426481;
			onLBSelChanged = "WF_MenuAction = 112";
		};
		class Title_PYLONS_MODE : RscText_SubTitle {
			idc = 230004;
			x = 0.637186;
			y = 0.263187;
			w = 0.28589;
			text = $STR_WF_EASA_PYLONS_MODE;
		};
		class LB_EASA_PYLONS_MODE : RscListBoxA {
			idc = 230035;
			columns[] = {0.005};
			rowHeight = 0.036;
			drawSideArrows = 1;
			idcRight = -1;
			idcLeft = -1;
			x = 0.68186;
			y = 0.303187;
			w = 0.15589;
			h = 0.426481;
			onLBSelChanged = "WF_MenuAction = 114";
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
		class CA_LabelRearmDefault: RscText {
			idc = 230006;
			x = 0.35;
			y = 0.758018;
			w = 0.12;
		};
		class CA_PurchaseByDefault : RscButton {
			idc = 230007;
			x = 0.44;
			y = 0.758018;
			w = 0.35;
			text = $STR_WF_EASA_Rearm_default;
			action = "WF_MenuAction = 115";
		};
		/* Exit */
		class Exit_Button : RscButton_Exit {
			x = 0.799471;
			y = 0.755506;
			onButtonClick = "closeDialog 0;";
			tooltip = $STR_WF_TOOLTIP_CloseButton;
		};
	};
};