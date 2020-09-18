waitUntil {commonInitComplete}; //--- Wait for the common part.

if (local player) then {
    params["_structure","_hq","_sideID"];
	private["_color","_marker" ,"_markercc","_text","_type","_side","_voteTime","_radius","_ehDescriptor","_pos","_index"];

	if(isNil "_structure") exitWith {};
	if(isNull _structure) exitWith {};

	_side = (_sideID) Call WFCO_FNC_GetSideFromID;
	_index = (missionNamespace getVariable format ["WF_%1STRUCTURENAMES", str _side]) find (typeOf _structure);
    _radius = missionNameSpace getVariable "WF_C_STRUCTURES_COMMANDCENTER_RANGE";
	waitUntil {clientInitComplete};
	if (_side != WF_Client_SideJoined) exitWith {};

	_marker = Format["BaseMarker%1",buildingMarker];
	buildingMarker = buildingMarker + 1;
	_markercc= Format["CCrange%1",CCMarker];
    CCMarker = CCMarker + 1;
	createMarkerLocal [_marker,getPos _structure];
	if(_structure getVariable ["wf_structure_type", ""] == "CommandCenter") then {
	    createMarkerLocal [_markercc,getPos _structure];
	    _markercc setMarkerBrushLocal "Border";
	    _markercc setMarkerShapeLocal "Ellipse";
        _markercc setMarkerColorLocal "ColorBlack";
        _markercc setMarkerSizeLocal [_radius,_radius];
	};
	_type = "mil_box";
	_color = "ColorBrown";
	if (_hq) then {_type = "b_hq"};
	_marker setMarkerTypeLocal _type;
	_text = "HQ";
	if (!_hq) then {
	    _text = [_structure, _side] Call WFCL_FNC_GetStructureMarkerLabel;_marker setMarkerSizeLocal [0.5,0.5]
	};
	if!(isNil '_text') then {
	    if (_text != "") then {_marker setMarkerTextLocal _text};
	};

	_marker setMarkerColorLocal _color;

    //--Draw 3D icons for base structures--BEGIN----------------------------------------------------------------------//
	//--I think, this is the best way to drawing factories icons: once more EH for each factory--
	//--Because in Draw3D EH you should try to do as little computation as possible--
	//--If you make one EH for all facs you must to do cycle for array of factories--
    _ehDescriptor = addMissionEventHandler ["Draw3D", {
        private ["_site", "_distance", "_pos", "_size", "_color", "_icon", "_maxhealth"];
        _site = (missionNamespace getVariable format["wf_structure_icon%1", _thisEventHandler]) # 0;
    	_distance = player distance _site;

    	if(_distance < WF_C_BASE_HQ_BUILD_RANGE && WF_STRCUCTURES_ICONS) then {
    	    _pos = ASLToAGL getPosASL _site;
            _pos set[2, (_pos # 2) + 5];
            _color = (missionNamespace getVariable format["wf_structure_icon%1", _thisEventHandler]) # 1;
            _icon = (missionNamespace getVariable format["wf_structure_icon%1", _thisEventHandler]) # 2;
            _maxhealth = (missionNamespace getVariable format["wf_structure_icon%1", _thisEventHandler]) # 3;

            if(_distance < 80) then {
                _size = 2 - (_distance / 50);
            } else {
                _size = 0.4;
            };
            drawIcon3D [getMissionPath _icon, _color, _pos, _size, _size, 0, format["%1/%2",
        	        _site getVariable "wf_site_health", _maxhealth], 2, 0.03, "TahomaB"];
        };

        if(!alive _site) then {
            missionNamespace setVariable [format["wf_structure_icon%1", _thisEventHandler], nil];
        	removeMissionEventHandler ["Draw3D", _thisEventHandler];
        };
    }];

    missionNamespace setVariable [format["wf_structure_icon%1", _ehDescriptor], [_structure,
                    [WF_C_TITLETEXT_COLOR_INT # 0, WF_C_TITLETEXT_COLOR_INT # 1, WF_C_TITLETEXT_COLOR_INT # 2,
                    WF_C_TITLETEXT_COLOR_INT # 3 - 0.3],
                    (missionNamespace getVariable format ["WF_%1STRUCTUREICON",str _side]) # _index,
                    (missionNamespace getVariable format ["WF_%1STRUCTUREMAXHEALTH",str _side]) # _index]];
    //--Draw 3D icons for base structures--END------------------------------------------------------------------------//

	waitUntil {!alive _structure};

	deleteMarkerLocal _marker;
	if(_structure getVariable ["wf_structure_type", ""] == "CommandCenter") then {deleteMarkerLocal _markercc};
};