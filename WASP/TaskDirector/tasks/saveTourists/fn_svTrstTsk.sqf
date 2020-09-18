params ["_stage", "_side", "_twn", "_twnPos", "_bldPos", "_name", "_coords"];

switch (_stage) do {
    case 0: {
        [player, format ["DlrTrstTwn%1", getPlayerUID player], [format [localize"STR_WF_M_DeliverTouristTownDesc", _twn],
            localize "STR_WF_M_DeliverTouristTownTitle", "Attack"], _twnPos,
            "CREATED", 0, true, "Attack", true] call BIS_fnc_taskCreate;
    };

    case 1: {
        [format ["DlrTrstTwn%1", getPlayerUID player], "SUCCEEDED"] call BIS_fnc_taskSetState;
    };

    case 2: {
        [[format ["SvTrts%1", getPlayerUID player], format ["DlrTrstTwn%1", getPlayerUID player]], player,
            [localize "STR_WF_M_DeliverTouristTalk", localize "STR_WF_M_DeliverTouristTalkTitle", "Listen"],
            _twnPos, "CREATED", 0, true, true, "Listen", true] call BIS_fnc_setTask;
    };

    case 3: {
        [format ["SvTrts%1", getPlayerUID player], "SUCCEEDED"] call BIS_fnc_taskSetState;
    };

    case 4: {
        [[format ["SvTrts1%1", getPlayerUID player], format ["SvTrts%1", getPlayerUID player]], player,
            [localize "STR_WF_M_DeliverTouristGiveSupport", localize "STR_WF_M_DeliverTouristGiveSupportTitle", "Getin"],
            _bldPos, "CREATED", 0, true, true, "Getin", true] call BIS_fnc_setTask;
    };

    case 5: {
        [format ["SvTrts1%1", getPlayerUID player], "FAILED"] call BIS_fnc_taskSetState;
    };

    case 6: {
        [format ["SvTrts1%1", getPlayerUID player], [format [localize "STR_WF_M_DeliverTouristOneOrMoreDown", _name],
            localize "STR_WF_M_DeliverTouristTalkTitle", "" ]] call BIS_fnc_taskSetDescription;
    };

    case 7: {
        [format ["SvTrts1%1", getPlayerUID player], "SUCCEEDED"] call BIS_fnc_taskSetState;
    };

    case 8: {
        [format ["SvTrts%1", getPlayerUID player], "FAILED"] call BIS_fnc_taskSetState;
    };

    case 9: {
        [format ["SvTrts%1", getPlayerUID player], [format [localize "STR_WF_M_DeliverTouristOneOrMoreDown", _name],
            localize "STR_WF_M_DeliverTouristTalkTitle", "" ]] call BIS_fnc_taskSetDescription;
    };

    case 10: {
        [format ["DlrTrstTwn%1", getPlayerUID player], "FAILED"] call BIS_fnc_taskSetState;
    };

    case 11: {
        [format ["DlrTrstTwn%1", getPlayerUID player], [format [localize "STR_WF_M_DeliverTouristTownLost", _twn],
            format ["%1 [%2]", localize "STR_WF_M_DeliverTouristTownTitle", toUpper (localize "STR_Failed")],
            "Danger"]] call BIS_fnc_taskSetDescription;
    };

    case 12: {
        [player, format ["DlrTstBtLst%1", getPlayerUID player], [format [localize"STR_WF_M_DeliverTouristBountyLost", _twn],
            localize "STR_WF_M_InterceptingInformers", "Attack"], _twnPos,
            "CREATED", 0, true, "Scout", false] call BIS_fnc_taskCreate;
    };

    case 13: {
        [format ["DlrTstBtLst%1", getPlayerUID player], "SUCCEEDED"] call BIS_fnc_taskSetState;
    };

    case 14: {
        _markerColor = "ColorBlue";

        if(_side == WEST) then {
            _markerColor = "ColorRed";
        };

        _marker = createMarkerLocal [format["enemySPFor%1", _side], _coords];
        _marker setMarkerTypeLocal "hd_pickup";
        _marker setMarkerColorLocal _markerColor;
        _marker setMarkerAlphaLocal 1;
        _marker setMarkerTextLocal format["%1 start position", if(_side == WEST) then { EAST } else { WEST }];

        private _svTourists1Desc = format ["SvTrts1%1", getPlayerUID player] call BIS_fnc_taskDescription;
        [format ["SvTrts1%1", getPlayerUID player], [format ["%1 %2", (_svTourists1Desc # 0) # 0,
            format [" %1: <marker name='%4'>%2 %3</marker>", localize "STR_WF_M_EnemyStartPos",
            (_coords # 0) / 10, (_coords # 1) / 10, format["enemySPFor%1", _side]]],
            (_svTourists1Desc # 1) # 0, (_svTourists1Desc # 2) # 0]] call BIS_fnc_taskSetDescription;

        _svTourists1Desc = format ["DlrTrstTwn%1", getPlayerUID player] call BIS_fnc_taskDescription;
        [format ["DlrTrstTwn%1", getPlayerUID player], [format ["%1 %2", (_svTourists1Desc # 0) # 0,
        format [" %1: <marker name='%4'>%2 %3</marker>", localize "STR_WF_M_EnemyStartPos",
        (_coords # 0) / 10, (_coords # 1) / 10, format["enemySPFor%1", _side]]], (_svTourists1Desc # 1) # 0,
        (_svTourists1Desc # 2) # 0]] call BIS_fnc_taskSetDescription;
    }
};