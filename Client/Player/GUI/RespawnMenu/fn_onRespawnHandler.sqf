Private ["_allowCustom","_buildings","_charge","_funds","_get","_loadDefault","_listbp","_mode","_price","_skip","_spawn","_spawnInside","_typeof","_unit","_weaps"];

_unit = _this select 0;
_spawn = _this select 1;
_loadDefault = true;
_typeof = typeOf _spawn;

WF_Client_IsRespawning = false;
_allowCustom = true;

//--- Default gear enforcement on mobile respawn.
if ((missionNamespace getVariable "WF_C_RESPAWN_MOBILE") == 2) then {
	if (_typeof in (missionNamespace getVariable ["WF_AMBULANCES", []])) then {_allowCustom = false};
};

//--- Respawn.
if (_spawn isKindOf "Man") then {_spawn = vehicle _spawn};
_spawnInside = false;
if (_typeof in (missionNamespace getVariable ["WF_AMBULANCES", []]) && alive _spawn) then {
	if (_spawn emptyPositions "cargo" > 0 && (locked _spawn in [0, 1])) then {_unit moveInCargo _spawn;_spawnInside = true};
};

if !(_spawnInside) then {
	_notSafePos = [getPos _spawn, 10, 20] Call WFCO_FNC_GetRandomPosition;
	_safePos = [_notSafePos, 0, 25] call BIS_fnc_findSafePos;
	_notSafePos set [0, _safePos # 0];
	_notSafePos set [1, _safePos # 1];
	_unit setPos _notSafePos;
};

//--Disable fatigue--
if ((missionNamespace getVariable "WF_C_GAMEPLAY_FATIGUE_ENABLED") == 0) then {
    _unit enableFatigue false;
    player setCustomAimCoef 0.1;
};

WF_PlayerMenuAction = nil;

[_this # 0] spawn {
	waitUntil {!isNil "ASL_Add_Player_Actions"};

	if!(_this # 0 getVariable ["ASL_Actions_Loaded",false]) then {
		[] call ASL_Add_Player_Actions;
		_this # 0 setVariable ["ASL_Actions_Loaded",true];
	};
};

//--- Loadout.
if (!isNil 'WF_P_CurrentGear' && !WF_RespawnDefaultGear && _allowCustom) then {
	_mode = missionNamespace getVariable "WF_C_RESPAWN_PENALTY";

	if (_mode in [0,2,3,4,5]) then {
		//--- Calculate the price/funds.
		_skip = false;
		_gear_cost = _unit getVariable "wf_custom_gear_cost";
		if (_mode != 0) then {
			_price = 0;

			//--- Get the mode pricing.
			switch (_mode) do {
				case 2: {_price = _gear_cost};
				case 3: {_price = round(_gear_cost/2)};
				case 4: {_price = round(_gear_cost/4)};
				case 5: {_price = _gear_cost};
			};

			//--- Are we charging only on mobile respawn?
			_charge = true;
			if (_mode == 5) then {
				_buildings = (WF_Client_SideJoined) Call WFCO_FNC_GetSideStructures;
				if (_spawn in _buildings || _spawn == ((WF_Client_SideJoined) Call WFCO_FNC_GetSideHQ)) then {_charge = false};
			};

			//--- Charge if possible.
			_funds = Call WFCL_FNC_GetPlayerFunds;
			if (_funds >= _price && _charge) then {
				-(_price) Call WFCL_FNC_ChangePlayerFunds;
				(Format[localize 'STR_WF_CHAT_Gear_RespawnCharge',_price]) Call WFCL_FNC_GroupChatMessage;
			};

			//--- Check that the player has enough funds.
			if (_funds < _price) then {_skip = true};
		};

		//--- Use the respawn loadout.
		if !(_skip) then {
			
			_respawn_gear = if (isNil 'WF_P_CurrentGear') then {missionNamespace getVariable format ["WF_AI_%1_DEFAULT_GEAR", WF_Client_SideJoined]} else {WF_P_CurrentGear};
			[player, _respawn_gear] call WFCO_FNC_EquipUnit; //--- Equip the equipment
			
			_loadDefault = false;
		};
	};
};

//--- Load the default loadout.
if (_loadDefault) then {
	Private ["_default"];
	_default = [];
	switch (WF_SK_V_Type) do {

		case WF_SNIPER: {_default = missionNamespace getVariable Format["WF_%1_DefaultGearSpot", WF_Client_SideJoinedText]};

		case WF_SOLDIER: {_default = missionNamespace getVariable Format["WF_%1_DefaultGearSoldier", WF_Client_SideJoinedText]};

		case WF_ENGINEER: {_default = missionNamespace getVariable Format["WF_%1_DefaultGearEngineer", WF_Client_SideJoinedText]};

		case WF_SPECOPS: {_default = missionNamespace getVariable Format["WF_%1_DefaultGearLock", WF_Client_SideJoinedText]};

        case WF_ARTY_OPERATOR: {_default = missionNamespace getVariable Format["WF_%1_DefaultGearArtOperator", WF_Client_SideJoinedText];};

        case WF_UAV_OPERATOR: {_default = missionNamespace getVariable Format["WF_%1_DefaultGearUAVOperator", WF_Client_SideJoinedText];};
	};
	
	[player, _default] call WFCO_FNC_EquipUnit;
};
