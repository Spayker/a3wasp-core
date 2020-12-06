params["_killer_isplayer", "_killer", "_killed_type", "_commanderTeam"];
private["_points", "_leaderCommanderTeam"];

if !(_killer_isplayer) then { //--- An AI is the killer.
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
    [_leaderCommanderTeam, (score _leaderCommanderTeam) + _points] remoteExecCall ["WFSE_fnc_RequestChangeScore",2];

};

[_killed_type, false] call WFCL_FNC_AwardBounty