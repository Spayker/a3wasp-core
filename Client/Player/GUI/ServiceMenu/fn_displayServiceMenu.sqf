WF_MenuAction = -1;

_vehi = [group player,false] Call WFCO_FNC_GetTeamVehicles;
_playerUav = getConnectedUAV player;
if!(isNull _playerUav) then { _vehi pushBack _playerUav };

if (!isNull(commanderTeam)) then {
    if (commanderTeam == Group player) then {
        _hcGroups = [WF_Client_SideJoined] call WFCO_FNC_getHighCommandGroups;
        if (count _hcGroups > 0) then {
            {
                _vehi = _vehi + ([_x, false] Call WFCO_FNC_GetTeamVehicles);
            } forEach _hcGroups;
        };
    };
};

_alives = (units group player) Call WFCO_FNC_GetLiveUnits;
if (!isNull(commanderTeam)) then {
    if (commanderTeam == Group player) then {
        _hcGroups = [WF_Client_SideJoined] call WFCO_FNC_getHighCommandGroups;
        if (count _hcGroups > 0) then {
            {
                _alives = _alives + ((units _x) Call WFCO_FNC_GetLiveUnits);
            } forEach _hcGroups;
        };

        _logik = (side player) Call WFCO_FNC_GetSideLogic;
        _areas = _logik getVariable "wf_basearea";
        {
            _areaPos = getPosATL _x;
            _alives = _alives + (_areaPos nearEntities [WF_STATIC_ARTILLERY, WF_C_BASE_AREA_RANGE])
        } forEach _areas;
    };
};
{if (vehicle _x == _x) then {_vehi pushBack _x}} forEach _alives;
_lastUse = 0;
_typeRepair = missionNamespace getVariable Format['WF_%1REPAIRTRUCKS',WF_Client_SideJoinedText];

_healPrice = 0;
_repairPrice = 0;
_refuelPrice = 0;
_rearmPrice = 0;
_lastVeh = objNull;
_lastDmg = 0;
_lastFue = 0;

_currentUpgrades = (WF_Client_SideJoined) Call WFCO_FNC_GetSideUpgrades;
_buildings = (WF_Client_SideJoined) Call WFCO_FNC_GetSideStructures;

//--- Service Point.
_csp = objNull;
_sp = [WF_Client_SideJoined, missionNamespace getVariable Format ["WF_%1SERVICEPOINTTYPE",WF_Client_SideJoinedText],_buildings] Call WFCO_FNC_GetFactories;
if (count _sp > 0) then {
	_csp = [vehicle player,_sp] Call WFCO_FNC_GetClosestEntity;
};

if ((missionNamespace getVariable "WF_C_MODULE_WF_EASA") > 0) then {
	_enable = false;
	_easaLevel = _currentUpgrades select WF_UP_EASA;
	if (!(isNull _csp) && _easaLevel > 0) then {
		if (player distance _csp < (missionNamespace getVariable "WF_C_UNITS_SUPPORT_RANGE")) then {
				if (((vehicle player isKindOf 'Air') && driver (vehicle player) == player)) then { _enable = true };
				if(!(_enable) && !isNull _playerUav) then { _enable = true }
		};
	};
	ctrlEnable [20010,_enable];
} else {
	ctrlEnable [20010,false];
};

