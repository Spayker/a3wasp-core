private ["_array","_index"];

_array = +_this;
_tolower = [];

{_tolower pushBack (toLower _x)} forEach _array;

_tolower