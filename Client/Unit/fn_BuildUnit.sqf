params ["_building", "_unit", "_vehi", "_factory", "_cpt"];
private ["_commander","_crew","_currentUnit","_unitdescription","_unitlogo","_direction","_distance","_driver",
"_extracrew","_factoryPosition","_factoryType","_group","_gunner","_index","_init","_isArtillery","_isMan","_locked",
"_longest","_position","_queu","_queu2","_ret","_show","_soldier","_waitTime","_txt","_type","_upgrades","_unique",
"_vehicle","_gunnerEqCommander","_turrets"];

_isMan = (_unit isKindOf "Man");
unitQueu = unitQueu + _cpt;

_distance = 0;
_direction = 0;
_longest = 0;
_position = 0;
_waitTime = 0;
_factoryType = "";
_unitdescription = "";
_unitlogo = "";

_currentUnit = missionNamespace getVariable _unit;
_waitTime = _currentUnit # QUERYUNITTIME;
_unitdescription = _currentUnit # QUERYUNITLABEL;
_unitlogo = _currentUnit # 1;

_type = typeOf _building;
_index = (missionNamespace getVariable Format ["WF_%1STRUCTURENAMES",WF_Client_SideJoinedText]) find _type;
if (_index != -1) then {
	_distance = (missionNamespace getVariable Format ["WF_%1STRUCTUREDISTANCES",WF_Client_SideJoinedText]) # _index;
	_direction = (missionNamespace getVariable Format ["WF_%1STRUCTUREDIRECTIONS",WF_Client_SideJoinedText]) # _index;
	_factoryType = (missionNamespace getVariable Format ["WF_%1STRUCTURES",WF_Client_SideJoinedText]) # _index;
	_position = _building modelToWorld [(sin _direction * _distance), (cos _direction * _distance), 0];
	_position set [2, .5];
	_longest = missionNamespace getVariable Format ["WF_LONGEST%1BUILDTIME",_factoryType];
} else {
	if (_type in WF_Logic_Depot) then {
		_distance = missionNamespace getVariable "WF_C_DEPOT_BUY_DISTANCE";
		_direction = missionNamespace getVariable "WF_C_DEPOT_BUY_DIR";
		_factoryType = "Depot";

	};
	_position = _building modelToWorld [(sin _direction * _distance), (cos _direction * _distance), 0];

	if (_type == WF_Logic_Airfield) then {
		_distance = missionNamespace getVariable "WF_C_HANGAR_BUY_DISTANCE";
		_direction = missionNamespace getVariable "WF_C_HANGAR_BUY_DIR";
		_factoryType = "Airport";
		_position = _building modelToWorld [(sin 180 * _distance), (cos 180 * _distance), 0]
	};

	_position set [2, .5];
	_longest = missionNamespace getVariable Format ["WF_LONGEST%1BUILDTIME",_factoryType];
};

_unique = varQueu;
varQueu = time + random 10000 - random 500 + diag_frameno;
_queu = _building getVariable "queu";
if (isNil "_queu") then {_queu = []};
_queu pushBack _unique;

_building setVariable ["queu",_queu,true];

_ret = 0;
_queu2 = [0];

if (count _queu > 0) then {_queu2 = _building getVariable "queu"};

_show = false;
while {_unique != _queu # 0 && alive _building && !isNull _building} do {
	sleep 4;
	_show = true;
	_ret = _ret + 4;
	_queu = _building getVariable "queu";

	if (_queu # 0 == _queu2 # 0) then {
		if (_ret > _longest) then {
			if (count _queu > 0) then {
				_queu = _building getVariable "queu";
				_queu = _queu - [_queu select 0];
				_building setVariable ["queu",_queu,true];
			};
		};
	};
	if (count _queu != count _queu2) then {
		_ret = 0;
		_queu2 = _building getVariable "queu";
	};
};

if (_show) then { [Format [localize "STR_WF_INFO_BuyEffective",_unitdescription]] spawn WFCL_fnc_handleMessage };

