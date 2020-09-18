private ["_coloration", "_trade_in"];
_trade_in = [uiNamespace getVariable "wf_dialog_ui_gear_target_staticgear", uiNamespace getVariable "wf_dialog_ui_gear_target_gear"] call WFCL_fnc_getGearCostDelta;

uiNamespace setVariable ["wf_dialog_ui_gear_tradein", _trade_in];

_coloration = if (_trade_in > 0) then {"#F56363"} else {"#76F563"};

((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70028) ctrlSetStructuredText parseText format ["<t align='left'>Trade-in: <t color='%3'>$%1</t><t><t align='right'>Resources: <t color='%4'>$%2</t><t>", _trade_in, call WFCL_FNC_GetPlayerFunds, _coloration, "#BAFF81"];
