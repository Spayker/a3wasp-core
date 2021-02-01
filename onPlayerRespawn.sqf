params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

hudOn = true;

if(!isFirstSpawnIsDone) then {
    isFirstSpawnIsDone = true;
};

_unit = _newUnit;
_loadDefault = true;

WF_DeathLocation = getPosATL _oldUnit;
_spawn = nil;
if(vehicle _unit != _unit) then {
    _spawn = vehicle _unit
} else {
    _spawn_locations = [WF_Client_SideJoined, WF_DeathLocation] Call WFCL_FNC_GetRespawnAvailable;
    _spawn = [WF_DeathLocation, _spawn_locations] Call WFCO_FNC_GetClosestEntity;
};
_typeof = typeOf _spawn;


WF_Client_IsRespawning = false;
_allowCustom = true;

//--- Default gear enforcement on mobile respawn.
if ((missionNamespace getVariable "WF_C_RESPAWN_MOBILE") == 2) then {
	if (_typeof in (missionNamespace getVariable ["WF_AMBULANCES", []])) then {_allowCustom = false};
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
/*
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
			[(leader WF_Client_Team), _respawn_gear] call WFCO_FNC_EquipUnit; //--- Equip the equipment

			_loadDefault = false;
		};

	};
};
*/

//--- Load the default loadout.
/*
if (_loadDefault) then {
	Private ["_default"];
	_default = [];
	switch (WF_SK_V_Type) do {
		case WF_SNIPER: {_default = missionNamespace getVariable Format["WF_%1_DefaultGearSpot", WF_Client_SideJoinedText]};
		case WF_SOLDIER: {_default = missionNamespace getVariable Format["WF_%1_DefaultGearSoldier", WF_Client_SideJoinedText]};
		case WF_ENGINEER: {_default = missionNamespace getVariable Format["WF_%1_DefaultGearEngineer", WF_Client_SideJoinedText]};
		case WF_SPECOPS: {_default = missionNamespace getVariable Format["WF_%1_DefaultGearLock", WF_Client_SideJoinedText]};
        case WF_MEDIC: {_default = missionNamespace getVariable Format["WF_%1_DefaultGearMedic", WF_Client_SideJoinedText];};
        case WF_SUPPORT: {_default = missionNamespace getVariable Format["WF_%1_DefaultGearSupport", WF_Client_SideJoinedText];};
	};

	[(leader WF_Client_Team), _default] call WFCO_FNC_EquipUnit;
};
*/

waitUntil {clientInitComplete};

(_unit) Call WFCL_fnc_applySkill;

if (!isNull commanderTeam) then {
	_mhqs = (WF_Client_SideJoined) Call WFCO_FNC_GetSideHQ;
    _hqs = [(leader WF_Client_Team),_mhqs] call WFCO_FNC_GetClosestEntity;
	if (commanderTeam == group _unit) then {
		HQAction = _unit addAction [localize "STR_WF_BuildMenu",{call WFCL_fnc_callBuildMenu}, [_hqs], 1000, false, true, "", "hqInRange && canBuildWHQ && (_target == player)"];
    };
};

// adjusting fatigue
if ((missionNamespace getVariable "WF_C_GAMEPLAY_FATIGUE_ENABLED") == 1) then {
    (leader WF_Client_Team) setCustomAimCoef 0.35;
    (leader WF_Client_Team) setUnitRecoilCoefficient 0.75;
    (leader WF_Client_Team) enablestamina false;
};

[WF_Client_SideJoinedText,'UnitsCreated',1] Call WFCO_FNC_UpdateStatistics;