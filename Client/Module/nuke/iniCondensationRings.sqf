//Changed in 0.5.0
//Changed in 0.3.0
private["_blastPos", "_rainLevel", "_fogLevel", "_yield", "_radius", "_n", "_int", "_airMode"];


_blastPos = _this select 0;
_yield = _this select 1;
_radius = _this select 2;
_radius = _radius * 5;
_airMode = _this select 3;
_rainLevel = rain;
_fogLevel = fog;



if (((_fogLevel >= 0.05) || (_rainLevel >= 0.05)) && (_yield != -1)) then 
{	
	//calculate amount of rings
	if(_yield <= 10) then {_n = 0;};
	if(_yield > 10 && _yield <= 50) then {_n = 1;};
	if(_yield > 50 && _yield <= 1000) then {_n = 2;};
	if(_yield > 1000) then {_n = 3;};
	
	//create the rings
	if(! _airMode) then
	{
		for "_i" from 0 to _n do 
		{
			[[_blastPos, _radius * 0.5 + _i * _radius * 0.1, _radius - (_i + 1) * _radius * 0.1],"freestyleNuke\condensationRing.sqf"] remoteExec ["execVM",0];
			sleep 0.5;
		};
	}
	else
	{	
		for "_j" from 0 to _n do
		{
			private _i = switch(_j) do
			{
				case 0: {0};
				case 1:	{1};
				case 2: {-1};
				case 3: {2};
				default {0};
			};
			[[_blastPos, _i * _radius * 0.1, _radius - (_i + 1) * _radius * 0.1],"freestyleNuke\condensationRing.sqf"] remoteExec ["execVM",0];
			sleep 0.5;
		};
	};
};


if(! _airMode) then
{
	_int = 4;
	if (_yield <= 5) then {_int = 2};
	if (_yield > 5 && _yield <= 50) then {_int = 3};

	[_int] call BIS_fnc_earthquake;
};
