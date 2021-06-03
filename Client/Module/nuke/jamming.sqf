//Changed in 0.3.0
//Changed in 0.2.0


private ["_blastPos","_radius1","_allVehicles", "_prevSate", "_i", "_jammed"];


_blastPos = _this select 0;
_radius1 = _this select 1;


_allVehicles = nearestObjects [_blastPos ,["LandVehicles", "Air", "Ship"], _radius1 * 2]; //get affected vehicles

_jammed = "HitAvionics"; 

_prevSate = [];
_prevSate resize (count _allVehicles);
_i = 0;

//save the state of the instruments prior to the jamming effect and then damage them
{
_prevSate set [_i, _x getHitPointDamage _jammed];
_x setHitPointDamage [_jammed, 1.0];
_i = _i + 1;
} forEach _allVehicles;

sleep 50;

_i = 0;

//restore effects to prevState, over time
for "_k" from 1 to 100 do
{

	{

	if((1 - _k / 100) > (_prevSate select _i)) then {_x setHitPointDamage [_jammed, 1 - _k / 100];};

	} forEach _allVehicles;

	sleep 0.25;
}