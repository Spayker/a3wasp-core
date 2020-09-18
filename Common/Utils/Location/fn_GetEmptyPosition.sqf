/*
	Return an empty 'safe' position.
	 Parameters:
		- Position (Object / Position).
		- Radius.
*/
Params["_object", "_radius", ["_nearPlayerAffected", false]];
Private ["_i" ,"_object", "_position", "_tpos"];


if (typeName _object == "OBJECT") then {_object = getPos _object};

_position = [(_object select 0)+5,(_object select 1)+5,0];
_i = 0;

while {_i < 1000} do {
	_tpos = [(_object select 0)+(_radius - (random (_radius * 2))),(_object select 1)+(_radius - (random (_radius * 2))),0];
	if (count (_tpos isFlatEmpty [15, 0, 2, 10, 0, false, objNull]) > 0 && (_tpos nearEntities 7) isEqualTo []) then {
	    if (_nearPlayerAffected) then {
	        if (allPlayers findIf { _x distance _tpos < 250 } == -1) exitWith { _position = _tpos }
	    };
	    if !(_nearPlayerAffected) exitWith { _position = _tpos }
	};
	_i = _i + 1
};

_position