_effective = [];
_nearSupport = [];
_spType = missionNamespace getVariable Format ["%1SP",WF_Client_SideJoinedText];
_i = 0;
{
	_closestSP = objNull;
	_add = false;

	_nearSupport set [_i, []];

	//--- Service Point.
	if (count _sp > 0) then {
		_closestSP = [_x,_sp] Call WFCO_FNC_GetClosestEntity;
		if !(isNull _closestSP) then {
			if (_x distance _closestSP < (missionNamespace getVariable "WF_C_UNITS_SUPPORT_RANGE")) then {
				_add = true;
				_nearSupport set [_i,(_nearSupport select _i) + [_closestSP]];
			};
		};
	};

	//--- Depots.
	_nObject = [_x, (missionNamespace getVariable "WF_C_UNITS_SUPPORT_RANGE")] Call WFCL_FNC_GetClosestDepot;

	if !(isNull _nObject) then {
		_add = true;
		_nearSupport set [_i,(_nearSupport select _i) + [_nObject]];
	};

	//--- Repairs Trucks.
	_checks = (getPos _x) nearEntities[_typeRepair, missionNamespace getVariable "WF_C_UNITS_REPAIR_TRUCK_RANGE"];
	if (count _checks > 0) then {
		_add = true;
		_nearSupport set [_i,(_nearSupport select _i) + _checks];
	};

	//--- Add the vehicle ?
	if (_add) then {
		_effective pushBack _x;
		_desc = [typeOf _x, 'displayName'] Call WFCO_FNC_GetConfigInfo;
		_finalNumber = (_x) Call WFCO_FNC_GetAIDigit;
		_isInVehicle = "";
		if (_x != vehicle _x) then {
			_descVehi = [typeOf (vehicle _x), 'displayName'] Call WFCO_FNC_GetConfigInfo;
			_isInVehicle = " [" + _descVehi + "] ";
		};

        private ["_healthIcon", "_ammo", "_ammoIcon", "_fuel", "_fuelIcon"];

        _health = str(round((1 - (damage _x)) * 100)) + "%";
        _healthIcon = "RSC\Pictures\health.paa";
        _ammo = str(_x ammo currentMuzzle (gunner _x));
        _ammoIcon = "RSC\Pictures\icon_wf_building_ammo.paa";
        _fuel = "";
        _fuelIcon = "";

		if!(_x isKindOf "Man") then {
		    _healthIcon = "\a3\ui_f\data\GUI\Cfg\GameTypes\defend_ca.paa";

		    if!(_x isKindOf "StaticWeapon") then {
		        _fuel = str(round(100 * fuel _x)) + "%";
                _fuelIcon = "\a3\ui_f\data\IGUI\Cfg\Actions\refuel_ca.paa";
            };
		};

		lnbAddRow [20002,[str(group _x),"[" + _finalNumber + "]",(_desc + _isInVehicle),
            "", _health, "", _ammo, "", _fuel]];
        lnbSetPicture [20002, [_i, 3], _healthIcon];
        lnbSetPicture [20002, [_i, 5], _ammoIcon];
        lnbSetPicture [20002, [_i, 7], _fuelIcon];

		_i = _i + 1;
	};
} forEach _vehi;

_checks = (getPos player) nearEntities[_typeRepair, missionNamespace getVariable "WF_C_UNITS_REPAIR_TRUCK_RANGE"];
if (count _checks > 0) then {
	_repair = _checks select 0;
	_vehi = ((getPos _repair) nearEntities[["Car","Motorcycle","Tank","Air","Ship","StaticWeapon"],100]) - [_repair];
	{
		if !(_x in _effective) then {
			_effective = _effective + [_x];
			_nearSupport set [_i,[_repair]];
			_descVehi = [typeOf (vehicle _x), 'displayName'] Call WFCO_FNC_GetConfigInfo;
			lbAdd[20002,_descVehi];

			_i = _i + 1;
		};
	} forEach _vehi;
};

if (count _effective > 0) then {lbSetCurSel[20002,0]};

_colorConfigs = [];

ctrlSetText [20016, localize 'STR_WF_SKIN'];

