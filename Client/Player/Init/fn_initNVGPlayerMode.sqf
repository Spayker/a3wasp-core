params ["_displayCode","_keyCode","_isShift","_isCtrl","_isAlt"];
_handled = false;


if ((_keyCode in actionKeys "NightVision")) then {

    switch WF_fullScreenNightVisionMode do {
        case 0: {
            if (cameraView != "GUNNER") then {
                playerHmd = hmd player;
                if(playerHmd in WF_NightVisionDevices) then {
                    player unlinkItem playerHmd;
                    player action ["nvGoggles", player];
                    WF_fullScreenNightVisionMode = currentVisionMode player;
                    _handled = true
                };

            }
        };
        case 1: {
            if (cameraView != "GUNNER") then {
                if(playerHmd in WF_NightVisionDevices) then {
                    player linkItem playerHmd;
                };
                player action ["nvGogglesOff", player];
                WF_fullScreenNightVisionMode = currentVisionMode player;
                _handled = true
            }
        }
    }
};
_handled