private ["_blastPos","_radius5000rem", "_allUnits", "_mark5000rem", "_h"];

_blastPos = _this select 0;
_radius5000rem = _this select 1;
if (_radius5000rem == -1) exitWith{};
_allUnits = _blastPos nearObjects ["Man", _radius5000rem];

{ 
    _h = [objNull, "GEOM"] checkVisibility [_blastPos, getPosASL _x];
    if ( (_h >= 0.5) && isDamageAllowed _x) then {
        _x setDamage[1, true];
    }
} forEach _allUnits