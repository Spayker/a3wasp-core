//------------------------fn_UpdatgeRadarMarker-----------------------------------------------------------------------//
//	Update Radar circle marker          										                                      //
//------------------------fn_UpdatgeRadarMarker-----------------------------------------------------------------------//
params ["_newSideId", "_location"];
private ["_marker", "_towerMarker", "_towerColor"];

{
    if((_x # 0) isEqualTo _location) exitWith {
        WF_C_TAKEN_RADIO_TOWERS deleteAt _forEachIndex;
        deleteMarkerLocal format["radiotower%1", (position _location) # 0];
        deleteMarkerLocal format["WF_%1_TowerMarker", (position _location) # 1];
    }
} forEach WF_C_TAKEN_RADIO_TOWERS;

_newSide = (_newSideId) Call WFCO_FNC_GetSideFromID;
_radioTowerColor = nil;
if (_newSide == sideLogic) then {
    _radioTowerColor = missionNamespace getVariable "WF_C_UNKNOWN_COLOR"
} else {
    _radioTowerColor =  missionNamespace getVariable (Format ["WF_C_%1_COLOR",_newSide])
};

_towerMarker = Format ["WF_%1_TowerMarker", (position _location) # 1];
createMarkerLocal [_towerMarker, getPosATL _location];
_towerMarker setMarkerTextLocal "Radio Tower";
_towerMarker setMarkerTypeLocal "loc_Transmitter";
_towerMarker setMarkerColorLocal _radioTowerColor;

if ((WF_Client_SideJoined call WFCO_FNC_GetSideID) == _newSideId) then {
    _marker = format["radiotower%1", (position _location) # 0];
    createMarkerLocal [_marker, getPosATL _location];
    _marker setMarkerBrushLocal "Border";
    _marker setMarkerShapeLocal "Ellipse";
    _marker setMarkerColorLocal "ColorBlack";
    _marker setMarkerSizeLocal [WF_C_STRUCTURES_COMMANDCENTER_RANGE / 2, WF_C_STRUCTURES_COMMANDCENTER_RANGE / 2];
    WF_C_TAKEN_RADIO_TOWERS pushBackUnique [_location, position _location];
}