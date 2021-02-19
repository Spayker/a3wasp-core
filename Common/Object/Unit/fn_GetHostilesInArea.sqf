private ['_hostiles','_objects'];
params ["_object", "_safeFromSide", ["_within", 50]];

_objects = _object nearEntities[WF_C_ALL_MAN_VEHICLE_KINDS,_within];
_hostiles = 0;

if (_safeFromSide isEqualType []) then {
	{
		_hostiles = _hostiles + (_x countSide _objects);
	} forEach _safeFromSide;
};
if (_safeFromSide isEqualType WEST) then {
	_hostiles = _hostiles + (_safeFromSide countSide _objects);
};

_hostiles