_display = _this select 0;

_enable = false;
_gear_field_range = missionNamespace getVariable "WF_C_UNITS_PURCHASE_GEAR_MOBILE_RANGE";
_gear_barrack_range = missionNamespace getVariable "WF_C_UNITS_PURCHASE_GEAR_RANGE";

ctrlEnable [2001, false];
ctrlEnable [2002, false];
ctrlEnable [2003, false];
ctrlEnable [2004, false];
ctrlEnable [2007, false];

if ((barracksInRange || lightInRange || heavyInRange || aircraftInRange || hangarInRange || depotInRange) && (player == leader WF_Client_Team)) then {_enable = true};
ctrlEnable [2002,_enable];
ctrlEnable [2004,commandInRange && (player == leader WF_Client_Team)]; //--- Special Menu

WF_MenuAction = -1;
WF_ForceUpdate = true;

_AllButtons = [2000, 2001, 2002, 2003, 2004, 2005, 2007, 2008, 2009, 2011, 2012, 2013, 2014];

(_display displayCtrl 2000) ctrlSetStructuredText (parseText ((localize 'STR_WF_MAIN_TeamMenu') + " <t color='#D3A119'>[M]</t>"));
(_display displayCtrl 2001) ctrlSetStructuredText (parseText ((localize 'STR_WF_MAIN_RoleSelector') + " <t color='#D3A119'>[R]</t>"));
(_display displayCtrl 2002) ctrlSetStructuredText (parseText ((localize 'STR_WF_MAIN_Purchase_Units') + " <t color='#D3A119'>[B]</t>"));
(_display displayCtrl 2003) ctrlSetStructuredText (parseText ((localize 'STR_WF_MAIN_Purchase_Gear') + " <t color='#D3A119'>[G]</t>"));
(_display displayCtrl 2004) ctrlSetStructuredText (parseText ((localize 'STR_WF_MAIN_TacticalMenu') + " <t color='#D3A119'>[T]</t>"));
(_display displayCtrl 2005) ctrlSetStructuredText (parseText ((localize 'STR_WF_SupportMenu') + " <t color='#D3A119'>[S]</t>"));
(_display displayCtrl 2007) ctrlSetStructuredText (parseText ((localize 'STR_WF_MAIN_UpgradeMenu') + " <t color='#D3A119'>[U]</t>"));
(_display displayCtrl 2008) ctrlSetStructuredText (parseText ((localize 'STR_WF_MAIN_VotingMenu') + " <t color='#D3A119'>[V]</t>"));
(_display displayCtrl 2009) ctrlSetStructuredText (parseText ((localize 'STR_WF_MAIN_EconomyMenu') + " <t color='#D3A119'>[E]</t>"));
(_display displayCtrl 2011) ctrlSetStructuredText (parseText ("<t size='1.5'><img image='\A3\ui_f\data\Map\VehicleIcons\iconVehicle_ca.paa' /></t> <t color='#D3A119'>[H]</t>"));
(_display displayCtrl 2012) ctrlSetStructuredText (parseText ("<t size='1.5'><img image='\A3\ui_f\data\GUI\Cfg\RespawnRoles\support_ca.paa' /></t> <t color='#D3A119'>[P]</t>"));
(_display displayCtrl 2013) ctrlSetStructuredText (parseText ("<t size='1.5'><img image='\A3\ui_f\data\GUI\Cfg\Cursors\rotate_gs.paa' /></t> <t color='#D3A119'>[Q]</t>"));
(_display displayCtrl 2014) ctrlSetStructuredText (parseText ("<t size='1.5'><img image='\A3\ui_f\data\GUI\Cfg\KeyframeAnimation\IconCamera_CA.paa' /></t> <t color='#D3A119'>[Z]</t>"));

{sleep 0.01; ctrlShow [_x, true]} forEach _AllButtons;

