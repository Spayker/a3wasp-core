Params ["_side", "_shallGetMoney"];
Private ["_townSuppluyValue", "_income","_side","_camps"];

_income = 0;
{
    _townSpeciality = _x getVariable ["townSpeciality", []];
    _townSuppluyValue = _x getVariable "supplyValue";
    _sideID = (_side) Call WFCO_FNC_GetSideID;

    if ((_x getVariable "sideID") == _sideID) then {

        if (_shallGetMoney) then {
            if(count _townSpeciality == 0) then { _income = _income + _townSuppluyValue }
        } else {
            if(count _townSpeciality == 0) then {
                _income = _income + _townSuppluyValue
    } else {
                if((_townSpeciality # 0) in WF_C_SECONDARY_SUPPLY_LOCATIONS) then { _income = _income + _townSuppluyValue }
            }
        }
    }
} forEach towns;

_income