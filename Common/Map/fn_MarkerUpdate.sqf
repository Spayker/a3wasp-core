params ["_markerType", "_markerColor", "_markerSize", "_markerText", "_markerName", "_tracked", "_refreshRate",
"_trackDeath", "_deathMarkerType", "_deathMarkerColor", "_deletePrevious", "_side", ["_deathMarkerSize", [1, 1]]];

waitUntil {commonInitComplete};

if (_side != side player || isNull _tracked || !(alive _tracked)) exitWith {};
if (_deletePrevious) then {deleteMarkerLocal _markerName};

_markerName = createMarkerLocal [_markerName,getPos _tracked];
if (_markerText != "") then {_markerName setMarkerTextLocal _markerText};
_markerName setMarkerTypeLocal _markerType;
_markerName setMarkerColorLocal _markerColor;
_markerName setMarkerSizeLocal _markerSize;

WF_UNIT_MARKERS pushBack ([_markerName, _tracked, _trackDeath, _deathMarkerType, _deathMarkerColor, _deathMarkerSize]);