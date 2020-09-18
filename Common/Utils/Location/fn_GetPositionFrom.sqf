Private["_destination","_distance","_direction","_position"];

_position = _this Select 0;
if (TypeName _position != "ARRAY") then {_position = Position _position};

_distance = _this Select 1;

_direction = _this Select 2;
if (TypeName _direction != "SCALAR") then {_direction = [_position,_direction] Call GetDirTo};

[(_position Select 0)+((sin _direction)*_distance),(_position Select 1)+((cos _direction)*_distance),(_position Select 2)]