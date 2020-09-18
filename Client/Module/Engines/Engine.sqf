params ["_vehicle", "_isOn"];

private _get = _vehicle getVariable 'ID';

if (!isNil '_get') then {
	if (!_isOn) then {
		_vehicle setVariable ["Fuel",fuel _vehicle];
		_vehicle setFuel 0;
		_vehicle addAction ["<t color='"+"#00E4FF"+"'>ENABLE ENGINE</t>", "Client\Module\Engines\Startengine.sqf",[], 7];
	};
	
	_vehicle setVariable ["ID",nil];
};
