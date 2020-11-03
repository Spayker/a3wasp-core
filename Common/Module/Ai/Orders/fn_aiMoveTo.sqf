Private ["_destination","_formations","_mission","_radius","_team","_update"];
params ["_team", "_destination", "_mission", ["_radius", 30], ["_formation", 'DIAMOND']];
_team setCombatMode "RED";
_team setBehaviour "COMBAT";
_team setFormation _formation;
_team setSpeedMode "NORMAL";

["INFORMATION", Format ["AI_MoveTo.sqf: [%1] Team [%2] is heading to [%3].", side _team,_team,_destination]] Call WFCO_FNC_LogContent;

[_team,true,[ [_destination, _mission, _radius, 20, "", []] ]] Call WFCO_fnc_aiWpAdd;