Private ['_team','_z'];
_team = _this;

for [{_z = (count (waypoints _team))-1},{_z > -1},{_z = _z - 1}] do {
	deleteWaypoint [_team, _z];
};