disableSerialization;

_display = _this # 0;
_lastRange = artyRange;
_lastUpdate = 0;
_listBox = 17019;

sliderSetRange[17005, 10, missionNamespace getVariable "WF_C_ARTILLERY_AREA_MAX"];
sliderSetPosition[17005, artyRange];

_markers = [];
_FTLocations = [];
_checks = [];
_fireTime = 0;
_status = 0;
_canFT = false;
_forceReload = true;
_startPoint = objNull;
_ftr = missionNamespace getVariable "WF_C_GAMEPLAY_FAST_TRAVEL_RANGE";

_marker = "artilleryMarker";
createMarkerLocal [_marker,artyPos];
_marker setMarkerTypeLocal "mil_destroy";
_marker setMarkerColorLocal "ColorRed";
_marker setMarkerSizeLocal [1,1];

_area = "artilleryAreaMarker";
createMarkerLocal [_area,artyPos];
_area setMarkerShapeLocal "Ellipse";
_area setMarkerColorLocal "ColorRed";
_area setMarkerSizeLocal [artyRange,artyRange];

_map = _display DisplayCtrl 17002;
_drawMarkerId = _map ctrlAddEventHandler ["Draw", WF_C_MAP_MARKER_HANDLER];

_listboxControl = _display DisplayCtrl _listBox;

_pard = missionNamespace getVariable "WF_C_PLAYERS_SUPPORT_PARATROOPERS_DELAY";
{lbAdd[17008,_x]} forEach (missionNamespace getVariable Format ["WF_%1_ARTILLERY_DISPLAY_NAME",WF_Client_SideJoinedText]);
lbSetCurSel[17008,0];

