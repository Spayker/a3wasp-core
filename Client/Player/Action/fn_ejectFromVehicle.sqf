Private['_unit', '_action', '_from', '_unit'];

_unit = _args select 0;
_action = _args select 1;
_from = _args select 2;
_unit action [_action, _from];
unassignVehicle _unit;