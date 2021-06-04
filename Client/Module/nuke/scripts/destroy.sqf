private ["_object", "_bomb", "_pos"];

_object = _this select 0;

_pos = getpos _object;
_bomb = "Bo_GBU12_LGB" createvehicle [_pos select 0, _pos select 1, (_pos select 2) + 0.1];
_bomb setvelocity [0, 0, -100];
_object setdammage 1;

sleep 5;

_bomb = "Radio" createvehicle _pos;
_bomb allowdammage false;
//_bomb say ["nuclear_boom", argt_nuclear_radius];

sleep 17;
deletevehicle _bomb;
deletevehicle _object;