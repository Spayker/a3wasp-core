Private ["_income","_incomeCoef","_incomeSystem","_side"];
_side = (_this) Call WFCO_FNC_GetSideID;

_income = 0;
_incomeCoef = 0;

{
    _townSpecialities = _x getVariable "townSpeciality";
    if (isNil "_townSpecialities") then {
        if(((_x getVariable "sideID") == _side)) then {
            _income = _income + (_x getVariable "supplyValue")
        }
    } else {
    if((count _townSpecialities == 0) && ((_x getVariable "sideID") == _side)) then {
		_income = _income + (_x getVariable "supplyValue")
    }
    }
} forEach towns;

_income