private ["_fog"];

32 setovercast 0;
sleep 128;
64 setovercast 1;
sleep 64;
//setwind
_fog = fog + 0.3;
if ( _fog > 1 ) then {_fog = 1};
64 setfog _fog;
64 setrain 1;