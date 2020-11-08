_action = _this select 0;

switch (_action) do {
	case "onLoad": { //--- Triggered on the very first loading of the UI
		waitUntil {!isNull (findDisplay 503000)};
		//-- Load the list.
		call WFCL_fnc_loadAvailableUnits;
        [] spawn WFCL_fnc_displayGearMenu;
		//--- Handle drag stop
		_dragging = if (isNil{uiNamespace getVariable "wf_dialog_ui_gear_dragging"}) then {false} else {uiNamespace getVariable "wf_dialog_ui_gear_dragging"};
		
		if (_dragging) then {uiNamespace setVariable ["wf_dialog_ui_gear_dragging", false]};
		(findDisplay 503000) displaySetEventHandler ["mouseButtonUp", "_dragging = if (isNil{uiNamespace getVariable 'wf_dialog_ui_gear_dragging'}) then {false} else {uiNamespace getVariable 'wf_dialog_ui_gear_dragging'}; if (_dragging) then {['onShoppingListMouseUp', _this select 1] call WFCL_fnc_displayWarfareGearMenu"];
	};
	case "onShoppingTabClicked": { //--- A shopping tab was clicked upon
		//--- New tab		
		_changedto = _this select 1;
		
		(_changedto) call WFCL_fnc_displayShoppingItems;
		uiNamespace setVariable ["wf_dialog_ui_gear_shop_tab", _changedto];
	};
	case "onUnitLBSelChanged": { //--- The units combo was changed
		_changedto = _this select 1;

		_target = (uiNamespace getVariable "wf_dialog_ui_gear_units") select _changedto;
		//--- The target
		uiNamespace setVariable ["wf_dialog_ui_gear_target", _target];
		if (_target isKindOf "Man") then {
            //--- Get the target's equipment
            _gear = (_target) call WFCO_FNC_GetUnitLoadout;
            //--- Calculate the initial mass
            _mass = (_gear) call WFCL_fnc_getTotalMass;

            //--- Default
            uiNamespace setVariable ["wf_dialog_ui_gear_target_staticgear", +_gear];
            uiNamespace setVariable ["wf_dialog_ui_gear_target_gear", _gear];
            uiNamespace setVariable ["wf_dialog_ui_gear_target_gear_mass", _mass];

            //--- Progress UI Updates.
            {[_forEachIndex, _x] call WFCL_fnc_updateContainerProgress} forEach [70301,70302,70303];

		    //--- Do we have a default gear tab? if not we give the template one to the player
			if (isNil {uiNamespace getVariable "wf_dialog_ui_gear_shop_tab"}) then {uiNamespace setVariable ["wf_dialog_ui_gear_shop_tab", WF_GEAR_TAB_TEMPLATES]};
			(uiNamespace getVariable "wf_dialog_ui_gear_shop_tab") call WFCL_fnc_displayShoppingItems;

			call WFCL_fnc_updatePrice;
			(_gear) call WFCL_fnc_displayInventory;
		} else {
			_gear = weaponCargo _target + magazineCargo _target + itemCargo _target + backpackCargo _target;

			//--- Calculate the initial mass
			_maxmass = getNumber(configFile >> "CfgVehicles" >> typeOf _target >> "maximumLoad");
			_mass = (_gear) call WFCL_fnc_getVehicleLoad;

			//--- Update the overlay
			call WFCL_fnc_enableVehicleOverlay;
			((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70001) ctrlSetText getText(configFile >> "CfgVehicles" >> typeOf _target >> 'picture');
			((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70001) ctrlSetTooltip getText(configFile >> "CfgVehicles" >> typeOf _target>> 'displayName');
			
			//--- Default
			uiNamespace setVariable ["wf_dialog_ui_gear_target_staticgear", +_gear];
			uiNamespace setVariable ["wf_dialog_ui_gear_target_gear", _gear];
			uiNamespace setVariable ["wf_dialog_ui_gear_target_gear_mass", [_maxmass, _mass]];
			
			//--- Do we have a default gear tab? if not we give the template one to the player
			if (isNil {uiNamespace getVariable "wf_dialog_ui_gear_shop_tab"}) then {uiNamespace setVariable ["wf_dialog_ui_gear_shop_tab", WF_GEAR_TAB_PRIMARY]};
			(uiNamespace getVariable "wf_dialog_ui_gear_shop_tab") call WFCL_fnc_displayShoppingItems;
			
			//--- Progress UI Updates.
			call WFCL_fnc_updateVehicleContainerProgress;

			call WFCL_fnc_updatePrice;
			(_gear) call WFCL_fnc_displayInventoryVehicle;
		};
	};
	case "onShoppingListLBDblClick": {
		//--- Item
		_selected = _this select 1;		

		//--- Get the current tab
		if (uiNamespace getVariable "wf_dialog_ui_gear_shop_tab" != WF_GEAR_TAB_TEMPLATES) then {//--- Skip on template tab
			_updated = false;
			if (uiNamespace getVariable "wf_dialog_ui_gear_target" isKindOf "Man") then {
				_updated = (lnbData [70108, [_selected,0]]) call WFCL_fnc_addItem;
		} else {
				_updated = [uiNamespace getVariable "wf_dialog_ui_gear_target_gear", lnbData [70108, [_selected,0]]] call WFCL_fnc_addVehicleItem;
			};
			
			if (_updated) then { call WFCL_fnc_updatePrice };
		} else {
			if (uiNamespace getVariable "wf_dialog_ui_gear_target" isKindOf "Man") then {
				(_selected) call WFCL_fnc_equipTemplate;
			};
		};
	};
	case "onShoppingListLBDrag": {
		//--- Item (Data)
		_selected = ((_this select 1) select 0) select 2;

		if (uiNamespace getVariable "wf_dialog_ui_gear_shop_tab" != WF_GEAR_TAB_TEMPLATES) then { //--- Skip on template tab
			uiNamespace setVariable ["wf_dialog_ui_gear_dragging", true];
			(_selected) call WFCL_fnc_onShoppingItemDrag;
		};
	};
	case "onShoppingListLBDrop": {
		_kind = _this select 1;
		_idc = _this select 2;
		_dropped = _this select 3;
		_path = _this select 4;

		if (uiNamespace getVariable "wf_dialog_ui_gear_shop_tab" != WF_GEAR_TAB_TEMPLATES) then { //--- Skip on template tab
			_updated = [_idc, _dropped, _kind, _path] call WFCL_fnc_onShoppingItemDrop;
			if (_updated) then { call WFCL_fnc_updatePrice };
		};
	};
	case "onShoppingListLBSelChanged": {
		//--- Item
		_selected = _this select 1;
		
		(lnbData [70108, [_selected,0]]) call WFCL_fnc_updateLinkedItems;
	};
	case "onLinkedItemsLBSelChanged": {
		//--- Item
		_selected = _this select 1;
		
		_dspl = findDisplay 503000;	
		_dsplCtrl = _dspl displayCtrl 22556;
		
		_info = "";
		_config_type = [(lnbData [70601, [_selected,0]])] call WFCO_FNC_GetConfigType;
		_info = [(lnbData [70601, [_selected,0]]), "descriptionShort", _config_type] Call WFCO_FNC_GetConfigInfo;
		
		_dsplCtrl ctrlSetStructuredText parseText _info;
	};	
	case "onShoppingListMouseUp": {
		{
			((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _x) ctrlSetBackgroundColor [1, 1, 1, 0.15];
		} forEach (uiNamespace getVariable ["wf_dialog_ui_gear_drag_colored_idc", []]);
		
		{
			((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _x) ctrlSetBackgroundColor [1, 1, 1, 0.15];
		} forEach (uiNamespace getVariable ["wf_dialog_ui_gear_drag_colored_idc_red", []]);

		//--- Todo: highlight current container.
		((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl (77001 + (uiNamespace getVariable "wf_dialog_ui_gear_items_tab"))) ctrlSetBackgroundColor [1, 1, 1, 0.4];

		uiNamespace setVariable ["wf_dialog_ui_gear_dragging", false];
	};
	case "onLinkedListLBDblClick": {
		//--- Item
		_selected = _this select 1;
		_updated = false;
		
		if (uiNamespace getVariable "wf_dialog_ui_gear_target" isKindOf "Man") then {
			_updated = (lnbData [70601, [_selected,0]]) call WFCL_fnc_addItem;
		} else {
			_updated = [uiNamespace getVariable "wf_dialog_ui_gear_target_gear", lnbData [70601, [_selected,0]]] call WFCL_fnc_addVehicleItem;
		};

		if (_updated) then { call WFCL_fnc_updatePrice };
	};
	case "onItemContainerClicked": { //--- Uniform (0), vest (1) or backpack (2) container was clicked upon
		//--- The container
		_container = _this select 1;
		_background = _this select 2;

		//--- Get the target's gear
		_gear = uiNamespace getVariable "wf_dialog_ui_gear_target_gear";

		if (uiNamespace getVariable "wf_dialog_ui_gear_target" isKindOf "Man") then {
		//--- Make sure that the container is present.
		if ((((_gear select 1) select _container) select 0) != "") then {
				(((_gear select 1) select _container) select 1) call WFCL_fnc_displayContainerItems;

			//--- Change the color
				((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _background) ctrlSetBackgroundColor [1, 1, 1, 0.4];
				{((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _x) ctrlSetBackgroundColor [1, 1, 1, 0.15]} forEach ([77001,77002,77003] - [_background]);

			//--- Set the current items tab
				uiNamespace setVariable ["wf_dialog_ui_gear_items_tab", _container];
			};
		};
	};
	case "onItemContainerMouseClicked": { //--- Uniform (0), vest (1) or backpack (2) container was clicked upon
		//--- The container
		_container = _this select 1;
		_idc = _this select 2;
		_mouse = _this select 3;

		//--- Remove the container & its content if needed
		if (_mouse isEqualTo 1 && uiNamespace getVariable "wf_dialog_ui_gear_target" isKindOf "Man") then { //--- Right click
			_updated = ["", _container] call WFCL_fnc_replaceContainer;
			if (_updated) then { call WFCL_fnc_updatePrice };
		};
	};
	case "onAccessoryClicked": { //--- Helm or Goggles were clicked upon
		//--- The array slot, idc and default picture
		_slot = _this select 1;
		_idc = _this select 2;
		_default = _this select 3;

		_gear = uiNamespace getVariable "wf_dialog_ui_gear_target_gear";

		if (!((_gear select 2) select _slot isEqualTo "") && uiNamespace getVariable "wf_dialog_ui_gear_target" isKindOf "Man") then {
			//--- Apply the default picture and release the tooltip
			((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) ctrlSetText _default;
			((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) ctrlSetTooltip "";

			(_gear select 2) set [_slot, ""];
			call WFCL_fnc_updatePrice;
		};
	};
	case "onItemClicked": { //--- NVG, Binocular or items were clicked upon
		//--- The array slot, idc and default picture
		_slot = _this select 1;
		_idc = _this select 2;
		_default = _this select 3;

		_gear = uiNamespace getVariable "wf_dialog_ui_gear_target_gear";

		if (!((((_gear select 3) select (_slot select 0)) select (_slot select 1)) isEqualTo "") && uiNamespace getVariable "wf_dialog_ui_gear_target" isKindOf "Man") then {
			((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) ctrlSetText _default;
			((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) ctrlSetTooltip "";

			((_gear select 3) select (_slot select 0)) set [(_slot select 1), ""];
			call WFCL_fnc_updatePrice;
		};
	};
	case "onWeaponClicked": { //--- Primary, Secondary or Handgun was clicked upon
		//--- The array slot, idc and default picture
		_slot = _this select 1;
		_idc = _this select 2;

		if (uiNamespace getVariable "wf_dialog_ui_gear_target" isKindOf "Man") then {
			["", _slot] call WFCL_fnc_replaceWeapon;
			call WFCL_fnc_updatePrice;
		};
	};
	case "onUnitItemsLBDblClick": { //--- Item container
		_row = _this select 1;

		_item = lnbData[70109, [_row,0]];
		_count = lnbValue[70109, [_row,0]];

		_gear = uiNamespace getVariable "wf_dialog_ui_gear_target_gear";

		if (uiNamespace getVariable ["wf_dialog_ui_gear_target", objNull] isKindOf "Man") then {
			_container = uiNamespace getVariable "wf_dialog_ui_gear_items_tab";
		_items = ((_gear select 1) select _container) select 1;

			_items deleteAt (_items find _item);
			(_gear select 1) select (uiNamespace getVariable "wf_dialog_ui_gear_items_tab") set [1, _items];

			//--- Update the mass.
			["ContainerItem", _item, "", [_container]] call WFCL_fnc_updateMass;

			//--- Update the Mass RscProgress
			[_container, 70301+_container] call WFCL_fnc_updateContainerProgress;
		} else {
			_gear deleteAt (_gear find _item);

		    //--- Update the mass.
			[_item, "delete"] call WFCL_fnc_updateVehicleLoad;

		    //--- Update the Mass RscProgress
			call WFCL_fnc_updateVehicleContainerProgress;
		};

		if (_count > 1) then { //--- Decrement
			lnbSetText[70109, [_row,0], Format["x%1",_count - 1]];
			lnbSetValue[70109, [_row,0], _count - 1];
		} else { //--- Remove
			lnbDeleteRow[70109, _row];
		};

		call WFCL_fnc_updatePrice;
	};

	case 'onWeaponAccessoryClicked': { //--- Primary, Secondary or Handgun accessory was clicked upon
		//--- The array slot, idc and default picture
		_slot_type = _this select 1;
		_slot = _this select 2;
		_idc = _this select 3;
		_default = _this select 4;

		_gear = uiNamespace getVariable "wf_dialog_ui_gear_target_gear";
		if (uiNamespace getVariable "wf_dialog_ui_gear_target" isKindOf "Man") then {
		if (count(((_gear select 0) select _slot_type) select 1) > 0) then {
			if (((((_gear select 0) select _slot_type) select 1) select _slot) != "") then {
					((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) ctrlSetText _default;
					((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl _idc) ctrlSetTooltip "";

				(((_gear select 0) select _slot_type) select 1) set [_slot, ""];
					call WFCL_fnc_updatePrice;
				};
			};
		};
	};

	case "onWeaponCurrentMagazineClicked": { //--- Primary, Secondary or Handgun current magazine was clicked upon
		_slot_type = _this select 1;
		_idc = _this select 2;

		if (uiNamespace getVariable "wf_dialog_ui_gear_target" isKindOf "Man") then {
			_updated = ["", _slot_type, _idc] call WFCL_fnc_changeCurrentMagazine;
			if (_updated) then {call WFCL_fnc_updatePrice};
		};
	};

	case "onWeaponCurrentGrenadeClicked": { //--- Primary, Secondary or Handgun current magazine was clicked upon
        _slot_type = _this select 1;
        _idc = _this select 2;

        if (uiNamespace getVariable "wf_dialog_ui_gear_target" isKindOf "Man") then {
            _updated = ["", _slot_type, _idc] call WFCL_fnc_changeCurrentGrenade;
            if (_updated) then {call WFCL_fnc_updatePrice};
        };
    };

	case "onPurchase": {
		_funds = Call WFCL_FNC_GetPlayerFunds;
		_cost = uiNamespace getVariable "wf_dialog_ui_gear_tradein";
		if (_funds >= _cost) then {
			if (uiNamespace getVariable "wf_dialog_ui_gear_target" isKindOf "Man") then {

				[uiNamespace getVariable "wf_dialog_ui_gear_target", uiNamespace getVariable "wf_dialog_ui_gear_target_gear"] call WFCO_FNC_EquipUnit;

				missionNamespace setVariable ["wf_gear_lastpurchased", uiNamespace getVariable "wf_dialog_ui_gear_target_gear"];
				WF_P_CurrentGear = (player) call WFCO_FNC_GetUnitLoadout;
			} else {
				[uiNamespace getVariable "wf_dialog_ui_gear_target", uiNamespace getVariable "wf_dialog_ui_gear_target_gear"] call WFCL_FNC_EquipVehicleCargo;
			};
			uiNamespace setVariable ["wf_dialog_ui_gear_target_staticgear", +(uiNamespace getVariable "wf_dialog_ui_gear_target_gear")];

			call WFCL_fnc_updatePrice;
			-(_cost) Call WFCL_FNC_ChangePlayerFunds
		} else {
			["not enough funds"] spawn WFCL_fnc_handleMessage
		};
	};

	case "onInventoryClear": {
		if (uiNamespace getVariable "wf_dialog_ui_gear_target" isKindOf "Man") then {
		_gear = [
			[["", ["","","",""], []], ["", ["","","",""], []], ["", ["","","",""], []]],
			[["", []], ["", []], ["", []]],
			["", ""],
			[["", ["",""]], ["", "", "", "", ""]]
		];
			uiNamespace setVariable ["wf_dialog_ui_gear_target_gear", _gear];

			_mass = (_gear) call WFCL_fnc_getTotalMass;
			uiNamespace setVariable ["wf_dialog_ui_gear_target_gear_mass", _mass];

			{[_forEachIndex, _x] call WFCL_fnc_updateContainerProgress} forEach [70301,70302,70303];
			
			call WFCL_fnc_updatePrice;
			(_gear) call WFCL_fnc_displayInventory;
		} else {
			_gear = [];
			uiNamespace setVariable ["wf_dialog_ui_gear_target_gear", _gear];
			(uiNamespace getVariable ["wf_dialog_ui_gear_target_gear_mass", [0, 0]]) set [1, 0];
			
			//--- Progress UI Updates.
			call WFCL_fnc_updateVehicleContainerProgress;

			call WFCL_fnc_updatePrice;
			(_gear) call WFCL_fnc_displayInventoryVehicle;
		};
	};

	case "onInventoryReload": {
		_gear = missionNamespace getVariable "wf_gear_lastpurchased";
		if (!isNil '_gear' && uiNamespace getVariable "wf_dialog_ui_gear_target" isKindOf "Man") then {
			uiNamespace setVariable ["wf_dialog_ui_gear_target_gear", _gear];

			_mass = (_gear) call WFCL_fnc_getTotalMass;
			uiNamespace setVariable ["wf_dialog_ui_gear_target_gear_mass", _mass];

			{[_forEachIndex, _x] call WFCL_fnc_updateContainerProgress} forEach [70301,70302,70303];

			call WFCL_fnc_updatePrice;
			(_gear) call WFCL_fnc_displayInventory;
		};
		//todo reload from config if nil
	};

	case "onTemplateCreation": {
		_templateName = ctrlText 1400;
		if(_templateName == "") then {
			[format["%1", localize "STR_WF_GEARTEMPLATE_NAME_ERROR"]] spawn WFCL_fnc_handleMessage
		} else {
			_selectedRole = WF_gbl_boughtRoles select 0;
			if(isNil "_selectedRole") then { _selectedRole = "" };
				
			if(count (missionNamespace getVariable [format["wf_player_gearTemplates_%1", _selectedRole], []]) < WF_C_PLAYERS_GEAR_TEMPLATES_COUNT) then {
				_gear = uiNamespace getVariable "wf_dialog_ui_gear_target_gear";
				[_gear, _templateName, _selectedRole] spawn WFCL_FNC_SaveGearTemplate;				
				WF_GEAR_TAB_HANDGUN call WFCL_fnc_displayShoppingItems;
				uiNamespace setVariable ["wf_dialog_ui_gear_shop_tab", WF_GEAR_TAB_HANDGUN];
			} else {
				[format[localize "STR_WF_GEARTEMPLATE_LIMIT_ERROR", WF_C_PLAYERS_GEAR_TEMPLATES_COUNT]] spawn WFCL_fnc_handleMessage
			};
		};
	};

	case "onTemplateDeletion": {
		_index = _this select 1;
		if (uiNamespace getVariable "wf_dialog_ui_gear_shop_tab" == WF_GEAR_TAB_TEMPLATES) then {
			//_seed = lnbValue[70108, [_index,0]];
			if (_index > -1 && _index < ((lnbSize((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70108)) select 0)) then {

                _selectedRole = WF_gbl_boughtRoles # 0;
				if(isNil "_selectedRole") then {
				    _selectedRole = "";
				};
				
				_templateDbId = ((missionNamespace getVariable [format["wf_player_gearTemplates_%1", _selectedRole], ["",[],0]]) # _index) # 2;
				
				_templateDbId spawn WFCL_FNC_DeleteGearTemplate;
				
				(WF_GEAR_TAB_HANDGUN) call WFCL_fnc_displayShoppingItems;
				uiNamespace setVariable ["wf_dialog_ui_gear_shop_tab", WF_GEAR_TAB_HANDGUN];
			};
		} else {
		    [format["%1", "<t size='1.3' color='#2394ef'>Information</t><br /><br /><t align='left'>Templates may only be removed from the <t color='#eaff96'>Template</t> tab</t><br /><br /><img image='Rsc\Pictures\icon_wf_building_barracks.paa' size='2.5'/>"]] spawn WFCL_fnc_handleMessage
		};
	};

	case "onItemContainerMouseDblClicked": {
		_container = _this select 1;

		if (uiNamespace getVariable "wf_dialog_ui_gear_target" isKindOf "Man") then {
			_gear = uiNamespace getVariable "wf_dialog_ui_gear_target_gear";
		_container_type = ((_gear select 1) select _container) select 0;

		if (_container_type != "") then {
				if (uiNamespace getVariable "wf_dialog_ui_gear_items_tab" == _container) then {lnbClear 70109};

				["Container", "", _container_type, [_container, ((_gear select 1) select _container) select 1]] call WFCL_fnc_updateMass;
			((_gear select 1) select _container) set [1, []];
				[_container, 70301+_container] call WFCL_fnc_updateContainerProgress;

				call WFCL_fnc_updatePrice;
			};
		};
	};
};