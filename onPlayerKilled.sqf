params ["_oldUnit", "_killer", "_respawn", "_respawnDelay"];

[_oldUnit, _killer, _respawn, _respawnDelay] spawn {
    params ["_oldUnit", "_killer", "_respawn", "_respawnDelay"];
    hudOn = false;

    if(isFirstSpawnIsDone) then {
        [_oldUnit] Spawn WFCL_FNC_OnKilled
    } else {
        _side = switch (getNumber(configFile >> "CfgVehicles" >> typeof player >> "side")) do {case 0: {east}; case 1: {west}; case 2: {resistance}; default {civilian}};
        WF_Client_SideJoined = _side;
        WF_C_RESPAWN_LOCATIONS = [];

        [WF_Client_SideJoined, [format["%1_Soldier_0", WF_Client_SideJoined],  -1, 12]] call BIS_fnc_addRespawnInventory;
        [WF_Client_SideJoined, [format["%1_Engineer_0", WF_Client_SideJoined], -1,  6]] call BIS_fnc_addRespawnInventory;
        [WF_Client_SideJoined, [format["%1_Recon_0", WF_Client_SideJoined],    -1,  3]] call BIS_fnc_addRespawnInventory;
        [WF_Client_SideJoined, [format["%1_Support_0", WF_Client_SideJoined],  -1,  3]] call BIS_fnc_addRespawnInventory;
        [WF_Client_SideJoined, [format["%1_Medic_0", WF_Client_SideJoined],    -1,  3]] call BIS_fnc_addRespawnInventory;
        [WF_Client_SideJoined, [format["%1_SpecOps_0", WF_Client_SideJoined],  -1,  3]] call BIS_fnc_addRespawnInventory;

        _spawn_locations = [WF_Client_SideJoined, getPosATL player] Call WFCL_FNC_GetRespawnAvailable;
        while {count _spawn_locations == 0} do {
            _spawn_locations = [WF_Client_SideJoined, getPosATL player] Call WFCL_FNC_GetRespawnAvailable;
            sleep 1;
        };

        {
            _name = name _x;
            if(_x isKindOf "WarfareBBaseStructure" || _x isKindOf "Warfare_HQ_base_unfolded") then {
                _type = _x getVariable ['wf_structure_type', ""];
                _nearTown = ([_x, towns] Call WFCO_FNC_GetClosestEntity) getVariable 'name';
                _txt = _type + ' ' + _nearTown + ' ' + str (round((vehicle player) distance _x)) + 'M';
                WF_C_RESPAWN_LOCATIONS pushBack ([WF_Client_SideJoined, _x, _txt] call BIS_fnc_addRespawnPosition);
            } else {
                WF_C_RESPAWN_LOCATIONS pushBack ([WF_Client_SideJoined, _x] call BIS_fnc_addRespawnPosition);
            }
        } forEach _spawn_locations;
    }
}

