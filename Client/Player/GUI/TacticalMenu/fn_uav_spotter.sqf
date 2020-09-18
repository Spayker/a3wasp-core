OperatorUav_delay = 15;  			//Check for new targets every x sec				//co ile sek. sprawdzać nowości
OperatorUav_refreshrate = 5; 		//Refresh markers every x sec. Should be divisible by OperatorUav_delay	//co ile sek. odświeżać markery. Powinno byc podzielne przez OperatorUav_delay
OperatorUav_recogSide = true;		//False for not to color according to the side	//False aby wrogowie nie byli zaznaczani innym kolorem
OperatorUav_disappear = 300;		//Marker will disappear after x sec				//Po tylu sekundach marker zniknie całkiem
OperatorUav_Scan = true;			//Look for new deployed Uavs?					//Czy szukać nowych Uavów (złożonych z plecaka)?
OperatorUav_maxRange = 1000;		//Maximal range. Not higher than 6000.
OperatorUav_range = 1;
		
OperatorUavGetInSight = {
	Private ["_Uav","_UavInSight","_UavSide"];
	_Uav = _this;
	_UavInSight = _Uav getVariable "UavInSight";
	{
		If ( !(lineintersects [aimpos _uav, getposASL _x, _uav, _x]) && !(terrainIntersectASL [getposASL _uav, getposASL _x]) && ((_uav distance _x) < OperatorUav_range) && alive _x && vehicle _x == _x && !(_x isKindOf "Animal") && _x != _uav)
			then {
				If (!(_x in _UavInSight)) then {_UavInSight set [count _UavInSight, _x]};
				_x setVariable ["UavLastSeen", [time, _Uav]];}
	} foreach (_uav nearEntities[["Man","Car","Motorcycle","Tank","Air","Ship", "Static"], OperatorUav_range]);
	_Uav setVariable ["UavInSight",_UavInSight];
	{
	If ((time -((_x getVariable "UavLastSeen")select 0)) <  OperatorUav_delay) then{
            [_x,_Uav] spawn OperatorUavMarker
        }
	} foreach _UavInSight //Deprecated since PvP update by OperatorUavPlayer
};

OperatorUavMarker = {
    If (side (_this select 1) == playerSide) then {
        Private ["_target","_marker","_timestamp","_UavInSight"];
        _target = (_this select 0);
        If (!(_target getVariable ["UavHasMarker",false])) then {

            _target setVariable ["UavHasMarker",true];
            _timestamp = ((_target getVariable "UavLastSeen") select 0);
            _UavInSight = (_this select 1) getVariable "UavInSight";
            _marker = createMarkerLocal [str _target + str random 1, position _target];
            if (vehicle _target isKindOf "Land" && !(vehicle _target isKindOf "Man")) then {
                _marker setMarkerShapeLocal "ICON";
                _marker setmarkertypeLocal "c_car";};
            if (vehicle _target isKindOf "Helicopter") then {
                _marker setmarkershapeLocal "ICON";
                _marker setmarkertypeLocal "c_air";};
            if (vehicle _target isKindOf "Plane") then {
                _marker setmarkershapeLocal "ICON";
                _marker setmarkertypeLocal "c_plane";};
            if (vehicle _target isKindOf "Ship") then {
            _marker setmarkershapeLocal "ICON";
            _marker setmarkertypeLocal "c_ship";};
            _marker setMarkerColorLocal "ColorGreen";
            if (!(OperatorUav_recogSide)) then {_marker setMarkerColorLocal "ColorOrange";};
            if (_target isKindOf "Man") then {
                _marker setmarkershapeLocal "ICON";
                _marker setmarkertypeLocal "mil_triangle_noShadow";
                _marker setMarkerSizeLocal [0.5,0.7]
            };

            while {(_target in _UavInSight) AND (time - _timestamp) < OperatorUav_disappear} do {
                if ((time - _timestamp) < OperatorUav_delay) then {
                    If (OperatorUav_recogSide) then {
                        switch (side _target) do {
                        case EAST:{_marker setMarkerColorLocal "colorEAST"};
                        case West:{_marker setMarkerColorLocal "colorWEST"};
                        case resistance:{_marker setMarkerColorLocal "colorGUER"};
                        case civilian:{_marker setMarkerColorLocal "colorCIV"};
                        default {_marker setMarkerColorLocal "colorUNKNOWN"};
                        };
                    };
                    _marker setMarkerDirLocal (getDir _target);
                    _marker setMarkerPosLocal (getPos _target);
                    _timestamp = ((_target getVariable "UavLastSeen")select 0);
					if(isNil "_timestamp") exitWith {};
                    _marker setMarkerAlphaLocal 1;
                };
				if(isNil "_timestamp") exitWith {};
                _marker setMarkerAlphaLocal ((-(time - _timestamp)+OperatorUav_disappear)/OperatorUav_disappear);
                _timestamp = ((_target getVariable "UavLastSeen")select 0);
				if(isNil "_timestamp") exitWith {};
                sleep OperatorUav_refreshrate;
            };
            deleteMarkerLocal _marker;
            _target setVariable ["UavHasMarker",false];
        };
    };
};
	
OperatorUavGetRange={
    While {!isNil 'playerUAV'} do{
        sleep OperatorUav_refreshrate;
        Private ["_fog","_fogcalc"];
        _fogcalc = 0;
        _fog = fog;
        If (_fog < 0.2 AND _fog >= 0) then { _fogcalc = -23000 * _fog + 6000};
        If (_fog >= 0.2 AND _fog < 0.5) then { _fogcalc = -4000 * _fog + 2200};
        If (_fog >= 0.5 ) then { _fogcalc = -400 * _fog + 400};
        If (_fog < 0) then { _fogcalc = 6000};
        If (_fogcalc > OperatorUav_maxRange) then { _fogcalc = OperatorUav_maxRange};
        OperatorUav_range = _fogcalc
    }
};

OperatorUavPosition = {
    Private ["_uav","_marker"];
    _uav = _this;
    _marker = createMarkerLocal [str _uav + str random 1, position _uav];
    _marker SetMarkerShapeLocal "ELLIPSE";
    _marker setMarkerBrushLocal "Border";
    if (((getPosATL _uav) select 2) > 2) then {_marker setMarkerAlphaLocal 0.5} else {_marker setMarkerAlphaLocal 0};
    _marker setMarkerSizeLocal [OperatorUav_range,OperatorUav_range];
    While {Alive _Uav && canMove _Uav} do {
        sleep OperatorUav_refreshrate;
        _marker setMarkerPosLocal (getPos _uav);
        if (((getPosATL _uav) select 2) > 2) then {_marker setMarkerAlphaLocal 0.5} else {_marker setMarkerAlphaLocal 0};
        _marker setMarkerSizeLocal [OperatorUav_range,OperatorUav_range];
    };
    deleteMarkerLocal _marker;
};

Private ["_uav"];
_uav = _this select 0;
if (isNil "OperatorUavFogLoop") then {OperatorUavFogLoop = _uav spawn OperatorUavGetRange};
_uav setVariable ["UavInSight",[]];
_uav spawn OperatorUavPosition;


While {Alive _uav && alive player} do {
    _uav spawn OperatorUavGetInSight;
    sleep OperatorUav_delay;
};

