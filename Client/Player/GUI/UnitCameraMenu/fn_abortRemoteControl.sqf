params ["_unit"];

objNull remoteControl _unit;

if(cameraOn == (vehicle _unit)) then {
    player switchCamera "Internal";
};

missionNamespace setVariable ["wf_remote_ctrl_unit", nil];
waitUntil {!isNull (findDisplay 46)};

(findDisplay 46) displayRemoveEventHandler ["KeyDown", missionNamespace getVariable ["wf_remote_ctrl_displayEH", -1]];

