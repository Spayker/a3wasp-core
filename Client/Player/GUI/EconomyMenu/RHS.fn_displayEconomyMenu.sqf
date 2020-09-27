disableSerialization;

_display = _this select 0;
_map = _display DisplayCtrl 23002;

if(isNil "mouseButtonUp") then {mouseButtonUp = -1};

_supplies = (WF_Client_SideJoined) Call WFCO_FNC_GetSideSupply;
_funds = Call WFCL_FNC_GetPlayerFunds;
_mhqs = (WF_Client_SideJoined) Call WFCO_FNC_GetSideHQ;
_mhq = [player,_mhqs] call WFCO_FNC_GetClosestEntity;
_hqDeployed = [WF_Client_SideJoined, _mhq] Call WFCO_FNC_GetSideHQDeployStatus;
if (!_hqDeployed || (missionNamespace getVariable "WF_C_STRUCTURES_CONSTRUCTION_MODE") == 0) then {ctrlEnable [23004, false];ctrlEnable [23006, false]};
if ((missionNamespace getVariable "WF_C_STRUCTURES_CONSTRUCTION_MODE") == 0) then { ctrlSetText[23005, localize 'STR_WF_Disabled']};

WF_MenuAction = -1;

_income = (WF_Client_SideJoined) Call WFCO_FNC_GetTownsIncome;
_incomeCoef = missionNamespace getVariable "WF_C_ECONOMY_INCOME_COEF";
_incomeDividision = missionNamespace getVariable "WF_C_ECONOMY_INCOME_DIVIDED";
_lastComboUpdate = -30;
_lastPurchase = -5;
_commanderPercent = 0;
_hasStarted = true;

_lastUse = 0;
_timer = 0;

SliderSetRange[1300771, 0, _supplies];

SliderSetRange[130077,0,_funds];
sliderSetRange[23010,50,missionNamespace getVariable "WF_C_ECONOMY_INCOME_PERCENT_MAX"];
_commanderPercent = missionNamespace getVariable "wf_commander_percent";
sliderSetPosition[23010, _commanderPercent];


ctrlSetText [1300661, Format [localize "STR_WF_Economy_Supplies",0]];
ctrlSetText [1300662, Format [localize "STR_WF_Economy_Converted_Money",0]];

ctrlSetText [130066, Format [localize "STR_WF_TEAM_MoneyTransfer",0]];
ctrlSetText [13010, Format [localize "STR_WF_Income",Call WFCL_FNC_GetPlayerFunds,(WF_Client_SideJoined) Call WFCL_FNC_GetIncome]];

_i = 1;
{
	_xtra = ["AI", name (leader _x)] select (isPlayer (leader _x));
	lbAdd[130088,Format ["[%1] %2",_i,_xtra]];
	_i = _i + 1;
} forEach WF_Client_Teams;
lbSetCurSel[130088,0];

