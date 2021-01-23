params ["_building", "_selectedGroupTemplate", "_factory", "_cpt", "_commonTime", "_selectedGroupTemplateDescription"];
private ["_commander","_crew","_currentUnit","_unitdescription","_unitlogo","_direction","_distance","_driver","_extracrew","_factoryPosition","_factoryType","_group","_gunner","_index","_init","_isArtillery","_isMan","_locked","_longest","_position","_queu","_queu2","_ret","_show","_soldier","_waitTime","_txt","_type","_upgrades","_unique","_vehicle","_unitskin"];

groupQueu = groupQueu + _cpt;

_distance = 0;
_direction = 0;
_longest = 0;
_position = 0;
_factoryType = "";
_unitdescription = "";
_unitlogo = "";
_unitskin = -1;

_currentUnit =  missionNamespace getVariable (_selectedGroupTemplate # 0);
_unitdescription = _currentUnit # QUERYUNITLABEL;
_unitlogo = _currentUnit # 1;

_type = typeOf _building;
_index = (missionNamespace getVariable Format ["WF_%1STRUCTURENAMES",WF_Client_SideJoinedText]) find _type;
if (_index != -1) then {
	_distance = (missionNamespace getVariable Format ["WF_%1STRUCTUREDISTANCES",WF_Client_SideJoinedText]) # _index;
	_direction = (missionNamespace getVariable Format ["WF_%1STRUCTUREDIRECTIONS",WF_Client_SideJoinedText]) # _index;
	_factoryType = (missionNamespace getVariable Format ["WF_%1STRUCTURES",WF_Client_SideJoinedText]) # _index;
	_position = _building modelToWorld [(sin _direction * _distance), (cos _direction * _distance), 0];
	_position set [2, .5];
	_longest = missionNamespace getVariable Format ["WF_LONGEST%1BUILDTIME",_factoryType];
} else {
	if (_type in WF_Logic_Depot) then {
		_distance = missionNamespace getVariable "WF_C_DEPOT_BUY_DISTANCE";
		_direction = missionNamespace getVariable "WF_C_DEPOT_BUY_DIR";
		_factoryType = "Depot";
	};
	if (_type == WF_Logic_Airfield) then {
		_distance = missionNamespace getVariable "WF_C_HANGAR_BUY_DISTANCE";
		_direction = missionNamespace getVariable "WF_C_HANGAR_BUY_DIR";
		_factoryType = "Airport";
	};

	_position = _building modelToWorld [(sin _direction * _distance), (cos _direction * _distance), 0];
	_position set [2, .5];
	_longest = missionNamespace getVariable Format ["WF_LONGEST%1BUILDTIME",_factoryType];
};

_unique = varGroupQueu;
varGroupQueu = time + random 10000 - random 500 + diag_frameno;
_queu = _building getVariable "groupQueu";
if (isNil "_queu") then {_queu = []};
_queu pushBack _unique;

_building setVariable ["groupQueu",_queu,true];

_ret = 0;
_queu2 = [0];

if (count _queu > 0) then {_queu2 = _building getVariable "groupQueu"};

_show = false;
while {_unique != _queu # 0 && alive _building && !isNull _building} do {
	sleep 4;
	_show = true;
	_ret = _ret + 4;
	_queu = _building getVariable "groupQueu";

	if (_queu # 0 == _queu2 # 0) then {
		if (_ret > _longest) then {
			if (count _queu > 0) then {
				_queu = _building getVariable "groupQueu";
				_queu = _queu - [_queu select 0];
				_building setVariable ["groupQueu",_queu,true];
			};
		};
	};
	if (count _queu != count _queu2) then {
		_ret = 0;
		_queu2 = _building getVariable "groupQueu";
	};
};

if (_show) then { [Format [localize "STR_WF_INFO_BuyEffective",_unitdescription]] spawn WFCL_fnc_handleMessage };

_position = [_position, 30] call WFCO_fnc_getEmptyPosition;
[player,_selectedGroupTemplate, _position, _direction] remoteExecCall ["WFSE_fnc_buyGroup", 2];

sleep _commonTime;

_queu = _building getVariable "groupQueu";

_queu = _queu - [_unique];
_building setVariable ["groupQueu",_queu,true];

if (!alive _building || isNull _building) exitWith {
	groupQueu = groupQueu - _cpt;
	missionNamespace setVariable [Format["WF_C_GROUP_QUEUE_%1",_factory],(missionNamespace getVariable Format["WF_C_GROUP_QUEUE_%1",_factory])-1];
};

groupQueu = groupQueu - _cpt;

missionNamespace setVariable [Format["WF_C_GROUP_QUEUE_%1",_factory],(missionNamespace getVariable Format["WF_C_GROUP_QUEUE_%1",_factory])-1];
[Format [localize "STR_WF_INFO_Build_Complete",_selectedGroupTemplateDescription, _unitlogo]] spawn WFCL_fnc_handleMessage