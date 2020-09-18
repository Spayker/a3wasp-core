/*
	Script: Sniper Skill System by Benny.
	Description: Add special skills to the defined sniper.
*/
Private ['_binoculars','_markerName','_markertime','_screenPos'];

_binoculars = ["Laserdesignator", "Binocular", "Binocular_Vector","rhs_1PN138","rhs_pdu4","lerca_1200_black","lerca_1200_tan","Leupold_Mk4","Rangefinder"];
if !((currentWeapon player) in _binoculars) exitWith {hint (localize "STR_WF_INFO_Spot_Info")};

if (isNil "markerID") then {markerID = 1};
_screenPos = screenToWorld [0.5,0.5];

_markerName = Format ["Spot%1",markerID];
createMarkerLocal [_markerName,_screenPos];
_markertime = [daytime] call bis_fnc_timetostring;
_markerName setMarkerText Format ['SPOTTED: %1',_markertime];
_markerName setMarkerTypeLocal "mil_destroy";
_markerName setMarkerColorLocal "ColorRed";
_markerName setMarkerSizeLocal [0.5,0.5];
markerID = markerID + 1;

WF_SK_V_LastUse_Spot = time;

[_markerName] Spawn {
	Private ["_marker"];
	_marker = _this select 0;
	sleep 180;
	deleteMarkerLocal _marker;
};