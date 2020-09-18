Private ["_funds"];

if (isNull _this) exitWith {0};

_funds = (_this getVariable "wf_funds");
if (isNil '_funds') exitWith {0};
_funds