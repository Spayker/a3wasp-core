/*
	Give a simple order to a team.
	 Parameters:
		- Team.
		- Destination.
		- WP Kind.
		- {Radius}.
*/

private ["_formations"];
params ["_team", "_destination", "_mission", ["_radius", 30]];

[_team,true,[[_destination, _mission, _radius, 20, [], [], []]]] Call WFCO_FNC_WaypointsAdd;