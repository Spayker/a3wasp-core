params ["_side"];
private ["_side", "_groups", "_isPurchased"];

_groups = [];

{
    _isPurchased = _x getVariable ["isHighCommandPurchased", false];
    if(_isPurchased && (side _x == _side) && count (units _x) > 0 ) then {
        _groups pushBack _x;
    }
} forEach allGroups;

_groups