params ["_unit"];
private ["_unit"];

if (count(vehicle _unit nearEntities [["Car","Air","Tank","Ship"], 4]) > 0) then {
	WF_SHOW_FAST_REPAIR_ACTION = true
} else {
	WF_SHOW_FAST_REPAIR_ACTION = false
};