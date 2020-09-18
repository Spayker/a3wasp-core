/*
	Global Airport Initialization, this file initialize the airports.
*/

Private ["_airport","_airports"];

//--- Get all of the city logics.
_airports = [0,0,0] nearEntities [["LocationEvacPoint_F"], 100000];

_i = 0;
{
	if (isServer) then {
		//--- Create the airport model.
		_airport = (missionNamespace getVariable "WF_C_HANGAR") createVehicle (getPos _x);
		_airport setDir ((getDir _x) + (missionNamespace getVariable "WF_C_HANGAR_RDIR"));
		_airport setPos (getPos _x);
		
		//--- Link the airport to the logic.
		_x setVariable ["wf_hangar", _airport, true];
	};
	
	if (local player) then {
		_marker = createMarkerLocal [Format ["wf_airport_%1", _i], getPos _x];
		_marker setMarkerTypeLocal "mil_triangle";
		_marker setMarkerColorLocal "ColorYellow";
		_i = _i + 1;
	};
} forEach _airports;