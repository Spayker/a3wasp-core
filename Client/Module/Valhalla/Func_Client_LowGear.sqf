/*
	Script from Valhalla.
*/

Private ["_vehicle"];
_vehicle = _this;
_increase_velo_coef=1.5;

_direction = {
	private["_vel","_veh","_vdir","_dir"];
	
	_vel=_this select 0;
	_veh=_this select 1;
	
	_vdir=(_vel select 0) atan2 (_vel select 1);
	if (_vdir < 0) then {_vdir=_vdir+360};
	_dir=getDir _veh;
	if (_dir < 0) then {_dir=_dir+360};
	
	_vdir=_vdir-_dir;
	
	if (abs(_vdir) < 15) then {true} else {false};
};

_min=30;
_max=70;

if (_vehicle isKindOf "Tank") then { _min=25; _max=35 };


while {(player==(driver _vehicle)) && (Local_HighClimbingModeOn) && (canMove _vehicle)} do {
	_speed=speed _vehicle;
	_vel=velocity _vehicle;	
	if (_speed < _min) then	{
		if ((Local_KeyPressedForward) && (isEngineOn _vehicle)) then {
			if (_speed > 0) then {			
				if ([_vel,_vehicle] call _direction) then {
					_vel=[(_vel select 0)*_increase_velo_coef,(_vel select 1)*_increase_velo_coef,(_vel select 2)*_increase_velo_coef];
					_vehicle setVelocity _vel;
				};
			};		
		};		
	} else {	
		if (_speed > _max) then {		
			if ([_vel,_vehicle] call _direction) then {
				_vel=[(_vel select 0)*0.7,(_vel select 1)*0.7,(_vel select 2)*0.7];
				_vehicle setVelocity _vel;
			};
		};
	};
	sleep 0.1;
};

Local_HighClimbingModeOn=false;