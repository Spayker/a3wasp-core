//--- Display the items from a container
private ["_config", "_find", "_list", "_item", "_items"];
_list = _this;

lnbClear 70109;

_items = [[], []];
if (count _list > 0) then {
    {
        _find = (_items select 0) find _x;
        if (_find isEqualTo -1) then {
            (_items select 0) pushBack _x;
            (_items select 1) pushBack 1;
        } else {
            (_items select 1) set [_find, ((_items select 1) select _find) + 1];
        };
    } forEach _list;
};

for '_i' from 0 to count(_items select 0)-1 do {
    _item = (_items select 0) select _i;
    _config = (_item) call WFCO_FNC_GetConfigType;

    lnbAddRow [70109, [format ["x%1", (_items select 1) select _i], format ["%1", getText(configFile >> _config >> _item >> 'displayName')]]];
    lnbSetPicture [70109, [_i, 0], getText(configFile >> _config >> _item >> 'picture')]; // listbox of magazines
    lnbSetData [70109, [_i, 0], _item];
    lnbSetValue [70109, [_i, 0], (_items select 1) select _i];
};