while {alive player && dialog} do {
    if (side player != WF_Client_SideJoined) exitWith {closeDialog 0};
    if !(dialog) exitWith {};

    _transferAmount = Floor (SliderPosition 130077);
    _convertSupplyAmount = Floor (SliderPosition 1300771);
    _convertedMoney = ceil (_convertSupplyAmount * 2);

    ctrlSetText [130066, Format [localize "STR_WF_TEAM_MoneyTransfer",_transferAmount]];
    ctrlSetText [1300661, Format [localize "STR_WF_Economy_Supplies", _convertSupplyAmount]];
    ctrlSetText [1300662, Format [localize "STR_WF_Economy_Converted_Money", _convertedMoney]];

    _curSel = lbCurSel 130088;
    if (WF_MenuAction == 1) then {
        WF_MenuAction = -1;
        if ((_transferAmount != 0)&&((WF_Client_Teams # _curSel) != group player)) then {
            [(WF_Client_Teams # _curSel),_transferAmount] Call WFCO_FNC_ChangeTeamFunds;
            -_transferAmount Call WFCL_FNC_ChangePlayerFunds;
    _funds = Call WFCL_FNC_GetPlayerFunds;
            if (isPlayer leader (WF_Client_Teams # _curSel)) then {
                ['FundsTransfer',_transferAmount,name player] remoteExecCall ["WFCL_FNC_LocalizeMessage", leader (WF_Client_Teams # _curSel)];
            };
            sliderSetRange[130077,0,_funds];
        };
    };

    if (WF_MenuAction == 66) then {
        WF_MenuAction = -1;
        if ((_convertSupplyAmount != 0)) then {
            -_convertSupplyAmount Call WFCL_FNC_ChangePlayerFunds;
            _funds = Call WFCL_FNC_GetPlayerFunds;
            (_funds + _convertedMoney) Call WFCL_FNC_ChangePlayerFunds;
            [WF_Client_SideJoined, -(_convertSupplyAmount)] Call WFCO_FNC_ChangeSideSupply;
            sliderSetRange[1300771, 0, (WF_Client_SideJoined) Call WFCO_FNC_GetTownsIncome];
            ctrlSetText [1300661, Format [localize "STR_WF_Economy_Supplies", 0]];
            ctrlSetText [1300662, Format [localize "STR_WF_Economy_Converted_Money", 0]];
        };
    };

    _funds = Call WFCL_FNC_GetPlayerFunds;
    _comEnable = false;
    if(!isNull commanderTeam)then{
        if(commanderTeam == group player) then { _comEnable = true }
    };

    ctrlEnable [23010,_comEnable];
    ctrlEnable [23012,_comEnable];
    ctrlEnable [23015,_comEnable];

    ctrlEnable [1300771,_comEnable];
    ctrlEnable [1300991,_comEnable];

    //--- Income System.
    _currentPercent = floor(sliderPosition 23010);
    ctrlSetText[23011, Format["%1%2",_currentPercent,"%"]];

    //_commanderPercent = floor(sliderPosition 23010);

    sliderSetPosition[23010, _currentPercent];

    _calInc = (WF_Client_SideJoined) Call WFCO_FNC_GetTownsIncome;

    if (_currentPercent != _income || _hasStarted) then {
        if (_hasStarted) then {_hasStarted = false};

        _income_player = 0;
        _income_commander = 0;
        _income_player = round(_income + ((_income / 100) * (100 - _currentPercent)));
        _income_commander = round(((_income * _incomeCoef) / 100) * _currentPercent);

        ctrlSetText [23013, localize 'STR_WF_ECONOMY_Income_Sys_Com' + ": $" + str(_income_commander)];
        ctrlSetText [23014, localize 'STR_WF_ECONOMY_Income_Sys_Ply' + ": $" + str(_income_player)];
    };

    if (WF_MenuAction == 3) then {
        WF_MenuAction = -1;

        if (_currentPercent != _commanderPercent) then {
            missionNamespace setVariable ["wf_commander_percent", _currentPercent, true];
        };
    };

    if (mouseButtonUp == 0) then {
        mouseButtonUp = -1;

        //--- Sell Building.
        if (WF_MenuAction == 105) then {
            WF_MenuAction = -1;
            _isCommander = false;
            if (!isNull(commanderTeam)) then {if (commanderTeam == group player) then {_isCommander = true}};
            if !(_isCommander) exitWith {};
            _position = _map posScreenToWorld[mouseX,mouseY];
            _structures = (WF_Client_SideJoined) Call WFCO_FNC_GetSideStructures;
            _mhqs = (WF_Client_SideJoined) Call WFCO_FNC_GetSideHQ;
            _mhq = [player,_mhqs] call WFCO_FNC_GetClosestEntity;
            _hqDeployed = ([WF_Client_SideJoined, _mhq] Call WFCO_FNC_GetSideHQDeployStatus);
            _closest = objNull;
            if(_hqDeployed) then {
                _closest = [_position,_structures + [_mhq]] Call WFCO_FNC_GetClosestEntity
            } else {
                _closest = [_position,_structures] Call WFCO_FNC_GetClosestEntity
            };

            if (!isNull _closest) then {
                //--- 100 meters close only.
                if (_closest distance _position < 100 && !(_closest getVariable["wf_sold", false])) then {
                    //--- Spawn a sell thread.
                    if(_closest == _mhq) then {
                        [WF_Client_SideJoined, _closest, true] remoteExec ["WFSE_fnc_RequestStructureSell", 2]
                    } else {
                        [WF_Client_SideJoined, _closest, false] remoteExec ["WFSE_fnc_RequestStructureSell", 2]
                    }
                }
            }
		}
	};
	
	//--- WF3 Adv Funds transfers.
    if (WF_MenuAction == 101) exitWith {
        WF_MenuAction = -1;
        closeDialog 0;
        createDialog "WF_TransferMenu";
    };

    if (_timer > 2) then {ctrlSetText [13010, Format [localize "STR_WF_Income", Call WFCL_FNC_GetPlayerFunds, (WF_Client_SideJoined) Call WFCL_FNC_GetIncome]];_timer = 0};
    _timer = _timer + 0.05;
	
	//--- Back Button.
	if (WF_MenuAction == 5) exitWith {
		WF_MenuAction = -1;
		closeDialog 0;
		createDialog "WF_Menu"
	};
	uiSleep 0.05;
}