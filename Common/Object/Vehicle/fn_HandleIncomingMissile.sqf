Private ["_limit","_source","_target","_distance"];
params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

_limit = missionNamespace getVariable "WF_C_GAMEPLAY_MISSILES_RANGE";
_source = getPos _unit;
_target = missileTarget _projectile;

_distance = _target distance _source;
	
	if (_distance > _limit) then {
    waitUntil {_projectile distance _source > _limit};
    deleteVehicle _projectile;
};