Private ["_mhq"];

_mhq = _this select 0;

if (!([WF_Client_SideJoined, _mhq] Call WFCO_FNC_GetSideHQDeployStatus)) then {
	_mhq addAction [localize "STR_WF_Unlock_MHQ",{call WFCL_fnc_toggleLock}, [], 95, false, true, '', 'alive _target && (locked _target == 2)',10];
	_mhq addAction [localize "STR_WF_Lock_MHQ",{call WFCL_fnc_toggleLock}, [], 94, false, true, '', 'alive _target && (locked _target == 0)',10];
};