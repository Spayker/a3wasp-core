params ["_newFriendSide"];
private ['_list'];

//--- set friendly gear
call TER_fnc_cleanGearData;

call compile preprocessFileLineNumbers "Common\Warfare\Config\Gear\Gear_Vanilla_Common.sqf";
call compile preprocessFileLineNumbers format ["Common\Warfare\Config\Gear\Gear_%1.sqf", _newFriendSide];
call compile preprocessFileLineNumbers format ["Common\Warfare\Config\Gear\Gear_Vanilla_%1.sqf", _newFriendSide];
call compile preprocessFileLineNumbers format ["Common\Warfare\Config\Gear\RoleBased\Gear_Sniper_%1.sqf", _newFriendSide];
call compile preprocessFileLineNumbers format ["Common\Warfare\Config\Gear\RoleBased\Gear_Support_%1.sqf", _newFriendSide];

_list = missionNamespace getVariable "wf_gear_list_explosives";
_list = _list + (missionNamespace getVariable "wf_gear_list_magazines");
_list = _list + (missionNamespace getVariable "wf_gear_list_accessories");
_list = _list + (missionNamespace getVariable "wf_gear_list_misc");
WF_C_GEAR_LIST = _list;

//--- set friendly start gear after respawn
player setVariable ['shallSetupFriendlyStartGear', true];