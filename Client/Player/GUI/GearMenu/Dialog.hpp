class WF_BuyGearMenu
{
	movingEnable = 0;
	idd = 503000;

	onLoad = "uiNamespace setVariable ['wf_dialog_ui_gear', _this select 0];['onLoad'] spawn WFCL_fnc_displayWarfareGearMenu";
	onUnload = "uiNamespace setVariable ['wf_dialog_ui_gear', nil]; ['onUnload'] call WFCL_fnc_displayWarfareGearMenu";

	class controlsBackground {
		class WF_Background : RscTextGear {
			x = "SafeZoneX";
			y = "SafeZoneY";
			w = "SafeZoneW";
			h = "SafeZoneH";

			colorBackground[] = {0, 0, 0, 0.7};
			moving = 0;
		};
		class WF_Background_Header : WF_Background {
			x = "SafeZoneX";
			y = "SafeZoneY";
			w = "SafeZoneW";
			h = "SafeZoneH * 0.06";

			colorBackground[] = {0, 0, 0, 0.4};
		};
		class WF_Background_Footer : WF_Background {
			x = "SafeZoneX";
			y = "SafeZoneY + (SafezoneH * 0.96)";
			w = "SafeZoneW";
			h = "SafeZoneH * 0.04";

			colorBackground[] = {0, 0, 0, 0.3};
		};
		class WF_Menu_Title : RscTextGear {
			x = "SafeZoneX + (SafeZoneW * 0.007)";
			y = "SafeZoneY + (SafezoneH * 0.01)";
			w = "SafeZoneW * 0.5";
			h = "SafeZoneH * 0.037";

			text = $STR_WF_GEAR_PurchaseMenu;
			colorText[] = {0.258823529, 0.713725490, 1, 1};

			sizeEx = "(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
		};
		class WF_Background_Gear : RscTextGear {
			x = "SafeZoneX + (SafeZoneW * 0.4)";
			y = "SafeZoneY + (SafezoneH * 0.06)";
			w = "SafeZoneW * 0.6";
			h = "SafeZoneH * 0.9";

			colorBackground[] = {0.5, 0.5, 0.5, 0.15};
		};
		class WF_Menu_Icons_Frame : RscFrameGear {
			x = "SafeZoneX + (SafeZoneW * 0.01)";
			y = "SafeZoneY + (SafezoneH * 0.07)";
			w = "SafeZoneW * 0.38";
			h = "SafeZoneH * 0.08";
		};
		class WF_Menu_Icons_Background : RscTextGear {
			x = "SafeZoneX + (SafeZoneW * 0.01)";
			y = "SafeZoneY + (SafezoneH * 0.07)";
			w = "SafeZoneW * 0.38";
			h = "SafeZoneH * 0.08";
			colorBackground[] = {0.5, 0.5, 0.5, 0.25};
		};

		class WF_Menu_ComboTarget_Frame : RscFrameGear {
			x = "SafeZoneX + (SafeZoneW * 0.01)";
			y = "SafeZoneY + (SafezoneH * 0.17)";
			w = "SafeZoneW * 0.38";
			h = "SafeZoneH * 0.055";
		};
		class WF_Menu_ComboTarget_Background : WF_Menu_Icons_Background {
			y = "SafeZoneY + (SafezoneH * 0.17)";
			h = "SafeZoneH * 0.055";
		};
		class WF_Menu_ComboTarget_Label : RscTextGear {
			x = "SafeZoneX + (SafeZoneW * 0.02)";
			y = "SafeZoneY + (SafezoneH * 0.18)";
			w = "SafeZoneW * 0.1";
			h = "SafeZoneH * 0.035";

			text = $STR_WF_GEAR_SquadMember;

			sizeEx = "0.9 * (			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
		};

		class WF_Menu_ShopList_Frame : RscFrameGear {
			x = "SafeZoneX + (SafeZoneW * 0.01)";
			y = "SafeZoneY + (SafezoneH * 0.245)";
			w = "SafeZoneW * 0.38";
			h = "SafeZoneH * 0.48";
		};
		class WF_Menu_ShopList_Background : WF_Menu_ComboTarget_Background {
			y = "SafeZoneY + (SafezoneH * 0.245)";
			h = "SafeZoneH * 0.48";
		};
		class WF_Menu_MagsList_Background : WF_Menu_ComboTarget_Background {
			x = "SafeZoneX + (SafeZoneW * 0.41)";
			y = "SafeZoneY + (SafezoneH * 0.545)";
			w = "SafeZoneW * 0.28";
			h = "SafeZoneH * 0.395";
		};
	};

	class controls {
		//--- Interactive background controls
		class WF_Gear_Container_Uniform : RscTextGear {
			idc = 77001;

			x = "SafeZoneX + (SafeZoneW * 0.41)";
			y = "SafeZoneY + (SafezoneH * 0.07)";
			w = "SafeZoneW * 0.09";
			h = "SafeZoneH * 0.112";

			colorBackground[] = {1, 1, 1, 0.15};
		};
		class WF_Gear_Container_Vest : WF_Gear_Container_Uniform {
			idc = 77002;

			x = "SafeZoneX + (SafeZoneW * 0.505)";
		};
		class WF_Gear_Container_Backpack : WF_Gear_Container_Uniform {
			idc = 77003;

			x = "SafeZoneX + (SafeZoneW * 0.60)";
		};
		class WF_Gear_Container_Helm : WF_Gear_Container_Uniform {
			idc = 77004;

			x = "SafeZoneX + (SafeZoneW * 0.70)";
			w = "SafeZoneW * 0.07";
			h = "SafeZoneH * 0.09";
		};
		class WF_Gear_Container_Glasses : WF_Gear_Container_Helm {
			idc = 77005;

			x = "SafeZoneX + (SafeZoneW * 0.774)";
		};
		class WF_Gear_Container_NVGoggles : WF_Gear_Container_Helm {
			idc = 77006;

			x = "SafeZoneX + (SafeZoneW * 0.847)";
		};
		class WF_Gear_Container_Binoculars : WF_Gear_Container_Helm {
			idc = 77007;

			x = "SafeZoneX + (SafeZoneW * 0.921)";
		};
		class WF_Gear_Container_Map : WF_Gear_Container_Uniform {
			idc = 77008;

			x = "SafeZoneX + (SafeZoneW * 0.70)";
			y = "SafeZoneY + (SafezoneH * 0.17)";
			w = "SafeZoneW * 0.056";
			h = "SafeZoneH * 0.07";
		};
		class WF_Gear_Container_GPS : WF_Gear_Container_Map {
			idc = 77009;

			x = "SafeZoneX + (SafeZoneW * 0.759)";
		};
		class WF_Gear_Container_Radio : WF_Gear_Container_Map {
			idc = 77010;

			x = "SafeZoneX + (SafeZoneW * 0.818)";
		};
		class WF_Gear_Container_Compass : WF_Gear_Container_Map {
			idc = 77011;

			x = "SafeZoneX + (SafeZoneW * 0.877)";
		};
		class WF_Gear_Container_Clock : WF_Gear_Container_Map {
			idc = 77012;

			x = "SafeZoneX + (SafeZoneW * 0.936)";
		};

		class WF_Gear_Container_Primary : WF_Gear_Container_Uniform {
			idc = 77013;

			x = "SafeZoneX + (SafeZoneW * 0.70)";
			y = "SafeZoneY + (SafezoneH * 0.25)";
			w = "SafeZoneW * 0.29";
			h = "SafeZoneH * 0.09";
		};
		class WF_Gear_Container_Primary_Muzzle : WF_Gear_Container_Map { // wasp
			idc = 77014;

			x = "SafeZoneX + (SafeZoneW * 0.70)";
			y = "SafeZoneY + (SafezoneH * 0.345)";
			w = "SafeZoneW * 0.044";
		};
		class WF_Gear_Container_Primary_Flashlight : WF_Gear_Container_Primary_Muzzle {
			idc = 77015;

			x = "SafeZoneX + (SafeZoneW * 0.7465)";
			w = "SafeZoneW * 0.044";
		};
		class WF_Gear_Container_Primary_Optics : WF_Gear_Container_Primary_Muzzle {
			idc = 77016;

			x = "SafeZoneX + (SafeZoneW * 0.793)";
			w = "SafeZoneW * 0.044";
		};
                class WF_Gear_Container_Primary_Bipod : WF_Gear_Container_Primary_Muzzle {
			idc = 77017;

			x = "SafeZoneX + (SafeZoneW * 0.8395)";
			w = "SafeZoneW * 0.044";
		};
		class WF_Gear_Container_Primary_CurrentMagazine : WF_Gear_Container_Primary_Muzzle {
			idc = 77901;

			x = "SafeZoneX + (SafeZoneW * 0.886)";
			w = "SafeZoneW * 0.044";
		};

		class WF_Gear_Container_Primary_CurrentGPMuzzle : WF_Gear_Container_Primary_Muzzle {
            idc = 77992;

            x = "SafeZoneX + (SafeZoneW * 0.933)";
            w = "SafeZoneW * 0.056";
		};

		class WF_Gear_Container_Secondary : WF_Gear_Container_Primary {
			idc = 77018;

			x = "SafeZoneX + (SafeZoneW * 0.70)";
			y = "SafeZoneY + (SafezoneH * 0.42)";
		};
		class WF_Gear_Container_Secondary_Muzzle : WF_Gear_Container_Map {
			idc = 77019;

			x = "SafeZoneX + (SafeZoneW * 0.70)";
			y = "SafeZoneY + (SafezoneH * 0.515)";
			w = "SafeZoneW * 0.06775";
		};
		class WF_Gear_Container_Secondary_Flashlight : WF_Gear_Container_Secondary_Muzzle {
			idc = 77020;

			x = "SafeZoneX + (SafeZoneW * 0.77375)";
		};
		class WF_Gear_Container_Secondary_Optics : WF_Gear_Container_Secondary_Muzzle {
			idc = 77021;

			x = "SafeZoneX + (SafeZoneW * 0.848)";
		};
        class WF_Gear_Container_Secondary_Bipod : WF_Gear_Container_Secondary_Muzzle {
			idc = 77022;

			x = "SafeZoneX + (SafeZoneW * 0.8515)+100";
		};
		class WF_Gear_Container_Secondary_CurrentMagazine : WF_Gear_Container_Secondary_Muzzle {
			idc = 77902;

			x = "SafeZoneX + (SafeZoneW * 0.92225)";
		};

		class WF_Gear_Container_Pistol : WF_Gear_Container_Primary {
			idc = 77023;
			x = "SafeZoneX + (SafeZoneW * 0.70)";
			y = "SafeZoneY + (SafezoneH * 0.595)";
		};
		class WF_Gear_Container_Pistol_Muzzle : WF_Gear_Container_Map {
			idc = 77024;

			x = "SafeZoneX + (SafeZoneW * 0.70)";
			y = "SafeZoneY + (SafezoneH * 0.695)";
			w = "SafeZoneW * 0.06775";
		};
		class WF_Gear_Container_Pistol_Flashlight : WF_Gear_Container_Pistol_Muzzle {
			idc = 77025;

			x = "SafeZoneX + (SafeZoneW * 0.77375)";
		};
		class WF_Gear_Container_Pistol_Optics : WF_Gear_Container_Pistol_Muzzle {
			idc = 77026;

			x = "SafeZoneX + (SafeZoneW * 0.848)";
		};
                class WF_Gear_Container_Pistol_Bipod : WF_Gear_Container_Pistol_Muzzle {
			idc = 77027;

			x = "SafeZoneX + (SafeZoneW * 0.8515)+100";
		};
		class WF_Gear_Container_Pistol_CurrentMagazine : WF_Gear_Container_Pistol_Muzzle {
			idc = 77903;

			x = "SafeZoneX + (SafeZoneW * 0.92225)";
		};


		class WF_Gear_Container_Items_Unit : WF_Gear_Container_Pistol_Muzzle {
			idc = 77109;

			x = "SafeZoneX + (SafeZoneW * 0.41)";
			y = "SafeZoneY + (SafezoneH * 0.25)";
			w = "SafeZoneW * 0.28";
			h = "SafeZoneH * 0.28";
		};

		//--- Actual controls
		class WF_Gear_Control_Items_Purchase : RscListNBoxGear {
			idc = 70108;

			x = "SafeZoneX + (SafeZoneW * 0.01)";
			y = "SafeZoneY + (SafezoneH * 0.245)";
			w = "SafeZoneW * 0.38";
			h = "SafeZoneH * 0.48";

			rowHeight = "1.5 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			sizeEx = "0.78 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";

			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
			itemBackground[] = {1,1,1,0.1};
			columns[] = {0.26, 0.001};

			canDrag = 1;

			onLBDblClick = "['onShoppingListLBDblClick', _this select 1] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrag = "['onShoppingListLBDrag', _this select 1] call WFCL_fnc_displayWarfareGearMenu";
			onLBSelChanged = "['onShoppingListLBSelChanged', _this select 1] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Linked_Items : WF_Gear_Control_Items_Purchase {
			idc = 70601;

			x = "SafeZoneX + (SafeZoneW * 0.41)";
			y = "SafeZoneY + (SafezoneH * 0.545)";
			w = "SafeZoneW * 0.28";
			h = "SafeZoneH * 0.395";

			onLBDblClick = "['onLinkedListLBDblClick', _this select 1] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrag = "['onShoppingListLBDrag', _this select 1] call WFCL_fnc_displayWarfareGearMenu";
			onLBSelChanged = "['onLinkedItemsLBSelChanged', _this select 1] call WFCL_fnc_displayWarfareGearMenu";
		};

		class WF_Gear_Control_Items_Unit : RscListNBoxGear {
			idc = 70109;

			x = "SafeZoneX + (SafeZoneW * 0.41)";
			y = "SafeZoneY + (SafezoneH * 0.25)";
			w = "SafeZoneW * 0.28";
			h = "SafeZoneH * 0.28";

			rowHeight = "1.65 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			sizeEx = "0.8 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";

			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
			itemBackground[] = {1,1,1,0.1};
			itemSpacing = 0.001;
			columns[] = {0.01, 0.4};

			onLBDblClick = "['onUnitItemsLBDblClick', _this select 1] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'ListItems', 77109, ((_this select 4) select 0) select 2, -1] call WFCL_fnc_displayWarfareGearMenu";
		};

		class WF_Gear_Control_Uniform: RscActiveTextGear {
			idc = 70001;

			style = ST_KEEP_ASPECT_RATIO;
			soundDoubleClick[] = {"",0.1,1};

			colorBackground[] = {0.6, 0.83, 0.47, 1};
			colorBackgroundSelected[] = {0.6, 0.83, 0.47, 1};
			colorFocused[] = {0, 0, 0, 0};
			color[] = {0.85, 0.85, 0.85, 1};
			colorText[] = {0.85, 0.85, 0.85, 1};
			colorActive[] = {1, 1, 1, 1};
			colorDisabled[] = {1,1,1,0.3};

			canDrag = 1;

			x = "SafeZoneX + (SafeZoneW * 0.41)";
			y = "SafeZoneY + (SafezoneH * 0.07)";
			w = "SafeZoneW * 0.09";
			h = "SafeZoneH * 0.112";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_uniform_gs.paa";
			action = "['onItemContainerClicked', 0, 77001] call WFCL_fnc_displayWarfareGearMenu";
			onMouseButtonDown = "['onItemContainerMouseClicked', 0, 70001, _this select 1] call WFCL_fnc_displayWarfareGearMenu";
			onMouseButtonDblClick = "['onItemContainerMouseDblClicked', 0] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Container', 77001, ((_this select 4) select 0) select 2, 0] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Vest: WF_Gear_Control_Uniform {
			idc = 70002;

			x = "SafeZoneX + (SafeZoneW * 0.505)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_vest_gs.paa";
			action = "['onItemContainerClicked', 1, 77002] call WFCL_fnc_displayWarfareGearMenu";
			onMouseButtonDown = "['onItemContainerMouseClicked', 1, 70002, _this select 1] call WFCL_fnc_displayWarfareGearMenu";
			onMouseButtonDblClick = "['onItemContainerMouseDblClicked', 1] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Container', 77002, ((_this select 4) select 0) select 2, 1] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Backpack: WF_Gear_Control_Uniform {
			idc = 70003;

			x = "SafeZoneX + (SafeZoneW * 0.60)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_backpack_gs.paa";
			action = "['onItemContainerClicked', 2, 77003] call WFCL_fnc_displayWarfareGearMenu";
			onMouseButtonDown = "['onItemContainerMouseClicked', 2, 70003, _this select 1] call WFCL_fnc_displayWarfareGearMenu";
			onMouseButtonDblClick = "['onItemContainerMouseDblClicked', 2] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Container', 77003, ((_this select 4) select 0) select 2, 2] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Helm: WF_Gear_Control_Uniform {
			idc = 70004;

			x = "SafeZoneX + (SafeZoneW * 0.70)";
			w = "SafeZoneW * 0.07";
			h = "SafeZoneH * 0.09";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_helmet_gs.paa";
			action = "['onAccessoryClicked', 0, 70004, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_helmet_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'HeadAsset', 77004, ((_this select 4) select 0) select 2, [2,0]] call WFCL_fnc_displayWarfareGearMenu";
			onMouseButtonDown = "";
			onMouseButtonDblClick = "";
		};
		class WF_Gear_Control_Glasses: WF_Gear_Control_Helm {
			idc = 70005;

			x = "SafeZoneX + (SafeZoneW * 0.774)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_glasses_gs.paa";
			action = "['onAccessoryClicked', 1, 70005, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_glasses_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'HeadAsset', 77005, ((_this select 4) select 0) select 2, [2,1]] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_NVGoggles: WF_Gear_Control_Helm {
			idc = 70006;

			x = "SafeZoneX + (SafeZoneW * 0.847)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_nvg_gs.paa";
			action = "['onItemClicked', [0,0], 70006, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_nvg_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Item', 77006, ((_this select 4) select 0) select 2, [3,0,0]] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Binoculars: WF_Gear_Control_Helm {
			idc = 70007;

			x = "SafeZoneX + (SafeZoneW * 0.921)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_binocular_gs.paa";
			action = "['onItemClicked', [0,1], 70007, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_binocular_gs.paa', [3,1]] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Item', 77007, ((_this select 4) select 0) select 2, [3,0,1]] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Map: WF_Gear_Control_Uniform {
			idc = 70008;

			x = "SafeZoneX + (SafeZoneW * 0.70)";
			y = "SafeZoneY + (SafezoneH * 0.17)";
			w = "SafeZoneW * 0.056";
			h = "SafeZoneH * 0.07";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_map_gs.paa";
			action = "['onItemClicked', [1,0], 70008, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_map_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Item', 77008, ((_this select 4) select 0) select 2, [3,1,0]] call WFCL_fnc_displayWarfareGearMenu";
			onMouseButtonDown = "";
			onMouseButtonDblClick = "";
		};
		class WF_Gear_Control_GPS: WF_Gear_Control_Map {
			idc = 70009;

			x = "SafeZoneX + (SafeZoneW * 0.759)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_gps_gs.paa";
			action = "['onItemClicked', [1,1], 70009, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_gps_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Item', 77009, ((_this select 4) select 0) select 2, [3,1,1]] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Radio: WF_Gear_Control_Map {
			idc = 70010;

			x = "SafeZoneX + (SafeZoneW * 0.818)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_radio_gs.paa";
			action = "['onItemClicked', [1,2], 70010, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_radio_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Item', 77010, ((_this select 4) select 0) select 2, [3,1,2]] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Compass: WF_Gear_Control_Map {
			idc = 70011;

			x = "SafeZoneX + (SafeZoneW * 0.877)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_compass_gs.paa";
			action = "['onItemClicked', [1,3], 70011, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_compass_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Item', 77011, ((_this select 4) select 0) select 2, [3,1,3]] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Clock: WF_Gear_Control_Map {
			idc = 70012;

			x = "SafeZoneX + (SafeZoneW * 0.936)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_watch_gs.paa";
			action = "['onItemClicked', [1,4], 70012, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_watch_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Item', 77012, ((_this select 4) select 0) select 2, [3,1,4]] call WFCL_fnc_displayWarfareGearMenu";
		};

		class WF_Gear_Control_Primary: WF_Gear_Control_Uniform {
			idc = 70013;

			x = "SafeZoneX + (SafeZoneW * 0.71)";
			y = "SafeZoneY + (SafezoneH * 0.25)";

			w = "SafeZoneW * 0.28";
			h = "SafeZoneH * 0.09";
			colorDisabled[] = {1,1,1,0.3};

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_primary_gs.paa";
			action = "['onWeaponClicked', 0] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Weapon', 77013, ((_this select 4) select 0) select 2, 0] call WFCL_fnc_displayWarfareGearMenu";
			onMouseButtonDown = "";
			onMouseButtonDblClick = "";
		};
		class WF_Gear_Control_Primary_Muzzle: WF_Gear_Control_Map { // wasp
			idc = 70014;

			x = "SafeZoneX + (SafeZoneW * 0.70)";
			y = "SafeZoneY + (SafezoneH * 0.345)";
			w = "SafeZoneW * 0.044";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_muzzle_gs.paa";
			action = "['onWeaponAccessoryClicked', 0, 0, 70014, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_muzzle_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Accessory', 77014, ((_this select 4) select 0) select 2, [0,0,1,0]] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Primary_Side: WF_Gear_Control_Primary_Muzzle {
			idc = 70015;

			x = "SafeZoneX + (SafeZoneW * 0.7465)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_side_gs.paa";
			action = "['onWeaponAccessoryClicked', 0, 1, 70015, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_side_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Accessory', 77015, ((_this select 4) select 0) select 2, [0,0,1,1]] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Primary_Optics: WF_Gear_Control_Primary_Muzzle {
			idc = 70016;

			x = "SafeZoneX + (SafeZoneW * 0.793)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_top_gs.paa";
			action = "['onWeaponAccessoryClicked', 0, 2, 70016, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_top_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Accessory', 77016, ((_this select 4) select 0) select 2, [0,0,1,2]] call WFCL_fnc_displayWarfareGearMenu";
		};
        class WF_Gear_Control_Primary_Bipod: WF_Gear_Control_Primary_Muzzle {
			idc = 70017;

			x = "SafeZoneX + (SafeZoneW * 0.8395)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_bipod_gs.paa";
			action = "['onWeaponAccessoryClicked', 0, 3, 70017, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_bipod_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Accessory', 77017, ((_this select 4) select 0) select 2, [0,0,1,3]] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Primary_CurrentMagazine: WF_Gear_Control_Primary_Muzzle {
			idc = 70901;

			x = "SafeZoneX + (SafeZoneW * 0.886)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_magazine_gs.paa";
			action = "['onWeaponCurrentMagazineClicked', 0, 70901] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'CurrentMagazine', 77901, ((_this select 4) select 0) select 2, 0] call WFCL_fnc_displayWarfareGearMenu";
		};

		class WF_Gear_Control_Primary_CurrentGP: WF_Gear_Control_Primary_Muzzle {
            idc = 70992;

            x = "SafeZoneX + (SafeZoneW * 0.933)";
            w = "SafeZoneW * 0.056";

            text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_magazine_gs.paa";
            action = "['onWeaponCurrentGrenadeClicked', 0, 70992] call WFCL_fnc_displayWarfareGearMenu";
            onLBDrop = "['onShoppingListLBDrop', 'CurrentGP', 77992, ((_this select 4) select 0) select 2, 0] call WFCL_fnc_displayWarfareGearMenu";
        };

		class WF_Gear_Control_Secondary: WF_Gear_Control_Primary {
			idc = 70018;

			x = "SafeZoneX + (SafeZoneW * 0.71)";
			y = "SafeZoneY + (SafezoneH * 0.42)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_secondary_gs.paa";
			action = "['onWeaponClicked', 1] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Weapon', 77018, ((_this select 4) select 0) select 2, 1] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Secondary_Muzzle: WF_Gear_Control_Map {
			idc = 70019;

			x = "SafeZoneX + (SafeZoneW * 0.705)";
			y = "SafeZoneY + (SafezoneH * 0.52)";
			w = "SafeZoneW * 0.06775";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_muzzle_gs.paa";
			action = "['onWeaponAccessoryClicked', 1, 0, 70019, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_muzzle_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Accessory', 77019, ((_this select 4) select 0) select 2, [0,1,1,0]] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Secondary_Side: WF_Gear_Control_Secondary_Muzzle {
			idc = 70020;

			x = "SafeZoneX + (SafeZoneW * 0.775)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_side_gs.paa";
			action = "['onWeaponAccessoryClicked', 1, 1, 70020, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_side_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Accessory', 77020, ((_this select 4) select 0) select 2, [0,1,1,1]] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Secondary_Optics: WF_Gear_Control_Secondary_Muzzle {
			idc = 70021;

			x = "SafeZoneX + (SafeZoneW * 0.845)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_top_gs.paa";
			action = "['onWeaponAccessoryClicked', 1, 2, 70021, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_top_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Accessory', 77021, ((_this select 4) select 0) select 2, [0,1,1,2]] call WFCL_fnc_displayWarfareGearMenu";
		};
        class WF_Gear_Control_Secondary_Bipod: WF_Gear_Control_Secondary_Muzzle {
			idc = 70022;

			x = "SafeZoneX + (SafeZoneW * 0.845)+100";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_bipod_gs.paa";
			action = "['onWeaponAccessoryClicked', 1, 3, 70022, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_bipod_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Accessory', 77022, ((_this select 4) select 0) select 2, [0,1,1,3]] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Secondary_CurrentMagazine: WF_Gear_Control_Secondary_Muzzle {
			idc = 70902;

			x = "SafeZoneX + (SafeZoneW * 0.92)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_magazine_gs.paa";
			action = "['onWeaponCurrentMagazineClicked', 1, 70902] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'CurrentMagazine', 77902, ((_this select 4) select 0) select 2, 1] call WFCL_fnc_displayWarfareGearMenu";
		};

		class WF_Gear_Control_Pistol: WF_Gear_Control_Primary {
			idc = 70023;

			x = "SafeZoneX + (SafeZoneW * 0.70)";
			y = "SafeZoneY + (SafezoneH * 0.595)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_hgun_gs.paa";
			action = "['onWeaponClicked', 2] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Weapon', 77023, ((_this select 4) select 0) select 2, 2] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Pistol_Muzzle: WF_Gear_Control_Map {
			idc = 70024;

			x = "SafeZoneX + (SafeZoneW * 0.705)";
			y = "SafeZoneY + (SafezoneH * 0.695)";
			w = "SafeZoneW * 0.06775";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_muzzle_gs.paa";
			action = "['onWeaponAccessoryClicked', 2, 0, 70024, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_muzzle_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Accessory', 77024, ((_this select 4) select 0) select 2, [0,2,1,0]] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Pistol_Side: WF_Gear_Control_Pistol_Muzzle {
			idc = 70025;

			x = "SafeZoneX + (SafeZoneW * 0.775)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_side_gs.paa";
			action = "['onWeaponAccessoryClicked', 2, 1, 70025, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_side_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Accessory', 77025, ((_this select 4) select 0) select 2, [0,2,1,1]] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Pistol_Optics: WF_Gear_Control_Pistol_Muzzle {
			idc = 70026;

			x = "SafeZoneX + (SafeZoneW * 0.845)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_top_gs.paa";
			action = "['onWeaponAccessoryClicked', 2, 2, 70026, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_top_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Accessory', 77026, ((_this select 4) select 0) select 2, [0,2,1,2]] call WFCL_fnc_displayWarfareGearMenu";
		};
        class WF_Gear_Control_Pistol_Bipod: WF_Gear_Control_Pistol_Muzzle {
			idc = 70027;

			x = "SafeZoneX + (SafeZoneW * 0.845)+100";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_bipod_gs.paa";
			action = "['onWeaponAccessoryClicked', 2, 3, 70027, '\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_bipod_gs.paa'] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'Accessory', 77027, ((_this select 4) select 0) select 2, [0,2,1,3]] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Pistol_CurrentMagazine: WF_Gear_Control_Pistol_Muzzle {
			idc = 70903;

			x = "SafeZoneX + (SafeZoneW * 0.92)";

			text = "\A3\Ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_magazine_gs.paa";
			action = "['onWeaponCurrentMagazineClicked', 2, 70903] call WFCL_fnc_displayWarfareGearMenu";
			onLBDrop = "['onShoppingListLBDrop', 'CurrentMagazine', 77903, ((_this select 4) select 0) select 2, 2] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Combo_Target : RscComboGear {
			idc = 70201;

			x = "SafeZoneX + (SafeZoneW * 0.15)";
			y = "SafeZoneY + (SafezoneH * 0.18)";
			w = "SafeZoneW * 0.235";
			h = "SafeZoneH * 0.037";

			onLBSelChanged = "['onUnitLBSelChanged', _this select 1] call WFCL_fnc_displayWarfareGearMenu";
		};

		class WF_Gear_Uniform_Progress_Load : RscProgressGear {
			idc = 70301;

			style = 0;
			texture = "";
			textureExt = "";
			colorBar[] = {0.9,0.9,0.9,0.9};
			colorExtBar[] = {1,1,1,1};
			colorFrame[] = {1,1,1,1};

			x = "SafeZoneX + (SafeZoneW * 0.41)";
			y = "SafeZoneY + (SafezoneH * 0.183)";
			w = "SafeZoneW * 0.09";
			h = "SafeZoneH * 0.016";
		};
		class WF_Gear_Vest_Progress_Load : WF_Gear_Uniform_Progress_Load {
			idc = 70302;

			x = "SafeZoneX + (SafeZoneW * 0.505)";
		};
		class WF_Gear_Backpack_Progress_Load : WF_Gear_Uniform_Progress_Load {
			idc = 70303;

			x = "SafeZoneX + (SafeZoneW * 0.60)";
		};

		class WF_Icon_Primary : RscActiveTextGear {
			idc = 70501;
			style = ST_KEEP_ASPECT_RATIO;
			x = "SafeZoneX + (SafeZoneW * 0.028)";
			y = "SafeZoneY + (SafezoneH * 0.07)";
			w = "SafeZoneW * 0.043";
			h = "SafeZoneH * 0.08";

			color[] = {0.75,0.75,0.75,0.7};
			colorActive[] = {1,1,1,0.7};
			colorBackground[] = {0.6, 0.8392, 0.4706, 0.7};
			colorBackgroundSelected[] = {0.6, 0.8392, 0.4706, 0.7};
			colorFocused[] = {0.0, 0.0, 0.0, 0};
			colorDisabled[] = {1,1,1,0.3};

			text = "Rsc\Pictures\icon_wf_gear_primary.paa";
			action = "['onShoppingTabClicked', WF_GEAR_TAB_PRIMARY] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Icon_Secondary : WF_Icon_Primary {
			idc = 70502;
			x = "SafeZoneX + (SafeZoneW * 0.071)";

			text = "Rsc\Pictures\icon_wf_gear_secondary.paa";
			action = "['onShoppingTabClicked', WF_GEAR_TAB_SECONDARY] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Icon_Handgun : WF_Icon_Primary {
			idc = 70503;
			x = "SafeZoneX + (SafeZoneW * 0.114)";

			text = "Rsc\Pictures\icon_wf_gear_handgun.paa";
			action = "['onShoppingTabClicked', WF_GEAR_TAB_HANDGUN] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Icon_Accessories : WF_Icon_Primary {
			idc = 70504;
			x = "SafeZoneX + (SafeZoneW * 0.157)";

			text = "Rsc\Pictures\icon_wf_gear_accessories.paa";
			action = "['onShoppingTabClicked', WF_GEAR_TAB_ACCESSORIES] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Icon_Ammunitions : WF_Icon_Primary {
			idc = 70505;
			x = "SafeZoneX + (SafeZoneW * 0.2)";

			text = "Rsc\Pictures\icon_wf_gear_ammunition.paa";
			action = "['onShoppingTabClicked', WF_GEAR_TAB_AMMO] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Icon_Misc : WF_Icon_Primary {
			idc = 70506;
			x = "SafeZoneX + (SafeZoneW * 0.243)";

			text = "Rsc\Pictures\icon_wf_gear_miscellaneous.paa";
			action = "['onShoppingTabClicked', WF_GEAR_TAB_MISC] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Icon_Equipment : WF_Icon_Primary {
			idc = 70507;
			x = "SafeZoneX + (SafeZoneW * 0.286)";

			text = "Rsc\Pictures\icon_wf_gear_equipment.paa";
			action = "['onShoppingTabClicked', WF_GEAR_TAB_EQUIPMENT] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Icon_Template : WF_Icon_Primary {
			idc = 70508;
			x = "SafeZoneX + (SafeZoneW * 0.329)";

			text = "Rsc\Pictures\icon_wf_building_barracks.paa";
			action = "['onShoppingTabClicked', WF_GEAR_TAB_TEMPLATES] call WFCL_fnc_displayWarfareGearMenu";
		};

		class WF_TemplateNameCaption: RscText
		{
			idc = 1000;
			text = $STR_WF_GEAR_TemplateNameCaption;
			x = 0.699973 * safezoneW + safezoneX;
			y = 0.787129 * safezoneH + safezoneY;
			w = 0.0918513 * safezoneW;
			h = 0.032 * safezoneH;
		};
		class WF_TemplateName: RscEdit
		{
			idc = 1400;
			text = "";
			x = 0.799709 * safezoneW + safezoneX;
			y = 0.787129 * safezoneH + safezoneY;
			w = 0.190263 * safezoneW;
			h = 0.032 * safezoneH;

			maxChars = 25;
			colorDisabled[] = {1,1,1,0.3};
		};
		class WF_Gear_Control_CreateTemplate : RscButtonGear {
			idc = 70401;

			x = 0.699973 * safezoneW + safezoneX;
			y = 0.829908 * safezoneH + safezoneY;
			w = 0.289999 * safezoneW;
			h = 0.032 * safezoneH;

			text = $STR_WF_GEAR_TemplateSave;
			tooltip = "Create a template of the current gear setup";
			action = "['onTemplateCreation'] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_DeleteTemplate : WF_Gear_Control_CreateTemplate {
			idc = 70402;

			x = 0.699973 * safezoneW + safezoneX;
			y = 0.871915 * safezoneH + safezoneY;
			w = 0.289999 * safezoneW;
			h = 0.032 * safezoneH;

			text = $STR_WF_GEAR_TemplateDelete;
			tooltip = "Remove an existing template";
			action = "['onTemplateDeletion', lnbCurSelRow 70108] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Buy : WF_Gear_Control_CreateTemplate {
			idc = 70403;

			x = 0.699449 * safezoneW + safezoneX;
			y = 0.914481 * safezoneH + safezoneY;
			w = 0.289999 * safezoneW;
			h = 0.032 * safezoneH;

			text = $STR_WF_GEAR_Buy;
			tooltip = "Purchase the current gear setup";
			action = "['onPurchase'] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Menu_Control_Info : RscStructuredTextGear {
			idc = 70028;
			x = "SafeZoneX + (SafeZoneW * 0.41)";
			y = "SafeZoneY + (SafezoneH * 0.21)";
			w = "SafeZoneW * 0.28";
			h = "SafeZoneH * 0.03";

			size = "0.9 * (			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
		};
		class WF_Gear_Control_Clear : RscButton_LesserGear {
			idc = 70029;
			x = "SafeZoneX + (SafeZoneW * 0.01)";
			y = "SafeZoneY + (SafezoneH * 0.96)";
			w = "SafeZoneW * 0.185";
			h = "SafeZoneH * 0.04";

			text = $STR_WF_GEAR_Clear;
			tooltip = "Clear the gear of the existing target";
			action = "['onInventoryClear'] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Gear_Control_Reload : WF_Gear_Control_Clear {
			idc = 70030;
			x = "SafeZoneX + (SafeZoneW * 0.205)";

			text = $STR_WF_GEAR_Reload;
			tooltip = "Reload the last purchased gear for this target";
			action = "['onInventoryReload'] call WFCL_fnc_displayWarfareGearMenu";
		};
		class WF_Control_Exit : RscButton_Exit {
			idc = 22555;

			x = "SafeZoneX + (SafeZoneW * 0.95)";
			y = "SafeZoneY + (SafezoneH * 0.01)";
			w = "SafeZoneW * 0.04";
			h = "SafeZoneH * 0.04";

			text = "X";
			action = "closeDialog 0";
		};
		class WF_Control_DescriptionGroup : RscControlsGroupLinkedItems {
			class Controls{
				class WF_Control_Description : RscStructuredTextGear {				
					idc = 22556;

					x = 0;
					y = 0;
					w = 1;
					h = 1;

					colorBackground[] = {0, 0, 0, 0};
				};
			};
		};
	};
};