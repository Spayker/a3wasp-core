#include "..\functions.h"

/*
	Author: [SA] Duda

	Description:
	Initializes Command Menu Actions

	Parameter(s):
	None
		
	Returns: 
	Nothing
*/

AIC_fnc_addWaypointsActionHandler = {
	params ["_menuParams","_actionParams"];
	_menuParams params ["_groupControlId"];
	private ["_group"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	AIC_fnc_setGroupControlAddingWaypoints(_groupControlId,true);
};

["GROUP",localize "STR_WF_HC_COMMAND_ADDWP",[],AIC_fnc_addWaypointsActionHandler] call AIC_fnc_addCommandMenuAction;
["WAYPOINT",localize "STR_WF_HC_COMMAND_ADDWP",[],AIC_fnc_addWaypointsActionHandler] call AIC_fnc_addCommandMenuAction;

AIC_fnc_setGroupBehaviourActionHandler = {
	params ["_menuParams","_actionParams"];
	_menuParams params ["_groupControlId"];
	private ["_group"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	_actionParams params ["_mode"];
	[_group,_mode] remoteExec ["setBehaviour", leader _group];
	[("Behaviour set to " + toLower _mode)] spawn WFCL_fnc_handleMessage
};

["GROUP",localize "STR_WF_HC_BEHAVIOUR_CARELESS",[localize "STR_WF_HC_SETGROUPBEHAVIOUR"],AIC_fnc_setGroupBehaviourActionHandler,["CARELESS"]] call AIC_fnc_addCommandMenuAction;
["GROUP",localize "STR_WF_HC_BEHAVIOUR_SAFE",[localize "STR_WF_HC_SETGROUPBEHAVIOUR"],AIC_fnc_setGroupBehaviourActionHandler,["SAFE"]] call AIC_fnc_addCommandMenuAction;
["GROUP",localize "STR_WF_HC_BEHAVIOUR_AWARE",[localize "STR_WF_HC_SETGROUPBEHAVIOUR"],AIC_fnc_setGroupBehaviourActionHandler,["AWARE"]] call AIC_fnc_addCommandMenuAction;
["GROUP",localize "STR_WF_HC_BEHAVIOUR_COMBAT",[localize "STR_WF_HC_SETGROUPBEHAVIOUR"],AIC_fnc_setGroupBehaviourActionHandler,["COMBAT"]] call AIC_fnc_addCommandMenuAction;
["GROUP",localize "STR_WF_HC_BEHAVIOUR_STEALTH",[localize "STR_WF_HC_SETGROUPBEHAVIOUR"],AIC_fnc_setGroupBehaviourActionHandler,["STEALTH"]] call AIC_fnc_addCommandMenuAction;

AIC_fnc_joinGroupActionHandler = {
	params ["_menuParams","_actionParams"];
	_menuParams params ["_groupControlId"];
	private ["_group"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	private ["_selectedGroup"];
	_selectedGroup = [_groupControlId] call AIC_fnc_selectGroupControlGroup;
	if((count (units _group)) + (count (units _selectedGroup)) <= WF_C_PLAYERS_AI_MAX) then {
        if(!isNull _selectedGroup) then {
            (units _group) joinSilent _selectedGroup;
            ["Selected Group Joined"] spawn WFCL_fnc_handleMessage
        } else {
            ["No Group Selected"] spawn WFCL_fnc_handleMessage
        }
	} else {
	    [format ["Max group unit reached: %1", WF_C_PLAYERS_AI_MAX]] spawn WFCL_fnc_handleMessage
	}
};

["GROUP",localize "STR_WF_HC_COMMAND_JOINGROUP",[localize "STR_WF_HC_GROUPSIZE"],AIC_fnc_joinGroupActionHandler,[]] call AIC_fnc_addCommandMenuAction;

AIC_fnc_setGroupSpeedActionHandler = {
	params ["_menuParams","_actionParams"];
	_menuParams params ["_groupControlId"];
	private ["_group"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	_actionParams params ["_speed","_label"];
	[_group,_speed] remoteExec ["setSpeedMode", leader _group];
	[("Speed set to " + _label)] spawn WFCL_fnc_handleMessage
};	
		
["GROUP",localize "STR_WF_HC_LIMITEDSPEED",[localize "STR_WF_HC_SETGROUPSPEED"],AIC_fnc_setGroupSpeedActionHandler,["LIMITED", "Half Speed"]] call AIC_fnc_addCommandMenuAction;
["GROUP",localize "STR_WF_HC_HALFSPEED",[localize "STR_WF_HC_SETGROUPSPEED"],AIC_fnc_setGroupSpeedActionHandler,["NORMAL", "Full Speed (In Formation)"]] call AIC_fnc_addCommandMenuAction;
["GROUP",localize "STR_WF_HC_FULLSPEED",[localize "STR_WF_HC_SETGROUPSPEED"],AIC_fnc_setGroupSpeedActionHandler,["FULL", "Full (No Formation)"]] call AIC_fnc_addCommandMenuAction;


AIC_fnc_commandMenuIsAir = {
	params ["_menuParams","_actionParams"];
	_menuParams params ["_groupControlId"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	_hasAir = false;
	{
		if(_x isKindOf "Air") then {
			_hasAir = true;
		};
	} forEach ([_group] call AIC_fnc_getGroupAssignedVehicles);
	_hasAir;
};

AIC_fnc_setFlyInHeightActionHandler = {
	params ["_menuParams","_actionParams"];
	_menuParams params ["_groupControlId"];
	private ["_group"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	_actionParams params ["_height"];
	{
		if(_x isKindOf "Air") then {
			[_x,_height] remoteExec ["flyInHeight", _x]; 
		};
	} forEach ([_group] call AIC_fnc_getGroupAssignedVehicles);
	[("Fly in height set to " + (str _height) + " meters")] spawn WFCL_fnc_handleMessage;
};

["GROUP","10 meters",["Set Fly in Height"],AIC_fnc_setFlyInHeightActionHandler,[10],AIC_fnc_commandMenuIsAir] call AIC_fnc_addCommandMenuAction;
["GROUP","20 meters",["Set Fly in Height"],AIC_fnc_setFlyInHeightActionHandler,[20],AIC_fnc_commandMenuIsAir] call AIC_fnc_addCommandMenuAction;
["GROUP","40 meters",["Set Fly in Height"],AIC_fnc_setFlyInHeightActionHandler,[40],AIC_fnc_commandMenuIsAir] call AIC_fnc_addCommandMenuAction;
["GROUP","100 meters",["Set Fly in Height"],AIC_fnc_setFlyInHeightActionHandler,[100],AIC_fnc_commandMenuIsAir] call AIC_fnc_addCommandMenuAction;
["GROUP","250 meters",["Set Fly in Height"],AIC_fnc_setFlyInHeightActionHandler,[250],AIC_fnc_commandMenuIsAir] call AIC_fnc_addCommandMenuAction;
["GROUP","500 meters",["Set Fly in Height"],AIC_fnc_setFlyInHeightActionHandler,[500],AIC_fnc_commandMenuIsAir] call AIC_fnc_addCommandMenuAction;
["GROUP","1000 meters",["Set Fly in Height"],AIC_fnc_setFlyInHeightActionHandler,[1000],AIC_fnc_commandMenuIsAir] call AIC_fnc_addCommandMenuAction;
["GROUP","2000 meters",["Set Fly in Height"],AIC_fnc_setFlyInHeightActionHandler,[2000],AIC_fnc_commandMenuIsAir] call AIC_fnc_addCommandMenuAction;

AIC_fnc_setGroupCombatModeActionHandler = {
	params ["_menuParams","_actionParams"];
	_menuParams params ["_groupControlId"];
	private ["_group"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	_actionParams params ["_mode","_modeLabel"];
	[_group,_mode] remoteExec ["setCombatMode", leader _group];
	[("Combat mode set to " + toLower _modeLabel)] spawn WFCL_fnc_handleMessage
};

["GROUP","Never fire",[localize "STR_WF_HC_SETGROUPCOMBATMODE"],AIC_fnc_setGroupCombatModeActionHandler,["BLUE","Never fire"]] call AIC_fnc_addCommandMenuAction;
["GROUP","Hold fire - defend only",[localize "STR_WF_HC_SETGROUPCOMBATMODE"],AIC_fnc_setGroupCombatModeActionHandler,["GREEN","Hold fire - defend only"]] call AIC_fnc_addCommandMenuAction;
["GROUP","Hold fire, engage at will",[localize "STR_WF_HC_SETGROUPCOMBATMODE"],AIC_fnc_setGroupCombatModeActionHandler,["WHITE","Hold fire, engage at will"]] call AIC_fnc_addCommandMenuAction;
["GROUP","Fire at will",[localize "STR_WF_HC_SETGROUPCOMBATMODE"],AIC_fnc_setGroupCombatModeActionHandler,["YELLOW","Fire at will"]] call AIC_fnc_addCommandMenuAction;
["GROUP","Fire at will, engage at will",[localize "STR_WF_HC_SETGROUPCOMBATMODE"],AIC_fnc_setGroupCombatModeActionHandler,["RED","Fire at will, engage at will"]] call AIC_fnc_addCommandMenuAction;
		
AIC_fnc_clearAllWaypointsActionHandler = {
	params ["_menuParams","_actionParams"];
	_menuParams params ["_groupControlId"];
	private ["_group"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	[_group] call AIC_fnc_disableAllWaypoints;	
	[_groupControlId,"REFRESH_WAYPOINTS",[]] call AIC_fnc_groupControlEventHandler;
	[("All waypoints cleared")] spawn WFCL_fnc_handleMessage
};

["GROUP",localize "STR_WF_HC_CONFIRMCANCELALL",[localize "STR_WF_HC_CLEARALLWAYPOINTS"],AIC_fnc_clearAllWaypointsActionHandler] call AIC_fnc_addCommandMenuAction;

AIC_fnc_remoteControlActionHandler = {
	params ["_menuParams","_actionParams"];
	_menuParams params ["_groupControlId"];
	private ["_group"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	private ["_fromUnit","_rcUnit","_exitingRcUnit"];

	_fromUnit = missionNamespace getVariable ["AIC_Remote_Control_From_Unit",objNull];
	if(isNull _fromUnit || !alive _fromUnit) then {
		_fromUnit = player;
		missionNamespace setVariable ["AIC_Remote_Control_From_Unit",_fromUnit];
	};
	
	_rcUnit = leader _group;
	if(!alive _rcUnit) exitWith {
		["RemoteControl",[localize "STR_WF_HC_REMOTECONTROL", localize "STR_WF_HC_REMOTECONTROL_FAILED"]] call BIS_fnc_showNotification;
	};
	_exitingRcUnit = missionNamespace getVariable ["AIC_Remote_Control_To_Unit",objNull];
	if(!isNull _exitingRcUnit) then {
		_exitingRcUnit removeEventHandler ["HandleDamage", (missionNamespace getVariable ["AIC_Remote_Control_To_Unit_Event_Handler",-1])];
		["MAIN_DISPLAY","KeyDown",(missionNamespace getVariable ["AIC_Remote_Control_Delete_Handler",-1])] call AIC_fnc_removeEventHandler;
	};
	missionNamespace setVariable ["AIC_Remote_Control_To_Unit",_rcUnit];
	missionNamespace setVariable ["AIC_Remote_Control_To_GroupId",_groupControlId];

	AIC_Remote_Control_From_Unit_Event_Handler = _fromUnit addEventHandler ["HandleDamage", "if ((_this # 2) > 0.5) then { [] call AIC_fnc_terminateRemoteControl }; _this # 2;"];
	AIC_Remote_Control_To_Unit_Event_Handler = _rcUnit addEventHandler ["HandleDamage", "if ((_this # 2) > 0.5) then { [] call AIC_fnc_terminateRemoteControl }; _this # 2;"];
	AIC_Remote_Control_Delete_Handler = ["MAIN_DISPLAY","KeyDown", "if(_this select 1 == 211) then { [] call AIC_fnc_terminateRemoteControl; }"] call AIC_fnc_addEventHandler;
	
	BIS_fnc_feedback_allowPP = false;
	{
	    _unit = _x;
	    if(alive _unit) then {
            {_unit disableAI _x} forEach ["MOVE","TEAMSWITCH","AUTOTARGET","TARGET"]
	    }
	} forEach (units (group player));

    selectPlayer _rcUnit;
	(vehicle _rcUnit) switchCamera "External";
	openMap false;
	
	["RemoteControl",[localize "STR_WF_HC_REMOTECONTROL",localize "STR_WF_HC_REMOTECONTROL_PRESSDEL"]] call BIS_fnc_showNotification;
};

AIC_fnc_terminateRemoteControl = {
	_originalLeader = missionNamespace getVariable ["AIC_Remote_Control_To_Unit",objNull];
	["MAIN_DISPLAY","KeyDown",(missionNamespace getVariable ["AIC_Remote_Control_Delete_Handler",-1])] call AIC_fnc_removeEventHandler;
	(missionNamespace getVariable ["AIC_Remote_Control_From_Unit",objNull]) removeEventHandler ["HandleDamage", (missionNamespace getVariable ["AIC_Remote_Control_From_Unit_Event_Handler",-1])];
	(missionNamespace getVariable ["AIC_Remote_Control_To_Unit",objNull]) removeEventHandler ["HandleDamage", (missionNamespace getVariable ["AIC_Remote_Control_To_Unit_Event_Handler",-1])];

	_player = missionNamespace getVariable ["AIC_Remote_Control_From_Unit",player];
	{
        _unit = _x;
        if(alive _unit) then {
            {_unit enableAI _x} forEach ["MOVE","TEAMSWITCH"];
        }
    } forEach (units (group _player));

	selectPlayer (_player);

	missionNamespace setVariable ["AIC_Remote_Control_From_Unit",nil];
	(vehicle player) switchCamera cameraView;
	BIS_fnc_feedback_allowPP = true;
	["RemoteControl",[localize "STR_WF_HC_REMOTECONTROL",localize "STR_WF_HC_REMOTECONTROL_TERMINATED"]] call BIS_fnc_showNotification;

	if!(isNull _originalLeader) then {
	    _unitGroup = group _originalLeader;
	    _unitGroup allowFleeing 0;

	    if(vehicle (leader _unitGroup) != leader _unitGroup) then {
	        _unitGroup setBehaviour "COMBAT"
	    } else {
            _unitGroup setBehaviour "AWARE"
	    };
        _unitGroup setCombatMode "YELLOW";
        _unitGroup setSpeedMode "FULL";

        _groupControlId = missionNamespace getVariable ["AIC_Remote_Control_To_GroupId", nil];
        if!(isnil '_groupControlId') then {
            [_groupControlId,"REFRESH_WAYPOINTS",[]] call AIC_fnc_groupControlEventHandler;
            missionNamespace setVariable ["AIC_Remote_Control_To_GroupId",nil];
        }
	};
	missionNamespace setVariable ["AIC_Remote_Control_To_Unit",nil];
};

["GROUP",localize "STR_WF_HC_REMOTECONTROLDIRECT",[localize "STR_WF_HC_REMOTECONTROL"],AIC_fnc_remoteControlActionHandler,[],{
	params ["_groupControlId"];
	private ["_group"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	private ["_canControl"];
	_canControl = true;
	if(!alive leader _group) then {
		_canControl = false;
	};
	if(isPlayer leader _group) then {
		_canControl = false;
	};
	_canControl;
}] call AIC_fnc_addCommandMenuAction;

AIC_fnc_assignVehicleActionHandler = {
	params ["_menuParams","_actionParams"];
	_menuParams params ["_groupControlId"];
	private ["_group"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	private ["_selectedVehicle"];
	_selectedVehicle = [_groupControlId] call AIC_fnc_selectGroupControlVehicle;
	if(!isNull _selectedVehicle) then {
		private ["_vehicleName","_assignedVehicles","_vehicleSlotsToAssign","_maxSlots","_vehicleRoles"];
		private ["_unitIndex","_countOfSlots","_vehicleToAssign"];
		[_group,_selectedVehicle] remoteExec ["addVehicle", leader _group];
		_assignedVehicles = [_group] call AIC_fnc_getGroupAssignedVehicles;
		_assignedVehicles pushBack _selectedVehicle;
		[_group,_assignedVehicles] call AIC_fnc_setGroupAssignedVehicles;
		_vehicleSlotsToAssign = [];
		_maxSlots = 0;
		{
			_vehicleRoles = [_x] call BIS_fnc_vehicleRoles;
			if(count _vehicleRoles > _maxSlots) then {
				_maxSlots = count _vehicleRoles;
			};
		} forEach _assignedVehicles;
		if(_maxSlots > 0) then {
			for "_i" from 0 to (_maxSlots-1) do {
				{
					_vehicleRoles = [_x] call BIS_fnc_vehicleRoles;
					if(count _vehicleRoles > _i) then {
						_vehicleSlotsToAssign pushBack [_x,_vehicleRoles select _i];
					};
				} forEach _assignedVehicles;
			};
		};
		_unitIndex = 0;
		_countOfSlots = count _vehicleSlotsToAssign;
		{
			if(_countOfSlots > _unitIndex) then {
				_vehicleToAssign = (_vehicleSlotsToAssign select _unitIndex) select 0;
				_role = (_vehicleSlotsToAssign select _unitIndex) select 1;
				[_x,_vehicleToAssign,_role] remoteExec ["AIC_fnc_getInVehicle", _x];
			};
			_unitIndex = _unitIndex + 1;
		} forEach (units _group);
		if(_selectedVehicle isKindOf "Air") then {
			[_selectedVehicle,100] remoteExec ["flyInHeight", _selectedVehicle]; 
		};
		_vehicleName = getText (configFile >> "CfgVehicles" >> typeOf _selectedVehicle >> "displayName");
		[("Vehicle assigned: " + _vehicleName)] spawn WFCL_fnc_handleMessage
	} else {
	    ["No vehicle assigned"] spawn WFCL_fnc_handleMessage
	};
};

AIC_fnc_disbandGroupActionHandler = {
    params ["_menuParams"];
    _menuParams params ["_groupControlId"];
    private ["_group"];
    _group = AIC_fnc_getGroupControlGroup(_groupControlId);

    if (commanderTeam == group player) then {
        if (!(isNil '_group')) then {
            _destroy = units _group;
            _vehicles = [];
            {
                if !(isPlayer _x) then {
                    if (vehicle _x != _x) then {
                        _vehicles pushBackUnique (vehicle _x)
                    };
                    if (_x isKindOf 'Man') then {removeAllWeapons _x};
                    [typeOf _x, false] call WFCL_FNC_AwardBounty;
                    deleteVehicle _x
                }
            } forEach _destroy;
            {
                _x setDammage 1;
                [typeOf _x, false] call WFCL_FNC_AwardBounty;
            } forEach _vehicles;
            _group setVariable ["isHighCommandPurchased", false, true];
            deleteGroup _group;
            _groups = [WF_Client_SideJoined] call WFCO_FNC_getHighCommandGroups;
        }
    }
};

AIC_fnc_unflipGroupActionHandler = {
    params ["_menuParams"];
    _menuParams params ["_groupControlId"];
    private ["_group"];
    _group = AIC_fnc_getGroupControlGroup(_groupControlId);

    if (commanderTeam == group player) then {
        if (!(isNil '_group')) then {
            _units = units _group;
            {
                if (getPos _x select 2 > 3 && !surfaceIsWater (getPos _x)) then {
                    [_x] Call WFCO_FNC_BrokeTerObjsAround;
                    [_x, getPos _x, 15] Call WFCO_FNC_PlaceSafe;
                } else {
                    [_x] Call WFCO_FNC_BrokeTerObjsAround;
                    _x setPos [getPos _x select 0, getPos _x select 1, 0.5];
                    _x setVelocity [0,0,-0.5];
                };
            } forEach _units;
        }
    }
};

["GROUP",localize "STR_WF_HC_ASSIGNVEHICLE",[],AIC_fnc_assignVehicleActionHandler,[]] call AIC_fnc_addCommandMenuAction;


["GROUP",localize "STR_WF_TEAM_DisbandButton",[],AIC_fnc_disbandGroupActionHandler,[]] call AIC_fnc_addCommandMenuAction;
["GROUP",localize "STR_WF_TOOLTIP_UnitCamUnflip",[],AIC_fnc_unflipGroupActionHandler,[]] call AIC_fnc_addCommandMenuAction;

AIC_fnc_unassignVehicleActionHandler = {
	params ["_menuParams","_actionParams"];
	_menuParams params ["_groupControlId"];
	private ["_group"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	{
		[_group,_x] remoteExec ["leaveVehicle", leader _group];
	} forEach ([_group] call AIC_fnc_getGroupAssignedVehicles);
	[_group,nil] call AIC_fnc_setGroupAssignedVehicles;
	["All vehicles unassigned"] spawn WFCL_fnc_handleMessage
};

["GROUP",localize "STR_WF_HC_UNASIGALLVEHS",[],AIC_fnc_unassignVehicleActionHandler,[],{
	params ["_groupControlId"];
	private ["_group"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	private ["_canUnassign"];
	_canUnassign = false;
	_canUnassign = (count ([_group] call AIC_fnc_getGroupAssignedVehicles) > 0);
	{
		if( _x != vehicle _x ) then {
			_canUnassign = true;
		};
	} forEach (units _group);
	_canUnassign;
}] call AIC_fnc_addCommandMenuAction;	


AIC_fnc_setGroupAutoCombatActionHandler = {
	params ["_menuParams","_actionParams"];
	_menuParams params ["_groupControlId"];
	private ["_group"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	_actionParams params ["_mode"];
	if (_mode == "On") then {
		{_x enableAI "AUTOCOMBAT"} foreach (units _group);
	} else {
		{_x disableAI "AUTOCOMBAT"} foreach (units _group);
	};
	[("AutoCombat " + toLower _mode)] spawn WFCL_fnc_handleMessage
};

["GROUP","On",[localize "STR_WF_HC_SETGROUPBEHAVIOUR","Toggle Auto Combat"],AIC_fnc_setGroupAutoCombatActionHandler,["On"]] call AIC_fnc_addCommandMenuAction;
["GROUP","Off",[localize "STR_WF_HC_SETGROUPBEHAVIOUR","Toggle Auto Combat"],AIC_fnc_setGroupAutoCombatActionHandler,["Off"]] call AIC_fnc_addCommandMenuAction;

AIC_fnc_deleteWaypointHandler = {
	params ["_menuParams","_actionParams"];
	_menuParams params ["_groupControlId","_waypointId"];
	private ["_group"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	[_group,_waypointId] call AIC_fnc_disableWaypoint;
	[_groupControlId,"REFRESH_WAYPOINTS",[]] call AIC_fnc_groupControlEventHandler;
};

["WAYPOINT",localize "STR_WF_HC_COMMAND_DELWP",[],AIC_fnc_deleteWaypointHandler] call AIC_fnc_addCommandMenuAction;

AIC_fnc_setWaypointFormationActionHandler = {
	params ["_menuParams","_actionParams"];
	_menuParams params ["_groupControlId","_waypointId"];
	private ["_group","_waypoint"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	_waypoint = [_group, _waypointId] call AIC_fnc_getWaypoint;
	_actionParams params ["_mode"];
	_waypoint set [7,_mode];
	[_group, _waypoint] call AIC_fnc_setWaypoint;
	[_groupControlId,"REFRESH_WAYPOINTS",[]] call AIC_fnc_groupControlEventHandler;
	[("Formation set to " + toLower _mode)] spawn WFCL_fnc_handleMessage
};

["WAYPOINT",localize "STR_WF_HC_FORMATION_COLUMN",[localize "STR_WF_HC_SETGROUPFORMATION"],AIC_fnc_setWaypointFormationActionHandler,["COLUMN"]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT",localize "STR_WF_HC_FORMATION_STAGCOLUMN",[localize "STR_WF_HC_SETGROUPFORMATION"],AIC_fnc_setWaypointFormationActionHandler,["STAG COLUMN"]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT",localize "STR_WF_HC_FORMATION_WEDGE",[localize "STR_WF_HC_SETGROUPFORMATION"],AIC_fnc_setWaypointFormationActionHandler,["WEDGE"]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT",localize "STR_WF_HC_FORMATION_ECHELONLEFT",[localize "STR_WF_HC_SETGROUPFORMATION"],AIC_fnc_setWaypointFormationActionHandler,["ECH LEFT"]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT",localize "STR_WF_HC_FORMATION_ECHELONRIGHT",[localize "STR_WF_HC_SETGROUPFORMATION"],AIC_fnc_setWaypointFormationActionHandler,["ECH RIGHT"]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT",localize "STR_WF_HC_FORMATION_V",[localize "STR_WF_HC_SETGROUPFORMATION"],AIC_fnc_setWaypointFormationActionHandler,["VEE"]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT",localize "STR_WF_HC_FORMATION_LINE",[localize "STR_WF_HC_SETGROUPFORMATION"],AIC_fnc_setWaypointFormationActionHandler,["LINE"]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT",localize "STR_WF_HC_FORMATION_FILE",[localize "STR_WF_HC_SETGROUPFORMATION"],AIC_fnc_setWaypointFormationActionHandler,["FILE"]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT",localize "STR_WF_HC_FORMATION_DIAMOND",[localize "STR_WF_HC_SETGROUPFORMATION"],AIC_fnc_setWaypointFormationActionHandler,["DIAMOND"]] call AIC_fnc_addCommandMenuAction;
								
AIC_fnc_setWaypointTypeActionHandler = {
	params ["_menuParams","_actionParams"];
	_menuParams params ["_groupControlId","_waypointId"];
	private ["_group","_waypoint"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	_waypoint = [_group, _waypointId] call AIC_fnc_getWaypoint;
	_actionParams params ["_mode","_label"];
	_waypoint set [3,_mode];
	[_group, _waypoint] call AIC_fnc_setWaypoint;
	[_groupControlId,"REFRESH_WAYPOINTS",[]] call AIC_fnc_groupControlEventHandler;
	[("Type set to " + toLower _label)] spawn WFCL_fnc_handleMessage
};

AIC_fnc_setLoiterTypeActionHandler = {
	params ["_menuParams","_actionParams"];
	_menuParams params ["_groupControlId","_waypointId"];
	_actionParams params ["_radius","_clockwise"];
	private ["_group","_waypoint"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	_waypoint = [_group, _waypointId] call AIC_fnc_getWaypoint;
	_waypoint set [3,"LOITER"];
	_waypoint set [10,_radius];
	if(_clockwise) then {
		_waypoint set [11,"CIRCLE"];
	} else {
		_waypoint set [11,"CIRCLE_L"];
	};
	[_group, _waypoint] call AIC_fnc_setWaypoint;
	[_groupControlId,"REFRESH_WAYPOINTS",[]] call AIC_fnc_groupControlEventHandler;
	_loiterTypeLabel = "loiter clockwise";
	if(!_clockwise) then {
		_loiterTypeLabel = "loiter counter clockwise";
	};
	[("Type set to " + _loiterTypeLabel + " at " + str _radius + " meter radius")] spawn WFCL_fnc_handleMessage
};

["WAYPOINT","Move (default)",["Set Waypoint Type"],AIC_fnc_setWaypointTypeActionHandler,["MOVE","Move"]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","Seek & Destroy",["Set Waypoint Type"],AIC_fnc_setWaypointTypeActionHandler,["SAD","Seek & Destroy"]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","10M Radius",["Set Waypoint Type","Loiter (Clockwise)"],AIC_fnc_setLoiterTypeActionHandler,[10,true]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","100M Radius",["Set Waypoint Type","Loiter (Clockwise)"],AIC_fnc_setLoiterTypeActionHandler,[100,true]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","250M Radius",["Set Waypoint Type","Loiter (Clockwise)"],AIC_fnc_setLoiterTypeActionHandler,[250,true]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","500M Radius",["Set Waypoint Type","Loiter (Clockwise)"],AIC_fnc_setLoiterTypeActionHandler,[500,true]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","1000M Radius",["Set Waypoint Type","Loiter (Clockwise)"],AIC_fnc_setLoiterTypeActionHandler,[1000,true]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","2000M Radius",["Set Waypoint Type","Loiter (Clockwise)"],AIC_fnc_setLoiterTypeActionHandler,[2000,true]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","3000M Radius",["Set Waypoint Type","Loiter (Clockwise)"],AIC_fnc_setLoiterTypeActionHandler,[3000,true]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","4000M Radius",["Set Waypoint Type","Loiter (Clockwise)"],AIC_fnc_setLoiterTypeActionHandler,[4000,true]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","10M Radius",["Set Waypoint Type","Loiter (C-Clockwise)"],AIC_fnc_setLoiterTypeActionHandler,[10,false]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","100M Radius",["Set Waypoint Type","Loiter (C-Clockwise)"],AIC_fnc_setLoiterTypeActionHandler,[100,false]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","250M Radius",["Set Waypoint Type","Loiter (C-Clockwise)"],AIC_fnc_setLoiterTypeActionHandler,[250,false]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","500M Radius",["Set Waypoint Type","Loiter (C-Clockwise)"],AIC_fnc_setLoiterTypeActionHandler,[500,false]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","1000M Radius",["Set Waypoint Type","Loiter (C-Clockwise)"],AIC_fnc_setLoiterTypeActionHandler,[1000,false]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","2000M Radius",["Set Waypoint Type","Loiter (C-Clockwise)"],AIC_fnc_setLoiterTypeActionHandler,[2000,false]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","3000M Radius",["Set Waypoint Type","Loiter (C-Clockwise)"],AIC_fnc_setLoiterTypeActionHandler,[3000,false]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","4000M Radius",["Set Waypoint Type","Loiter (C-Clockwise)"],AIC_fnc_setLoiterTypeActionHandler,[4000,false]] call AIC_fnc_addCommandMenuAction;

AIC_fnc_setWaypointFlyInHeightActionHandlerScript = {
	params ["_group","_height"]; 
  { 
  	if(_x isKindOf "Air") then { 
    	[_x,_height] remoteExec ["flyInHeight", _x];
    };
  } forEach ([_group] call AIC_fnc_getGroupAssignedVehicles);
};

AIC_fnc_setWaypointFlyInHeightActionHandler = {
	private ["_script"];
	params ["_menuParams","_actionParams"];
	_menuParams params ["_groupControlId","_waypointId"];
  _actionParams params ["_height"];
	private ["_group","_waypoint"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	_waypoint = [_group, _waypointId] call AIC_fnc_getWaypoint;
  _script = format ["[group this, %1] call AIC_fnc_setWaypointFlyInHeightActionHandlerScript",_height];
	_waypoint set [4,_script];
	_waypoint set [12,_height];
	[_group, _waypoint] call AIC_fnc_setWaypoint;
	[("Waypoint fly in height set to " + (str _height) + " meters")] spawn WFCL_fnc_handleMessage
};

["WAYPOINT","10 meters",["Set Fly in Height"],AIC_fnc_setWaypointFlyInHeightActionHandler,[10],AIC_fnc_commandMenuIsAir] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","20 meters",["Set Fly in Height"],AIC_fnc_setWaypointFlyInHeightActionHandler,[20],AIC_fnc_commandMenuIsAir] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","40 meters",["Set Fly in Height"],AIC_fnc_setWaypointFlyInHeightActionHandler,[40],AIC_fnc_commandMenuIsAir] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","100 meters",["Set Fly in Height"],AIC_fnc_setWaypointFlyInHeightActionHandler,[100],AIC_fnc_commandMenuIsAir] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","250 meters",["Set Fly in Height"],AIC_fnc_setWaypointFlyInHeightActionHandler,[250],AIC_fnc_commandMenuIsAir] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","500 meters",["Set Fly in Height"],AIC_fnc_setWaypointFlyInHeightActionHandler,[500],AIC_fnc_commandMenuIsAir] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","1000 meters",["Set Fly in Height"],AIC_fnc_setWaypointFlyInHeightActionHandler,[1000],AIC_fnc_commandMenuIsAir] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","2000 meters",["Set Fly in Height"],AIC_fnc_setWaypointFlyInHeightActionHandler,[2000],AIC_fnc_commandMenuIsAir] call AIC_fnc_addCommandMenuAction;

AIC_fnc_setWaypointDurationActionHandler = {
	params ["_menuParams","_actionParams"];
	_menuParams params ["_groupControlId","_waypointId"];
  _actionParams params ["_duration"];
	private ["_group","_waypoint"];
	_group = AIC_fnc_getGroupControlGroup(_groupControlId);
	_waypoint = [_group, _waypointId] call AIC_fnc_getWaypoint;
	_waypoint set [9,_duration * 60];
	[_group, _waypoint] call AIC_fnc_setWaypoint;
	[("Waypoint duration set to " + (str _duration) + " mins")] spawn WFCL_fnc_handleMessage
};

["WAYPOINT","None",["Set Duration"],AIC_fnc_setWaypointDurationActionHandler,[0]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","1 Min",["Set Duration"],AIC_fnc_setWaypointDurationActionHandler,[1]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","2 Min",["Set Duration"],AIC_fnc_setWaypointDurationActionHandler,[2]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","3 Min",["Set Duration"],AIC_fnc_setWaypointDurationActionHandler,[3]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","4 Min",["Set Duration"],AIC_fnc_setWaypointDurationActionHandler,[4]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","5 Min",["Set Duration"],AIC_fnc_setWaypointDurationActionHandler,[5]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","10 Min",["Set Duration"],AIC_fnc_setWaypointDurationActionHandler,[10]] call AIC_fnc_addCommandMenuAction;
["WAYPOINT","20 Min",["Set Duration"],AIC_fnc_setWaypointDurationActionHandler,[20]] call AIC_fnc_addCommandMenuAction;

