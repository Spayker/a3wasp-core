private ["_gear", "_list", "_u"];
_gear = _this;

lnbClear 70109;
_list = [];

_u = 0;

{
    _item = _x;
    if (({_x isEqualTo _item} count _list) < 1) then {
        _count = {_x isEqualTo _item} count _gear;
        _config = (_item) call WFCO_FNC_GetConfigType;
        lnbAddRow [70109, [format ["x%1", _count], format ["%1", getText(configFile >> _config >> _item >> 'displayName')]]];
        lnbSetPicture [70109, [_u, 0], getText(configFile >> _config >> _item >> 'picture')];
        lnbSetData [70109, [_u, 0], _item];
        lnbSetValue [70109, [_u, 0], _count];
        _list pushBack _item;
        _u = _u + 1;
    };
} forEach _gear;