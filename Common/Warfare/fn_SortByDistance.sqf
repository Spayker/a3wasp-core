/*
	Return a list of entity or position sorted according to a center.
	 Parameters:
		- Entity.
		- List.
*/
Private["_current","_nearest","_nearestDistance","_object","_objects","_sorted"];

_object = _this # 0;
_objects = +(_this # 1);

_sorted = [];
if(typeName _object != "OBJECT") then {
	if(_object isEqualType []) exitwith { _sorted };
	if(_object isEqualType "") exitwith { _sorted };
};

for '_i' from 0 to count(_objects)-1 do {
	_nearest = ObjNull;
	_index = -1;
	if (count _this > 2) then {
        _nearestDistance = _this # 2
    } else {
        _nearestDistance = 100000
    };

	for '_j' from count(_objects)-1 to 0 step -1 do {
		_current = _objects # _j;
		if(typeName _current != "STRING")then{
			_distance = _current distance _object;
		
			if (_distance < _nearestDistance) then {
			    _nearest = _current;
			    _nearestDistance = _distance;_index = _j
			}
		}
	};
	
	_sorted pushBack _nearest;	
	if(_index > -1) then { _objects deleteAt _index }
};

_sorted - [objNull]