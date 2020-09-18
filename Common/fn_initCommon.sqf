["INITIALIZATION", Format ["Init_Common.sqf: Common initialization begins at [%1]", time]] Call WFCO_FNC_LogContent;

private ['_count'];

[east] call WFCO_fnc_roleList;
[west] call WFCO_fnc_roleList;

["INITIALIZATION", "fn_initCommon.sqf: Functions are initialized."] Call WFCO_FNC_LogContent;

varQueu = time + random 10000 - random 500 + diag_frameno; //clt, to remove with new sys later on.
varGroupQueu = time + random 10000 - random 500 + diag_frameno; //clt, to remove with new sys later on.
unitMarker = 0;

/* Respawn Markers */
createMarkerLocal ["respawn_east",getMarkerPos "EastTempRespawnMarker"];
if(WF_C_PARAMETER_COLORATION == 1) then {
	"respawn_east" setMarkerColorLocal "ColorEAST";
} else {
	"respawn_east" setMarkerColorLocal "ColorGreen";
};
"respawn_east" setMarkerShapeLocal "RECTANGLE";
"respawn_east" setMarkerBrushLocal "BORDER";
"respawn_east" setMarkerSizeLocal [15,15];
"respawn_east" setMarkerAlphaLocal 0;
createMarkerLocal ["respawn_west",getMarkerPos "WestTempRespawnMarker"];
if(WF_C_PARAMETER_COLORATION == 1) then {
	"respawn_west" setMarkerColorLocal "ColorWEST";
} else {
	"respawn_west" setMarkerColorLocal "ColorGreen";
};
"respawn_west" setMarkerShapeLocal "RECTANGLE";
"respawn_west" setMarkerBrushLocal "BORDER";
"respawn_west" setMarkerSizeLocal [15,15];
"respawn_west" setMarkerAlphaLocal 0;
createMarkerLocal ["respawn_guerrila",getMarkerPos "GuerTempRespawnMarker"];
"respawn_guerrila" setMarkerColorLocal "ColorGUER";
"respawn_guerrila" setMarkerShapeLocal "RECTANGLE";
"respawn_guerrila" setMarkerBrushLocal "BORDER";
"respawn_guerrila" setMarkerSizeLocal [15,15];
"respawn_guerrila" setMarkerAlphaLocal 0;

/* Wait for BIS Module Init */
waitUntil {!(isNil 'BIS_fnc_init')};
waitUntil {BIS_fnc_init};

/* CORE SYSTEM - Start
	Different Core are added depending on the current ArmA Version running, add yours bellow.
*/
/* Model Core */
Call Compile preprocessFileLineNumbers 'Common\Warfare\Config\Core_Models\CombinedOps.sqf';
/* Class Core */
Call Compile preprocessFileLineNumbers 'Common\Warfare\Config\Core\Core_CIV.sqf';
Call Compile preprocessFileLineNumbers 'Common\Warfare\Config\Core\Core_GUE.sqf';
Call Compile preprocessFileLineNumbers 'Common\Warfare\Config\Core\Core_RU.sqf';
Call Compile preprocessFileLineNumbers 'Common\Warfare\Config\Core\Core_US.sqf';

//--- Types.
WF_Logic_Airfield = "Land_Ss_hangard";
WF_Logic_Depot = ["Land_BagBunker_Large_F", "Land_Ss_hangard"];

/* Call in the teams template - Combined Operations */
_team_west = 'US';
_team_east = 'RU';

["INITIALIZATION", "Init_Common.sqf: Core Files are loaded."] Call WFCO_FNC_LogContent;

//--- new system.
_grpWest = (missionNamespace getVariable 'WF_C_UNITS_FACTIONS_WEST') # (missionNamespace getVariable 'WF_C_UNITS_FACTION_WEST');
_grpEast = (missionNamespace getVariable 'WF_C_UNITS_FACTIONS_EAST') # (missionNamespace getVariable 'WF_C_UNITS_FACTION_EAST');
_grpRes = (missionNamespace getVariable 'WF_C_UNITS_FACTIONS_GUER') # (missionNamespace getVariable 'WF_C_UNITS_FACTION_GUER');

["INITIALIZATION", Format["Init_Common.sqf: Using groups - West [%1], East [%2], Resistance [%3].",_grpWest,_grpEast,_grpRes]] Call WFCO_FNC_LogContent;

/* CORE SYSTEM - End */

