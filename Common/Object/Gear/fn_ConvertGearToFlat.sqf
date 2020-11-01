private ["_classnames", "_gear"];
_gear = _this;

_classnames = [];
{
	if (_x select 0 != "") then { _classnames pushBack (_x select 0) };
	{ if (_x != "") then { _classnames pushBack _x } } forEach (_x select 1);
	if (count(_x select 2) > 0) then { _classnames pushBack ((_x select 2) select 0) };
} forEach (_gear select 0);

{
	if (_x select 0 != "") then { _classnames pushBack (_x select 0) };
	{ if (_x != "") then { _classnames pushBack _x } } forEach (_x select 1);
} forEach (_gear select 1);

{
	if (_x != "") then { _classnames pushBack _x };
} forEach (_gear select 2);

{
	if(!isnil "_x")then{
		{
		    _item = _x;
            if(typeName _x == 'ARRAY') then { _item = _item # 0 };
		    if (_item != "") then { _classnames pushBack _item }
		} forEach _x;
	};
} forEach (_gear select 3);

_classnames