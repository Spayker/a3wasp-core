params ["_side", ["_shallDropCommanderInfo", false]];
private ['_winnerSideId', '_town', '_townSideId', '_color', '_townMarker', '_friendlyUnits'];

_sideId = _side Call WFCO_FNC_GetSideID;

{
    _town = _x;
    _townSideId = _town getVariable "sideID";

    if (_townSideId == _sideId) then {
        _color = missionNamespace getVariable (Format ["WF_C_%1_COLOR", _side]);
        _townMarker = Format ["WF_%1_CityMarker", _town getVariable "name"];
        _townMarker setMarkerColorLocal _color;

        _camps = _town getVariable "camps";
        {
            (_x getVariable "wf_camp_marker") setMarkerColorLocal _color
        } forEach _camps;

        _friendlyUnits = [];
        {if ((side _x) == _side) then {_friendlyUnits pushBackUnique _x}} forEach allUnits;

        ["TownUpdate", _town] Spawn WFCL_FNC_TaskSystem
    }
} forEach towns;

_hqs = (_side) call WFCO_FNC_GetSideHQ;
{
    [_x,true,_sideId] call WFCL_fnc_initBaseStructure
} forEach _hqs;

_structures = (_side) call WFCO_FNC_GetSideStructures;
{
    [_x,false,_sideId] call WFCL_fnc_initBaseStructure
} forEach _structures;

if(_shallDropCommanderInfo) then { commanderTeam = objNull }
