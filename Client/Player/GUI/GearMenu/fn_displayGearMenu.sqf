_last_funds = -1;

while { true } do {
	
	if (isNil {uiNamespace getVariable "wf_dialog_ui_gear"}) exitWith {}; //--- Menu is closed.
	
	_funds = Call WFCL_FNC_GetPlayerFunds;
	
	if (_last_funds != _funds) then {		
		_trade_in = uiNamespace getVariable "wf_dialog_ui_gear_tradein";
		_coloration = if (_trade_in > 0) then {"#F56363"} else {"#76F563"};
		((uiNamespace getVariable "wf_dialog_ui_gear") displayCtrl 70025) ctrlSetStructuredText parseText format ["<t align='left'>Trade-in: <t color='%3'>$%1</t><t><t align='right'>Resources: <t color='%4'>$%2</t><t>", _trade_in, Call WFCL_FNC_GetPlayerFunds, _coloration, "#BAFF81"];
	};
	
	_last_funds = _funds;
	
	sleep .1;
};