//--- Determine which logics are defined.
_presents = [];
{
	Private ["_sideIsPresent"];
	_sideIsPresent = (!isNil (_x # 1));
	missionNamespace setVariable [Format["WF_%1_PRESENT", str (_x # 0)], _sideIsPresent];
	if (_sideIsPresent) then {_presents pushBack (_x # 0);};
} forEach [[west,"WF_L_BLU"],[east,"WF_L_OPF"],[resistance,"WF_L_GUE"]];

WF_PRESENTSIDES = _presents;

WF_DEFENDER = resistance;
WF_DEFENDER_ID = (WF_DEFENDER) Call WFCO_FNC_GetSideID;

//--- Import the desired global side variables.
Call Compile preprocessFileLineNumbers Format["Common\Warfare\Config\Core_Root\Root_%1.sqf",_grpRes];
Call Compile preprocessFileLineNumbers Format["Common\Warfare\Config\Core_Root\Root_%1.sqf", _team_west];
Call Compile preprocessFileLineNumbers Format["Common\Warfare\Config\Core_Root\Root_%1.sqf", _team_east];

//--- Import the desired defenses. (todo, Replace the old defense init by this one).
Call Compile preprocessFileLineNumbers Format["Common\Warfare\Config\Defenses\Defenses_%1.sqf",_grpWest];
Call Compile preprocessFileLineNumbers Format["Common\Warfare\Config\Defenses\Defenses_%1.sqf",_grpEast];
Call Compile preprocessFileLineNumbers Format["Common\Warfare\Config\Defenses\Defenses_%1.sqf",_grpRes];

//--- Server Exec.
if (isServer) then {
	//--- Import the desired town groups.
	Call Compile preprocessFileLineNumbers Format["Common\Warfare\Config\Groups\Groups_%1.sqf",_grpWest];
	Call Compile preprocessFileLineNumbers Format["Common\Warfare\Config\Groups\Groups_%1.sqf",_grpEast];
	Call Compile preprocessFileLineNumbers Format["Common\Warfare\Config\Groups\Groups_%1.sqf",_grpRes];
};

//--- Airports Init.
[] spawn WFCO_fnc_initAirports;

["INITIALIZATION", "Init_Common.sqf: Config Files are loaded."] Call WFCO_FNC_LogContent;

//--- Boundaries, use setPos to find the perfect spot on other islands and worldName to determine the island name (editor: diag_log worldName; player setPos [0,5120,0]; ).
Call WFCO_fnc_initBoundaries;
["INITIALIZATION", "Init_Common.sqf: Boundaries are loaded."] Call WFCO_FNC_LogContent;

//--- ICBM.
if ((missionNamespace getVariable "WF_C_MODULE_WF_ICBM") > 0) then {
	WFCO_FNC_Nuke = Compile preprocessFile "Client\Module\Nuke\nuke.sqf";
	WFCO_FNC_NukeIncomming = Compile preprocessFile "Client\Module\Nuke\nukeincoming.sqf";
}; 

//--- Longest vehicles purchase (+ extra processing).
_balancePrice = missionNamespace getVariable "WF_C_UNITS_PRICING";
{
	Private ["_longest","_structure"];
	_structure = _x;

	//--- Get the longest build time per structure.
	_longest = 0;
	{
		_type = missionNamespace getVariable Format ["WF_%1%2UNITS", _x, _structure];
		if !(isNil '_type') then {
			{
				_c = missionNamespace getVariable _x;
				if !(isNil '_c') then {
					if ((_c # QUERYUNITTIME) > _longest) then {_longest = (_c # QUERYUNITTIME);};
					if (_structure in ["LIGHT", "HEAVY"]) then {if (_balancePrice in [1,3]) then {_c set [QUERYUNITPRICE, (_c # QUERYUNITPRICE)*2]}};
					if (_structure in ["AIRCRAFT", "AIRPORT"]) then {if (_balancePrice in [1,2]) then {_c set [QUERYUNITPRICE, (_c # QUERYUNITPRICE)*2]}};
				};
			} forEach _type;
		};
	} forEach WF_PRESENTSIDES;

	missionNamespace setVariable [Format ["WF_LONGEST%1BUILDTIME",_structure], _longest];
} forEach ["BARRACKS","LIGHT","HEAVY","AIRCRAFT","AIRPORT","DEPOT"];

//--- Make a global array of miscelleanous stuff.
_repairs = [];
{
	_repairs = _repairs + (missionNamespace getVariable Format["WF_%1REPAIRTRUCKS", _x]);
} forEach WF_PRESENTSIDES;

missionNamespace setVariable ["WF_REPAIRTRUCKS", _repairs];

//--Advanced Sling Loading
[] Call WFCO_fnc_initAdvancedSlingLoading;

//--- Common initilization is complete at this point.
["INITIALIZATION", Format ["Init_Common.sqf: Common initialization ended at [%1]", time]] Call WFCO_FNC_LogContent;
commonInitComplete = true;