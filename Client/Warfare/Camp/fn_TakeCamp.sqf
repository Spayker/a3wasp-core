Private ['_playerPos', '_town', '_camps', '_camp', '_oldSideId', '_oldSide', '_newSID'];

_playerPos = getPosATL player;
_town = [_playerPos] Call WFCO_FNC_GetClosestLocation;
_camps = _town getVariable "camps";

_camp = [_playerPos, _camps] Call WFCO_FNC_GetClosestEntity;
_oldSideId = _camp getVariable "sideID";

if (_oldSideId != WF_C_UNKNOWN_ID) then {
    _oldSide = (_oldSideId) call WFCO_FNC_GetSideFromID;
    if (missionNamespace getVariable Format ["WF_%1_PRESENT",_oldSide]) then {
        [_oldSide, "LostAt",["Strongpoint",_town]] remoteExecCall ["WFSE_FNC_SideMessage", 2]
    };
};

if (missionNamespace getVariable Format ["WF_%1_PRESENT",WF_Client_SideJoined]) then {
    [WF_Client_SideJoined,"CapturedNear",["Strongpoint",_town]] remoteExecCall ["WFSE_FNC_SideMessage", 2]
};

_newSID = WF_Client_SideJoined Call WFCO_FNC_GetSideID;
_camp setVariable ["sideID",_newSID,true];
[_camp,_newSID,_oldSideId] remoteExecCall ["WFCL_FNC_CampCaptured"];