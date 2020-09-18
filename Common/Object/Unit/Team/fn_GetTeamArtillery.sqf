Params ["_team","_ignoreAmmo","_index","_side","_logik"];
Private["_artillery","_artyTypes","_artyWeapons","_count","_ignoreAmmo","_index","_position","_search","_side","_team","_units","_vehicle","_haveAmmo","_weapons","_x","_y"];

if (_index < 0) exitWith {[]};

_units = units _team;

_artyTypes = (missionNamespace getVariable Format ["WF_%1_ARTILLERY_CLASSNAMES",_side]) # _index;
if (!isNull(commanderTeam)) then {
    if (commanderTeam == Group player) then {
        _purchasedGroups = [WF_Client_SideJoined] call WFCO_FNC_getHighCommandGroups;
        {
            _groupUnits = units _x;
            {
                _units pushBack (vehicle _x)
            } forEach _groupUnits
        } foreach _purchasedGroups;

        _areas = _logik getVariable "wf_basearea";
        {
            _areaPos = getPosATL _x;
            _units = _units + (_areaPos nearEntities [WF_STATIC_ARTILLERY, WF_C_BASE_AREA_RANGE])
        } forEach _areas;
    }
};

_artillery = [];
{
	_vehicle = vehicle _x;
	if (typeOf(_vehicle) in _artyTypes) then {
		if (!(isNull(gunner _vehicle)) && !(_vehicle in _artillery) && !(isPlayer(gunner _vehicle))) then {
			if !(isPlayer(gunner _vehicle)) then {
				_haveAmmo = false;
				_weapons = _vehicle weaponsTurret [0];
				
				{
					if((_vehicle ammo _x) > 0) then { _haveAmmo = true }
				} forEach _weapons;

				if (_ignoreAmmo || _haveAmmo) then {
					_artillery pushBack (_vehicle)
				}
			}
		}
	}
} forEach _units;

_artillery