private["_tcarm","_units"];

_tcarm = missionNamespace getVariable "WF_C_PLAYERS_MARKER_TOWN_RANGE";

while {!WF_GameOver} do {
	_units = (Units Group player) Call WFCO_FNC_GetLiveUnits;
    towns = towns - [objNull];
	{
		_town = _x;
		_townSideId = _town getVariable "sideID";
		_townName = _town getVariable "name";
		_supplyValue = _town getVariable "supplyValue";
		_maxSupplyValue = _town getVariable "maxSupplyValue";
		_range = (_town getVariable "range") * _tcarm;
		_visible = false;

		if (_townSideId == WF_Client_SideID) then {
                    _visible = true
		} else {
		    {
		        if (_town distance _x < _range) then {
		            _visible = true
		        }
		    } forEach _units
		};

		if!(isNil '_townName') then {
		_marker = Format ["WF_%1_CityMarker", _townName];
		_townSpecialities = _town getVariable ["townSpeciality", []];

	    if (_visible) then {
            if (count _townSpecialities == 0) then {
                _marker setMarkerTextLocal Format["%1 S$: %2/%3", _townName, _supplyValue, _maxSupplyValue]
            } else {
                if (WF_C_WAREHOUSE in (_townSpecialities)) then { _marker setMarkerTextLocal Format["%1 S$: %2/%3", _townName, _supplyValue, _maxSupplyValue] };
                    if (WF_C_MILITARY_BASE in (_townSpecialities)) then { _marker setMarkerTextLocal Format["%1 AC: -5%2", _townName, "%"] };
                if (WF_C_PLANT in (_townSpecialities)) then { _marker setMarkerTextLocal Format["%1 SV: %2/%3", _townName, _supplyValue, _maxSupplyValue] };
                if (WF_C_POWER_PLANT in (_townSpecialities)) then { _marker setMarkerTextLocal Format["%1 SV: %2/%3", _townName, _supplyValue, _maxSupplyValue] };
                if (WF_C_LUMBER_MILL in (_townSpecialities)) then { _marker setMarkerTextLocal Format["%1 SV: %2/%3", _townName, _supplyValue, _maxSupplyValue] }
            }
		} else {
            if (count _townSpecialities == 0) then {
                _marker setMarkerTextLocal (_townName)
		} else {
                    if (WF_C_MILITARY_BASE in (_townSpecialities)) then { _marker setMarkerTextLocal Format["%1 AC: -5%2", _townName, "%"] };

                if (WF_C_MINE in (_townSpecialities)) then { _marker setMarkerTextLocal (_townName) }
            }
	    }
		}
	} forEach towns;
	sleep 5;
};