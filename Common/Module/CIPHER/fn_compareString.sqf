/* Compare whether string A is greater than string B */
private ["_aisgreater","_stringA","_stringB"];
_stringA = toArray(_this # 0);
_stringB = toArray(_this # 1);

_aisgreater = false;

for '_i' from 0 to count(_stringA)-1 do {
    if (_i > count(_stringB)-1) exitWith {_aisgreater = true};
    if ((_stringA # _i) != (_stringB # _i)) exitWith {
        _aisgreater = ((_stringA # _i) > (_stringB # _i));
    };
};

_aisgreater;