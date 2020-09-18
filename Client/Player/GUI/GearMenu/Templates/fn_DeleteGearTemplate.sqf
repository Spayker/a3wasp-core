//------------------fn_DeleteGearTemplate-----------------------------------------//
//	Delete gear template from the server DB										  //
//------------------fn_DeleteGearTemplate-----------------------------------------//
#include "..\..\..\..\..\script_macros.hpp"

params [["_templateDbId", 0]];

_result = false;
_resultMessage = "";

_result = ["WFSE_FNC_DeleteGearTemplate", player, [_templateDbId]] call WFCL_FNC_remoteExecServer;

if(!_result) then {
	_resultMessage = localize "STR_WF_GEARTEMPLATE_DELETE_ERROR";
} else {
	_resultMessage = localize "STR_WF_GEARTEMPLATE_DELETE_OK";
	call WFCL_FNC_GetGearTemplates;
};

HINT parseText(_resultMessage);

_result;