sleep _waitTime;

_queu = _building getVariable "queu";
_queu = _queu - [_unique];
_building setVariable ["queu",_queu,true];

_group = WF_Client_Team;
if (!alive _building || isNull _building) exitWith {
	unitQueu = unitQueu - _cpt;
	if(_unit == missionNamespace getVariable Format["WF_%1MHQNAME", WF_Client_SideJoined]) then {
	    missionNamespace setVariable [Format["WF_C_QUEUE_HQ_%1",_factory],(missionNamespace getVariable Format["WF_C_QUEUE_HQ_%1",_factory])-1];
	} else {
	missionNamespace setVariable [Format["WF_C_QUEUE_%1",_factory],(missionNamespace getVariable Format["WF_C_QUEUE_%1",_factory])-1];
	}
};

if (_isMan) then {
	_soldier = [_unit,_group,_position,WF_Client_SideID] Call WFCO_FNC_CreateUnit;
	
	//--- Make sure that our unit is supposed to have a backpack.
	if (getText(configFile >> 'CfgVehicles' >> _unit >> 'backpack') != "") then {
		//--- Retrieve the unit gear config.
		_gear_config = (_unit) Call WFCO_FNC_GetUnitConfigGear;
		_gear_backpack = _gear_config # 2;
		_gear_backpack_content = _gear_config # 3;

		//--- Backpack handling.
		if (_gear_backpack != "") then {[_soldier, _gear_backpack, _gear_backpack_content] Call WFCO_FNC_EquipBackpack};
	};

	[WF_Client_SideJoinedText,'UnitsCreated',1] Call WFCO_FNC_UpdateStatistics;
} else {
	_driver = _vehi # 0;
	_gunner = _vehi # 1;
	_commander = _vehi # 2;
	_extracrew = _vehi # 3;
	_locked = _vehi # 4;
	_gunnerEqCommander = _vehi # 5;

	_factoryPosition = getPos _building;
    _position = [_position, 30] call WFCO_fnc_getEmptyPosition;
	if(_unit isKindOf 'Ship') then { _position = [_position, 2, 75, 5, 2, 0, 1] call BIS_fnc_findSafePos };

	_direction = -((((_position # 1) - (_factoryPosition # 1)) atan2 ((_position # 0) - (_factoryPosition # 0))) - 90);//--- model to world that later on.
    _vehicle = [_unit, _position, sideID, _direction, _locked, nil, nil, nil, _unitdescription] Call WFCO_FNC_CreateVehicle;
    _vehicle setVectorUp surfaceNormal position _vehicle;
    WF_Client_Team reveal _vehicle;
    createVehicleCrew _vehicle;

    {
        _crew = _x;
        _isMajorCrewMember = false;
        if(_crew isEqualTo driver objectParent _crew ||
            _crew isEqualTo gunner objectParent _crew ||
                _crew isEqualTo commander objectParent _crew) then {
    //--- Driver.
    if (!_driver) then { _vehicle deleteVehicleCrew (driver _vehicle) };
	
    if(_gunnerEqCommander) then {
        if (!_gunner && !_commander) then { _vehicle deleteVehicleCrew (gunner _vehicle) };
    } else {
        //--- Gunner.
        if (!_gunner) then { _vehicle deleteVehicleCrew (gunner _vehicle) };
        //--- Commander.
        if (!_commander) then { _vehicle deleteVehicleCrew (commander _vehicle) };
    };
            _isMajorCrewMember = true
        };

    if (_extracrew) then {
        _turrets = _currentUnit # QUERYUNITTURRETS;

        {
        	if (count units _group < WF_C_PLAYERS_AI_MAX && isNull (_vehicle turretUnit _x)) then {
        		_soldier = [missionNamespace getVariable Format ["WF_%1SOLDIER",WF_Client_SideJoinedText],
        		                _group,_position,WF_Client_SideID] Call WFCO_FNC_CreateUnit;
        		[_soldier] allowGetIn true;
        		_soldier moveInTurret [_vehicle, _x];
        	};
        } forEach _turrets;
            _isMajorCrewMember = true
    };
	
        if!(_isMajorCrewMember) then {
            _vehicle deleteVehicleCrew _crew
        }
    } forEach crew _vehicle;

	if (typeOf _vehicle in WF_FLY_UAVS) then {
	    createVehicleCrew _vehicle;
	    _vehicle setVariable ['uavOwnerGroup', WF_Client_Team, true];
	} else {
    {
        [_x, typeOf _x,_group,_position,WF_Client_SideID] spawn WFCO_FNC_InitManUnit;

            private _classLoadout = missionNamespace getVariable Format ['WF_%1ENGINEER', WF_Client_SideJoined];
        if(_vehicle isKindOf "Tank") then {
                _classLoadout = missionNamespace getVariable Format ['WF_%1ENGINEER',WF_Client_SideJoined];
        };
        if(_vehicle isKindOf "Air") then {
            _classLoadout = missionNamespace getVariable Format ['WF_%1PILOT',WF_Client_SideJoined];
        };

        _x setUnitLoadout _classLoadout;
        _x setUnitTrait ["Engineer",true];
    } forEach crew _vehicle;
    (crew _vehicle) join (leader WF_Client_Team);
	};

	//--- Clear the vehicle.	
	_vehicle call WFCO_FNC_ClearVehicleCargo;

	[_vehicle] call WFCL_FNC_IconVehicle;
	
	/* Section: Local Init (Client Only) */
	//--- Lock / Unlock.
	_vehicle addAction [localize "STR_WF_Unlock",{call WFCL_fnc_toggleLock}, [], 95, false, true, '', 'alive _target && (locked _target == 2)',10];
	_vehicle addAction [localize "STR_WF_Lock",{call WFCL_fnc_toggleLock}, [], 94, false, true, '', 'alive _target && (locked _target == 0)',10];

	//--- Salvage Truck.
	if (_unit in (missionNamespace getVariable Format['WF_%1SALVAGETRUCK',WF_Client_SideJoinedText])) then {[_vehicle] spawn WFCL_FNC_UpdateSalvage};

	/* Section: Creation */

	[WF_Client_SideJoinedText,'VehiclesCreated',1] Call WFCO_FNC_UpdateStatistics;
	
	_group addVehicle _vehicle;

	_vehicle allowCrewInImmobile true;
	if(isEngineOn _vehicle) then {
		_vehicle engineOn false;
	};

	if({(_vehicle isKindOf _x)} count ["Tank","Wheeled_APC"] !=0) then {
		_vehicle addeventhandler ['Engine',{_this execVM "Client\Module\Engines\Engine.sqf"}];
        _vehicle addAction ["<t color='"+"#00E4FF"+"'>DISABLE ENGINE</t>","Client\Module\Engines\Stopengine.sqf", [], 7,false, true,"","alive _target &&(isEngineOn _target)"];
    };
	
	//--- Empty Vehicle.
	if (!_driver && !_gunner && !_commander) exitWith {};

	[WF_Client_SideJoinedText,'UnitsCreated',_cpt] spawn WFCO_FNC_UpdateStatistics;
};

unitQueu = unitQueu - _cpt;

if(_unit == missionNamespace getVariable Format["WF_%1MHQNAME", WF_Client_SideJoined]) then {
    missionNamespace setVariable [Format["WF_C_QUEUE_HQ_%1",_factory],(missionNamespace getVariable Format["WF_C_QUEUE_HQ_%1",_factory])-1]
} else {
    missionNamespace setVariable [Format["WF_C_QUEUE_%1",_factory],(missionNamespace getVariable Format["WF_C_QUEUE_%1",_factory])-1]
};
[Format [localize "STR_WF_INFO_Build_Complete",_unitdescription]] spawn WFCL_fnc_handleMessage