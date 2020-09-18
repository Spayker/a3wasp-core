baseb = [
    //[			class					  ,			name					, dis , %]
      ["Base_WarfareBBarracks"            , localize "RB_Barracks"      	, 10  , 3   ],
	  ["Base_WarfareBLightFactory"        , localize "RB_Light_Factory"     , 10  , 2   ],
	  ["Base_WarfareBHeavyFactory"        , localize "RB_Heavy_Factory"     , 10  , 1   ],
	  ["Base_WarfareBUAVterminal"         , localize "RB_Command_Center"    , 10  , 1   ],
	  ["Base_WarfareBAircraftFactory"     , localize "RB_Aircraft_factory"  , 10  , 0.5 ],
	  ["BASE_WarfareBAntiAirRadar"        , localize "RB_Air_Defense_Radar" , 10  , 1.5 ],
	  ["BASE_WarfareBArtilleryRadar"      , localize "RB_Artillery_Radar"   , 10  , 1.5 ],
	  ["Warfare_HQ_base_unfolded"         , localize "RB_Headquarters"      , 10  , 0.5 ],
	  ["BASE_WarfareBFieldhHospital"      , localize "RB_Field_Hospital"    , 10  , 3   ],
	  ["Base_WarfareBVehicleServicePoint" , localize "RB_Service_Point"     , 10  , 2   ]
];

repairprocess = "no";
_isCommander = false;

waitUntil { !isNil "WF_SK_V_Type" };

while {alive player} do {
	/////// SNIPER
	if (WF_SK_V_Type == WF_SNIPER)then{
		_obj = cursortarget;
		_dis = player distance _obj;
		if (!isNull _obj && !(side player == side _obj) && (_dis < 1000) )then{
			for "_i" from 0 to (count baseb) do {
				if (_obj isKindOf (baseb select _i select 0)) then{
					_dam = (1 - getDammage _obj)*100;
					_color = "#00ff00";
					if ( _dam > 67) then {_color = "#00ff00";} else { if ( _dam > 37) then {_color = "#ffe400"} else {_color = "#ff0000"}};  
					_text = composeText [parseText format ["<t size='1.2'>%1:</t><t size='1.2' color='%2' align='center'> %3 %4</t>",localize "RB_state",_color ,str (_dam), "%"]];
					hintSilent _text;
				};
			};
		};
    };
    
	/////// REPAIR BUILD (only commander)
	if (!isNull(commanderTeam)) then {if (commanderTeam == group player) then {_isCommander = true}};
	if (_isCommander) then {
		if (repairprocess == "no") then {
			_obj = cursorTarget;
			if (!isNull _obj && side player == side _obj) then {
				for "_i" from 0 to (count baseb) do {
					if (_obj isKindOf (baseb select _i select 0)) then {
						_dam = (1 - getDammage _obj)*100;
						_color = "#00ff00";
						if ( _dam > 67) then {_color = "#00ff00";} else { if ( _dam > 37) then {_color = "#ffe400"} else {_color = "#ff0000"}};  

						_text = composeText [parseText format ["<t size='1'>%1</t><br /><t size='1.2'>%2:</t><t size='1.2' color='%3' align='center'> %4 %5</t>",(baseb select _i) select 1,localize "RB_state",_color ,str (_dam), "%"]];
						hintSilent _text;
						_dis = player distance _obj; 
						if (_dis < (baseb select _i select 2) && _dam < 100 && isNil "rep") then {
							obj = _obj; objnum = _i;
							repairprocess = "yes";
							rep = player addaction [localize "STR_WASP_actions_brepair","Client\Base\baserep\repair.sqf"];
						};
						if ((_dis > (baseb select _i select 2) || _dam == 100) && !isNil "rep") then {
							player removeAction rep;
							rep = Nil;
						};	        	
					};
				};
			};
		}else{
			_dis = player distance obj;
			if ((_dis > (baseb select objnum select 2)) && !isNil "rep") then {
				player removeAction rep;
				rep = Nil;
				repairprocess = "no";
			};
		};   
		sleep 3;
	};
	sleep 1;
};