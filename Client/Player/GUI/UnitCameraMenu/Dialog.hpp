class RscMenu_UnitCamera {
	movingEnable = 1;
	idd = 21000;
	onLoad = "_this spawn WFCL_fnc_displayUnitCameraMenu";

	class controlsBackground {
		class Background_M : RscText {
			x = 0.000119537;
			y = 0.70044;
			w = 0.999761;
			h = 0.298829;
			moving = 1;
			colorBackground[] = WF_Background_Color;
		};
		class Background_H : RscText {
			x = 0.000119537;
			y = 0.70044;
			w = 0.999761;
			h = 0.0525;
			moving = 1;
			colorBackground[] = WF_Background_Color_Header;
		};
		class Background_F : RscText {
			x = 0.000119537;
			y = 0.946769;
			w = 0.999761;
			h = 0.0525;
			moving = 1;
			colorBackground[] = WF_Background_Color_Footer;
		};
		class Background_L : RscText {
			x = 0.000119537;
			y = 0.75194;
			w = 0.999761;
			h = WF_Background_Border_Thick;
			colorBackground[] = WF_Background_Border;
		};
	};
	class controls {
		class Title_UnitCam : RscText_Title {
			idc = 21001;
			x = 0.00470497;
			y = 0.706961;
			w = 0.3;
			text = $STR_WF_TACTICAL_UnitCam;
		};
		class CA_Camera_UnitList : RscListBox {
			idc = 21002;
			x = -0.000335053;
			y = 0.755239;
			w = 0.311932;
			h = 0.190877;
			rowHeight = 0.01;
			sizeEx = 0.024;
			colorDisabled[] = {1,1,1,0.3};
			onLBSelChanged = "WF_MenuAction = 101";
		};
		class CA_SquadKI_Label : RscText {
			idc = 21003;
			x = 0.312271;
			y = 0.714061;
			w = 0.3;
			colorText[] = {0.2588, 0.7137, 1, 1};
			text = $STR_WF_UNITCAM_SquadKI;
		};
		class CA_Camera_AIList : RscListBox {
			idc = 21004;
			x = 0.312269;
			y = 0.754063;
			w = 0.311932;
			h = 0.190877;
			rowHeight = 0.01;
			sizeEx = 0.024;
			colorDisabled[] = {1,1,1,0.3};
			onLBSelChanged = "WF_MenuAction = 102";
		};
		class CA_Camera_Mode : RscText {
			idc = 21005;
			x = 0.629077;
			y = 0.713836;
			w = 0.3;
			colorText[] = {0.2588, 0.7137, 1, 1};
			text = $STR_WF_UNITCAM_CamMode;
		};
		class CA_Camera_Combo : RscCombo {
			idc = 21006;
			x = 0.831595;
			y = 0.711259;
			w = 0.163193;
			h = 0.035;
			onLBSelChanged = "WF_MenuAction = 103";
		};
		class CA_MiniMap : RscMapControl {
			idc = 21007;
			x = 0.625041;
			y = 0.75514;
			w = 0.374504;
			h = 0.191614;
			ShowCountourInterval = 1;
			widthRailWay = 1;

			onMouseMoving = "mouseX = (_this Select 1);mouseY = (_this Select 2)";
			onMouseButtonDown = "mouseButtonDown = _this Select 1";
			onMouseButtonUp = "mouseButtonUp = _this Select 1";
		};
		//--Remote control button--
		class CA_RC_Button : RscClickableText {
        	idc = 160004;
        	onButtonClick = "WF_MenuAction = 141";
        	colorDisabled[] = {1,1,1,0.05};

        	text = "\A3\Ui_f\data\IGUI\RscCustomInfo\Sensors\Targets\FriendlyGroundRemote_ca.paa";
        	x = 0.6875;
        	y = 0.954;
        	w = 0.045;
        	h = 0.045;
        	tooltip = $STR_WF_HC_REMOTECONTROL;
        };
		//--Unflip button in Unit Camera Menu--
		class CA_UN_Button : RscClickableText {
			idc = 160003;
			x = 0.76602464;
			y = 0.953825;
			w = 0.045;
			h = 0.045;
			text = "\A3\ui_f\data\GUI\Cfg\Cursors\rotate_gs.paa";
			onButtonClick = "WF_MenuAction = 140";
			colorDisabled[] = {1,1,1,0.3};
			tooltip = $STR_WF_TOOLTIP_UnitCamUnflip;
		};
		/* Exit */
		class CA_UN_Exit_Button : RscButton_Exit {
			x = 0.954933;
			y = 0.953825;
			onButtonClick = "closeDialog 0;";
			tooltip = $STR_WF_TOOLTIP_CloseButton;
		};
	};
};