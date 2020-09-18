if ((count _this) < 1) exitWith {debugLog "Log: [returnVehicleTurrets] Function requires at least 1 parameter!"; []};

params ["_entry"];

//Validate parameters
if ((typeName _entry) != (typeName configFile)) exitWith {debugLog "Log: [returnVehicleTurrets] Entry (0) must be a Config!"; []};

private ["_turrets", "_turretIndex"];
_turrets = [];
_turretIndex = 0;

//Explore all turrets and sub-turrets recursively.
for "_i" from 0 to ((count _entry) - 1) do
{
	private ["_subEntry"];
	_subEntry = _entry select _i;
	
	if (isClass _subEntry) then
	{
		private ["_hasGunner","_isset","_pcom","_pgun"];
		_hasGunner = [_subEntry, "hasGunner"] Call BIS_fnc_returnConfigEntry;

		_pgun = [_subEntry, "primaryGunner"] Call BIS_fnc_returnConfigEntry;
		_pcom = [_subEntry, "primaryObserver"] Call BIS_fnc_returnConfigEntry;
		
		_isset = false;
		if (_pgun == 1 && !vhasGunner) then {vhasGunner = true;_isset = true};
		if (_pcom == 1 && !vhasCommander && !_isset) then {vhasCommander = true};
		
		//Make sure the entry was found.
		if !(isNil "_hasGunner") then 
		{
			if (_hasGunner == 1) then 
			{
				_turrets pushBack (_turretIndex);
				
				//Include sub-turrets, if present.
				if (isClass (_subEntry >> "Turrets")) then 
				{
					_turrets pushBack ([_subEntry >> "Turrets"] Call WFCO_fnc_getConfigVehicleTurretsReturn);
				} 
				else 
				{
					_turrets pushBack ([]);
				};
			};
		};

		_turretIndex = _turretIndex + 1;
	};
};

_turrets