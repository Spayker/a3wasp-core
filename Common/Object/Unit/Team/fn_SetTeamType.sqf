Private['_idtype','_team'];

_team = _this select 0;
_idtype = _this select 1;

if (isNull _team) exitWith {};

_team setVariable ["wf_teamtype", _idtype, true];