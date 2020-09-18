//--- Define which 'part' of the game to run.
#include "version.sqf"

WF_Debug = false;
#ifdef WF_DEBUG
	WF_Debug = true;
#endif

WF_Skip_Intro = false;
#ifdef WF_SKIP_INTRO
	WF_Skip_Intro = true;
#endif

WF_Camo = false;
#ifdef WF_CAMO
	WF_Camo = true;
#endif

//--- Global Init, first file called.
isHostedServer = (isServer && !isDedicated);
isHeadLessClient = false;
//--- Headless Client?
isHeadLessClient = (!hasInterface && !isDedicated);

clientInitComplete = false;
commonInitComplete = false;
serverInitComplete = false;
serverInitFull = false;
WF_GameOver = false;
townInitServer = false;
townInit = false;
towns = [];

if (isHostedServer || (!isHeadLessClient && !isDedicated)) then {
    12452 cutText ["<t size='2' color='#00a2e8'>"+(localize 'STR_WF_Loading')+":</t><br /><t size='1.5'>10%</t>   <t color='#ffd719' size='1.5'>"+(localize 'STR_WF_LoadingWaitForTheServer')+"</t>","BLACK IN",55555, true, true];
};

missionNamespace setVariable ["WF_TERR_TYPE", WF_TERR_TYPE];
missionNamespace setVariable ["WF_MAXPLAYERS", WF_MAXPLAYERS];
missionNamespace setVariable ["WF_MISSIONNAME", WF_MISSIONNAME];
WF_LogLevel = 0; //--- Logging level (0: Trivial, 1: Information, 2: Warnnings, 3: Errors).

//--- Mission is starting.
for '_i' from 0 to 3 do {diag_log "################################"};
diag_log format ["## Island Name: [%1]", worldName];
diag_log format ["## Mission Name: [%1]", WF_MISSIONNAME];
diag_log format ["## Max players Defined: [%1]", WF_MAXPLAYERS];
for '_i' from 0 to 3 do {diag_log "################################"};

["INITIALIZATION", "initJIPCompatible.sqf: Starting JIP Initialization"] Call WFCO_FNC_LogContent;
WF_Client_SideJoined = civilian;

if (isHeadLessClient) then {["INITIALIZATION", "Init.sqf: Detected an headless client."] Call WFCO_FNC_LogContent};

//--- Server JIP Information
if ((isHostedServer || isDedicated) && !isHeadLessClient) then { //--- JIP Handler, handle connection & disconnection.
	onPlayerConnected {[_uid, _name, _id, _owner] spawn WFSE_FNC_OnPlayerConnected};
	addMissionEventHandler ["HandleDisconnect",{_this spawn WFSE_FNC_OnPlayerDisconnected}];
};

//--- Client initialization, either hosted or pure client. Part I
if (isHostedServer || (!isHeadLessClient && !isDedicated)) then {
	["INITIALIZATION", "Init.sqf: Client detected... waiting for non null result..."] Call WFCO_FNC_LogContent;
	waitUntil {!isNull player};
	["INITIALIZATION", "Init.sqf: Client is not null..."] Call WFCO_FNC_LogContent;
};

setObjectViewDistance 1750; //--- Server & Client default View Distance.
setViewDistance 4000;
waitUntil {time > 0};
enableEnvironment [false, true];


if (isMultiplayer) then {Call WFCO_fnc_initParameters}; //--- In MP, we get the parameters.
WF_Parameters_Ready = true; //--- All parameters are set and ready.

call WFCO_fnc_initCommonConstants;//--- Set the constants and the parameters, skip the params if they're already defined.

