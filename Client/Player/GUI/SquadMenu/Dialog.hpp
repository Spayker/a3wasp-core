class RscMenu_Squad {
	movingEnable = 1;
	idd = 508000;
	onLoad = "_this spawn WFCL_fnc_displaySquadMenu";

	class controlsBackground {
		class CA_Background : RscText {
			x = 0;
			y = 0;
			w = 0.8;
			h = 0.8;
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
			y = 0.76;
			w = 0.8;
			h = 0.04;
			colorBackground[] = WF_Background_Color_Sub;
		};
		class CA_Menu_Title : RscText_Title {
			x = 0.007;
			y = 0.01;
			w = 0.5;
			text = "Groups Menu :";
			colorText[] = WF_Menu_Title_Color;
		};
		class CA_Quit_Button: RscButton_Main {
			x = 0.75;
			y = 0.0075;
			w = 0.045;
			h = 0.045;
			text = "X";
			shadow = 2;
			sizeEx = 0.03;

			onButtonClick = "closeDialog 0;";
		};
		class CA_Back_Button : CA_Quit_Button {
			x = 0.695;
			text = "<<";
			onButtonClick = "WF_MenuAction = 1000;";
			tooltip = $STR_WF_TOOLTIP_BackButton;
		};
		class CA_Menu_Details : RscText {
			x = 0.405;
			y = 0.07;
			w = 0.39;
			h = 0.215;
			colorBackground[] = {0.5, 0.5, 0.5, 0.15};
			style = ST_TEXT_BG;
		};
		class CA_Menu_Links : CA_Menu_Details {
			y = 0.29;
			h = 0.46;
		};
		class CA_Menu_Groups : RscText {
			x = 0.005;
			y = 0.07;
			w = 0.396;
			h = 0.425;
			colorBackground[] = {0.5, 0.5, 0.5, 0.15};
			style = ST_TEXT_BG;
		};
		class CA_Menu_Requests : RscText {
			x = 0.005;
			y = 0.5;
			w = 0.396;
			h = 0.25;
			colorBackground[] = {0.5, 0.5, 0.5, 0.15};
			style = ST_TEXT_BG;
		};
	};

	class controls {
		class CA_GroupsList : RscListnBox {
			idc = 508001;
			x = 0.01;
			y = 0.12;
			w = 0.386;
			h = 0.36;
			columns[] = {0.01, 0.35};
			rowHeight = 0.03;

			onLBDblClick = "WF_MenuAction = 1";
			onLBSelChanged = "WF_MenuAction = 2";
		};
		class CA_Icon : RscPicture {
			x = 0.67;
			y = 0.090;
			w = 0.128;
			h = 0.128;
			style = 0x30 + 0x800;
			text = "RSC\Pictures\upgrade_infantry.paa";
		};
		class CA_GroupsDetails : RscStructuredText {
			idc = 508002;
			x = 0.41;
			y = 0.080;
			w = 0.26;
			h = 0.195;
			size = 0.0260;
			shadow = 2;

			class Attributes {
				font = "Zeppelin32";
				color = "#E8F0FF";
				align = "left";
				shadow = true;
			};
		};
		class CA_UnitsList : RscListnBox {
			idc = 508003;
			x = 0.41;
			y = 0.34;
			w = 0.38;
			h = 0.40;
			columns[] = {0.01, 0.35};
			rowHeight = 0.045;
			sizeEx = 0.0240;
		};
		class CA_MembersDetails : CA_GroupsDetails {
			idc = 508004;
			y = 0.3;
			h = 0.035;
		};
		class CA_Join : RscButton_Main {
			x = 0.595;
			y = 0.762;
			w = 0.2;
			h = 0.035;
			sizeEx = 0.035;
			text = "Join";
			action = "WF_MenuAction = 1";
		};
		class CA_Groups : CA_GroupsDetails {
			idc = 508005;
			x = 0.01;
			h = 0.035;
		};
		class CA_Request : CA_GroupsDetails {
			idc = 508006;
			x = 0.01;
			y = 0.51;
			h = 0.035;
		};
		class CA_RequestsList : RscListnBox {
			idc = 508007;
			x = 0.01;
			y = 0.55;
			w = 0.386;
			h = 0.19;
			columns[] = {0.01, 0.35};
			rowHeight = 0.0316;

			onLBDblClick = "WF_MenuAction = 3";
			// onLBSelChanged = "WF_MenuAction = 2";
		};
		class CA_Accept_Button : RscButton {
			idc = 508008;
			x = 0.01;
			y = 0.762;
			w = 0.15;
			h = 0.035;
			sizeEx = 0.035;

			text = "Accept";

			colorBackground[] = WF_Menu_Button_Sub_Color;
			colorBackgroundActive[] = WF_Menu_Button_Sub_Color;
			colorFocused[] = WF_Menu_Button_Sub_Focused_Color;

			onButtonClick = "WF_MenuAction = 3;";
		};
		class CA_Deny_Button : CA_Accept_Button {
			idc = 508009;
			x = 0.17;

			text = "Deny";

			onButtonClick = "WF_MenuAction = 4;";
		};
		class CA_Kick_Button : CA_Accept_Button {
			idc = 508009;
			x = 0.33;

			text = "Kick";

			onButtonClick = "WF_MenuAction = 5;";
		};
	};
};