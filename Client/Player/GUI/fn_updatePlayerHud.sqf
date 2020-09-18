private ["_health", "_color", "_uptimeValue", "_commanderValue", "_playersWestCount", "_playersEastCount",
        "_moneyTotalValue", "_moneyIncomeValue", "_supplyTotalValue", "_supplyIncomeValue", "_hControl", "_fbControl",
        "_frControl", "_fbvControl", "_frvControl", "_mControl", "_mvControl", "_sControl", "_svControl", "_tControl",
		"_textSize", "_textSize1", "_textSize2", "_uiSize",

		"_textHealth","_textComm","_textUptime","_textMoney","_textIncome","_textSupply", "_textSVMIN", "_textTowns",
		"_textFPS","_lineLabel0","_lineLabel","_textLabel1","_textLabel2","_textLabel3","_textLabel4", "_textLabel5",
		"_textLabel6","_textLabel7","_textLabel8","_textLabel9","_flagwest01","_flageast01","_player"];

disableSerialization;

CutRsc["OptionsAvailable","PLAIN",0];

private _cutDisplay = ["currentCutDisplay"] call BIS_FNC_GUIget;

//--Old HUD variables--START------------------------------------------------------------------------------------------//
_textHealth 	= format["%1:", localize "STR_WF_HUD_HEALTH"];
_textComm 		= format["%1:", localize "STR_WF_HUD_COMM"];
_textUptime 	= format["%1:", localize "STR_WF_HUD_UPTIME"];
_textMoney 		= format["%1:", localize "STR_WF_HUD_MONEY"];
_textIncome 	= format["%1:", localize "STR_WF_HUD_INCOME"];
_textSupply 	= format["%1:", localize "STR_WF_HUD_SUPPLY"];
_textSVMIN 		= format["%1:", localize "STR_WF_HUD_SVMIN"];
_textTowns 		= format["%1:", localize "STR_WF_HUD_TOWNS"];
_textFPS 		= format["%1:", localize "STR_WF_HUD_FPS"];

_textControl1 = _cutDisplay DisplayCtrl 1353;
_textControl2 = _cutDisplay DisplayCtrl 1351;
_textControl3 = _cutDisplay DisplayCtrl 1355;
_textControl4 = _cutDisplay DisplayCtrl 1349;
_textControl5 = _cutDisplay DisplayCtrl 1347;
_textControl6 = _cutDisplay DisplayCtrl 1357;
_textControl7 = _cutDisplay DisplayCtrl 1359;
_textControl8 = _cutDisplay DisplayCtrl 1361;
_textControl9 = _cutDisplay DisplayCtrl 1371;

_lineLabel0 = _cutDisplay DisplayCtrl 1344;
_lineLabel = _cutDisplay DisplayCtrl 1345;
_textLabel1 = _cutDisplay DisplayCtrl 1346;
_textLabel2 = _cutDisplay DisplayCtrl 1348;
_textLabel3 = _cutDisplay DisplayCtrl 1370;
_textLabel4 = _cutDisplay DisplayCtrl 1350;
_textLabel5 = _cutDisplay DisplayCtrl 1352;
_textLabel6 = _cutDisplay DisplayCtrl 1354;
_textLabel7 = _cutDisplay DisplayCtrl 1356;
_textLabel8 = _cutDisplay DisplayCtrl 1358;
_textLabel9 = _cutDisplay DisplayCtrl 1360;
_flagwest01 = _cutDisplay DisplayCtrl 1362;
_flageast01 = _cutDisplay DisplayCtrl 1365;

_playerWestCountIndicator = _cutDisplay DisplayCtrl 1364;
_playerEastCountIndicator = _cutDisplay DisplayCtrl 1367;
//--Old HUD variables--END--------------------------------------------------------------------------------------------//

