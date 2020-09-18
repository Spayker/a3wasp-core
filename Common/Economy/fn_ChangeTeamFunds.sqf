params ["_team", "_amount"];

if (!isNull _team) then {
    _finalSum = (_team getVariable "wf_funds") + _amount;
    _team setVariable ["wf_funds", _finalSum, true];
    (leader _team) setVariable ["wf_funds", _finalSum, true];
};