{
    lbAdd[17034, getText (configFile >> "CfgMagazines" >> _x >> "displayName")]
} forEach ( (missionNamespace getVariable Format ["WF_%1_ARTILLERY_EXTENDED_MAGS", WF_Client_SideJoinedText]) # 0 );
lbSetCurSel[17034,0];

_IDCS = [17005,17006,17007,17008,17034];
if ((missionNamespace getVariable "WF_C_ARTILLERY") == 0) then {{ctrlEnable [_x,false]} forEach _IDCS};

{ctrlEnable [_x, false]} forEach [17010,17011,17012,17013,17014,17015,17017,17018,17020];

_currentValue = -1;
_currentFee = -1;
_currentSpecial = "";
_currentFee = -1;

//--- Support List.
_lastSel = -1;

_isCommander = false;
if (!isNull(commanderTeam)) then {if (commanderTeam == group player) then {_isCommander = true}};

_addToList = [
    localize 'STR_WF_TACTICAL_FastTravel',
    localize 'STR_WF_CAS',
    localize 'STR_WF_TACTICAL_ParadropVehicle',
    localize 'STR_WF_TACTICAL_Paratroop',
    localize 'STR_WF_TACTICAL_Heli_Paratroop'
];

_addToListID = [
    "Fast_Travel",
    'CAS',
    "Paradrop_Vehicle",
    "Paratroopers",
    "HeliParatroopers"
];

_addToListFee = [0,7500,7500,5000,9500,3500,3500];
_addToListInterval = [0,500,500,1000,800,600,600];

if (WF_Client_SideJoined != resistance) then {
    _addToList pushBack (localize 'STR_WF_CRUISE_MISSILE');
    _addToListID pushBack ("Cruise Missile");
    _addToListFee pushBack 7500;
    _addToListInterval pushBack 500
} else {
    _addToList pushBack (localize 'STR_WF_CHEMICAL_MISSILE');
    _addToListID pushBack ("Chemical Missile");
    _addToListFee pushBack 7500;
    _addToListInterval pushBack 500
};

if (_isCommander) then {
    _addToList pushBack (localize 'STR_WF_TACTICAL_Paratroop_HC');
    _addToList pushBack (localize 'STR_WF_TACTICAL_Heli_Paratroop_HC');

    _addToListID pushBack ("ParatroopersHC");
    _addToListID pushBack ("HeliParatroopersHC");

    _addToListFee pushBack 3500;
    _addToListFee pushBack 3500;

    _addToListInterval pushBack 600;
    _addToListInterval pushBack 600;
};

for '_i' from 0 to count(_addToList)-1 do {
	lbAdd [_listBox,_addToList # _i];
	lbSetValue [_listBox, _i, _i];
};

lbSort _listboxControl;

//--- Artillery Mode.
_mode = missionNamespace getVariable 'WF_V_ARTILLERYMINMAP';
if (isNil '_mode') then {_mode = 2;missionNamespace setVariable ['WF_V_ARTILLERYMINMAP',_mode]};
_trackingArray = [];
_trackingArrayID = [];
_lastArtyUpdate = -60;
_minRange = 100;
_maxRange = 200;
_requestMarkerTransition = false;
_requestRangedList = true;
_startLoad = true;
_mhqs = [];

//--- Startup coloration.
with uinamespace do {
	currentBEDialog = _display;
	switch (_mode) do {
		case 0: {(currentBEDialog displayCtrl 17023) ctrlSetTextColor [1,1,1,1]};
		case 1: {(currentBEDialog displayCtrl 17023) ctrlSetTextColor [0,0.635294,0.909803,1]};
		case 2: {(currentBEDialog displayCtrl 17023) ctrlSetTextColor [0.6,0.850980,0.917647,1]};
	};
};

lbSetCurSel[_listbox, 0];

if ((missionNamespace getVariable "WF_C_ARTILLERY") == 0) then {
	(_display displayCtrl 17016) ctrlSetStructuredText (parseText Format['<t align="right" color="#FF4747">%1</t>',localize 'STR_WF_Disabled']);
};

_textAnimHandler = [] spawn {};

WF_MenuAction = -1;
mouseButtonUp = -1;

while {alive player && dialog} do {

	if (side player != WF_Client_SideJoined) exitWith {
	    deleteMarkerLocal _marker;
	    deleteMarkerLocal _area;
	    {deleteMarkerLocal _x} forEach _markers;
	    _map ctrlRemoveEventHandler ["Draw", _drawMarkerId];
	    closeDialog 0
	};

	if (!dialog) exitWith {deleteMarkerLocal _marker;deleteMarkerLocal _area;{deleteMarkerLocal _x} forEach _markers};
	
	_logik = (WF_Client_SideJoined) Call WFCO_FNC_GetSideLogic;
	_currentUpgrades = (WF_Client_SideJoined) Call WFCO_FNC_GetSideUpgrades;
	_currentSel = lbCurSel(_listBox);

	//--- Fast travel processing
    if (time - _lastUpdate > 15) then {
        {deleteMarkerLocal _x} forEach _markers;
        _markers = [];
        _FTLocations = [];
        _canFT = false;
        _startPoint = objNull;
        _lastUpdate = time;

        _friendlySides = WF_Client_Logic getVariable ["wf_friendlySides", []];
        {
            if(count _mhqs == 0) then {
                _mhqs = ((_x) Call WFCO_FNC_GetSideHQ)
            } else {
                _mhqs = _mhqs - [objNull];
            _mhqs = _mhqs +  ((_x) Call WFCO_FNC_GetSideHQ)
            }
        } forEach _friendlySides;

        _base = [player,_mhqs] call WFCO_FNC_GetClosestEntity;

        _closestTown = [player, towns] call WFCO_FNC_GetClosestEntity;
        _sideID = _closestTown getVariable "sideID";
        _side = (_sideID) Call WFCO_FNC_GetSideFromID;
        if (side player == _side && player distance _closestTown < _ftr) then {
            _canFT = true;
            _startPoint = _closestTown
        };

        if (!(_canFT) && player distance _base < _ftr && alive _base) then {
            _canFT = true;
            _startPoint = _base
        };

        if (!canMove (vehicle player)) then {_canFT = false};
        if (_canFT) then {
            _buildings = (WF_Client_SideJoined) Call WFCO_FNC_GetSideStructures;
            _checks = [WF_Client_SideJoined,missionNamespace getVariable Format ["WF_%1COMMANDCENTERTYPE",WF_Client_SideJoinedText],_buildings] Call WFCO_FNC_GetFactories;
            _checks = _checks + _mhqs;

            _takenBases = [];
            {
                _town = _x;
                _sideID = _town getVariable "sideID";
                _side = (_sideID) Call WFCO_FNC_GetSideFromID;
                if (_side == WF_Client_SideJoined) then {
                    _townSpecialities = _town getVariable "townSpeciality";
                    if(WF_C_MILITARY_BASE in (_townSpecialities) || WF_C_AIR_BASE in (_townSpecialities)) then {
                        _takenBases pushBack _town
                    }
                }
            } forEach towns;

            if(count _takenBases > 0) then { _checks = _checks + _takenBases };

            _i = 0;
            _fee = 0;
            _funds = Call WFCL_FNC_GetPlayerFunds;
            {
                if (_x distance player > _ftr) then {

                    _sideID = _x getVariable "sideID";
                    _fee = round(((_x distance player)/1000) * (missionNamespace getVariable "WF_C_GAMEPLAY_FAST_TRAVEL_PRICE_KM"));
                    if (_funds < _fee) then {_skip = true};

                    _FTLocations = _FTLocations + [_x];
                    _markerName = Format ["FTMarker%1",_i];
                    _markers = _markers + [_markerName];
                    createMarkerLocal [_markerName,getPos _x];
                    _markerName setMarkerTypeLocal "mil_circle";
                    _markerName setMarkerColorLocal "ColorYellow";
                    _markerName setMarkerSizeLocal [1,1];

                    //--- Fee, Cheap marker stuff
                    _markerName = Format ["FTMarker%1%1",_i];
                    _markers = _markers + [_markerName];
                    createMarkerLocal [_markerName,[(getPos _x select 0)-5,(getPos _x select 1)+75]];
                    _markerName setMarkerTypeLocal "mil_circle";
                    _markerName setMarkerColorLocal "ColorYellow";
                    _markerName setMarkerSizeLocal [0,0];
                    _markerName setMarkerTextLocal Format ["$%1",_fee];

                    _i = _i + 1
                }
            } forEach _checks
        }
    };

	//--- Special changed or a reload is requested.
	if (_currentSel != _lastSel || _forceReload) then {
		_currentValue = lbValue[_listBox, _currentSel];

		_currentSpecial = _addToListID # _currentValue;
		_currentFee = _addToListFee # _currentValue;

	    _currentGroupSize = count ((Units (WF_Client_Team)) Call WFCO_FNC_GetLiveUnits);
		_currentInterval = _addToListInterval # _currentValue;
		_forceReload = false;
		_controlEnable = false;

		_funds = Call WFCL_FNC_GetPlayerFunds;

		ctrlSetText[17021,Format ["$%1",_currentFee]];

		//--- Enabled or disabled?
		switch (_currentSpecial) do {
		    case "Fast_Travel": {
                _controlEnable = if (count _FTLocations > 0) then {true} else {false}
            };
			case "Cruise Missile": {
				if ((missionNamespace getVariable "WF_C_MODULE_WF_CRUISE_MISSILE") > 0) then {
				    _controlEnable = false;
					_commander = false;
					if (!isNull(commanderTeam)) then {
						if (commanderTeam == WF_Client_Team) then {_commander = true};
					_currentLevel = _currentUpgrades # WF_UP_CRUISE_MISSILE;
                        _controlEnable = (_currentLevel > 0 && _commander && _funds >= _currentFee && time - lastCruiseMissileCall > _currentInterval)
					}
				}
			};
			case "Chemical Missile": {
				if ((missionNamespace getVariable "WF_C_MODULE_WF_CRUISE_MISSILE") > 0) then {
				    _controlEnable = false;
					_commander = false;
					if (!isNull(commanderTeam)) then {
						if (commanderTeam == WF_Client_Team) then {_commander = true};
                        _currentLevel = _currentUpgrades # WF_UP_CRUISE_MISSILE;
                        _controlEnable = (_currentLevel > 0 && _commander && _funds >= _currentFee && time - lastChemicalMissileCall > _currentInterval)
					}
				}
			};
			case "CAS": {
			    _controlEnable = false;
			    if (!isNull(commanderTeam)) then {
                    _controlEnable = ((commanderTeam == WF_Client_Team) && _funds >= _currentFee && time - lastCasCall > _currentInterval)
                }
			};
			case "ParatroopersHC": {
			    _currentLevel = _currentUpgrades # WF_UP_PARATROOPERS;
			    _hcAllowedGroupAmount = WF_C_HIGH_COMMAND_MIN_GROUP_AMOUNT + ( (((WF_Client_SideJoined) call WFCO_FNC_GetSideUpgrades) # WF_UP_HC_GROUP_AMOUNT) * 2 );
			    _currentHCGroupAmount = (count ([WF_Client_SideJoined] call WFCO_FNC_getHighCommandGroups)) + groupQueu;
                _controlEnable = (_funds >= _currentFee && _currentLevel > 0 && time - lastParaCall > _currentInterval && _currentHCGroupAmount <= _hcAllowedGroupAmount);
                if(_currentHCGroupAmount >= _hcAllowedGroupAmount) then {
                    [format ["%1", localize "STR_WF_INFO_Paratroop_NotAllowed"]] spawn WFCL_fnc_handleMessage
                };
			};
			case "Paratroopers": {
				_currentLevel = _currentUpgrades # WF_UP_PARATROOPERS;
				_controlEnable = (_funds >= _currentFee && _currentLevel > 0 && time - lastParaCall > _currentInterval && _currentGroupSize <= WF_C_PLAYERS_AI_MAX);
				if(_currentGroupSize > WF_C_PLAYERS_AI_MAX) then {
				    [format ["%1", localize "STR_WF_INFO_Paratroop_NotAllowed"]] spawn WFCL_fnc_handleMessage
				};
			};
			case "HeliParatroopersHC": {
                _currentLevel = _currentUpgrades # WF_UP_PARATROOPERS;
                _hcAllowedGroupAmount = WF_C_HIGH_COMMAND_MIN_GROUP_AMOUNT + ( (((WF_Client_SideJoined) call WFCO_FNC_GetSideUpgrades) # WF_UP_HC_GROUP_AMOUNT) * 2 );
                _currentHCGroupAmount = (count ([WF_Client_SideJoined] call WFCO_FNC_getHighCommandGroups)) + groupQueu;
                _controlEnable = (_funds >= _currentFee && _currentLevel > 0 && time - lastParaCall > _currentInterval && _currentHCGroupAmount <= _hcAllowedGroupAmount);
                if(_currentHCGroupAmount >= _hcAllowedGroupAmount) then {
                    [format ["%1", localize "STR_WF_INFO_Paratroop_NotAllowed"]] spawn WFCL_fnc_handleMessage
                };
			};
			case "HeliParatroopers": {
                _currentLevel = _currentUpgrades # WF_UP_PARATROOPERS;
                _controlEnable = (_funds >= _currentFee && _currentLevel > 0 && time - lastParaCall > _currentInterval && _currentGroupSize <= WF_C_PLAYERS_AI_MAX);
                if(_currentGroupSize > WF_C_PLAYERS_AI_MAX) then {
                    [format ["%1", localize "STR_WF_INFO_Paratroop_NotAllowed"]] spawn WFCL_fnc_handleMessage
                };
			};
			case "Paradrop_Vehicle": {
				_currentLevel = _currentUpgrades # WF_UP_SUPPLYPARADROP;
				_controlEnable = (_funds >= _currentFee && _currentLevel > 0 && time - lastSupplyCall > _currentInterval);
			}
		};

		ctrlEnable[17020, _controlEnable];

		WF_MenuAction = -1;
	};

	//--- Request Asset.
	if (WF_MenuAction == 20) then {
		WF_MenuAction = -1;

		//--- Output.
		switch (_currentSpecial) do {
		    case "Fast_Travel": {
                WF_MenuAction = 7;
                if !(scriptDone _textAnimHandler) then {terminate _textAnimHandler};
                _textAnimHandler = [17022,localize 'STR_WF_TACTICAL_ClickOnMap',10,"ff9900"] spawn WFCL_FNC_SetControlFadeAnim;
            };
			case "Cruise Missile": {
				WF_MenuAction = 8;
				if !(scriptDone _textAnimHandler) then {terminate _textAnimHandler};
				_textAnimHandler = [17022,localize 'STR_WF_TACTICAL_ClickOnMap',10,"ff9900"] spawn WFCL_FNC_SetControlFadeAnim;
			};
			case "Chemical Missile": {
				WF_MenuAction = 11;
				if !(scriptDone _textAnimHandler) then {terminate _textAnimHandler};
				_textAnimHandler = [17022,localize 'STR_WF_TACTICAL_ClickOnMap',10,"ff9900"] spawn WFCL_FNC_SetControlFadeAnim;
			};
			case "CAS": {
			    WF_MenuAction = 10;
                if !(scriptDone _textAnimHandler) then {terminate _textAnimHandler};
                _textAnimHandler = [17022,localize 'STR_WF_TACTICAL_ClickOnMap',10,"ff9900"] spawn WFCL_FNC_SetControlFadeAnim;
			};
			case "Paratroopers": {
				WF_MenuAction = 3;
				if !(scriptDone _textAnimHandler) then {terminate _textAnimHandler};
				_textAnimHandler = [17022,localize 'STR_WF_TACTICAL_ClickOnMap',10,"ff9900"] spawn WFCL_FNC_SetControlFadeAnim;
			};
			case "ParatroopersHC": {
				WF_MenuAction = 5;
				if !(scriptDone _textAnimHandler) then {terminate _textAnimHandler};
				_textAnimHandler = [17022,localize 'STR_WF_TACTICAL_ClickOnMap',10,"ff9900"] spawn WFCL_FNC_SetControlFadeAnim;
			};
			case "HeliParatroopers": {
                WF_MenuAction = 4;
				if !(scriptDone _textAnimHandler) then {terminate _textAnimHandler};
				_textAnimHandler = [17022,localize 'STR_WF_TACTICAL_ClickOnMap',10,"ff9900"] spawn WFCL_FNC_SetControlFadeAnim;
			};
			case "HeliParatroopersHC": {
                WF_MenuAction = 6;
                if !(scriptDone _textAnimHandler) then {terminate _textAnimHandler};
                _textAnimHandler = [17022,localize 'STR_WF_TACTICAL_ClickOnMap',10,"ff9900"] spawn WFCL_FNC_SetControlFadeAnim;
            };
			case "Paradrop_Vehicle": {
				WF_MenuAction = 9;

				if !(scriptDone _textAnimHandler) then {terminate _textAnimHandler};
				_textAnimHandler = [17022,localize 'STR_WF_TACTICAL_ClickOnMap',10,"ff9900"] spawn WFCL_FNC_SetControlFadeAnim;
			}
		};
	};

	artyRange = floor (sliderPosition 17005);
	if (_lastRange != artyRange) then {_area setMarkerSizeLocal [artyRange,artyRange];};

	if (mouseButtonUp == 0) then {
		mouseButtonUp = -1;
		//--- Set Artillery Marker on map.
		if (WF_MenuAction == 1) then {
			WF_MenuAction = -1;
			artyPos = _map posScreenToWorld[mouseX,mouseY];
			_marker setMarkerPosLocal artyPos;
			_area setMarkerPosLocal artyPos;
			_requestRangedList = true;
		};
		//--- Paratroops.
		if (WF_MenuAction == 3) then {
			WF_MenuAction = -1;
			_forceReload = true;
			if !(scriptDone _textAnimHandler) then {terminate _textAnimHandler};
			[17022] Call WFCL_FNC_SetControlFadeAnimStop;
			_callPos = _map posScreenToWorld[mouseX,mouseY];
			if (!surfaceIsWater _callPos) then {
				lastParaCall = time;
				-(_currentFee) Call WFCL_FNC_ChangePlayerFunds;
				[WF_Client_SideJoined, _callPos, WF_Client_Team, WF_C_PLAYERS_AI_MAX, false] remoteExec ["WFCO_FNC_Paratroopers",2];
				[format ["%1", localize "STR_WF_INFO_Paratroop_Info"]] spawn WFCL_fnc_handleMessage
			};
		};

		//--- Paratroops HC.
        if (WF_MenuAction == 5) then {
            WF_MenuAction = -1;
            _forceReload = true;
            if !(scriptDone _textAnimHandler) then {terminate _textAnimHandler};
            [17022] Call WFCL_FNC_SetControlFadeAnimStop;
            _callPos = _map posScreenToWorld[mouseX,mouseY];
            if (!surfaceIsWater _callPos) then {
                lastParaCall = time;
                -(_currentFee) Call WFCL_FNC_ChangePlayerFunds;
                [WF_Client_SideJoined, _callPos, WF_Client_Team, WF_C_PLAYERS_AI_MAX, true] remoteExec ["WFCO_FNC_Paratroopers",2];
                [format ["%1", localize "STR_WF_INFO_Paratroop_Info"]] spawn WFCL_fnc_handleMessage
            };
        };

		//--- Heli Paratroops.
        if (WF_MenuAction == 4) then {
            WF_MenuAction = -1;
            _forceReload = true;
            if !(scriptDone _textAnimHandler) then {terminate _textAnimHandler};
            [17022] Call WFCL_FNC_SetControlFadeAnimStop;
            _callPos = _map posScreenToWorld[mouseX,mouseY];
            _height = getTerrainHeightASL [_callPos # 0, _callPos # 1];
            _callPos = [_callPos # 0, _callPos # 1, _height];

            if (!surfaceIsWater _callPos) then {
                lastParaCall = time;
                -(_currentFee) Call WFCL_FNC_ChangePlayerFunds;
                [WF_Client_SideJoined, _callPos, WF_Client_Team, WF_C_PLAYERS_AI_MAX, false] remoteExec ["WFCO_FNC_HeliParatroopers",2];
				[format ["%1", localize "STR_WF_INFO_Paratroop_Info"]] spawn WFCL_fnc_handleMessage;
			};
		};

		//--- Heli Paratroops HC.
        if (WF_MenuAction == 6) then {
            WF_MenuAction = -1;
            _forceReload = true;
            if !(scriptDone _textAnimHandler) then {terminate _textAnimHandler};
            [17022] Call WFCL_FNC_SetControlFadeAnimStop;
            _callPos = _map posScreenToWorld[mouseX,mouseY];
            _height = getTerrainHeightASL [_callPos # 0, _callPos # 1];
            _callPos = [_callPos # 0, _callPos # 1, _height];

            if (!surfaceIsWater _callPos) then {
                lastParaCall = time;
                -(_currentFee) Call WFCL_FNC_ChangePlayerFunds;
                [WF_Client_SideJoined, _callPos, WF_Client_Team, WF_C_PLAYERS_AI_MAX, true] remoteExec ["WFCO_FNC_HeliParatroopers",2];
				[format ["%1", localize "STR_WF_INFO_Paratroop_Info"]] spawn WFCL_fnc_handleMessage;
			};
		};
		
		//--- Fast Travel.
        if (WF_MenuAction == 7) then {
            WF_MenuAction = -1;
            _forceReload = true;
            if !(scriptDone _textAnimHandler) then {terminate _textAnimHandler};
            [17022] Call WFCL_FNC_SetControlFadeAnimStop;
            _callPos = _map PosScreenToWorld[mouseX,mouseY];
            _destination = [_callPos,_FTLocations] Call WFCO_FNC_GetClosestEntity;
            if (_callPos distance _destination < 500) then {
                _map ctrlRemoveEventHandler ["Draw", _drawMarkerId];
                closeDialog 0;
                deleteMarkerLocal _marker;
                deleteMarkerLocal _area;

                //--- Remove Markers.
                {
                    _track = (_x # 0);
                    _vehicle = (_x # 1);

                    _vehicle setVariable ['WF_A_Tracked', nil];

                    deleteMarkerLocal Format ["WF_A_Large%1",_track];
                    deleteMarkerLocal Format ["WF_A_Small%1",_track];
                } forEach _trackingArrayID;
                _mode = -1;

                _fee = round(((player distance _destination)/1000) * (missionNamespace getVariable "WF_C_GAMEPLAY_FAST_TRAVEL_PRICE_KM"));
                -(_fee) Call WFCL_FNC_ChangePlayerFunds;

                _travelingWith = [];
                {
                    if (_x distance _startPoint < _ftr && !(_x in _travelingWith) && canMove _x
                        && !(vehicle _x isKindOf "StaticWeapon") && !stopped _x
                            && !((currentCommand _x) in ["WAIT","STOP"])) then {
                                _travelingWith pushBack (vehicle _x)
                    }
                } forEach units (WF_Client_Team);

                ForceMap true;
                _compass = shownCompass;
                _GPS = shownGPS;
                _pad = shownPad;
                _radio = shownRadio;
                _watch = shownWatch;

                showCompass false;
                showGPS false;
                showPad false;
                showRadio false;
                showWatch false;

                mapAnimClear;
                mapAnimCommit;

                _locationPosition = getPosATL _destination;
                _camera = "camera" camCreate _locationPosition;
                _camera camSetDir [0, 0, 0];
                _camera camSetFov 1;
                _camera cameraEffect["Internal","TOP"];

                _camera camSetTarget _locationPosition;
                _camera camSetPos [_locationPosition select 0,(_locationPosition select 1) + 2,100];
                _camera camCommit 0;

                mapAnimAdd [0,0.05,GetPos _startPoint];
                mapAnimCommit;

                _delay = ((_startPoint distance _destination) / 50) * (missionNamespace getVariable "WF_C_GAMEPLAY_FAST_TRAVEL_TIME_COEF");
                mapAnimAdd [_delay,.18,getPos _destination];
                mapAnimCommit;

                waitUntil {mapAnimDone || !alive player};
                _skip = false;
                if (!alive player) then {_skip = true};
                if (!_skip) then {
                    {
                        _emptyPosition = [_locationPosition, 120] call WFCO_fnc_getEmptyPosition;
                        _x setPosATL _emptyPosition;
                        _x setVectorUp surfaceNormal position _x
                    } forEach _travelingWith;
                };
                sleep 1;

                ForceMap false;
                showCompass _compass;
                showGPS _GPS;
                showPad _pad;
                showRadio _radio;
                showWatch _watch;

                _camera cameraEffect["TERMINATE","BACK"];
                camDestroy _camera;
            };
        };
		
		//--- Cruise Missile Strike.
		if (WF_MenuAction == 8) then {
			_forceReload = true;
			if !(scriptDone _textAnimHandler) then {terminate _textAnimHandler};
			[17022] Call WFCL_FNC_SetControlFadeAnimStop;
			WF_MenuAction = -1;
			-_currentFee Call WFCL_FNC_ChangePlayerFunds;
			_callPos = _map PosScreenToWorld[mouseX,mouseY];
			_obj = "Land_HelipadEmpty_F" createVehicle _callPos;
			_nukeMarker = createMarkerLocal ["cruiseMissileStrike", _callPos];
			_nukeMarker setMarkerTypeLocal "mil_warning";
			_nukeMarker setMarkerTextLocal "Cruise Missile Strike";
			_nukeMarker setMarkerColorLocal "ColorRed";
			lastCruiseMissileCall = time;
			
			[_obj,_nukeMarker] spawn WFCL_FNC_CruiseMissileIncoming
		};

		//--- Chemical Missile Strike.
		if (WF_MenuAction == 11) then {
			_forceReload = true;
			if !(scriptDone _textAnimHandler) then {terminate _textAnimHandler};
			[17022] Call WFCL_FNC_SetControlFadeAnimStop;
			WF_MenuAction = -1;
			-_currentFee Call WFCL_FNC_ChangePlayerFunds;
			_callPos = _map PosScreenToWorld[mouseX,mouseY];
			_obj = "Land_HelipadEmpty_F" createVehicle _callPos;
			_nukeMarker = createMarkerLocal ["chemicalMissileStrike", _callPos];
			_nukeMarker setMarkerTypeLocal "mil_warning";
			_nukeMarker setMarkerTextLocal "Chemical Missile Strike";
			_nukeMarker setMarkerColorLocal "ColorRed";
			lastChemicalMissileCall = time;

			[_obj,_nukeMarker] spawn WFCL_FNC_ChemicalMissileIncoming
		};
		//--- Vehicle Paradrop.
		if (WF_MenuAction == 9) then {
			_forceReload = true;
			if !(scriptDone _textAnimHandler) then {terminate _textAnimHandler};
			[17022] Call WFCL_FNC_SetControlFadeAnimStop;
			WF_MenuAction = -1;
			lastSupplyCall = time;
			-_currentFee Call WFCL_FNC_ChangePlayerFunds;
			_callPos = _map PosScreenToWorld[mouseX,mouseY];
			[WF_Client_SideJoined,_callPos,WF_Client_Team] remoteExec ["WFCO_FNC_ParaVehicles",2];
		};

		//--- CAS request
		if (WF_MenuAction == 10) then {
            _forceReload = true;
            if !(scriptDone _textAnimHandler) then {terminate _textAnimHandler};
            [17022] Call WFCL_FNC_SetControlFadeAnimStop;
            WF_MenuAction = -1;
            lastCasCall = time;
            -_currentFee Call WFCL_FNC_ChangePlayerFunds;
            _callPos = _map PosScreenToWorld[mouseX, mouseY];

            [WF_Client_SideJoined, _callPos] remoteExec ["WFCO_FNC_casRequest",2];
            [format ["%1", localize "STR_WF_INFO_Cas_Info"]] spawn WFCL_fnc_handleMessage;
        };
	};
	
	//--- Update the Artillery Status.
	if ((missionNamespace getVariable "WF_C_ARTILLERY") > 0) then {
		_fireTime = (missionNamespace getVariable "WF_C_ARTILLERY_INTERVALS") # (_currentUpgrades # WF_UP_ARTYTIMEOUT);
		_status = round(_fireTime - (time - fireMissionTime));
		_txt = [Format ['<t align="left" color="#4782FF">%1 %2</t>',_status,localize 'STR_WF_Seconds'], Format['<t align="left" color="#73FF47">%1</t>',localize 'STR_WF_TACTICAL_Available']] select (time - fireMissionTime > _fireTime);
		(_display displayCtrl 17016) ctrlSetStructuredText (parseText _txt);
		_enable = !(_status > 0);
		if(WF_Debug) then { _enable = true; };
		ctrlEnable [17007,_enable];
	};
	
	//--- Request Fire Mission.
	if (WF_MenuAction == 2) then {
		WF_MenuAction = -1;
		_units = [WF_Client_Team,true,lbCurSel(17008),WF_Client_SideJoinedText,_logik] Call WFCO_FNC_GetTeamArtillery;
		if (Count _units > 0) then {
		    _isScud = false;
		    {
		        if (typeOf _x == WF_MOBILE_TACTICAL_MISSILE_LAUNCHER_TYPE) exitWith {
		            _isScud = true;
		            [_x, 15] execVM "\cwr3\vehicles\cwr3_scud\functions\scud_launch.sqf"
		        }
		    } forEach _units;
			fireMissionTime = time;
		    if (_isScud) then {
		        _callPos = _map PosScreenToWorld[mouseX,mouseY];
                ["Land_HelipadEmpty_F" createVehicle _callPos] spawn WFCL_FNC_NukeIncoming;
		    } else {
			[GetMarkerPos "artilleryMarker", lbCurSel(17008), lbCurSel(17034), _logik, _units] Spawn WFCL_FNC_RequestFireMission;
		    }
		} else {
			[format ["%1", localize "STR_WF_INFO_NoArty"]] spawn WFCL_fnc_handleMessage
		};			
	};
	
	//--- Arty Combo Change or Script init.
	if (WF_MenuAction == 200 || _startLoad) then {
		WF_MenuAction = -1;
		_index = lbCurSel(17008);

		lnbClear 17034;
		{
            lbAdd[17034, getText (configFile >> "CfgMagazines" >> _x >> "displayName")]
        } forEach ( (missionNamespace getVariable Format ["WF_%1_ARTILLERY_EXTENDED_MAGS", WF_Client_SideJoinedText]) # _index );
		
		_minRange = (missionNamespace getVariable Format ["WF_%1_ARTILLERY_RANGES_MIN",WF_Client_SideJoined]) # _index;
		_maxRange = round(((missionNamespace getVariable Format ["WF_%1_ARTILLERY_RANGES_MAX",WF_Client_SideJoined]) # _index) / (missionNamespace getVariable "WF_C_ARTILLERY"));

		_trackingArray = [WF_Client_Team,true,lbCurSel(17008),WF_Client_SideJoined,_logik] Call WFCO_FNC_GetTeamArtillery;
		
		_requestMarkerTransition = true;
		_requestRangedList = true;
		_startLoad = false;
	};
	
	//--- Focus on an artillery cannon.
	if (WF_MenuAction == 60) then {
		WF_MenuAction = -1;
		
		ctrlMapAnimClear _map;
		_map ctrlMapAnimAdd [1,.475,getPos(_trackingArray # (lnbCurSelRow 17024))];
		ctrlMapAnimCommit _map;
	};
	
	//--- Flush on change.
	if (_requestMarkerTransition) then {
		_requestMarkerTransition = false;
		
		{
			_track = (_x # 0);
			_vehicle = (_x # 1);

			_vehicle setVariable ['WF_A_Tracked', nil];
			deleteMarkerLocal Format ["WF_A_Large%1",_track];
			deleteMarkerLocal Format ["WF_A_Small%1",_track];
		} forEach _trackingArrayID;
		_trackingArrayID = [];
	};
	
	//--- Artillery List.
	if ((missionNamespace getVariable "WF_C_ARTILLERY") > 0 && (_requestRangedList || time - _lastArtyUpdate > 3)) then {
		_requestRangedList = false;
		
		//--- No need to update the list all the time.
		if (time - _lastArtyUpdate > 5) then {
			_lastArtyUpdate = time;
			_trackingArray = [WF_Client_Team,true,lbCurSel(17008),WF_Client_SideJoined,_logik] Call WFCO_FNC_GetTeamArtillery;
		};
		
		//--- Clear & Fill;
		lnbClear 17024;
		_i = 0;
		{
            _artillery = _x;
		    _magazineRangeOk = false;

		    if(artypos inRangeOfArtillery [[_artillery], currentMagazine _artillery]) then {
		        _magazineRangeOk = true
		    } else {
		        if (typeOf _artillery == WF_MOBILE_TACTICAL_MISSILE_LAUNCHER_TYPE) then { _magazineRangeOk = true }
		    };

            _text = localize 'STR_WF_TACTICAL_ArtilleryInRange'; 																		//"In Range";
			_color = [0, 0.875, 0, 0.8];
		    if(_magazineRangeOk) then {
		        _distance = _artillery distance (getMarkerPos _marker);

                if (_distance > _maxRange) then {_color = [0.875, 0, 0, 0.8];_text = localize 'STR_WF_TACTICAL_ArtilleryOutOfRange'}; 	 //"Out of Range";
                if (_distance <= _minRange) then {_color = [0.875, 0.5, 0, 0.8];_text = localize 'STR_WF_TACTICAL_ArtilleryRangeTooClose'}; //"Too close";
		    } else {
		        _color = [0.875, 0, 0, 0.8];_text = localize 'STR_WF_TACTICAL_ArtilleryRangeTooClose'
		    };

		    _noAmmo = false;
		    _weapons = _artillery weaponsTurret [0];
		    {
                if((_artillery ammo _x) == 0) then { _noAmmo = true }
            } forEach _weapons;

            if(_noAmmo) then {
                _color = [0.875, 0, 0, 0.8];_text = localize 'STR_WF_TACTICAL_ArtilleryNoAmmo'
            };

		    lnbAddRow [17024,[[typeOf _artillery, 'displayName'] Call WFCO_FNC_GetConfigInfo,_text]];
            lnbSetPicture [17024,[_i,0],[typeOf _artillery, 'picture'] Call WFCO_FNC_GetConfigInfo];
			
			lnbSetColor [17024,[_i,0],_color];
			lnbSetColor [17024,[_i,1],_color];
			_i = _i + 1;
		} forEach _trackingArray;
	};
	
	//--- Update artillery display.
	if (_mode != -1) then {
	
		//--- Nothing.
		if (_mode == 0) then {
			_requestMarkerTransition = true;
			_mode = -1;
		};
			
		//--- Filled Content.
		if (_mode == 1 || _mode == 2) then {
			//--- Remove if dead or null or sel changed.
			{
				_track = (_x # 0);
				_vehicle = (_x # 1);
				
				if !(alive _vehicle) then {
					deleteMarkerLocal Format ["WF_A_Large%1",_track];
					deleteMarkerLocal Format ["WF_A_Small%1",_track];
				};
			} forEach _trackingArrayID;
			
			//--- No need to update the marker all the time.
			if (time - _lastArtyUpdate > 5) then {
				_lastArtyUpdate = time;
				_trackingArray = [WF_Client_Team,true,lbCurSel(17008),WF_Client_SideJoined,_logik] Call WFCO_FNC_GetTeamArtillery;
			};
			
			//--- Live Feed.
			_trackingArrayID = [];
			{
				_track = _x getVariable 'WF_A_Tracked';
				if (isNil '_track') then {
					_track = buildingMarker;
					buildingMarker = buildingMarker + 1;
					_x setVariable ['WF_A_Tracked', _track];
					_dmarker = Format ["WF_A_Large%1",_track];
					createMarkerLocal [_dmarker, getPos _x];
					_dmarker setMarkerColorLocal "ColorBlue";
					_dmarker setMarkerShapeLocal "ELLIPSE";
					_brush = "SOLID";
					if (_mode == 1) then {_brush = "SOLID"};
					if (_mode == 2) then {_brush = "BORDER"};
					_dmarker setMarkerBrushLocal _brush;
					_dmarker setMarkerAlphaLocal 0.4;
					_dmarker setMarkerSizeLocal [_maxRange,_maxRange];
					_dmarker = Format ["WF_A_Small%1",_track];
					createMarkerLocal [_dmarker, getPos _x];
					_dmarker setMarkerColorLocal "ColorBlack";
					_dmarker setMarkerShapeLocal "ELLIPSE";
					_dmarker setMarkerBrushLocal "SOLID";
					_dmarker setMarkerAlphaLocal 0.4;
					_dmarker setMarkerSizeLocal [_minRange,_minRange];
				} else {
					_dmarker = Format ["WF_A_Large%1",_track];
					_dmarker setMarkerPosLocal (getPos _x);
					_dmarker = Format ["WF_A_Small%1",_track];
					_dmarker setMarkerPosLocal (getPos _x);
				};
				_trackingArrayID = _trackingArrayID + [[_track,_x]];
			} forEach _trackingArray;
		};
	};
	
	_lastRange = artyRange;
	_lastSel = lbCurSel(_listbox);
	sleep 0.1;
	
	//--- Back Button.
	if (WF_MenuAction == 30) exitWith { //---added-MrNiceGuy
		WF_MenuAction = -1;
		closeDialog 0;
		createDialog "WF_Menu"
	};
};

deleteMarkerLocal _marker;
deleteMarkerLocal _area;
{deleteMarkerLocal _x} forEach _markers;

if !(scriptDone _textAnimHandler) then {terminate _textAnimHandler};
//--- Remove Markers.
{
	_track = (_x # 0);
	_vehicle = (_x # 1);
	
	_vehicle setVariable ['WF_A_Tracked', nil];

	deleteMarkerLocal Format ["WF_A_Large%1",_track];
	deleteMarkerLocal Format ["WF_A_Small%1",_track];
} forEach _trackingArrayID;