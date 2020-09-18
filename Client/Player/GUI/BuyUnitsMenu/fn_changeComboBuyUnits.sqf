Private['_get','_lb','_type'];
_lb = _this select 0;
_type = _this select 1;

lbClear _lb;
{
	lbAdd [_lb,_x];
} forEach (missionNamespace getVariable Format["WF_%1%2FACTIONS",WF_Client_SideJoinedText,_type]);

_get = missionNamespace getVariable Format["WF_%1%2CURRENTFACTIONSELECTED",WF_Client_SideJoinedText,_type];
if (isNil '_get') then {
	lbSetCurSel [_lb,0];
} else {
	lbSetCurSel [_lb,_get];
};