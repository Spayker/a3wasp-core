Params ["_side", "_shallGetMoney"];
Private ["_townSuppluyValue", "_income","_side","_camps"];

_income = 0;
{
    _townSpeciality = _x getVariable ["townSpeciality", []];
    _townSuppluyValue = _x getVariable "supplyValue";
    _townSideId = _x getVariable "sideID";

    _sideID = (_side) Call WFCO_FNC_GetSideID;

    if (_townSideId == _sideID) then {

        if (_townSideId == WF_DEFENDER_ID) then {
            _resFaction = _x getVariable ["resFaction", WF_DEFENDER_CDF_FACTION];
            if(_resFaction == WF_DEFENDER_GUER_FACTION) then {
        if (_shallGetMoney) then {
            if(count _townSpeciality == 0) then { _income = _income + _townSuppluyValue }
        } else {
            if(count _townSpeciality == 0) then {
                _income = _income + _townSuppluyValue
    } else {
                if(((_townSpeciality # 0) in WF_C_SECONDARY_SUPPLY_LOCATIONS) || ((_townSpeciality # 0) == WF_C_WAREHOUSE)) then {
                    _income = _income + _townSuppluyValue
                }
            }
        }
    }
        } else {
            if (_shallGetMoney) then {
                if(count _townSpeciality == 0) then { _income = _income + _townSuppluyValue }
            } else {
                if(count _townSpeciality == 0) then {
                    _income = _income + _townSuppluyValue
                } else {
                    if(((_townSpeciality # 0) in WF_C_SECONDARY_SUPPLY_LOCATIONS) || ((_townSpeciality # 0) == WF_C_WAREHOUSE)) then {
                        _income = _income + _townSuppluyValue
                    }
                }
            }
        }
    }
} forEach towns;

_income