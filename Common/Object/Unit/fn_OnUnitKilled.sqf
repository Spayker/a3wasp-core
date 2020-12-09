/*
	Triggerd upon a unit death.
	 Parameters:
		- Killed
		- Killer
		- Killed side ID.
*/

params ["_killed", "_killer"];
private ["_get", "_killed_isplayer","_killed_group","_killed_isman","_killed_side","_killed_type","_killer_group","_killer_isplayer","_killer_iswfteam","_killer_side","_killer_type","_killer_vehicle","_killer_uid", "_processCommanderBounty"];

if(isHeadLessClient) exitWith {};

_killed_type = typeOf _killed;
_killed_side = switch (getNumber(configFile >> "CfgVehicles" >> _killed_type >> "side")) do {case 0: {east}; case 1: {west}; case 2: {resistance}; default {civilian}};
if(isServer) exitWith { ["INFORMATION", Format ["fn_OnUnitKilled.sqf: [%1] [%2] has been killed by [%3].", side _killed, _killed, _killer]] Call WFCO_FNC_LogContent };

if !(alive _killer) exitWith {}; //--- Killer is null or dead, nothing to see here.
_killer_side = switch (getNumber(configFile >> "CfgVehicles" >> _killer_type >> "side")) do {case 0: {east}; case 1: {west}; case 2: {resistance}; default {civilian}};
if(_killer_side == resistance) exitWith {};

//--- Retrieve basic information.
_killer_group = group _killer;
_leaderKillerGroup = leader _killer_group;
_killer_isplayer = (isPlayer _killer);
_killer_type = typeOf _killer;
_killer_vehicle = vehicle _killer;
_killer_uid = getPlayerUID _leaderKillerGroup;


_killed_group = group _killed;
_killed_isman = (_killed isKindOf "Man");
_killed_isplayer = (isPlayer _killed);

_shallUpdateStats = false;
_shallChangeScore = false;

