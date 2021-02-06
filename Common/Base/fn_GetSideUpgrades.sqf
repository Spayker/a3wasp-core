/*
	Return a side's HQ.
	 Parameters:
		- Side.
*/

switch (_this) do {
	case west: {WF_L_BLU getVariable ["wf_upgrades", []]};
	case east: {WF_L_OPF getVariable ["wf_upgrades", []]};
	case resistance: {WF_L_GUE getVariable ["wf_upgrades", []]};
	default { 
				private _upgrades = [];
				{
					_upgrades pushBack 0;
				} forEach (missionNamespace getVariable ["WF_C_UPGRADES_WEST_LEVELS", [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]);
				
				_upgrades
			};
}