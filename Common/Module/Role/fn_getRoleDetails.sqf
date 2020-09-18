params [["_skill","",[""]], "_side"];

_skillDetails = [];

{
    if ((_x # 0) isEqualType "") then {
        if ((_x # 0) == _skill) exitWith {
            _skillDetails = _x;
        };
    } else {
        private ["_y"];
        _y = _x;

        {
            if ((_x # 0) == _skill) exitWith {
                _skillDetails = _x;
            };
        } foreach _y;
    };

    if (count _skillDetails != 0) exitWith  {};

} foreach ([_side] call WFCO_fnc_roleList);

_skillDetails;