private["_tcarm","_units"];

_tcarm = missionNamespace getVariable "WF_C_PLAYERS_MARKER_TOWN_RANGE";

while {!WF_GameOver} do {
	_units = (Units Group player) Call WFCO_FNC_GetLiveUnits;

	{
		_town = _x;
		_range = (_town getVariable "range") * _tcarm;
		_visible = false;
		if ((_town getVariable "sideID") == sideID) then {_visible = true} else {{if (_town distance _x < _range) then {_visible = true}} forEach _units};
		_marker = Format ["WF_%1_CityMarker", _town getVariable "name"];
		_townSpecialities = _town getVariable "townSpeciality";

	    if (_visible) then {

            if !(isNil "_townspecialities") then {
            if (WF_C_MILITARY_BASE in (_townSpecialities)) exitWith { _marker setMarkerTextLocal Format["%1 AC: -15%2", _town getVariable "name", "%"] };

            if (WF_C_RADAR in (_townSpecialities)) exitWith { _marker setMarkerTextLocal Format["%1 CC", _town getVariable "name"] };

                if (WF_C_MINE in (_townSpecialities)) exitWith { _marker setMarkerTextLocal (_x getVariable "name") }
            };
            _marker setMarkerTextLocal Format["%1 SV: %2/%3", _town getVariable "name", _town getVariable "supplyValue",_town getVariable "maxSupplyValue"];
		} else {
            if !(isNil "_townspecialities") then {
            if (WF_C_MILITARY_BASE in (_townSpecialities)) exitWith { _marker setMarkerTextLocal Format["%1 AC: -15%2", _town getVariable "name", "%"] };

            if (WF_C_RADAR in (_townSpecialities)) exitWith { _marker setMarkerTextLocal Format["%1 CC", _town getVariable "name"] };

            if (WF_C_MINE in (_townSpecialities)) exitWith { _marker setMarkerTextLocal (_x getVariable "name") };
            };

            _marker setMarkerTextLocal (_town getVariable "name")
	    }
	} forEach towns;
	sleep 5;
};