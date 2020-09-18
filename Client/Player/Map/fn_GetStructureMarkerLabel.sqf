Private["_class","_label","_rlType","_side","_structure","_structures","_structuresNames"];

_structure = _this select 0;
_side = _this select 1;

_class = typeOf _structure;

_structures = missionNamespace getVariable Format ['WF_%1STRUCTURES', _side];
_structuresNames = missionNamespace getVariable Format ['WF_%1STRUCTURENAMES',_side];

_rlType = _structures select (_structuresNames find _class);

_label = switch (_rlType) do {
	case "Barracks": {"B"};
	case "Light": {"L"};
	case "CommandCenter": {"C"};
	case "Heavy": {"H"};
	case "Aircraft": {"A"};
	case "ServicePoint": {"S"};
	case "AARadar": {"AAR"};
	case "ArtyRadar": {"ARR"};
	default {""};
};

_label