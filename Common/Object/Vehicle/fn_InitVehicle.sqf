params ["_vehicle", "_sideId", "_locked", ["_bounty", true], ["_global", true], ["_skin", -1]];
private ["_side", "_vehicle"];

_side = (_sideId) Call WFCO_FNC_GetSideFromID;

if (_locked) then {_vehicle lock _locked};

_vehicle spawn WFCO_FNC_ClearVehicleCargo;

//-- Init HQ
if(typeOf _vehicle == (missionNamespace getVariable [Format["WF_%1MHQNAME", _side], ""])) then {
    _vehicle setVariable ["wf_side", _side];
    _vehicle setVariable ["wf_trashable", false];
    _vehicle setVariable ["wf_structure_type", "Headquarters"];
    _vehicle setVariable ["wf_hq_deployed", false, true];

	_logik = (_side) Call WFCO_FNC_GetSideLogic;
    _hqs = (_side) call WFCO_FNC_GetSideHQ;
	_hqs = _logik getVariable ["wf_hq", []];
	_hqs = _hqs - [objNull];
	_hqs pushBack _vehicle;
	_logik setVariable ["wf_hq", _hqs, true]
} else {
    [_vehicle] remoteExec ["WFSE_FNC_addEmptyVehicleToQueue", 2]
};

[_vehicle, _bounty, _sideId, _side, _global, _skin] spawn {
    params ["_vehicle", "_bounty", "_sideId", "_side", "_global", "_skin"];

    if (_global) then {
    	if (_sideId != WF_DEFENDER_ID) then {
    		[_vehicle, _sideId] remoteExec ["WFCO_FNC_initUnit",0,true];
    	};
    };

    if(typeOf _vehicle == (missionNamespace getVariable [Format["WF_%1SUPPLY_TRUCK", _side], ""])) then {

        _vehicle addEventHandler ["GetIn", {
            params ["_vehicle", "_role", "_unit", "_turret"];
            if(_role == "driver") then {
                (localize "STR_WF_CHAT_Commander_Supply_Truck_Move_Order") remoteExecCall ["WFCL_FNC_GroupChatMessage", _unit]
            }
         }];

        _vehicle addEventHandler ["GetOut", {
        	params ["_vehicle", "_role", "_unit", "_turret"];
        	if(_role == "driver") then { [_vehicle, group (_unit)] call WFCO_fnc_SellSupplyTruck }
        }]
    };

	if (_bounty) then {
		_vehicle addEventHandler ["killed", format ['[_this # 0,_this # 1,%1] spawn WFCO_FNC_OnUnitKilled', _sideId]];
		_vehicle addEventHandler ["hit", {_this spawn WFCO_FNC_OnUnitHit}];
		if(!isHostedServer) then {
			[_vehicle, ["killed", format ['params ["_unit", "_killer"]; if(local _unit) then { [_unit, _killer, %1] spawn WFCO_FNC_OnUnitKilled; };', _sideId]]] remoteExec ["addEventHandler", 2];
			[_vehicle, ["hit", {params ["_unit"]; if(local _unit) then { _this spawn WFCO_FNC_OnUnitHit; };}]] remoteExec ["addEventHandler", 2];
		};
	};

	/*if(typeOf _vehicle in ['CUP_O_2S6M_RU','CUP_B_M6LineBacker_USA_W', 'CUP_B_M6LineBacker_USA_D']) then {
		_vehicle addeventhandler ['Fired',{_this spawn WFCO_FNC_HandleAAMissiles}]
	};*/

	if(typeOf _vehicle in WF_C_COMBAT_JETS_WITH_BOMBS) then {
		_vehicle addeventhandler ['Fired',{_this spawn WFCO_FNC_HandleBombs}]
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