private ["_canRequest","_canRequestOutsideBase","_playerAreas","_areaRange"];

_logic = _this # 3;
_startPos = _this # 4;
_sources = _this # 5;

_source = objNull;
if(typeName _sources == "ARRAY") then {
    _source = [player, _sources] call WFCO_FNC_GetClosestEntity
} else {
    _source = _sources;
};

if !(alive _source) exitWith {};

//--- Area limits.
_root = "REPAIR";
_mhqs = (WF_Client_SideJoined) Call WFCO_FNC_GetSideHQ;
_hq = [player,_mhqs] call WFCO_FNC_GetClosestEntity;
_tooFar = false;

if (_source == _hq) then {_root = "HQ"};
if ((missionNamespace getVariable "WF_C_BASE_AREA") > 0) then {
    if (_source == _hq) then {
        if (count(WF_Client_Logic getVariable "wf_basearea") >= (missionNamespace getVariable "WF_C_BASE_AREA")) then {
            _startpos = [_startPos,WF_Client_Logic getVariable "wf_basearea"] Call WFCO_FNC_GetClosestEntity;
            if (_source distance _startpos > (missionNamespace getVariable "WF_C_BASE_HQ_BUILD_RANGE")) exitWith {_tooFar = true};
        };
    };
};


if (isNil 'WF_COIN_Root') then {WF_COIN_Root = ""};
if (WF_COIN_Root != _root) then {lastBuilt = []};
WF_COIN_Root = _root;

if (_tooFar) exitWith {
    [format ["%1", localize 'STR_WF_INFO_BaseArea_Reached']] spawn WFCL_fnc_handleMessage
};//--- Base area reached.

//--- Call in the construction interface.
112200 cutrsc ["WF_ConstructionInterface","plain"]; //---added-MrNiceGuy
uiNamespace setVariable ["COIN_displayMain",finddisplay 46];

//--- Terminate of system is already running
if !(isNil {player getVariable "bis_coin_logic"}) exitWith {};
player setVariable ["bis_coin_logic",_logic];
bis_coin_player = player;

_originalHudOn = hudOn;
if (hudOn) then {
    hudOn = !hudOn;
    ctrlSetText[13020, "HUD OFF"];
};

//--- Convert the startpos to array if needed (base area).
if (_startPos isEqualType objNull) then {_startPos = getPos _startPos};

_camera = nil;
if (isNil "BIS_CONTROL_CAM") then {
	_camera = "camconstruct" camCreate [position player select 0,position player select 1,15];
	_camera cameraEffect ["internal","back"];
	_camera camPrepareFov 0.900;
	_camera camPrepareFocus [-1,-1];
	_camera camCommitPrepared 0;
	cameraEffectEnableHUD true;
	_camera setdir direction player;
	[_camera,-30,0] call BIS_fnc_setPitchBank;
	_camera camConstuctionSetParams ([_startPos] + (_logic getVariable "BIS_COIN_areasize"));
};
BIS_CONTROL_CAM = _camera;
BIS_CONTROL_CAM_LMB = false;
BIS_CONTROL_CAM_RMB = false;

//--- Prevent uikey override for other mods.
WF_COIN_DEH1 = (uiNamespace getVariable "COIN_displayMain") displayAddEventHandler ["KeyDown",		"if !(isNil 'BIS_CONTROL_CAM_Handler') then {BIS_temp = ['keydown',_this,commandingMenu] spawn BIS_CONTROL_CAM_Handler; BIS_temp = nil;}"];
WF_COIN_DEH2 = (uiNamespace getVariable "COIN_displayMain") displayAddEventHandler ["KeyUp",		"if !(isNil 'BIS_CONTROL_CAM_Handler') then {BIS_temp = ['keyup',_this] spawn BIS_CONTROL_CAM_Handler; BIS_temp = nil;}"];
WF_COIN_DEH3 = (uiNamespace getVariable "COIN_displayMain") displayAddEventHandler ["MouseButtonDown",	"if !(isNil 'BIS_CONTROL_CAM_Handler') then {BIS_temp = ['mousedown',_this,commandingMenu] spawn BIS_CONTROL_CAM_Handler; BIS_temp = nil; BIS_CONTROL_CAM_onMouseButtonDown = _this; if (_this select 1 == 1) then {BIS_CONTROL_CAM_RMB = true}; if (_this select 1 == 0) then {BIS_CONTROL_CAM_LMB = true};}"];
WF_COIN_DEH4 = (uiNamespace getVariable "COIN_displayMain") displayAddEventHandler ["MouseButtonUp",	"if !(isNil 'BIS_CONTROL_CAM_Handler') then {BIS_CONTROL_CAM_RMB = false; BIS_CONTROL_CAM_LMB = false;}"];

BIS_CONTROL_CAM_keys = [];

if (isNil "BIS_CONTROL_CAM_ASL") then {
	createCenter sideLogic;
	_logicGrp = createGroup sidelogic;
	_logicASL = _logicGrp createUnit ["Logic",position player,[],0,"none"];
	BIS_CONTROL_CAM_ASL = _logicASL;
};

