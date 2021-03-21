/*
	Return a side's HQ.
	 Parameters:
		- Side.
*/

switch (_this) do {
	case west: {WF_L_BLU getVariable ["wf_hq", []]};
	case east: {WF_L_OPF getVariable ["wf_hq", []]};
	case resistance: {WF_L_GUE getVariable ["wf_hq", []]};
	default {[]};
}