_veh = _this select 0;
_pylonsEquipment = _this select 1;

//--Given: vehicle pointer, pylons arr--
functionDoLoadOut = {
	_vh = _this select 0;
	_plns = _this select 1;
	for "_j" from 0 to (count _plns) - 1 do {
		//_pylonConf = [];					
		for "_k" from 0 to (count (_plns select _j)) - 1 do {
			if(_k < 4) then {				
				_vh setVariable[format['_p%1', _k], (_plns select _j) select _k];
			};
		};		
		
		if(!(isNil { _vh getVariable  '_p2'} ) && !(isNil { _vh getVariable '_p3'} )) then {			
			_vh setPylonLoadOut[_vh getVariable '_p0', _vh getVariable '_p1', _vh getVariable '_p2', _vh getVariable '_p3'];
		} else {
			if(!(isNil { _vh getVariable  '_p2'} )) then {				
				_vh setPylonLoadOut[_vh getVariable '_p0', _vh getVariable '_p1', _vh getVariable '_p2'];
			} else {				
				_vh setPylonLoadOut[_vh getVariable '_p0', _vh getVariable '_p1'];
			};
		};
		
		if(count (_plns select _j) == 5) then {			
			_vh setAmmoOnPylon [_vh getVariable '_p0', (_plns select _j) select 4];			
		};
	};
};

[_veh, _pylonsEquipment] spawn functionDoLoadOut;