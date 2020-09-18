class WF_VoteMenu {
	movingEnable = 1;
	idd = 500000;
	onLoad = "(_this) spawn WFCL_fnc_displayVoteMenu";

	class controlsBackground {
		class CA_Background : RscText {
			x = 0.273;
			y = 0.134;
			w = 0.5;
			h = 0.8;
			colorBackground[] = WF_Background_Color;
			moving = 1;
		};
		class CA_Background_Header : CA_Background {
			x = 0.273;
			y = 0.134;
			w = 0.5;
			h = 0.06;
			colorBackground[] = WF_Background_Color_Header;
		};
		class CA_Background_Footer : CA_Background {
			x = 0.273;
			y = 0.134 + 0.76;
			w = 0.5;
			h = 0.04;
			colorBackground[] = WF_Background_Color_Sub;
		};
		class CA_Menu_Title : RscText_Title {
			x = 0.28;
			y = 0.134 + 0.01;
			w = 0.5;
			text = $STR_WF_VOTING_Title;
			colorText[] = WF_Menu_Title_Color;
		};
		class CA_Quit_Button: RscButton_Exit {
			x = 0.273 + 0.45;
			y = 0.134 + 0.0075;
			w = 0.045;
			h = 0.045;
			text = "X";
			shadow = 2;
			sizeEx = 0.03;

			onButtonClick = "closeDialog 0;";
		};
	};

	class controls {
		class CA_Vote_List : RscListnBox {
			idc = 500100;
			x = 0.28;
			y = 0.134 + 0.07;
			w = 0.489;
			h = 0.665;
			columns[] = {0.01, 0.75};
			colorDisabled[] = {1,1,1,0.3};
			colorSelectBackground[] = WF_Menu_ListBox_Select_Color;
			colorSelectBackground2[] = WF_Menu_ListBox_Select_Color;

			onLBSelChanged = "WF_MenuAction = 1";
		};
		class CA_Menu_TimeLeft : RscText {
			idc = 500101;
			x = 0.28;
			y = 0.134 + 0.762;
			w = 0.25;
			sizeEx = 0.03;
			text = "";
			colorText[] = WF_Menu_Text_Color;
			shadow = 2;
		};
		class CA_Menu_Elected : CA_Menu_TimeLeft {
			idc = 500102;
			x = 0.273 + 0.20;
			y = 0.134 + 0.762;
			w = 0.3;
			style = ST_RIGHT;
			text = "";
		};
		class CA_Menu_Time_Static : CA_Menu_TimeLeft {
			idc = 500103;
			x = 0.273 + 0.16;
			y = 0.134 + 0.762;
			w = 0.3;
			style = ST_RIGHT;
			text = $STR_WF_VOTING_TimeLeft;
		};
	};
};