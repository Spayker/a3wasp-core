/*
	Initialize a unit for clients (JIP Compatible).
*/

params ["_unit", "_sideID"];
private ["_get","_isMan","_logik","_side","_unit_kind"];

_unit_kind = typeOf _unit;

if !(alive _unit) exitWith {}; //--- Abort if the unit is null or dead.

waitUntil{!isNil "commonInitComplete"};
waitUntil {commonInitComplete}; //--- Wait for the common part.
_side = (_sideID) call WFCO_FNC_GetSideFromID;
_logik = (_side) call WFCO_FNC_GetSideLogic;

// --- [Generic Vehicle initialization] (Run on all clients AND server)
if !(local player) exitWith {}; //--- We don't need the server to process it.
if!(isHeadLessClient) then {
waitUntil {clientInitComplete}; //--- Wait for the client part.
};

_isMan = (_unit isKindOf 'Man');
// --- [Generic Vehicle initialization] (Run on all clients)

if(local _unit && !(_unit hasWeapon "NVGoggles")) then {
	_unit addWeapon "NVGoggles";
};

if (_unit_kind in (missionNamespace getVariable "WF_REPAIRTRUCKS")) then { //--- Repair Trucks.
	//--- Build action.
    _unit addAction [localize 'STR_WF_BuildMenu_Repair',
    {call WFCL_fnc_callBuildMenuForRepairTruck}, [], 1000, false, true, '',
    format['side player == side _target && alive _target && player distance _target <= %1',
    missionNamespace getVariable 'WF_C_UNITS_REPAIR_TRUCK_RANGE']];
	//--- Build action.
	_unit addAction [localize 'STR_WF_Repair_Camp',{call WFCL_fnc_RepairCamp}, [], 97, false, true, '', '_camp = [_unit] call WFCL_FNC_GetNearestCamp; (!isNull _camp && (isObjectHidden _camp))'];
};

if (_unit isKindOf "Tank" || _unit isKindOf "Car") then {
	//--- Valhalla Low gear.
	_unit addAction ["<t color='#FFBD4C'>"+(localize "STR_ACT_LowGearOn")+"</t>","Client\Module\Valhalla\LowGear_Toggle.sqf", [], 91, false, true, "", "(player==driver _target) && !Local_HighClimbingModeOn && canMove _target"];
	_unit addAction ["<t color='#FFBD4C'>"+(localize "STR_ACT_LowGearOff")+"</t>","Client\Module\Valhalla\LowGear_Toggle.sqf", [], 91, false, true, "", "(player==driver _target) && Local_HighClimbingModeOn && canMove _target"];
};

if (_unit isKindOf "Ship") then { //--- Boats.
	//--- Push action.
	_unit addAction [localize "STR_WF_Push",{call WFCL_fnc_pushVehicle}, [], 93, false, true, "", 'driver _target == _this && alive _target && speed _target < 30'];
};

