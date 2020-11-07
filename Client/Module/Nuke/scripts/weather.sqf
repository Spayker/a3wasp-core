private ["_fog"];

32 setovercast 0;
sleep 128;
_fog = fog + 0.3;
if ( _fog > 1 ) then {_fog = 1};
64 setfog _fog;
