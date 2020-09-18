/*
	Retrieve a random position.
	 Parameters:
		- Position
		- Min Radius
		- Max Radius
*/

private ["_radius","_direction","_limit"];
params ["_position", "_minRadius", "_maxRadius"];
_direction = random 360;

if (typeName _position == "OBJECT") then {_position = getPos _position};
if (count _position < 3) then {_position set [2, 0]};

_radius = (random (_maxRadius - _minRadius)) + _minRadius;
_position = [(_position select 0)+((sin _direction)*_radius),(_position select 1)+((cos _direction)*_radius),(_position select 2)];

//--Make limit for this loop--
_limit = 0;

while {surfaceIsWater _position && _limit < 100} do {
	_direction = random 360;
	_radius = (random (_maxRadius - _minRadius)) + _minRadius;
	_position = [(_position select 0)+((sin _direction)*_radius),(_position select 1)+((cos _direction)*_radius),(_position select 2)];
	_limit = _limit + 1;
};

_position