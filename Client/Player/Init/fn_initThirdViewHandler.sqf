waituntil {!(IsNull (findDisplay 46))};

if(WF_C_GAMEPLAY_THIRDVIEW == 0) then {
player addEventHandler ["GetOutMan", {
    params ["_unit"];
    if (cameraOn == _unit && cameraView == "EXTERNAL") then {
            _unit switchCamera "INTERNAL"
        }
}];
(findDisplay 46) displayAddEventHandler ["KeyDown", {
    params ["_displayorcontrol", "_key"];

    if (isNull objectParent player) then {
        if (_key in actionKeys "curatorPersonView") then {
            [format["%1", localize "STR_WF_GAMEPLAY_THIRDVIEW_MESSAGE"]] spawn WFCL_fnc_handleMessage;
            true
        };
    };
}];} else {
    player addEventHandler ["GetOutMan", {
        params ["_unit"];
        if (cameraOn == _unit && cameraView == "GROUP") then {
            _unit switchCamera "EXTERNAL"
        }
    }];

    (findDisplay 46) displayAddEventHandler ["KeyDown", {
        params ["_displayorcontrol", "_key"];

        if (_key in actionKeys "tacticalView") then {
            [format["%1", localize "STR_WF_GAMEPLAY_TACTICALVIEW_MESSAGE"]] spawn WFCL_fnc_handleMessage;
            true
        }

    }]
}



