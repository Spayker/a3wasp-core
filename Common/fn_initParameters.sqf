/*
	Parameters Constants Initialization, use the same class name for parameter as variables.
*/

for '_i' from 0 to (count (missionConfigFile >> "Params"))-1 do {
	_paramName = (configName ((missionConfigFile >> "Params") select _i));
	_value = [getNumber (missionConfigFile >> "Params" >> _paramName >> "default"), paramsArray # _i] select (isMultiplayer);
	
	missionNamespace setVariable [_paramName, _value];
};

["INITIALIZATION", "fn_initParameters.sqf: Parameters are defined."] Call WFCO_FNC_LogContent;