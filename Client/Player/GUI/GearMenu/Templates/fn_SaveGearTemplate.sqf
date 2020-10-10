//------------------fn_SaveGearTemplate-----------------------------------------//
//	Saves gear template to the server DB										//
//------------------fn_SaveGearTemplate-----------------------------------------//
#include "..\..\..\..\..\script_macros.hpp"

params [["_gear", []], ["_name", ""], ["_role", ""]];
private ["_result", "_resultGear", "_excludes", "_upgrades", "_resultMessage"];

_result = false;
_resultGear = [];
_resultMessage = "";

_upgrades = (WF_Client_SideJoined) Call WFCO_FNC_GetSideUpgrades;

_resultGear = [_gear, _upgrades # WF_UP_GEAR] call WFCO_FNC_proccedLoadOutForSide;

if(!isNil "_resultGear") then {
	_result = ["WFSE_FNC_SaveGearTemplate", player, [_resultGear # 0, _name, _role, getPlayerUID player, WF_Client_SideJoinedText]] call WFCL_FNC_remoteExecServer;
};

if(!_result) then {
	_resultMessage = localize "STR_WF_GEARTEMPLATE_SAVE_ERROR";
} else {
	_resultMessage = format[localize "STR_WF_GEARTEMPLATE_SAVE_OK", _name];
	
	call WFCL_FNC_GetGearTemplates;
	
	if(count (_resultGear # 1) > 0) then {
		_resultMessage = _resultMessage + "<br /><br />" + (localize "STR_WF_GEARTEMPLATE_SAVE_EXCLUDES");
		
		_resultMessage = _resultMessage + "<br /><br />";
		
		{			
			_config_type = [_x] call WFCO_FNC_GetConfigType;
			
			_resultMessage = _resultMessage + format["<t align='left'><img image='%1' size='1.5'/></t><t color='#ee2222' size='1.1'>%2</t><br />", [_x, "picture", _config_type] Call WFCO_FNC_GetConfigInfo, [_x, "displayName", _config_type] Call WFCO_FNC_GetConfigInfo];
		} forEach (_resultGear # 1);
	};
};

[format["%1", _resultMessage]] spawn WFCL_fnc_handleMessage;

_result;