if (WF_Debug) then { //--- Debug.
	missionNamespace setVariable ["WF_C_GAMEPLAY_UPGRADES_CLEARANCE", 7];
	missionNamespace setVariable ["WF_C_TOWNS_OCCUPATION", 1];
	missionNamespace setVariable ["WF_C_TOWNS_DEFENDER", 2];
	//missionNamespace setVariable ["WF_C_TOWNS_STARTING_MODE", 2];
	missionNamespace setVariable ["WF_C_ECONOMY_SUPPLY_START_EAST", 999999];
	missionNamespace setVariable ["WF_C_ECONOMY_SUPPLY_START_WEST", 999999];
	missionNamespace setVariable ["WF_C_ECONOMY_FUNDS_START_EAST", 999999];
	missionNamespace setVariable ["WF_C_ECONOMY_FUNDS_START_WEST", 999999];
	missionNamespace setVariable ["WF_C_MODULE_WF_EASA", 1];
	missionNamespace setVariable ["WF_DEBUG_DISABLE_TOWN_INIT", 0];  // 0 -> disabled, 1 -> enabled
};

["INITIALIZATION", "initJIPCompatible.sqf: Headless client is supported."] Call WFCO_FNC_LogContent;

//--- Apply the time-environment (don't halt).
[] Spawn {
	waitUntil {time > 0}; //--- Await for the mission to start / JIP.
	setDate [(date # 0),(missionNamespace getVariable "WF_C_ENVIRONMENT_STARTING_MONTH"),(date # 2),(missionNamespace getVariable "WF_C_ENVIRONMENT_STARTING_HOUR"),(date # 4)]; //--- Apply the date and time.
	if (local player) then {skipTime (time / 3600)}; //--- If we're dealing with a client, he may have JIP half way through the game. Sync him via skipTime with the mission time.
	sleep 2;
};

[] spawn WFCO_fnc_initCommon; //--- Execute the common files.
[] spawn WFCO_fnc_initTowns; //--- Execute the towns file.

//--- Server initialization.
if (isHostedServer || isDedicated) then { //--- Run the server's part.
	["INITIALIZATION", "initJIPCompatible.sqf: Executing the Server Initialization."] Call WFCO_FNC_LogContent;
	[] spawn WFSE_fnc_initServer;
};

//--- Weather	
if (WF_C_ENVIRONMENT_WEATHER_SNOWSTORM > 0) then {
	//"_snowfall","_duration_storm","_ambient_sounds_al","_breath_vapors","_snow_burst","_effect_on_objects","_vanilla_fog","_local_fog","_intensifywind","_unitsneeze"
	[true,           6000,                15,                    false,           10,             false, 			false,         true,        true,          true] execvm "Common\Module\Weather\SnowStorm\al_snow.sqf";
};

//--- Client initialization, either hosted or pure client. Part II
if (isHostedServer || (!isHeadLessClient && !isDedicated)) then {
	waitUntil {!isNil 'WF_PRESENTSIDES'}; //--- Await for teams to be set before processing the client init.
	{
		_logik = (_x) Call WFCO_FNC_GetSideLogic;
		waitUntil {!isNil {_logik getVariable "wf_teams"}};
		missionNamespace setVariable [Format["WF_%1TEAMS",_x], _logik getVariable "wf_teams"];
	} forEach WF_PRESENTSIDES;

	["INITIALIZATION", "Init.sqf: Executing the Client Initialization."] Call WFCO_FNC_LogContent;

	[] spawn WFCL_fnc_initClient;
	waitUntil {clientInitComplete};
	if!(WF_Skip_Intro) then {
	    [] spawn WFCL_FNC_MissionIntro;
        waitUntil {WF_EndIntro};
	} else {
	    12452 cutText ["<t size='2' color='#00a2e8'>"+(localize 'STR_WF_Loading')+":</t>" + 
		"<br /><t size='1.5'>100%</t>   <t color='#ffd719' size='1.5'>"+(localize 'STR_WF_LoadingGearTemplates')+"</t>","BLACK IN",5, true, true];
	};
};

//--- Run the headless client initialization.
if (isHeadLessClient) then { call WFHC_fnc_initHc };