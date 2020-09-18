Private["_assist","_bounty","_get","_name","_type"];


_killed = _this select 0;
_name = name _killed;

_bounty = 100;//if (score _killed < 0) then {100} else {100+11*(score _killed)};
(_bounty) Call WFCL_FNC_ChangePlayerFunds;

[_bounty, _name] spawn WFCL_FNC_showAwardHint