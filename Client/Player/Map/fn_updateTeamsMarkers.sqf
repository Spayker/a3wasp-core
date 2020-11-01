private["_sideText","_label","_count"];

_sideText = WF_Client_SideJoinedText;
_markerType = "b_inf";
_maxPlayersInTeam = WF_MAXPLAYERS_IN_TEAM;
_shallTrackPlayers = missionNamespace getVariable ["WF_C_UNITS_TRACK_LEADERS", 0];

while {!WF_GameOver} do {

    if(_shallTrackPlayers > 0) then {
        deleteMarkerLocal "";
        _label = "";

        WF_Client_Teams = missionNamespace getVariable Format['WF_%1TEAMS',WF_Client_SideJoined];
        WF_Client_Teams = WF_Client_Teams - [grpNull];
        WF_Client_Teams_Count = count WF_Client_Teams;
        _count = 1;

        for "_i" from 1 to _maxPlayersInTeam do {
            _markerToRemove = Format["%1AdvancedSquad%2Marker",_sideText,_i];
            deleteMarkerLocal _markerToRemove
        };

	    {
		    _marker = Format["%1AdvancedSquad%2Marker",_sideText,_count];

            if (alive (leader _x)) then {
                _label = "";
                if (isPlayer (leader _x)) then {
                    _marker = Format["%1AdvancedSquad%2Marker",_sideText,_count];
                    createMarkerLocal [_marker,[0,0,0]];
                    _marker setMarkerTypeLocal _markerType;
                    if(WF_C_PARAMETER_COLORATION == 1) then {
                        if(side player == west) then {
                                _marker setMarkerColorLocal (missionNamespace getVariable "WF_C_WEST_COLOR")
                            } else {
                                _marker setMarkerColorLocal (missionNamespace getVariable "WF_C_EAST_COLOR")
                            }
                        } else {
                            _marker setMarkerColorLocal "ColorBlue"
                        };
                    _marker setMarkerSizeLocal [1,1];
                    _label = Format["%1 [%2]",name (leader _x),_count];
                    _marker setMarkerTextLocal _label;
                    _marker setMarkerPosLocal GetPos (leader _x);
                        _marker setMarkerAlphaLocal 1
			    } else {
				    deleteMarkerLocal _marker
                };
            } else {
                deleteMarkerLocal _marker
            };
            _count = _count + 1
        } forEach WF_Client_Teams
    };

	_unitMarkers = WF_UNIT_MARKERS;
    {
        _markerName = _x # 0;
        _tracked = _x # 1;
        _trackDeath = _x # 2;
        _deathMarkerType = _x # 3;
        _deathMarkerColor = _x # 4;
        _deathMarkerSize = _x # 5;

        if(isNull _tracked) then {
            deleteMarkerLocal _markerName;
            WF_UNIT_MARKERS set [_forEachIndex, objNull];
        } else {
            _markerName setMarkerPosLocal (getPos _tracked);
            if(!alive _tracked) then {
                if (_trackDeath) then {
                    [_markerName, _deathMarkerType, _deathMarkerColor, _deathMarkerSize] spawn {
                        params ["_markerName", "_deathMarkerType", "_deathMarkerColor", "_deathMarkerSize"];
                        _markerName setMarkerTypeLocal _deathMarkerType;
                        _markerName setMarkerColorLocal _deathMarkerColor;
                        _markerName setMarkerSizeLocal _deathMarkerSize;
                        sleep (missionNamespace getVariable "WF_C_PLAYERS_MARKER_DEAD_DELAY");
                        deleteMarkerLocal _markerName;
                    };
                } else {
                    deleteMarkerLocal _markerName;
                };
                WF_UNIT_MARKERS set [_forEachIndex, objNull];
            };
        };
    } forEach _unitMarkers;

    WF_UNIT_MARKERS = WF_UNIT_MARKERS - [objNull];

	sleep 3
}