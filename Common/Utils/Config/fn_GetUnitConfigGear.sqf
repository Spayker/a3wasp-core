/*
	Return the gear of a unit from the config.
	 Parameters:
		- Unit kind
*/

Private ["_backpack","_get_backpack_content","_kind","_magazines","_root","_weapons"];

_kind = _this;

_root = configFile >> 'CfgVehicles' >> _kind;
_weapons = getArray(_root >> 'weapons') - ["Throw", "Put"];
_magazines = getArray(_root >> 'magazines');
_backpack = getText(_root >> 'backpack');
_get_backpack_content = [[[],[]],[[],[]]];

if (_backpack != "") then {
	if (isClass(configFile >> 'CfgVehicles' >> _backpack >> 'TransportWeapons')) then {
		Private ["_cname","_get","_root_sub"];
		for '_j' from 0 to count(configFile >> 'CfgVehicles' >> _backpack >> "TransportWeapons")-1 do {
			_root_sub = (configFile >> 'CfgVehicles' >> _backpack >> 'TransportWeapons') select _j;
			_cname = getText(_root_sub >> 'weapon');
			_get = missionNamespace getVariable _cname;
			
			if !(isNil '_get') then {
				((_get_backpack_content select 0) select 0) pushBack _cname;
				((_get_backpack_content select 0) select 1) pushBack (getNumber(_root_sub >> 'count'));
			};
		};
	};
	if (isClass(configFile >> 'CfgVehicles' >> _backpack >> 'TransportMagazines')) then {
		Private ["_cname","_count","_get","_root"];
		for '_j' from 0 to count(configFile >> 'CfgVehicles' >> _backpack >> "TransportMagazines")-1 do {
			_root = (configFile >> 'CfgVehicles' >> _backpack >> 'TransportMagazines') select _j;
			_cname = getText(_root >> 'magazine');
			_get = missionNamespace getVariable Format["Mag_%1",_cname];
			
			if !(isNil '_get') then {
				((_get_backpack_content select 1) select 0) pushBack _cname;
				((_get_backpack_content select 1) select 1) pushBack (getNumber(_root >> 'count'));
			};
		};
	};
};

[_weapons, _magazines, _backpack, _get_backpack_content]