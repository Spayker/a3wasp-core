/* Sort an array by alphabetical order, selection sort. */
private['_auxArray','_min','_reverse'];
params ["_list"];

_auxArray = [];
for '_i' from 0 to (count _list)-1 do {_auxArray set [_i, _i]};

if (count _list == 0) exitWith {[]};
_isString = ((_list # 0) isEqualType "");

for '_i' from 0 to (count _list)-1 do {
    _min = _i;

    for '_j' from _i+1 to (count _list)-1 do {
        if (_isString) then {
            if !([_list # _j, _list # _min] Call WFCO_fnc_compareString) then {_min = _j}
        } else {
            if ((_list # _j) < (_list # _min)) then {_min = _j};
        };
    };

    if (_min != _i) then {
        _list = [_list, _i, _min] Call WFCO_fnc_swapArray;
        _auxArray = [_auxArray, _i, _min] Call WFCO_fnc_swapArray;
    };
};

[_list, _auxArray]