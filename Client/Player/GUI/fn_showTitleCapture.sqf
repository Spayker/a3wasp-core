private["_delay","_lastCheck","_lastSID","_lastUpdate","_txt","_colorBlue","_colorGreen","_colorRed","_colorBlack","_colorFriendly","_colorEnemy","_colorResistance","_ui_bg"];

disableSerialization;
_delay = 4;
_lastCheck = "";
_lastSID = -1;
_lastUpdate = time;
_txt = "";

_colorBlue = [0,0,0.7,0.6];
_colorGreen = [0,0.7,0,0.6];
_colorRed = [0.7,0,0,0.6];
_colorBlack = [0,0,0,0.6];

if(WF_C_PARAMETER_COLORATION == 1) then {
_colorEnemy =_colorRed;
	if (side player == west) then {
_colorResistance =_colorBlue;
		_colorFriendly = _colorBlue;
		_colorEnemy = _colorRed;
	} else {
		_colorFriendly = _colorRed;
		_colorEnemy = _colorBlue;
	};		
} else {
	_colorFriendly = _colorGreen;
_colorEnemy = _colorRed;
};
	
if(WF_C_PARAMETER_COLORATION == 1) then {
	_colorResistance = _colorGreen;
} else {
	_colorResistance = _colorBlue;
};

_ui_bg = [0,0,0,0.7];
_update = false;

while {!WF_GameOver} do {
	_nearest = [player,towns] Call WFCO_FNC_GetClosestEntity;

	waitUntil {sleep 0.5;!(isNil "_nearest")};
	_update = if (player distance _nearest < (_nearest getVariable "range") && alive player) then {true} else {false};
	
	if(isNil "_update") then {_update = true};
	
	if(_update)then{
		_sideID = _nearest getVariable "sideID";
		_curSV = _nearest getVariable "supplyValue";
		_maxSV = _nearest getVariable "maxSupplyValue";

		if(isNil "_curSV")then{_curSV = 1};
		if(isNil "_maxSV")then{_maxSV = 1};

		_camp = [vehicle player, 12, true] Call WFCL_FNC_GetClosestCamp;

		if (!isNull _camp) then {
			if (!isObjectHidden _camp) then {
				_sideID = _camp getVariable "sideID";
				_curSV = _camp getVariable "supplyValue";
				if (_lastCheck == "Town") then {_delay = 0};
				_txt = "";
				_lastCheck = "Camp"
			}
		} else {
		    _townSpecialities = _nearest getVariable "townSpeciality";
		    _hasSuppluySpeciality = true;

		    if!(isNil '_townSpecialities') then {
		         if(WF_C_MILITARY_BASE in (_townSpecialities)) then { _hasSuppluySpeciality = false };

		         if(WF_C_AIR_BASE in (_townSpecialities)) then { _hasSuppluySpeciality = false };

		         if(WF_C_PORT in (_townSpecialities)) then { _hasSuppluySpeciality = false };

                 if(WF_C_MINE in (_townSpecialities)) then { _hasSuppluySpeciality = false }
			};

		    if (_hasSuppluySpeciality) then {
                _txt = Format [localize "STR_WF_TownSV", _curSV,_maxSV]
		} else {
		        _txt = ""
		    };
            _lastCheck = "Town"
		};

		if!(isnil "_sideID")then{
		if (_sideID != _lastSID) then {_delay = 0};
		if (isNull (uiNamespace getVariable "wf_title_capture")) then {600200 cutRsc["CaptureBar","PLAIN",0];_delay = 0};
		if !(isNull (uiNamespace getVariable "wf_title_capture")) then {
	
			_barColor = _colorResistance;
			
			if ((_sideID == WESTID)&&(WF_Client_SideID == WESTID) || (_sideID == EASTID)&&(WF_Client_SideID == EASTID)) then {_barColor = _colorFriendly}; //--- Green
			if ((_sideID == WESTID)&&(WF_Client_SideID == EASTID) || (_sideID == EASTID)&&(WF_Client_SideID == WESTID)) then {_barColor = _colorEnemy};

			_control = (uiNamespace getVariable "wf_title_capture") displayCtrl 601001;
			_control ctrlShow true;
			_control ctrlSetBackgroundColor _barColor;
			_backgroundControl = (uiNamespace getVariable "wf_title_capture") displayCtrl 601000;
			_backgroundControl ctrlShow true;
			_backgroundControl ctrlSetBackgroundColor _ui_bg;
			_textControl = (uiNamespace getVariable "wf_title_capture") displayCtrl 601002;
			_textControl ctrlShow true;
			_textControl ctrlSetText _txt;
			_maxWidth = (ctrlPosition _backgroundControl Select 2) - 0.02;
			_position = ctrlPosition _control;
			_position set [2,_maxWidth * _curSV / _maxSV];
			_control ctrlSetPosition _position;
			_control ctrlCommit _delay;
			_delay = 4;
                _lastSID = _sideID
            }
        }
	};
	if(!_update && !WF_GameOver)then{
		_delay = 0;
		if (isNull (uiNamespace getVariable "wf_title_capture")) then {600200 cutRsc["CaptureBar","PLAIN",0]};
		if (!isNull (uiNamespace getVariable "wf_title_capture")) then {
			{((uiNamespace getVariable "wf_title_capture") displayCtrl _x) ctrlShow false} forEach [601000,601001,601002];
		};
	};
	sleep 5;
};