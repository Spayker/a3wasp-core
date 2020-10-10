WF_MenuAction = -1;

_veh = vehicle player;
_type = typeOf (vehicle player);
_pylons = [];
_rearmPrice = 0;
_oldpylons = _veh getVariable "_pylons";

//--Check is it first EASA for veh or no. If it is no a first EASA, copy old data--
if(!(isNil '_oldpylons' )) then { 
	if (count _oldpylons > 0) then {
		_pylons = +_oldpylons;
		_rearmPrice = round((((missionNamespace getVariable _type) select QUERYUNITPRICE)/(missionNamespace getVariable "WF_C_UNITS_SUPPORT_REARM_PRICE"))*1.25);
		_rearmPrice = round((_rearmPrice * (count _pylons)) / 2);
	};
};

_ix = 0;
private _allPylons = "true" configClasses (
		configFile 
		>> 
		"CfgVehicles" 
		>> 
		typeOf _veh
		>> 
		"Components" 
		>> 
		"TransportPylonsComponent" 
		>> 
		"pylons"
		) apply {configName _x};

{
	_strText = "";
	_strSubText = getText (configFile >> "CfgMagazines" >> (getPylonMagazines _veh) select _ix >> "displayName");
	for "_i" from 0 to (count _pylons) - 1 do {			
		if(((_pylons select _i) select 0) == _x) exitWith {
			_strText = format["%1 (%2)", _x, getText (configFile >> "CfgMagazines" >> (_pylons select _i) select 1 >> "displayName")];			
		};
	};	
	
	lbAdd[230033, format ["%1 (%2)", _x, _strSubText]];
	lbSetTooltip [230033, _ix, _strSubText];
	
	if(_strText != "") then {
		lbSetColor [230033, _ix, [0.9333, 0.8980, 0.5451, 0.9]];
	};
	
	lbSetData[230033, _ix, _x];
	_ix = _ix + 1;
} foreach _allPylons;

[format ["%1", localize 'STR_WF_INFO_EASA_HELP']] spawn WFCL_fnc_handleMessage;
	
lbAdd[230035, "ON"];
lbAdd[230035, "OFF"];
lbSetCurSel [230035, 0];

if(count allTurrets [_veh, true] == 0) then {
	lbSetCurSel [230035, 1];
	ctrlEnable[230035, false];
	};

ctrlEnable[22004, false];
ctrlSetText [230005, "$" + str(_rearmPrice)];

ctrlEnable[230007 , false];

if(!(isNil '_oldpylons' ) ) then { 
	if (count _oldpylons > 0) then {	
		ctrlSetText [230006,"$" + str(round(_rearmPrice / 2))];
		if(round(_rearmPrice / 2) <= Call WFCL_FNC_GetPlayerFunds && (count _pylons > 0)) then {
			ctrlEnable[230007, true];
		}
		else {
			ctrlEnable[230007, false];
		};
	};
} else {
	ctrlEnable[230007, false];
	ctrlSetText [230006,"$0"];
};

