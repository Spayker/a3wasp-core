/*
	Triggered whenever the player die
	 Parameters:
		- Killed
*/

params ["_killed", "_respawnDelay"];
Private ["_delay"];

if(!isNull (missionNamespace getVariable ["wf_remote_ctrl_unit", objNull])) then {
    [missionNamespace getVariable "wf_remote_ctrl_unit"] spawn WFCL_FNC_abortRemoteControl
};

if(WF_GameOver) exitWith {};

WF_Client_IsRespawning = true;

if !(isNil "HQAction") then {(leader WF_Client_Team) removeAction HQAction};

//--- Close any existing dialogs.
if (dialog) then {closeDialog 0};

(_killed) connectTerminalToUAV objNull;

//--- Update the player.
[WF_Client_Team, _killed] remoteExecCall ["WFSE_FNC_updateTeamLeader",2];

//--- Make sure that player is always the leader (of his group).
if (! (isPlayer (_killed)) && !(WF_Client_SideJoined isEqualTo resistance)) then {(WF_Client_Team) selectLeader (_killed)};

/* Re-add client UAV deploy handler */
(leader WF_Client_Team) addEventHandler ["WeaponAssembled", {
	params ["_unit", "_staticWeapon"];
	if((typeof _staticWeapon) in WF_AR2_UAVS) then {
        _staticWeapon removeWeaponTurret ["Laserdesignator_mounted",[0]];
        _staticWeapon removeMagazineTurret ["Laserbatteries",[0]]
	}
}];

_killedPos = if(isNil '_killed') then { getPosATL (vehicle player) } else { getPosATL (vehicle _killed) };
_spawn_locations = [WF_Client_SideJoined, _killedPos] Call WFCL_FNC_GetRespawnAvailable;

{ _x call BIS_fnc_removeRespawnPosition } forEach WF_C_RESPAWN_LOCATIONS;
WF_C_RESPAWN_LOCATIONS = [];

{
    if(_x isKindOf "WarfareBBaseStructure" || _x isKindOf "Warfare_HQ_base_unfolded") then {
        _type = _x getVariable ['wf_structure_type', ""];
        _sorted = [getPosATL _x, towns] Call WFCO_FNC_SortByDistance;
        _nearTown = (_sorted select 0) getVariable 'name';
        _txt = _type + ' ' + _nearTown;
        WF_C_RESPAWN_LOCATIONS pushBackUnique([WF_Client_SideJoined, _x, _txt] call BIS_fnc_addRespawnPosition)
    } else {
        if (typeof _x in ["CUP_O_BTR90_HQ_RU" , "CUP_B_LAV25_HQ_USMC" , "CUP_B_LAV25_HQ_desert_USMC"]) then {
            _type = _x getVariable ['wf_structure_type', ""];
            _sorted = [getPosATL _x, towns] Call WFCO_FNC_SortByDistance;
            _nearTown = (_sorted select 0) getVariable 'name';
            _txt = _type + ' ' + _nearTown;
            WF_C_RESPAWN_LOCATIONS pushBackUnique([WF_Client_SideJoined, [getPosATL _x, 60] call WFCO_FNC_GetSafePlace, _txt] call BIS_fnc_addRespawnPosition)
    } else {
            if (typeof _x == WF_C_CAMP ) then {
                _sorted = [getPosATL _x, towns] Call WFCO_FNC_SortByDistance;
                _nearTown = (_sorted select 0) getVariable 'name';
                _txt = 'Camp ' + _nearTown + ' ' + str (round((_killedPos) distance _x)) + 'M';
                WF_C_RESPAWN_LOCATIONS pushBackUnique ([WF_Client_SideJoined, [getPosATL _x, 5] call WFCO_FNC_GetSafePlace, _txt] call BIS_fnc_addRespawnPosition);
            } else {
                if (typeof _x in  WF_Logic_Depot || typeof _x == WF_Logic_Airfield) then {
                    _townSpeciality = _x getVariable ["townSpeciality", []];
                    _baseTypeName = 'Military Base ';
                    if (WF_C_AIR_BASE in _townSpeciality) then { _baseTypeName = 'Air Base ' };
                    _sorted = [getPosATL _x, towns] Call WFCO_FNC_SortByDistance;
                    _nearTown = (_sorted select 0) getVariable 'name';
                    _txt = _baseTypeName + _nearTown + ' ' + str (round((_killedPos) distance _x)) + 'M';
                    WF_C_RESPAWN_LOCATIONS pushBackUnique([WF_Client_SideJoined, [getPosATL _x, 60] call WFCO_FNC_GetSafePlace, _txt] call BIS_fnc_addRespawnPosition)
                } else {
                WF_C_RESPAWN_LOCATIONS pushBackUnique ([WF_Client_SideJoined, _x] call BIS_fnc_addRespawnPosition)

                }
            }
    }
    }
} forEach _spawn_locations;

if(WF_P_gearPurchased && !isNil ('WF_P_CurrentGear')) then {
    //// last saved gear
    [WF_Client_SideJoined, [format["%1_Saved_Assault_0", WF_Client_SideJoined],  -1, 12]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_Saved_Engineer_0", WF_Client_SideJoined], -1,  6]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_Saved_Recon_0", WF_Client_SideJoined],    -1,  3]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_Saved_Support_0", WF_Client_SideJoined],  -1,  3]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_Saved_Medic_0", WF_Client_SideJoined],    -1,  3]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_Saved_SpecOps_0", WF_Client_SideJoined],  -1,  3]] call BIS_fnc_addRespawnInventory;
} else {
    [WF_Client_SideJoined, [format["%1_Assault_0", WF_Client_SideJoined],  -1, 12]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_Engineer_0", WF_Client_SideJoined], -1,  6]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_Recon_0", WF_Client_SideJoined],    -1,  3]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_Support_0", WF_Client_SideJoined],  -1,  3]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_Medic_0", WF_Client_SideJoined],    -1,  3]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_SpecOps_0", WF_Client_SideJoined],  -1,  3]] call BIS_fnc_addRespawnInventory;
};

player removeAllEventHandlers "HandleHeal";

[{true}, WF_C_RESPAWN_DELAY - _respawnDelay, ""] call BIS_fnc_setRespawnDelay
