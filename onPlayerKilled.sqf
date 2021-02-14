params ["_oldUnit", "_killer", "_respawn", "_respawnDelay"];

_playerBots = units _oldUnit;

if(count _playerBots > 0) then {
    WF_C_RESPAWN_TEMP_GROUP = createGroup [switch (getNumber(configFile >> "CfgVehicles" >> typeof player >> "side")) do {case 0: {east}; case 1: {west}; case 2: {resistance}; default {civilian}}, true];
    (units (group player) - [player]) joinSilent WF_C_RESPAWN_TEMP_GROUP;
};

[_oldUnit, _killer, _respawn, _respawnDelay] spawn {
    params ["_oldUnit", "_killer", "_respawn", "_respawnDelay"];
    hudOn = false;
    WF_DeathLocation = getPosATL _oldUnit;
    if(isFirstSpawnIsDone) then {
        [_oldUnit, _respawnDelay] Spawn WFCL_FNC_OnKilled;
    } else {
        WF_Client_SideJoined = switch (getNumber(configFile >> "CfgVehicles" >> typeof player >> "side")) do {case 0: {east}; case 1: {west}; case 2: {resistance}; default {civilian}};
        WF_C_RESPAWN_LOCATIONS = [];

        [WF_Client_SideJoined, [format["%1_Assault_0", WF_Client_SideJoined],  -1, 12]] call BIS_fnc_addRespawnInventory;
        [WF_Client_SideJoined, [format["%1_Engineer_0", WF_Client_SideJoined], -1,  6]] call BIS_fnc_addRespawnInventory;
        [WF_Client_SideJoined, [format["%1_Recon_0", WF_Client_SideJoined],    -1,  3]] call BIS_fnc_addRespawnInventory;
        [WF_Client_SideJoined, [format["%1_Support_0", WF_Client_SideJoined],  -1,  3]] call BIS_fnc_addRespawnInventory;
        [WF_Client_SideJoined, [format["%1_Medic_0", WF_Client_SideJoined],    -1,  3]] call BIS_fnc_addRespawnInventory;
        [WF_Client_SideJoined, [format["%1_SpecOps_0", WF_Client_SideJoined],  -1,  3]] call BIS_fnc_addRespawnInventory;

        _spawn_locations = [WF_Client_SideJoined, getPosATL _oldUnit] Call WFCL_FNC_GetRespawnAvailable;
        while {count _spawn_locations == 0} do {
            _spawn_locations = [WF_Client_SideJoined, getPosATL _oldUnit] Call WFCL_FNC_GetRespawnAvailable;
            sleep 1;
        };

        { _x call BIS_fnc_removeRespawnPosition } forEach WF_C_RESPAWN_LOCATIONS;
        WF_C_RESPAWN_LOCATIONS = [];

        {
            if(_x isKindOf "WarfareBBaseStructure" || _x isKindOf "Warfare_HQ_base_unfolded") then {
                _type = _x getVariable ['wf_structure_type', ""];
                _nearTown = ([_x, towns] Call WFCO_FNC_GetClosestEntity) getVariable 'name';
                _txt = _type + ' ' + _nearTown + ' ' + str (round((vehicle player) distance _x)) + 'M';
                WF_C_RESPAWN_LOCATIONS pushBack ([WF_Client_SideJoined, _x, _txt] call BIS_fnc_addRespawnPosition)
            } else {
                if (_x isKindOf "CUP_O_BTR90_HQ_RU" || _x isKindOf "CUP_B_LAV25_HQ_USMC" || _x isKindOf "CUP_B_LAV25_HQ_desert_USMC") then {
                    _type = _x getVariable ['wf_structure_type', ""];
                    _nearTown = ([_x, towns] Call WFCO_FNC_GetClosestEntity) getVariable ['name', ''];
                    _txt = _type + ' ' + _nearTown + ' ' + str (round((vehicle player) distance _x)) + 'M';
                    WF_C_RESPAWN_LOCATIONS pushBack ([WF_Client_SideJoined, [getPosATL _x, 60] call WFCO_FNC_GetSafePlace, _txt] call BIS_fnc_addRespawnPosition)
            } else {
                    if (typeof _x == WF_C_CAMP ) then {
                        _nearTown = ([_x, towns] Call WFCO_FNC_GetClosestEntity) getVariable ['name', ''];
                        _txt = 'Camp ' + _nearTown + ' ' + str (round((vehicle player) distance _x)) + 'M';
                        WF_C_RESPAWN_LOCATIONS pushBack ([WF_Client_SideJoined, [getPosATL _x, 5] call WFCO_FNC_GetSafePlace, _txt] call BIS_fnc_addRespawnPosition);
                    } else {
                        WF_C_RESPAWN_LOCATIONS pushBack ([WF_Client_SideJoined, _x] call BIS_fnc_addRespawnPosition);
                    }
            }
            }
        } forEach _spawn_locations;

        /* HQ Building Init. */
        12452 cutText ["<t size='2' color='#00a2e8'>"+(localize 'STR_WF_Loading')+":</t>" +
        	"<br /><t size='1.5'>90%</t>   <t color='#ffd719' size='1.5'>"+(localize 'STR_WF_LoadingWaitForHQ')+"</t>","BLACK IN", 5, true, true];

        if (!isNil 'WF_PlayerMenuAction') then { player removeAction WF_PlayerMenuAction };
    }
}

