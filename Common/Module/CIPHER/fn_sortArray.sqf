private["_min"];
params ["_list", "_reverse", ["_auxArray", []]];

if (count _list == 0) exitWith {[]};
_isString = ((_list # 0) isEqualType "");

for '_i' from 0 to (count _list)-1 do {
    _min = _i;

    for '_j' from _i+1 to (count _list)-1 do {
        if (_isString) then {
            if !([_list select _j, _list select _min] Call WFCO_fnc_compareString) then {_min = _j}
        } else {
            if ((_list select _j) < (_list select _min)) then {_min = _j};
        };
    };

    if (_min != _i) then {
        _list = [_list, _i, _min] Call WFCO_fnc_swapArray;
        if (count _auxArray > 0) then {_auxArray = [_auxArray, _i, _min] Call WFCO_fnc_swapArray};
    };
};

if (_reverse) then {
    _list = (_list) Call WFCO_fnc_reverseArray;
    if (count _auxArray > 0) then {_auxArray = (_auxArray) Call WFCO_fnc_reverseArray};
};

[_list, _auxArray]