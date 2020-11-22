Params ["_destination","_index","_logik","_units"];
Private ["_count","_destination","_index","_type","_units","_logik"];

_type = ((missionNamespace getVariable Format ['WF_%1_ARTILLERY_CLASSNAMES', WF_Client_SideJoinedText]) # _index) find (typeOf (_units # 0));
if (count _units < 1 || _type < 0) exitWith { [format ["%1", localize "STR_WF_INFO_NoArty"]] spawn WFCL_fnc_handleMessage };

{
    _unit = _x;
    if (isPlayer (leader (group _unit))) then {
        [_unit, _destination, WF_Client_SideJoined, artyRange] Spawn WFCO_FNC_FireArtillery
    } else {
        [[_unit], _destination, WF_Client_SideJoined, artyRange] remoteExecCall ["WFSE_fnc_fireRemoteArtillery",2]
    }
} forEach _units;

[_units, _destination, artyRange] remoteExecCall ["WFSE_fnc_calculateArtyDamage",2];