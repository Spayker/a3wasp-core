/*
	Script: Engineer Skill System by Benny.
	Description: Add special skills to the defined engineer.
*/
Private ['_dammages','_skip','_vehicle','_vehicles','_z'];

_vehicles = player nearEntities [WF_C_CAR_MOTO_SHIP_TANK_AIR_KINDS,5];
if (count _vehicles < 1) exitWith {};

_vehicle = [player,_vehicles] Call WFCO_FNC_GetClosestEntity;

_dammages = getDammage _vehicle;

if !(_vehicle isKindOf "Plane") then {
	_vehicle_hit_point_damage_array = getAllHitPointsDamage _vehicle;
	if(count _vehicle_hit_point_damage_array > 1) then {
		_array = _vehicle_hit_point_damage_array select 2;
		{_dammages = _dammages + _x} forEach _array;
		_dammages = _dammages / count (_array);
	};
} else {_dammages = damage _vehicle};

if (_dammages <= 0) exitWith {};
WF_SK_V_LastUse_LR = time;

_skip = false;

[format["%1", localize 'STR_HINT_FieldStarted']] spawn WFCL_fnc_handleMessage;

for [{_z = 0},{_z < 25},{_z = _z + 1}] do {
	player playMove "Acts_carFixingWheel";
	sleep 1;
	if (!alive player || vehicle player != player || !alive _vehicle || _vehicle distance player > WF_C_NEAREST_VEHICLE_RANGE) exitWith {
	    [format["%1", localize 'STR_HINT_FieldFailed']] spawn WFCL_fnc_handleMessage;
	    _skip = true;
	}
};

if (!alive player || vehicle player != player || !alive _vehicle || _vehicle distance player > WF_C_NEAREST_VEHICLE_RANGE) exitWith {
    [format["%1", localize 'STR_HINT_FieldFailed']] spawn WFCL_fnc_handleMessage;
    _skip = true
};


if (!_skip) then {
	_dammages = _dammages - .15;
	if (_dammages < 0) then {_dammages = 0};
	_vehicle setDammage _dammages;
	[format["%1", localize 'STR_HINT_FieldComplete']] spawn WFCL_fnc_handleMessage
};

player switchmove "";