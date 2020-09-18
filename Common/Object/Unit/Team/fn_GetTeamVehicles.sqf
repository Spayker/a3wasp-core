Private["_canMove","_count","_crew","_ignoreOwnerConflict","_member","_ownerConflict","_range","_team","_teamVehicles","_units","_vehicle"];

_team = _this select 0;
_canMove = _this select 1;

_member = objNull;
_range = 150;
if (count _this > 2) then {_member = _this select 2};
if (count _this > 3) then {_range = _this select 3};

_ignoreOwnerConflict = false;
if (count _this > 4) then {_ignoreOwnerConflict = _this select 4};

_teamVehicles = [];
_units = units _team;

 {
	_vehicle = vehicle _x;
 
 	if (_x != _vehicle && !(_vehicle in _teamVehicles)) then {_teamVehicles pushBack (_vehicle)};
	if (_canMove && !canMove _vehicle) then {_teamVehicles = _teamVehicles - [_vehicle]};
	if (!IsNull _member && _member distance _vehicle > _range) then {_teamVehicles = _teamVehicles - [_vehicle]};

	_ownerConflict = false;
	_crew = crew _vehicle;
	{if (_x != leader _team && isPlayer _x) then {_ownerConflict = true}} forEach _crew;
	if (!_ignoreOwnerConflict && _ownerConflict) then {_teamVehicles = _teamVehicles - [_vehicle]};
 } forEach _units;

_teamVehicles