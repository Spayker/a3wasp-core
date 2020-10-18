/*
	Triggered whenever the player die
	 Parameters:
		- Killed
*/

params ["_body"];

//--- EH are flushed on unit death, still, just make sure.
player removeAllEventHandlers "killed";
removeAllActions _body;

WF_Client_IsRespawning = true;

player removeAction WF_PlayerMenuAction;
if !(isNil "HQAction") then {player removeAction HQAction};

//--- Close any existing dialogs.
if (dialog) then {closeDialog 0};

if(!WF_GameOver) then
{
	WF_DeathLocation = getPos _body;

	//--- Fade transition.
	titleCut["","BLACK OUT",1];
	waitUntil {alive player};

	//--- Update the player.
	[WF_Client_Team, player] remoteExecCall ["WFSE_FNC_updateTeamLeader",2];
	//--- Make sure that player is always the leader (of his group).
	if (group player == WF_Client_Team) then {
		if (leader(group player) != player) then {(group player) selectLeader player};
	};

	titleCut["","BLACK IN",1];

	//--- Re-add the KEH to the client.
	player addEventHandler ['Killed', {[_this select 0,_this select 1] Spawn WFCL_FNC_OnKilled; [_this select 0,_this select 1, sideID] Spawn WFCO_FNC_OnUnitKilled}];

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
	[] Spawn {
		Private ["_delay"];
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
	};

	sleep random 1;

	//--- Create a respawn menu.
	createDialog "WF_RespawnMenu";
};