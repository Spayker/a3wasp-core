/*
	Return a side's HQ.
	 Parameters:
		- Side.
*/

switch (_this) do {
	case west: {WF_L_BLU getVariable "wf_commander"};
	case east: {WF_L_OPF getVariable "wf_commander"};
	case resistance: {WF_L_GUE getVariable "wf_commander"};
	default {objNull};
}