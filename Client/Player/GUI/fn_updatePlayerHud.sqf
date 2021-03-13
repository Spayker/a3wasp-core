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

_icons = [
	"RSC\Pictures\icon_wf_building_mhq.paa",       //mhq deployable
	"Rsc\Pictures\icon_wf_building_barracks.paa",  //barracks
	"RSC\Pictures\icon_wf_building_gear.paa",      //gear avail
	"RSC\Pictures\icon_wf_building_lvs.paa",       //lvsp
	"RSC\Pictures\icon_wf_building_hvs.paa",       //hvsp
	"RSC\Pictures\icon_wf_building_air.paa",       //helipad
	"RSC\Pictures\icon_wf_building_hangar.paa",    //hangar
	"RSC\Pictures\icon_wf_building_repair.paa",    //rearm | repair | refuel
	"RSC\Pictures\icon_wf_building_cc.paa",        //command center
	"RSC\Pictures\icon_wf_building_aa_radar.paa",  //AA radar
	"RSC\Pictures\icon_wf_building_am_radar.paa"
];

while {alive (leader WF_Client_Team)} do {

    _usable = [hqInRange,barracksInRange,gearInRange,lightInRange,heavyInRange,aircraftInRange,hangarInRange,
                                    serviceInRange,commandInRange,antiAirRadarInRange,antiArtyRadarInRange];
    _c = 0;

        if (hudOn) then {
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

        {
            if (_x) then {
                ((_cutDisplay) DisplayCtrl (3500 + _c)) ctrlSetText (_icons select _c);
                ((_cutDisplay) DisplayCtrl (3500 + _c)) ctrlSetTextColor WF_C_TITLETEXT_COLOR_INT;
            } else {
                ((_cutDisplay) DisplayCtrl (3500 + _c)) CtrlSetText "";
            };
            _c = _c + 1;
        } forEach _usable
	} else {
        call _hideHud;
        {
            if (_x) then {
                ((_cutDisplay) DisplayCtrl (3500 + _c)) ctrlSetText ("");
            };
            _c = _c + 1;
        } forEach _usable
    };

	sleep 3
}