while {alive player && dialog} do {
	sleep 0.1;
	
	if (side player != WF_Client_SideJoined) exitWith {closeDialog 0};
	if !(dialog) exitWith {};
	
	
	if (WF_MenuAction == 111) then {
		WF_MenuAction = -1;		
		
		_k = 0;
		lbClear 230034;
		{
			if(_x != "CUP_PylonPod_ANAAQ_28" && _x != "CUP_PylonPod_ALQ_131" && _x != "rhs_mag_kh55sm_nocamo" && _x != "rhs_mag_kh55sm") then {
				lbAdd[230034, getText (configFile >> "CfgMagazines" >> _x >> "displayName")];				
				lbSetData [230034, _k, _x];
				_k = _k + 1;
			};			
		} foreach ((typeOf _veh) getCompatiblePylonMagazines lbData[230033, lbCurSel 230033]);

		ctrlEnable[22004 , false];
	};
	
	//--Weapon magazine changed--
	if (WF_MenuAction == 112) then {
		WF_MenuAction = -1;						
		
		_turretPath = [0];
		
		if(lbCurSel 230035 == 0) then {			
			_turretPath = [0];
		}
		else {			
			_turretPath = [];
		};
		
		if(count _pylons > 0) then {
			//--If current pylon already in array do not pushBack to array, else set new value--
			_exist = false;
			
			for "_j" from 0 to (count _pylons) - 1 do {
				if( (_pylons select _j) select 0 == lbData[230033, lbCurSel 230033]) exitWith {
					_exist = true;
					_pylons set [_j, [lbData[230033, lbCurSel 230033], lbData[230034, lbCurSel 230034], true, _turretPath]];
					lbSetColor [230033, lbCurSel 230033, [0.9333, 0.8980, 0.5451, 0.9]];					
				};
			};
			
			if(!_exist) then {
				_pylons pushBack [lbData[230033, lbCurSel 230033], lbData[230034, lbCurSel 230034], true, _turretPath];
				lbSetColor [230033, lbCurSel 230033, [0.9333, 0.8980, 0.5451, 0.9]];				
			};
		}
		else
		{
			_pylons pushBack [lbData[230033, lbCurSel 230033], lbData[230034, lbCurSel 230034], true, _turretPath];
			lbSetColor [230033, lbCurSel 230033, [0.9333, 0.8980, 0.5451, 0.9]];			
		};
		
		_rearmPrice = round((((missionNamespace getVariable _type) select QUERYUNITPRICE)/(missionNamespace getVariable "WF_C_UNITS_SUPPORT_REARM_PRICE"))*1.25);
		_rearmPrice = round((_rearmPrice * (count _pylons)) / 2);		
		ctrlSetText [230005,"$"+str(_rearmPrice)];
		
		if(_rearmPrice <= Call WFCL_FNC_GetPlayerFunds && (count _pylons > 0)) then {
			ctrlEnable[22004 , true];
		}
		else {
			ctrlEnable[22004 , false];
		};
		
		if(!(isNil '_oldpylons' ) ) then { 
			if (count _oldpylons > 0) then {
				if(round(_rearmPrice / 2) <= Call WFCL_FNC_GetPlayerFunds && (count _pylons > 0)) then {
					ctrlEnable[230007 , true];
				}
				else {
					ctrlEnable[230007 , false];
				};
			};
		};	
		
		ctrlSetText [230006,"$" + str(round(_rearmPrice / 2))];	
	};
	
	//--Weapon control mode changed--
	if (WF_MenuAction == 114) then {
		WF_MenuAction = -1;		
		
		_turretPath = [0];
		
		if(lbCurSel 230035 == 0) then {			
			_turretPath = [0];
		}
		else {			
			_turretPath = [];
		};
		
		if(count _pylons > 0) then {			
			for "_j" from 0 to (count _pylons) - 1 do {
				if( (_pylons select _j) select 0 == lbData[230033, lbCurSel 230033]) exitWith {					
					_pylons set [_j, [lbData[230033, lbCurSel 230033], lbData[230034, lbCurSel 230034], true, _turretPath]];					
				};
			};
		};		
	};
	
	//--Remove from set--
	if (WF_MenuAction == 102) then {
		WF_MenuAction = -1;
		
		_trysell_message = true;		
		
		if(count _pylons > 0) then {			
			for "_j" from 0 to (count _pylons) - 1 do {
				if( (_pylons select _j) select 0 == lbData[230033, lbCurSel 230033] && lbData[230033, lbCurSel 230033] == lbText[230033, lbCurSel 230033] ) exitWith {					
					_pylons deleteAt _j;
					lbSetColor [230033, lbCurSel 230033, [1, 1, 1, 1]];
					_trysell_message = false;
				};
			};
		};
		
		if(count _pylons > 0) then {
			_rearmPrice = round((((missionNamespace getVariable _type) select QUERYUNITPRICE)/(missionNamespace getVariable "WF_C_UNITS_SUPPORT_REARM_PRICE"))*1.25);
			_rearmPrice = round((_rearmPrice * (count _pylons)) / 2);		
		}
		else {
			_rearmPrice = 0;
		};
		
		ctrlSetText [230005,"$"+str(_rearmPrice)];
		
		if(_rearmPrice <= Call WFCL_FNC_GetPlayerFunds && (count _pylons > 0)) then {
			ctrlEnable[22004 , true];
		}
		else {
			ctrlEnable[22004 , false];
		};
		
		if(!(isNil '_oldpylons' ) ) then { 
			if (count _oldpylons > 0) then {
				if(round(_rearmPrice / 2) <= Call WFCL_FNC_GetPlayerFunds && (count _pylons > 0)) then {
					ctrlEnable[230007 , true];
				}
				else {
					ctrlEnable[230007 , false];
				};
			};
		};
		
		ctrlSetText [230006,"$" + str(round(_rearmPrice / 2))];		
		
		if(_trysell_message) then {
			[format["%1", localize 'STR_WF_EASA_TRYSELL_MESSAGE']] spawn WFCL_fnc_handleMessage
		};		
	};
	
	//--Purchase Button--
	if (WF_MenuAction == 101) then {
		WF_MenuAction = -1;
		
		-_rearmPrice Call WFCL_FNC_ChangePlayerFunds;
			
		if(count _pylons > 0) then {
			_veh setVariable ["_pylons", _pylons, true];
			[_veh, _pylons] call WFCO_FNC_Requip_AIR_VEH;
		};
		
		if (WF_Debug) then {
			diag_log format["Set pylons for %1 : %2", typeOf _veh, _pylons];
		};
	};
	
	//--Rearm by default Button--
	if (WF_MenuAction == 115) then {
		WF_MenuAction = -1;
		
		-(round(_rearmPrice / 2)) Call WFCL_FNC_ChangePlayerFunds;		
		
		_veh setVariable ["_pylons", nil]; 
		[_veh, side player] Spawn WFCO_FNC_RearmVehicle;
	};
};