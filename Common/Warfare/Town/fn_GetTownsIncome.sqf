Private ["_income","_incomeCoef","_incomeSystem","_side"];
_sideId = (_this) Call WFCO_FNC_GetSideID;

_income = 0;
_incomeCoef = 0;

{
    _townSpecialities = _x getVariable "townSpeciality";
    _townSideId = _x getVariable "sideID";
    _townSupplyValue = _x getVariable "supplyValue";

    _shallProceed = true;
    if(isNil '_townSideId' || isNil '_townSupplyValue') then { _shallProceed = false };

    if(_shallProceed) then {
    if (isNil "_townSpecialities") then {
            if((_townSideId == _sideId)) then {
                _income = _income + _townSupplyValue
        }
    } else {
            if((count _townSpecialities == 0) && (_townSideId == _sideId)) then {
                _income = _income + _townSupplyValue
            }
    }
    }
} forEach towns;

_income