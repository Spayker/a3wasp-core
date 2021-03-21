_lastUpdate = time;
_handle = nil;
_mhqbr = missionNamespace getVariable "WF_C_BASE_HQ_BUILD_RANGE";
_pur = missionNamespace getVariable "WF_C_UNITS_PURCHASE_RANGE";
_pura = missionNamespace getVariable "WF_C_UNITS_PURCHASE_HANGAR_RANGE";
_ccr = missionNamespace getVariable "WF_C_STRUCTURES_COMMANDCENTER_RANGE";
_pgr = missionNamespace getVariable "WF_C_UNITS_PURCHASE_GEAR_RANGE";
_rptr = missionNamespace getVariable "WF_C_UNITS_REPAIR_TRUCK_RANGE";
_spr = missionNamespace getVariable "WF_C_STRUCTURES_SERVICE_POINT_RANGE";
_tcr = missionNamespace getVariable "WF_C_TOWNS_CAPTURE_RANGE";
_ftr = missionNamespace getVariable "WF_C_GAMEPLAY_FAST_TRAVEL_RANGE";
_uavRange = missionNamespace getVariable "WF_C_GAMEPLAY_DARTER_CONNECT_DISTANCE_LIMITATION";
_buygearfrom = missionNamespace getVariable "WF_C_TOWNS_GEAR";
_gear_field_range = missionNamespace getVariable "WF_C_UNITS_PURCHASE_GEAR_MOBILE_RANGE";
_boundaries_enabled = if ((missionNamespace getVariable "WF_C_GAMEPLAY_BOUNDARIES_ENABLED") > 0) then {true} else {false};
_typeRepair = missionNamespace getVariable Format['WF_%1REPAIRTRUCKS',WF_Client_SideJoinedText];
_commandCenter = objNull;

