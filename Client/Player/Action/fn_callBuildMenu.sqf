Private ["_mhqs", "_base"];

_mhqs = (WF_Client_SideJoined) Call WFCO_FNC_GetSideHQ;
_mhq = [player,_mhqs] call WFCO_FNC_GetClosestEntity;

_hqDeployed = [WF_Client_SideJoined, _mhq] Call WFCO_FNC_GetSideHQDeployStatus;
if (_hqDeployed) then {
    [missionNamespace getVariable "WF_C_BASE_COIN_AREA_HQ_DEPLOYED",true,MCoin] Call WFCL_FNC_initConstructionModule;

} else {
    [missionNamespace getVariable "WF_C_BASE_COIN_AREA_HQ_UNDEPLOYED",false,MCoin] Call WFCL_FNC_initConstructionModule;
};

[player,player,2,MCoin,getpos player,_mhq] call WFCL_fnc_callConstructionInterface;