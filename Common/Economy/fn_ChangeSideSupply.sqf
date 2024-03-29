Params ['_side', ['_amount', 0]];
Private ['_amount','_change','_currentSupply','_side'];

_maxSupplyLimit = WF_C_MAX_ECONOMY_SUPPLY_LIMIT;

_currentSupply = (_side) Call WFCO_FNC_GetSideSupply;
if (isNil '_currentSupply') then {_currentSupply = 0};
_change = _currentSupply + _amount;
if (_change < 0) then {_change = _currentSupply - _amount};
if (_change >= _maxSupplyLimit) then {_change = _maxSupplyLimit};

(_side Call WFCO_FNC_GetSideLogic) setVariable ["wf_supply", _change, true];