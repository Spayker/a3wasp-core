/* Swap Element A with Element B in an array. */
Private ["_array","_elea","_eleb","_posa","_posb"];
_array = _this select 0;
_posa = _this select 1;
_posb = _this select 2;

_elea = _array select _posa;
_eleb = _array select _posb;

_array set [_posa, _eleb];
_array set [_posb, _elea];

_array;