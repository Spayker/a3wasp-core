params ["_vehicle", "_sideId", "_locked", ["_bounty", true], ["_global", true], ["_skin", -1]];
private ["_side", "_vehicle", "_isHQ"];

_side = (_sideId) Call WFCO_FNC_GetSideFromID;

if (_locked) then {_vehicle lock _locked};

_vehicle spawn WFCO_FNC_ClearVehicleCargo;

_isHQ = (typeOf _vehicle == (missionNamespace getVariable [Format["WF_%1MHQNAME", _side], ""]));

//-- Init HQ
if(_isHQ) then {
    _vehicle setVariable ["wf_side", _side, true];
    _vehicle setVariable ["wf_trashable", false, true];
    _vehicle setVariable ["wf_structure_type", "Headquarters", true];
    _vehicle setVariable ["wf_hq_deployed", false, true];
    _vehicle addMPEventHandler ["MPHit",{
        params ["_unit", "_causedBy", "_damage", "_instigator"];

        if(WF_C_BASE_ALLOW_TEAM_DAMMAGE <= 0 && ((side _causedBy) == (_unit getVariable "wf_side"))) then {
            _unit setDammage ((getDammage _unit) - _damage)
        } else {
            if(!hasInterface && !isDedicated)then{
                [_unit] call WFHC_FNC_BuildingDamaged;

                if!(alive _unit) then {
                    [_unit, _causedBy] call WFHC_FNC_OnHQKilled
                }
            }
        }

    }];

	_logik = (_side) Call WFCO_FNC_GetSideLogic;
	_hqs = _logik getVariable ["wf_hq", []];
	_hqs = _hqs - [objNull];
	_hqs pushBack _vehicle;

	_logik setVariable ["wf_hq", _hqs, true];
	_hqs = _logik getVariable ["wf_hq", []];
} else {
    [_vehicle] remoteExec ["WFSE_FNC_addEmptyVehicleToQueue", 2]
};

[_vehicle, _bounty, _sideId, _side, _global, _skin, _ishq] spawn {
    params ["_vehicle", "_bounty", "_sideId", "_side", "_global", "_skin", "_ishq"];


    if (_global) then {
            if (_vehicle isKindOf "Air") then { //--- Air units.
            _enemySide = civilian;
                if(_side == west) then {_enemySide = east};
                if(_side == east) then {_enemySide = west};
            if(_side == resistance) then {_enemySide = resistance};
            if (_sideId != WF_DEFENDER_ID) then {
                [_vehicle, _sideId] remoteExec ["WFCO_FNC_updateUnitMarkerStorage",_side, true]
            };
            [_vehicle, _side] remoteExec ["WFCO_FNC_performAirVehicleTracking", _enemySide, true]
        } else {
            if (_sideId != WF_DEFENDER_ID) then {
                [_vehicle, _sideId] remoteExec ["WFCO_FNC_updateUnitMarkerStorage",_side, true];
            }
        }
    };

    if(typeOf _vehicle == (missionNamespace getVariable [Format["WF_%1SUPPLY_TRUCK", _side], ""])) then {

        _vehicle addEventHandler ["GetIn", {
            params ["_vehicle", "_role", "_unit", "_turret"];
            _isSupplyVehicle = _vehicle getVariable ['isSupplyVehicle', false];
            if(_isSupplyVehicle && _role == "driver") then {
                (localize "STR_WF_CHAT_Commander_Supply_Truck_Move_Order") remoteExecCall ["WFCL_FNC_GroupChatMessage", _unit]
            }

         }];

        _vehicle addEventHandler ["GetOut", {
        	params ["_vehicle", "_role", "_unit", "_turret"];
        	if(_role == "driver") then { [_vehicle, group (_unit)] call WFCO_fnc_SellSupplyTruck }
        }]
    };

	if (_bounty && !_isHQ) then {
		_vehicle addMPEventHandler ['MPKilled', {[_this # 0,_this # 1] call WFCO_FNC_OnUnitKilled}];
		_vehicle addMPEventHandler ["MPHit",{_this call WFCO_FNC_OnUnitHit}];
	};

	//--Check if vehicle is arty vehicle and add EH--
    {
        if(typeOf _vehicle == (_x # 0)) exitWith {
    		[_vehicle, ["Fired", {
            	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
    			if(isPlayer _gunner || _gunner == (missionNamespace getVariable ["wf_remote_ctrl_unit", objNull])) then {
    				deleteVehicle _projectile;
    			};
            }]] remoteExec ["addEventHandler", -2, true];
        };
    } forEach (missionNamespace getVariable [format['WF_%1_ARTILLERY_CLASSNAMES', _side], []]);

	_vehicle addEventHandler ["GetOut", {
		private _vehicle = param [0, objNull, [objNull]];
		if !((crew _vehicle) isEqualTo []) exitWith {};
		(_vehicle call BIS_fnc_getPitchBank) params ["_vx","_vy"];
		if (([_vx,_vy] findIf {_x > 80 || _x < -80}) != -1) then {
			0 = [_vehicle] spawn {
				private _vehicle = param [0, objNull, [objNull]];
				waitUntil {(_vehicle nearEntities ["Man", 10]) isEqualTo [] || !alive _vehicle};
				if (!alive _vehicle) exitWith {};
				_vehicle allowDamage false;
				_vehicle setVectorUp [0,0,1];
				_vehicle setPosATL [(getPosATL _vehicle) # 0, (getPosATL _vehicle) # 1, 0];
				_vehicle allowDamage true;
			};
		};
	}];

    if!(_isHQ) then {
	if(_vehicle isKindOf "Car" || _vehicle isKindOf "Apc" || _vehicle isKindOf "Motorcycle") then {
        _vehicle addEventHandler ["HandleDamage", {
        if ((_this # 1) find "wheel" != -1) then {
            (_this # 2) * 0.8
        } else {
            (_this # 2)
        }
        }]
        }
	};

	if(_skin > -1) then {
		_type = typeOf _vehicle;
		_colorConfigs = "true" configClasses (configfile >> "CfgVehicles" >> _type >> "textureSources");

		if(count _colorConfigs > 0) then {
			if(_skin <= count _colorConfigs) then {
				_txtIndex = 0;
				{
					_vehicle setObjectTextureGlobal [_txtIndex, _x];
					_txtIndex = _txtIndex + 1;
				}	forEach (getArray (configfile >> "CfgVehicles" >> _type >> "textureSources" >> configName (_colorConfigs # _skin) >> "textures"))
			}
		}
	};
};

_vehicle