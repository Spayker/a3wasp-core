/*
	Remove a team's waypoints.
	 Parameters:
		- Team.
*/

Private ['_team'];

_team = _this;

for '_z' from (count (waypoints _team))-1 to 0 step -1 do {
	deleteWaypoint [_team, _z];
};