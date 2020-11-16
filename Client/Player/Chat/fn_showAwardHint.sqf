params ["_bounty", "_killedName"];
private[ "_fillKillPayTitle", "_Display", "_isTimeToCleanUp", "_cleanUp"];

if (isServer) exitWith {
    ["WARNING", Format ["fn_showAwardHint was called from server with following params: _bounty - %1, _killedName - %2", _bounty, _killedName]] Call WFCO_FNC_LogContent
};

disableSerialization;

_display	= uiNamespace getVariable "Display_KillPay";
bountyTimeAppearance = time;

_fillKillPayTitle	= {
    _display	= uiNamespace getVariable "Display_KillPay";
    _CtrlText	= _display DisplayCtrl 119900;
    _Text		= "<t align='left' size='1.2'><br />";

    {
        private["_Color", "_Plus"];
        _b = _x # 0;
        _kN = _x # 1;
        _Color	= "#d7ffd7";
        _Plus	= if (_b >= 0) then {"+"} else {""};
        _Text	= _Text + format["<br /><t color='#ffae2b'>%2%3$</t> <t color='%1'>%4</t>", _Color, _Plus, _b, _kN]
    } forEach WF_KillPay_Array;

    _Text		= _Text + "</t>";
    _CtrlText ctrlSetStructuredText parseText _Text;
    shallRemoveBountyScore = false;
};

_isTimeToCleanUp = {
    _result = false;
    if(time - 5 > bountyTimeAppearance) then { _result = true };
    _result
};

_cleanUp = {
    6890 cutText ["","PLAIN",1];
    WF_KillPay_Array 	= [];
    uiNamespace setVariable ["Display_KillPay", nil]
};

if (count(WF_KillPay_Array) < 5) then {
	WF_KillPay_Array set [count(WF_KillPay_Array), [_bounty, _killedName]];
}else {
	WF_KillPay_Array set [0,-1];
	WF_KillPay_Array = WF_KillPay_Array - [-1];
	WF_KillPay_Array set [count(WF_KillPay_Array), [_bounty, _killedName]];
};

if (isNil "_display") then{
	6890 cutRsc ["MSG_KillPay","PLAIN",0.5];
	[] call _fillKillPayTitle;
	if (isNil 'isCleanUpStarted') then { isCleanUpStarted = false };
	if !(isCleanUpStarted) then {
        [_isTimeToCleanUp, _cleanUp] spawn {
            params ["_isTimeToCleanUp", "_cleanUp"];
            isCleanUpStarted = true;
            _isCleanedUp = false;
            while {!(_isCleanedUp)} do {
                sleep 5;
                if([] call _isTimeToCleanUp) then {
                    [] call _cleanUp;
                    _isCleanedUp = true
                }
            };
            isCleanUpStarted = false
        }
	}
} else {
	[] call _fillKillPayTitle
};