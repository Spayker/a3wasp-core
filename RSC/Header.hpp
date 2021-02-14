/* Header */

//--- Require briefing.html to show up.
onLoadMission = WF_MISSIONNAME;
onLoadMissionTime = false;

//--- Respawn options.
respawn = 3;
respawnDelay = WF_RESPAWNDELAY;
respawnTemplates[] = {"MenuPosition","MenuInventory"};
respawnOnStart = 1;
respawnDialog = 0;

//--- Properties.
class Header {
	gameType = CTI;
	minPlayers = 1;
	maxPlayers = WF_MAXPLAYERS;
};