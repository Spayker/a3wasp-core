Private ["_additionalErase","_direction","_expand","_markerColor","_markerMax","_markerMin","_markerName","_markerPosition","_markerSize","_markerType"];
_markerName = _this select 0;
_markerPosition = _this select 1;
_markerType = _this select 2;
_markerSize = _this select 3;
_markerColor = _this select 4;
_markerMin = _this select 5;
_markerMax = _this select 6;
_additionalErase = "";
if (count _this > 7) then {_additionalErase = _this select 7};

deleteMarkerLocal _markerName;
CreateMarkerLocal [_markerName,_markerPosition];
_markerName setMarkerTypeLocal _markerType;
_markerName setMarkerColorLocal _markerColor;
_markerName setMarkerSizeLocal [_markerSize,_markerSize];

_difference = (_markerMax - _markerMin)/10;
_direction = 0;
_expand = true;
activeAnimMarker = true;

if (_additionalErase != "") then {
	Private ["_pr"];
	_pr = missionNamespace getVariable "WF_C_AI_PATROL_RANGE";
	createMarkerLocal [_additionalErase,_markerPosition];
	_additionalErase setMarkerShapeLocal "Ellipse";
	_additionalErase setMarkerColorLocal _markerColor;
	_additionalErase setMarkerSizeLocal [_pr,_pr];
};

while {activeAnimMarker} do {
	sleep 0.1;

	_direction = (_direction + 1) % 360;
	_markerName setMarkerDirLocal _direction;
	_markerName setMarkerSizeLocal [_markerSize,_markerSize];

	if (_markerSize > _markerMax) then {_expand = false};
	if (_markerSize < _markerMin) then {_expand = true};
	if (_expand) then {_markerSize = _markerSize + _difference} else {_markerSize = _markerSize - _difference};
};

deleteMarkerLocal _markerName;
if (_additionalErase != "") then {deleteMarkerLocal _additionalErase};