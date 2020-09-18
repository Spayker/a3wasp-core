params ["_vehicle"];
private ["_ehDescriptor"];

waitUntil {commonInitComplete};

_ehDescriptor = addMissionEventHandler ["Draw3D", {
        private ["_vehicle", "_color", "_distance", "_icon", "_time", "_pos", "_size"];
        _vehicle = (missionNamespace getVariable format["wf_vehicle_icon%1", _thisEventHandler]) # 0;
        _time = (missionNamespace getVariable format["wf_vehicle_icon%1", _thisEventHandler]) # 1;
    	_distance = player distance _vehicle;

    	if(_distance < 500 && _distance > 9) then {
    	    _pos = ASLToAGL getPosASL _vehicle;
            _pos set[2, (_pos # 2) + 3.75];
            _color = (missionNamespace getVariable format["wf_vehicle_icon%1", _thisEventHandler]) # 2;
            _icon = (missionNamespace getVariable format["wf_vehicle_icon%1", _thisEventHandler]) # 3;
            _size = 1.5;

            drawIcon3D[_icon, _color, _pos, _size, _size, 0, "", true, 0.1, "RobotoCondensed", "", true];
        };

        if(!alive _vehicle || (time - _time) > 90) then {
            missionNamespace setVariable [format["wf_vehicle_icon%1", _thisEventHandler], nil];
        	removeMissionEventHandler ["Draw3D", _thisEventHandler];
        };
    }];

missionNamespace setVariable [format["wf_vehicle_icon%1", _ehDescriptor], [_vehicle, time,
                    WF_C_TITLETEXT_COLOR_INT, "A3\ui_f\data\IGUI\Cfg\simpleTasks\types\car_ca.paa"]];