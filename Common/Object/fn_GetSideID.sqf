/*
	Return the numeric value of a side.
	 Parameters:
		- Side.
*/

switch (_this) do {
	case west: {WF_C_WEST_ID};
	case east: {WF_C_EAST_ID};
	case resistance: {WF_C_GUER_ID};
	case civilian: {WF_C_CIV_ID};
	case sideAmbientLife: {WF_C_AMBIENT_ID};
	case sideEmpty: {WF_C_EMPTY_ID};
    case sideFriendly: {WF_C_FRIENDLY_ID};
	case sideEnemy: {WF_C_ENEMY_ID};
	case sideUnknown: {WF_C_UNKNOWN_ID};
    case sideLogic: {WF_C_LOGIC_ID};
	default {4};
};

