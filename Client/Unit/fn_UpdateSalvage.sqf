private["_vehicle","_salvagerRange","_percentage"];
_vehicle = param [0];

_salvagerRange = missionNamespace getVariable "WF_C_UNITS_SALVAGER_SCAVENGE_RANGE";
_percentage = missionNamespace getVariable "WF_C_UNITS_SALVAGER_SCAVENGE_RATIO";

while {!WF_GameOver || !(alive _vehicle)} do {
	if(!(isNull (driver _vehicle)) && !WF_GameOver && alive _vehicle) then
	{		
		_vehicles = nearestObjects [getPos _vehicle, ['Car','Motorcycle','Ship','Air','Tank','StaticWeapon'],_salvagerRange];

		_wrecks = [];
		{
			if !(alive _x) then {_wrecks pushBack _x};
		} forEach _vehicles;

		_hqs = [];
		{_hqs = _hqs + [_x Call WFCO_FNC_GetSideHQ]} forEach WF_PRESENTSIDES;

		_wrecks = _wrecks - _hqs;

		_overAllCost = 0;
		{
			_isNeeded = _x getVariable 'keepAlive';
		
			if (isNil '_isNeeded') then {
				_get = missionNamespace getVariable (typeOf _x);
				_salvageCost = 250;
				if !(isNil '_get') then {
					_salvageCost = round(((_get # QUERYUNITPRICE)*_percentage) / 100);
				};
		
				_overAllCost = _overAllCost + _salvageCost;
				(Format [localize 'STR_WF_CHAT_Salvaged_Unit',_salvageCost,[typeOf _x,'displayName'] Call WFCO_FNC_GetConfigInfo]) Call WFCL_FNC_GroupChatMessage;
		
				deleteVehicle _x;
			};
		} foreach _wrecks;

		if (_overAllCost > 0) then {(_overAllCost) Call WFCL_FNC_ChangePlayerFunds};
	};
	sleep 5;
};