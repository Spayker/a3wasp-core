private["_count","_currentPosition","_direction","_obstacles","_placed","_retPos","_vehicles"];
scopeName "PlaceSafe";

params["_position", ["_radius", 35]];
_retPos = [];

_currentPosition = _position;
_placed = false;
_direction = 0;

for [{_count = 0},{_count < 40 && !_placed},{_count = _count + 1}] do {
	_obstacles = _currentPosition nearEntities [["Building"], 15];
	_vehicles = _currentPosition nearEntities [["Building","Car","Tank","Air"], 7];

	if (count _obstacles > 0 || count _vehicles > 0 || surfaceIsWater _currentPosition) then {
		_currentPosition = [(_position # 0)+((sin _direction)*_radius),(_position # 1)+((cos _direction)*_radius),.5];
		_direction = _direction + 36;
		if (_count > 15) then {_radius = _radius + 50};
	} else {
		_retPos = _currentPosition;
		_placed = true;
		breakTo "PlaceSafe";
	};
};

_retPos