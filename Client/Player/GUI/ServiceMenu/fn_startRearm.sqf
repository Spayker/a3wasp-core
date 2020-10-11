params ["_veh", "_supports", "_typeRepair", "_spType", ["_isAirBase", false]];
private ['_airCoef','_artCoef','_cts','_distanceMin','_heaCoef','_i','_ligCoef','_name','_nearIsDP','_nearIsRT','_nearIsSP','_repairRange','_rearmTime','_supportRange'];

_supportRange = missionNamespace getVariable "WF_C_UNITS_SUPPORT_RANGE";
_repairRange = missionNamespace getVariable "WF_C_UNITS_REPAIR_TRUCK_RANGE";

//--- Retrieve Informations.
_name = [typeOf _veh, 'displayName'] Call WFCO_FNC_GetConfigInfo;
_rearmTime = missionNamespace getVariable "WF_C_UNITS_SUPPORT_REARM_TIME";

//--- SP?
_nearIsSP = false;
_nearIsDP = false;
_nearIsRT = false;
{
	if ((typeOf _x) == _spType) then {_nearIsSP = true};
	if (((typeOf _x) in WF_Logic_Depot) || ((typeOf _x) in WF_Logic_Airfield)) then {_nearIsDP = true};
	if ((typeOf _x) in _typeRepair) then {_nearIsRT = true};
} forEach _supports;

_isAirVehicle = (typeOf _veh) iskindOf "Air";
if (_isAirVehicle && !_isAirBase && _nearIsDP) exitWith {
    [format["%1", localize "STR_WF_SERVICE_CANTAIR_INTOWN"]] spawn WFCL_fnc_handleMessage
};


//--- Coefficient Vary depending on the support type.
_airCoef = 1;
_artCoef = 1;
_heaCoef = 1;
_ligCoef = 1;
if (_nearIsRT) then {
	_airCoef = 3.4;
	_artCoef = 3;
	_heaCoef = 2.8;
	_ligCoef = 2.6;
};
if (_nearIsDP) then {
	_airCoef = 2.5;
	_artCoef = 2.4;
	_heaCoef = 2.2;
	_ligCoef = 2;
};
if (_nearIsSP) then {
	_airCoef = 1.9;
	_artCoef = 1.7;
	_heaCoef = 1.5;
	_ligCoef = 1.2;
};

//--- Class Malus.
if (_veh isKindOf 'Air') then {_rearmTime = round(_rearmTime * _airCoef)};
if (_veh isKindOf 'StaticWeapon') then {_rearmTime = round(_rearmTime * _artCoef)};
if (_veh isKindOf 'Tank') then {_rearmTime = round(_rearmTime * _heaCoef)};
if (_veh isKindOf 'Car' || _veh isKindOf 'Motorcycle') then {_rearmTime = round(_rearmTime * _ligCoef)};

//--- Inform the player.
[Format[localize "STR_WF_INFO_Rearming",format["%1 [%2] %3", group _veh, _veh call WFCO_FNC_GetAIDigit, _name],_rearmTime]] spawn WFCL_fnc_handleMessage;

//--- Make sure that we still have something as a support.
_cts = 0;
_i = 0;
while {true} do {
	sleep 1;

	//--- Check the distance & alive.
	_cts = 0;
	{
		_distanceMin = if ((typeOf _x) in _typeRepair) then {_repairRange} else {_supportRange};
		if ((alive _x) && ((_veh distance _x) < _distanceMin)) then {_cts = _cts + 1};
	} forEach _supports;

	_i = _i + 1;

	if (_cts == 0 || !(alive _veh) || (getPos _veh) select 2 > 2) exitWith {
	    _cts = 0;
	    [format[localize "STR_WF_INFO_Rearm_Failed",_name]] spawn WFCL_fnc_handleMessage
	};
	if (_i >= _rearmTime) exitWith {
	    [format[localize "STR_WF_INFO_Rearm_Success",format["%1 [%2] %3", group _veh, _veh call WFCO_FNC_GetAIDigit, _name]]] spawn WFCL_fnc_handleMessage
	};
};

//--- Rearm?
if (_cts != 0) then {
	[_veh, WF_Client_SideJoined] spawn WFCO_FNC_RearmVehicle;
};