while {true} do {
	sleep 0.1;

	if (Side player != WF_Client_SideJoined) exitWith {closeDialog 0};
	if (!dialog) exitWith {};
	_curSel = lbCurSel(20002);

	//--Enable/Disable TANK MAGZ MENU--
    _tanksRearmEnabled = false;
    _currentLevelHeavyMagz = _currentUpgrades select WF_UP_HEAVY_MAGZ;
    if(_currentLevelHeavyMagz > 0 && (player distance _csp < (missionNamespace getVariable "WF_C_UNITS_SUPPORT_RANGE"))) then {
        if(driver (vehicle player) == player && (vehicle player isKindOf 'Tank' ||
            vehicle player isKindOf 'Wheeled_APC_F' || vehicle player isKindOf 'StaticWeapon')) then {
            _tanksRearmEnabled = true;
    	};
    };

	if (_curSel != -1) then {
		_veh = (vehicle (_effective select _curSel));
		_funds = Call WFCL_FNC_GetPlayerFunds;
		ctrlEnable [20003,false];
        ctrlEnable [20004,false];
        ctrlEnable [20005,false];
        ctrlEnable [20008,false];
        ctrlEnable [1608, false];
        ctrlEnable [1609, false];
        ctrlEnable [1610, false];
        ctrlEnable [1611, false];
        ctrlEnable [20018, false];

        //--- Depots.
        _nObject = [_veh, (missionNamespace getVariable "WF_C_UNITS_SUPPORT_RANGE")] Call WFCL_FNC_GetClosestDepot;

		if (_veh isKindOf "Man") then {
		    if (isNull _nObject) then {
			_enabled = if (_funds >= _healPrice) then {true} else {false};
			ctrlEnable [20008,_enabled];
			ctrlEnable [1611, _enabled];
		    } else {
		        _townServices = _nObject getVariable ["townServices", []];
		        _healServiceExists = false;
                if(WF_C_TOWNS_SERVICE_HEAL in _townServices) then { _healServiceExists = true };
                _enabled = if (_healServiceExists && _funds >= _healPrice) then {true} else {false};
                ctrlEnable [20008, _enabled];
                ctrlEnable [1611, _enabled]
		    };

			//--- Healing.
			_healPrice = round((getDammage _veh)*(missionNamespace getVariable "WF_C_UNITS_SUPPORT_HEAL_PRICE"));
			ctrlSetText [20011,"$0"];
			ctrlSetText [20012,"$0"];
			ctrlSetText [20013,"$0"];
			ctrlSetText [20014,"$"+str(_healPrice)];
		} else {
			//--- Prevent on the air re-supply.
			_canBeUsed = if ((getPos _veh) select 2 <= 2 && speed _veh <= 20) then {true} else {false};

            if (isNull _nObject) then {
			_enabled = if (_canBeUsed && _funds >= _rearmPrice) then {true} else {false};
			ctrlEnable [20003,_enabled];
                ctrlEnable [1608, _enabled];
                ctrlEnable [20018, _enabled && _tanksRearmEnabled];

			_enabled = if (_canBeUsed && _funds >= _repairPrice) then {true} else {false};
			ctrlEnable [20004,_enabled];
                ctrlEnable [1610, _enabled];

			_enabled = if (_canBeUsed && _funds >= _refuelPrice) then {true} else {false};
			ctrlEnable [20005,_enabled];
                ctrlEnable [1609, _enabled];

			_enabled = if (_canBeUsed && _funds >= _healPrice) then {true} else {false};
			ctrlEnable [20008,_enabled];
                ctrlEnable [1611, _enabled];
            } else {
                _townServices = _nObject getVariable ["townServices", []];
                if(count _townServices > 0) then {
                    _rearmServiceExists = false;
                    if(WF_C_TOWNS_SERVICE_REARM in _townServices) then { _rearmServiceExists = true };
                    _enabled = if (_canBeUsed && _rearmServiceExists && _funds >= _rearmPrice) then {true} else {false};
                    ctrlEnable [20003, _enabled];
                    ctrlEnable [1608, _enabled];
                    ctrlEnable [20018, if (_enabled && _tanksRearmEnabled) then {true} else {false}];

                    _repairServiceExists = false;
                    if(WF_C_TOWNS_SERVICE_REPAIRING in _townServices) then { _repairServiceExists = true };
                    _enabled = if (_canBeUsed && _repairServiceExists && _funds >= _repairPrice) then {true} else {false};
                    ctrlEnable [20004, _enabled];
                    ctrlEnable [1610, _enabled];

                    _fuelServiceExists = false;
                    if(WF_C_TOWNS_SERVICE_FUEL in _townServices) then { _fuelServiceExists = true };
                    _enabled = if (_canBeUsed && _fuelServiceExists && _funds >= _refuelPrice) then {true} else {false};
                    ctrlEnable [20005, _enabled];
                    ctrlEnable [1609, _enabled];

                    _healServiceExists = false;
                    if(WF_C_TOWNS_SERVICE_HEAL in _townServices) then { _healServiceExists = true };
                    _enabled = if (_canBeUsed && _healServiceExists && _funds >= _healPrice) then {true} else {false};
                    ctrlEnable [20008, _enabled];
                    ctrlEnable [1611, _enabled];
                }
            };
			//--- Healing.
			_healPrice = 0;
			{
				if (alive _x) then {_healPrice = _healPrice + round((getDammage _x)*(missionNamespace getVariable "WF_C_UNITS_SUPPORT_HEAL_PRICE"))};
			} forEach (crew _veh);
			ctrlSetText [20014,"$"+str(_healPrice)];
			//--- Repair.
			if (_veh != _lastVeh || getDammage _veh != _lastDmg) then {
				_type = typeOf _veh;

				_vehicle_hit_point_damage_array = getAllHitPointsDamage _veh;
				if(count _vehicle_hit_point_damage_array > 1) then {
					_array = _vehicle_hit_point_damage_array select 2;
					{_lastDmg = _lastDmg + _x} forEach _array;
					_lastDmg = _lastDmg / count (_array);
				};

				_get = missionNamespace getVariable _type;
				if !(isNil '_get') then {
					_repairPrice = round(_lastDmg*((_get select QUERYUNITPRICE)/(missionNamespace getVariable "WF_C_UNITS_SUPPORT_REPAIR_PRICE")));
				} else {
					_repairPrice = 500;
				};
			};
			ctrlSetText [20012,"$"+str(_repairPrice)];
			//--- Rearm.
			if (_veh != _lastVeh) then {
				_type = typeOf _veh;
				_get = missionNamespace getVariable _type;
				if !(isNil '_get') then {
					_rearmPrice = round((_get select QUERYUNITPRICE)/(missionNamespace getVariable "WF_C_UNITS_SUPPORT_REARM_PRICE"));
					//--If vehicle have EASA reload EASA magazines--
					if(!(isNil { _veh getVariable "_pylons" } )) then {
						if(count (_veh getVariable "_pylons") > 0) then {
							_rearmPrice = round(_rearmPrice + (_rearmPrice * (count (_veh getVariable "_pylons")) / 10));
						};
					};
				} else {
					_rearmPrice = 500;
				};
			};
			ctrlSetText [20011,"$"+str(_rearmPrice)];
			//--- Refuel.
			if (_veh != _lastVeh || fuel _veh != _lastFue) then {
				_type = typeOf _veh;
				_lastFue = fuel _veh;
				_get = missionNamespace getVariable _type;
				if !(isNil '_get') then {
					_fuel = ((fuel _veh) -1) * -1;
					_refuelPrice = round(_fuel*((_get select QUERYUNITPRICE)/(missionNamespace getVariable "WF_C_UNITS_SUPPORT_REFUEL_PRICE")));
				} else {
					_refuelPrice = 200;
				};
			};
			ctrlSetText [20013,"$"+str(_refuelPrice)];
		};

		_lastVeh = _veh;

		//--- Rearm.
		if (WF_MenuAction == 1) then {
			WF_MenuAction = -1;
			-_rearmPrice Call WFCL_FNC_ChangePlayerFunds;

			//--- Spawn a Rearm thread.
			[_veh,_nearSupport select _curSel,_typeRepair,_spType] Spawn WFCL_fnc_startRearm;
		};

		//--- Rearm ALL.
		if (WF_MenuAction == 88) then {
			WF_MenuAction = -1;

			_funds = Call WFCL_FNC_GetPlayerFunds;
			_fullPrice = 0;
			_lcurSp = (_nearSupport # _curSel ) # 0;

			{
				_lrearmPrice = 0;
				_lveh = _x;
				_type = typeOf _lveh;
				_get = missionNamespace getVariable _type;
				if !(isNil '_get') then {
					_lrearmPrice = round((_get select QUERYUNITPRICE)/(missionNamespace getVariable "WF_C_UNITS_SUPPORT_REARM_PRICE"));
					//--If vehicle have EASA reload EASA magazines--
					if(!(isNil { _lveh getVariable "_pylons" } )) then {
						if(count (_lveh getVariable "_pylons") > 0) then {
							_lrearmPrice = round(_lrearmPrice + (_lrearmPrice * (count (_lveh getVariable "_pylons")) / 10));
						};
					};
				} else {
					_lrearmPrice = 500;
				};

				if ((_lveh distance _lcurSp) < (missionNamespace getVariable "WF_C_UNITS_SUPPORT_RANGE")) then {
					_fullPrice = _fullPrice + _lrearmPrice;
				};
			} forEach _vehi;

			if(_funds < _fullPrice) then {
				[Format[localize 'STR_WF_INFO_Funds_Missing_Service', _fullPrice - _funds]] spawn WFCL_fnc_handleMessage;
			} else {
				-_fullPrice Call WFCL_FNC_ChangePlayerFunds;

				//--- Spawn a Rearm thread.
				{
					if ((_x distance ((_nearSupport # _curSel ) # 0)) < (missionNamespace getVariable "WF_C_UNITS_SUPPORT_RANGE") && !(_x isKindOf "Man")) then {
						[_x, _nearSupport select _curSel,_typeRepair,_spType] Spawn WFCL_fnc_startRearm;
						uiSleep 0.5;
					};
				} forEach _vehi;
			};
		};

		//--- Repair.
		if (WF_MenuAction == 2) then {
			WF_MenuAction = -1;
			-_repairPrice Call WFCL_FNC_ChangePlayerFunds;

			//--- Spawn a Repair thread.
			[_veh,_nearSupport select _curSel,_typeRepair,_spType] Spawn WFCL_fnc_startRepair;
		};

		//--- Repair ALL.
		if (WF_MenuAction == 90) then {
			WF_MenuAction = -1;

			_funds = Call WFCL_FNC_GetPlayerFunds;
			_fullPrice = 0;
			_lcurSp = (_nearSupport # _curSel ) # 0;

			{
				_lrepairPrice = 0;
				_lveh = _x;
				_type = typeOf _lveh;

				_lvehicle_hit_point_damage_array = getAllHitPointsDamage _lveh;
				if(count _lvehicle_hit_point_damage_array > 1) then {
					_larray = _lvehicle_hit_point_damage_array select 2;
					{_lastDmg = _lastDmg + _x} forEach _larray;
					_lastDmg = _lastDmg / count (_larray);
				};

				_get = missionNamespace getVariable _type;
				if !(isNil '_get') then {
					_lrepairPrice = round(_lastDmg*((_get select QUERYUNITPRICE)/(missionNamespace getVariable "WF_C_UNITS_SUPPORT_REPAIR_PRICE")));
				} else {
					_lrepairPrice = 500;
				};

				if ((_lveh distance _lcurSp) < (missionNamespace getVariable "WF_C_UNITS_SUPPORT_RANGE")) then {
					_fullPrice = _fullPrice + _lrepairPrice;
				};
			} forEach _vehi;

			if(_funds < _fullPrice) then {
				[Format[localize 'STR_WF_INFO_Funds_Missing_Service', _fullPrice - _funds]] spawn WFCL_fnc_handleMessage
			} else {
				-_fullPrice Call WFCL_FNC_ChangePlayerFunds;

				//--- Spawn a Repair thread.
				{
					if ((_x distance _lcurSp) < (missionNamespace getVariable "WF_C_UNITS_SUPPORT_RANGE") && !(_x isKindOf "Man")) then {
						[_x, _nearSupport select _curSel,_typeRepair,_spType] Spawn WFCL_fnc_startRepair;
						uiSleep 0.5;
					};
				} forEach _vehi;
			};
		};

		//--- Refuel.
		if (WF_MenuAction == 3) then {
			WF_MenuAction = -1;
			-_refuelPrice Call WFCL_FNC_ChangePlayerFunds;

			//--- Spawn a Refuel thread.
			[_veh,_nearSupport select _curSel,_typeRepair,_spType] Spawn WFCL_fnc_startRefuel;
		};

		//--- Refuel ALL.
		if (WF_MenuAction == 89) then {
			WF_MenuAction = -1;

			_funds = Call WFCL_FNC_GetPlayerFunds;
			_fullPrice = 0;
			_lcurSp = (_nearSupport # _curSel ) # 0;

			{
				_lrefuelPrice = 0;
				_lveh = _x;
				_type = typeOf _lveh;
				_lastFue = fuel _lveh;
				_get = missionNamespace getVariable _type;
				if !(isNil '_get') then {
					_fuel = ((fuel _lveh) -1) * -1;
					_lrefuelPrice = round(_fuel*((_get select QUERYUNITPRICE)/(missionNamespace getVariable "WF_C_UNITS_SUPPORT_REFUEL_PRICE")));
				} else {
					_lrefuelPrice = 200;
				};

				if ((_lveh distance _lcurSp) < (missionNamespace getVariable "WF_C_UNITS_SUPPORT_RANGE")) then {
					_fullPrice = _fullPrice + _lrefuelPrice;
				};
			} forEach _vehi;

			if(_funds < _fullPrice) then {
				[Format[localize 'STR_WF_INFO_Funds_Missing_Service', _fullPrice - _funds]] spawn WFCL_fnc_handleMessage
			} else {
				-_fullPrice Call WFCL_FNC_ChangePlayerFunds;

				//--- Spawn a Refuel thread.
				{
					if ((_x distance _lcurSp) < (missionNamespace getVariable "WF_C_UNITS_SUPPORT_RANGE") && !(_x isKindOf "Man")) then {
						[_x, _nearSupport select _curSel,_typeRepair,_spType] Spawn WFCL_fnc_startRefuel;
						uiSleep 0.5;
					};
				} forEach _vehi;
			};
		};

		//--- Heal.
		if (WF_MenuAction == 5) then {
			WF_MenuAction = -1;
			-_healPrice Call WFCL_FNC_ChangePlayerFunds;

			//--- Spawn a Healing thread.
			[_veh,_nearSupport select _curSel,_typeRepair,_spType] Spawn WFCL_fnc_startHeal;
		};

		//--- Heal ALL.
		if (WF_MenuAction == 91) then {
			WF_MenuAction = -1;

			_funds = Call WFCL_FNC_GetPlayerFunds;
			_fullPrice = 0;
			_lcurSp = (_nearSupport # _curSel ) # 0;

			{
				_lhealPrice = 0;
				_lveh = _x;
				if (_lveh isKindOf "Man") then {
					_lhealPrice = round((getDammage _lveh)*(missionNamespace getVariable "WF_C_UNITS_SUPPORT_HEAL_PRICE"));
				} else {
					{
						if (alive _x) then {_lhealPrice = _lhealPrice + round((getDammage _x)*(missionNamespace getVariable "WF_C_UNITS_SUPPORT_HEAL_PRICE"))};
					} forEach (crew _lveh);
				};

				if ((_lveh distance _lcurSp) < (missionNamespace getVariable "WF_C_UNITS_SUPPORT_RANGE")) then {
					_fullPrice = _fullPrice + _lhealPrice;
				};
			} forEach _vehi;

			if(_funds < _fullPrice) then {
				[Format[localize 'STR_WF_INFO_Funds_Missing_Service', _fullPrice - _funds]] spawn WFCL_fnc_handleMessage
			} else {
				-_fullPrice Call WFCL_FNC_ChangePlayerFunds;

				//--- Spawn a Refuel thread.
				{
					if ((_x distance _lcurSp) < (missionNamespace getVariable "WF_C_UNITS_SUPPORT_RANGE")) then {
						[_x, _nearSupport select _curSel,_typeRepair,_spType] Spawn WFCL_fnc_startHeal;
						uiSleep 0.5;
					};
				} forEach _vehi;
			};
		};

		//--- Texture.
		if (WF_MenuAction == 9) then {
			WF_MenuAction = -1;

			_colorTextures = [];

			if(count _colorConfigs > 0) then {
				_colorTextures pushback (getArray (configfile >> "CfgVehicles" >> typeof _veh >> "textureSources" >> configName (_colorConfigs select (lbCurSel 20015)) >> "textures"));

				if (WF_Debug) then {
					diag_log format["textures for source %1 : %2", _colorConfigs # (lbCurSel 20015), _colorTextures];
				};

				_txtIndex = 0;
				{
					_veh setObjectTextureGlobal [_txtIndex, _x];
					_txtIndex = _txtIndex + 1;
				}	forEach (_colorTextures select 0);
			};
		};

		//--- Unit select.
		if (WF_MenuAction == 10) then {
			WF_MenuAction = -1;

			//--Compute vehicle skins data--
			lbClear 20015;
			_colorConfigs = "true" configClasses (configfile >> "CfgVehicles" >> typeof _veh >> "textureSources");

			if (WF_Debug) then {
				diag_log format["textureSources for %1 : %2", typeOf _veh, _colorConfigs];
			};

			if (count _colorConfigs > 0) then {
				{
					lbAdd [20015,(getText (configfile >> "CfgVehicles" >> typeof _veh >> "textureSources" >> configName _x >> "displayName"))];
				} foreach _colorConfigs;
			};
		};
	} else {
		{ctrlEnable[_x,false]} forEach [20003,20004,20005,20008,20018];
	};

	//--- EASA. TBD: Add dialog;
	if (WF_MenuAction == 7) then {
		WF_MenuAction = -1;
		closeDialog 0;
		createDialog "RscMenu_EASA";
	};

	//--- TANK MAGZ. TBD: Add dialog;
	if (WF_MenuAction == 17) then {
		WF_MenuAction = -1;
		closeDialog 0;
		createDialog "RscMenu_TANK_MAGZ";
	};

	//--- Back Button.
	if (WF_MenuAction == 8) exitWith { //---added-MrNiceGuy
		WF_MenuAction = -1;
		closeDialog 0;
		createDialog "WF_Menu"
	};
};