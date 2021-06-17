Private ["_towns"];

//--- Get all of the city objects.
_towns = nearestObjects [[0,0,0], ["Land_BagBunker_Large_F"], 100000];
_hangars = nearestObjects [[0,0,0], ["Land_Ss_hangard"], 100000];
_airBases = [];
{
    _locationSpecialities = _x getVariable "townSpeciality";
    if !(isNil "_locationSpecialities") then {
        if (WF_C_AIR_BASE in _locationSpecialities) then { _airBases pushBack _x }
    }
} forEach _hangars;

_towns = _towns + _airBases;

//--- Await for a proper initialization.
//{
//	waitUntil {!isNil {_x getVariable "wf_inactive"}};
//} forEach _towns;

townInit = true;

["INITIALIZATION", "fn_initTowns.sqf: Towns initialization is done."] Call WFCO_FNC_LogContent;