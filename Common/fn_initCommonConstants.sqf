//--- DO NOT CHANGE.
WESTID = 0;
EASTID = 1;
RESISTANCEID = 2;
//--- DO NOT CHANGE.
QUERYUNITLABEL = 0;
QUERYUNITPICTURE = 1;
QUERYUNITPRICE = 2;
QUERYUNITTIME = 3;
QUERYUNITCREW = 4;
QUERYUNITUPGRADE = 5;
QUERYUNITFACTORY = 6;
QUERYUNITSKILL = 7;
QUERYUNITFACTION = 8;
QUERYUNITTURRETS = 9;
//--- DO NOT CHANGE.
QUERYGEARLABEL = 0;
QUERYGEARPICTURE = 1;
QUERYGEARCLASS = 2;
QUERYGEARTYPE = 3;
QUERYGEARCOST = 4;
QUERYGEARUPGRADE = 5;
QUERYGEARALLOWED = 6;
QUERYGEARHANDGUNPOOL = 7;
QUERYGEARMAGAZINES = 8;
QUERYGEARSPACE = 9;
QUERYGEARALLOWTWO = 10;

//--- Side Statics.
WF_C_WEST_ID = 0;
WF_C_EAST_ID = 1;
WF_C_GUER_ID = 2;
WF_C_CIV_ID = 3;
WF_C_UNKNOWN_ID = 4;
WF_C_ENEMY_ID = 5;
WF_C_FRIENDLY_ID = 6;
WF_C_LOGIC_ID = 7;
WF_C_EMPTY_ID = 8;
WF_C_AMBIENT_ID = 9;

//--- Role names
WF_SNIPER         = "Sniper";
WF_SOLDIER        = "Soldier";
WF_ENGINEER       = "Engineer";
WF_SPECOPS        = "SpecOps";
WF_MEDIC          = "Medic";
WF_SUPPORT        = "Support";

//--- Common Upgrades, each number match the upgrades arrays.
WF_UP_BARRACKS = 0;
WF_UP_LIGHT = 1;
WF_UP_HEAVY = 2;
WF_UP_AIR = 3;
WF_UP_PARATROOPERS = 4;
WF_UP_UAV = 5;
WF_UP_SUPPLYRATE = 6;
WF_UP_RESPAWNRANGE = 7;
WF_UP_ARTYTIMEOUT = 8;
WF_UP_CRUISE_MISSILE = 9;
WF_UP_GEAR = 10;
WF_UP_AMMOCOIN = 11;
WF_UP_EASA = 12;
WF_UP_AAR1 = 13;
WF_UP_SUPPLYPARADROP = 14;
WF_UP_ARTYAMMO = 15;
WF_UP_HEAVY_MAGZ = 16;
WF_UP_HC_GROUP_AMOUNT = 17;
WF_UP_REMOTE_CONTROL = 18;