//--HUD variables--START----------------------------------------------------------------------------------------------//
_bgControl = _cutDisplay DisplayCtrl 1099;
_hControl = _cutDisplay DisplayCtrl 1100;
_fbControl = _cutDisplay DisplayCtrl 1101;
_frControl = _cutDisplay DisplayCtrl 1102;
_fbvControl = _cutDisplay DisplayCtrl 1103;
_frvControl = _cutDisplay DisplayCtrl 1104;
_mControl = _cutDisplay DisplayCtrl 1105;
_mvControl = _cutDisplay DisplayCtrl 1106;
_sControl = _cutDisplay DisplayCtrl 1107;
_svControl = _cutDisplay DisplayCtrl 1108;
_tControl = _cutDisplay DisplayCtrl 1109;
//--HUD variables--END------------------------------------------------------------------------------------------------//

_uiSize = getResolution # 5;
_textSize = 1.95 - _uiSize;
_textSize1 = 1.8 - _uiSize;
_textSize2 = 1.7 - _uiSize;
_bgSize = 8 - _uiSize;
if(_uiSize >= 0.7) then {
	_bgSize = _bgSize - 2;
};
if(_uiSize > 0.85) then {
	_bgSize = _bgSize - 4;
};

_hideOldHud = {
    _textControl1 ctrlShow false;
    _textControl3 ctrlShow false;
    _textControl6 ctrlShow false;
    _textControl7 ctrlShow false;
    _textControl8 ctrlShow false;
    _textControl2 ctrlShow false;
    _textControl9 ctrlShow false;
    _textControl4 ctrlShow false;
    _textControl5 ctrlShow false;
    _textLabel1 ctrlShow false;
    _textLabel2 ctrlShow false;
    _textLabel3 ctrlShow false;
    _textLabel4 ctrlShow false;
    _textLabel5 ctrlShow false;
    _textLabel6 ctrlShow false;
    _textLabel7 ctrlShow false;
    _textLabel8 ctrlShow false;
    _textLabel9 ctrlShow false;
    _lineLabel  ctrlShow false;
    _lineLabel0 ctrlShow false;
    _flagwest01 ctrlShow false;
    _flageast01 ctrlShow false;
    _playerWestCountIndicator ctrlShow false;
    _playerEastCountIndicator ctrlShow false;
};

_hideHud = {
    _bgControl ctrlShow false;
    _hControl ctrlShow false;
    _fbControl ctrlShow false;
    _frControl ctrlShow false;
    _fbvControl ctrlShow false;
    _frvControl ctrlShow false;
    _mControl ctrlShow false;
    _mvControl ctrlShow false;
    _sControl ctrlShow false;
    _svControl ctrlShow false;
    _tControl ctrlShow false;
};

