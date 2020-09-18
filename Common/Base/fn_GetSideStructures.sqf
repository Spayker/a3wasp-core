/*
	Return a side's structures.
	 Parameters:
		- Side.
*/

switch (_this) do {
	case west: {WF_L_BLU getVariable "wf_structures"};
	case east: {WF_L_OPF getVariable "wf_structures"};
	case resistance: {WF_L_GUE getVariable "wf_structures"};
	default {objNull};
}