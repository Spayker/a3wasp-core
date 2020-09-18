/*
	Groups Specific Functions.
	 Scope: Client.
*/

//--- The client join request has been accepted.
WFCL_FNC_Groups_JoinAccepted = {
	Private ["_group"];
	_group = _this # 0;
	WF_Client_PendingRequests = [];//--- Flush all existing requests.
	hint parseText Format["<t color='#42b6ff' size='1.2' underline='1' shadow='1'>Information:</t><br /><br /><t>Your request to join the the group <t color='#BD63F5'>%1</t> has been <t color='#B6F563'>Accepted</t>.</t>", _group];
};

//--- The client join request has been denied.
WFCL_FNC_Groups_JoinDenied = {
	Private ["_group"];
	_group = _this # 0;
	hint parseText Format["<t color='#42b6ff' size='1.2' underline='1' shadow='1'>Information:</t><br /><br /><t>Your request to join the the group <t color='#BD63F5'>%1</t> has been <t color='#B6F563'>Denied</t>.</t>", _group];
};

//--- The client get kicked back to his original group.
WFCL_FNC_Groups_KickedOff = {
	Private ["_group"];
	_group = _this # 0;
	
	[player, WF_Client_Team, WF_Client_SideJoined] Call WFCO_FNC_ChangeUnitGroup;
	if (leader WF_Client_Team != player) then {WF_Client_Team selectLeader player};
	hint parseText Format["<t color='#42b6ff' size='1.2' underline='1' shadow='1'>Information:</t><br /><br /><t>You were kicked from the group <t color='#BD63F5'>%1</t>, you have been transfered back to your <t color='#B6F563'>Original group</t>.</t>", _group];
};

