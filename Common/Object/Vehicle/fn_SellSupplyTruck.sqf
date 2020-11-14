params ["_vehicle", "_team"];
private ["_side"];

_side = side _team;
_hqs = (_side) Call WFCO_FNC_GetSideHQ;
_hq = [_vehicle, _hqs] call WFCO_FNC_GetClosestEntity;
_isSupplyVehicle = _vehicle getVariable ['isSupplyVehicle', false];

if (!(isNil "_hq") && _isSupplyVehicle) then {

    if ((_hq distance _vehicle) > missionNamespace getVariable "WF_C_BASE_HQ_BUILD_RANGE" ) then {
        (localize "STR_WF_CHAT_Commander_Supply_Truck_Too_Far") remoteExecCall ["WFCL_FNC_GroupChatMessage", leader _team]
    } else {
        _supplyBonus = 2500;
        _txt = Format[Localize "STR_WF_CHAT_Commander_Supply_Truck_Sold", _supplyBonus];

        (_txt) remoteExecCall ["WFCL_FNC_CommandChatMessage", _side];
        [_side, _supplyBonus] Call WFCO_FNC_ChangeSideSupply;
        deleteVehicle _vehicle
    }
    
}