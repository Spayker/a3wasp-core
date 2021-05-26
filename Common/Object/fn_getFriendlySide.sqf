Private ['_friendlySides', '_friendlySide'];

_friendlySides = WF_Client_Logic getVariable ["wf_friendlySides", []];
_friendlySide = sideUnknown;
{
    if(_x != WF_Client_SideJoined) exitWith { _friendlySide = _x }
} forEach _friendlySides;

_friendlySide