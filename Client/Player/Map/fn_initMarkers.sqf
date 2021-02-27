/*
	Client towns markers initialization.
*/

{
	Private ["_townColor", "_townMarker", "_townSide"];

	//--- Wait for the sideID to be initialized.
	waitUntil {!isNil {_x getVariable "sideID"}};
	_townSide = _x getVariable "sideID";
	_camps = _x getVariable ["camps", []];
	
	//--- Determine the coloration method.
	_townColor = missionNamespace getVariable "WF_C_UNKNOWN_COLOR";
	if (_townSide == WF_Client_SideID) then {
		_townColor = missionNamespace getVariable (Format ["WF_C_%1_COLOR",(_townSide) Call WFCO_FNC_GetSideFromID]);
	};

	//--- Get town speciality
	_townSpeciality = _x getVariable ["townSpeciality", []];

	//--- Place a marker over the logic.
	_townMarker = Format ["WF_%1_CityMarker", _x getVariable "name"];
	createMarkerLocal [_townMarker, getPos _x];
    _townMarker setMarkerTextLocal (_x getVariable "name");


    _townMarker setMarkerTypeLocal "n_unknown";

    if (WF_C_PORT in _townSpeciality) then { _townMarker setMarkerTypeLocal "n_naval" };

    if (WF_C_AIR_BASE in _townSpeciality) then { _townMarker setMarkerTypeLocal "c_plane" };

    if (WF_C_MILITARY_BASE in _townSpeciality) then { _townMarker setMarkerTypeLocal "loc_WaterTower" };

    if (WF_C_WAREHOUSE in _townSpeciality) then { _townMarker setMarkerTypeLocal "n_installation" };

    if (WF_C_PLANT in _townSpeciality || WF_C_POWER_PLANT in _townSpeciality) then { _townMarker setMarkerTypeLocal "loc_Power" };

	_townMarker setMarkerColorLocal _townColor;

	//--- The town may have some camps.
	{
		Private ["_campColor","_campMarker","_campSide"];
		_campSideId = _x getVariable "sideID";
		
		// --- Determine the coloration method.
		_campColor = missionNamespace getVariable "WF_C_UNKNOWN_COLOR";
		if (_campSideId == WF_Client_SideID) then {
			_campColor = missionNamespace getVariable (Format ["WF_C_%1_COLOR",(_campSideId) Call WFCO_FNC_GetSideFromID])
		};

		//--- Place a marker over the logic.
		_campMarker = _x getVariable "wf_camp_marker";
		createMarkerLocal [_campMarker, getPos _x];
		_campMarker setMarkerTypeLocal "o_unknown";
		_campMarker setMarkerColorLocal _campColor;
		_campMarker setMarkerSizeLocal [0.5,0.5];
	} forEach _camps;

	//--- Place service sub markers
	_townServices = _x getVariable "townServices";
	if(count _townServices > 0) then {
	    _townServiceMarkers = [];
	    _rearmServiceExists = false;
	    if(WF_C_TOWNS_SERVICE_REARM in _townServices) then {
	        _townMarkerPos = getPos _x;
	        _rearmMarker = Format ["WF_%1_CityMarker_Rearm", _x getVariable "name"];
            createMarkerLocal [_rearmMarker, [(_townMarkerPos # 0) - 75, (_townMarkerPos # 1) + 100]];
            _rearmMarker setMarkerTypeLocal "n_service";
            _rearmMarker setMarkerColorLocal (missionNamespace getVariable "WF_C_CIV_COLOR");
            _rearmMarker setMarkerSizeLocal [0.5,0.5];
            _townServiceMarkers pushBack _rearmMarker
	    };

	    if(WF_C_TOWNS_SERVICE_REPAIRING in _townServices) then {
	        _townMarkerPos = getPos _x;
            _repairMarker = Format ["WF_%1_CityMarker_Repair", _x getVariable "name"];
            createMarkerLocal [_repairMarker, [(_townMarkerPos # 0) - 75, (_townMarkerPos # 1) + 50]];
            _repairMarker setMarkerTypeLocal "n_maint";
            _repairMarker setMarkerColorLocal (missionNamespace getVariable "WF_C_CIV_COLOR");
            _repairMarker setMarkerSizeLocal [0.5,0.5];
            _townServiceMarkers pushBack _repairMarker
	    };

	    if(WF_C_TOWNS_SERVICE_FUEL in _townServices) then {
            _townMarkerPos = getPos _x;
            _refuelMarker = Format ["WF_%1_CityMarker_Refuel", _x getVariable "name"];
            createMarkerLocal [_refuelMarker, [(_townMarkerPos # 0) - 75, (_townMarkerPos # 1)]];
            _refuelMarker setMarkerTypeLocal "loc_fuelStation";
            _refuelMarker setMarkerColorLocal (missionNamespace getVariable "WF_C_CIV_COLOR");
            _refuelMarker setMarkerSizeLocal [0.5,0.5];
            _townServiceMarkers pushBack _refuelMarker
        };

        if(WF_C_TOWNS_SERVICE_HEAL in _townServices) then {
            _townMarkerPos = getPos _x;
            _healMarker = Format ["WF_%1_CityMarker_Heal", _x getVariable "name"];
            createMarkerLocal [_healMarker, [(_townMarkerPos # 0) - 75, (_townMarkerPos # 1) - 50]];
            _healMarker setMarkerTypeLocal "loc_Hospital";
            _healMarker setMarkerColorLocal (missionNamespace getVariable "WF_C_CIV_COLOR");
            _healMarker setMarkerSizeLocal [0.5,0.5];
            _townServiceMarkers pushBack _healMarker
        };
        _x setVariable ["serviceMarkers", _townServiceMarkers]
	};
} forEach towns;