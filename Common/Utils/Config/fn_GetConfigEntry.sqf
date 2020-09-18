/*
	Return a config entry. (adapted from BIS)
	 Parameters:
		- Config
		- Object
*/

params ["_config", "_entryName"];

//--- Validate parameters
if ((typeName _config) != (typeName configFile)) exitWith {debugLog "Log: [returnConfigEntry] Starting class (0) must be of type Config!"; nil};
if ((typeName _entryName) != (typeName "")) exitWith {debugLog "Log: [returnConfigEntry] Entry name (1) must be of type String!"; nil};

private ["_entry", "_value"];
_entry = _config >> _entryName;

//--- If the entry is not found and we are not yet at the config root, explore the class' parent.
if (((configName (_config >> _entryName)) == "") && (!((configName _config) in ["CfgVehicles", "CfgWeapons", ""]))) then {
	[inheritsFrom _config, _entryName] call WFCO_FNC_GetConfigEntry;
} else {
	//--- Supporting either Numbers or Strings, and array ofc!
	switch (true) do {
		case (isNumber _entry): {_value = getNumber _entry};
		case (isText _entry): {_value = getText _entry};
		case (isArray _entry): {_value = getArray _entry};
	};
};

//--- Make sure returning 'nil' works.
if (isNil "_value") exitWith {nil};
 
_value