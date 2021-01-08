//---[Side specific initialization] (Run on the desired client team).
params ['_unit', '_sideID'];

waitUntil {!isNil 'WF_UNIT_MARKERS'};
waitUntil {!isNil 'sideID'};

if (sideID != _sideID) exitWith {};

_unit_kind = typeOf _unit;
_isMan = (_unit isKindOf 'Man');
_side = (_sideID) call WFCO_FNC_GetSideFromID;

if !(isHeadLessClient) then {

    Private ["_color","_params"];
    //--- Map Marker tracking.
    _color = missionNamespace getVariable (format ["WF_C_%1_COLOR", _side]);
    _params = [];

    unitMarker = unitMarker + 1;
    _markerName = format ["unitMarker%1", unitMarker];

    if (_isMan) then { //--- Man.
        if (group _unit == group player) then {  _color = "ColorOrange" };
        _params = [_unit, _color, (_unit) call WFCO_FNC_GetAIDigit];
    } else { //--- Vehicle.
        if (local _unit && isMultiplayer) then {_color = "ColorOrange"};
        if (_unit_kind in (missionNamespace getVariable ["WF_AMBULANCES", []])) then {_color = "ColorYellow"};//--- Medical.
        _params = [_unit, _color];
        if (_unit_kind == missionNamespace getVariable Format["WF_%1MHQNAME", _side]) then { _params = [_unit, "ColorCIV"] }//--- HQ.
    };

    WF_UNIT_MARKERS pushBack (_params)
}