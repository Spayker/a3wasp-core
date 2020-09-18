//------------------fn_addBaseBuildingRepAction-----------------------------------------------------------------------//
//	Calling on player machine by server with RemoteExec for adding action for repair base buildings                   //
//------------------fn_addBaseBuildingRepAction-----------------------------------------------------------------------//
params ["_building", "_structure_type"];
private ["_actionText", "_actionId"];

_actionText = format["<t color='#f8d664'><img size='0.75' image='\a3\ui_f\data\IGUI\Cfg\Cursors\iconRepairVehicle_ca.paa'/>%1 %2</t>",
	localize "STR_WF_SERVICE_Repair", _structure_type];
_actionId = _building addAction ["", WFCL_FNC_baseBuildingRepAction, [], 1, true, false, "",
    "_this == leader commanderTeam || WF_SK_V_Type == 'Engineer'", 10];
_building setUserActionText [_actionId , _actionText, "<img size='2' image='\a3\ui_f\data\IGUI\Cfg\Cursors\iconRepairVehicle_ca.paa'/>"];