WF_MenuAction = -1;

private["_veh", "_type", "_weaps", "_weaps", "_magz", "_rearmPrice", "_rearmXPrice", "_currentUpgrades", "_currentLevel", "_countOfSelectedMagz", "_WF_VEH_MAGAZINES"];

_veh = vehicle player;
_type = typeOf _veh;
_WF_VEH_MAGAZINES = [];

switch(side _veh) do {
	case east: { _WF_VEH_MAGAZINES = call compile preprocessFileLineNumbers "Common\Warfare\Config\Config_VehWeaponMagazines_EAST.sqf"; };
	case west: { _WF_VEH_MAGAZINES = call compile preprocessFileLineNumbers  "Common\Warfare\Config\Config_VehWeaponMagazines_WEST.sqf"; };
	default { _WF_VEH_MAGAZINES = call compile preprocessFileLineNumbers  "Common\Warfare\Config\Config_VehWeaponMagazines_GUER.sqf"; };
};

_weaps = [];
_magz = [];
_rearmPrice = 0;
_rearmXPrice = 0;

ctrlEnable [22004, false];
_currentUpgrades = (side player) Call WFCO_FNC_GetSideUpgrades;
_currentLevel = _currentUpgrades select WF_UP_HEAVY_MAGZ;
_currentLevel = _currentLevel + 1;
_countOfSelectedMagz = 0;

_findWeaps = {
    private ["_root", "_class", "_path", "_currentPath"];
    _root = (_this select 0);
    _path = (_this select 1);
    for "_i" from 0 to count _root -1 do {
        _class = _root select _i;
        if (isClass _class) then {
            _currentPath = _path;
            {
                _weaps set [count _weaps, _x];
            } foreach getArray (_class >> "weapons");
            _class = _class >> "turrets";
        };
    };
};

_class = (configFile >> "CfgVehicles" >> _type >> "turrets");

//--Calculate weapons--
[_class, [0]] call _findWeaps;
	 
_getAnyMagazines = {
    private ["_weapon", "_mags", "_wpn", "_mgs"];
	
    _weapon = configFile >> "CfgWeapons" >> _this;
    _mags = [];
    {
		_wpn = (if (_x == "this") then { _weapon } else { _weapon >> _x });
		_mgs = getArray(_wpn >> "magazines");
		
		{
			if((count _WF_VEH_MAGAZINES) == 0 || _x in _WF_VEH_MAGAZINES || WF_Debug) then {
				_mags pushBack _x;
			};
		} forEach _mgs;
    } foreach getArray (_weapon >> "muzzles");
	
	if(_mags isEqualTo []) then { //--No one magazie does included in _WF_VEH_MAGAZINES. Do represent of all weapon magazines--
		{
			_wpn = (if (_x == "this") then { _weapon } else { _weapon >> _x });
			_mgs = getArray(_wpn >> "magazines");
			
			_mags = _mags + _mgs;
		} foreach getArray (_weapon >> "muzzles");
	};
	
    _mags
};
	 
//--Find all mags--
{
	{
		if(_x != "rhs_mag_Atomic_2a33" && _x != "rhs_mag_Atomic_2a_2633_26") then {
			_magz pushBack _x;
		};
	} forEach (_x call _getAnyMagazines);
} forEach _weaps; 

{	
	_magName = getText (configFile >> "CfgMagazines" >> _x >> "displayName");
	lbAdd[230033, format["%1 [%2]", _magName, _x]];
	lbSetData[230033, _forEachIndex , str([0,_x])];
	lbSetTooltip [230033, _forEachIndex, _x];
	lbSetPictureColor [230033, _forEachIndex, [1, 1, 1, 0.75]];
	lbSetPicture [230033, _forEachIndex, "\a3\ui_f\data\IGUI\Cfg\Actions\ico_OFF_ca.paa"];
} foreach _magz;

while {alive player && dialog} do {
	sleep 0.1;
	
	if (side player != WF_Client_SideJoined) exitWith {closeDialog 0};
	if !(dialog) exitWith {};
	
	
	if (WF_MenuAction == 111) then {
		WF_MenuAction = -1;		
		
		_idx = lbCurSel 230033;
		_data = call compile lbData[230033, _idx];
		
		if((_data # 0) == 0) then {
			if(_countOfSelectedMagz < _currentLevel) then {
				lbSetPicture [230033, _idx, "\a3\ui_f\data\IGUI\Cfg\Actions\ico_ON_ca.paa"];			
				_rearmPrice= _rearmPrice + round(((missionNamespace getVariable _type) select QUERYUNITPRICE)/10);
				_data set[0, 1];
				_countOfSelectedMagz = _countOfSelectedMagz + 1;
			} else {
				HINT parseText(Format[localize "STR_WF_TANK_MAGZ_NOTALLOW", _currentLevel]);
			};
		} else {
			lbSetPicture [230033, _idx, "\a3\ui_f\data\IGUI\Cfg\Actions\ico_OFF_ca.paa"];
			_rearmPrice= _rearmPrice - round(((missionNamespace getVariable _type) select QUERYUNITPRICE)/10);
			_data set[0, 0];
			_countOfSelectedMagz = _countOfSelectedMagz - 1;
		};
		lbSetData[230033, _idx, str(_data)];

		ctrlSetText [230005,"$"+str(_rearmPrice)];
		
		if(_rearmPrice > 0) then {
			ctrlEnable [22004, true];
		} else {
			ctrlEnable [22004, false];
		};
	};
	
	//--Purchase Button--
	if (WF_MenuAction == 101) then {
		WF_MenuAction = -1;
				
		_curFunds = call WFCL_FNC_GetPlayerFunds;
		
		if(_rearmXPrice > 0) then { _rearmPrice = _rearmXPrice; };
				
		if (_curFunds < _rearmPrice) then {
			hint parseText(Format[localize 'STR_WF_INFO_Funds_Missing', _rearmPrice - _curFunds, ""]);
		} else {
			_veh setVehicleAmmoDef 1;			
			-_rearmPrice Call WFCL_FNC_ChangePlayerFunds;
			for "_j" from 0 to (lbSize 230033) - 1 do {
				_data = call compile lbData [230033, _j];
				if((_data # 0) == 1) then {
					if (WF_Debug) then {
						diag_log format["GUI_Menu_TANK_MAGZ.sqf: Set additional magazine for %1 : %2", typeOf _veh, _data # 1];
					};
						_veh addMagazineTurret [_data # 1,[0]];
				};				
			};
		};
		
		closeDialog 0;
	};
};