params ["_side", "_type", "_shallGetEntity"];
private ["_towns", "_townTypes", "_count"];

_towns = (_side) call WFCO_FNC_GetSideTowns;
_foundSpecialLocations = [];

{
    _townTypes = _x getVariable "townSpeciality";
    if (_type in _townTypes) then { _foundSpecialLocations pushBack _x }
} forEach _towns;

if(_shallGetEntity) exitWith { _foundSpecialLocations };

_count = count _foundSpecialLocations;

_count