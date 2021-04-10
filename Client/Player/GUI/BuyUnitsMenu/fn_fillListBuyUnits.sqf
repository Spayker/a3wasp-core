params ["_listNames", "_filler", "_listBox", "_value", "_isPort"];
private ['_addin','_c','_currentUpgrades','_filter','_i','_u','_value','_selectedRole'];
_selectedRole = WF_gbl_boughtRoles # 0;

_u = 0;
_i = 0;

_currentUpgrades = (WF_Client_SideJoined) call WFCO_FNC_GetSideUpgrades;
_filter = missionNamespace getVariable format["WF_%1%2CURRENTFACTIONSELECTED",WF_Client_SideJoinedText,_filler];
if (isNil '_filter') then {_filter = "nil"} else {
	if (_filter == 0) then {
		_filter = 'nil';
	} else {
		_filter = ((missionNamespace getVariable format["WF_%1%2FACTIONS",WF_Client_SideJoinedText,_filler]) # _filter);
	};
};

lnbClear _listBox;

{
	if(isNil "_x") then {
		_listNames deleteAt _forEachIndex;
	} else {
		_selUnit = missionNamespace getVariable _x;
		if(isNil "_selUnit")then{
			_listNames deleteAt _forEachIndex;
		};
	}
}foreach _listNames;
		
_UpBar = ((WF_Client_SideJoined) call WFCO_FNC_GetSideUpgrades) # WF_UP_BARRACKS;
_UpLight = ((WF_Client_SideJoined) call WFCO_FNC_GetSideUpgrades) # WF_UP_LIGHT;
_UpHeavy = ((WF_Client_SideJoined) call WFCO_FNC_GetSideUpgrades) # WF_UP_HEAVY;
_UpAir = ((WF_Client_SideJoined) call WFCO_FNC_GetSideUpgrades) # WF_UP_AIR;

_logic = (WF_Client_SideJoined) Call WFCO_FNC_GetSideLogic;
_isFirstOutTeam = _logic getVariable ["wf_isFirstOutTeam", false];
{
	_addin = true;
	_isAdvVehicle = false;
	_c = missionNamespace getVariable _x;
	_className = _x;
	
	if!(isNil "_c") then {
		if (_filter != "nil") then {
			if ((_c # QUERYUNITFACTION) != _filter) then {_addin = false}
		};

		_addit = false;
		if(_filler == 'Depot') then {
		    if(_UpBar >= (missionNamespace getVariable[_className, [0, 0, 0, 0, 0, 0]]) # 5) then { _addit = true };

		    if!(_isPort) then {
		        if (_className isKindOf 'Ship') then { _addit = false; _addin = false }
		    }
		};

		if (_x in WF_ADV_ARTILLERY)then{ _isAdvVehicle = true};
		if (_x in WF_FLY_UAVS)then{ _isAdvVehicle = true};

        if!(isNil '_selectedRole')then{
            if(_selectedRole == WF_SUPPORT)then{
                if(_filler == 'Light')then{
                    if (_isAdvVehicle && _UpLight >= _c # QUERYUNITUPGRADE) then {
                        _addit = true
                    }
                };
                if(_filler == 'Heavy')then{
                    if (_isAdvVehicle && _UpHeavy >= _c # QUERYUNITUPGRADE) then {
                        _addit = true
                    }
                }
		    };

		    if(_selectedRole == WF_SUPPORT) then {
		        if(_filler == 'Aircraft' || _filler == 'Airport') then {
		            if (_isAdvVehicle  && _UpAir >= _c # QUERYUNITUPGRADE) then {
		                _addit = true
		            }
		        }
		    }
		};

        if((_filler == 'Light' || _filler == 'Heavy')) then {
            if(_x == missionNamespace getVariable Format["WF_%1MHQNAME", WF_Client_SideJoined]) then {

                if (isNull(commanderTeam)) then {
                    _addit = false;
                    _addin = false
                } else {
                    if (commanderTeam == group player) then {
                        _addit = true;
                        _addin = true
                    } else {
                        _addit = false;
                        _addin = false
                    }
                };

                if(_isFirstOutTeam) then {
                    _addit = false;
                    _addin = false
                }
            }
        };

		if (((_c # QUERYUNITUPGRADE) <= (_currentUpgrades # _value) && _addin && !_isAdvVehicle) || (_addit && _addin)) then {
		    _cost = _c # QUERYUNITPRICE;
		    _capturedMilitaryBases = [WF_Client_SideJoined, WF_C_MILITARY_BASE, false] call WFCO_fnc_getSpecialLocations;
            if(_capturedMilitaryBases > 0) then {
                _cost = ceil (_cost - (WF_C_MILITARY_BASE_DISCOUNT_PERCENT * _capturedMilitaryBases * _cost));
            };

            if(_x == missionNamespace getVariable Format["WF_%1MHQNAME", WF_Client_SideJoined]) then {
                _currentHQPenalty = missionNamespace getVariable (format ["wf_%1_hq_penalty", WF_Client_SideJoined]);
                _cost = _cost + _currentHQPenalty
            };

		    if(_isAdvVehicle) then {
		        lnbAddRow [_listBox,['$'+str (_cost),(_c # QUERYUNITLABEL)]];
                lnbSetData [_listBox,[_i,0],_filler];
                lnbSetValue [_listBox,[_i,0],_u];
                lnbSetValue [_listBox,[_i,1],_cost];
                lnbSetColor [_listBox,[_i,1],[0.6, 0.4, 0.6, 1.0]];
		    } else {
		        lnbAddRow [_listBox,['$'+str (_cost),(_c # QUERYUNITLABEL)]];
				lnbSetData [_listBox,[_i,0],_filler];
				lnbSetValue [_listBox,[_i,0],_u];
                lnbSetValue [_listBox,[_i,1],_cost];

                if(_filler == 'Depot' && _x isKindOf 'Man') then {
                    lnbSetColor [_listBox,[_i,1],[0.6, 0.6, 0.0, 1.0]]
                };

				if(_x in (missionNamespace getVariable ["WF_AMBULANCES", []])) then {
					lnbSetColor [_listBox,[_i,1],[1.0, 1.0, 0.0, 1.0]]
				};

				if(_x in (missionNamespace getVariable [format["WF_%1SALVAGETRUCK", WF_Client_SideJoined], []])) then {
					lnbSetColor [_listBox,[_i,1],[0.0, 0.5, 1.0, 1.0]]
				};

				if(_x in (missionNamespace getVariable [format["WF_%1REPAIRTRUCKS", WF_Client_SideJoined], []])) then {
					lnbSetColor [_listBox,[_i,1],[1.0, 0.5, 0.25, 1.0]]
				};

				if(_x in (missionNamespace getVariable [format["WF_%1REPAIRTRUCKS", WF_Client_SideJoined], []])) then {
                    lnbSetColor [_listBox,[_i,1],[1.0, 0.5, 0.25, 1.0]]
                };

                if((_c # QUERYUNITLABEL) find "(Fuel Truck)" > -1) then {
                    lnbSetColor [_listBox,[_i,1],[0.75, 0.25, 0.25, 1.0]]
                };

                if((_c # QUERYUNITLABEL) find "(Ammo Truck)" > -1) then {
                    lnbSetColor [_listBox,[_i,1],[0.25, 0.75, 0.25, 1.0]]
                };
		    };
		_i = _i + 1;
	};
	_u = _u + 1;
	};
	
} forEach _listNames;

if (_i > 0) then {lnbSetCurSelRow [_listBox,0]} else {lnbSetCurSelRow [_listBox,-1]};