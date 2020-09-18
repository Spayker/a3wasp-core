private ["_cost", "_item", "_var"];

_item = _this;

_cost = 0;
_var = missionNamespace getVariable format["wf_%1", _item];
if !(isNil '_var') then { _cost = (_var select 0) select 1 };

_cost