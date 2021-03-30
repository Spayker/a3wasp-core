/*
	Remove a team's waypoints.
	 Parameters:
		- Team.
*/

Private ['_group'];

_group = _this;

for '_z' from (count (waypoints _group))-1 to 0 step -1 do {
	deleteWaypoint [_group, _z];
};