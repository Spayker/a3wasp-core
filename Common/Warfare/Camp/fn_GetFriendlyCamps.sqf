private["_add","_camp","_count","_friendlyCamps","_sideID"];
params["_town", "_side", ["_lives", false]];

_sideID = _side Call WFCO_FNC_GetSideID;
_friendlyCamps = [];

{
	if ((_x getVariable "sideID") == _sideID) then {
		_add = true;
		if (_lives) then {if (isObjectHidden _x) then {_add = false}};
		if (_add) then {_friendlyCamps pushBack _x};
	};
} forEach (_town getVariable "camps");
_friendlyCamps