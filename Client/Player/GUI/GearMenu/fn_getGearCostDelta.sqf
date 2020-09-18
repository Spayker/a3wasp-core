private ["_cost", "_find", "_gear_new", "_gear_old", "_item_cost"];

_gear_old = +(_this # 0);
_gear_new = +(_this # 1);

_cost = 0;


if (uiNamespace getVariable "wf_dialog_ui_gear_target" isKindOf "Man") then {
    _gear_old = (_gear_old) call WFCO_FNC_ConvertGearToFlat;
    _gear_new = (_gear_new) call WFCO_FNC_ConvertGearToFlat
};

if (typeName(_gear_old) == "ARRAY") then {
    {
        _find = _gear_new find _x;
        _item_cost = (_x) call WFCO_FNC_GetGearItemCost;
        if !(_find isEqualTo -1) then {
            _gear_new set [_find, false]
        } else {
            _cost = _cost - (_item_cost * 0.5)
        }
    } forEach _gear_old;

    _gear_new = _gear_new - [false];

    {
        _item_cost = (_x) call WFCO_FNC_GetGearItemCost;
        _cost = _cost + _item_cost
    } forEach _gear_new
};

round _cost