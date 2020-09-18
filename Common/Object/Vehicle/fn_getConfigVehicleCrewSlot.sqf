/* Adapted from BIS turret's function. */
private ['_entry','_turrestcount','_turrets'];

_entry = configFile >> 'CfgVehicles' >> _this >> 'Turrets';

vhasCommander = false;
vhasGunner = false;
_turrets = [_entry] Call WFCO_fnc_getConfigVehicleTurretsReturn;

tmp_overall = [];

if (count _turrets > 0) then {
	[_turrets, []] Call WFCO_fnc_getConfigVehicleTurrets;
};

_turrestcount = count ([_this, false] call BIS_fnc_allTurrets);
if(_turrestcount == 1) then { _turrestcount = 0 };

if (vhasGunner) then {_turrestcount = _turrestcount - 1};
if (vhasCommander) then {_turrestcount = _turrestcount - 1};


_result = [[vhasCommander,vhasGunner,count(tmp_overall)+1, _turrestcount], tmp_overall];
{
    if(_this == (_x # 0)) exitWith { _result = [_x # 1, []] }
} forEach WF_VEHICLES_WITH_EXTRA_SLOT_ISSUE;

_result