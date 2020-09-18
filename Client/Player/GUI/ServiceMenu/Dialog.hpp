class RscMenu_Service {
	movingEnable = 1;
	idd = 20000;
	onLoad = "[] spawn WFCL_fnc_displayServiceMenu";

	class controlsBackground {
		class Background_M : RscText {
			x = 0;
			y = 0.1516;
			w = 1;
			h = 0.777948;
			moving = 1;
			colorBackground[] = WF_Background_Color;
		};
		class Background_H : RscText {
			x = 0;
			y = 0.1516;
			w = 1;
			h = 0.0525;
			moving = 1;
			colorBackground[] = WF_Background_Color_Header;
		};
		class Background_F : RscText {
			x = 0;
			y = 0.8768;
			w = 1;
			h = 0.0525;
			moving = 1;
			colorBackground[] = WF_Background_Color_Footer;
		};
		class Background_L : RscText {
			x = 0;
			y = 0.202921;
			w = 1;
			h = WF_Background_Border_Thick;
			colorBackground[] = WF_Background_Border;
		};
	};
	class controls {
		class Title_Service : RscText_Title {
			idc = 20001;
			x = 0;
			y = 0.1576;
			w = 0.3;
			text = $STR_WF_SupportMenu;
		};
		class CA_UnitList : RscListBoxA {
			idc = 20002;
			x = 0.01;
			y = 0.21;
			w = 0.98;
			h = 0.429552;

            columns[] = {-0.01,0.135,0.215,0.7045,0.731,0.797,0.823,0.879,0.905};
			//           grp   num   name  icon h       icon am     icon fuel
			colorPicture[] = {1, 1, 1, 1};
			drawSideArrows = false;
			idcRight = -1;
            idcLeft = -1;
			rowHeight = 0.025;
			colorDisabled[] = {1,1,1,0.3};
			sizeEx = 0.035;
			onLBSelChanged = "WF_MenuAction = 10";
		};
		class CA_Rearm_Button : RscButton {
			idc = 20003;
			x = 0.161261;
			y = 0.650391;
			w = 0.16;
			text = $STR_WF_SERVICE_Rearm;
			action = "WF_MenuAction = 1";
		};
		class CA_Repair_Button : RscButton {
			idc = 20004;
			x = 0.50748;
			y = 0.650391;
			w = 0.16;
			text = $STR_WF_SERVICE_Repair;
			action = "WF_MenuAction = 2";
		};
		class CA_Refuel_Button : RscButton {
			idc = 20005;
			x = 0.161261;
			y = 0.697899;
			w = 0.16;
			text = $STR_WF_SERVICE_Refuel;
			action = "WF_MenuAction = 3";
		};
		class CA_Heal_Button : RscButton {
			idc = 20008;
			x = 0.50748;
			y = 0.697899;
			w = 0.16;
			text = $STR_WF_SERVICE_Heal;
			action = "WF_MenuAction = 5";
		};
		class CA_EASA_Button : RscButton {
			idc = 20010;
			x = 0.161261;
			y = 0.747311;
			w = 0.565918;
			text = $STR_WF_SERVICE_EASA;
			action = "WF_MenuAction = 7";
		};
		class CA_LabelSKIN: RscText {
			idc = 20016;
			x = 0.16;
			y = 0.84;
			w = 0.28;
		};
		class LB_SKIN_ARR : RscCombo {
			idc = 20015;
			x = 0.347507;
			y = 0.84;
			w = 0.255918;
			h = 0.036;
			onLBSelChanged = "WF_MenuAction = 9";
		};
		class CA_LabelRearm: RscText {
			idc = 20011;
			x = 0.388739;
			y = 0.653752;
			w = 0.12;
		};
		class CA_LabelRepair : CA_LabelRearm {
			idc = 20012;
			x = 0.734957;
			y = 0.653752;
			w = 0.12;
		};
		class CA_LabelRefuel : CA_LabelRearm {
			idc = 20013;
			x = 0.388739;
			y = 0.699691;
			w = 0.12;
		};
		class CA_LabelHeal : CA_LabelRearm {
			idc = 20014;
			x = 0.734957;
			y = 0.699691;
			w = 0.12;
		};
		/* Back */
		class Back_Button : RscButton_Back {
			x = 0.9;
			y = 0.8816;
			action = "WF_MenuAction = 8";
			tooltip = $STR_WF_TOOLTIP_BackButton;
		};
		/* Exit */
		class Exit_Button : RscButton_Exit {
			x = 0.95;
			y = 0.8816;
			onButtonClick = "closeDialog 0;";
			tooltip = $STR_WF_TOOLTIP_CloseButton;
		};

		class RscButton_1607: RscButton
		{
			idc = 20018;
			action = "WF_MenuAction = 17";

			x = 0.1625;
			y = 0.8;
			w = 0.565917;
			h = 0.036;

			text = $STR_WF_TANK_MAGZ;
		};

		/*Do action for all units in list*/
		class RscButton_1608: RscButton
		{
			//-RELOAD--
			idc = 1608;
			text = "ALL"; //--- ToDo: Localize;
			x = 0.327;
			y = 0.6504;
			w = 0.06;
			h = 0.036;

			action = "WF_MenuAction = 88";
		};
		class RscButton_1609: RscButton
		{
			//-REFUEL--
			idc = 1609;
			text = "ALL"; //--- ToDo: Localize;
			x = 0.327;
			y = 0.698;
			w = 0.06;
			h = 0.036;

			action = "WF_MenuAction = 89";
		};
		class RscButton_1610: RscButton
		{
			//-REPAIR--
			idc = 1610;
			text = "ALL"; //--- ToDo: Localize;
			x = 0.675;
			y = 0.6504;
			w = 0.06;
			h = 0.036;

			action = "WF_MenuAction = 90";
		};
		class RscButton_1611: RscButton
		{
			//-HEAL--
			idc = 1611;
			text = "ALL"; //--- ToDo: Localize;
			x = 0.675;
			y = 0.698;
			w = 0.06;
			h = 0.036;

			action = "WF_MenuAction = 91";
		};
	};
};