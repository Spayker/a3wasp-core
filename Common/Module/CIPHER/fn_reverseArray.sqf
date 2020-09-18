Private ["_array","_reversed","_u"];
_array = _this;
_reversed = [];

_u = 0;
for '_i' from count(_array)-1 step -1 to 0 do {
    _reversed set [_u, _array select _i];
    _u = _u + 1;
};

_reversed