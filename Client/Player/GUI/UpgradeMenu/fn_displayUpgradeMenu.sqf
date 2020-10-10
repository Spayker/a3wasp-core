//--- Register the UI.
uiNamespace setVariable ["wf_display_upgrades", _this # 0];
_upgrade_lastsel = uiNamespace getVariable "wf_display_upgrades_sel";
if (isNil '_upgrade_lastsel') then {_upgrade_lastsel = 0; uiNamespace setVariable ["wf_display_upgrades_sel", 0]};

_upgrade_enabled = missionNamespace getVariable Format["WF_C_UPGRADES_%1_ENABLED",WF_Client_SideJoinedText];
_upgrade_costs = missionNamespace getVariable Format["WF_C_UPGRADES_%1_COSTS",WF_Client_SideJoinedText];
_upgrade_descriptions = missionNamespace getVariable "WF_C_UPGRADES_DESCRIPTIONS";
_upgrade_labels = missionNamespace getVariable "WF_C_UPGRADES_LABELS";
_upgrade_levels = missionNamespace getVariable Format["WF_C_UPGRADES_%1_LEVELS",WF_Client_SideJoinedText];
_upgrade_links = missionNamespace getVariable Format["WF_C_UPGRADES_%1_LINKS",WF_Client_SideJoinedText];
_upgrade_sorted = missionNamespace getVariable "WF_C_UPGRADES_SORTED";
_upgrade_times = missionNamespace getVariable Format["WF_C_UPGRADES_%1_TIMES",WF_Client_SideJoinedText];
_upgrade_isupgrading = false;

_upgrades = (WF_Client_SideJoined) call WFCO_FNC_GetSideUpgrades;

_i = 0;
{
	if (_upgrade_enabled # _x) then {
		lnbAddRow [504001, [Format ["%1/%2",_upgrades # _x,_upgrade_levels # _x],_upgrade_labels # _x]];
		lnbSetValue [504001, [_i, 0], _x];
		_i = _i + 1;
	};
} forEach _upgrade_sorted;
lnbSetCurSelRow[504001, _upgrade_lastsel];
_upgrades_old = _upgrades;

_purchase = false;
_update_upgrade = true;
_update_upgrade_details = true;
_update_list = false;
_update_upgrade_lastcheck = -1;

_player_commander = false; //added-MrNiceGuy
if (!isNull(commanderTeam)) then {if (commanderTeam == group player) then {_player_commander = true}};
if !(_player_commander) then {ctrlEnable [504007, false]};

WF_WF_MenuAction = -1;

while {alive player && dialog} do {
	if (WF_WF_MenuAction == 1) then {WF_WF_MenuAction = -1; if (_player_commander) then {_purchase = true}};
	if (WF_WF_MenuAction == 2) then {WF_WF_MenuAction = -1;_update_upgrade = true};
	
	_upgrades = (WF_Client_SideJoined) call WFCO_FNC_GetSideUpgrades;
	
	if (time - _update_upgrade_lastcheck > 0.5) then {
		_update_list = false;
		_update_upgrade_lastcheck = time;
		for '_i' from 0 to count(_upgrades_old)-1 do {if ((_upgrades_old # _i) != (_upgrades # _i)) exitWith {_update_list = true}};
		if (_update_list) then {
			_update_list = false;
			for '_i' from 0 to count(_upgrades_old)-1 do {lnbSetText[504001, [_i, 0], Format ["%1/%2",_upgrades # _i,_upgrade_levels # _i]]};
			
			_i = 0;
			{
				if (_upgrade_enabled # _x) then {
					lnbSetText[504001, [_i, 0], Format ["%1/%2",_upgrades # _x,_upgrade_levels # _x]];
					_i = _i + 1;
				};
			} forEach _upgrade_sorted;
			
			_ui_lnb_sel = lnbCurSelRow(504001);
			if (_ui_lnb_sel != -1) then {lnbSetCurSelRow[504001, _ui_lnb_sel]};
		};
		_upgrades_old = _upgrades;
	};
	
	if (_update_upgrade) then {
		_update_upgrade = false;
		_ui_lnb_sel = lnbCurSelRow(504001);
		if (_ui_lnb_sel != -1) then {
			_id = lnbValue[504001, [_ui_lnb_sel, 0]];
			uiNamespace setVariable ["wf_display_upgrades_sel", _ui_lnb_sel];
			((uiNamespace getVariable "wf_display_upgrades") displayCtrl 504005) ctrlSetStructuredText (parseText (_upgrade_descriptions # _id));
		};
		_update_upgrade_details = true;
	};

	if (_update_upgrade_details) then {
		_update_upgrade_details = false;
		_ui_lnb_sel = lnbCurSelRow(504001);
		if (_ui_lnb_sel != -1) then {
			_id = lnbValue[504001, [_ui_lnb_sel, 0]];
			_upgrade_current = _upgrades # _id;
			_funds = call WFCL_FNC_GetPlayerFunds;
			_supply = (WF_Client_SideJoined) call WFCO_FNC_GetSideSupply;
			_html = "";
			_html2 = "<t color='#42b6ff' size='1.2' underline='1' shadow='1'>Dependencies:</t><br /><br />";
			if (_upgrade_current < (_upgrade_levels # _id)) then {
				_upgrade_supply = ((_upgrade_costs # _id) # _upgrade_current) # 0;
				_upgrade_price = ((_upgrade_costs # _id) # _upgrade_current) # 1;

				_html = Format["<t color='#42b6ff' size='1.2' underline='1' shadow='1'>%1:</t><br /><br /><t color='#42b6ff' shadow='1'>Upgrade Level :</t><t shadow='1' align='right'><t color='#F5D363'>%2</t>/<t color='#F5D363'>%3</t></t><br /><t color='#42b6ff' shadow='1'>Needed Funds :</t><t shadow='1' align='right'><t color='#F5D363'>%4</t>/<t color='%5'>%6</t> $</t><br /><t color='#42b6ff' shadow='1'>Needed Supply :</t><t shadow='1' align='right'><t color='#F5D363'>%7</t>/<t color='%8'>%9</t> S</t><br /><t color='#42b6ff' shadow='1'>Needed Time :</t><t shadow='1' align='right'><t color='#F5D363'>%10</t> Seconds</t><br />",_upgrade_labels # _id,_upgrade_current, _upgrade_levels # _id,_upgrade_price,if(_funds >= _upgrade_price) then {'#76F563'} else {'#F56363'},_funds,_upgrade_supply,if(_supply >= _upgrade_supply) then {'#76F563'} else {'#F56363'},_supply,(_upgrade_times # _id) # _upgrade_current];
				
				_links = (_upgrade_links # _id) # _upgrade_current;
				if (count _links > 0) then {
					if ((_links # 0) isEqualType []) then {
						_count = count(_links);
						for '_i' from 0 to _count-1 do {
							_coma = ["", ", "] select (_i+1 < _count);
							_clink = _links # _i;
							_linkto = _upgrades # (_clink # 0);
							_html2 = _html2 + Format ["<t shadow='1'><t color='%1'>%2 </t><t color='#F5D363'>%3</t>%4</t>",if (_linkto >= (_clink # 1)) then {'#76F563'} else {'#F56363'},_upgrade_labels # (_clink # 0), _clink # 1,_coma];
						};
					} else {
						_linkto = _upgrades # (_links # 0);
						if (_linkto >= (_links # 1)) then {_html2 = _html2 + "<t color='#76F563' shadow='1'>All dependencies are met</t>"} else {_html2 = _html2 + Format ["<t shadow='1'><t color='#F56363'>%1 </t><t color='#F5D363'>%2</t></t>",_upgrade_labels # (_links # 0), _links # 1]};
					};
				} else {
					_html2 = _html2 + "<t color='#76F563' shadow='1'>None</t>";
				};
			} else {
				_html = Format["<t color='#42b6ff' size='1.2' underline='1' shadow='1'>%1:</t><br /><br /><t color='#76F563' shadow='1'>The maximum upgrade level has been reached.</t>",_upgrade_labels # _id];
				_html2 = _html2 + "<t color='#76F563' shadow='1'>None</t>";
			};
			((uiNamespace getVariable "wf_display_upgrades") displayCtrl 504003) ctrlSetStructuredText (parseText _html);
			((uiNamespace getVariable "wf_display_upgrades") displayCtrl 504004) ctrlSetStructuredText (parseText _html2);
		};
	};
	
	if (_purchase) then {
		_purchase = false;
		_ui_lnb_sel = lnbCurSelRow(504001);
		if (_ui_lnb_sel != -1) then {
			_id = lnbValue[504001, [_ui_lnb_sel, 0]];
			_upgrade_current = _upgrades # _id;
			_funds = call WFCL_FNC_GetPlayerFunds;
			_supply = (WF_Client_SideJoined) call WFCO_FNC_GetSideSupply;
			if !(WF_Client_Logic getVariable "wf_upgrading") then {
				if (_upgrade_current < (_upgrade_levels # _id)) then {
					_upgrade_supply = ((_upgrade_costs # _id) # _upgrade_current) # 0;
					_upgrade_price = ((_upgrade_costs # _id) # _upgrade_current) # 1;
					if(_funds >= _upgrade_price && _supply >= _upgrade_supply) then {
						_links = (_upgrade_links # _id) # _upgrade_current;
						_link_needed = false;
						if (count _links > 0) then {
							if ((_links # 0) isEqualType []) then {
								_count = count(_links);
								for '_i' from 0 to _count-1 do {
									_clink = _links # _i;
									_linkto = _upgrades # (_clink # 0);
									if (_linkto < (_clink # 1)) exitWith {_link_needed = true};
								};
							} else {
								_linkto = _upgrades # (_links # 0);
								if (_linkto < (_links # 1)) exitWith {_link_needed = true};
							};
						};
						if !(_link_needed) then {
							-(_upgrade_price) Call WFCL_FNC_ChangePlayerFunds;
							[WF_Client_SideJoined, -(_upgrade_supply)] Call WFCO_FNC_ChangeSideSupply;
							[WF_Client_SideJoined, _id, _upgrade_current, true] remoteExecCall ["WFSE_fnc_RequestUpgrade",2];
							WF_Client_Logic setVariable ["wf_upgrading", true, true];
							//--- Pure client, spawn an upgrade thread, which is local to the client in case the client tickrate is above the server tickrate.
							if !(isServer) then {
								_upgrade_time = (_upgrade_times # _id) # _upgrade_current;
								[_id, _upgrade_current, _upgrade_time] spawn {
									sleep (_this # 2);
									[WF_Client_SideJoined, _this # 0, _this # 1] remoteExecCall ["WFSE_FNC_synchronizeUpgade",2];
								};
							};
							[Format[localize "STR_WF_HINT_Upgrading",_upgrade_labels # _id,_upgrade_current + 1]] spawn WFCL_fnc_handleMessage
						} else {
							[Format["%1", localize "STR_WF_HINT_Dependencies"]] spawn WFCL_fnc_handleMessage
						};
					} else {
						[Format[localize "STR_WF_HINT_NotEnough",_upgrade_labels # _id,_upgrade_current]] spawn WFCL_fnc_handleMessage
					};
				} else {
					[format ["%1", localize "STR_WF_HINT_ReachedMax"]] spawn WFCL_fnc_handleMessage
				};
			} else {
				[format ["%1", localize "STR_WF_HINT_AlreadyRunning"]] spawn WFCL_fnc_handleMessage
			};
		};
	};
	
	if ((_upgrade_isupgrading && !(WF_Client_Logic getVariable "wf_upgrading")) || (!_upgrade_isupgrading && (WF_Client_Logic getVariable "wf_upgrading"))) then {
		_upgrade_isupgrading = (WF_Client_Logic getVariable "wf_upgrading");
		_html = ["", "<t>An upgrade is <t color='#B6F563'>currently running</t></t>"] select (_upgrade_isupgrading);
		((uiNamespace getVariable "wf_display_upgrades") displayCtrl 504006) ctrlSetStructuredText (parseText _html);
	};
	
	//--- Go back to the main menu.
	if (WF_WF_MenuAction == 1000) exitWith {
		WF_WF_MenuAction = -1;
		closeDialog 0;
		createDialog "WF_Menu"
	};
	
	sleep .01;
};

uiNamespace setVariable ["wf_display_upgrades", nil];