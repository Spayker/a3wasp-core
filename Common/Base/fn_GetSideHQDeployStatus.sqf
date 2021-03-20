/*
	Return a side HQ deloy status.
	 Parameters:
		- Side.
*/
params ["_side", "_hq"];

switch (_side) do {
	case west: {_hq getVariable ["wf_hq_deployed", false]};
	case east: {_hq getVariable ["wf_hq_deployed", false]};
	case resistance: {_hq getVariable ["wf_hq_deployed", false]};
	default {false};
}

