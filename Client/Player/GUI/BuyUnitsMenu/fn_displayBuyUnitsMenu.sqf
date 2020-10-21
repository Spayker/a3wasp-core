disableSerialization;

//--- Init.
WF_MenuAction = -1;

_listUnits = [];

_closest = objNull;
_commander = false;
_extracrew = false;
_countAlive = 0;
_currentCost = 0;
_currentIDC = 0;
_disabledColor = [0.7961, 0.8000, 0.7961, 1];
_display = _this select 0;
_driver = false;
_enabledColor = [0, 1, 0, 1];
_enabledColor2 = [1, 0, 0, 1]; //---NEW (LOCK)
_gunner = false;
_IDCLock = 12023;
_IDCS = [12005,12006,12007,12008,12020,12021,12025,120255];
_IDCSVehi = [12012,12013,12014,12041];
_isInfantry = false;
_isLocked = true;
_lastCheck = 0;
_lastSel = -1;
_lastType = 'nil';
_listBox = 12001;
_comboFaction = 12026;
_comboGroups  = 920266;
_map = _display displayCtrl 12015;
_sorted = [];
_type = 'nil';
_update = true;
_updateDetails = true;
_updateList = true;
_updateMap = true;
_val = 0;
_mbu = missionNamespace getVariable 'WF_C_PLAYERS_AI_MAX';
_selectedRole = WF_gbl_boughtRoles select 0;

ctrlSetText[12025,localize 'STR_WF_UNITS_FactionChoiceLabel' + ":"];
ctrlSetText[120255,localize 'STR_WF_UNITS_PurchaseTypeChoiceLabel' + ":"];

//--- Get the closest Factory Type in range.
_break = false;
_status = [barracksInRange,lightInRange,heavyInRange,aircraftInRange,depotInRange,hangarInRange];
_statusLabel = ['Barracks','Light','Heavy','Aircraft','Depot','Airport'];
_statusVals = [0,1,2,3,4,3,0];
for [{_i = 0},{(_i < 6) && !_break},{_i = _i + 1}] do {
	if (_status select _i) then {
		_break = true;
		_currentIDC = _IDCS select _i;
		_type = _statusLabel select _i;
		_val = _statusVals select _i;
	};
};

if (_type == 'nil') exitWith {closeDialog 0};

//--- Destroy local variables.
_break = nil;
_status = nil;
_statusLabel = nil;
_statusVals = nil;

//--- Enable the current IDC.
_IDCS = _IDCS - [_currentIDC];
{
	_con = _display DisplayCtrl _x;
	_con ctrlSetTextColor [0.4, 0.4, 0.4, 1];
} forEach _IDCS;

