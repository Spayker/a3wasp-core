params ["_pos","_side"];
private ["_object","_gridmarkers","_col","_px","_py","_nam","_buildings","_artyRadarInRange","_radar_range"];

if(_side == side player)then{
	_startAlpha = 0.6;
	_col = "ColorRed";
	_radar_range = missionNamespace getVariable "WF_C_STRUCTURES_ANTIARTYRADAR_DETECTION";

	_buildings = (WF_Client_SideJoined) Call WFCO_FNC_GetSideStructures;
	_artyRadarInRange = !(isNull (['ArtyRadarTYPE',_buildings,_radar_range,WF_Client_SideJoined,player] Call WFCO_FNC_BuildingInRange));

	if (antiArtyRadarInRange) then {
		if (_artyRadarInRange) then {
			
			_px = floor ( (_pos # 0) / 100);
			_py = floor ( (_pos # 1) / 100);
			_nam = format["grid_%1_%2",_px,_py];

			
			createMarkerLocal[_nam,[(_px*100)+50,(_py*100)+50,0]];
			_nam setMarkerShapeLocal "RECTANGLE";
			_nam setMarkerSizeLocal [150,150];
			_nam setMarkerColorLocal _col;
			_nam setMarkerAlphaLocal _startAlpha;
			
			sleep 75;		
			deleteMarkerLocal _nam;
		};
	};
};