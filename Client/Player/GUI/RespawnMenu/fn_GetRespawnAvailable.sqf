params ["_side", "_deathLoc"];
private ["_availableSpawn","_base_respawn","_buildings","_checks","_deathLoc","_farps","_has_baserespawn","_mhqs","_mobileRespawns","_range","_side","_sideText","_upgrades"];

_sideText = str _side;
_enemySide = sideEnemy;

//--- Base.
_mhqs = (WF_Client_SideJoined) Call WFCO_FNC_GetSideHQ;
_availableSpawn = _mhqs;
_buildings = (_side) Call WFCO_FNC_GetSideStructures;
_checks = [_side,missionNamespace getVariable Format["WF_%1BARRACKSTYPE",_sideText],_buildings] Call WFCO_FNC_GetFactories;
if (count _checks > 0) then {_availableSpawn = _availableSpawn + _checks};
_checks = [_side,missionNamespace getVariable Format["WF_%1LIGHTTYPE",_sideText],_buildings] Call WFCO_FNC_GetFactories;
if (count _checks > 0) then {_availableSpawn = _availableSpawn + _checks};
_checks = [_side,missionNamespace getVariable Format["WF_%1HEAVYTYPE",_sideText],_buildings] Call WFCO_FNC_GetFactories;
if (count _checks > 0) then {_availableSpawn = _availableSpawn + _checks};
_checks = [_side,missionNamespace getVariable Format["WF_%1AIRCRAFTTYPE",_sideText],_buildings] Call WFCO_FNC_GetFactories;
if (count _checks > 0) then {_availableSpawn = _availableSpawn + _checks};

_base_respawn = _availableSpawn - _mhqs;
_has_baserespawn = false;
{
    _has_baserespawn = if (alive _x || count _base_respawn > 0) then {true} else {false};
    //--- HQ is dead, but we can spawn at other buildings.
    if (!alive _x && count _availableSpawn > 1) then {_availableSpawn = _availableSpawn - [_x]};
} forEach _mhqs;


//--- Mobile respawn.
if ((missionNamespace getVariable "WF_C_RESPAWN_MOBILE") > 0) then {
	_mobileRespawns = missionNamespace getVariable [format["WF_AMBULANCES_%1", _side], []];
	_upgrades = (_side) Call WFCO_FNC_GetSideUpgrades;
	_range = (missionNamespace getVariable "WF_C_RESPAWN_RANGES") select (_upgrades select WF_UP_RESPAWNRANGE);
	_checks = _deathLoc nearEntities[_mobileRespawns,_range];
	if (count _checks > 0) then {
		{
			_availableSpawn pushBackUnique _x
		} forEach _checks
	}
};

//--- Camps.
if ((missionNamespace getVariable "WF_C_RESPAWN_CAMPS_MODE") > 0) then {
	_availableSpawn = _availableSpawn + ([_deathLoc, _side] Call WFCO_FNC_GetRespawnCamps);
};

//--- Military Bases
_towns =(WF_Client_SideJoined) call WFCO_FNC_GetSideTowns;
{
    _townSpecialities = _x getVariable ["townSpeciality", []];
    if (WF_C_MILITARY_BASE in (_townSpecialities) || WF_C_AIR_BASE in (_townSpecialities)) then {
        _enemySide = [[west], [east]] select (_side == west);
        _enemySide pushBack (resistance);
        _respawnMinRange = missionNamespace getVariable "WF_C_RESPAWN_CAMPS_SAFE_RADIUS";
        _hostiles = [_x, _enemySide,_respawnMinRange] Call WFCO_FNC_GetHostilesInArea;
        if (_hostiles == 0) then { _availableSpawn pushBackUnique _x }
    }
} forEach _towns;



_availableSpawn