while {true} do {
    _cutDisplay = ["currentCutDisplay"] call BIS_FNC_GUIget;

	if (!isNull _cutDisplay && hudOn) then {
	    if(hudStyle) then {
            call _hideOldHud;

            //--HUD variables--START----------------------------------------------------------------------------------------------//
            _bgControl = _cutDisplay DisplayCtrl 1099;
            _hControl = _cutDisplay DisplayCtrl 1100;
            _fbControl = _cutDisplay DisplayCtrl 1101;
            _frControl = _cutDisplay DisplayCtrl 1102;
            _fbvControl = _cutDisplay DisplayCtrl 1103;
            _frvControl = _cutDisplay DisplayCtrl 1104;
            _mControl = _cutDisplay DisplayCtrl 1105;
            _mvControl = _cutDisplay DisplayCtrl 1106;
            _sControl = _cutDisplay DisplayCtrl 1107;
            _svControl = _cutDisplay DisplayCtrl 1108;
            _tControl = _cutDisplay DisplayCtrl 1109;
            //--HUD variables--END------------------------------------------------------------------------------------------------//

            //--Background--
            _bgControl ctrlShow true;
            _fText = format["<t align='left' valign='top' size='%1' color='#ffffffff'><img image='RSC\Pictures\hudback.paa'/></t>", _bgSize];
            _bgControl ctrlSetStructuredText parseText _fText;

            //--HP, Commander and Uptime--
            _hControl ctrlShow true;
            _health = 1 - (getDammage player);
            _color = "#00FF00";
            if (_health <= 0.89) then {_color = "#FFCC00"};
            if (_health <= 0.79) then {_color = "#FF9900"};
            if (_health <= 0.60) then {_color = "#FF2200"};
            if (_health <= 0.08) then {_color = "#882222"};
            _uptimeValue = Call WFCL_FNC_GetTime;
            _commanderValue = "AI";
            if (!isNull commanderTeam) then { _commanderValue = name (leader commanderTeam)};
            if (count _commanderValue > 10) then {
                _commanderValue = [_commanderValue, 0, 7] call BIS_fnc_trimString;
                _commanderValue = format["%1...", _commanderValue];
            };
            _fText = format["<t color='%1' shadow='1' font='PuristaBold' size='%6' valign='middle'><img image='RSC\Pictures\health.paa'/> %2</t>  <t color='#FFFFFF' shadow='1' font='PuristaBold' size='%6' valign='middle'><img image='\A3\ui_f\data\GUI\Cfg\Ranks\general_gs.paa'/> %4 <img image='\A3\ui_f\data\IGUI\Cfg\CommandBar\imageNoWeapons_ca.paa'/> %5 <img image='\A3\ui_f\data\IGUI\RscTitles\MPProgress\timer_ca.paa'/> %3<t/>",
                                _color, floor(_health * 100), format ["%1:%2:%3", _uptimeValue # 1, _uptimeValue # 2, _uptimeValue # 3], _commanderValue, WF_SK_V_Type, _textSize];
            _hControl ctrlSetStructuredText parseText _fText;

            //--Flags and players--
            _fbControl ctrlShow true;
            _fText = format["<t size='%1' valign='bottom'><img image='RSC\Pictures\flag_bluefor_ca.paa'/></t>", _textSize];
            _fbControl ctrlSetStructuredText parseText _fText;

            _frControl ctrlShow true;
            _fText = format["<t size='%1' valign='bottom'><img image='RSC\Pictures\flag_opfor_ca.paa'/></t>", _textSize];
            _frControl ctrlSetStructuredText parseText _fText;

            _playersWestCount = count (missionNamespace getVariable ["WF_PLAYERS_WEST", []]);
            _playersEastCount = count (missionNamespace getVariable ["WF_PLAYERS_EAST", []]);

            _fbvControl ctrlShow true;
            _fText = format["<t color='#FFFFFF' shadow='1' font='PuristaBold' size='%2' valign='middle'>%1<t/>", _playersWestCount, _textSize];
            _fbvControl ctrlSetStructuredText parseText _fText;

            _frvControl ctrlShow true;
            _fText = format["<t color='#FFFFFF' shadow='1' font='PuristaBold' size='%2' valign='middle'>%1<t/>", _playersEastCount, _textSize];
            _frvControl ctrlSetStructuredText parseText _fText;

            //--Money--
            _mControl ctrlShow true;
            _fText = format["<t size='%1' shadow='1'><img image='RSC\Pictures\money.paa'/></t>", _textSize];
            _mControl ctrlSetStructuredText parseText _fText;

            _mvControl ctrlShow true;

            _moneyTotalValue = Call WFCL_FNC_GetPlayerFunds;
            _moneyIncomeValue = WF_Client_SideJoined Call WFCL_FNC_GetIncome;

            if(_moneyTotalValue > 99999) then {
                _moneyTotalValue = _moneyTotalValue/1000;
                _moneyTotalValue = format["%1K", [_moneyTotalValue, 1] call BIS_fnc_cutDecimals];
            };

            if(_moneyIncomeValue > 9999) then {
                _moneyIncomeValue = _moneyIncomeValue/1000;
                _moneyIncomeValue = format["%1K", [_moneyIncomeValue, 1] call BIS_fnc_cutDecimals];
            };

            _fText = format["<t color='#FFFFFF' shadow='1' font='PuristaBold' size='%3'>%1</t><br/><t color='#FFFFFF' shadow='1' font='PuristaBold' size='%4'>+ %2</t>",
                                _moneyTotalValue, _moneyIncomeValue, _textSize1, _textSize2];
            _mvControl ctrlSetStructuredText parseText _fText;

            //--Supply--
            _sControl ctrlShow true;
            _fText = "<t size='1.75' shadow='1' valign='top'><img image='\A3\ui_f\data\GUI\Rsc\RscDisplayArcadeMap\icon_toolbox_modules_ca.paa'/></t>";
            _sControl ctrlSetStructuredText parseText _fText;

            _svControl ctrlShow true;

            _supplyTotalValue = WF_Client_SideJoined Call WFCO_FNC_GetSideSupply;
            _supplyIncomeValue = WF_Client_SideJoined Call WFCO_FNC_GetTotalSupplyValue;

            if(_supplyTotalValue > 99999) then {
                _supplyTotalValue = _supplyTotalValue/1000;
                _supplyTotalValue = format["%1K", [_supplyTotalValue, 1] call BIS_fnc_cutDecimals];
            };

            if(_supplyIncomeValue > 9999) then {
                _supplyIncomeValue = _supplyIncomeValue/1000;
                _supplyIncomeValue = format["%1K", [_supplyIncomeValue, 1] call BIS_fnc_cutDecimals];
            };
            _fText = format["<t color='#FFFFFF' shadow='1' font='PuristaBold' size='%3'>%1</t><br/><t color='#FFFFFF' shadow='1' font='PuristaBold' size='%4'>+ %2</t>",
                                _supplyTotalValue, _supplyIncomeValue, _textSize1, _textSize2];
            _svControl ctrlSetStructuredText parseText _fText;

            _tControl ctrlShow true;
            _fText = format["<t color='#FFFFFF' shadow='1' font='PuristaBold' size='%5' valign='middle'><img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\default_ca.paa'/>%1 <img image='\A3\ui_f\data\GUI\Rsc\RscDisplayOptionsVideo\icon_performance.paa'/> S:%2 HC:%3 C:%4</t>",
            format["%1/%2", WF_Client_SideJoined Call WFCO_FNC_GetTownsHeld, count towns], floor(missionNamespace getVariable["WF_SERVER_FPS", 0]), floor(missionNamespace getVariable["WF_HC_FPS", 0]), floor(diag_fps), _textSize];
            _tControl ctrlSetStructuredText parseText _fText;
		} else {
		    call _hideHud;

            _textControl1 = _cutDisplay DisplayCtrl 1353;
            _textControl2 = _cutDisplay DisplayCtrl 1351;
            _textControl3 = _cutDisplay DisplayCtrl 1355;
            _textControl4 = _cutDisplay DisplayCtrl 1349;
            _textControl5 = _cutDisplay DisplayCtrl 1347;
            _textControl6 = _cutDisplay DisplayCtrl 1357;
            _textControl7 = _cutDisplay DisplayCtrl 1359;
            _textControl8 = _cutDisplay DisplayCtrl 1361;
            _textControl9 = _cutDisplay DisplayCtrl 1371;

            _lineLabel0 = _cutDisplay DisplayCtrl 1344;
            _lineLabel = _cutDisplay DisplayCtrl 1345;
            _textLabel1 = _cutDisplay DisplayCtrl 1346;
            _textLabel2 = _cutDisplay DisplayCtrl 1348;
            _textLabel3 = _cutDisplay DisplayCtrl 1370;
            _textLabel4 = _cutDisplay DisplayCtrl 1350;
            _textLabel5 = _cutDisplay DisplayCtrl 1352;
            _textLabel6 = _cutDisplay DisplayCtrl 1354;
            _textLabel7 = _cutDisplay DisplayCtrl 1356;
            _textLabel8 = _cutDisplay DisplayCtrl 1358;
            _textLabel9 = _cutDisplay DisplayCtrl 1360;
            _flagwest01 = _cutDisplay DisplayCtrl 1362;
            _flageast01 = _cutDisplay DisplayCtrl 1365;

            _playerWestCountIndicator = _cutDisplay DisplayCtrl 1364;
            _playerEastCountIndicator = _cutDisplay DisplayCtrl 1367;

            _player = leader player;
            //Show background

            _lineLabel ctrlShow true;
            _linelabel0 ctrlShow true;

            if (side player == WEST) then {
                _lineLabel0 CtrlSetBackgroundColor [0,0.4,1,1];
                _lineLabel CtrlSetBackgroundColor [0,0.4,1,1];
            } else {
                _lineLabel0 CtrlSetBackgroundColor [1,0.2,0,1];
                _lineLabel CtrlSetBackgroundColor [1,0.2,0,1];
            };

            _textLabel1 ctrlSetText _textHealth;
            _textLabel2 ctrlSetText _textUptime;
            _textLabel3 ctrlSetText _textComm;
            _textLabel4 ctrlSetText _textMoney;
            _textLabel5 ctrlSetText _textIncome;
            _textLabel6 ctrlSetText _textSupply;
            _textLabel7 ctrlSetText _textSVMIN;
            _textLabel8 ctrlSetText _textTowns;
            _textLabel9 ctrlSetText _textFPS;
            _flagwest01 ctrlSetText "RSC\Pictures\flag_bluefor_ca.paa";
            _flageast01 ctrlSetText "RSC\Pictures\flag_opfor_ca.paa";
            _textLabel1 ctrlShow true;
            _textLabel2 ctrlShow true;
            _textLabel3 ctrlShow true;
            _textLabel4 ctrlShow true;
            _textLabel5 ctrlShow true;
            _textLabel6 ctrlShow true;
            _textLabel7 ctrlShow true;
            _textLabel8 ctrlShow true;
            _textLabel9 ctrlShow true;
            _lineLabel  ctrlShow true;
            _lineLabel0 ctrlShow true;
            _flagwest01 ctrlShow true;
            _flageast01 ctrlShow true;

            //HEALT
            _textControl5 ctrlShow true;
            _status = damage _player;
            _health = 1 - _status;
            _healthAct = (1 - _status) * 100;
            _textControl5 ctrlSetText Format ["%1",str(round _healthAct)] + " %";
            if (_health <= 1) then {_textControl5 ctrlSetTextColor [0, 1, 0, 1]};
            if (_health <= 0.89) then {_textControl5 ctrlSetTextColor [1, 0.8831, 0, 1]};
            if (_health <= 0.79) then {_textControl5 ctrlSetTextColor [1, 0.65, 0, 1]};
            if (_health <= 0.60) then {_textControl5 ctrlSetTextColor [1, 0.15, 0, 1]};
            if (_health <= 0.08) then {_textControl5 ctrlSetTextColor [0.45, 0.25, 0.25, 1]};

            //UPTIME
            _uptime = Call WFCL_FNC_GetTime; //added-MrNiceGuy
            _textControl4 ctrlShow true;
            _textControl4 ctrlSetTextColor [0.7, 0.7, 0.7, 1];_textControl4 ctrlSetText Format ["%1:%2:%3",_uptime select 1,_uptime select 2, _uptime select 3];

            //COMMANDER
            _textControl9 ctrlShow true;
            if (!isNull commanderTeam) then {
                _textControl9 ctrlSetTextColor [0.85, 0, 0, 1];_textControl9 ctrlSetText Format [" %1", name (leader commanderTeam)];
            }else{
                _textControl9 ctrlSetTextColor [0.85, 0, 0, 1];_textControl9 ctrlSetText Format [" %1", "AI"];
            };

            //MONEY
            _textControl2 ctrlShow true;
            _textControl2 ctrlSetTextColor [0, 0.825294, 0.449803, 1];_textControl2 ctrlSetText Format ["%1 $",Call WFCL_FNC_GetPlayerFunds];
            _textControl1 ctrlShow true;
            _textControl1 ctrlSetTextColor [0, 0.825294, 0.449803, 1];_textControl1 ctrlSetText Format ["+ %1 $",WF_Client_SideJoined Call WFCL_FNC_GetIncome];

            //SUPPLY
            _textControl3 ctrlShow true;
            _textControl3 ctrlSetTextColor [1, 0.8831, 0, 1];_textControl3 ctrlSetText Format ["%1",(WF_Client_SideJoined) Call WFCO_FNC_GetSideSupply];
            _textControl6 ctrlShow true;
            _textControl6 ctrlSetTextColor [1, 0.6831, 0, 1];_textControl6 ctrlSetText Format ["+ %1", WF_Client_SideJoined Call WFCO_FNC_GetTotalSupplyValue];
            _textControl7 ctrlShow true;
            _textControl7 ctrlSetTextColor [0.1, 0.7, 0.9, 1];_textControl7 ctrlSetText Format ["%1 on %2", WF_Client_SideJoined Call WFCO_FNC_GetTownsHeld, count towns];

            //SERVERFPS
            _textControl8 ctrlShow true;

            _clientFPS = round(diag_fps);
            _level = "Perfect";

            if (isNil '_clientFPS') then { _clientFPS=50 };
            if ((_clientFPS < 52)&&(_clientFPS >= 45)) then {_textControl8 ctrlSetTextColor [0, 1, 1, 1]; _level="Perfect";};
            if ((_clientFPS < 45)&&(_clientFPS >= 39)) then {_textControl8 ctrlSetTextColor [0, 1, 0, 1]; _level="Very Good";};
            if ((_clientFPS < 39)&&(_clientFPS >= 28)) then {_textControl8 ctrlSetTextColor [0.5, 1, 0.15, 1]; _level="Good";};
            if ((_clientFPS < 28)&&(_clientFPS >= 21)) then {_textControl8 ctrlSetTextColor [0.9, 1, 0, 1]; _level="Average";};
            if ((_clientFPS < 21)&&(_clientFPS >= 11)) then {_textControl8 ctrlSetTextColor [1, 0.6, 0, 1]; _level="Low";};
            if ((_clientFPS < 11)&&(_clientFPS >= 0)) then {_textControl8 ctrlSetTextColor [1, 0.3, 0, 1]; _level="Very Low";};

            _textControl8 ctrlSetText Format ["%1 FPS %2",_clientFPS,_level];

            // OSD SCORE BLUFOR - OPFOR
            _playersWestCount = count (missionNamespace getVariable ["WF_PLAYERS_WEST", []]);
            _playersEastCount = count (missionNamespace getVariable ["WF_PLAYERS_EAST", []]);

            _spacewest = "";
            _spaceeast = "";

            if ( ( _playersWestCount < 10) && ( _playersWestCount >= 0) ) then { _spacewest = "   "};
            if ( ( _playersWestCount >= 10) && ( _playersWestCount < 100)) then { _spacewest = "  "};

            if ( ( _playersEastCount < 10) && ( _playersEastCount >= 0) ) then { _spaceeast = "   "};
            if ( ( _playersEastCount >= 10) && ( _playersEastCount < 100)) then { _spaceeast = "  "};

            if ( ( _playersWestCount < 0) && (_playersWestCount > -10)) then { _spacewest = "  "};
            if ( ( _playersEastCount < 0) && (_playersEastCount > -10)) then { _spaceeast = "  "};

            if ( _playersWestCount < 0 ) then { _playerWestCountIndicator ctrlSetTextColor [ 1,0.51,0,1];} else {_playerWestCountIndicator ctrlSetTextColor [ 0.96,0.96,0.96,1];};
            if ( _playersEastCount < 0 ) then { _playerEastCountIndicator ctrlSetTextColor [ 1,0.51,0,1];} else {_playerEastCountIndicator ctrlSetTextColor [ 0.96,0.96,0.96,1];};

            _playerWestCountIndicator ctrlSetText Format [_spacewest + "%1",_playersWestCount];
            _playerEastCountIndicator ctrlSetText Format [_spaceeast + "%1",_playersEastCount];

            _playerWestCountIndicator ctrlShow true;
            _playerEastCountIndicator ctrlShow true;
		};
	} else {
        call _hideHud;
        call _hideOldHud;
    };

	sleep 3;
};