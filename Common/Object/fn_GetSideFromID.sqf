/*
	Return the side from the ID.
	 Parameters:
		- Side ID.
*/

switch (_this) do {
	case WF_C_WEST_ID: {west};
	case WESTID: {west};
	case WF_C_EAST_ID: {east};
	case EASTID: {east};
	case WF_C_GUER_ID: {resistance};
	case RESISTANCEID: {resistance};
	case WF_C_CIV_ID: {civilian};
	default {sideLogic};
};

