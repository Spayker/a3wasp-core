private ["_blastPos","_radius100thermal", "_allUnits", "_mark100thermal", "_h"];

_blastPos = _this select 0;
_radius100thermal = _this select 1;

if (_radius100thermal == -1) exitWith{};

_allUnits = _blastPos nearObjects ["Man", _radius100thermal];

{ 
    _h = [objNull, "GEOM"] checkVisibility [getPosASL _x, _blastPos];
    if ( _h >= 0.5 && isDamageAllowed _x) then {
        _x setDamage[damage _x + 0.1, true]
    }
} forEach _allUnits;




