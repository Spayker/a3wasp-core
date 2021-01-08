params ['_unit', '_side'];

//--AAR Tracking--
if (WF_Client_SideJoined != _side) then { //--- Track the unit via AAR System, skip if the unit side is the same as the player one.
    [_unit, _side] spawn WFCO_FNC_trackAirTargets;

    //--AAR Upgrade > 1--
    _drawAirIconEH = addMissionEventHandler ["Draw3D", {
        _object = missionNamespace getVariable [format["unitForDraw3D%1", _thisEventHandler], objNull];

        if(!isNull _object && antiAirRadarInRange) then {
            _currentUpgrades = (WF_Client_SideJoined) call WFCO_FNC_GetSideUpgrades;
            _curARRLevel = _currentUpgrades # WF_UP_AAR1;

            //--If AAR Upgrade level is > 1 then drawIcon3D--
            if(_curARRLevel > 1) then {
                _height = missionNamespace getVariable "WF_C_STRUCTURES_ANTIAIRRADAR_DETECTION";
                if (((getPos _object) # 2) > _height) then {
                    _pos = ASLToAGL getPosASL _object;
                    _vehName = getText (configFile >> "CfgVehicles" >> typeOf _object >> "displayName");
                    _showArrow = false;

                    //--If AAR Upgrade level is > 2 then show arrow in screen edges and show distance--
                    if(_curARRLevel > 2) then {
                        _showArrow = true;
                        _vehName = format["%1 [%2]", _vehName, player distance _object];
                    };
                    drawIcon3D [getText (configFile >> "CfgVehicles" >> typeOf _object >> "icon"),
                    [0.3,0.3,0.5,1], _pos, 0.8, 0.8, getDir _object, _vehName, 1, 0.03, "TahomaB", "", _showArrow]
                }
            }
        };

        if(!alive _object) then { removeMissionEventHandler ["Draw3D", _thisEventHandler] }
    }];
    missionNamespace setVariable [format["unitForDraw3D%1", _drawAirIconEH], _unit]
}