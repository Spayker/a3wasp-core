Private ["_unit","_weapon","_limit","_ammo","_rocket","_distance","_pos","_vel","_speed","_at","_t"];
_unit = _this select 0;
_weapon = _this select 1;
_ammo = _this select 4;

_timer=0;
_speednorm=0.001;
_speednormed=[1,1,1];
_pos=getPos _unit;
_timestart = time;
_rocket = nearestObject [_unit,_ammo];
_StartingVel = velocity _rocket;
_affectedbombs = WF_C_BOMBS_TO_DISABLE_AUTOGUIDE;

if(_ammo in _affectedbombs)then{ 
  
	if (isPlayer _unit) then {_target =cursorTarget} else {_target = assignedTarget _unit;};
	while {!isNull _rocket} do {      
		_time = time - _timestart;
		_speed0 = (_StartingVel select 0);
		_speed1 = (_StartingVel select 1);
		_speed2 = (_StartingVel select 2) - ((9)*(_time));
		_speednorm = ((_speed0)^2+(_speed1)^2+(_speed2)^2)^(0.5);
		_speednormed = [(_speed0/_speednorm),(_speed1/_speednorm),(_speed2/_speednorm)];
		_velguidednormed2 = _speed2/_speednorm;
		_rocket setvectorDirandUp [[(_speed0/_speednorm),(_speed1/_speednorm),_velguidednormed2],[0,0,1]];
		_rocket setVelocity [(_speed0),(_speed1),(_speed2)];
	};
};















