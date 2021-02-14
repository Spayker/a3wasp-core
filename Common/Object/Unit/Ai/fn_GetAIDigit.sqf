Private ["_i","_split","_unit","_yield"];

_unit = _this;

if (_unit == leader (group _unit)) exitWith {
    if(isPlayer _unit) then {
        name _unit
    } else {
        "Leader"
    }
};

_split = toArray(str _unit);

_find = _split find 58;
_yield = [];

if (_find != -1) then {
	for '_i' from (_find+1) to count(_split)-1 do {
		if ((_split select _i) == 65 || (_split select _i) == 32) exitWith {};
		_yield pushBack (_split select _i);
	};
};

if (count _yield == 0) exitWith {''};

toString(_yield)