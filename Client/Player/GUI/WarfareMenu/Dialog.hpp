#define	WFMM_H					0.25
#define WFMM_W					WFMM_H

#define WFMM_Top				WFMM_H * 0.34
#define WFMM_Left				WFMM_H * 0.12
#define WFMM_Right				WFMM_H * 0.38
#define WFMM_Bottom				WFMM_H * 0.3

#define WFMM_FontSize			WFMM_H * 0.17

#define WFMM_X					0.5 - WFMM_H / 2
#define WFMM_Y					0.5 - WFMM_H / 2
#define WFMM_XD					WFMM_H * 0.6
#define WFMM_YD					WFMM_H / 2.15

//// Button Class
class WF_Menu_RscShortcutButton: RscShortcutButton {
	type = 16;
	idc = -2;
	style = 0x800 + 0x200 + 16 + 0x02;
	default = 0;
	color[] = {0.543, 0.5742, 0.4102, 1.0};
	color2[] = {0.95, 0.95, 0.95, 1};
	colorBackground[] = {1, 1, 1, 1};
	colorbackground2[] = {1, 1, 1, 0.4};
	colorDisabled[] = {1, 1, 1, 0.25};
	periodFocus = 1.2;
	periodOver = 0.8;
	soundEnter[] = {WF_SoundEnter,0.09,1};
    soundPush[] = {WF_SoundPush,0.09,1};
    soundClick[] = {WF_SoundClick,0.07,1};
    soundEscape[] = {WF_SoundEscape,0.09,1};
	class HitZone {
		left = 0.03;
		top = 0.05;
		right = 0.005;
		bottom = 0.005;
	};
	class ShortcutPos {
		left = 0;
		top = 0;
		w = 0.15;
		h = 0.15;
	};
	 class TextPos {
		left = 0.04;
		top = 0.085;
		right = 0.1;
		bottom = 0.085;
	};
	animTextureNormal = "RSC\Pictures\wf_menu\MB_Normal.paa";
	animTextureDisabled = "RSC\Pictures\wf_menu\MB_Disabled.paa";
	animTextureOver = "RSC\Pictures\wf_menu\MB_Focus.paa";
	animTextureFocused = "RSC\Pictures\wf_menu\MB_Normal.paa";
	animTexturePressed = "RSC\Pictures\wf_menu\MB_Click.paa";
	animTextureDefault = "RSC\Pictures\wf_menu\MB_Normal.paa";

	textureNoShortcut = "";
	period = 0.4;
	font = "PuristaMedium";
	size = 0.035;
	sizeEx = 0.035;
	text = "";
	action = "";
	class Attributes {
		font = "PuristaMedium";
		color = "#42b6ff";
		align = "center";
		shadow = "true";
	};
	class AttributesImage {
		font = "PuristaMedium";
		color = "#42b6ff";
		align = "center";
	};
};

class WF_MenuMainButton: WF_Menu_RscShortcutButton {
	w = WFMM_W;
	h = WFMM_H;

	class HitZone {
		left = WFMM_Left;
		top = WFMM_Top;
		right = WFMM_Right;
		bottom = WFMM_Top;
	};
	class TextPos {
		left = WFMM_Left;
		top = WFMM_Top;
		right = WFMM_Right;
		bottom = WFMM_Top;
	};

	font = "TahomaB";
	size = WFMM_FontSize;
	sizeEx = WFMM_FontSize;

	color[] = {0.2588, 0.7137, 1, 1};
	color2[] = {0.95, 0.95, 0.95, 1};
	colorBackground[] = {0.8, 0.8, 0.8, 1};
	colorbackground2[] = {1, 1, 1, 0.4};
	colorDisabled[] = {1, 1, 1, 0.25};
	colorFocused[] = {0.2588, 0.7137, 1, 1};
	colorBackGroundFocused[] = {0.2588, 0.7137, 1, 1};
};

class MainMenuButtonLittle: WF_MenuMainButton {
	w = WFMM_W / 2;
	h = WFMM_H / 2;

	class HitZone {
		left = WFMM_Left / 2;
		top = WFMM_Top / 2;
		right = WFMM_Right / 2;
		bottom = WFMM_Top / 2.5;
	};
	class TextPos {
		left = WFMM_Left / 2;
		top = WFMM_Top / 2;
		right = WFMM_Right  / 2;
		bottom = WFMM_Top  / 2.5;
	};

	font = "PuristaMedium";
	size = WFMM_FontSize / 1.75;
	sizeEx = WFMM_FontSize / 1.75;
};

//// WF Main Menu
class WF_Menu {
	movingEnable = 1;
	idd = 68792001;
	onLoad = "_this spawn WFCL_fnc_displayWarfareMenu";

	//// BackGround
	class controlsBackground {};

	//// Controls
	class controls {
		class TeamMenu: WF_MenuMainButton
		{
			idc	= 2000;
			x = 0.5 - WFMM_H / 2 * 1.15;
			y = 0.5 - WFMM_H / 2 * 1.15;
			w = WFMM_W * 1.2;
			h = WFMM_H * 1.2;

			class TextPos {
                left = WFMM_H * 0.07;
                top = WFMM_Top;
                right = WFMM_H * 0.38;
                bottom = WFMM_Top;
            };
            shortcuts[] = { 50 };
			text = $STR_WF_MAIN_TeamMenu;
            tooltip = $STR_WF_TOOLTIP_MainMenu_TeamMenu;
			Show = false;
            action = "WF_MenuAction = 3";
		};

