//------------------------fn_UpdatgeRadarMarker-----------------------------------------------------------------------//
//	Update Radar circle marker          										                                      //
//------------------------fn_UpdatgeRadarMarker-----------------------------------------------------------------------//
params ["_newSideId", "_location"];
private ["_marker"];

{
    if((_x # 0) isEqualTo _location) exitWith {
        WF_C_TAKEN_RADIO_TOWERS deleteAt _forEachIndex;
        deleteMarkerLocal format["radiotower%1", (position _location) # 0];
        deleteMarkerLocal format["WF_%1_TowerMarker", (position _location) # 1];
    }
} forEach WF_C_TAKEN_RADIO_TOWERS;

if ((WF_Client_SideJoined call WFCO_FNC_GetSideID) == _newSideId) then {
    _marker = format["radiotower%1", (position _location) # 0];
    createMarkerLocal [_marker, getPosATL _location];
    _marker setMarkerBrushLocal "Border";
    _marker setMarkerShapeLocal "Ellipse";
    _marker setMarkerColorLocal "ColorBlack";
    _marker setMarkerSizeLocal [WF_C_STRUCTURES_COMMANDCENTER_RANGE / 2, WF_C_STRUCTURES_COMMANDCENTER_RANGE / 2];

    _towerMarker = Format ["WF_%1_TowerMarker", (position _location) # 1];
    createMarkerLocal [_towerMarker, getPosATL _location];
    _towerMarker setMarkerTextLocal "Radio Tower";
    _towerMarker setMarkerTypeLocal "loc_Transmitter";
    _towerColor = missionNamespace getVariable (Format ["WF_C_%1_COLOR",(_newSideId) Call WFCO_FNC_GetSideFromID]);
    _towerMarker setMarkerColorLocal _towerColor;

    WF_C_TAKEN_RADIO_TOWERS pushBackUnique [_location, position _location]
}