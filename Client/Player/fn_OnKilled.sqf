/*
	Triggered whenever the player die
	 Parameters:
		- Killed
*/

params ["_killed", "_killer"];
Private ["_delay"];

if(WF_GameOver) exitWith {};

WF_Client_IsRespawning = true;

if !(isNil "HQAction") then {player removeAction HQAction};

//--- Close any existing dialogs.
if (dialog) then {closeDialog 0};

WF_DeathLocation = getPos _killed;
player connectTerminalToUAV objNull;

//--- Fade transition.
titleCut["","BLACK OUT",1];

[_killed, _killer, sideID] Spawn WFCO_FNC_OnUnitKilled;

waitUntil {alive player};

//--- Update the player.
[WF_Client_Team, player] remoteExecCall ["WFSE_FNC_updateTeamLeader",2];

//--- Make sure that player is always the leader (of his group).
if (! (isPlayer (leader(group player))) && !(WF_Client_SideJoined isEqualTo resistance)) then {(group player) selectLeader player};

//--- Create a respawn menu.
createDialog "WF_RespawnMenu";

titleCut["","BLACK IN",1];

/* Re-add client UAV deploy handler */
player addEventHandler ["WeaponAssembled", {
	params ["_unit", "_staticWeapon"];
	if((typeof _staticWeapon) in WF_AR2_UAVS) then {
        _staticWeapon removeWeaponTurret ["Laserdesignator_mounted",[0]];
        _staticWeapon removeMagazineTurret ["Laserbatteries",[0]]
	}
}];

//--- Call the pre respawn routine.
(player) Call WFCL_FNC_PreRespawnHandler;

//--- Camera & PP thread
_delay = missionNamespace getVariable "WF_C_RESPAWN_DELAY";

"dynamicBlur" ppEffectEnable true;
"dynamicBlur" ppEffectAdjust [1];
"dynamicBlur" ppEffectCommit _delay/3;
"colorCorrections" ppEffectAdjust [1, 1, 0, [0.1, 0.0, 0.0, 1], [1.0, 0.5, 0.5, 0.1], [0.199, 0.587, 0.114, 0.0]];
"colorCorrections" ppEffectCommit 0.1;
"colorCorrections" ppEffectEnable true;
"colorCorrections" ppEffectAdjust [1, 1, 0, [0.1, 0.0, 0.0, 0.5], [1.0, 0.5, 0.5, 0.1], [0.199, 0.587, 0.114, 0.0]];
"colorCorrections" ppEffectCommit _delay/3;

WF_DeathCamera = "camera" camCreate WF_DeathLocation;
//WF_DeathCamera camSetDir 0;
WF_DeathCamera camSetFov 0.7;
WF_DeathCamera cameraEffect["Internal","TOP"];

WF_DeathCamera camSetTarget WF_DeathLocation;
WF_DeathCamera camSetPos [WF_DeathLocation select 0,(WF_DeathLocation select 1) + 2,5];
WF_DeathCamera camCommit 0;

waitUntil {camCommitted WF_DeathCamera};

WF_DeathCamera camSetPos [WF_DeathLocation select 0,(WF_DeathLocation select 1) + 2,30];
WF_DeathCamera camCommit _delay+2;