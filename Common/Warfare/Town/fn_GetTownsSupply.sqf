Params ["_side", "_shallGetMoney"];
Private ["_townSuppluyValue", "_income","_side","_camps"];

_income = 0;
{
    _camps = _x getVariable "camps";
    _townSuppluyValue = _x getVariable "supplyValue";

    if(count _camps > 0) then {
        _sideID = (_side) Call WFCO_FNC_GetSideID;
	    if ((_x getVariable "sideID") == _sideID) then {_income = _income + _townSuppluyValue}
    } else {
        if !(_shallGetMoney) then {
            _townSpeciality = _x getVariable "townSpeciality";
            if(_townSpeciality in WF_C_SECONDARY_SUPPLY_LOCATIONS) then { _income = _income + _townSuppluyValue }
        }
    }
} forEach towns;

_income