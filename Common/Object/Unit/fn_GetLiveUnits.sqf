Private["_liveUnits","_units"];

_units = _this;

_liveUnits = [];

{if (alive _x) then {_liveUnits pushBack (_x)}} forEach _units;
_liveUnits