		class BuyUnits: WF_MenuMainButton
		{
			idc	= 2002;
			x = WFMM_X - WFMM_XD / 2 * 2.1;
			y = WFMM_Y - WFMM_YD;
			shortcuts[] = { 48 };
			text = $STR_WF_MAIN_Purchase_Units;
            tooltip = $STR_WF_TOOLTIP_MainMenu_Purchase_Units;
			Show = false;
			action = "WF_MenuAction = 1";
		};

		class BuyGear: WF_MenuMainButton
        {
            idc	= 2003;
            x = WFMM_X - WFMM_XD / 2 * 2.1;
            y = WFMM_Y + WFMM_YD / 2 * 2.25;
            shortcuts[] = { 34 };
            text = $STR_WF_MAIN_Purchase_Gear;
            tooltip = $STR_WF_TOOLTIP_MainMenu_Purchase_Gear;
            Show = false;
            action = "WF_MenuAction = 2";
        };

        class VoteMenu: WF_MenuMainButton
        {
            idc	= 2008;
            x = WFMM_X - WFMM_XD / 2 * 0.01;
            y = WFMM_Y - WFMM_YD / 2 * 4.25;
            shortcuts[] = { 47 };
            text = $STR_WF_MAIN_VotingMenu;
            tooltip = $STR_WF_TOOLTIP_MainMenu_VoteForCommander;
            Show = false;
            action = "WF_MenuAction = 4";
        };

        class SupportMenu: WF_MenuMainButton
        {
            idc	= 2005;
            x = WFMM_X - WFMM_XD / 2 * 0.01;
            y = WFMM_Y + WFMM_YD / 2 * 4.35;
            shortcuts[] = { 31 };
            text = $STR_WF_SupportMenu;
            tooltip = $STR_WF_TOOLTIP_CommandMenu_SupportMenu;
            Show = false;
            action = "WF_MenuAction = 9";
        };

        class RoleSelectorMenu: WF_MenuMainButton
        {
            idc	= 2001;
            x = WFMM_X - WFMM_XD / 2 * 4;
            y = WFMM_Y + WFMM_YD / 2 * 0.2;
            shortcuts[] = { 19 };
            text = $STR_WF_MAIN_RoleSelector;
            tooltip = $STR_WF_TOOLTIP_MainMenu_RoleSelectorMenu;
            Show = false;
            action = "WF_MenuAction = 14";
        };

        class EconomyMenu: WF_MenuMainButton
        {
            idc	= 2009;
            x = WFMM_X + WFMM_XD / 2 * 2.1;
            y = WFMM_Y - WFMM_YD;
            shortcuts[] = { 18 };
            text = $STR_WF_MAIN_EconomyMenu;
            tooltip = $STR_WF_TOOLTIP_CommandMenu_Commander_Menu;
            Show = false;
            action = "WF_MenuAction = 8";
        };

		class UpgradeMenu: WF_MenuMainButton
        {
            idc	= 2007;
            x = WFMM_X + WFMM_XD / 2 * 2.1;
            y = WFMM_Y + WFMM_YD / 2 * 2.25;
            shortcuts[] = { 22 };
            text = $STR_WF_MAIN_UpgradeMenu;
            tooltip = $STR_WF_TOOLTIP_CommandMenu_Upgrade_Menu;
            Show = false;
            action = "WF_MenuAction = 7";
        };

        class TacticalMenu: WF_MenuMainButton
        {
            idc	= 2004;
            x = WFMM_X + WFMM_XD / 2 * 4;
            y = WFMM_Y + WFMM_YD / 2 * 0.2;
            shortcuts[] = { 20 };
            text = $STR_WF_MAIN_TacticalMenu;
            tooltip = $STR_WF_TOOLTIP_CommandMenu_SpecialMenu;
            Show = false;
            action = "WF_MenuAction = 6";
        };

        //// Litle Buttons
        class CA_Help_Button: MainMenuButtonLittle
        {
            idc	= 2011;
            x = WFMM_X - WFMM_XD * 0.55;
            y = WFMM_Y - WFMM_YD * 1.9;
            shortcuts[] = { 35 };
            tooltip = $STR_WF_TOOLTIP_CommandMenu_Help;
            action = "WF_MenuAction = 13";
        };

        class CA_PA_Button: MainMenuButtonLittle
        {
            idc	= 2012;
            x = WFMM_X + WFMM_XD * 1.15;
            y = WFMM_Y - WFMM_YD * 1.9;
            shortcuts[] = { 25 };
            tooltip = $STR_WF_TOOLTIP_Parameter;
            action = "WF_MenuAction = 12";
        };
        //--Unflip button--
        class CA_UNFLIP_Button: MainMenuButtonLittle
        {
            idc	= 2013;
            x = WFMM_X - WFMM_XD * 0.55;
            y = WFMM_Y - WFMM_YD * -3.1;
            tooltip = $STR_WF_COMMAND_UnflipButton;
            action = "WF_MenuAction = 10";
        };
        //--Headbug Fix--
        class CA_DCR_Button: MainMenuButtonLittle
        {
            idc	= 2014;
            x = WFMM_X + WFMM_XD * 1.15;
            y = WFMM_Y - WFMM_YD * -3.1;
            tooltip = $STR_WF_TOOLTIP_HeadbugFix;
            action = "WF_MenuAction = 11";
        };
	};
};