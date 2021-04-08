Private["_sideID","_totalSupply","_camps"];

_sideID = (_this) Call WFCO_FNC_GetSideID;
_totalSupply = 0;

{
    _town = _x;
    _townSideId = _town getVariable "sideID";
    _camps = _town getVariable "camps";
        _townSpecialities = _town getVariable "townSpeciality";

        if(isNil '_townSpecialities') then {
            if ((_townSideId) == _sideID) then	{
                        _totalSupply = _totalSupply + (_town getVariable "supplyValue")
                    }
    } else {
	        if (count _townSpecialities > 0) then {
            {
                    if (_x in WF_C_SECONDARY_SUPPLY_LOCATIONS || _x == WF_C_WAREHOUSE) exitWith {
                        if ((_townSideId) == _sideID) then	{
                        _totalSupply = _totalSupply + (_town getVariable "supplyValue")
                    }
                }
            } forEach _townSpecialities
    } else {
                if ((_townSideId) == _sideID) then	{
            _totalSupply = _totalSupply + (_town getVariable "supplyValue")
        }
    }
    }
} forEach towns;

_totalSupply