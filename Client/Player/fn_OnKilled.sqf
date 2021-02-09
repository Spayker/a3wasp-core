/*
	Triggered whenever the player die
	 Parameters:
		- Killed
*/

params ["_killed"];
Private ["_delay"];

if(!isNull (missionNamespace getVariable ["wf_remote_ctrl_unit", objNull])) then {
    [missionNamespace getVariable "wf_remote_ctrl_unit"] spawn WFCL_FNC_abortRemoteControl
};

if(WF_GameOver) exitWith {};

WF_Client_IsRespawning = true;

if !(isNil "HQAction") then {(leader WF_Client_Team) removeAction HQAction};

//--- Close any existing dialogs.
if (dialog) then {closeDialog 0};

WF_DeathLocation = getPosATL _killed;
(_killed) connectTerminalToUAV objNull;

//--- Fade transition.
//titleCut["","BLACK OUT",1];

// waitUntil {alive player};

//--- Update the player.
[WF_Client_Team, _killed] remoteExecCall ["WFSE_FNC_updateTeamLeader",2];

//--- Make sure that player is always the leader (of his group).
if (! (isPlayer (_killed)) && !(WF_Client_SideJoined isEqualTo resistance)) then {(WF_Client_Team) selectLeader (_killed)};

//titleCut["","BLACK IN",1];

/* Re-add client UAV deploy handler */
(leader WF_Client_Team) addEventHandler ["WeaponAssembled", {
	params ["_unit", "_staticWeapon"];
	if((typeof _staticWeapon) in WF_AR2_UAVS) then {
        _staticWeapon removeWeaponTurret ["Laserdesignator_mounted",[0]];
        _staticWeapon removeMagazineTurret ["Laserbatteries",[0]]
	}
}];

{ _x call BIS_fnc_removeRespawnPosition } forEach WF_C_RESPAWN_LOCATIONS;

WF_C_RESPAWN_LOCATIONS = [];
_spawn_locations = [WF_Client_SideJoined, WF_DeathLocation] Call WFCL_FNC_GetRespawnAvailable;
{
    _name = name _x;
    if(_x isKindOf "WarfareBBaseStructure" || _x isKindOf "Warfare_HQ_base_unfolded") then {
        _type = _x getVariable ['wf_structure_type', 'test'];
        _nearTown = ([_x, towns] Call WFCO_FNC_GetClosestEntity) getVariable 'name';
        _txt = _type + ' ' + _nearTown + ' ' + str (round((vehicle player) distance _x)) + 'M';
        WF_C_RESPAWN_LOCATIONS pushBack ([WF_Client_SideJoined, _x, _txt] call BIS_fnc_addRespawnPosition);
    } else {
        WF_C_RESPAWN_LOCATIONS pushBack ([WF_Client_SideJoined, _x] call BIS_fnc_addRespawnPosition);
    }
} forEach _spawn_locations;

private _respawnInfo = [player] call BIS_fnc_getRespawnInventories;

if(isFirstSpawnIsDone && WF_P_gearPurchased) then {
    //// last saved gear
    [WF_Client_SideJoined, [format["%1_Saved_Soldier_0", WF_Client_SideJoined],  -1, 12]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_Saved_Engineer_0", WF_Client_SideJoined], -1,  6]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_Saved_Recon_0", WF_Client_SideJoined],    -1,  3]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_Saved_Support_0", WF_Client_SideJoined],  -1,  3]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_Saved_Medic_0", WF_Client_SideJoined],    -1,  3]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_Saved_SpecOps_0", WF_Client_SideJoined],  -1,  3]] call BIS_fnc_addRespawnInventory;
} else {
    [WF_Client_SideJoined, [format["%1_Soldier_0", WF_Client_SideJoined],  -1, 12]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_Engineer_0", WF_Client_SideJoined], -1,  6]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_Recon_0", WF_Client_SideJoined],    -1,  3]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_Support_0", WF_Client_SideJoined],  -1,  3]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_Medic_0", WF_Client_SideJoined],    -1,  3]] call BIS_fnc_addRespawnInventory;
    [WF_Client_SideJoined, [format["%1_SpecOps_0", WF_Client_SideJoined],  -1,  3]] call BIS_fnc_addRespawnInventory;
}
