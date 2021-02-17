params ["_object", "_side"];
private ["_height", "_markerName", "_markerText", "_currentUpgrades"];

waitUntil {!isNil "unitMarker"};

unitMarker = unitMarker + 1;
_markerName = Format ["unitMarker%1",unitMarker];

createMarkerLocal [_markerName,[0,0,0]];
_markerName setMarkerTypeLocal "mil_dot";
_markerName setMarkerColorLocal "ColorCIV";
_markerName setMarkerSizeLocal [1,1];
_markerName setMarkerAlphaLocal 0;
_markerText = "";

_currentUpgrades = (WF_Client_SideJoined) Call WFCO_FNC_GetSideUpgrades;
if((_currentUpgrades # WF_UP_AAR1) > 0 ) then {
	_markerText = getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName");	
};
_markerName setMarkerTextLocal _markerText;

_height = missionNamespace getVariable "WF_C_STRUCTURES_ANTIAIRRADAR_DETECTION";

while {alive _object && !(isNull _object)} do {
	if (antiAirRadarInRange) then {
		if (((getPos _object) # 2) > _height) then {
			if(_markerText == "") then {
				_currentUpgrades = (WF_Client_SideJoined) Call WFCO_FNC_GetSideUpgrades;
				if((_currentUpgrades # WF_UP_AAR1) > 0 ) then {
					_markerText = getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName");	
				};
				_markerName setMarkerTextLocal _markerText;
			};
			_markerName setMarkerAlphaLocal 1;
			_markerName setMarkerPosLocal (getPos _object);
		} else {
			_markerName setMarkerAlphaLocal 0;
		};
	} else {
		_markerName setMarkerAlphaLocal 0;
	};
	
	sleep 1;
};

deleteMarkerLocal _markerName;