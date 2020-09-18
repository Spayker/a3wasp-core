Private['_movePos','_team'];

_team = _this select 0;
_movePos = _this select 1;

if (isNull _team) exitWith {};

_team setVariable ["wf_teamgoto", _movePos, true];