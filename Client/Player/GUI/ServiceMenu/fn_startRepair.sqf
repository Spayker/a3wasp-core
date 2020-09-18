Private ['_airCoef','_artCoef','_cts','_distanceMin','_heaCoef','_i','_ligCoef','_name','_nearIsDP','_nearIsRT','_nearIsSP','_repairRange','_repTime','_spType','_supportRange','_supports','_typeRepair','_veh'];
_veh = _this select 0;
_supports = _this select 1;
_typeRepair = _this select 2;
_spType = _this select 3;
_supportRange = missionNamespace getVariable "WF_C_UNITS_SUPPORT_RANGE";
_repairRange = missionNamespace getVariable "WF_C_UNITS_REPAIR_TRUCK_RANGE";

//--- Retrieve Informations.
_name = [typeOf _veh, 'displayName'] Call WFCO_FNC_GetConfigInfo;
_repTime = missionNamespace getVariable "WF_C_UNITS_SUPPORT_REPAIR_TIME";

//--- SP?
_nearIsSP = false;
_nearIsDP = false;
_nearIsRT = false;
{
	if ((typeOf _x) == _spType) then {_nearIsSP = true};
	if ((typeOf _x) in WF_Logic_Depot) then {_nearIsDP = true};
	if ((typeOf _x) in _typeRepair) then {_nearIsRT = true};
} forEach _supports;

//--- Coefficient Vary depending on the support type.
_airCoef = 1;
_artCoef = 1;
_heaCoef = 1;
_ligCoef = 1;
if (_nearIsRT) then {
	_airCoef = 2.4;
	_artCoef = 1.8;
	_heaCoef = 1.6;
	_ligCoef = 1.4;
};
if (_nearIsDP) then {
	_airCoef = 1.9;
	_artCoef = 1.5;
	_heaCoef = 1.3;
	_ligCoef = 1.1;
};
if (_nearIsSP) then {
	_airCoef = 1.4;
	_artCoef = 1;
	_heaCoef = 0.8;
	_ligCoef = 0.6;
};

//--- Class Malus.
if (_veh isKindOf 'Air') then {_repTime = round(_repTime * (_airCoef + getDammage _veh))};
if (_veh isKindOf 'StaticWeapon') then {_repTime = round(_repTime * (_artCoef + getDammage _veh))};
if (_veh isKindOf 'Tank') then {_repTime = round(_repTime * (_heaCoef + getDammage _veh))};
if (_veh isKindOf 'Car' || _veh isKindOf 'Motorcycle') then {_repTime = round(_repTime * (_ligCoef + getDammage _veh))};

//--- Inform the player.
hint parseText(Format[localize "STR_WF_INFO_Repairing",format["%1 [%2] %3", group _veh, _veh call WFCO_FNC_GetAIDigit, _name],_repTime]);

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

	if (_cts == 0 || !(alive _veh) || (getPos _veh) select 2 > 2) exitWith {_cts = 0;hint parseText(Format[localize "STR_WF_INFO_Repair_Failed",_name])};
	if (_i >= _repTime) exitWith {hint parseText(Format[localize "STR_WF_INFO_Repair_Success",format["%1 [%2] %3", group _veh, _veh call WFCO_FNC_GetAIDigit, _name]])};
};

//--- Fix the damages?
if (_cts != 0) then {
	_veh setDammage 0;
};