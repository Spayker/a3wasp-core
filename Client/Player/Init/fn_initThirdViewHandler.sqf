waituntil {!(IsNull (findDisplay 46))};

player addEventHandler ["GetOutMan", {
    params ["_unit"];
    if (cameraOn == _unit && cameraView == "EXTERNAL") then {
        _unit switchCamera "INTERNAL";
    };
}];

(findDisplay 46) displayAddEventHandler ["KeyDown", {
    params ["_displayorcontrol", "_key"];

    if (isNull objectParent player) then {
        if (_key in actionKeys "curatorPersonView") then {
            [format["%1", localize "STR_WF_GAMEPLAY_THIRDVIEW_MESSAGE"]] spawn WFCL_fnc_handleMessage;
            true
        };
    };
}];