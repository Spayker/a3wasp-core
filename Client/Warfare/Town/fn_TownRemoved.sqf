params ["_townName", ["_camps", []]];

towns = towns - [objNull];
_townMarker = Format ["WF_%1_CityMarker", _townName];
deleteMarkerLocal _townMarker;
deleteMarkerLocal (Format ["WF_%1_CityMarker_Rearm", _townName]);
deleteMarkerLocal (Format ["WF_%1_CityMarker_Repair", _townName]);
deleteMarkerLocal (Format ["WF_%1_CityMarker_Refuel", _townName]);
deleteMarkerLocal (Format ["WF_%1_CityMarker_Heal", _townName]);

{ deleteMarkerLocal (_x getVariable "wf_camp_marker") } forEach _camps