//--- Loop.
while {alive player && dialog} do {
	//--- Nothing in range? exit!.
	if (!barracksInRange && !lightInRange && !heavyInRange && !aircraftInRange && !hangarInRange && !depotInRange) exitWith {closeDialog 0};
	if (side player != WF_Client_SideJoined || !dialog) exitWith {closeDialog 0};
	
	//--- Purchase.
	if (WF_MenuAction == 1) then {
		WF_MenuAction = -1;
		if (lbCurSel _comboGroups == 0) then {
		    _currentRow = lnbCurSelRow _listBox;
            _currentValue = lnbValue[_listBox,[_currentRow,0]];
            _unit = _listUnits select _currentValue;
            _currentUnit = missionNamespace getVariable _unit;
            _currentCost = _currentUnit # QUERYUNITPRICE;
            _capturedMilitaryBases = [WF_Client_SideJoined, WF_C_MILITARY_BASE, false] call WFCO_fnc_getSpecialLocations;
            if(_capturedMilitaryBases > 0) then {
                _currentCost = ceil (_currentCost - (WF_C_MILITARY_BASE_DISCOUNT_PERCENT * _capturedMilitaryBases * _currentCost));
            };
            _cpt = 1;
            _isInfantry = (_unit isKindOf 'Man');
            if !(_isInfantry) then {
                _extra = 0;
                if (_driver) then {_extra = _extra + 1};
                if (_gunner) then {_extra = _extra + 1};
                if (_commander) then {_extra = _extra + 1};
                if (_extracrew) then {_extra = _extra + ((_currentUnit select QUERYUNITCREW) select 3)};
                _currentCost = _currentCost + ((missionNamespace getVariable "WF_C_UNITS_CREW_COST") * _extra);
            };
            if ((_currentRow) != -1) then {
                _funds = Call WFCL_FNC_GetPlayerFunds;
                _skip = false;
                if (_funds < _currentCost) then {
                    _skip = true;
                    [Format[localize 'STR_WF_INFO_Funds_Missing',_currentCost - _funds,_currentUnit select QUERYUNITLABEL]] spawn WFCL_fnc_handleMessage
                };
                //--- Make sure that we own all camps before being able to purchase infantry.
                if (_type == "Depot" && _isInfantry) then {
                    _totalCamps = _closest Call WFCO_FNC_GetTotalCamps;
                    _campsSide = [_closest,WF_Client_SideJoined] Call WFCO_FNC_GetTotalCampsOnSide;
                    if (_totalCamps != _campsSide) then {
                        _skip = true;
                        [format["%1", (localize 'STR_WF_INFO_Camps_Purchase')]] spawn WFCL_fnc_handleMessage
                    };
                };
                if !(_skip) then {
                    _currentGroupSize = Count ((Units (group player)) Call WFCO_FNC_GetLiveUnits);
                    //--- Get the infantry limit based off the infantry upgrade.
                    _realSize = missionNamespace getVariable 'WF_C_PLAYERS_AI_MAX';

                    if (_isInfantry) then {
                        if ((unitQueu + _currentGroupSize + 1) > _realSize) then {
                            _skip = true;
                            [Format [localize 'STR_WF_INFO_MaxGroup',_realSize]] spawn WFCL_fnc_handleMessage
                        }
                    };

                    if (!_isInfantry && !_skip) then {
                        _cpt = 0;
                        if (_driver) then {_cpt = _cpt + 1};
                        if (_gunner) then {_cpt = _cpt + 1};
                        if (_commander) then {_cpt = _cpt + 1};
                        if (_extracrew) then {_cpt = _cpt + ((_currentUnit select QUERYUNITCREW) select 3)};
                        if ((unitQueu + _currentGroupSize + _cpt) > _realSize && _cpt != 0) then {
                            _skip = true;
                            [Format [localize 'STR_WF_INFO_MaxGroup',_realSize]] spawn WFCL_fnc_handleMessage
                        };
                    };
                };

                if !(_skip) then {
                    if(_unit == missionNamespace getVariable Format["WF_%1MHQNAME", WF_Client_SideJoined]) then {
                        _mhqs = (WF_Client_SideJoined) Call WFCO_FNC_GetSideHQ;
                        _mhqs = _mhqs - [objNull];
                        if(count _mhqs >= missionNamespace getVariable "WF_C_BASE_AREA") then {
                            _skip = true;
                            [Format [localize 'STR_WF_INFO_BaseArea_Reached',count _mhqs]] spawn WFCL_fnc_handleMessage
                        }
                    }
                };

                if !(_skip) then {

                    //--- Check the max queu.
                    if(_unit == missionNamespace getVariable Format["WF_%1MHQNAME", WF_Client_SideJoined]) then {
                        if ((missionNamespace getVariable Format["WF_C_QUEUE_HQ_%1",_type]) < (missionNamespace getVariable Format["WF_C_QUEUE_%1_HQ_MAX",_type])) then {
                            missionNamespace setVariable [Format["WF_C_QUEUE_HQ_%1",_type],(missionNamespace getVariable Format["WF_C_QUEUE_HQ_%1",_type])+1];

                            _queu = _closest getVariable 'queu';
                            _txt = Format [localize 'STR_WF_INFO_BuyEffective',_currentUnit select QUERYUNITLABEL];
                            if (!isNil '_queu') then {if (count _queu > 0) then {_txt = Format [localize 'STR_WF_INFO_Queu',_currentUnit select QUERYUNITLABEL]}};
                            [format["%1", _txt]] spawn WFCL_fnc_handleMessage;

                            _gunnerEqCommander = false; //--crutch for vehicles such as CUP BPPU VODNIK--
                            if(count _currentUnit >= 12) then {
                                _gunnerEqCommander = _currentUnit # 11;
                            };

                            _params = [[_closest,_unit,[_driver,_gunner,_commander,_extracrew,_isLocked,_gunnerEqCommander],_type,_cpt], [_closest,_unit,[],_type,_cpt]] select (_isInfantry);
                            _params Spawn WFCL_FNC_BuildUnit;
                            -(_currentCost) Call WFCL_FNC_ChangePlayerFunds;
                        } else {
                            [Format [localize 'STR_WF_INFO_Queu_Max',missionNamespace getVariable Format["WF_C_QUEUE_%1_HQ_MAX",_type]]] spawn WFCL_fnc_handleMessage
                        }
                    } else {
                    if ((missionNamespace getVariable Format["WF_C_QUEUE_%1",_type]) < (missionNamespace getVariable Format["WF_C_QUEUE_%1_MAX",_type])) then {
                        missionNamespace setVariable [Format["WF_C_QUEUE_%1",_type],(missionNamespace getVariable Format["WF_C_QUEUE_%1",_type])+1];

                        _queu = _closest getVariable 'queu';
                        _txt = Format [localize 'STR_WF_INFO_BuyEffective',_currentUnit select QUERYUNITLABEL];
                        if (!isNil '_queu') then {if (count _queu > 0) then {_txt = Format [localize 'STR_WF_INFO_Queu',_currentUnit select QUERYUNITLABEL]}};
                        [format["%1", _txt]] spawn WFCL_fnc_handleMessage;

                        _gunnerEqCommander = false; //--crutch for vehicles such as CUP BPPU VODNIK--
                        if(count _currentUnit >= 12) then {
                            _gunnerEqCommander = _currentUnit # 11;
                        };

                        _params = [[_closest,_unit,[_driver,_gunner,_commander,_extracrew,_isLocked,_gunnerEqCommander],_type,_cpt], [_closest,_unit,[],_type,_cpt]] select (_isInfantry);
                        _params Spawn WFCL_FNC_BuildUnit;
                        -(_currentCost) Call WFCL_FNC_ChangePlayerFunds;
                    } else {
                        [Format [localize 'STR_WF_INFO_Queu_Max',missionNamespace getVariable Format["WF_C_QUEUE_%1_MAX",_type]]] spawn WFCL_fnc_handleMessage
                        }
                    }
                };
            };
		} else {
		    _currentRow = lnbCurSelRow _listBox;
            _currentValue = lnbValue[_listBox,[_currentRow,0]];
            _cost = lnbValue[_listBox,[_currentRow,1]];
            _generalSquadCounter = lnbValue[_listBox,[_currentRow,2]];
            _cpt = 1;

		    _generalGroupTemplates = missionNamespace getVariable Format["WF_%1AITEAMTEMPLATES",WF_Client_SideJoined];
		    _generalGroupTemplateDescriptions = missionNamespace getVariable Format["WF_%1AITEAMTEMPLATEDESCRIPTIONS",WF_Client_SideJoined];
            _selectedGroupTemplate = _generalGroupTemplates # _generalSquadCounter;
            _selectedGroupTemplateDescription = _generalGroupTemplateDescriptions # _generalSquadCounter;

            _commonTime = 0;
            {
                _firstClassName = _selectedGroupTemplate # 0;
                _firstUnitConfig = missionNamespace getVariable _firstClassName;
                _commonTime = _commonTime + (_firstUnitConfig # QUERYUNITTIME)
            } foreach _selectedGroupTemplate;

            if ((_currentRow) != -1) then {
                _funds = Call WFCL_FNC_GetPlayerFunds;
                _skip = false;

                if (_funds < _cost) then {
                    _skip = true;
                    [Format[localize 'STR_WF_INFO_Funds_Missing',_cost - _funds,_selectedGroupTemplateDescription]] spawn WFCL_fnc_handleMessage;
                };

                if !(_skip) then {
                    _hcAllowedGroupAmount = WF_C_HIGH_COMMAND_MIN_GROUP_AMOUNT + (((WF_Client_SideJoined) call WFCO_FNC_GetSideUpgrades) # WF_UP_HC_GROUP_AMOUNT);

                    _purchasedGroups = [WF_Client_SideJoined] call WFCO_FNC_getHighCommandGroups;
                    if((count _purchasedGroups) >= _hcAllowedGroupAmount ) then {
                        _skip = true;
                        [Format [localize 'STR_WF_INFO_HC_Group_Max', _hcAllowedGroupAmount]] spawn WFCL_fnc_handleMessage
                    }
                };
                if !(_skip) then {
                    _purchasedGroups = [WF_Client_SideJoined] call WFCO_FNC_getHighCommandGroups;
                    if (groupQueu  >= WF_C_HIGH_COMMAND_MAX_QUEUE_ORDER_GROUP_PURCHASE) then {
                        _skip = true;
                        [Format [localize 'STR_WF_INFO_Queu_Max', WF_C_HIGH_COMMAND_MAX_QUEUE_ORDER_GROUP_PURCHASE]] spawn WFCL_fnc_handleMessage;
                    }
                };
                if !(_skip) then {
                    //--- Check the max queu.
                    if ((missionNamespace getVariable Format["WF_C_GROUP_QUEUE_%1",_type]) < WF_C_HIGH_COMMAND_MAX_QUEUE_ORDER_GROUP_PURCHASE) then {
                        missionNamespace setVariable [Format["WF_C_GROUP_QUEUE_%1",_type],(missionNamespace getVariable Format["WF_C_GROUP_QUEUE_%1",_type])+1];

                        _queu = _closest getVariable 'groupQueu';
                        _txt = Format [localize 'STR_WF_INFO_BuyEffective',_selectedGroupTemplateDescription];
                        if (!isNil '_queu') then {if (count _queu > 0) then {_txt = Format [localize 'STR_WF_INFO_Queu',_selectedGroupTemplateDescription]}};
                        [format ["%1", _txt]] spawn WFCL_fnc_handleMessage;

                        [_closest,_selectedGroupTemplate,_type,_cpt, _commonTime, _selectedGroupTemplateDescription] Spawn WFCL_FNC_BuildGroup;
                        -(_cost) Call WFCL_FNC_ChangePlayerFunds;

                    } else {
                        [Format [localize 'STR_WF_INFO_Queu_Max',missionNamespace getVariable Format["WF_C_GROUP_QUEUE_%1_MAX",_type]]] spawn WFCL_fnc_handleMessage
                    };
                };
            };

		};
	};
	
	//--- Tabs selection.
	if (WF_MenuAction == 101) then {WF_MenuAction = -1;if (barracksInRange) then {_currentIDC = 12005;_type = 'Barracks';_val = 0;_update = true}};
	if (WF_MenuAction == 102) then {WF_MenuAction = -1;if (lightInRange) then {_currentIDC = 12006;_type = 'Light';_val = 1;_update = true}};
	if (WF_MenuAction == 103) then {WF_MenuAction = -1;if (heavyInRange) then {_currentIDC = 12007;_type = 'Heavy';_val = 2;_update = true}};
	if (WF_MenuAction == 104) then {WF_MenuAction = -1;if (aircraftInRange) then {_currentIDC = 12008;_type = 'Aircraft';_val = 3;_update = true}};
	if (WF_MenuAction == 105) then {WF_MenuAction = -1;if (depotInRange) then {_currentIDC = 12020;_type = 'Depot';_val = 4;_update = true}};
	if (WF_MenuAction == 106) then {WF_MenuAction = -1;if (hangarInRange) then {_currentIDC = 12021;_type = 'Airport';_val = 3;_update = true}};

	//--- driver-gunner-commander icons.
	if (WF_MenuAction == 201) then {WF_MenuAction = -1;_driver = if (_driver) then {false} else {true};_updateDetails = true};
	if (WF_MenuAction == 202) then {WF_MenuAction = -1;_gunner = if (_gunner) then {false} else {true};_updateDetails = true};
	if (WF_MenuAction == 203) then {WF_MenuAction = -1;_commander = if (_commander) then {false} else {true};_updateDetails = true};
	if (WF_MenuAction == 204) then {WF_MenuAction = -1;_extracrew = if (_extracrew) then {false} else {true};_updateDetails = true};
	
	//--- Factory DropDown list value has changed.
	if (WF_MenuAction == 301) then {WF_MenuAction = -1;_factSel = lbCurSel 12018;_closest = _sorted select _factSel;_updateMap = true};
	
	//--- Selection change, we update the details.
	if (WF_MenuAction == 302) then {WF_MenuAction = -1;_updateDetails = true};
	
	//--- Faction Filter changed.
	if (WF_MenuAction == 303) then {WF_MenuAction = -1;_update = true;missionNamespace setVariable [Format["WF_%1%2CURRENTFACTIONSELECTED",WF_Client_SideJoinedText,_type],(lbCurSel _comboFaction)]};

	//--- Unit/Group Filter changed
	if (WF_MenuAction == 3033) then {WF_MenuAction = -1;_update = true;missionNamespace setVariable [Format["WF_%1%2CURRENTGROUPSSELECTED",WF_Client_SideJoinedText,_type],(lbCurSel _comboGroups)]};

	//--- Lock icon.
	if (WF_MenuAction == 401) then {WF_MenuAction = -1;_isLocked = if (_isLocked) then {false} else {true};_updateDetails = true};

	//--- Player funds.
	ctrlSetText [12019,Format [localize 'STR_WF_UNITS_Cash',Call WFCL_FNC_GetPlayerFunds]];

	//--- Update tabs.
	if (_update) then {

        [_comboFaction,_type] Call WFCL_FNC_changeComboBuyUnits;
        [_comboGroups,_type] Call WFCL_FNC_changeComboBuyGroups;
	    _selectedPurchaseTypeIndex = lbCurSel _comboGroups;

        if (_selectedPurchaseTypeIndex == 0) then {

            _listUnits = missionNamespace getVariable Format ['WF_%1%2UNITS',WF_Client_SideJoinedText,_type];
            {
                _un = _x;
                if(isNil "_un")then{
                    _listUnits deleteAt _forEachIndex;
                }else{
                    _selUnit = missionNamespace getVariable _un;
                    if(isNil "_selUnit")then{
                        _listUnits deleteAt _forEachIndex;

                    };
                }
            } foreach _listUnits;

            _isPort = false;
            if (_type == 'Depot') then {

                _sorted = [[vehicle player, missionNamespace getVariable "WF_C_TOWNS_PURCHASE_RANGE"] Call WFCL_FNC_GetClosestDepot];

                _townSpecialities = (_sorted # 0) getVariable ["townSpeciality", []];
                if (WF_C_PORT in _townSpecialities) then { _isPort = true }
            };

            [_listUnits, _type, _listBox, _val, _isPort] Call WFCL_FNC_fillListBuyUnits;
        } else {
            [_type,_listBox,_val] Call WFCL_FNC_fillListBuyGroups;
        };

		lnbSortByValue [_listBox, 1, false];
		
		//--- Update tabs icons.
		_IDCS = [12005,12006,12007,12008,12020,12021,12025,120255];
		_IDCS = _IDCS - [_currentIDC];
		_con = _display DisplayCtrl _currentIDC;
		_con ctrlSetTextColor [1, 1, 1, 1];
		{_con = _display DisplayCtrl _x;_con ctrlSetTextColor [0.4, 0.4, 0.4, 1]} forEach _IDCS;
		
		_update = false;
		_updateList = true;
		_updateDetails = true;
	};
	
	//--- Update factories.
	if (_updateList) then {
		switch (_type) do {
			//--- Specials.
			case 'Depot': {
				_sorted = [[vehicle player, missionNamespace getVariable "WF_C_TOWNS_PURCHASE_RANGE"] Call WFCL_FNC_GetClosestDepot];
			};
			case 'Airport': {
				_sorted = [[vehicle player, missionNamespace getVariable "WF_C_UNITS_PURCHASE_HANGAR_RANGE"] Call WFCL_FNC_GetClosestAirport];
			};
			//--- Factories
			default {
				_buildings = (WF_Client_SideJoined) Call WFCO_FNC_GetSideStructures;
				_factories = [WF_Client_SideJoined,missionNamespace getVariable Format ['WF_%1%2TYPE',WF_Client_SideJoinedText,_type],_buildings] Call WFCO_FNC_GetFactories;
				_sorted = [vehicle player,_factories] Call WFCO_FNC_SortByDistance;
				_closest = _sorted select 0;
				_countAlive = count _factories;
			};
		};

		//--- Refresh the Factory DropDown list.
		lbClear 12018;
		{
			_nearTown = ([_x, towns] Call WFCO_FNC_GetClosestEntity) getVariable 'name';
			_txt = _type + ' ' + _nearTown + ' ' + str (round((vehicle player) distance _x)) + 'M';
			lbAdd[12018,_txt];
		} forEach _sorted;
		lbSetCurSel [12018,0];
		
		_updateList = false;
		_updateMap = true;
	};
	
	//--- Display Factory Queu.
	if(lbCurSel _comboGroups == 0) then {
	_queu = _closest getVariable "queu";
	_value = [count (_closest getVariable "queu"), 0] select (isNil '_queu');
	ctrlSetText[12024,Format[localize 'STR_WF_UNITS_QueuedLabel',str _value]];
	} else {
	    _queu = _closest getVariable "groupQueu";
	    _value = [count (_closest getVariable "groupQueu"), 0] select (isNil '_queu');
        ctrlSetText[12024,Format[localize 'STR_WF_UNITS_QueuedLabel',str _value]];
	};

	
	//--- List selection changed.
	if (_updateDetails) then {

	    if(lbCurSel _comboGroups == 0) then {
	        _currentRow = lnbCurSelRow _listBox;
            //--- Our list is not empty.
            if (_currentRow != -1) then {
                _currentValue = lnbValue[_listBox,[_currentRow,0]];
                _unit = _listUnits select _currentValue;
                _currentUnit = missionNamespace getVariable _unit;
                ctrlSetText [12009,_currentUnit select QUERYUNITPICTURE];
                ctrlSetText [12033,_currentUnit select QUERYUNITFACTION];
                ctrlSetText [12035,str (_currentUnit select QUERYUNITTIME)];
                _currentCost = _currentUnit select QUERYUNITPRICE;
                _capturedMilitaryBases = [WF_Client_SideJoined, WF_C_MILITARY_BASE, false] call WFCO_fnc_getSpecialLocations;
                if(_capturedMilitaryBases > 0) then {
                    _currentCost = ceil (_currentCost - (WF_C_MILITARY_BASE_DISCOUNT_PERCENT * _capturedMilitaryBases * _currentCost));
                };

                _side = switch (getNumber(configFile >> "CfgVehicles" >> _unit >> "side")) do {case 0: {east}; case 1: {west}; case 2: {resistance}; default {civilian}};
                if(_side == civilian) then {
                    {ctrlShow [_x,false]} forEach (_IDCSVehi);
                    _driver = false;
                    _gunner = false;
                    _commander = false;
                    _extracrew = false
                };

                _isInfantry = (_unit isKindOf 'Man');

                //--- Update driver-gunner-commander icons.
                if (!(_isInfantry)) then {
                    ctrlSetText [12036,"N/A"];
                    ctrlSetText [12037,str (getNumber (configFile >> 'CfgVehicles' >> _unit >> 'transportSoldier'))];
                    ctrlSetText [12038,str (getNumber (configFile >> 'CfgVehicles' >> _unit >> 'maxSpeed'))];
                    ctrlSetText [12039,str (getNumber (configFile >> 'CfgVehicles' >> _unit >> 'armor'))];
                    if (_side != civilian) then {
                        _slots = _currentUnit select QUERYUNITCREW;
                        if (_slots isEqualType []) then {

                            _hasCommander = _slots select 0;
                            _hasGunner = _slots select 1;
                            _turretsCount = _slots select 3;
                            _extra = 0;

                            _maxOut = false;
                            if (_lastType != _type || _lastSel != _currentRow) then {_maxOut = true};

                            if (_maxOut) then {
                                _driver = true;
                                _gunner = true;
                                _commander = true;
                                _extracrew = false;
                            };

                            if !(_hasGunner) then {_gunner = false};

                            if !(_hasCommander) then {_commander = false};

                            if (_turretsCount <= 0) then {_extracrew = false; _turretsCount = 0};

                            ctrlShow[_IDCSVehi select 0, true];
                            ctrlShow[_IDCSVehi select 1, _hasGunner];
                            ctrlShow[_IDCSVehi select 2, _hasCommander];
                            ctrlShow[_IDCSVehi select 3, if (_turretsCount == 0) then {false} else {true}];

                            _c = 0;
                            {
                                _color = if (_x) then {_enabledColor} else {_disabledColor};
                                _con = _display displayCtrl (_IDCSVehi select _c);
                                _con ctrlSetTextColor _color;

                                _c = _c + 1;
                            } forEach [_driver,_gunner,_commander,_extracrew];

                            if (_driver) then {_extra = _extra + 1};
                            if (_gunner) then {_extra = _extra + 1};
                            if (_commander) then {_extra = _extra + 1};
                            if (_extracrew) then {_extra = _extra + _turretsCount};

                            //--- Set the 'extra' price.
                            _currentCost = _currentCost + ((missionNamespace getVariable "WF_C_UNITS_CREW_COST") * _extra);
                        } else {//--- Backward compability.
                            _c = 0;
                            _extra = 0;

                            //--- Enabled AI by default.
                            _extracrew = false;
                            _maxOut = false;
                            if (_lastType != _type || _lastSel != _currentRow) then {_maxOut = true};

                            switch (_slots) do {
                                case 1: {
                                    if (_maxOut) then {_driver = true};
                                    if (_driver) then {_extra = _extra + 1};
                                    _gunner = false;
                                    _commander = false;
                                };
                                case 2: {
                                    if (_maxOut) then {_driver = true;_gunner = true};
                                    if (_driver) then {_extra = _extra + 1};
                                    if (_gunner) then {_extra = _extra + 1};
                                    _commander = false;
                                };
                                case 3: {
                                    if (_maxOut) then {_driver = true;_gunner = true;_commander = true};
                                    if (_driver) then {_extra = _extra + 1};
                                    if (_gunner) then {_extra = _extra + 1};
                                    if (_commander) then {_extra = _extra + 1};
                                };
                            };

                            //--- Show the icons.
                            {
                                _show = false;
                                if (_c < _slots) then {_show = true};
                                ctrlShow [_x,_show];
                                _c = _c + 1;
                            } forEach _IDCSVehi;

                            //--- Mask extra crew.
                            ctrlShow[_IDCSVehi select 3, false];

                            _i = 0;

                            //--- Set the icons.
                            {
                                _color = if (_x) then {_enabledColor} else {_disabledColor};
                                _con = _display displayCtrl (_IDCSVehi select _i);
                                _con ctrlSetTextColor _color;
                                _i = _i + 1;
                            } forEach [_driver,_gunner,_commander,_extracrew];

                            //--- Set the 'extra' price.
                            _currentCost = _currentCost + ((missionNamespace getVariable "WF_C_UNITS_CREW_COST") * _extra);
                        };
                    }
                } else {
                    //--- calculate skill
                    _upgrades = (WF_Client_SideJoined) Call WFCO_FNC_GetSideUpgrades;
                    _current_infantry_upgrade = _upgrades select WF_UP_BARRACKS;
                    _skill = 0.3;
                    switch (_current_infantry_upgrade) do {
                        case 1: { _skill = 0.5 };
                        case 2: { _skill = 0.7 };
                        case 3: { _skill = 0.9 };
                    };
                    ctrlSetText [12036,Format ["%1/100",_skill * 100]];
                    ctrlSetText [12037,"N/A"];
                    ctrlSetText [12038,"N/A"];
                    ctrlSetText [12039,"N/A"];

                    {ctrlShow [_x,false]} forEach (_IDCSVehi);
                    _driver = false;
                    _gunner = false;
                    _commander = false;
                    _extracrew = false;

                    //--- Display a unit's loadout.
                    _weapons = (getArray (configFile >> 'CfgVehicles' >> _unit >> 'weapons')) - ['Put','Throw'];
                    _magazines = getArray (configFile >> 'CfgVehicles' >> _unit >> 'magazines');

                    _classMags = [];
                    _classMagsAmount = [];
                    _MagsLabel = [];

                    {
                        _findAt = _classMags find _x;
                        if (_findAt == -1) then {
                            _classMags pushBack _x;
                            _classMagsAmount pushBack 1;
                            _MagsLabel pushBack ([_x,'displayName','CfgMagazines'] Call WFCO_FNC_GetConfigInfo);
                        } else {
                            _classMagsAmount set [_findAt, (_classMagsAmount select _findAt) + 1];
                        };
                    } forEach _magazines;
                    _txt = "<t color='#42b6ff' shadow='1'>" + (localize 'STR_WF_UNITS_Weapons') + ":</t><br />";

                    _txttg = "";
                    _txtta = "";

                    for [{_i = 0},{_i < count _weapons},{_i = _i + 1}] do {
                        _txttg = _txttg + "<t color='#eee58b' shadow='2'>" + ([(_weapons select _i),'displayName','CfgWeapons'] Call WFCO_FNC_GetConfigInfo) + "</t>";

                        if ((_i+1) < count _weapons) then {_txttg = _txttg + "<t color='#D3A119' shadow='2'>,</t> "};
                    };

                    for "_j" from 0 to ((count WF_C_INFANTRY_TO_REQUIP) - 1) do
                    {
                        _currentElement = WF_C_INFANTRY_TO_REQUIP select _j;
                        if (_unit in _currentElement) exitWith {
                            //--Weapons--
                            _cnt = count (_currentElement select 1);
                            if(_cnt > 0) then {
                                _cnt = _cnt - 1;
                                _txttg = "";
                                for "_k" from 0 to _cnt do
                                {
                                    _curEl = (_currentElement select 1) select _k;
                                    _txttg = _txttg + "<t color='#eee58b' shadow='2'>" + _curEl + "</t>";
                                    if(_k < _cnt) then {_txttg = _txttg + "<t color='#D3A119' shadow='2'>,</t> "};
                                };
                            };

                            //--Ammo--
                            _cnt = count (_currentElement select 2);
                            if(_cnt > 0) then {
                                _cnt = _cnt - 1;
                                _txtta = "";
                                for "_l" from 0 to _cnt do
                                {
                                    _curEl = (_currentElement select 2) select _l;
                                    _txtta = _txtta + "<t color='#eee58b' shadow='2'>" + _curEl + "</t>";
                                    if(_l < _cnt) then {_txtta = _txtta + "<t color='#D3A119' shadow='2'>,</t> "};
                                };
                            };
                        };
                    };

                    _txt = _txt + _txttg;

                    _txt = _txt + "<t color='#D3A119' shadow='2'></t><br /><br />";
                    _txt = _txt + "<t color='#42b6ff' shadow='1'>" + (localize 'STR_WF_UNITS_Magazines') + ":</t><br />";

                    if(_txtta == "") then {
                        for [{_i = 0},{_i < count _MagsLabel},{_i = _i + 1}] do {
                            _txt = _txt + "<t color='#eee58b' shadow='2'>" + ((_MagsLabel select _i) + "</t> <t color='#42b6ff' shadow='1'>x</t><t color='#42b6ff' shadow='1'>" + str (_classMagsAmount select _i)) + "</t>";
                            if ((_i+1) < count _MagsLabel) then {_txt = _txt + "<t color='#D3A119' shadow='2'>,</t> "};
                        };
                    }
                    else
                    {
                        _txt = _txt + _txtta;
                    };

                    _txt = _txt + "<t color='#D3A119' shadow='2'></t>";

                    (_display displayCtrl 12022) ctrlSetStructuredText (parseText _txt);
                };

                //--- Lock Icon.
                if !(_isInfantry) then {
                    ctrlShow[_IDCLock,true];
                    _color = if (_isLocked) then {_enabledColor2} else {_disabledColor};
                    _con = _display displayCtrl _IDCLock;
                    _con ctrlSetTextColor _color;
                } else {
                    ctrlShow[_IDCLock,false];
                };

                //--- Long description.
                if !(_isInfantry) then {
                    if (isClass (configFile >> 'CfgVehicles' >> _unit >> 'Library')) then {
                        _txt = getText (configFile >> 'CfgVehicles' >> _unit >> 'Library' >> 'libTextDesc');
                        (_display displayCtrl 12022) ctrlSetStructuredText (parseText _txt);
                    } else {
                        (_display displayCtrl 12022) ctrlSetStructuredText (parseText '');
                    };
                };

                ctrlSetText [12034,Format ["$ %1",_currentCost]];
                _updateDetails = false;
            } else {
                {ctrlSetText [_x , ""]} forEach [12009,12010,12027,12028,12029,12030,12031,12032,12033,12034,12035,12036,12037,12038,12039];
                (_display displayCtrl 12022) ctrlSetStructuredText (parseText '');
            };
	    } else {
            lbClear _comboFaction;
	        {ctrlShow [_x,false]} forEach (_IDCSVehi);
            ctrlShow[_IDCLock,false];
            _driver = false;
            _gunner = false;
            _commander = false;
            _extracrew = false;
            (_display displayCtrl 12022) ctrlSetStructuredText (parseText '');

            _currentRow = lnbCurSelRow _listBox;
            _currentValue = lnbValue[_listBox,[_currentRow,0]];
            _cost = lnbValue[_listBox,[_currentRow,1]];
            _generalSquadCounter = lnbValue[_listBox,[_currentRow,2]];

            _generalGroupTemplates = missionNamespace getVariable Format["WF_%1AITEAMTEMPLATES",WF_Client_SideJoined];
            _selectedGroupTemplate = _generalGroupTemplates # _generalSquadCounter;
            _firstClassName = _selectedGroupTemplate # 0;
            _firstUnitConfig = missionNamespace getVariable _firstClassName;

            ctrlSetText [12009,_firstUnitConfig # QUERYUNITPICTURE];
            ctrlSetText [12033,_firstUnitConfig # QUERYUNITFACTION];
            ctrlSetText [12034,Format ["$ %1",_cost]];

            //--- calculate skill
            _upgrades = (WF_Client_SideJoined) Call WFCO_FNC_GetSideUpgrades;
            _current_infantry_upgrade = _upgrades select WF_UP_BARRACKS;
            _skill = 0.3;
            switch (_current_infantry_upgrade) do {
                case 1: { _skill = 0.5 };
                case 2: { _skill = 0.7 };
                case 3: { _skill = 0.9 };
            };

            ctrlSetText [12036,Format ["%1/100", _skill * 100]];

            _commonTime = 0;
            {
                _firstClassName = _selectedGroupTemplate # 0;
                _firstUnitConfig = missionNamespace getVariable _firstClassName;
                _commonTime = _commonTime + (_firstUnitConfig # QUERYUNITTIME)
            } foreach _selectedGroupTemplate;
            ctrlSetText [12035,str (_commonTime)];
            ctrlSetText [12037,str ( count _selectedGroupTemplate * (getNumber (configFile >> 'CfgVehicles' >> _firstClassName >> 'transportSoldier')))];
            ctrlSetText [12038,str (getNumber (configFile >> 'CfgVehicles' >> _firstClassName >> 'maxSpeed'))];
            ctrlSetText [12039,str (getNumber (configFile >> 'CfgVehicles' >> _firstClassName >> 'armor'))];

            _txt = "<t color='#42b6ff' shadow='1'>" + (localize 'STR_WF_GROUP_UNITS') + ":</t><br />";
            _txttg = "";
            for [{_z = 0},{_z < count _selectedGroupTemplate},{_z = _z + 1}] do {
                _firstClassName = _selectedGroupTemplate # _z;
                _firstUnitConfig = missionNamespace getVariable _firstClassName;

                if!(isNil '_firstUnitConfig') then {
                    _txttg = _txttg + "<t color='#eee58b' shadow='2'>" + (_firstUnitConfig # QUERYUNITLABEL) + "</t>";

                    if ((_z+1) < count _selectedGroupTemplate) then {_txttg = _txttg + "<t color='#D3A119' shadow='2'>,</t> "}
                }
            };

            _txt = _txt + _txttg;
            (_display displayCtrl 12022) ctrlSetStructuredText (parseText _txt);
	    };
	};
	
	//--- Update the Factory Minimap position.
	if (_updateMap) then {
		ctrlMapAnimClear _map;
		_map ctrlMapAnimAdd [2,.075,getPos _closest];
		ctrlMapAnimCommit _map;
		_updateMap = false;
	};
	
	//--- Check that the factories of the current type are still alive.
	_lastCheck = _lastCheck + 0.1;
	if (_lastCheck > 2 && _type != 'Depot' && _type != 'Airport') then {
		_lastCheck = 0;
		_buildings = (WF_Client_SideJoined) Call WFCO_FNC_GetSideStructures;
		_factories = [WF_Client_SideJoined,missionNamespace getVariable Format ['WF_%1%2TYPE',WF_Client_SideJoinedText,_type],_buildings] Call WFCO_FNC_GetFactories;
		if (count _factories != _countAlive) then {_updateList = true};
	};
	
	_lastSel = lnbCurSelRow _listBox;
	_lastType = _type;
	sleep 0.1;
	
	//--- Back Button.
	if (WF_MenuAction == 2) exitWith { //---added-MrNiceGuy
		WF_MenuAction = -1;
		closeDialog 0;
		createDialog "WF_Menu"
	};
};