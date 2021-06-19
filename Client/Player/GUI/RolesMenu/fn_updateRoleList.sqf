Private ['_roleList','_role'];

_roleList = [WF_Client_SideJoined] call WFCO_fnc_roleList;
_role = _roleList select (_this select 0);
_role set [7, _this select 1];

_roleName = _role select 0;
_roleDetails = [_roleName, WF_Client_SideJoined] call WFCO_fnc_getRoleDetails;
if (count _roleDetails > 0) then {
((findDisplay 2800) displayCtrl 2822) ctrlSetStructuredText parseText format[
    "<t size='1.8' color='#ffae2b'>Available Slots:</t> <t size='1.8'>%1</t><br/>",
   ((_roleDetails select 6) - (_roleDetails select 7))
    ]
}
