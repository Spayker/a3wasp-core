//------------------------fn_UpdatgeRadarMarker-----------------------------------------------------------------------//
//	Update Radar circle marker          										                                      //
//------------------------fn_UpdatgeRadarMarker-----------------------------------------------------------------------//
params ["_location"];
private ["_marker"];

waitUntil { (missionNamespace getVariable ["commonInitComplete", false])
    && (missionNamespace getVariable ["clientInitComplete", false]) };

if ((WF_Client_SideJoined call WFCO_FNC_GetSideID) == (_location getVariable ["sideid", -1])) then {
    _marker = format["markerradar%1", (position _location) # 0];
    createMarkerLocal [_marker, getPos _location];
    _marker setMarkerBrushLocal "Border";
    _marker setMarkerShapeLocal "Ellipse";
    _marker setMarkerColorLocal "ColorBlack";
    _marker setMarkerSizeLocal [WF_C_STRUCTURES_COMMANDCENTER_RANGE / 2, WF_C_STRUCTURES_COMMANDCENTER_RANGE / 2];
} else {
    deleteMarkerLocal format["markerradar%1", (position _location) # 0];
};