_showConstructionMode = {
    _optionValues = [
        format ["%1", if (WF_AutoWallConstructingEnabled) then {localize "STR_WF_On"} else {localize "STR_WF_Off"}],
        format ["%1", if (WF_AutoManningDefense) then {localize "STR_WF_On"} else {localize "STR_WF_Off"}]
    ];

    _optionDescription = [];
    _optionDescription pushBackUnique (format ["%1:          ", localize "STR_WF_AutoWall"]);
    _optionDescription pushBackUnique (format ["%1:  ", localize "STR_WF_AutoDefense"]);

    _optionValuesCount = count _optionValues;
    _optionSize = [2.8 / _optionValuesCount, 2] select (_optionValuesCount <= 1);
    _optionText = format ["<t color='#00FF00' shadow='2' size='%1' align='left' valign='middle'>",_optionSize];
    _optionLines = 0;
    for "_i" from 0 to 1 do {
        _optionText = _optionText + format ["%1 %2<br />", _optionDescription # _i];
        _optionLines = _optionLines + 0.05;
    };

    _optionText = _optionText + "</t>";
    _optionPos = ctrlPosition ((uiNamespace getVariable "wf_title_coin") displayCtrl 112225);
    ((uiNamespace getVariable "wf_title_coin") displayCtrl 112225) ctrlSetStructuredText (parseText _optionText);
    ((uiNamespace getVariable "wf_title_coin") displayCtrl 112225) ctrlSetPosition [_optionPos # 0,_optionPos # 1,_optionPos # 2,(_optionPos # 3) + _optionLines];
    ((uiNamespace getVariable "wf_title_coin") displayCtrl 112225) ctrlShow true;
    ((uiNamespace getVariable "wf_title_coin") displayCtrl 112225) ctrlCommit 0;

    _optionTextValue = format ["<t color='#00FF00' shadow='2' size='%1' align='left' valign='middle'>",_optionSize];
    for "_i" from 0 to 1 do {
        _optionTextValue = _optionTextValue + format["%1<br />", _optionValues # _i];
        _optionLines = _optionLines + 0.05;
    };

    _optionTextValue = _optionTextValue + "</t>";
    _optionPos = ctrlPosition ((uiNamespace getVariable "wf_title_coin") displayCtrl 112227);
    ((uiNamespace getVariable "wf_title_coin") displayCtrl 112227) ctrlSetStructuredText (parseText _optionTextValue);
    ((uiNamespace getVariable "wf_title_coin") displayCtrl 112227) ctrlSetPosition [_optionPos # 0,_optionPos # 1,_optionPos # 2,(_optionPos # 3) + _optionLines];
    ((uiNamespace getVariable "wf_title_coin") displayCtrl 112227) ctrlShow true;
    ((uiNamespace getVariable "wf_title_coin") displayCtrl 112227) ctrlCommit 0;
};

_logic setVariable ["BIS_COIN_selected",objNull];
_logic setVariable ["BIS_COIN_params",[]];
_logic setVariable ["BIS_COIN_tooltip",""];
_logic setVariable ["BIS_COIN_menu","#USER:BIS_Coin_categories_0"];
_get = _logic getVariable 'WF_NVGPersistent';
_nvgstate = true;
if (isNil '_get') then {
	_nvgstate = (daytime > 18.5 || daytime < 5.5);
	_logic setVariable ['WF_NVGPersistent',_nvgstate];
} else {
	_nvgstate = _logic getVariable 'WF_NVGPersistent';
};
camUseNVG _nvgstate;
_logic setVariable ["BIS_COIN_nvg",_nvgstate];

_bns = missionNamespace getVariable Format["WF_%1STRUCTURENAMES",WF_Client_SideJoinedText];
_greenList = missionNamespace getVariable "COIN_UseHelper";
//--- Building Limit Init.
_buildingsNames = _bns;
_buildingsNames = _buildingsNames - [_buildingsNames select 0];
_buildingsType = missionNamespace getVariable Format["WF_%1STRUCTURES",WF_Client_SideJoinedText];
_buildingsType = _buildingsType - [_buildingsType select 0];

//--- Open menu
_logic spawn {
	_logic = _this;
	waitUntil {!isNil {_this getVariable "BIS_COIN_fundsOld"}};
	while {!isNil "BIS_CONTROL_CAM"} do {
		waitUntil {
			_params = _logic getVariable "BIS_COIN_params";
			if (isNil "_params") then {_params = []};
			(commandingMenu == "" && count _params == 0 && !BIS_CONTROL_CAM_RMB) || isNil "BIS_CONTROL_CAM"
		};
		if (isNil "BIS_CONTROL_CAM") exitWith {};
		showCommandingMenu "#USER:BIS_Coin_categories_0";
		sleep 0.01;
	};
};

//--- Border - temporary solution
_createBorder = {
	Private ["_logic","_startpos"];
	_logic = _this select 0;
	_startpos = _this select 1;
	_oldBorder = missionNamespace getVariable "BIS_COIN_border";
	if (!isNil "_oldBorder") then {
		{deleteVehicle _x} forEach _oldBorder;
	};
	missionNamespace setVariable ["BIS_COIN_border",nil];

	_border = [];
	_center = _startpos;
	_size = (_logic getVariable "BIS_COIN_areasize") select 0;
	_width = 9.998;
	_width = 9.996;
	_width = 9.992;
	_width = 9.967;
	_width = 9.917;
	_width = 9.83;
	_width = 9.48;
	_width = 10 - (0.1/(_size * 0.2));
	_width = 10;

	_pi = 3.14159265358979323846;
	_perimeter = (_size * _pi);
	_perimeter = _perimeter + _width - (_perimeter % _width);
	_size = (_perimeter / _pi);
	_wallcount = _perimeter / _width * 2;
	_total = _wallcount;

	for "_i" from 1 to _total do {
		_dir = (360 / _total) * _i;
		_xpos = (_center select 0) + (sin _dir * _size);
		_ypos = (_center select 1) + (cos _dir * _size);
		_zpos = (_center select 2);

		_a = "transparentwall" createVehicleLocal [_xpos,_ypos,_zpos];
		_a setposasl [_xpos,_ypos,0];
		_a setdir (_dir + 90);
		_border pushBack _a;
	};
	missionNamespace setVariable ["BIS_COIN_border",_border];
};
//--- end of border init function

_createBorderScope = [_logic,_startpos] spawn _createBorder;

//--- This block is pretty important
if !(isNil "BIS_CONTROL_CAM_Handler") exitWith {endLoadingScreen};

//--- init of camera control handler
BIS_CONTROL_CAM_Handler = {
	_mode = _this select 0;
	_input = _this select 1;
	_logic = bis_coin_player getVariable "bis_coin_logic";

	_terminate = false;

  	if (isNil "_logic") exitWith {};

	_areasize = (_logic getVariable "BIS_COIN_areasize");
	_limitH = _areasize select 0;
	_limitV = _areasize select 1;

	_keysCancel	= actionKeys "ingamePause";

	_keysBanned	= [1];
	_keyNightVision		= actionKeys "NightVision";
	_keyAutoWallConstructing = actionKeys "User12";

	//--- Mouse DOWN
	if (_mode == "mousedown") then {
		_key = _input select 1;
		if (_key == 1) then {_terminate = true};
	};

	//--- Key DOWN
	if (_mode == "keydown") then {

		_key = _input select 1;
		_ctrl = _input select 3;
		if !(_key in (BIS_CONTROL_CAM_keys + _keysBanned)) then {BIS_CONTROL_CAM_keys = BIS_CONTROL_CAM_keys + [_key]};

		//--- Terminate CoIn
		if (_key in _keysCancel && isNil "BIS_Coin_noExit") then {_terminate = true};

		//--- Start NVG
		if (_key in _keyNightVision) then {
			_NVGstate = !(_logic getVariable "BIS_COIN_nvg");
			_logic setVariable ["BIS_COIN_nvg",_NVGstate];
			_logic setVariable ['WF_NVGPersistent',_NVGstate];
			camUseNVG _NVGstate;
		};

		if(_key in _keyAutoWallConstructing) then { WF_AutoWallConstructingEnabled = !WF_AutoWallConstructingEnabled };

		//--- Last Built Defense (Custom Action #15).
		if ((_key in (actionKeys "User15")) && count lastBuilt > 0) then {
			_deployed = true;
			_mhqs = (WF_Client_SideJoined) Call WFCO_FNC_GetSideHQ;
            _mhq = [player,_mhqs] call WFCO_FNC_GetClosestEntity;
			if (WF_COIN_Root == "HQ") then {_deployed = [WF_Client_SideJoined, _mhq] Call WFCO_FNC_GetSideHQDeployStatus};
			_currentCash = Call WFCL_FNC_GetPlayerFunds;
			if (_currentCash > (lastBuilt select 2) select 1 && _deployed) then {
				showCommandingMenu '';
				_logic setVariable ["BIS_COIN_params",lastBuilt];
			};
		};

		//--- Manning Defense (Custom Action #16).
		if (_key in (actionKeys "User13")) then { WF_AutoManningDefense = !WF_AutoManningDefense };

		//--- Sell Defense. (Commander only) (Custom Action #17).
		if ((_key in (actionKeys "User17"))) then {
		    _preview = _logic getVariable "BIS_COIN_preview";
		    if (isNil "_preview") then {//--- Proceed when there is no preview.
		    	_targeting = screenToWorld [0.5,0.5];
		    	_defense_list = missionNamespace getVariable Format["WF_%1DEFENSENAMES",WF_Client_SideJoinedText];
		    	_near = nearestObjects [_targeting, _defense_list,12];

		    	if (count _near > 0) then {
		    		_closest = _near # 0;
		    		_sold = _closest getVariable 'sold';
		    		_closestType = typeOf (_closest);
		    		_get = missionNamespace getVariable _closestType;

		    		if ((player distance _closest) > ((_logic getVariable "BIS_COIN_areasize") select 0) || (_closest getVariable 'side') != WF_Client_SideJoined) exitWith {};

		    		if (!isNil '_get' && isNil '_sold') then {
		    		    _price = _get # QUERYUNITPRICE;

                        _closest setVariable ['sold',true];
                        _returnPrice = round(_price/2.5);
                        _returnPrice Call WFCL_FNC_ChangePlayerFunds;
                        [_returnPrice, (_get # QUERYUNITLABEL)] spawn WFCL_FNC_showAwardHint;
                        _area = [getPos (_closest),((WF_Client_SideJoined) Call WFCO_FNC_GetSideLogic) getVariable "wf_basearea"] Call WFCO_FNC_GetClosestEntity2;

                        if(_closest isKindOf "staticWeapon") then {
                            _get = _area getVariable 'availStaticDefense';
                            if(!isNil '_get') then {
                                if (!isNull _area && _get < missionNamespace getVariable "WF_C_BASE_DEFENSE_MAX") then {
                                    _area setVariable [ "availStaticDefense" ,_get +1];
                                };
                            };
                        } else {
                            _get = _area getVariable 'avail';

                            if(!isNil '_get') then {
                                if (!isNull _area && _get < missionNamespace getVariable "WF_C_BASE_AV_FORTIFICATIONS") then {
                                    _area setVariable [ "avail" ,_get +1];
                                };
                            };
                        };

                        deleteVehicle _closest
		    		};
		    	};
		    };
		};
	};
	//--- Key UP
	if (_mode == "keyup") then {
		_key = _input select 1;
		if (_key in BIS_CONTROL_CAM_keys) then {BIS_CONTROL_CAM_keys = BIS_CONTROL_CAM_keys - [_key]};
	};

	//--- Deselect or Close
	if (_terminate) then {
		_menu = _this select 2;

		//--- Close
		if (isNil "BIS_Coin_noExit") then {
			if (_menu == "#USER:BIS_Coin_categories_0") then {
				BIS_CONTROL_CAM cameraEffect ["terminate","back"];
				camDestroy BIS_CONTROL_CAM;
				BIS_CONTROL_CAM = nil;
			} else {
				_preview = _logic getVariable "BIS_COIN_preview";
				if !(isNil "_preview") then {deleteVehicle _preview};
				_logic setVariable ["BIS_COIN_preview",nil];
				_logic setVariable ["BIS_COIN_params",[]];
				_get = _logic getVariable 'WF_Helper';
				if !(isNil '_get') then {
					deleteVehicle _get;
					_logic setVariable ['WF_Helper',nil];
				};
			};
		};
	};

	//--- Camera no longer exists - terminate and start cleanup
	if (isNil "BIS_CONTROL_CAM" || player != bis_coin_player || !isNil "BIS_COIN_QUIT") exitWith {
		if !(isNil "BIS_CONTROL_CAM") then {BIS_CONTROL_CAM cameraEffect ["terminate","back"];camDestroy BIS_CONTROL_CAM;};
		BIS_CONTROL_CAM = nil;
		BIS_CONTROL_CAM_Handler = nil;
		1122 cuttext ["","plain"];
		_player = bis_coin_player;
		_player setVariable ["bis_coin_logic",nil];
		bis_coin_player = objNull;
		_preview = _logic getVariable "BIS_COIN_preview";
		if !(isNil "_preview") then {deleteVehicle _preview};
		_logic setVariable ["BIS_COIN_preview",nil];
		_get = _logic getVariable 'WF_Helper';
		if !(isNil '_get') then {
			deleteVehicle _get;
			_logic setVariable ['WF_Helper',nil];
		};
		_logic setVariable ["BIS_COIN_selected",nil];
		_logic setVariable ["BIS_COIN_params",nil];
		_logic setVariable ["BIS_COIN_lastdir",nil];
		_logic setVariable ["BIS_COIN_tooltip",nil];
		_logic setVariable ["BIS_COIN_fundsOld",nil];
		_logic setVariable ["BIS_COIN_nvg",nil];
		showCommandingMenu "";
		(uiNamespace getVariable "COIN_displayMain") displayRemoveEventHandler ["KeyDown",WF_COIN_DEH1];
		(uiNamespace getVariable "COIN_displayMain") displayRemoveEventHandler ["KeyUp",WF_COIN_DEH2];
		(uiNamespace getVariable "COIN_displayMain") displayRemoveEventHandler ["MouseButtonDown",WF_COIN_DEH3];
		(uiNamespace getVariable "COIN_displayMain") displayRemoveEventHandler ["MouseButtonUp",WF_COIN_DEH4];

		//--- Behold the placeholders
		BIS_COIN_QUIT = nil;
		_border = missionNamespace getVariable "BIS_COIN_border";
		{deleteVehicle _x} forEach _border;
		missionNamespace setVariable ["BIS_COIN_border",nil];
	};
};
//--- end of init of camera control handler

waitUntil {scriptDone _createBorderScope};
endLoadingScreen;


///*** LOOOP ****
_canAffordCount = 0;
_canAffordCountOld = 0;
_limitHOld = -1;
_limitVOld = -1;
_loaded = false;
_localtime = time;
_logic = bis_coin_player getVariable "bis_coin_logic";
_colorGreen = "#(argb,8,8,3)color(0,1,0,0.3,ca)";
_colorRed = "#(argb,8,8,3)color(1,0,0,0.3,ca)";
_colorGray = "#(argb,8,8,3)color(0,0,0,0.25,ca)";
_colorYellow = "#(argb,8,8,3)color(1,1,0,0.3,ca)";

//--- check defence, fortification quantity on base
_areasize = (_logic getVariable "BIS_COIN_areasize");
_allStatics = nearestObjects [_startPos, missionNamespace getVariable Format["WF_%1DEFENSENAMES",WF_Client_SideJoinedText], _areaSize # 0];
_currentDefenses = 0;
_currentFortifications = 0;
{
    if(alive _x) then {
        if (_x isKindOf "StaticWeapon") then {
            _currentDefenses = _currentDefenses + 1
        } else {
            _currentFortifications = _currentFortifications + 1;
        }
    }
} forEach _allStatics;

_area = [_startPos,((WF_Client_SideJoined) Call WFCO_FNC_GetSideLogic) getVariable "wf_basearea"] Call WFCO_FNC_GetClosestEntity2;
if (_currentDefenses > 0) then {
    _registeredAvailableDefenseCount = _area getVariable ['availStaticDefense', missionNamespace getVariable "WF_C_BASE_DEFENSE_MAX"];
    _currentAvailableDefenseCount = (missionNamespace getVariable "WF_C_BASE_DEFENSE_MAX") - _currentDefenses;
    if (_registeredAvailableDefenseCount != _currentAvailableDefenseCount) then {
        _registeredAvailableDefenseCount = _currentAvailableDefenseCount;
        _area setVariable ['availStaticDefense', _registeredAvailableDefenseCount];
    }
};

if (_currentFortifications > 0) then {
    _registeredAvailableFortificationCount = _area getVariable ['avail', missionNamespace getVariable "WF_C_BASE_AV_FORTIFICATIONS"];
    _currentAvailableFortificationCount = (missionNamespace getVariable "WF_C_BASE_AV_FORTIFICATIONS") - _currentFortifications;
    if (_registeredAvailableFortificationCount != _currentAvailableFortificationCount) then {
        _area setVariable ['avail', _registeredAvailableFortificationCount];
    }
};

while {!isNil "BIS_CONTROL_CAM"} do {

	if (isnull (uiNamespace getVariable 'wf_title_coin') && !_loaded) then { //---TEST MrNiceGuy
		cameraEffectEnableHUD true;
		1122 cutrsc ["constructioninterface","plain"];
		_loaded = true;
		_localtime = time;
	};

	if ((time - _localtime) >= 1 && _loaded) then {_loaded = false};
	_mode = "mousemoving";
	_camera = BIS_CONTROL_CAM;

	//--- Player dies on construction mode or the source die.
	if (!alive player || !alive _source) exitWith {
		startLoadingScreen [localize "str_coin_exit" + " " + localize "str_coin_name","RscDisplayLoadMission"];

		if !(isNil "BIS_CONTROL_CAM") then {BIS_CONTROL_CAM cameraEffect ["terminate","back"];camDestroy BIS_CONTROL_CAM;};
		BIS_CONTROL_CAM = nil;
		BIS_CONTROL_CAM_Handler = nil;
		1122 cuttext ["","plain"];
		_player = bis_coin_player;
		_player setVariable ["bis_coin_logic",nil];
		bis_coin_player = objNull;
		_preview = _logic getVariable "BIS_COIN_preview";
		if !(isNil "_preview") then {deleteVehicle _preview};
		_logic setVariable ["BIS_COIN_preview",nil];
		_get = _logic getVariable 'WF_Helper';
		if !(isNil '_get') then {
			deleteVehicle _get;
			_logic setVariable ['WF_Helper',nil];
		};
		_logic setVariable ["BIS_COIN_selected",nil];
		_logic setVariable ["BIS_COIN_params",nil];
		_logic setVariable ["BIS_COIN_lastdir",nil];
		_logic setVariable ["BIS_COIN_tooltip",nil];
		_logic setVariable ["BIS_COIN_fundsOld",nil];
		_logic setVariable ["BIS_COIN_nvg",nil];
		showCommandingMenu "";

		(uiNamespace getVariable "COIN_displayMain") displayRemoveEventHandler ["KeyDown",WF_COIN_DEH1];
		(uiNamespace getVariable "COIN_displayMain") displayRemoveEventHandler ["KeyUp",WF_COIN_DEH2];
		(uiNamespace getVariable "COIN_displayMain") displayRemoveEventHandler ["MouseButtonDown",WF_COIN_DEH3];
		(uiNamespace getVariable "COIN_displayMain") displayRemoveEventHandler ["MouseButtonUp",WF_COIN_DEH4];

		//--- Behold the placeholders
		BIS_COIN_QUIT = nil;
		WF_COIN_DEH1 = nil;
		WF_COIN_DEH2 = nil;
		WF_COIN_DEH3 = nil;
		WF_COIN_DEH4 = nil;
		_border = missionNamespace getVariable "BIS_COIN_border";
		{deleteVehicle _x} forEach _border;
		missionNamespace setVariable ["BIS_COIN_border",nil];
		endLoadingScreen;
	};

	_areasize = (_logic getVariable "BIS_COIN_areasize");
	_limitH = _areasize select 0;
	_limitV = _areasize select 1;
	_limitHOld = _limitH;
	_limitVOld = _limitV;

	_keysCancel		= actionKeys "ingamePause";
	_keysBanned		= [1];

	//--- Mouse moving or holding
	if (_mode == "mousemoving" || _mode == "mouseholding") then {
		//--- Check pressed keys
		_keys = BIS_CONTROL_CAM_keys;
		_ctrl = (29 in _keys) || (157 in _keys);
		_shift = (42 in _keys) || (54 in _keys);
		_alt = (56 in _keys);

		//--- Construction or Selection
		_params = _logic getVariable "BIS_COIN_params";
		_tooltip = "empty";
		_tooltipType = "empty";
		_selected = objNull;
		if (count _params > 0) then {
			//--- Basic colors
			_color = _colorGreen;

			//--- Class, Category, Cost, (preview class), (display name)
			_itemclass = _params select 0;
			_itemcategory = _params select 1;
			_itemcost = _params select 2;
			_itemcash = 0;
			if (_itemcost isEqualType []) then {_itemcash = _itemcost select 0; _itemcost = _itemcost select 1};
			_funds = _logic getVariable "BIS_COIN_funds";
			if (_funds isEqualType []) then {
				_a = (WF_Client_SideJoined) Call WFCO_FNC_GetSideSupply;
				_b = Call WFCL_FNC_GetPlayerFunds;
				_funds = [_a]+[_b];
			} else {
				_funds = [Call WFCL_FNC_GetPlayerFunds];
			};
			_itemFunds = _funds select _itemcash;
			_itemname = [getText (configFile >> "CfgVehicles" >> _itemclass >> "displayName"), _params # 3] select (count _params > 3);
			_itemclass_preview = getText (configFile >> "CfgVehicles" >> _itemclass >> "ghostpreview");
			if (_itemclass_preview == "") then {_itemclass_preview = _itemclass};
			if(_itemclass_preview == "StaticCannon_Preview") then {
				_itemclass_preview = "M2StaticMGPreview";
			};

			//--- Preview building
			_preview = camtarget BIS_CONTROL_CAM;
			_new = false;
			if (typeof _preview != _itemclass_preview) then {
				//--- No preview
				deleteVehicle _preview;
				if !(isNil {_logic getVariable "BIS_COIN_preview"}) then {deleteVehicle (_logic getVariable "BIS_COIN_preview")}; //--- Serialization hack
				_get = _logic getVariable 'WF_Helper';
				if !(isNil '_get') then {
					deleteVehicle _get;
					_logic setVariable ['WF_Helper',nil];
				};
				_mhqs = (WF_Client_SideJoined) Call WFCO_FNC_GetSideHQ;
				_mhq = [player,_mhqs] call WFCO_FNC_GetClosestEntity;

				_hqDeployed = [WF_Client_SideJoined, _mhq] Call WFCO_FNC_GetSideHQDeployStatus;
				_index = _bns find _itemclass;
				if (_index == 0 && _hqDeployed) exitWith {
					(_mhq) Spawn WFCL_FNC_HandleHQAction;
					[WF_Client_SideJoined,_itemclass,[0,0,0],0,getPlayerUID player] remoteExecCall ["WFSE_fnc_RequestStructure",2];

					[missionNamespace getVariable "WF_C_BASE_COIN_AREA_HQ_UNDEPLOYED",false,MCoin] Call WFCL_FNC_initConstructionModule;

					_structuresCosts = missionNamespace getVariable Format["WF_%1STRUCTURECOSTS",WF_Client_SideJoinedText];
					[WF_Client_SideJoined,-(_structuresCosts select _index)] Call WFCO_FNC_ChangeSideSupply;

					startLoadingScreen [localize "str_coin_exit" + " " + localize "str_coin_name","RscDisplayLoadMission"];

					if !(isNil "BIS_CONTROL_CAM") then {BIS_CONTROL_CAM cameraEffect ["terminate","back"];camDestroy BIS_CONTROL_CAM;};
					BIS_CONTROL_CAM = nil;
					BIS_CONTROL_CAM_Handler = nil;
					1122 cuttext ["","plain"];
					_player = bis_coin_player;
					_player setVariable ["bis_coin_logic",nil];
					bis_coin_player = objNull;
					_preview = _logic getVariable "BIS_COIN_preview";
					if !(isNil "_preview") then {deleteVehicle _preview};
					_logic setVariable ["BIS_COIN_preview",nil];
					_logic setVariable ["BIS_COIN_selected",nil];
					_logic setVariable ["BIS_COIN_params",nil];
					_logic setVariable ["BIS_COIN_lastdir",nil];
					_logic setVariable ["BIS_COIN_tooltip",nil];
					_logic setVariable ["BIS_COIN_fundsOld",nil];
					_logic setVariable ["BIS_COIN_nvg",nil];
					showCommandingMenu "";

					(uiNamespace getVariable "COIN_displayMain") displayRemoveEventHandler ["KeyDown",WF_COIN_DEH1];
					(uiNamespace getVariable "COIN_displayMain") displayRemoveEventHandler ["KeyUp",WF_COIN_DEH2];
					(uiNamespace getVariable "COIN_displayMain") displayRemoveEventHandler ["MouseButtonDown",WF_COIN_DEH2];
					(uiNamespace getVariable "COIN_displayMain") displayRemoveEventHandler ["MouseButtonUp",WF_COIN_DEH3];

					//--- Behold the placeholders
					BIS_COIN_QUIT = nil;
					WF_COIN_DEH1 = nil;
					WF_COIN_DEH2 = nil;
					WF_COIN_DEH3 = nil;
					WF_COIN_DEH4 = nil;
					_border = missionNamespace getVariable "BIS_COIN_border";
					{deleteVehicle _x} forEach _border;
					missionNamespace setVariable ["BIS_COIN_border",nil];
					endLoadingScreen;
				};

				_preview = _itemclass_preview createVehicleLocal (screenToWorld [0.5,0.5]);
				_preview enableSimulation false;

				_gdir = _logic getVariable 'BIS_COIN_lastdir';
				if !(isNil '_gdir') then {_preview setDir _gdir};
				BIS_CONTROL_CAM camSetTarget _preview;
				BIS_CONTROL_CAM camCommit 0;
				_logic setVariable ["BIS_COIN_preview",_preview];
				_new = true;

				//--- Preview Helper.
				if (_itemclass in _greenList && _index != -1) then {
					_distance = (missionNamespace getVariable Format ["WF_%1STRUCTUREDISTANCES",WF_Client_SideJoinedText]) # _index;
					_direction = (missionNamespace getVariable Format ["WF_%1STRUCTUREDIRECTIONS",WF_Client_SideJoinedText]) # _index;
					_npos = [getPos _preview,_distance,getDir _preview + _direction] Call WFCO_FNC_GetPositionFrom;
					_helper = "VR_3DSelector_01_default_F" createVehicleLocal _npos;
					_helper setPos _npos;
					_logic setVariable ['WF_Helper',_helper];

                    [_preview, _helper, _distance] spawn {
						_preview = _this # 0;
						_helper = _this # 1;
						_distance = _this # 2;

						while{ true } do {
							if(isNil "_helper") exitWith {};
							if(isNull _helper) exitWith {};

							_mainDir = getDir _preview;
							_mainDir = 0 - _mainDir;

							_mainPos = getPos _preview;

							_xCoord = (_distance * cos(_mainDir)) + (_mainPos # 0);
							_yCoord = (_distance * sin(_mainDir)) + (_mainPos # 1);
							_helper setPosAtl [_xCoord, _yCoord, 0];

							uiSleep 0.3;
						};
					};
				};

				_preview setObjectTexture [0,_colorGray];
				_preview setVariable ["BIS_COIN_color",_colorGray];

				//--- Exception - preview not created
				if (isnull _preview) then {
					deleteVehicle _preview;
					_logic setVariable ["BIS_COIN_preview",nil];
					_logic setVariable ["BIS_COIN_params",[]];
					_get = _logic getVariable 'WF_Helper';
					if !(isNil '_get') then {
						deleteVehicle _get;
						_logic setVariable ['WF_Helper',nil];
					};
				};

			} else {
				//--- Check zone
				if (([position _preview,_startPos] call BIS_fnc_distance2D) > _limitH) then {
					_color = _colorGray
				} else {
					//--- No money
					_funds = 0;
					call compile format ["_funds = %1;",_itemFunds];
					_fundsRemaining = _funds - _itemcost;
					if (_fundsRemaining < 0) then {_color = _colorRed};
					_color = [_itemcategory, _preview, _color] Call (missionNamespace getVariable "WF_C_STRUCTURES_PLACEMENT_METHOD");
				};

				//--Check if it is stationary defense and barracks in the area--
				_area = [_startPos,((WF_Client_SideJoined) Call WFCO_FNC_GetSideLogic) getVariable "wf_basearea"] Call WFCO_FNC_GetClosestEntity2;
				if!(isNil '_color') then {
					if (_color == _colorGreen && _itemclass in (missionNamespace getVariable Format["WF_%1DEFENSENAMES",WF_Client_SideJoinedText])
				    && _itemclass isKindOf "StaticWeapon") then {
						//--Check if defense is special and barracks in area--
						_buildings = WF_Client_SideJoined call WFCO_FNC_GetSideStructures;
						_closest = ['BARRACKSTYPE',_buildings,
									WF_C_BASE_DEFENSE_MANNING_RANGE,WF_Client_SideJoined,_preview] call WFCO_FNC_BuildingInRange;

						if (!alive _closest) then {
							//--Second check if we have a barracks in WF_C_BASE_DEFENSE_MANNING_RANGE + WF_C_BASE_DEFENSE_MANNING_RANGE_EXT * 2 (DIAMETER)--
							//--and any building in this area--
							_closest = ['BARRACKSTYPE',_buildings,
									   (WF_C_BASE_DEFENSE_MANNING_RANGE + (WF_C_BASE_DEFENSE_MANNING_RANGE_EXT * 2)),
									   WF_Client_SideJoined,_preview] call WFCO_FNC_BuildingInRange;
							if!(alive _closest && alive([position _preview,_buildings] call WFCO_FNC_GetClosestEntity5)) then {
								_color = _colorYellow;
							};
						};
						_availStaticDefense = _area getVariable ['availStaticDefense', WF_C_BASE_DEFENSE_MAX];
						if (_availStaticDefense <= 0) then {
							_color = _colorRed
						}
					}
				};

                if (_color == _colorGreen && _itemclass in (missionNamespace getVariable Format["WF_%1DEFENSENAMES",WF_Client_SideJoinedText])
                				    && !(_itemclass isKindOf "StaticWeapon")) then {
                    _availStaticFortifications = _area getVariable ['avail', WF_C_BASE_AV_FORTIFICATIONS];
                    if (_availStaticFortifications <= 0) then { 
                        _color = _colorRed
                    }
                };

				_preview setObjectTexture [0,_color];
				_preview setVariable ["BIS_COIN_color",_color];
				_tooltip = _itemclass;
				_tooltipType = "preview";

				//--- Temporary solution
				_colorGUI = [1,1,1,0.1];
				if (_color == _colorGreen) then {_colorGUI = [0.3,1,0.3,0.3]};
				if (_color == _colorRed) then {_colorGUI = [1,0.2,0.2,0.4]};
				if (_color == _colorYellow) then {_colorGUI = [1,1,0.2,0.4]};

				((uiNamespace getVariable "wf_title_coin") displayCtrl 112201) ctrlSetTextColor _colorGUI;
				((uiNamespace getVariable "wf_title_coin") displayCtrl 112201) ctrlCommit 0;
			};

			//--- Place
			if (!_new && !isNil "_preview" &&  ((BIS_CONTROL_CAM_LMB && 65536 in (actionKeys "DefaultAction")) ||
			    {_x in (actionKeys "DefaultAction")} count BIS_CONTROL_CAM_keys > 0) && (_color == _colorGreen ||
			    _color == _colorYellow)) then {
				_pos = position _preview;
				_dir = direction _preview;
				deleteVehicle _preview;
				_logic setVariable ["BIS_COIN_preview",nil];
				_logic setVariable ["BIS_COIN_params",[]];
				_get = _logic getVariable 'WF_Helper';
				if !(isNil '_get') then {
					deleteVehicle _get;
					_logic setVariable ['WF_Helper',nil];
				};

				//--- Execute designer defined code
				[_logic,_itemclass,_pos,_dir,_params] spawn {
					params ["_logic", "_itemclass", "_pos", "_dir", "_par"];

					//--- Define the last direction used.
					_logic setVariable ["BIS_COIN_lastdir",_dir];

					//--- On Purchase.
					_structureNames = missionNamespace getVariable Format["WF_%1STRUCTURENAMES",WF_Client_SideJoinedText];
					_structures = missionNamespace getVariable Format["WF_%1STRUCTURES",WF_Client_SideJoinedText];
					_defenses = missionNamespace getVariable Format["WF_%1DEFENSENAMES",WF_Client_SideJoinedText];
					_costs = missionNamespace getVariable Format["WF_%1STRUCTURECOSTS",WF_Client_SideJoinedText];

					//--- Structures.
					_index = _structureNames find _itemclass;
					if (_index != -1) then {
						_price = _costs select _index;
						_itemname = _structures select _index;

						//--- Military base or airfield near?
                        _area = [_pos,((WF_Client_SideJoined) Call WFCO_FNC_GetSideLogic) getVariable "wf_basearea"] Call WFCO_FNC_GetClosestEntity2;

                        _town = [_area] Call WFCO_FNC_GetClosestLocation;
                        _townside =  (_town getVariable "sideID") Call WFCO_FNC_GetSideFromID;
                        if!(isNil "_townside") then {
                            if ((_pos distance _town < 600 && _townside != WF_Client_SideJoined) || !isNull _area) then {
                                _townSpecialities = _town getVariable "townSpeciality";
                                if(WF_C_MILITARY_BASE in (_townSpecialities)) then {
                                    _discountStructures = missionNamespace getVariable Format["WF_%1MILITARY_BASE_DISCOUNT_PROGRAM",WF_Client_SideJoinedText];
                                    if (_itemname in _discountStructures) then { _price = _price - (_price * WF_C_BASE_CONSTRUCTION_DISCOUNT_PERCENT) }
                                };
                                if(WF_C_AIR_BASE in (_townSpecialities)) then {
                                    _discountStructures = missionNamespace getVariable Format["WF_%1AIR_BASE_DISCOUNT_PROGRAM",WF_Client_SideJoinedText];
                                    if (_itemname in _discountStructures) then { _price = _price - (_price * WF_C_BASE_CONSTRUCTION_DISCOUNT_PERCENT) }
                                }
                            }
                        };

						[WF_Client_SideJoined, -_price] Call WFCO_FNC_ChangeSideSupply;

						if (_index == 0) then {
						    _mhqs = (WF_Client_SideJoined) Call WFCO_FNC_GetSideHQ;
                            _mhq = [player,_mhqs] call WFCO_FNC_GetClosestEntity;
							_hqDeployed = [WF_Client_SideJoined, _mhq] Call WFCO_FNC_GetSideHQDeployStatus;
							if (_hqDeployed) then {
								[missionNamespace getVariable "WF_C_BASE_COIN_AREA_HQ_UNDEPLOYED",false,MCoin] Call WFCL_FNC_initConstructionModule;
							} else {
								[missionNamespace getVariable "WF_C_BASE_COIN_AREA_HQ_DEPLOYED",true,MCoin] Call WFCL_FNC_initConstructionModule;
							};
							//_logic setVariable ["BIS_COIN_restart",true];
						} else {
							[player,score player + (missionNamespace getVariable "WF_C_PLAYERS_COMMANDER_SCORE_BUILD")] remoteExecCall ["WFSE_fnc_RequestChangeScore",2];
						};
					};

					//--- Execute designer defined code On Construct
					_mhqs = (WF_Client_SideJoined) Call WFCO_FNC_GetSideHQ;
                    _mhq = [player,_mhqs] call WFCO_FNC_GetClosestEntity;
					_deployed = [WF_Client_SideJoined, _mhq] Call WFCO_FNC_GetSideHQDeployStatus;
					
					_find = _structureNames find _itemclass;
					if (_find != -1) then {
						//--- Increment the buildings.
						if ((_find - 1) > -1) then {
							_current = WF_Client_Logic getVariable "wf_structures_live";
							_current set [_find - 1, (_current select (_find-1)) + 1];
							WF_Client_Logic setVariable ["wf_structures_live", _current, true];
						};

						[WF_Client_SideJoined,_itemclass,_pos,_dir,getPlayerUID player] remoteExecCall ["WFSE_fnc_RequestStructure",2];
					};

					if (_itemclass in _defenses) then {
					    //--Check if defense is special and barracks in area--
					    _canRequest = false;

                        _buildings = WF_Client_SideJoined call WFCO_FNC_GetSideStructures;
                        _closest = ['BARRACKSTYPE',_buildings,
                           WF_C_BASE_DEFENSE_MANNING_RANGE,WF_Client_SideJoined,_pos] call WFCO_FNC_BuildingInRange;

                        if (!alive _closest) then {
                            //--Second check if we have a barracks in WF_C_BASE_DEFENSE_MANNING_RANGE + WF_C_BASE_DEFENSE_MANNING_RANGE_EXT * 2 (DIAMETER)--
                            //--and any building in this area--
                            _closest = ['BARRACKSTYPE',_buildings,
                                       (WF_C_BASE_DEFENSE_MANNING_RANGE + (WF_C_BASE_DEFENSE_MANNING_RANGE_EXT * 2)),
                                       WF_Client_SideJoined,_pos] call WFCO_FNC_BuildingInRange;
                            if(alive _closest && alive([_pos,_buildings] call WFCO_FNC_GetClosestEntity5)) then {
                        	    _canRequest = true;
                        	};
                        } else {
                            _canRequest = true;
                        };

                        if(((WF_C_ADV_AIR_DEFENCE # 0) find _itemclass) > -1 && !_canRequest) then {
                            [format["%1", localize 'STR_WF_INFO_BaseArea_NeedBarracks']] spawn WFCL_fnc_handleMessage
                        } else {
                            _area = [_pos,((WF_Client_SideJoined) call WFCO_FNC_GetSideLogic) getVariable "wf_basearea"] call WFCO_FNC_GetClosestEntity2;
                            _canRequestOutsideBase = true;
                            _playerAreas = [];

                            //--If is not base area, check player areas--
                            if(isNull _area) then {
                                _playerAreas = missionNamespace getVariable ["WF_FORTITIFACTIONS_AREAS", []];
                                _areaRange = (missionNamespace getVariable ["WF_C_BASE_AREA_RANGE", 0]) +
                                	    (missionNamespace getVariable ["WF_C_BASE_HQ_BUILD_RANGE", 0]);

                                if(count _playerAreas >= WF_C_BASE_AREA) then {
                                    _canRequestOutsideBase = false;

                                    {
                                        if(_pos inArea [_x, _areaRange, _areaRange, 0, false]) exitWith {
                                            if(count (_x getVariable ["fortifications", []]) < WF_C_BASE_AV_FORTIFICATIONS) then {
                                                _canRequestOutsideBase = true;
                                            } else {
                                                [format[localize "STR_WF_INFO_FortsAreaCount_Reached", WF_C_BASE_AV_FORTIFICATIONS]] spawn WFCL_fnc_handleMessage
                                            };
                                        };
                                    } forEach _playerAreas;

                                    if(!_canRequestOutsideBase) then {
                                        [format[localize "STR_WF_INFO_FortsArea_Reached", WF_C_BASE_AREA]] spawn WFCL_fnc_handleMessage
                                    };
                                };
                            };

                            //--For building in base area _canRequestOutsideBase always TRUE--
                            if(_canRequestOutsideBase) then {
                                //--Pay the bill--
                                _get = missionNamespace getVariable _itemclass;
                                if !(isNil '_get') then {
                                    _price = _get # QUERYUNITPRICE;
                                    -(_price) call WFCL_FNC_ChangePlayerFunds;
                                };

                                [WF_Client_SideJoined,_itemclass,_pos,_dir,WF_AutoManningDefense,getPlayerUID player,clientOwner] remoteExec ["WFSE_fnc_RequestDefense",2];

                                lastBuilt = _par;

                                if(_itemclass isKindOf "staticWeapon") then {
                                    _get = _area getVariable 'availStaticDefense';
                                    if(!isNil '_get') then {
                                        if (!isNull _area && _get > 0) then {
                                            _commanderTeam =(WF_Client_SideJoined) Call WFCO_FNC_GetCommanderTeam;
                                            _area setVariable [ "availStaticDefense" ,_get -1];
                                        };
                                    };
                                } else {
                                    _get = _area getVariable 'avail';

                                    if(!isNil '_get') then {
                                        if (!isNull _area && _get > 0) then {
                                            _commanderTeam =(WF_Client_SideJoined) Call WFCO_FNC_GetCommanderTeam;
                                            _area setVariable [ "avail" ,_get -1];
                                        };
                                    };
                                };

                                if((_itemclass isKindOf "staticWeapon") && !_canRequest) then {
                                    [format ["%1", localize 'STR_WF_INFO_BaseArea_NoBarracksStaticGunner']] spawn WFCL_fnc_handleMessage
                                };
                            };
                        };
					};
				};

				//--- Temporary solution
				_colorGUI = [1,1,1,0.1];
				((uiNamespace getVariable "wf_title_coin") displayCtrl 112201) ctrlSetTextColor _colorGUI;
				((uiNamespace getVariable "wf_title_coin") displayCtrl 112201) ctrlCommit 0;
			};
		} else {
			_colorGUI = [1,1,1,0.1];
			((uiNamespace getVariable "wf_title_coin") displayCtrl 112201) ctrlSetTextColor _colorGUI;
			((uiNamespace getVariable "wf_title_coin") displayCtrl 112201) ctrlCommit 0;
		};

		//--- Amount of funds changed
		_funds = _logic getVariable "BIS_COIN_funds";
		if (_funds isEqualType []) then {
			_a = (WF_Client_SideJoined) Call WFCO_FNC_GetSideSupply;
			_b = Call WFCL_FNC_GetPlayerFunds;
			_funds = [_a]+[_b];
		} else {
			_funds = [Call WFCL_FNC_GetPlayerFunds];
		};
		_fundsDescription = _logic getVariable "BIS_COIN_fundsDescription";
		_cashValues = [];
		{_cashValues pushBack (_x)} forEach _funds;
		_cashValuesOld = _logic getVariable "BIS_COIN_fundsOld";
		if (isNil "_cashValuesOld") then {_cashValuesOld = []; _cashValuesOld set [count _cashValues - 1,-1]};

		//--- calculating auto wall/defensee manning quantity to be displayed on UI
		call _showConstructionMode;

		if (!([_cashValues,_cashValuesOld] call bis_fnc_arraycompare)) then {
			_cashValuesCount = count _cashValues;
			_cashSize = [2.8 / _cashValuesCount, 2] select (_cashValuesCount <= 1);
			_cashText = format ["<t color='#ffffffff' shadow='2' size='%1' align='left' valign='middle'>",_cashSize];
			_cashLines = 0;
			for "_i" from 0 to (count _funds - 1) do {
				_cashValue = _cashValues # _i;
				_cashDescription = ["?", _fundsDescription # _i] select (count _fundsDescription > _i);
				_cashText = _cashText + format ["%1 %2<br />",_cashDescription,round _cashValue];
				_cashLines = _cashLines + 0.05;
			};
			_cashText = _cashText + "</t>";
			_cashPos = ctrlPosition ((uiNamespace getVariable "wf_title_coin") displayCtrl 112224);
			((uiNamespace getVariable "wf_title_coin") displayCtrl 112224) ctrlSetStructuredText (parseText _cashText);
			((uiNamespace getVariable "wf_title_coin") displayCtrl 112224) ctrlSetPosition [_cashPos # 0,_cashPos # 1,_cashPos # 2,(_cashPos # 3) + _cashLines];
			((uiNamespace getVariable "wf_title_coin") displayCtrl 112224) ctrlShow true;
			((uiNamespace getVariable "wf_title_coin") displayCtrl 112224) ctrlCommit 0;

            //--- calculating defense/fortification quantity to be displayed on UI
            _availableDefenses = _area getVariable ['availStaticDefense', WF_C_BASE_DEFENSE_MAX];
            _availableFortifications = _area getVariable ['avail', WF_C_BASE_AV_FORTIFICATIONS];

            _defenseValues = [
                format ["%1/%2", WF_C_BASE_DEFENSE_MAX - _availableDefenses, WF_C_BASE_DEFENSE_MAX],
                format ["%1/%2", WF_C_BASE_AV_FORTIFICATIONS - _availableFortifications, WF_C_BASE_AV_FORTIFICATIONS]
            ];
            _defenseDescription = [];
            _defenseDescription pushBackUnique (format ["%1:      ", localize "STR_WF_Defense"]);
            _defenseDescription pushBackUnique (format ["%1: ", localize "STR_WF_Fortification"]);

            _defenseValuesCount = count _defenseValues;
            _defenseSize = [2.8 / _defenseValuesCount, 2] select (_defenseValuesCount <= 1);
            _defenseText = format ["<t color='#00FF00' shadow='2' size='%1' align='left' valign='middle'>",_defenseSize];
            _defenseLines = 0;
            for "_i" from 0 to 1 do {
                _defenseValue = _defenseValues # _i;
                _defenseText = _defenseText + format ["%1 %2<br />", _defenseDescription # _i, _defenseValue];
                _defenseLines = _defenseLines + 0.05;
            };
            _defenseText = _defenseText + "</t>";
			_defensePos = ctrlPosition ((uiNamespace getVariable "wf_title_coin") displayCtrl 112226);
            ((uiNamespace getVariable "wf_title_coin") displayCtrl 112226) ctrlSetStructuredText (parseText _defenseText);
            ((uiNamespace getVariable "wf_title_coin") displayCtrl 112226) ctrlSetPosition [_defensePos # 0,_defensePos # 1,_defensePos # 2,(_defensePos # 3) + _defenseLines];
            ((uiNamespace getVariable "wf_title_coin") displayCtrl 112226) ctrlShow true;
            ((uiNamespace getVariable "wf_title_coin") displayCtrl 112226) ctrlCommit 0;

			//--- Categories menu
			_categories = +(_logic getVariable "BIS_COIN_categories");
			_categoriesMenu = [];
			//--- Ammo Upgrade.
			_upgrades = (WF_Client_SideJoined) Call WFCO_FNC_GetSideUpgrades;
			if (_upgrades select WF_UP_AMMOCOIN < 1) then {_categories = _categories - [localize 'STR_WF_Ammo']};

			for "_i" from 0 to (count _categories - 1) do { _categoriesMenu pushBack _i; };
			[["Categories",true],"BIS_Coin_categories",[_categoriesMenu,_categories],"#USER:BIS_Coin_%1_items_0","",""] call BIS_fnc_createmenu;

			//--- Items menu
			_items = _logic getVariable "BIS_COIN_items";
			_canAffordCountOld = _canAffordCount;
			_canAffordCount = 0;
			for "_i" from 0 to (count _categories - 1) do {
				_category = _categories select _i;
				_arrayNames = [];
				_arrayNamesLong = [];
				_arrayEnable = [];
				_arrayParams = [];
				_j = 0;
				{
					_itemclass = _x select 0;
					_itemcategory = _x select 1;
					if (_itemcategory isEqualType "") then {//--- Backward compatibility
						_itemcategory = _categories find _itemcategory;
					};

					if (_itemcategory < count _categories) then {
						_itemcost = _x select 2;
						_itemcash = 0;

						if (_itemcost isEqualType []) then {_itemcash = _itemcost select 0; _itemcost = _itemcost select 1};
						_cashValue = _cashValues select _itemcash;
						_cashDescription = ["?", _fundsDescription # _itemcash] select (count _fundsDescription > _itemcash);
						_itemname = [getText (configFile >> "CfgVehicles" >> _itemclass >> "displayName"), _x # 3] select (count _x > 3);

						//--- Military base or airfield near?
						_area = [_startPos,((WF_Client_SideJoined) Call WFCO_FNC_GetSideLogic) getVariable "wf_basearea"] Call WFCO_FNC_GetClosestEntity2;

						_town = [_area] Call WFCO_FNC_GetClosestLocation;
                        _townside =  (_town getVariable "sideID") Call WFCO_FNC_GetSideFromID;
                        if!(isNil "_townside") then {
                            if ((_startPos distance _town < 600 && _townside != WF_Client_SideJoined) || !isNull _area) then {
                                _townSpecialities = _town getVariable "townSpeciality";
                                if(WF_C_MILITARY_BASE in (_townSpecialities)) then {
                                    if!(isNil "_itemname") then {
                                        _discountStructures = missionNamespace getVariable Format["WF_%1MILITARY_BASE_DISCOUNT_PROGRAM",WF_Client_SideJoinedText];
                                        if (_itemname in _discountStructures) then { _itemcost = _itemcost - (_itemcost * WF_C_BASE_CONSTRUCTION_DISCOUNT_PERCENT) }
                                    }
                                };
                                if(WF_C_AIR_BASE in (_townSpecialities)) then {
                                    if!(isNil "_itemname") then {
                                        _discountStructures = missionNamespace getVariable Format["WF_%1AIR_BASE_DISCOUNT_PROGRAM",WF_Client_SideJoinedText];
                                        if (_itemname in _discountStructures) then { _itemcost = _itemcost - (_itemcost * WF_C_BASE_CONSTRUCTION_DISCOUNT_PERCENT) }
                                    }
                                }
                            }
                        };

						//--- Build Limit reached?
						_buildLimit = false;
						_find = _buildingsNames find _itemclass;
						if (_find != -1) then {
							_current = WF_Client_Logic getVariable "wf_structures_live";
							_limit = missionNamespace getVariable (Format['WF_C_STRUCTURES_MAX_%1',(_buildingsType select _find)]);
							if (isNil '_limit') then {_limit = 4}; //--- Default.
							if ((_current select _find) >= _limit) then {_buildLimit = true};
						};
						if (_itemcategory == _i && !isNil "_itemcost") then {
							_canAfford = [0, 1] select (_cashValue - _itemcost >= 0 && !_buildLimit);
							_canAffordCount = _canAffordCount + _canAfford;
							_text = parseText(Format ['%1 <t align="right"><t color="#ffc342">%2</t> <t color="#efff42">%3</t></t>',_itemname,_cashDescription,_itemcost] + "          ");
							_arrayNames pushBack _text;
							_arrayNamesLong pushBack _text;
							_arrayEnable pushback _canAfford;
							_arrayParams pushBack ([_logic getVariable "BIS_COIN_ID"] + [_x,_i]);
						};
						_j = _j + 1;
					};
				} forEach _items;

				[[_category,true],format ["BIS_Coin_%1_items",_i],[_arrayNames,_arrayNamesLong,_arrayEnable],"","
					BIS_CONTROL_CAM_LMB = false;
					scopename 'main';
					_item = '%1';
					_id = %2;
					_array = (call compile '%3') select _id;
					_logic = call compile ('BIS_COIN_'+ str (_array select 0));

					_params = _array select 1;
					_logic setVariable ['BIS_COIN_params',_params];
					_logic setVariable ['BIS_COIN_menu',commandingMenu];
					showCommandingMenu '';

				",_arrayParams] spawn BIS_fnc_createmenu;
			};

			if (_canAffordCount != _canAffordCountOld) then {showCommandingMenu (commandingMenu)}; //<-- Open menu again to show disabled items
		};
		_logic setVariable ["BIS_COIN_fundsOld",_cashValues];
		_logic setVariable ["BIS_COIN_tooltip",_tooltipType + _tooltip];
	};
	sleep 0.05;
};
//--- end of loop

if (_originalHudOn) then {
    hudOn = true;
    ctrlSetText[13020, "HUD ON"];
};

112200 cuttext ["","plain"]; //---added-MrNiceGuy
showCommandingMenu '';