if (_unit isKindOf "Air") then { //--- Air units.
	if ((getNumber (configFile >> 'CfgVehicles' >> _unit_kind >> 'transportSoldier')) > 0) then { //--- Transporters only.
		//--- HALO action.
		_unit addAction ['HALO',{call WFCL_fnc_doHalo}, [], 97, false, true, '', format['getPos _target # 2 >= %1 && alive _target', missionNamespace getVariable 'WF_C_PLAYERS_HALO_HEIGHT']];
		//--- Cargo Eject action.
		_unit addAction [localize 'STR_WF_Cargo_Eject',{call WFCL_fnc_ejectCargo}, [], 99, false, true, '', 'driver _target == _this && alive _target'];
	};

    if!(isHeadLessClient) then {
	//--AAR Tracking--
	if (WF_Client_SideJoined != _side) then { //--- Track the unit via AAR System, skip if the unit side is the same as the player one.
		[_unit, _side] spawn WFCO_FNC_trackAirTargets;

		//--AAR Upgrade > 1--
		_drawAirIconEH = addMissionEventHandler ["Draw3D", {
			_object = missionNamespace getVariable [format["unitForDraw3D%1", _thisEventHandler], objNull];

			if(!isNull _object && antiAirRadarInRange) then {
				_currentUpgrades = (WF_Client_SideJoined) call WFCO_FNC_GetSideUpgrades;
				_curARRLevel = _currentUpgrades # WF_UP_AAR1;

				//--If AAR Upgrade level is > 1 then drawIcon3D--
				if(_curARRLevel > 1) then {
					_height = missionNamespace getVariable "WF_C_STRUCTURES_ANTIAIRRADAR_DETECTION";
					if (((getPos _object) # 2) > _height) then {
						_pos = ASLToAGL getPosASL _object;
						_vehName = getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName");
						_showArrow = false;

						//--If AAR Upgrade level is > 2 then show arrow in screen edges and show distance--
						if(_curARRLevel > 2) then {
							_showArrow = true;
							_vehName = format["%1 [%2]", _vehName, player distance _object];
						};
						drawIcon3D [getText (configFile >> "CfgVehicles" >> typeOf _object >> "icon"),
                            [0.3,0.3,0.5,1], _pos, 0.8, 0.8, getDir _object, _vehName, 1, 0.03, "TahomaB", "", _showArrow]
                        }
                    }
			};

                if(!alive _object) then { removeMissionEventHandler ["Draw3D", _thisEventHandler] }
		}];
            missionNamespace setVariable [format["unitForDraw3D%1", _drawAirIconEH], _unit]
        }
	};

	if (_unit isKindOf "Plane") then { //--- Planes.
		_unit addAction [localize "STR_WF_TaxiReverse",{call WFCL_fnc_taxiReverse}, [], 92, false, true, "", 'driver _target == _this && alive _target && speed _target < 4 && speed _target > -4 && getPos _target # 2 < 4'];
	};
};

//---[Side specific initialization] (Run on the desired client team).
waitUntil {!isNil 'sideID'};
if (sideID != _sideID) exitWith {};

/*
if !(_isMan) then { //--- Vehicle Specific.
    if ((missionNamespace getVariable "WF_C_GAMEPLAY_MISSILES_RANGE") != 0) then { //--- Max missile range.
        _unit addEventHandler ['incomingMissile', {_this spawn WFCO_FNC_HandleIncomingMissile}]; //--- Handle incoming missiles.
    };
};
*/

if !(isHeadLessClient) then {

Private ["_color","_markerName","_params","_size","_txt","_type"];
//--- Map Marker tracking.
_type = "mil_dot";
_color = missionNamespace getVariable (format ["WF_C_%1_COLOR", _side]);
_size = [1,1];
_txt = "";
_params = [];

unitMarker = unitMarker + 1;
_markerName = format ["unitMarker%1", unitMarker];

if (_isMan) then { //--- Man.
	_type = "mil_dot";
	_size = [0.5,0.5];
	if (group _unit == group player) then {
		_color = "ColorOrange";
		_txt = (_unit) call WFCO_FNC_GetAIDigit;
	};
        _params = [_type,_color,_size,_txt,_markerName,_unit,2,true,"waypoint",_color,false,_side,[1,1]];
} else { //--- Vehicle.
        if (local _unit && isMultiplayer) then {_color = "ColorOrange"};
	if (_unit_kind in (missionNamespace getVariable format["WF_%1REPAIRTRUCKS",str _side])) then {_type = "mil_box";};//--- Repair.
        if (_unit_kind in (missionNamespace getVariable ["WF_AMBULANCES", []])) then {_color = "ColorYellow"};//--- Medical.
        _params = [_type,_color,_size,_txt,_markerName,_unit,2,true,"waypoint",_color,false,_side,[2,2]];
        if (_unit in ((_side) call WFCO_FNC_GetSideHQ)) then {
            _color = "ColorOrange";
            _params = ['b_hq',_color,[1,1],'HQ','HQUndeployed',_unit,1,false,'','',false,_side]
        }//--- HQ.
};

    _params spawn WFCO_FNC_MarkerUpdate;
}