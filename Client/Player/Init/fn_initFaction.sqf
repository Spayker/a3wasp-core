Private ['_c','_list','_r','_side','_type','_u'];
params ["_type","_side","_list"];

_r = [localize 'STR_WF_COMMAND_All'];
_u = [];

{
	_c = missionNamespace getVariable _x;
	if !(isNil '_c') then {
		if !((_c # QUERYUNITFACTION) in _r) then {

			_r pushBack (_c # QUERYUNITFACTION);
		};
	};
} forEach _list;

missionNamespace setVariable [Format["WF_%1%2FACTIONS",_side,_type],_r];