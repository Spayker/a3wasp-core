Private ['_boundariesXY'];
_boundariesXY = -1;

switch (toLower(worldName)) do {
	case 'chernarus': {_boundariesXY = 15360};
	case 'eden': {_boundariesXY = 12800};
	case 'fallujah': {_boundariesXY = 10240};
	case 'isladuala': {_boundariesXY = 10240};
	case 'isladuala3': {_boundariesXY = 10240};
	case 'panthera2': {_boundariesXY = 10240};
	case 'queshkibrul': {_boundariesXY = 5120};
	case 'sara': {_boundariesXY = 20480};
	case 'saraLite': {_boundariesXY = 10240};
	case 'takistan': {_boundariesXY = 12800};
	case 'malden': {_boundariesXY = 12800};
	case 'utes': {_boundariesXY = 5120};
	case 'yapal': {_boundariesXY = 5120};
	case 'zargabad': {_boundariesXY = 8192};
	case 'tanoa': {_boundariesXY = 29360};
	case 'altis': {_boundariesXY = 29360};
	case 'napf': {_boundariesXY = 20600};
	case 'stratis': {_boundariesXY = 10240};
	case 'enoch': {_boundariesXY = 15360};
};

if ((missionNamespace getVariable "WF_C_GAMEPLAY_BOUNDARIES_ENABLED") > 0) then {
	if (_boundariesXY == -1) then {
		missionNamespace setVariable ["WF_C_GAMEPLAY_BOUNDARIES_ENABLED", 0];
		if (local player) then {
			WFCL_FNC_IsOnMap = nil;
			WFCL_FNC_HandleOnMap = nil;
		};
		["INFORMATION", Format ["initBoundaries.sqf: There is no proper boundaries set for island [%1]", worldName]] Call WFCO_FNC_LogContent;
	} else {
		missionNamespace setVariable ['WF_BOUNDARIESXY',_boundariesXY];
		["INFORMATION", Format ["initBoundaries.sqf: Boundaries [%1] found for island [%2]", _boundariesXY, worldName]] Call WFCO_FNC_LogContent;
	};
} else {
	if (_boundariesXY == -1) then {
		["INFORMATION", Format ["initBoundaries.sqf: There is no proper boundaries set for island [%1]", worldName]] Call WFCO_FNC_LogContent;
	} else {
		missionNamespace setVariable ['WF_BOUNDARIESXY',_boundariesXY];
		["INFORMATION", Format ["initBoundaries.sqf: Boundaries [%1] found for island [%2] {Boundaries parameter is disabled}", _boundariesXY, worldName]] Call WFCO_FNC_LogContent;
	};
};