/*
	### Working with the missionNamespace ###
	 * The With command allows us to swap the Global variable Namespace.
	 * It prevents the typical long variable declaration (missionNamespace setVariable...).

	In the declaration below, the parameters are first (they are checked with the isNil command).
	The isNil check prevent us from overriding MP parameters.
*/
with missionNamespace do {
//---- Admins UID
	WF_RESERVEDUIDS = ["76561198058092022","76561198086269246"]; //Admin UIDS

//--- AI.
	if (isNil "WF_C_AI_COMMANDER_ENABLED") then {WF_C_AI_COMMANDER_ENABLED = 1;}; //--- Enable or disable the AI Commanders.
	WF_C_AI_COMMANDER_MOVE_INTERVALS = 3600;
	WF_C_AI_DELEGATION_FPS_INTERVAL = 60 * 3; //--- A client send it's FPS average each x seconds to the server.
	WF_C_AI_DELEGATION_FPS_MIN = 25; //--- A client can handle groups if it's FPS average is above x.
	WF_C_AI_DELEGATION_GROUPS_MAX = 1; //--- A client max have up to x groups managed on his computer (high values may makes lag, be careful).
	WF_C_AI_PATROL_RANGE = 400;
	WF_C_AI_TOWN_ATTACK_HOPS_WP = 4; //--- AI may use up to x WP to attack a town.
	
//--- High Command module
    WF_C_HIGH_COMMAND_MAX_GROUP_AMOUNT = 10;
    WF_C_HIGH_COMMAND_MIN_GROUP_AMOUNT = 4;
    WF_C_HIGH_COMMAND_MAX_QUEUE_ORDER_GROUP_PURCHASE = 3;

//--- Artillery.
	if (isNil "WF_C_ARTILLERY") then {WF_C_ARTILLERY = 1;}; //--- Enable or disable Artillery fire missions (0: Disabled, 1: Short, 2: Medium, 3: Long).
	WF_C_ARTILLERY_AMMO_RANGE_LASER = 175; //--- Artillery laser rounds detection range (Per Shell).
	WF_C_ARTILLERY_AMMO_RANGE_SADARM = 200; //--- Artillery SADARM rounds operative range (Per Shell).
	WF_C_ARTILLERY_AREA_MAX = 300; //---  Maximum spread area of artillery support.
	WF_C_ARTILLERY_INTERVALS = [800, 700, 600, 500]; //--- Delay between each fire mission for each upgrades.
	if (isNil "WF_C_ARTILLERY") then {WF_C_ARTILLERY = 2;};

	//--- Base
	if (isNil "WF_C_BASE_AREA") then {WF_C_BASE_AREA = 2;}; //--- Force the bases to be grouped by areas.
	if (WF_Debug) then { WF_C_BASE_AREA = 99; };
	if (isNil "WF_C_BASE_RES") then {WF_C_BASE_RES = 0;}; //--- RES Parameters (0 Disabled, 1 West, 2 East, 3 both).
	if (isNil "WF_C_BASE_DEFENSE_MAX") then {WF_C_BASE_DEFENSE_MAX = 20;}; //--- Maximum AIs that will be able to man defense within the barracks area.
	if (isNil "WF_C_BASE_DEFENSE_MANNING_RANGE") then {WF_C_BASE_DEFENSE_MANNING_RANGE = 250;}; //--- Within x meters, defenses may be manned.
	WF_C_BASE_DEFENSE_MANNING_RANGE_EXT = 50;
	WF_C_BASE_DEFENSE_MANNING_TIMEOUT = 420; //-- A time for recreate unit for static weapon on the base defense.
	if (isNil "WF_C_BASE_PATROLS_INFANTRY") then {WF_C_BASE_PATROLS_INFANTRY = 1;}; //--- Enable AI Squad patrol in base from Barracks.
	if (isNil "WF_C_BASE_START_TOWN") then {WF_C_BASE_START_TOWN = 1;}; //--- Remove the spawn locations which are too far away from the towns.
	if (isNil "WF_C_BASE_STARTING_DISTANCE") then {WF_C_BASE_STARTING_DISTANCE = 7500;}; //--- Sides need at last xkm of distance between them.
	if (isNil "WF_C_BASE_STARTING_MODE") then {WF_C_BASE_STARTING_MODE = 2;}; //--- Starting Locations Mode: 0 = WN|ES; 1 = WS|EN; 2 = Random;
	WF_C_BASE_AREA_RANGE = 250; //--- A base area has a range of x meters.
	WF_C_BASE_HQ_BUILD_RANGE = 120; //--- HQ Build range.
	WF_C_BASE_AV_FORTIFICATIONS = 30; //--- Base available fotifications.
	WF_C_BASE_PROTECTION_RANGE = 800;  //--- Base protection range.
	WF_C_BASE_HQ_REPAIR_PRICE = 25000; //--- HQ Repair price.
    WF_C_BASE_HQ_REPAIR_PRICE_CASH = 250000; //--- HQ Repair price with cash.
	
//--- Camps.
	WF_C_CAMPS_CAPTURE_BOUNTY = 500; //--- Bounty received by player whenever he capture a camp.
	WF_C_CAMPS_CAPTURE_RATE = 20;
	WF_C_CAMPS_CAPTURE_RATE_MAX = 25;
	WF_C_CAMPS_RANGE = 15;
	WF_C_CAMPS_RANGE_PLAYERS = 10;
	WF_C_CAMPS_REPAIR_DELAY = 20;
	WF_C_CAMPS_REPAIR_PRICE = 500;
	WF_C_CAMPS_REPAIR_RANGE = 15;

//--- Economy.
	if (isNil "WF_C_ECONOMY_FUNDS_START_WEST") then {WF_C_ECONOMY_FUNDS_START_WEST = if (WF_Debug) then {900000} else {800};};
	if (isNil "WF_C_ECONOMY_FUNDS_START_EAST") then {WF_C_ECONOMY_FUNDS_START_EAST = if (WF_Debug) then {900000} else {800};};
	if (isNil "WF_C_ECONOMY_FUNDS_START_GUER") then {WF_C_ECONOMY_FUNDS_START_GUER = if (WF_Debug) then {900000} else {800};};
	if (isNil "WF_C_ECONOMY_INCOME_INTERVAL") then {WF_C_ECONOMY_INCOME_INTERVAL = 60;}; //--- Income Interval (Delay between each paycheck).
	if (isNil "WF_C_ECONOMY_SUPPLY_START_WEST") then {WF_C_ECONOMY_SUPPLY_START_WEST = if (WF_Debug) then {900000} else {1200};};
	if (isNil "WF_C_ECONOMY_SUPPLY_START_EAST") then {WF_C_ECONOMY_SUPPLY_START_EAST = if (WF_Debug) then {900000} else {1200};};
	if (isNil "WF_C_ECONOMY_SUPPLY_START_GUER") then {WF_C_ECONOMY_SUPPLY_START_GUER = if (WF_Debug) then {900000} else {1200};};
	if (isNil "WF_C_MAX_ECONOMY_SUPPLY_LIMIT") then {WF_C_MAX_ECONOMY_SUPPLY_LIMIT = 60000;};
	if (isNil "WF_C_ECONOMY_SUPPLY_SYSTEM") then {WF_C_ECONOMY_SUPPLY_SYSTEM = 1;}; //--- Supply System (0: Trucks, 1: Automatic with time).
	if (isNil "WF_C_ECONOMY_INCOME_COEF") then {WF_C_ECONOMY_INCOME_COEF = 55;}; //--- Town Multiplicator Coefficient (SV * x).
	WF_C_ECONOMY_INCOME_COEF = WF_C_ECONOMY_INCOME_COEF / 10; //--Trick for Parameters.hpp, it can not store float numbers (55 == 5.5)--
	
	WF_C_ECONOMY_INCOME_DIVIDED = 2; //--- Prevent commander from being a millionaire, and add the rest to the players pool.
	WF_C_ECONOMY_INCOME_PERCENT_MAX = 100; //--- Commander may set income up to x%.
	WF_C_ECONOMY_SUPPLY_TIME_INCREASE_DELAY = 60; //--- Increase SV delay.
	WF_C_ECONOMY_SUPPLY_TRUCK_TIME_CHECK_DELAY = 2400; //--- supply truck alive status check.
	WF_C_ECONOMY_SUPPLY_MAX_TEAM_LIMIT = 50000;
	WF_C_ECONOMY_HQ_PENALTY_INCREASE_STEP = 5000;

//--- Environment.	
	if (isNil "WF_C_OBJECT_MAX_VIEW") then {WF_C_OBJECT_MAX_VIEW = 5000;}; //--- Max object distance.
	if (isNil "WF_C_ENVIRONMENT_MAX_VIEW") then {WF_C_ENVIRONMENT_MAX_VIEW = 5000;}; //--- Max view distance.
	if (isNil "WF_C_ENVIRONMENT_MAX_CLUTTER") then {WF_C_ENVIRONMENT_MAX_CLUTTER = 50;}; //--- Max Terrain grid.
	if (isNil "WF_C_ENVIRONMENT_STARTING_HOUR") then {WF_C_ENVIRONMENT_STARTING_HOUR = 9;}; //--- Starting Hour of the day.
	if (isNil "WF_C_ENVIRONMENT_STARTING_MONTH") then {WF_C_ENVIRONMENT_STARTING_MONTH = 6;}; //--- Starting Month of the year.
	if (isNil "WF_C_ENVIRONMENT_WEATHER_SNOWSTORM") then {WF_C_ENVIRONMENT_WEATHER_SNOWSTORM = 0;}; //--- snow storms
	if (isNil "WF_C_ENVIRONMENT_WEATHER_OVERCAST") then {WF_C_ENVIRONMENT_WEATHER_OVERCAST = 30;}; //--- weather conditions
	if (isNil "WF_C_ENVIRONMENT_WEATHER_FOG") then {WF_C_ENVIRONMENT_WEATHER_FOG = 0;}; //--- fog conditions
	if (isNil "WF_C_ENVIRONMENT_WEATHER_WIND") then {WF_C_ENVIRONMENT_WEATHER_WIND = 30;}; //--- wind conditions
	if (isNil "WF_C_ENVIRONMENT_WEATHER_WAVES") then {WF_C_ENVIRONMENT_WEATHER_WAVES = 0;}; //--- waves on sea conditions
	if (isNil "WF_C_ENVIRONMENT_DAY_FAST_TIME") then {WF_C_ENVIRONMENT_DAY_FAST_TIME = 15;};
	if (isNil "WF_C_ENVIRONMENT_NIGHT_FAST_TIME") then {WF_C_ENVIRONMENT_NIGHT_FAST_TIME = 60;};
	WF_C_ENVIRONMENT_WEATHER_TRANSITION = 1800; //--- Weather Transition period, change weather overcast each x seconds (longer is more realistic).

//--- Gameplay.
	if (isNil "WF_C_PARAMETER_COLORATION") then {WF_C_PARAMETER_COLORATION = 1;}; //--- Map Coloration.
	if (isNil "WF_C_GAMEPLAY_BOUNDARIES_ENABLED") then {WF_C_GAMEPLAY_BOUNDARIES_ENABLED = 1;}; //--- Enable the map boundaries if defined.
	if (isNil "WF_C_GAMEPLAY_FATIGUE_ENABLED") then {WF_C_GAMEPLAY_FATIGUE_ENABLED = 0;}; //--- Disable the fatigue system for default.
	if (isNil "WF_C_GAMEPLAY_UPGRADES_CLEARANCE") then {WF_C_GAMEPLAY_UPGRADES_CLEARANCE = 0;}; //--- Upgrade clearance (on start), 0: Disabled, 1: West, 2: East, 3: Res, 4: West + East, 5: West + Res, 6: East + Res, 7: All.
	if (isNil "WF_C_GAMEPLAY_VICTORY_CONDITION") then {WF_C_GAMEPLAY_VICTORY_CONDITION = 2;}; //--- Victory Condition (0: Annihilation, 1: Assassination, 2: Supremacy, 3: Towns).
	if (isNil "WF_C_GAMEPLAY_MISSILES_RANGE") then {WF_C_GAMEPLAY_MISSILES_RANGE = 3500;}; //--- missile range limit
	if (isNil "WF_C_GAMEPLAY_TEAMSTACKING_CHECK") then {WF_C_GAMEPLAY_TEAMSTACKING_CHECK = 1;}; //-- Teamstacking check enabled
	if (isNil "WF_C_GAMEPLAY_THIRDVIEW") then {WF_C_GAMEPLAY_THIRDVIEW = 1;}; //-- Enable thirdview on feet
	WF_C_GAMEPLAY_VOTE_TIME = if (WF_Debug) then {4} else {40};
	if (isNil "WF_DEBUG_DISABLE_TOWN_INIT") then {WF_DEBUG_DISABLE_TOWN_INIT = 0;};
	missionNamespace setVariable ["WF_C_GAMEPLAY_FAST_TRAVEL_RANGE", 175];
        missionNamespace setVariable ["WF_C_GAMEPLAY_FAST_TRAVEL_PRICE_KM", 215];
    missionNamespace setVariable ["WF_C_GAMEPLAY_FAST_TRAVEL_TIME_COEF", 0.4];
    WF_C_GAMEPLAY_DARTER_CONNECT_DISTANCE_LIMITATION = 500;

//--- Modules.
	if (isNil "WF_C_MODULE_WF_EASA") then {WF_C_MODULE_WF_EASA = 1;}; //--- Enable the Exchangeable Armament System for Aircraft.
	if (isNil "WF_C_MODULE_WF_CRUISE_MISSILE") then {WF_C_MODULE_WF_CRUISE_MISSILE = 1;}; //--- Enable the Intercontinental Ballistic Missile call for the commander.
	WF_C_MINIMAL_PARATROPPER_GROUP_SIZE = 4; //--- minimal group size of troopers to be sent on battlefield

//--- Players.
	if (isNil "WF_C_PLAYERS_AI_MAX") then {WF_C_PLAYERS_AI_MAX = 10;}; //--- Max AI allowed on each player groups.
	WF_C_PLAYERS_BOUNTY_CAPTURE = 2000;
	WF_C_PLAYERS_BOUNTY_CAPTURE_ASSIST = 2000;
	WF_C_PLAYERS_BOUNTY_CAPTURE_MISSION = 2000;
	WF_C_PLAYERS_BOUNTY_CAPTURE_MISSION_ASSIST = 2000;
	WF_C_PLAYERS_COMMANDER_BOUNTY_CAPTURE_COEF = 60;
	WF_C_PLAYERS_COMMANDER_SCORE_BUILD = 2;
	WF_C_PLAYERS_COMMANDER_SCORE_CAPTURE = 5;
	WF_C_PLAYERS_COMMANDER_SCORE_UPGRADE = 2;
	WF_C_PLAYERS_GEAR_SELL_COEF = 0.6; //--- Sell price of the gear: item price * x (800 * 0.2 = 400)
	WF_C_PLAYERS_GEAR_TEMPLATES_COUNT = 10; //--A count limit of gear templates for a role--
	WF_C_PLAYERS_GEAR_VEHICLE_RANGE = 50; //--- Possible to buy gear in vehicle if that one is within that range.
	WF_C_PLAYERS_HALO_HEIGHT = 200; //--- Distance above which units are able to perform an HALO jump.
	WF_C_PLAYERS_MARKER_DEAD_DELAY = 60; //--- Time that a marker remain on a dead unit.
	WF_C_PLAYERS_MARKER_TOWN_RANGE = 0.05; //--- A town marker is updated (SV) on map if a unit is within the range (town range * coef).
	WF_C_PLAYERS_OFFMAP_TIMEOUT = 50; //--- Player may remain x second outside of the map before being killed.
	WF_C_PLAYERS_PENALTY_TEAMKILL = 1000; //--- Teamkill penalty.
	WF_C_PLAYERS_SCORE_CAPTURE = 10;
	WF_C_PLAYERS_SCORE_CAPTURE_ASSIST = 5;
	WF_C_PLAYERS_SCORE_CAPTURE_CAMP = 2;
	WF_C_PLAYERS_SCORE_DELIVERY = 3;
	WF_C_PLAYERS_SKILL_SOLDIER_UNITS_MAX = 6; //--- Skill (Soldiers), have more units than the others.
	WF_C_PLAYERS_SQUADS_MAX_PLAYERS = 4; //--- One player squad may contain up to x players.
	WF_C_PLAYERS_SQUADS_REQUEST_TIMEOUT = 100; //--- Time delay after which an unanswered request "fades".
	WF_C_PLAYERS_SQUADS_REQUEST_DELAY = 120; //--- Time delay between each potential squad hops.
	WF_C_PLAYERS_SUPPORT_PARATROOPERS_DELAY = 1200; //--- Paratroopers Call Interval.
	WF_C_PLAYERS_UAV_SPOTTING_DELAY = 20; //--- Interval between each uav spotting routine.
	WF_C_PLAYERS_UAV_SPOTTING_DETECTION = 0.21; //--- UAV will reveal each targets that it knows about this value (0-4)
	WF_C_PLAYERS_UAV_SPOTTING_RANGE = 1100; //--- Max Range of the UAV spotting.

//--- Respawn.
	if (isNil "WF_C_RESPAWN_CAMPS_MODE") then {WF_C_RESPAWN_CAMPS_MODE = 2;}; //--- Respawn Camps (0: Disabled, 1: Classic [from town center], 2: Enhanced [from nearby camps]).
	if (isNil "WF_C_RESPAWN_CAMPS_RANGE") then {WF_C_RESPAWN_CAMPS_RANGE = 550;}; //--- How far a player need to be from a town to spawn at camps.
	if (isNil "WF_C_RESPAWN_CAMPS_RULE_MODE") then {WF_C_RESPAWN_CAMPS_RULE_MODE = 2;}; //--- Respawn Camps Rule (0: Disabled, 1: West | East, 2: West | East | Resistance).
	if (isNil "WF_C_RESPAWN_DELAY") then {WF_C_RESPAWN_DELAY = 10;}; //--- Respawn Delay (Players/AI).
	if (WF_Debug) then {WF_C_RESPAWN_DELAY = 1;};
	if (isNil "WF_C_RESPAWN_MOBILE") then {WF_C_RESPAWN_MOBILE = 2;}; //--- Allow mobile respawn (0: Disabled, 1: Enabled, 2: Enabled but default gear).
	if (isNil "WF_C_RESPAWN_PENALTY") then {WF_C_RESPAWN_PENALTY = 4;}; //--- Respawn Penalty (0: None, 1: Remove All, 2: Pay full gear price, 3: Pay 1/2 gear price, 4: pay 1/4 gear price, 5: Charge on Mobile).
	WF_C_RESPAWN_CAMPS_SAFE_RADIUS = 50;
	WF_C_RESPAWN_RANGE_LEADER = 50;
	WF_C_RESPAWN_RANGES = [250, 350, 500];

//--- Structures.
	if (isNil "WF_C_STRUCTURES_COLLIDING") then {WF_C_STRUCTURES_COLLIDING = 1;};
	if (isNil "WF_C_STRUCTURES_CONSTRUCTION_MODE") then {WF_C_STRUCTURES_CONSTRUCTION_MODE = 0;}; //--- Structures construction mode (0: Time).
	if (isNil "WF_C_STRUCTURES_HQ_COST_DEPLOY") then {WF_C_STRUCTURES_HQ_COST_DEPLOY = 100;}; //--- HQ Deploy / Mobilize Price.
	if (isNil "WF_C_STRUCTURES_HQ_RANGE_DEPLOYED") then {WF_C_STRUCTURES_HQ_RANGE_DEPLOYED = 200;}; //--- HQ Deploy / Mobilize Price.
	if (isNil "WF_C_STRUCTURES_MAX") then {WF_C_STRUCTURES_MAX = 3;};
	if (WF_Debug) then { WF_C_STRUCTURES_MAX = 99; };
	WF_C_STRUCTURES_ANTIAIRRADAR_DETECTION = 100;
	WF_C_STRUCTURES_ANTIARTYRADAR_DETECTION = 5500;
	WF_C_STRUCTURES_BUILDING_DEGRADATION = 1; //--- Degredation of the building in time during a repair phase (over 100).
	WF_C_STRUCTURES_COMMANDCENTER_RANGE = 5500; //--- Command Center Range.
	WF_C_STRUCTURES_DAMAGES_REDUCTION = 4; //--- Building Damage Reduction (Current damage given / x, 1 = normal).
	WF_C_STRUCTURES_RUINS = "Land_Mil_Barracks_i_ruins_EP1"; //--- Ruins model.
	WF_C_STRUCTURES_SALE_DELAY = 50; //--- Building is sold after x seconds.
	if (WF_Debug) then { WF_C_STRUCTURES_SALE_DELAY = 3; };
	WF_C_STRUCTURES_SALE_PERCENT = 50; //--- When a structure is sold, x% of supply goes back to the side.
	WF_C_STRUCTURES_SERVICE_POINT_RANGE = 50;
	WF_C_BASE_COIN_DISTANCE_MIN = 100;
	WF_C_BASE_COIN_GRADIENT_MAX = 4;
	WF_DELETE_RUINS_LAT = 180; //--Latancy for delte ruins (after base building destroyed)--

//--- Towns.
	if (isNil "WF_C_TOWNS_AMOUNT") then {WF_C_TOWNS_AMOUNT = 7;}; //--- Amount of towns (0: Very small, 1: Small, 2: Medium, 3: Large, 4: Full).
	if (isNil "WF_C_TOWNS_BUILD_PROTECTION_RANGE") then {WF_C_TOWNS_BUILD_PROTECTION_RANGE = 450;}; //--- Prevent construction in towns within that radius.
	if (isNil "WF_C_TOWNS_AI_SPAWN_RANGE") then {WF_C_TOWNS_AI_SPAWN_RANGE = 1000;};
	if (isNil "WF_C_TOWNS_CAPTURE_MODE") then {WF_C_TOWNS_CAPTURE_MODE = 2;}; //--- Town capture mode (0: Normal, 1: Threshold, 2: All Camps).
	if (isNil "WF_C_TOWNS_DEFENDER") then {WF_C_TOWNS_DEFENDER = 2;}; //--- Town defender Difficulty (0: Disabled, 1: Light, 2: Medium, 3: Hard, 4: Insane).
	if (isNil "WF_C_TOWNS_DEFENDER_AIM_SKILL") then {WF_C_TOWNS_DEFENDER_AIM_SKILL = 2;}; //--A aiming skill of town defender units from 1 to 10--
	if (isNil "WF_C_TOWNS_OCCUPATION") then {WF_C_TOWNS_OCCUPATION = 2;}; //--- Town occupation Difficulty (0: Disabled, 1: Light, 2: Medium, 3: Hard, 4: Insane).
	if (isNil "WF_C_TOWNS_GEAR") then {WF_C_TOWNS_GEAR = 1;}; //--- Buy Gear From (0: None, 1: Camps, 2: Depot, 3: Camps & Depot).
	if (isNil "WF_C_TOWNS_REINFORCEMENT_DEFENDER") then {WF_C_TOWNS_REINFORCEMENT_DEFENDER = 0;}; //--- Enable towns defender reinforcement.
	if (isNil "WF_C_TOWNS_REINFORCEMENT_OCCUPATION") then {WF_C_TOWNS_REINFORCEMENT_OCCUPATION = 0;}; //--- Enable towns occupation reinforcement.
	if (isNil "WF_C_TOWNS_STARTING_MODE") then {WF_C_TOWNS_STARTING_MODE = 0;}; //--- Town starting mode (0: Resistance, 1: 50% blu, 50% red, 2: Nearby Towns, 3: Random).
	if (isNil "WF_C_TOWNS_VEHICLES_LOCK_DEFENDER") then {WF_C_TOWNS_VEHICLES_LOCK_DEFENDER = 1;}; //--- Lock the vehicles of the defender side.
	WF_C_TOWNS_CAPTURE_ASSIST = 400;
	WF_C_TOWNS_CAPTURE_RANGE = 40;
	WF_C_TOWNS_CAPTURE_RATE = 0.4;
	WF_C_TOWNS_CAPTURE_THRESHOLD_RANGE = 140;
	WF_C_TOWNS_DEFENSE_RANGE = 30;
	WF_C_TOWNS_DETECTION_RANGE_ACTIVE_COEF = 1; //--- Town activation range once active (town range * coef)
	WF_C_TOWNS_DETECTION_RANGE_COEF = 1; //--- Town activation range while idling (town range * coef)
	WF_C_TOWNS_DETECTION_RANGE_AIR = 50; //--- Detect Air if > x
	WF_C_TOWNS_PATROL_HOPS = 5; //--- Amount of Waypoints given to the AI Patrol in towns (Higher is wider).
	WF_C_TOWNS_PATROL_RANGE = 250;
	WF_C_TOWNS_PURCHASE_RANGE = 60;
	WF_C_TOWNS_SUPPLY_LEVELS_TIME = [1, 2, 3, 4, 5];
	WF_C_TOWNS_UNITS_INACTIVE = 120; //--- Remove units in town if no enemies are to be found within that time.
	WF_C_TOWNS_BACKCAPTURING_TIMEOUT = 300; //--A time for which lose side can to take back a town--
	WF_C_TOWNS_UNITS_SPAWN_CAPTURE_DELAY = 1200; //--- If x seconds has elapsed since a town last capture, units may spawn again during that town capture.
	WF_C_TOWNS_UNITS_WAYPOINTS = 9;
	WF_C_TOWNS_SERVICE_FUEL = "fuelStation";
	WF_C_TOWNS_SERVICE_REPAIRING = "repairStation";
	WF_C_TOWNS_SERVICE_REARM = "rearmStation";
	WF_C_TOWNS_SERVICE_HEAL = "healStation";

//--- Units.
	if (isNil "WF_C_UNITS_BALANCING") then {WF_C_UNITS_BALANCING = 1;}; //--- Enable Units weaponry balancing.
	if (isNil "WF_C_UNITS_CLEAN_TIMEOUT") then {WF_C_UNITS_CLEAN_TIMEOUT = 120;}; //--- Lifespan of a dead body.
	if (isNil "WF_C_UNITS_EMPTY_TIMEOUT") then {WF_C_UNITS_EMPTY_TIMEOUT = 1200;}; //--- Lifespan of an empty vehicle.
	if (isNil "WF_C_UNITS_KAMOV_DISABLED") then {WF_C_UNITS_KAMOV_DISABLED = 0;}; //--- Enable Kamov.
	if (isNil "WF_C_UNITS_PRICING") then {WF_C_UNITS_PRICING = 0;}; //--- Price Focus. (0: Default, 1: Infantry, 2: Tanks, 3: Air).
	if (isNil "WF_C_UNITS_TOWN_PURCHASE") then {WF_C_UNITS_TOWN_PURCHASE = 1;}; //--- Allow AIs to be bought from depots.
	if (isNil "WF_C_UNITS_TRACK_INFANTRY") then {WF_C_UNITS_TRACK_INFANTRY = 1;}; //--- Track units on map (infantry).
	if (isNil "WF_C_UNITS_TRACK_LEADERS") then {WF_C_UNITS_TRACK_LEADERS = 1;}; //--- Track playable Team Leaders on map (infantry).
	WF_C_UNITS_BOUNTY_COEF = 1; //--- Bounty is the unit price * coef.
	WF_C_UNITS_BOUNTY_ASSISTANCE_COEF = 0.5; //--- Bounty assistance is the unit price * coef * assist coef.
	WF_C_UNITS_COUNTERMEASURE_PLANES = 64;
	WF_C_UNITS_COUNTERMEASURE_CHOPPERS = 32;
	WF_C_UNITS_CREW_COST = 120;
	WF_C_UNITS_PURCHASE_RANGE = 150;
	WF_C_UNITS_PURCHASE_GEAR_RANGE = 150;
	WF_C_UNITS_PURCHASE_GEAR_MOBILE_RANGE = 5;
	WF_C_UNITS_PURCHASE_GEAR_MOBILE_AI_RANGE = 45;
	WF_C_UNITS_PURCHASE_HANGAR_RANGE = 50;
	WF_C_UNITS_REPAIR_TRUCK_RANGE = 40;
	WF_C_UNITS_SALVAGER_SCAVENGE_RANGE = 60;
	WF_C_UNITS_SALVAGER_SCAVENGE_RATIO = 60; //--- Salvager Sell %.
	WF_C_UNITS_SKILL_DEFAULT = .7;
	WF_C_UNITS_SUPPORT_RANGE = 70; //--- Action range for repair/rearm/refuel.
	WF_C_UNITS_SUPPORT_HEAL_PRICE = 125;
	WF_C_UNITS_SUPPORT_HEAL_TIME = 10;
	WF_C_UNITS_SUPPORT_REARM_PRICE = 14;
	WF_C_UNITS_SUPPORT_REARM_TIME = 20;
	WF_C_UNITS_SUPPORT_REFUEL_PRICE = 16;
	WF_C_UNITS_SUPPORT_REFUEL_TIME = 10;
	WF_C_UNITS_SUPPORT_REPAIR_PRICE = 2;
	WF_C_UNITS_SUPPORT_REPAIR_TIME = 20;

	#include "specialConstants.sqf";

	WFDC_SMILES = [
			//--FOR KILLER--
			[":jack_o_lantern:", ":smiling_imp:", ":laughing:", ":japanese_ogre:", ":shark:", ":japanese_ogre:"],
			//--FOR KILLED--
			[":sob:", ":weary:", ":tired_face:", ":persevere:", ":skull:", ":rage:"]
		];

	//--- Units Factions.
	if (isNil "WF_C_UNITS_FACTION_EAST") then {WF_C_UNITS_FACTION_EAST = 0;}; //--- East Faction.
	if (isNil "WF_C_UNITS_FACTION_GUER") then {WF_C_UNITS_FACTION_GUER = 0;}; //--- Guerilla Faction.
	if (isNil "WF_C_UNITS_FACTION_WEST") then {WF_C_UNITS_FACTION_WEST = 0;}; //--- West Faction.
	WF_C_UNITS_FACTIONS_EAST = ['RU']; //--- East Factions.
	WF_C_UNITS_FACTIONS_GUER = ['GUE']; //--- Guerilla Factions.
	WF_C_UNITS_FACTIONS_WEST = ['US']; //--- West Factions.

//--- Overall mission coloration.
if(WF_C_PARAMETER_COLORATION == 1) then {
	missionNamespace setVariable ["WF_C_WEST_COLOR", "ColorWEST"];
	missionNamespace setVariable ["WF_C_EAST_COLOR", "ColorEAST"];
	missionNamespace setVariable ["WF_C_GUER_COLOR", "ColorGUER"];
	missionNamespace setVariable ["WF_C_CIV_COLOR", "ColorYellow"];
	missionNamespace setVariable ["WF_C_UNKNOWN_COLOR", "Color2_FD_F"];
} else {
	if (side player == west) then {
	missionNamespace setVariable ["WF_C_WEST_COLOR", "ColorGreen"];
	missionNamespace setVariable ["WF_C_EAST_COLOR", "ColorRed"];
	missionNamespace setVariable ["WF_C_GUER_COLOR", "ColorBlue"];
	missionNamespace setVariable ["WF_C_CIV_COLOR", "ColorYellow"];
	missionNamespace setVariable ["WF_C_UNKNOWN_COLOR", "ColorBlue"];
	} else {
		missionNamespace setVariable ["WF_C_WEST_COLOR", "ColorRed"];
		missionNamespace setVariable ["WF_C_EAST_COLOR", "ColorGreen"];
		missionNamespace setVariable ["WF_C_GUER_COLOR", "ColorBlue"];
		missionNamespace setVariable ["WF_C_CIV_COLOR", "ColorYellow"];
		missionNamespace setVariable ["WF_C_UNKNOWN_COLOR", "ColorBlue"];
	};
};

WF_C_TITLETEXT_COLOR = "#c8c832";
WF_C_TITLETEXT_COLOR_INT = [0.78, 0.78, 0.2, 1];
switch(side player) do {
    case WEST: {
        WF_C_TITLETEXT_COLOR = "#00a2e8";
        WF_C_TITLETEXT_COLOR_INT = [0, 0.64, 0.91, 1];
    };

    case EAST: {
        WF_C_TITLETEXT_COLOR = "#c83232";
        WF_C_TITLETEXT_COLOR_INT = [0.78, 0.2, 0.2, 1];
    };
};

	/* Special Variables, Those are used after the typical declaration above. */

//--- Build area (Radius/Height).
	WF_C_BASE_COIN_AREA_HQ_DEPLOYED = [WF_C_STRUCTURES_HQ_RANGE_DEPLOYED, 25];
	WF_C_BASE_COIN_AREA_HQ_UNDEPLOYED = [WF_C_STRUCTURES_HQ_RANGE_DEPLOYED / 2, 25];
	WF_C_BASE_COIN_AREA_REPAIR = [45, 10];

//--- Max structures.
	if (isNil 'WF_C_STRUCTURES_MAX_BARRACKS') then {WF_C_STRUCTURES_MAX_BARRACKS = WF_C_STRUCTURES_MAX;};
	if (isNil 'WF_C_STRUCTURES_MAX_LIGHT') then {WF_C_STRUCTURES_MAX_LIGHT = WF_C_STRUCTURES_MAX;};
	if (isNil 'WF_C_STRUCTURES_MAX_COMMANDCENTER') then {WF_C_STRUCTURES_MAX_COMMANDCENTER = WF_C_STRUCTURES_MAX;};
	if (isNil 'WF_C_STRUCTURES_MAX_HEAVY') then {WF_C_STRUCTURES_MAX_HEAVY = WF_C_STRUCTURES_MAX;};
	if (isNil 'WF_C_STRUCTURES_MAX_AIRCRAFT') then {WF_C_STRUCTURES_MAX_AIRCRAFT = WF_C_STRUCTURES_MAX;};
	if (isNil 'WF_C_STRUCTURES_MAX_SERVICEPOINT') then {WF_C_STRUCTURES_MAX_SERVICEPOINT = WF_C_STRUCTURES_MAX * 2;};
	if (isNil 'WF_C_STRUCTURES_MAX_TENTS') then {WF_C_STRUCTURES_MAX_TENTS = 3;};

//--- Apply a towns unit coeficient.
	WF_C_TOWNS_UNITS_COEF = switch (WF_C_TOWNS_OCCUPATION) do {case 0: {0}; case 1: {1}; case 2: {1}; case 3: {2}; case 4: {2}; default {1}};
	WF_C_TOWNS_UNITS_DEFENDER_COEF = switch (WF_C_TOWNS_DEFENDER) do {case 0: {0}; case 1: {1}; case 2: {1.5}; case 3: {2}; case 4: {2.5}; default {1}};
	WF_C_TOWNS_ALL_SIDES = [west, east, resistance, sideEnemy];

    //----
    WF_C_WAREHOUSE = "warehouse";           // +10k to max suppluy
    WF_C_RADAR = "radar";                   // command center feature available
    WF_C_MILITARY_BASE = "militaryBase";    // 5% discount on unit purchase
    WF_C_AIR_BASE = "airBase";              // 5% discount on unit purchase
    WF_C_PLANT = "plant";                   // pure supply income
    WF_C_POWER_PLANT = "powerPlant";        // pure supply income
    WF_C_LUMBER_MILL = "lumberMill";        // pure supply income
    WF_C_MINE = "mine";                     // one time supply truck spawn
    WF_C_PORT = "port";                     // periodic supply truck spawn

    WF_C_SECONDARY_SUPPLY_LOCATIONS = [WF_C_PLANT, WF_C_POWER_PLANT, WF_C_LUMBER_MILL];

    WF_C_MILITARY_BASE_DISCOUNT_PERCENT = 0.05;
    WF_C_BASE_CONSTRUCTION_DISCOUNT_PERCENT = 0.25;

//--- Chemical protection
WF_C_CHEMICAL_DAMAGE_RADIUS = 500;
WF_C_GAS_MASKS = ['g_regulatormask_f','g_airpurifyingrespirator_02_olive_f','g_airpurifyingrespirator_02_sand_f','g_airpurifyingrespirator_02_black_f','g_airpurifyingrespirator_01_f'];

};

["INITIALIZATION", "Init_CommonConstants.sqf: Constants are defined."] Call WFCO_FNC_LogContent;