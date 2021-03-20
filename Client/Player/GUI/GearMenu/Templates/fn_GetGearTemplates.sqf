//----------------------------------fn_GetGearTemplates-----------------------------------------//
//	Retrieves gear templates for each role from the server DB       						    //
//----------------------------------fn_GetGearTemplates-----------------------------------------//
#include "..\..\..\..\..\script_macros.hpp"

private ["_templates"];

{
    _templates = nil;
    if (side player == resistance) then {
        _templates = (["WFSE_FNC_GetGearTemplates", player, [steamid, WF_Client_SideJoinedText, _x], 200] call WFCL_FNC_remoteExecServer);
    } else {
    _templates = [_x, 4] call compile preprocessFileLineNumbers format["Common\Warfare\Config\Gear\RoleBased\Gear_Templates_%1.sqf", WF_Client_SideJoinedText];
	_templates = _templates + (["WFSE_FNC_GetGearTemplates", player, [steamid, WF_Client_SideJoinedText, _x], 200] call WFCL_FNC_remoteExecServer);
    };

	if(isNil "_templates") then {
		_templates = [];
	};

	["MESSAGE", Format["fn_GetGearTemplates.sqf: The gear templates has been recieved for a role %1: %2", _x, _templates]] Call WFCO_FNC_LogContent;

	missionNamespace setVariable [format["wf_player_gearTemplates_%1", _x], _templates];
} forEach [WF_RECON,WF_ASSAULT,WF_ENGINEER,WF_SPECOPS,WF_MEDIC,WF_SUPPORT,""];
