/*
	Return a side's HQ.
	 Parameters:
		- Side.
*/

switch (_this) do {
	case west: {WF_L_BLU getVariable "wf_supply"};
	case east: {WF_L_OPF getVariable "wf_supply"};
	case resistance: {WF_L_GUE getVariable "wf_supply"};
	default {objNull};
}