Params ["_artillery","_destination","_side","_radius"];
Private["_angle","_artillery","_artillery_classes","_artillery_type","_burst","_destination","_dispersion","_direction","_distance","_FEH","_gunner","_i","_index","_minRange","_maxRange","_position","_radius","_reloadTime","_side","_type","_velocity","_watchPosition","_weapon","_xcoord","_ycoord"];

_index = [typeOf _artillery, _side] Call WFCO_FNC_IsArtillery;
_minRange = (missionNamespace getVariable Format ["WF_%1_ARTILLERY_RANGES_MIN",_side]) # _index;
_maxRange = round(((missionNamespace getVariable Format ["WF_%1_ARTILLERY_RANGES_MAX",_side]) # _index) / (missionNamespace getVariable "WF_C_ARTILLERY"));
_dispersion = (missionNamespace getVariable Format ["WF_%1_ARTILLERY_DISPERSIONS",_side]) # _index;

_artillery setVariable ["restricted",true,true];
{if(isPlayer _x) then {_x action  ["getOut", _artillery]};} forEach (crew _artillery);

_gunner = gunner _artillery;
if (_index == -1) exitWith {["WARNING", Format ["fn_FireArtillery.sqf: No artillery types were found for [%1].", _artillery]] Call WFCO_FNC_LogContent};
if (isNull _gunner) exitWith {["WARNING", Format ["fn_FireArtillery.sqf: Artillery [%1] gunner is null.", _artillery]] Call WFCO_FNC_LogContent};
if (isPlayer _gunner) exitWith {["WARNING", Format ["fn_FireArtillery.sqf: Artillery [%1] gunner is a player", _artillery]] Call WFCO_FNC_LogContent};

_minRange = (missionNamespace getVariable Format ["WF_%1_ARTILLERY_RANGES_MIN",_side]) # _index;
_maxRange = round(((missionNamespace getVariable Format ["WF_%1_ARTILLERY_RANGES_MAX",_side]) # _index) / (missionNamespace getVariable "WF_C_ARTILLERY"));

[_artillery] Call WFCO_FNC_prepareArtyMission; //--- Prepare the artillery unit to the fire mission submission.

//--- Artillery Calculations.
_position = getPos _artillery;
_xcoord = (_destination # 0) - (_position # 0);
_ycoord = (_destination # 1) - (_position # 1);
_direction =  -(((_ycoord atan2 _xcoord) + 270) % 360);
if (_direction < 0) then {_direction = _direction + 360};
_distance = sqrt ((_xcoord ^ 2) + (_ycoord ^ 2)) - _minRange;
_angle = _distance / (_maxRange - _minRange) * 100 + 15;
if (_angle > 70) then {_angle = 70};
if (_distance < 0 || _distance + _minRange > _maxRange) exitWith {};

{_gunner disableAI _x} forEach ['MOVE','TARGET','AUTOTARGET'];
_watchPosition = [_destination # 0, _destination # 1, (_artillery distance _destination)/(tan(90-_angle))];

(_gunner) doWatch _watchPosition;

sleep 5;

if !(alive _artillery) exitWith {
	if (alive _gunner) then {{_gunner enableAI _x} forEach ['MOVE','TARGET','AUTOTARGET']};
};

_reloadTime = (missionNamespace getVariable Format ["WF_%1_ARTILLERY_TIME_RELOAD",_side]) # _index;
_burst = (missionNamespace getVariable Format ["WF_%1_ARTILLERY_BURST",_side]) # _index;
_art_pos = getPosATL _artillery;

if(_side == west) then {
	[_art_pos, east] remoteExec ["WFCL_FNC_ARRadarMarkerUpdate", east]
} else {
	[_art_pos, west] remoteExec ["WFCL_FNC_ARRadarMarkerUpdate", west]
};


for '_i' from 1 to _burst do {
	sleep (_reloadTime+random 3);
	if (!alive _gunner || !alive _artillery) exitWith {};
	
	//--- Randomize Land Area.
	_distance = random (_distance / _maxRange * 100) + random _radius;
	_direction = random 360;

	//--- Default Position.
	_landDestination = [((_destination # 0)+((sin _direction)*_distance))+(random _dispersion)-(random _dispersion),(_destination # 1)+((cos _direction)*_distance)+(random _dispersion)-(random _dispersion),0];
	
    _artillery doArtilleryFire [_landDestination, currentMagazine _artillery, 0];
    sleep 5;
    _artillery fire (currentWeapon _artillery)
};

if (alive (_gunner)) then {{_gunner enableAI _x} forEach ['MOVE','TARGET','AUTOTARGET']};

[_artillery] Call WFCO_FNC_finishArtyMission; //--- Free the artillery unit from the fire mission submission.
sleep 5;

_artillery setVariable ["restricted",false,true];