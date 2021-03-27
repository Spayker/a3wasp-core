Private ["_income","_incomeCoef","_incomeSystem","_side"];
_sideId = (_this) Call WFCO_FNC_GetSideID;

_income = 0;
_incomeCoef = 0;

{
    _townSpecialities = _x getVariable "townSpeciality";
    _townSideId = _x getVariable "sideID";
    _townSupplyValue = _x getVariable "supplyValue";
    _keepProcessingFlag = true;

    if(_sideId == WF_DEFENDER_ID && _townSideId == _sideId) then {
        _resFaction = _x getVariable ['resFaction', WF_DEFENDER_GUER_FACTION];
        if(_resFaction == WF_DEFENDER_CDF_FACTION) then {
            _keepProcessingFlag = false;
        }
    };

    if(_keepProcessingFlag) then {
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