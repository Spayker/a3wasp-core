/*
	Triggerd upon a unit death.
	 Parameters:
		- Killed
		- Killer
		- Killed side ID.
*/

params ["_killed", "_killer"];
private ["_get", "_killed_isplayer","_killed_group","_killed_isman","_killed_side","_killed_type","_killer_group","_killer_isplayer","_killer_iswfteam","_killer_side","_killer_type","_killer_vehicle","_killer_uid", "_processCommanderBounty"];

_processCommanderBounty = {
    params["_killer_isplayer", "_killer", "_killed_type", "_commanderTeam"];
    private["_killer_award", "_points", "_leaderCommanderTeam"];

    _killer_award = objNull;
    if !(_killer_isplayer) then { //--- An AI is the killer.
        _killer_award = _killer;
        _points = switch (true) do {
            case (_killed_type isKindOf "Infantry"): {1};
            case (_killed_type isKindOf "Car"): {2};
            case (_killed_type isKindOf "Ship"): {4};
            case (_killed_type isKindOf "Motorcycle"): {1};
            case (_killed_type isKindOf "Tank"): {4};
            case (_killed_type isKindOf "Helicopter"): {4};
            case (_killed_type isKindOf "Plane"): {6};
            case (_killed_type isKindOf "StaticWeapon"): {2};
            case (_killed_type isKindOf "Building"): {2};
            default {1};
        };
        _leaderCommanderTeam = leader _commanderTeam;

        if (isServer) then {
            [_leaderCommanderTeam, (score _leaderCommanderTeam) + _points] call WFSE_fnc_RequestChangeScore;
        } else {
            [_leaderCommanderTeam, (score _leaderCommanderTeam) + _points] remoteExecCall ["WFSE_fnc_RequestChangeScore",2];
        };
    };
    [_killed_type, false, _killer_award] remoteExecCall ["WFCL_FNC_AwardBounty", _commanderTeam]
};

if(isHeadLessClient) then {
    _killed setVariable ["wf_trashed_time", time, 2];
    _killed spawn WFCO_FNC_TrashObject;
};

_killed_side = (_this # 2) Call WFCO_FNC_GetSideFromID;
_killed_group = group _killed;
_killed_isman = (_killed isKindOf "Man");
_killed_type = typeOf _killed;
_killed_isplayer = (isPlayer _killed);

_last_hit = _killed getVariable "wf_lasthitby";
if !(isNil '_last_hit') then {
	if (alive _last_hit) then {
		if (side _last_hit != _killed_side && time - (_killed getVariable "wf_lasthittime") < 25) then {_killer = _last_hit};
	};
};

if (isNil '_killed_side') then { _killed_side = side _killed };

["INFORMATION", Format ["fn_OnUnitKilled.sqf: [%1] [%2] has been killed by [%3].", _killed_side, _killed, _killer]] Call WFCO_FNC_LogContent;
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

if !(alive _killer) exitWith {}; //--- Killer is null or dead, nothing to see here.

//--- Retrieve basic information.
_killer_group = group _killer;
_leaderKillerGroup = leader _killer_group;
_killer_isplayer = (isPlayer _killer);
_killer_iswfteam = (!isNil {_killer_group getVariable "wf_funds"});
_killer_side = side _killer;
_killer_type = typeOf _killer;
_killer_vehicle = vehicle _killer;
_killer_uid = getPlayerUID _leaderKillerGroup;

if (_killer_side == sideEnemy) then { //--- Make sure the killer is not renegade, if so, get the side from the config.
	if !(_killer isKindOf "Man") then {_killer_type = typeOf effectiveCommander(vehicle _killer)};
	_killer_side = switch (getNumber(configFile >> "CfgVehicles" >> _killer_type >> "side")) do {case 0: {east}; case 1: {west}; case 2: {resistance}; default {civilian}};
};

if (_killed_side in WF_PRESENTSIDES) then { //--- Update the statistics if needed.
	if (_killed_isman) then {[str _killed_side,'Casualties',1] Call WFCO_FNC_UpdateStatistics} else {[str _killed_side,'VehiclesLost',1] Call WFCO_FNC_UpdateStatistics};
};

_get = missionNamespace getVariable _killed_type; //--- Get the killed informations.

if (!isNil '_get' ) then { //--- Make sure that type killed type is defined in the core files
	if(_killer_iswfteam) then { //---the killer is a WF team.
		if (_killer_side != _killed_side) then { //--- Normal kill.
			if (isPlayer _leaderKillerGroup) then { //--- The team is lead by a player.
				_killer_award = objNull;
				if !(_killer_isplayer) then { //--- An AI is the killer.
					_killer_award = _killer;
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

					if (isServer) then {
								[_leaderKillerGroup, (score _leaderKillerGroup) + _points] call WFSE_fnc_RequestChangeScore;
					} else {
								[_leaderKillerGroup, (score _leaderKillerGroup) + _points] remoteExecCall ["WFSE_fnc_RequestChangeScore",2];
					};
				};

				//--- Award the bounty if needed.
				if (_killed_isplayer && _killer_isplayer) then {
					[_killed] remoteExecCall ["WFCL_FNC_AwardBountyPlayer", _killer];
				};

						[_killed_type, false, _killer_award] remoteExecCall ["WFCL_FNC_AwardBounty", _leaderKillerGroup];
				if (vehicle _killed != _killed && alive _killed) then { //--- Kill assist (players in the same vehicle).
					{
						if (alive _x && isPlayer _x) then {
							[_objectType, true] remoteExecCall ["WFCL_FNC_AwardBounty", getPlayerUID(_x)];
						}
					} forEach ((crew (vehicle _killed)) - [_killer, player]);
				};
			};
		} else { //--- Teamkill.
			if ((isPlayer _leaderKillerGroup) && _killer != _killed && !(_killed_type isKindOf "Building")) then {
				//--- Only applies to player groups.
        		['Teamkill'] remoteExecCall ["WFCL_FNC_LocalizeMessage", _killer]
        	};
        };
	} else {
	    if (_killer_side != _killed_side && _killer_side != resistance) then {

	        if (_killer isKindOf 'UAV' ) then {
                    _uavOwnerGroup = _killer getVariable ['uavOwnerGroup', objNull];
                    if!(isNull _uavOwnerGroup) then {
                        [_killer_isplayer, _killer, _killed_type, _uavOwnerGroup] call _processCommanderBounty
                    }
	        };

	        _commanderTeam = (_killer_side) Call WFCO_FNC_GetCommanderTeam;

	        if(!(isNil '_commanderTeam')) then {
                if (isPlayer(leader _killer_group)) then {
                    [_killer_isplayer, _killer, _killed_type, leader _killer_group] call _processCommanderBounty
                } else {
                    if (_killer_type isKindOf "StaticWeapon") then {
						[_killer_isplayer, _killer, _killed_type, _commanderTeam] call _processCommanderBounty
                    };

                    _isCasGroup = _killer_group getVariable ['isCasGroup', false];
                    if(_isCasGroup) then {
                        [_killer_isplayer, _killer, _killed_type, _commanderTeam] call _processCommanderBounty
                    }
                };

				_highCommandCreatedGroups = [_killer_side] call WFCO_FNC_getHighCommandGroups;
				
				if(!(isNil '_highCommandCreatedGroups')) then {
					if(_killer_group in _highCommandCreatedGroups) then {
						[_killer_isplayer, _killer, _killed_type, _commanderTeam] call _processCommanderBounty
                    }
                }
            }
	    }
	}
}