while {alive player && dialog} do {
	if (!dialog) exitWith {};

	//--- Build Units.
	_enable = false;
	if ((barracksInRange || lightInRange || heavyInRange || aircraftInRange || hangarInRange || depotInRange) && (player == leader WF_Client_Team)) then {_enable = true};
	ctrlEnable [2002,_enable];
	ctrlEnable [2003,gearInRange];
	ctrlEnable [2001,gearInRange || WF_FreeRolePurchase];

	_enable = false; //added-MrNiceGuy
	if (!isNull(commanderTeam)) then {if (commanderTeam == group player) then {_enable = true}};
	ctrlEnable [2004,commandInRange && (player == leader WF_Client_Team)]; //--- Special Menu
	ctrlEnable [2007,commandInRange]; //--- Upgrade Menu

	//--- Uptime.
	_uptime = Call WFCL_FNC_GetTime; //added-MrNiceGuy

	//--- Buy Units.
	if (WF_MenuAction == 1) exitWith {
		WF_MenuAction = -1;
		closeDialog 0;
		createDialog "RscMenu_BuyUnits";
	};

	//--- Buy Gear.
	if (WF_MenuAction == 2) exitWith {
		WF_MenuAction = -1;
		closeDialog 0;
		_closestShop = [vehicle player, _gear_field_range] Call WFCL_FNC_GetClosestCamp;
		if(isNull _closestShop) then {
		    _buildings = WF_Client_SideJoined call WFCO_FNC_GetSideStructures;
            _closestShop = ['BARRACKSTYPE', _buildings, _gear_barrack_range, WF_Client_SideJoined, player] call WFCO_FNC_BuildingInRange;
		};

        _items = [];
        _selectedRole = WF_gbl_boughtRoles select 0;
        _upgrades = (WF_Client_SideJoined) Call WFCO_FNC_GetSideUpgrades;
        _upgrade_gear = _upgrades select WF_UP_GEAR;

        _list = [];
        if(isNil '_selectedRole') then {
            _list = missionNamespace getVariable "wf_gear_list_primary";
            _list = _list + (missionNamespace getVariable "wf_gear_list_secondary");
            _list = _list + (missionNamespace getVariable "wf_gear_list_pistol");
            _list = _list + (missionNamespace getVariable "wf_gear_list_uniforms");
            _list = _list + (missionNamespace getVariable "wf_gear_list_backpacks");
            _list = _list + (missionNamespace getVariable "wf_gear_list_special");
            _list = _list + (missionNamespace getVariable "wf_gear_list_explosives");
            _list = _list + (missionNamespace getVariable "wf_gear_list_headgear");
            _list = _list + (missionNamespace getVariable "wf_gear_list_vests");
            _list = _list + (missionNamespace getVariable "wf_gear_list_glasses");
            _list = _list + (missionNamespace getVariable "wf_gear_list_misc");
            _list = _list + (missionNamespace getVariable "wf_gear_list_magazines");
            _list = _list + (missionNamespace getVariable "wf_gear_list_accessories");
        } else {
            _gearListPrimary = missionNamespace getVariable format["wf_gear_list_primary_%1", _selectedRole];
            if!(isNil '_gearListPrimary')then{
                _list = (missionNamespace getVariable "wf_gear_list_primary") + _gearListPrimary
            };

            _gear_list_secondary = missionNamespace getVariable format["wf_gear_list_secondary_%1", _selectedRole];
            if!(isNil '_gear_list_secondary')then{
                _list = _list + (missionNamespace getVariable "wf_gear_list_secondary") + _gear_list_secondary
            };

            _gear_list_pistol = missionNamespace getVariable format["wf_gear_list_pistol_%1", _selectedRole];
            if!(isNil '_gear_list_pistol')then{
                _list = _list + (missionNamespace getVariable "wf_gear_list_pistol") + _gear_list_pistol
            };

            _gear_list_uniforms = missionNamespace getVariable format["wf_gear_list_uniforms_%1", _selectedRole];
            if(!(isNil '_gear_list_uniforms'))then{
                _list = _list + (missionNamespace getVariable "wf_gear_list_uniforms") + _gear_list_uniforms
            };

            _gear_list_backpacks = missionNamespace getVariable format["wf_gear_list_backpacks_%1", _selectedRole];
            if(!(isNil '_gear_list_backpacks'))then{
                _list = _list + (missionNamespace getVariable "wf_gear_list_backpacks") + _gear_list_backpacks
            };

            _gear_list_special = missionNamespace getVariable format["wf_gear_list_special_%1", _selectedRole];
            if(!(isNil '_gear_list_special'))then{
                _list = _list + (missionNamespace getVariable "wf_gear_list_special") + _gear_list_special
            };

            _gear_list_explosives = missionNamespace getVariable format["wf_gear_list_explosives_%1", _selectedRole];
            if(!(isNil '_gear_list_explosives'))then{
                _list = _list + (missionNamespace getVariable "wf_gear_list_explosives") + _gear_list_explosives
            };

            _gear_list_headgear = missionNamespace getVariable format["wf_gear_list_headgear_%1", _selectedRole];
            if(!(isNil '_gear_list_headgear'))then{
                _list = _list + (missionNamespace getVariable "wf_gear_list_headgear") + _gear_list_headgear
            };

            _gear_list_vests = missionNamespace getVariable format["wf_gear_list_vests_%1", _selectedRole];
            if(!(isNil '_gear_list_vests'))then{
                _list = _list + (missionNamespace getVariable "wf_gear_list_vests") + _gear_list_vests
            };

            _gear_list_glasses = missionNamespace getVariable format["wf_gear_list_glasses_%1", _selectedRole];
            if(!(isNil '_gear_list_glasses'))then{
                _list = _list + (missionNamespace getVariable "wf_gear_list_glasses") + _gear_list_glasses
            };

            _gear_list_misc = missionNamespace getVariable format["wf_gear_list_misc_%1", _selectedRole];
            if(!(isNil '_gear_list_misc'))then{
                _list = _list + (missionNamespace getVariable "wf_gear_list_misc") + _gear_list_misc
            };

            _gear_list_magazines = missionNamespace getVariable format["wf_gear_list_magazines_%1", _selectedRole];
            if(!(isNil '_gear_list_magazines'))then{
                _list = _list + (missionNamespace getVariable "wf_gear_list_magazines") + _gear_list_magazines
            };

            _gear_list_accessories = missionNamespace getVariable format["wf_gear_list_accessories_%1", _selectedRole];
            if(!(isNil '_gear_list_accessories'))then{
                _list = _list + (missionNamespace getVariable "wf_gear_list_magazines") + _gear_list_accessories
            };
        };

        {
            _get = missionNamespace getVariable format["wf_%1", _x];
            if (((_get select 0) select 0) <= _upgrade_gear) then {
                _items pushBack _x;
                _items pushBack ((_get select 0) select 1);
                _items pushBack true
            }
        } forEach _list;

        [_closestShop, _items] call TER_fnc_addShopCargo;
		[_closestShop] call TER_fnc_callShop;
	};

	//--- Team Menu.
	if (WF_MenuAction == 3) exitWith {
		WF_MenuAction = -1;
		closeDialog 0;
		createDialog "RscMenu_Team";
	};

	//--- Role Menu.
    if (WF_MenuAction == 14) exitWith {
        WF_MenuAction = -1;
        closeDialog 0;
        createDialog "WF_roles_menu";
        waitUntil {sleep 0.1; !isNull (findDisplay 2800)};
        [] call WFCL_fnc_updateRolesMenu;
        _selectedRole = WF_gbl_boughtRoles select 0;
        if(isnil '_selectedRole')then{
            lbSetCurSel [2801, 0];
        } else {
            _roleList = [WF_Client_SideJoined] call WFCO_fnc_roleList;
            {
                if (_selectedRole == (_x # 0)) exitWith {
                    lbSetCurSel [2801, _forEachIndex];
                }
            } forEach _roleList
        };
    };

	//--- Voting Menu.
	if (WF_MenuAction == 4) exitWith {
		WF_MenuAction = -1;
		if(!isNull(commanderTeam))then{
			if(commanderTeam == group player)then{
				if((WF_Client_Logic getVariable "wf_votetime") <= 0)then{
					ctrlEnable [509101,true];
					closeDialog 0;
					createDialog "WF_Commander_VoteMenu";

				}else{
					ctrlEnable [509101,false];
				};
			}else{
				_skip = false;
				if ((WF_Client_Logic getVariable "wf_votetime") <= 0) then {_skip = true};
				if (!_skip) then {
					closeDialog 0;
					createDialog "WF_VoteMenu";
				};

				if !(_skip) exitWith {};
				[WF_Client_SideJoined, name player] remoteExecCall ["WFSE_fnc_RequestCommanderVote",2];
				voted = true;
				waitUntil {(WF_Client_Logic getVariable "wf_votetime") > 0 || !dialog || !alive player};
				if (!alive player || !dialog) exitWith {};
				closeDialog 0;
				createDialog "WF_VoteMenu";
			};
		}else{
			_skip = false;
			if ((WF_Client_Logic getVariable "wf_votetime") <= 0) then {_skip = true};
			if (!_skip) then {
				closeDialog 0;
				createDialog "WF_VoteMenu";
			};

			if !(_skip) exitWith {};
			[WF_Client_SideJoined, name player] remoteExecCall ["WFSE_fnc_RequestCommanderVote",2];
			voted = true;
			waitUntil {(WF_Client_Logic getVariable "wf_votetime") > 0 || !dialog || !alive player};
			if (!alive player || !dialog) exitWith {};
			closeDialog 0;
			createDialog "WF_VoteMenu";
		};
	};

	//--- Unflip Vehicle.
	if (WF_MenuAction == 10) then {
		WF_MenuAction = -1;
		
		_vehicle = vehicle player;
		
		if (player == _vehicle) then {
			_objects = player nearEntities[WF_C_CAR_MOTO_TANK_AIR_KINDS,10];
			if (count _objects > 0) then {
				{
					if (getPos _x select 2 > 3 && !surfaceIsWater (getPos _x)) then {
						[_x] Call WFCO_FNC_BrokeTerObjsAround;
						
						[_x, getPos _x, 15] Call WFCO_FNC_PlaceSafe;
					} else {
						[_x] Call WFCO_FNC_BrokeTerObjsAround;
						
						_x setPos [getPos _x select 0, getPos _x select 1, 0.5];
						_x setVelocity [0,0,-0.5];
					};
				} forEach _objects;
			};
		};
	};

	//--- Headbug Fix.
	if (WF_MenuAction == 11) then { //added-MrNiceGuy
		WF_MenuAction = -1;
		closeDialog 0;
		titleCut["","BLACK FADED",0];
		_pos = position player;
		_vehi = "C_Quadbike_01_F" createVehicle [0,0,0];
		player moveInCargo _vehi;
		deleteVehicle _vehi;
		player setPos _pos;
		titleCut["","BLACK IN",5];
	};

	//--- Display Parameters.
	if (WF_MenuAction == 12) exitWith {
		WF_MenuAction = -1;
		closeDialog 0;
		createDialog "RscDisplay_Parameters";
	};

	//--- Command Menu.
	if (WF_MenuAction == 5) exitWith {
		WF_MenuAction = -1;
		closeDialog 0;
		createDialog "RscMenu_Command";
	};

	//--- Tactical Menu.
	if (WF_MenuAction == 6) exitWith {
		WF_MenuAction = -1;
		closeDialog 0;
		createDialog "RscMenu_Tactical";
	};

	//--- Upgrade Menu.
	if (WF_MenuAction == 7) exitWith {
		WF_MenuAction = -1;
		closeDialog 0;
		createDialog "WF_UpgradeMenu";
	};

	//--- Economy Menu.
	if (WF_MenuAction == 8) exitWith {
		WF_MenuAction = -1;
		closeDialog 0;
		createDialog "RscMenu_Economy";
	};

	//--- Service Menu.
	if (WF_MenuAction == 9) exitWith {
		WF_MenuAction = -1;
		closeDialog 0;
		createDialog "RscMenu_Service";
	};

	//--- Help Menu
	if (WF_MenuAction == 13) exitWith {
		WF_MenuAction = -1;
		closeDialog 0;
		createDialog "RscMenu_Help";
	};

	if (WF_MenuAction == 17) then {
		WF_MenuAction = -1;
	    if ( zoomgps < 1 ) then { zoomgps = (zoomgps + 0.025)} else { zoomgps = 1};
	};
	if (WF_MenuAction == 18) then {
		WF_MenuAction = -1;
	    if ( zoomgps >= 0.025) then { zoomgps = (zoomgps - 0.025)} else { zoomgps = 0.025};
	};
	
	sleep 0.1;
};