_get = missionNamespace getVariable _killed_type; //--- Get the killed informations.
if (!isNil '_get' ) then { //--- Make sure that type killed type is defined in the core files
_last_hit = _killed getVariable "wf_lasthitby";
if !(isNil '_last_hit') then {
	if (alive _last_hit) then {
    		if (side _last_hit != _killed_side && time - (_killed getVariable "wf_lasthittime") < 25) then {_killer = _last_hit}
    	}
	};

    if(player == _leaderKillerGroup) then { // current player killed someone
        if(vehicle player != player) then { _killer_side = WF_Client_SideJoined };
        if (_killer_side != _killed_side) then { //--- Normal kill.

            if(_killed_isplayer) then {
                [_killed] call WFCL_FNC_AwardBountyPlayer
            } else {
                [_killed_type, false] call WFCL_FNC_AwardBounty
            };
            _shallUpdateStats = true

        } else { //--- Teamkill.
            if (_killer != _killed && !(_killed_type isKindOf "Building")) then {
                //--- Only applies to player groups.
                ['Teamkill'] call WFCL_FNC_LocalizeMessage;
                _shallUpdateStats = true
            }
        }

    } else { // bots killed some one

        if (group player == _killer_group) then { // player's bots killed someone
            if(vehicle _killer != _killer) then { _killer_side = WF_Client_SideJoined };
            if (_killer_side != _killed_side) then { //--- Normal kill.
                [_killed_type, true] call WFCL_FNC_AwardBounty;
                _shallUpdateStats = true;
                _shallChangeScore = true
            } else {
                if (_killer != _killed && !(_killed_type isKindOf "Building")) then {
                    //--- Only applies to player groups.
                    ['Teamkill'] call WFCL_FNC_LocalizeMessage;
                    _shallUpdateStats = true;
                    _shallChangeScore = true
                }
            };

        } else { // CAS, UAV, hc groups killed someone
            _shallCheck = true;
            if (_killer isKindOf 'UAV' ) then {
                _uavOwnerGroup = _killer getVariable ['uavOwnerGroup', objNull];
                if!(isNull _uavOwnerGroup) then {
                    if(_uavOwnerGroup == group player) then {
                        if(vehicle _killer != _killer) then { _killer_side = WF_Client_SideJoined };
                        if (_killer_side != _killed_side) then { //--- Normal kill.
                            [_killed_type, true] call WFCL_FNC_AwardBounty;
                            _shallUpdateStats = true;
                            _shallChangeScore = true
                        } else {
                            if (_killer != _killed && !(_killed_type isKindOf "Building")) then {
                                //--- Only applies to player groups.
                                ['Teamkill'] call WFCL_FNC_LocalizeMessage;
                                _shallUpdateStats = true;
                                _shallChangeScore = true
                            }
                        };
                        _shallUpdateStats = true;
                        _shallCheck = false
                    }
                }
            };

            if (_shallCheck) then {
                _commanderTeam = (_killer_side) Call WFCO_FNC_GetCommanderTeam;
                if (!isNull(_commanderTeam)) then {
                    if (_commanderTeam == group player) then {

                        if (_killer_type isKindOf "StaticWeapon") then { // base static defense
                            [_killer_isplayer, _killer, _killed_type, _commanderTeam] call WFCO_FNC_processCommanderBounty;
                            _shallUpdateStats = true;
                            _shallChangeScore = true;
                            _shallCheck = false
                        };

                        if(_shallCheck) then {
                            _isCasGroup = _killer_group getVariable ['isCasGroup', false];
                            if(_isCasGroup) then { // CAS group
                                [_killer_isplayer, _killer, _killed_type, _commanderTeam] call WFCO_FNC_processCommanderBounty;
                                _shallUpdateStats = true;
                                _shallChangeScore = true;
                                _shallCheck = false
                            }
                        };

                        if(_shallCheck) then {
                            _highCommandCreatedGroups = [_killer_side] call WFCO_FNC_getHighCommandGroups;
                            if(!(isNil '_highCommandCreatedGroups')) then { // hc group
                                if(_killer_group in _highCommandCreatedGroups) then {
                                    [_killer_isplayer, _killer, _killed_type, _commanderTeam] call WFCO_FNC_processCommanderBounty;
                                    _shallUpdateStats = true;
                                    _shallChangeScore = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
};

if(_shallUpdateStats) then {

    if (_shallChangeScore) then {
        _points = switch (true) do {
            case (_killed_type isKindOf "Infantry"): {1};
            case (_killed_type isKindOf "Car"): {2};
            case (_killed_type isKindOf "Ship"): {4};
            case (_killed_type isKindOf "Motorcycle"): {1};
            case (_killed_type isKindOf "Tank"): {4};
            case (_killed_type isKindOf "Helicopter"): {4};
            case (_killed_type isKindOf "Plane"): {6};
            case (_killed_type isKindOf "Uav"): {4};
            case (_killed_type isKindOf "StaticWeapon"): {2};
            case (_killed_type isKindOf "Building"): {2};
            default {1};
        };
        [_leaderKillerGroup, (score _leaderKillerGroup) + _points] remoteExecCall ["WFSE_fnc_RequestChangeScore",2]
    };

[_killed, _killer, _killed_side] spawn {
	params ["_killed","_killer","_killed_side"];

	if (isPlayer _killed) then {
		if(_killed == _killer || name _killed == name _killer) then {		
			[format ["%1 **%2** has been killed :skull_crossbones:", _killed_side Call WFCO_FNC_GetSideFLAG, name _killed]] remoteExec ["WFDC_FNC_LogContent", 2];
		} else {
			_killerInfo = "";
			_killerSmile = "";
			_killedSmile = "";
			if(!isNull _killer) then {
				_killerInfo = format[" by %1 ", (side _killer) Call WFCO_FNC_GetSideFLAG];
				if!(isPlayer _killer) then { 
					_killerInfo = format["%1%2 ", _killerInfo,[_killer, "displayName"] call WFCO_FNC_GetConfigInfo]; 
				} else {
					_killerSmile = (WFDC_SMILES # 0) # (floor random count (WFDC_SMILES # 0));
					_killedSmile = (WFDC_SMILES # 1) # (floor random count (WFDC_SMILES # 1));
				};
				_killerName = "";
				if!((name _killer) isEqualTo "Error: No unit") then {
					_killerName = name _killer;
				};
				_killerInfo = format["%1 **%2** %3", _killerInfo, _killerName, _killerSmile];
			};		
			
			[format [":crossed_swords: %1**%2** %3 has been killed%4", _killed_side Call WFCO_FNC_GetSideFLAG, name _killed, _killedSmile, _killerInfo]] remoteExec ["WFDC_FNC_LogContent", 2];
		};
	};
};

if (_killed_side in WF_PRESENTSIDES) then { //--- Update the statistics if needed.
	if (_killed_isman) then {[str _killed_side,'Casualties',1] Call WFCO_FNC_UpdateStatistics} else {[str _killed_side,'VehiclesLost',1] Call WFCO_FNC_UpdateStatistics};
                }
            }
