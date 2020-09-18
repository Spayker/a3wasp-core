/*
	Find turrets recursively (based on http://community.bistudio.com/wiki/weaponsTurret)
	 Parameters:
		- Config root
		- Turret Path
*/

private ["_root", "_class", "_path", "_currentPath"];

_root = _this select 0;
_path = +(_this select 1);

for "_i" from 0 to count _root -1 do {
	_class = _root select _i;
	if (isClass _class) then {
		_currentPath = _path + [_i];
		_result set [count _result, [getArray(_class >> "weapons"), getArray(_class >> "magazines"), _currentPath, str _class]];
		_class = _class >> "turrets";
		if (isClass _class) then {[_class, _currentPath] call WFCO_FNC_FindTurretsRecursive};
	};
};