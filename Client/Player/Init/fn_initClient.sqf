Private ['_HQRadio','_base','_buildings','_condition','_get','_idbl','_isDeployed','_oc','_weat'];

["INITIALIZATION", Format ["fn_initClient.sqf: Client initialization begins at [%1]", time]] Call WFCO_FNC_LogContent;

//--Do check for required addons--
_reqAddons = "";
{
	_isModeExists = true;
	_tmpMas = _x # 1;
	for "_i" from 0 to (count _tmpMas) - 1 do {			
		if !(isClass (configFile >> "CfgPatches" >> (_tmpMas # _i))) then {
			_isModeExists = false;
		};		
	};
	
	if !(_isModeExists) then { _reqAddons = format["%1 %2", _reqAddons ,_x # 0] };
} foreach WF_REQ_ADDONS;

if(count (toArray(_reqAddons)) > 0) then { 
	["WARNING", Format["fn_initClient.sqf: Client [%1] have not required addons: [%2], and is now being sent back to the lobby.", name player, _reqAddons]] Call WFCO_FNC_LogContent;
	titleText [(localize "STR_WF_ReqAddons") + ": \n"+_reqAddons, "BLACK FADED", 20];
	sleep 20;
	failMission "END1";
};

WF_Client_SideJoined = side player;
WF_Client_SideJoinedText = str WF_Client_SideJoined;

WF_STRCUCTURES_ICONS = true;
WF_MAXPLAYERS_IN_TEAM = 30;
WF_EndIntro = if(WF_Skip_Intro) then {true} else {false};
WF_IsRoleSelectedDialogClosed = false;
WF_isFirstRoleSelected = false;
WF_KillPay_Array = [];
//--- Position the client on the temp spawn (Common is not yet init'd so we call is straigh away).
12452 cutText ["<t size='2' color='#00a2e8'>"+(localize 'STR_WF_Loading')+":</t>" + 	
	"<br /><t size='1.5'>35%</t>   <t color='#ffd719' size='1.5'>"+(localize 'STR_WF_LoadingGetPreRespawn')+"</t>","BLACK IN",55555, true, true];
player setPos ([getMarkerPos Format["%1TempRespawnMarker",WF_Client_SideJoinedText],1,10] Call WFCO_FNC_GetRandomPosition);

// Dialog: Skills Menu
WF_role_list = [];

// Dialog: Squad menu
WF_Client_LastGroupJoinRequest = -5000;
WF_Client_PendingRequests = [];
WF_Client_PendingRequests_Accepted = [];
call WFCL_fnc_Squads;

//--- Notification HUD init
call WFCL_fnc_initMessageHUD;
WF_PREVIOUS_HINT_MESSAGE = "";

//--- Namespace related (GUI).
BIS_FNC_GUIset = {UInamespace setVariable [_this # 0, _this # 1]};
BIS_FNC_GUIget = {UInamespace getVariable (_this # 0)};

//// GEAR INIT
//--- Gear: Config sub ID
WF_SUBTYPE_ITEM = 0;
WF_SUBTYPE_ACC_MUZZLE = 101;
WF_SUBTYPE_ACC_OPTIC = 201;
WF_SUBTYPE_ACC_SIDE = 301;
WF_SUBTYPE_ACC_BIPOD = 302;
WF_SUBTYPE_HEADGEAR = 605;
WF_SUBTYPE_UAVTERMINAL = 621;
WF_SUBTYPE_VEST = 701;
WF_SUBTYPE_UNIFORM = 801;
WF_SUBTYPE_BACKPACK = 901;

WF_GEAR_TAB_PRIMARY = 0;
WF_GEAR_TAB_SECONDARY = 1;
WF_GEAR_TAB_HANDGUN = 2;
WF_GEAR_TAB_UNIFORMS = 3;
WF_GEAR_TAB_BACKPACK = 4;
WF_GEAR_TAB_EQUIPMENT = 5;
WF_GEAR_TAB_HEADGEAR = 6;
WF_GEAR_TAB_GLASSES = 7;
WF_GEAR_TAB_EXPLOSIVES = 8;
WF_GEAR_TAB_SPECIAL = 9;
WF_GEAR_TAB_MAGAZINES = 10;
WF_GEAR_TAB_MISC = 11;
WF_GEAR_TAB_TEMPLATES = 12;

//--- Gear: Config ID
WF_TYPE_RIFLE = 1;
WF_TYPE_PISTOL = 2;
WF_TYPE_LAUNCHER = 4;
WF_TYPE_RIFLE2H = 5;
WF_TYPE_EQUIPMENT = 4096;
WF_TYPE_ITEM = 131072;

// adjusting fatigue
if ((missionNamespace getVariable "WF_C_GAMEPLAY_FATIGUE_ENABLED") == 1) then {
    player setCustomAimCoef 0.35;
    player setUnitRecoilCoefficient 0.75;
    player enablestamina false;
} else {
    player enableFatigue false;
    player setCustomAimCoef 0.1;
};

[_this # 0] spawn {
	waitUntil {!isNil "ASL_Add_Player_Actions"};

	if!(_this # 0 getVariable ["ASL_Actions_Loaded",false]) then {
		[] call ASL_Add_Player_Actions;
		_this # 0 setVariable ["ASL_Actions_Loaded",true];
	};
};

// right custom HUD module
if (!(visibleMap) && (isNil "BIS_CONTROL_CAM")) then {Local_GUIWorking=true; 1365 cutRsc ["RscOverlay","PLAIN",0]};//if GUI is not working, but it should - restart it

// RADIO CHANNEL SETTINGS
0 enableChannel [true, false]; // removing voice in global but global chat will be on
1 enableChannel [true, true];  // enabling side voice and chat
2 enableChannel [true, true];  // enabling command voice and chat
4 enableChannel [true, true];  // enabling vehicle voice and chat
5 enableChannel [true, true];  // enabling direct voice and chat

12452 cutText ["<t size='2' color='#00a2e8'>"+(localize 'STR_WF_Loading')+":</t>" + 	
	"<br /><t size='1.5'>65%</t>   <t color='#ffd719' size='1.5'>"+(localize 'STR_WF_LoadingPreparingRolesGear')+"</t>","BLACK IN",55555, true, true];
if (WF_Client_SideJoined == west) then {(west) call compile preprocessFileLineNumbers "Common\Warfare\Config\Gear\Gear_West.sqf"};
if (WF_Client_SideJoined == east) then {(east) call compile preprocessFileLineNumbers "Common\Warfare\Config\Gear\Gear_East.sqf"};

if (WF_Client_SideJoined == west) then {(west) call compile preprocessFileLineNumbers "Common\Warfare\Config\Gear\Gear_Vanilla_West.sqf"};
if (WF_Client_SideJoined == east) then {(east) call compile preprocessFileLineNumbers "Common\Warfare\Config\Gear\Gear_Vanilla_East.sqf"};

if (WF_Client_SideJoined == west) then {(west) call compile preprocessFileLineNumbers "Common\Warfare\Config\Gear\Gear_Vanilla_Common.sqf"};
if (WF_Client_SideJoined == east) then {(east) call compile preprocessFileLineNumbers "Common\Warfare\Config\Gear\Gear_Vanilla_Common.sqf"};

if (WF_Client_SideJoined == east) then {(east) call compile preprocessFileLineNumbers "Common\Warfare\Config\Gear\RoleBased\Gear_Sniper_East.sqf"};
if (WF_Client_SideJoined == west) then {(west) call compile preprocessFileLineNumbers "Common\Warfare\Config\Gear\RoleBased\Gear_Sniper_West.sqf"};

if (WF_Client_SideJoined == east) then {(east) call compile preprocessFileLineNumbers "Common\Warfare\Config\Gear\RoleBased\Gear_Support_East.sqf"};
if (WF_Client_SideJoined == west) then {(west) call compile preprocessFileLineNumbers "Common\Warfare\Config\Gear\RoleBased\Gear_Support_West.sqf"};


//--- UI Namespace release from previous possible games (only on titles dialog!).
{uiNamespace setVariable [_x, displayNull]} forEach ["wf_title_capture"];

//--- Waiting for the common part to be executed.
waitUntil {commonInitComplete};

["INITIALIZATION", Format ["fn_initClient.sqf: Common initialization is complete at [%1]", time]] Call WFCO_FNC_LogContent;

Call WFCL_fnc_initProfileVariables;

12452 cutText ["<t size='2' color='#00a2e8'>"+(localize 'STR_WF_Loading')+":</t>" + 	
	"<br /><t size='1.5'>80%</t>   <t color='#ffd719' size='1.5'>"+(localize 'STR_WF_LoadingGlobalData')+"</t>","BLACK IN",55555, true, true];
//--- Queue Protection.
missionNamespace setVariable ['WF_C_QUEUE_BARRACKS',0];
missionNamespace setVariable ['WF_C_QUEUE_BARRACKS_MAX',10];
missionNamespace setVariable ['WF_C_QUEUE_LIGHT',0];
missionNamespace setVariable ['WF_C_QUEUE_HQ_LIGHT',0];
missionNamespace setVariable ['WF_C_QUEUE_LIGHT_MAX',5];
missionNamespace setVariable ['WF_C_QUEUE_LIGHT_HQ_MAX',1];
missionNamespace setVariable ['WF_C_QUEUE_HEAVY',0];
missionNamespace setVariable ['WF_C_QUEUE_HQ_HEAVY',0];
missionNamespace setVariable ['WF_C_QUEUE_HEAVY_MAX',5];
missionNamespace setVariable ['WF_C_QUEUE_HEAVY_HQ_MAX',1];
missionNamespace setVariable ['WF_C_QUEUE_AIRCRAFT',0];
missionNamespace setVariable ['WF_C_QUEUE_AIRCRAFT_MAX',2];
missionNamespace setVariable ['WF_C_QUEUE_AIRPORT',0];
missionNamespace setVariable ['WF_C_QUEUE_AIRPORT_MAX',2];
missionNamespace setVariable ['WF_C_QUEUE_DEPOT',0];
missionNamespace setVariable ['WF_C_QUEUE_DEPOT_MAX',4];

missionNamespace setVariable ['WF_C_GROUP_QUEUE_BARRACKS',0];
missionNamespace setVariable ['WF_C_GROUP_QUEUE_BARRACKS_MAX',3];
missionNamespace setVariable ['WF_C_GROUP_QUEUE_LIGHT',0];
missionNamespace setVariable ['WF_C_GROUP_QUEUE_LIGHT_MAX',3];
missionNamespace setVariable ['WF_C_GROUP_QUEUE_HEAVY',0];
missionNamespace setVariable ['WF_C_GROUP_QUEUE_HEAVY_MAX',3];
missionNamespace setVariable ['WF_C_GROUP_QUEUE_AIRCRAFT',0];
missionNamespace setVariable ['WF_C_GROUP_QUEUE_AIRCRAFT_MAX',3];
missionNamespace setVariable ['WF_C_GROUP_QUEUE_AIRPORT',0];
missionNamespace setVariable ['WF_C_GROUP_QUEUE_AIRPORT_MAX',3];
missionNamespace setVariable ['WF_C_GROUP_QUEUE_DEPOT',0];
missionNamespace setVariable ['WF_C_GROUP_QUEUE_DEPOT_MAX',3];

//--- Global Client Variables.
sideID = WF_Client_SideJoined Call WFCO_FNC_GetSideID;
paramBoundariesRunning = false;
call WFCL_fnc_initGlobalMarkingMonitorFunctions;
WF_Client_Logic = (WF_Client_SideJoined) Call WFCO_FNC_GetSideLogic;
WF_Client_SideID = sideID;
WF_Client_Color = switch (WF_Client_SideJoined) do { case west: {missionNamespace getVariable "WF_C_WEST_COLOR"}; case east: {missionNamespace getVariable "WF_C_EAST_COLOR"}; case resistance: {missionNamespace getVariable "WF_C_GUER_COLOR"};};
WF_Client_Team = group player;
WF_Client_Teams = missionNamespace getVariable Format['WF_%1TEAMS',WF_Client_SideJoinedText];
WF_Client_Teams_Count = count WF_Client_Teams;
WF_Client_IsRespawning = false;
WF_UNIT_MARKERS = [];

commanderTeam = objNull;
buildingMarker = 0;
CCMarker = 0;
lastBuilt = [];
unitQueu = 0;
groupQueu = 0;
fireMissionTime = -1000;
artyRange = 15;
artyPos = [0,0,0];
comTask = objNull;
voted = false;
votePopUp = true;
hudOn = true;
WF_AutoManningDefense = true;
lastParaCall = -1200;
lastSupplyCall = -1200;
lastCasCall = -1200;
lastCruiseMissileCall = -1200;
lastChemicalMissileCall = -1200;
canBuildWHQ = true;
WF_RespawnDefaultGear = false;
WF_ForceUpdate = true;

//--Set default Shadows Distance if it wasn't loaded from the profile--
if (isNil 'currentSD') then {
	currentSD = 25;
	setShadowDistance currentSD;
};

//--Set default Terrain grid if it wasn't loaded from the profile--
if (isNil 'currentTG') then {
	currentTG = 25;
	setTerrainGrid currentTG;
};

hqInRange = false;
barracksInRange = false;
gearInRange = false;
lightInRange = false;
heavyInRange = false;
aircraftInRange = false;
serviceInRange = false;
commandInRange = false;
depotInRange = false;
antiAirRadarInRange = false;
antiArtyRadarInRange = false;
hangarInRange = false;

enableTeamSwitch false;

//--- Import the client side upgrade informations.
ExecVM "Common\Warfare\Config\Core_Upgrades\Labels_Upgrades.sqf";

//--- Update the player.
if (isMultiplayer) then {
	[WF_Client_Team, player] remoteExecCall ["WFSE_FNC_updateTeamLeader",2];
};

//--- Disable Artillery Computer.
Call Compile "enableEngineArtillery false;";

//--- Commander % stock init.
if (isNil { missionNamespace getVariable "wf_commander_percent"}) then { missionNamespace setVariable ["wf_commander_percent", if ((missionNamespace getVariable "WF_C_ECONOMY_INCOME_PERCENT_MAX") >= 50 && (missionNamespace getVariable "WF_C_ECONOMY_INCOME_PERCENT_MAX") <= 100) then {missionNamespace getVariable "WF_C_ECONOMY_INCOME_PERCENT_MAX"} else {100}]};

//--- HQ price penalty.
if (isNil { missionNamespace getVariable (format ["wf_%1_hq_penalty", WF_Client_SideJoined])}) then {
    missionNamespace setVariable [format ["wf_%1_hq_penalty", WF_Client_SideJoined], 0]
};

/* Exec SQF|FSM Misc stuff. */
[] spawn WFCL_fnc_updateTeamsMarkers;

/* Don't pause the client initialization process. */
[] Spawn {
	waitUntil {townInit};
	/* Handle the capture GUI */
	["INITIALIZATION", "fn_initClient.sqf: Initializing the Town Capture FSM"] Call WFCO_FNC_LogContent;
	[] spawn WFCL_fnc_showTitleCapture;
	/* Handle the map town markers */
	["INITIALIZATION", "fn_initClient.sqf: Initializing the Towns Marker FSM"] Call WFCO_FNC_LogContent;
	[] spawn WFCL_fnc_updateTownMarkers;
	waitUntil {!isNil {WF_Client_Logic getVariable "wf_structures"}};
	waitUntil {!isNil {WF_Client_Logic getVariable "wf_supply"}};

	/* Handle the client actions */
	["INITIALIZATION", "fn_initClient.sqf: Initializing the Available Actions FSM"] Call WFCO_FNC_LogContent;
	[] spawn WFCL_fnc_updateAvailableActions;
};

//--- Add the briefing (notes).
[] Call Compile preprocessFile "briefing.sqf";

//--- HQ Radio system.
waitUntil {!isNil {WF_Client_Logic getVariable "wf_radio_hq"}};
_HQRadio = WF_Client_Logic getVariable "wf_radio_hq";
["INITIALIZATION", Format["fn_initClient.sqf: Initialized the Radio Announcer [%1]", _HQRadio]] Call WFCO_FNC_LogContent;
waitUntil {!isNil {WF_Client_Logic getVariable "wf_radio_hq_id"}};
WF_V_HQTopicSide = WF_Client_Logic getVariable "wf_radio_hq_id";
["INITIALIZATION", Format["fn_initClient.sqf: Initializing the Radio Announcer Identity [%1]", WF_V_HQTopicSide]] Call WFCO_FNC_LogContent;
_HQRadio setIdentity WF_V_HQTopicSide;
_HQRadio setRank "COLONEL";
_HQRadio setGroupId ["HQ"];
_HQRadio kbAddTopic [WF_V_HQTopicSide,"Common\Module\Kb\hq.bikb","Common\Module\Kb\hq.fsm",{call WFCO_fnc_initHq}];
player kbAddTopic [WF_V_HQTopicSide,"Common\Module\Kb\hq.bikb","Common\Module\Kb\hq.fsm",{call WFCO_fnc_initHq}];
sideHQ = _HQRadio;

["INITIALIZATION", "fn_initClient.sqf: Radio announcer is initialized."] Call WFCO_FNC_LogContent;

/* Wait for a valid signal (Teamswapping) with failover */
if (!WF_Debug) then {
	if (isMultiplayer && time > 7) then {
		private ["_get","_timelaps"];
		_get = true;

		sleep (random 0.1);

		[player, WF_Client_SideJoined] remoteExecCall ["WFSE_fnc_RequestJoin",2];
		
		_timelaps = 0;
		while { true } do {
			sleep 0.1;
			_get = missionNamespace getVariable 'WF_P_CANJOIN';
			if !(isNil '_get') exitWith { ["INITIALIZATION", Format["fn_initClient.sqf: [%1] Client [%2], Can join? [%3]",WF_Client_SideJoined,name player,_get]] Call WFCO_FNC_LogContent };

			_timelaps = _timelaps + 0.1;
			if (_timelaps > 15) then {
				_timelaps = 0;
				["WARNING", Format["fn_initClient.sqf: [%1] Client [%2] join is pending... no ACK was received from the server, a new request will be submitted.",WF_Client_SideJoined,name player]] Call WFCO_FNC_LogContent;
				[player, WF_Client_SideJoined] remoteExecCall ["WFSE_fnc_RequestJoin",2];
			};
		};

		if !(_get) exitWith {
			["WARNING", Format["fn_initClient.sqf: [%1] Client [%2] has teamswapped/STACKED and is now being sent back to the lobby.",WF_Client_SideJoined,name player]] Call WFCO_FNC_LogContent;

			sleep 12;
			failMission "END1";
		};
	};
} else {
    //--make request join for show--
    [player, WF_Client_SideJoined] remoteExecCall ["WFSE_fnc_RequestJoin",2];
};

/* Get the client starting location */
12452 cutText ["<t size='2' color='#00a2e8'>"+(localize 'STR_WF_Loading')+":</t>" + 	
	"<br /><t size='1.5'>85%</t>   <t color='#ffd719' size='1.5'>"+(localize 'STR_WF_LoadingGetRespawn')+"</t>","BLACK IN",55555, true, true];
["INITIALIZATION", "fn_initClient.sqf: Retrieving the client spawn location."] Call WFCO_FNC_LogContent;
_base = objNull;
if (time < 30) then {
	waitUntil {!isNil {WF_Client_Logic getVariable "wf_startpos"}};
	_base = WF_Client_Logic getVariable "wf_startpos";
} else {
	waitUntil {!isNil {WF_Client_Logic getVariable "wf_hq"}};
	waitUntil {!isNil {WF_Client_Logic getVariable "wf_structures"}};
	_mhqs = (WF_Client_SideJoined) Call WFCO_FNC_GetSideHQ;
    _base = [player,_mhqs] call WFCO_FNC_GetClosestEntity;
	_buildings = (WF_Client_SideJoined) Call WFCO_FNC_GetSideStructures;

	if (count _buildings > 0) then {_base = _buildings # 0;};
};

["INITIALIZATION", Format["fn_initClient.sqf: Client spawn location has been determined at [%1].", _base]] Call WFCO_FNC_LogContent;

/* Position the client at the previously defined location */
private _pos = getPos _base;
_safePos = [_pos, 0, 60] call BIS_fnc_findSafePos;
_pos set [0, _safePos # 0];
_pos set [1, _safePos # 1];
player setPos _pos;

/* HQ Building Init. */
12452 cutText ["<t size='2' color='#00a2e8'>"+(localize 'STR_WF_Loading')+":</t>" + 
	"<br /><t size='1.5'>90%</t>   <t color='#ffd719' size='1.5'>"+(localize 'STR_WF_LoadingWaitForHQ')+"</t>","BLACK IN",55555, true, true];


["INITIALIZATION", "fn_initClient.sqf: Initializing COIN Module."] Call WFCO_FNC_LogContent;

_mhqs = (WF_Client_SideJoined) Call WFCO_FNC_GetSideHQ;
_mhq = [player,_mhqs] call WFCO_FNC_GetClosestEntity;
_isDeployed = [WF_Client_SideJoined, _mhq] Call WFCO_FNC_GetSideHQDeployStatus;
if(isNil "_isDeployed") then { _isDeployed = false };

if (_isDeployed) then {
	[missionNamespace getVariable "WF_C_BASE_COIN_AREA_HQ_DEPLOYED",true,MCoin] Call WFCL_FNC_initConstructionModule;
} else {
	[missionNamespace getVariable "WF_C_BASE_COIN_AREA_HQ_UNDEPLOYED",false,MCoin] Call WFCL_FNC_initConstructionModule;
};

_greenList = [];
{_greenList pushBack (missionNamespace getVariable Format ["%1%2",WF_Client_SideJoinedText,_x]);} forEach ["BAR","LVF","HEAVY","AIR"];
missionNamespace setVariable ["COIN_UseHelper", _greenList];

//--- Make sure that player is always the leader.
if (leader(WF_Client_Team) != player) then {(WF_Client_Team) selectLeader player};

// initiate the passive skills.
WF_gbl_boughtRoles = [];
WF_FreeRolePurchase = true;

// map click drop
onMapSingleClick {if (_shift) then {false} else {true}};

/* Skill Module. */
WF_SHOW_FAST_REPAIR_ACTION = false;
[] Call WFCL_fnc_initSkill;
(player) Call WFCL_fnc_applySkill;

/* Debug System - Client */
if (WF_Debug) then {
	onMapSingleClick "vehicle player setpos _pos;(vehicle player) setVelocity [0,0,-0.1];diag_log getpos player;"; //--- Teleport
	player addEventHandler ["HandleDamage", {if (player != (_this # 3)) then {(_this # 3) setDammage 1}; false}]; //--- God-Slayer mode.
};

/* JIP Handler */
waitUntil {townInit};
["INITIALIZATION", "fn_initClient.sqf: Towns are initialized."] Call WFCO_FNC_LogContent;

/* JIP System, initialize the camps and towns properly. */
[] Spawn {
	sleep 2;
	["INITIALIZATION", "fn_initClient.sqf: Updating JIP Markers."] Call WFCO_FNC_LogContent;
	Call WFCL_fnc_initMarkers;
};

/* Repair Truck CoIn Handling. */
[missionNamespace getVariable "WF_C_BASE_COIN_AREA_REPAIR",false,RCoin,"REPAIR"] Call WFCL_FNC_initConstructionModule;

/* A new player come to reinforce the battlefield */
[WF_Client_SideJoinedText,'UnitsCreated',1] Call WFCO_FNC_UpdateStatistics;

/* Client death handler. */
player addEventHandler ['Killed', {_this Spawn WFCL_FNC_OnKilled}];

/* Client UAV deploy handler */
player addEventHandler ["WeaponAssembled", {
	params ["_unit", "_staticWeapon"];
	if((typeof _staticWeapon) in WF_AR2_UAVS) then {
        _staticWeapon removeWeaponTurret ["Laserdesignator_mounted",[0]];
        _staticWeapon removeMagazineTurret ["Laserbatteries",[0]]
	}
}];

_roleDefaultGear = [];
_roleDefaultGear = missionNamespace getVariable Format["WF_%1_DefaultGearSoldier", WF_Client_SideJoinedText];
[player, _roleDefaultGear] call WFCO_FNC_EquipUnit;
WF_P_CurrentGear = (player) call WFCO_FNC_GetUnitLoadout;
WF_P_gearPurchased = false;

/* Vote System, define whether a vote is already running or not */
["INITIALIZATION", "fn_initClient.sqf: Vote system is initialized."] Call WFCO_FNC_LogContent;
if ((WF_Client_Logic getVariable "wf_votetime") > 0) then {createDialog "WF_VoteMenu"};

/* Towns Task System */
["TownAddComplete"] Spawn WFCL_FNC_TaskSystem;

12452 cutText ["<t size='2' color='#00a2e8'>"+(localize 'STR_WF_Loading')+":</t>" + 
	"<br /><t size='1.5'>90%</t>   <t color='#ffd719' size='1.5'>"+(localize 'STR_WF_LoadingGearTemplates')+"</t>","BLACK IN",55555, true, true];
call WFCL_FNC_GetGearTemplates;

[] ExecVM "Client\Player\Init\fn_initThirdViewHandler.sqf";


clientInitComplete = true;

sleep 5;
/* HUD MODULE */
0 = [] spawn WFCL_FNC_updatePlayerHud;
/* Key Binding */
0 = [] spawn WFCL_fnc_initKeybind;
//--- Valhalla init.
0 = [] execVM "Client\Module\Valhalla\Init_Valhalla.sqf";

if!(WF_Skip_Intro) then {
    waitUntil { WF_EndIntro };
	
	[] spawn {
		sleep 10;
		["Buy first role for free near barracks or captured camp"] spawn WFCL_fnc_handleMessage;
	};
};

//--- map marker handler
WF_C_MAP_MARKER_HANDLER = {
    Private ['_unit', '_colorStr', '_iconType', '_color'];

	_iconsToBeDisplayed = [];
    {
        _unit = _x # 0;
        _colorStr = _x # 1;
		_unitPos = getPos _unit;
        _shallDraw = true;

        _text = if(count _x > 2) then { _x # 2 } else { '' };
        _iconType = getText (configFile >> "CfgVehicles" >> typeOf _unit >> "icon");

        _color = nil;
        switch (_colorStr) do {
            case 'ColorEAST':{ _color = [0.5,0,0,1] };
            case 'ColorWEST':{ _color = [0,0.3,0.6,1] };
            case 'ColorYellow':{ _color = [0.85,0.85,0,1] };
            case 'ColorCIV':{ _color = [0.4,0,0.5,1]  };
            default {_color = [0.85,0.4,0,1] };
        };

        if(_unit isKindOf 'Man') then {
            if(group _unit != WF_Client_Team) then {_text = ''};
            if (vehicle _unit != _unit) then {
                _vehicleUnit = vehicle _unit;
                    _iconType = getText (configFile >> "CfgVehicles" >> typeOf _vehicleUnit >> "icon");
                    _unitCrew = crew _vehicleUnit;
                    _digitArray = [];
                    {
                        if (group _x == WF_Client_Team) then {
                            _digit = (_x) call WFCO_FNC_GetAIDigit;
                            if(_digit != '') then {
                                _digitArray pushBack _digit;
                    _text = _digitArray joinString ", "
                            }
                        }
                    } forEach _unitCrew
            }
        } else {
            _iconType = getText (configFile >> "CfgVehicles" >> typeOf (_unit) >> "icon");
            _unitCrew = crew _unit;

            _text = '';
            if (count _unitCrew > 0) then {
                _digitArray = [];
                {
                    if (group _x == WF_Client_Team) then { _digitArray pushBack ((_x) call WFCO_FNC_GetAIDigit) };
                } forEach _unitCrew;
                        _text = _digitArray joinString ", ";
            }
                    };

		if (!(isNull _unit) && alive _unit && _shallDraw) then {
			_shallAdd = true;

			{
				if( ((_x # 0) + (_x # 3)) == (_iconType + _text)  ) then {
				    if(_x # 2 == (vehicle _unit)) exitWith {
					_shallAdd = false
				}
				}
			} foreach _iconsToBeDisplayed;

			if(_shallAdd) then {
				_iconsToBeDisplayed pushBack [_iconType, _color, vehicle _unit, _text]
            }

		}
    } forEach WF_UNIT_MARKERS;

	{
		_iconType = _x # 0;
		_color = 	_x # 1;
		_unit  = 	_x # 2;
		_text  = 	_x # 3;

        (_this select 0) drawIcon [
                _iconType,
                _color,
                getPos _unit,
                24,
                24,
                getDir _unit,
                _text,
                1,
                0.03,
                "TahomaB",
                "right"
            ]

	} foreach _iconsToBeDisplayed
};

waitUntil {!isNull findDisplay 12};
findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", WF_C_MAP_MARKER_HANDLER];

//--- res base logic clean up
{ deleteVehicle _x } forEach ([0,0,0] nearEntities [["LocationOutpost_F"], 100000]);

["INITIALIZATION", Format ["fn_initClient.sqf: Client initialization ended at [%1]", time]] Call WFCO_FNC_LogContent;