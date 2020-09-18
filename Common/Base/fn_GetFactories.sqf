params ["_side", "_kind", "_buildings"];
private ["_list","_type"];

_list = [];

if !(isNil '_kind') then {
    _type = (missionNamespace getVariable format["WF_%1STRUCTURENAMES", _side]) # _kind;
    {if (typeOf _x == _type && alive _x) then {_list pushBack _x}} forEach _buildings
};

_list