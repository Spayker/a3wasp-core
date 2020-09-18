[] spawn {

	waitUntil {!(isNull player)};	
	waituntil {!(isNull (findDisplay 46))};
	(FindDisplay 46) displayAddEventHandler ["keydown","_this call WFCL_FNC_doKeyDown"];
	
};