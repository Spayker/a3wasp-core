params ["_vehicle", "_team"];
private ["_side"];

_side = side _team;
_hqs = (_side) Call WFCO_FNC_GetSideHQ;
_hq = [_vehicle, _hqs] call WFCO_FNC_GetClosestEntity;

if !(isNil "_hq") then {

    if ((_hq distance _vehicle) > missionNamespace getVariable "WF_C_BASE_HQ_BUILD_RANGE" ) then {
        ("HQ locates too far from Truck") remoteExecCall ["WFCL_FNC_GroupChatMessage", leader _team]
    } else {
        _supplyBonus = 2500;
        _txt = Format[Localize "STR_WF_CHAT_Commander_Supply_Truck_Sold", _supplyBonus];

        (_txt) remoteExecCall ["WFCL_FNC_CommandChatMessage", _side];
        [_side, _supplyBonus] Call WFCO_FNC_ChangeSideSupply;
        deleteVehicle _vehicle
    }
    
}