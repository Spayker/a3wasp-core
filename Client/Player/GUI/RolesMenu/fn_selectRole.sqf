private["_roleName","_roleDetails","_requiredRoles","_reqStatus","_roleStatus","_status"];
disableSerialization;
_roleName = lbData [2801, lbCurSel(2801)];
_reqStatus = true;
_roleStatus = true;
_status = "";

ctrlEnable[2804, true];
ctrlEnable[2805, true];
if (_roleName == "") exitWith {
    ((findDisplay 2800) displayCtrl 2802) ctrlSetStructuredText parseText "";
    ((findDisplay 2800) displayCtrl 2822) ctrlSetStructuredText parseText "";
    ((findDisplay 2800) displayCtrl 2806) ctrlSetStructuredText parseText "";
    ctrlEnable[2804, false];
    ctrlEnable[2805, false];
};

WF_IsRoleListUpdated = false;

_roleDetails = [_roleName, WF_Client_SideJoined] call WFCO_fnc_getRoleDetails;

    _funds = call WFCL_FNC_GetPlayerFunds;
    if (_funds < (_roleDetails select 4)) then {
        _roleStatus = false;
    };


if ((_roleDetails select 6) <= (_roleDetails select 7)) then {
    _reqStatus = false;
};

if (_reqStatus && _roleStatus) then {
    _status = "<t size='1.8' color='#20DB16'>You are able to buy this role.</t>";
} else {
    if (!_reqStatus) then {
        _status = "<t size='1.8' color='#DB1620'>Max role limit is reached.</t><br/>";
    };
    if (!_roleStatus) then {
        _status = format["%1<t size='1.8' color='#DB1620'>You do not have enought funds to buy this role.</t>", _status];
    };
};

if ((_roleDetails select 0) in WF_gbl_boughtRoles) then {
    ctrlEnable[2804, false];
    _status = "<t size='1.8' color='#006BC9'>You have already bought this skill.</t>";
} else {
    ctrlEnable[2804, true];
    ctrlEnable[2805, false];
};

    _cost = str (_roleDetails select 4) + "$";


((findDisplay 2800) displayCtrl 2806) ctrlSetStructuredText parseText format[
    "<t size='4.2' align='center' color='#ffae2b'>%1</t><br/>",
    (_roleDetails select 1)
];

((findDisplay 2800) displayCtrl 2802) ctrlSetStructuredText parseText format[
        "<t size='1.8'>%1</t><br/>
            <br/>"+
                "<t size='1.8' color='#ffae2b'>Cost:</t> <t size='1.8'>%2</t><br/>"+"%3",
                    format ([(_roleDetails select 2)] + (_roleDetails select 5)),
                        _cost,_status];

((findDisplay 2800) displayCtrl 2822) ctrlSetStructuredText parseText format[
    "<t size='1.8' color='#ffae2b'>Available Slots:</t> <t size='1.8'>%1</t><br/>", "Updating..."
];

[WF_Client_SideJoined, player, _roleName] remoteExecCall ["WFSE_fnc_getRoleList", 2];