//--- Used to display incomming group join requests.
WFCL_FNC_Groups_ReceiveRequest = {
	Private ["_name","_player","_uid"];
	_player = _this # 0;
	
	_uid = getPlayerUID(_player);
	_name = name _player;
	
	if (alive _player) then {
		_exists = false;
		{if ((_x # 0) == _uid) exitWith {_exists = true}} forEach WF_Client_PendingRequests;
		
		if !(_exists) then {
			[_uid, _name] Spawn {
				Private ["_data","_delay","_index","_is_present","_name","_uid"];
				_uid = _this # 0;
				_name = _this # 1;
				
				_delay = missionNamespace getVariable "WF_C_PLAYERS_SQUADS_REQUEST_TIMEOUT";
				while {_delay > -1} do {
					sleep 1;
					_is_present = false;
					{
						if ((_x # 0) == _uid && (_x # 1) == _name) exitWith {_is_present = true};
					} forEach WF_Client_PendingRequests;
					_delay = _delay - 1;
					if !(_is_present) exitWith {};
				};
				
				if (_delay <= 0) then {
					_index = -1;
					for '_i' from 0 to count(WF_Client_PendingRequests)-1 do {
						_data = WF_Client_PendingRequests # _i;
						if ((_data # 0) == _uid && (_data # 1) == _name) exitWith {_index = _i};
					};
					if (_index != -1) then {
						WF_Client_PendingRequests set [_index, "***NIL***"];
						WF_Client_PendingRequests = WF_Client_PendingRequests - ["***NIL***"];
					};
				};
			};
			[WF_Client_PendingRequests, [_uid, _name]] Call WFCO_FNC_ArrayPush;
			hint parseText Format["<t color='#42b6ff' size='1.2' underline='1' shadow='1'>Information:</t><br /><br /><t>Player <t color='#BD63F5'>%1</t> has been requested to join your squad, you may accept or deny the request in the <t color='#B6F563'>Groups Menu</t>.</t>", _name];
		};
	};
};

//--- Groups LB filler.
WFCL_FNC_UI_Groups_FillUnits = {
	Private ["_lb","_unit","_units","_u_label","_u_pic","_u_player","_u_veh"];

	_units = _this # 0;
	_lb = _this # 1;

	if (typeName _units == "GROUP") then {_units = units _units};

	for '_i' from 0 to count(_units)-1 do {
		_unit = _units # _i;
		_u_veh = if (_unit != vehicle _unit) then {true} else {false};
		_u_pic = if (_u_veh) then {"picture"} else {"portrait"};
		_u_label = getText(configFile >> "CfgVehicles" >> typeOf(vehicle _unit) >> "displayName");
		_u_player = if (isPlayer _unit) then {"*"} else {""};
		
		lnbAddRow[_lb, [Format["%1(%2) [%3]",_u_player,name _unit,_u_label]]];
		lnbSetPicture [_lb, [_i,0], getText(configFile >> "CfgVehicles" >> typeOf(vehicle _unit) >> _u_pic)];
	};
};

//--- Join a group.
WFCL_FNC_UI_Groups_Join = {
	Private ["_ai","_group","_players","_units"];

	_group = _this;
	_units = (units _group) Call WFCO_FNC_GetLiveUnits;
	_players = {isPlayer _x} count _units;
	_ai = (count _units) - _players;
	
	if (group player != _group) then {
		if (_players < (missionNamespace getVariable "WF_C_PLAYERS_SQUADS_MAX_PLAYERS")) then {
			if (time - WF_Client_LastGroupJoinRequest > (missionNamespace getVariable "WF_C_PLAYERS_SQUADS_REQUEST_DELAY")) then {
				WF_Client_LastGroupJoinRequest = time;
				//--- Don't bother if the client try to join his original team.
				if (_group == WF_Client_Team) then {
					[player, _group, WF_Client_SideJoined] Call WFCO_FNC_ChangeUnitGroup;
					_group selectLeader _unit;
					hint parseText Format["<t color='#42b6ff' size='1.2' underline='1' shadow='1'>Information:</t><br /><br /><t>You have joined back your original group (<t color='#BD63F5'>%1</t>) as a squad leader.</t>",_group];
					_update_group = true;
					_update_list = -1;
				} else {
					//---- Always join a team where the leader is not null.
					if (alive leader _group) then {
						//--- The team might be controlled by a player, if so this is a request.
						if (isPlayer leader _group) then {
							["RequestSpecial", ["group-query", _group, player, WF_Client_SideJoined]] Call WFCO_FNC_SendToServer;
							hint parseText Format["<t color='#42b6ff' size='1.2' underline='1' shadow='1'>Information:</t><br /><br /><t>A <t color='#B6F563'>Group join Request</t> has been sent to the group <t color='#BD63F5'>%1</t> controlled by <t color='#BD63F5'>%2</t>.</t>", _group, name leader _group];
						} else {
							//--- AI Teams may only be joined if the AI TL parameter is enabled.
							if ((missionNamespace getVariable "WF_C_AI_TEAMS_ENABLED") > 0) then {
								["RequestSpecial", ["group-query", _group, player, WF_Client_SideJoined]] Call WFCO_FNC_SendToServer;
								_update_group = true;
							} else {
								hint parseText "<t color='#42b6ff' size='1.2' underline='1' shadow='1'>Warning:</t><br /><br /><t><t color='#B6F563'>AI Teams</t> might not be joined if the AI Teams parameter is disabled.</t>";
								WF_Client_LastGroupJoinRequest = -5000;
							};
						};
					} else {
						hint parseText Format["<t color='#42b6ff' size='1.2' underline='1' shadow='1'>Warning:</t><br /><br /><t>The group you've attempted to join has no leader or the leader is dead (<t color='#BD63F5'>%1</t>).</t>", if (isNull _group) then {"Null"} else {_group}];
						WF_Client_LastGroupJoinRequest = -5000;
					};
				};
			} else {
				hint parseText Format["<t color='#42b6ff' size='1.2' underline='1' shadow='1'>Warning:</t><br /><br /><t>You cannot change groups that often, please wait <t color='#F56363'>%1</t> seconds.</t>", round(((missionNamespace getVariable "WF_C_PLAYERS_SQUADS_REQUEST_DELAY") + WF_Client_LastGroupJoinRequest) - time)];
			};
		} else {
			hint parseText Format["<t color='#42b6ff' size='1.2' underline='1' shadow='1'>Warning:</t><br /><br /><t>The <t color='#B6F563'>player limit</t> on this group has been reached (<t color='#F56363'>%1</t>).</t>",missionNamespace getVariable "WF_C_PLAYERS_SQUADS_MAX_PLAYERS"];
		};
	} else {
		hint parseText "<t color='#42b6ff' size='1.2' underline='1' shadow='1'>Information:</t><br /><br /><t>You are already in this squad.</t>";
	};
};

//--- Kick a player from a squad.
WFCL_FNC_UI_Groups_Kick = {
	Private ["_selected"];

	_selected = _group_units # _ui_lnb_sel;
	if (isPlayer _selected && group _selected == group player) then {
		lnbDeleteRow [508003, _ui_lnb_sel];
		[getPlayerUID _selected, "HandleSpecial", ["group-kick", group player]] Call WFCO_FNC_SendToClients;
	};
};

//--- Accept a join request.
WFCL_FNC_UI_Groups_RequestAccept = {
	Private ["_data","_index","_players","_units","_type","_uid"];
	_units = (units group player) Call WFCO_FNC_GetLiveUnits;
	_players = {isPlayer _x} count _units;
	
	if ((count WF_Client_PendingRequests_Accepted) + _players <= (missionNamespace getVariable "WF_C_PLAYERS_SQUADS_MAX_PLAYERS")) then {
		_type = lnbData[508007, [_ui_lnb_sel, 0]];
		_uid = lnbData[508007, [_ui_lnb_sel, 1]];
		
		lnbDeleteRow [508007, _ui_lnb_sel];
		
		_index = -1;
		for '_i' from 0 to count(WF_Client_PendingRequests)-1 do {
			_data = WF_Client_PendingRequests # _i;
			if ((_data # 0) == _uid) exitWith {_index = _i};
		};
		if (_index != -1) then {
			WF_Client_PendingRequests set [_index, "***NIL***"];
			WF_Client_PendingRequests = WF_Client_PendingRequests - ["***NIL***"];
		};
		
		//--- Make sure that the request hasn't timed out.
		if (_index != -1) then {
			//--- Use a local array to temporary store the requests, this will prevent mass acceptation glitch with lag.
			WF_Client_PendingRequests_Accepted pushBack _uid;
			(_uid) Spawn {sleep 6; WF_Client_PendingRequests_Accepted = WF_Client_PendingRequests_Accepted - [_this]};
			
			//--- Make the client join my squad.
			_player = objNull;
			{
				{if (getPlayerUID(_x) == _uid) exitWith {_player = _x}} forEach units _x;
				if !(isNull _player) exitWith {};
			} forEach (WF_Client_Logic getVariable "wf_teams");
			
			if !(isNull _player) then {
				//--- The player can join our squad.
				[_player, group player, WF_Client_SideJoined] Call WFCO_FNC_ChangeUnitGroup;
				
				//--- Inform the remote client that he can join.
				[_uid, "HandleSpecial", ["group-join-accept", group player]] Call WFCO_FNC_SendToClients;
			};
		};
	} else {
		hint parseText Format["<t color='#42b6ff' size='1.2' underline='1' shadow='1'>Warning:</t><br /><br /><t>The <t color='#B6F563'>player limit</t> on this group has been reached (<t color='#F56363'>%1</t>).</t>", missionNamespace getVariable "WF_C_PLAYERS_SQUADS_MAX_PLAYERS"];
	};
};

//--- Deny a join request.
WFCL_FNC_UI_Groups_RequestDeny = {
	Private ["_data","_index","_player","_type","_uid"];

	_type = lnbData[508007, [_ui_lnb_sel, 0]];
	_uid = lnbData[508007, [_ui_lnb_sel, 1]];
	
	lnbDeleteRow [508007, _ui_lnb_sel];
	
	_index = -1;
	for '_i' from 0 to count(WF_Client_PendingRequests)-1 do {
		_data = WF_Client_PendingRequests # _i;
		if ((_data # 0) == _uid) exitWith {_index = _i};
	};
	if (_index != -1) then {
		WF_Client_PendingRequests set [_index, "***NIL***"];
		WF_Client_PendingRequests = WF_Client_PendingRequests - ["***NIL***"];
	};
	
	//--- Make sure that the request hasn't timed out.
	if (_index != -1) then {
		//--- Make sure that the player still exists.
		_player = objNull;
		{
			{if (getPlayerUID(_x) == _uid) exitWith {_player = _x}} forEach units _x;
			if !(isNull _player) exitWith {};
		} forEach (WF_Client_Logic getVariable "wf_teams");
		
		if !(isNull _player) then {
			//--- Inform the remote client that he cannot join.
			[_uid, "HandleSpecial", ["group-join-deny", group player]] Call WFCO_FNC_SendToClients;
		};
	};
};