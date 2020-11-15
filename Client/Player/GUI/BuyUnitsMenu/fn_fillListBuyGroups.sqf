params ["_filler", "_listBox", "_value"];
private ['_c','_currentUpgrades','_filter','_i','_u','_value'];

_u = 0;
_i = 0;

_listGroups = missionNamespace getVariable Format["WF_%1AITEAMTEMPLATEDESCRIPTIONS",WF_Client_SideJoined];
_unitClassNames = missionNamespace getVariable Format["WF_%1AITEAMTEMPLATES", WF_Client_SideJoined];
_requiredGroupUpgrades = missionNamespace getVariable Format["WF_%1AITEAMUPGRADES", WF_Client_SideJoined];
_groupTypes = missionNamespace getVariable Format["WF_%1AITEAMTYPES", WF_Client_SideJoined];
_selectedRole = WF_gbl_boughtRoles # 0;

_currentUpgrades = (WF_Client_SideJoined) call WFCO_FNC_GetSideUpgrades;
lnbClear _listBox;

_UpBar = ((WF_Client_SideJoined) call WFCO_FNC_GetSideUpgrades) # WF_UP_BARRACKS;
_UpLight = ((WF_Client_SideJoined) call WFCO_FNC_GetSideUpgrades) # WF_UP_LIGHT;
_UpHeavy = ((WF_Client_SideJoined) call WFCO_FNC_GetSideUpgrades) # WF_UP_HEAVY;


{
    _addit = false;
	_isAdvVehicle = false;
    _groupName = _x;
    _unitClassNamesByGroup = _unitClassNames # _forEachIndex;
    _requiredUpgradesByGroup = _requiredGroupUpgrades # _forEachIndex;
    _groupType = _groupTypes # _forEachIndex;
    _requiredGroupUpgrade = _requiredGroupUpgrades # _forEachIndex;

    _isUpgradeOk = false;
    switch (_filler) do {
        case ("Barracks"): {
            if (_UpBar >= _requiredGroupUpgrade) then { _isUpgradeOk = true }
        };
        case ("Light"): {
            if (_UpLight >= _requiredGroupUpgrade) then { _isUpgradeOk = true }
        };
        case ("Heavy"): {
            if (_UpHeavy >= _requiredGroupUpgrade) then { _isUpgradeOk = true }
        };
    };

    if ((_unitClassNamesByGroup # 0) in WF_ADV_ARTILLERY) then { _isAdvVehicle = true };

    if(_isAdvVehicle) then {
        if!(isNil '_selectedRole')then{
            if(_selectedRole == WF_ARTY_OPERATOR)then{
                _addit = true;
            }
        }
    };

    if(_groupType == _filler && ((_isUpgradeOk && !_isAdvVehicle) || (_isAdvVehicle && _addit))) then {
        _cost = 0;
        {
            _c = missionNamespace getVariable _x;
            _className = _x;

            if!(isNil "_c") then {
                _cost = _cost + (_c # QUERYUNITPRICE);
            };

        } foreach _unitClassNamesByGroup;

        _capturedMilitaryBases = [WF_Client_SideJoined, WF_C_MILITARY_BASE, false] call WFCO_fnc_getSpecialLocations;
        if(_capturedMilitaryBases > 0) then {
            _cost = ceil (_cost - (WF_C_MILITARY_BASE_DISCOUNT_PERCENT * _capturedMilitaryBases * _cost));
        };

        lnbAddRow   [_listBox,['$'+str (_cost), _groupName]];
        lnbSetData  [_listBox,[_i,0],_filler];
        lnbSetValue [_listBox,[_i,1],_cost];
        lnbSetValue [_listBox,[_i,2],_u];
        _i = _i + 1;
    };
    _u = _u + 1;

} forEach _listGroups;

if (_i > 0) then {lnbSetCurSelRow [_listBox,0]} else {lnbSetCurSelRow [_listBox,-1]};