while {!WF_GameOver} do {

    _ccr = missionNamespace getVariable "WF_C_STRUCTURES_COMMANDCENTER_RANGE";
	if (time - _lastUpdate > 5 || WF_ForceUpdate) then {
		_buildings = (WF_Client_SideJoined) Call WFCO_FNC_GetSideStructures;

        _purchaseRange = -1;
        _checks = ['COMMANDCENTERTYPE',_buildings,_ccr,WF_Client_SideJoined,player] Call WFCO_FNC_BuildingInRange;
        _commandCenter = _checks;
        commandInRange = if (isNull _checks) then {false} else {true};

        if!(commandInRange) then {
                {
                _location = _x # 0;
                _locationPos = _x # 1;
                if(isNull _location) then {
                    deleteMarkerLocal format["radiotower%1", (_locationPos) # 0];
                    deleteMarkerLocal format["WF_%1_TowerMarker", (_locationPos) # 1];
                    WF_C_TAKEN_RADIO_TOWERS deleteAt _forEachIndex;
                } else {
                    if(!alive _location) then {
                        deleteMarkerLocal format["radiotower%1", (_locationPos) # 0];
                        deleteMarkerLocal format["WF_%1_TowerMarker", (_locationPos) # 1];
                        WF_C_TAKEN_RADIO_TOWERS deleteAt _forEachIndex;
                    }
                }
            } forEach WF_C_TAKEN_RADIO_TOWERS;

            if(count WF_C_TAKEN_RADIO_TOWERS > 0) then {
                {
                    _location = _x # 0;
                    if ((_location distance player) <= (_ccr/2)) exitWith { commandInRange = true; _ccr = _ccr/2 }
                } forEach WF_C_TAKEN_RADIO_TOWERS;
            }
        };

        if (_purchaseRange == -1) then {
		_purchaseRange = if (commandInRange) then {_ccr} else {_pur};
        };

		//--- Boundaries are limited ?
		if (_boundaries_enabled) then {
			_isOnMap = Call WFCL_FNC_IsOnMap;
			if (!_isOnMap && alive player && !WF_Client_IsRespawning) then {
				if !(paramBoundariesRunning) then {_handle = [] Spawn WFCL_FNC_HandleOnMap;};
			} else {
				if !(isNil '_handle') then {terminate _handle;_handle = nil;};
				paramBoundariesRunning = false;
			};
		};

		//--- UAV distance limitation
		_currentlyConnectedDrone = getConnectedUAV player;
        if(!(isNull _currentlyConnectedDrone)) then {
            if (_currentlyConnectedDrone isKindOf "UAV_01_base_F") then {
                if((player distance _currentlyConnectedDrone) >= _uavRange) then {
                    player connectTerminalToUAV objNull;
                    [Format["<t color='#42b6ff' size='1.2' underline='1' shadow='1'>Information:</t><br /><br /><t>UAV lost signal with you. Max range is (<t color='#BD63F5'>%1</t>) meters.</t>",_uavRange]] spawn WFCL_fnc_handleMessage;
                };
            };
        };

        _mhqs = (WF_Client_SideJoined) Call WFCO_FNC_GetSideHQ;
        if (count _mhqs > 0) then {
            _base = [player, _mhqs] call WFCO_FNC_GetClosestEntity;

		//--- Fast Travel.
        if (commandInRange) then {
        	_fastTravel = false;
        	_isDeployed = [WF_Client_SideJoined, _base] Call WFCO_FNC_GetSideHQDeployStatus;
            if !(isNil '_isDeployed') then {
            if (player distance _base < _ftr && alive _base && _isDeployed) then {_fastTravel = true} else {
                _closest = [vehicle player, towns] Call WFCO_FNC_GetClosestEntity;
                _sideID = _closest getVariable 'sideID';
                if (player distance _closest < _ftr && _sideID == WF_Client_SideID) then {_fastTravel = true} else {
                    if (!isNull _commandCenter) then {
                        if (player distance _commandCenter < _ftr) then {_fastTravel = true}
                    }
                }
            }
            }
        };

		//--- HQ.
		if !(isNull _base) then {
			hqInRange = if ((player distance _base < _mhqbr) && alive _base  && (side _base in [WF_Client_SideJoined,civilian])) then {true} else {false};
		};
        };

		barracksInRange = if (isNull (['BARRACKSTYPE',_buildings,_purchaseRange,WF_Client_SideJoined,player] Call WFCO_FNC_BuildingInRange)) then {false} else {true};
		gearInRange = if (isNull (['BARRACKSTYPE',_buildings,_pgr,WF_Client_SideJoined,player] Call WFCO_FNC_BuildingInRange)) then {false} else {true};
		if !(gearInRange) then {
			if (_buygearfrom in [1,2,3]) then {
				_nObject = objNull;
				switch (_buygearfrom) do { 
					case 1:{_nObject = [vehicle player, _gear_field_range] Call WFCL_FNC_GetClosestCamp;};
					case 2:{_nObject = [vehicle player, _gear_field_range] Call WFCL_FNC_GetClosestDepot;};
					case 3:{{if !(isNull _x) exitWith {_nObject = _x;}} forEach [[vehicle player, _gear_field_range] Call WFCL_FNC_GetClosestCamp, [vehicle player, _gear_field_range] Call WFCL_FNC_GetClosestDepot]};
				};
				gearInRange = if !(isNull _nObject) then {true} else {false};
			};
		};

		lightInRange = if (isNull (['LIGHTTYPE',_buildings,_purchaseRange,WF_Client_SideJoined,player] Call WFCO_FNC_BuildingInRange)) then {false} else {true};
		heavyInRange = if (isNull (['HEAVYTYPE',_buildings,_purchaseRange,WF_Client_SideJoined,player] Call WFCO_FNC_BuildingInRange)) then {false} else {true};
		aircraftInRange = if (isNull (['AIRCRAFTTYPE',_buildings,_purchaseRange,WF_Client_SideJoined,player] Call WFCO_FNC_BuildingInRange)) then {false} else {true};
		serviceInRange = if (isNull (['SERVICEPOINTTYPE',_buildings,_spr,WF_Client_SideJoined,player] Call WFCO_FNC_BuildingInRange)) then {false} else {true};

		if !(serviceInRange) then {
			_checks = (getPos player) nearEntities[_typeRepair,_rptr];
			if (count _checks > 0) then {serviceInRange = true;};
		};

		_checks = [WF_Client_SideJoined, missionNamespace getVariable Format ["WF_%1AARADARTYPE",WF_Client_SideJoinedText],_buildings] Call WFCO_FNC_GetFactories;
		if (count _checks > 0) then {antiAirRadarInRange = true;} else {antiAirRadarInRange = false;};
		
		_checks = [WF_Client_SideJoined, missionNamespace getVariable Format ["WF_%1ArtyRadarTYPE",WF_Client_SideJoinedText],_buildings] Call WFCO_FNC_GetFactories;
		if (count _checks > 0) then {antiArtyRadarInRange = true;} else {antiArtyRadarInRange = false;};
		
		//--- Town Depot.
		depotInRange = if !(isNull ([vehicle player, _tcr] Call WFCL_FNC_GetClosestDepot)) then {true} else {false};
		if (depotInRange) then {serviceInRange = true};

		//--- Airport.
		hangarInRange = if !(isNull ([vehicle player, _pura] Call WFCL_FNC_GetClosestAirport)) then {true} else {false};

		[] spawn WFCL_fnc_updateCommanderState;

		0 = [] spawn {
			missionNamespace setVariable ["ASL_Nearby_Vehicles", (call ASL_Find_Nearby_Vehicles)];
		};

		if (WF_ForceUpdate) then {WF_ForceUpdate  = false}
	};

	_lastUpdate = time;
	sleep 5;
};