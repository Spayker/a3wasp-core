params ["_displayorcontrol", "_key", "_shift", "_ctrl", "_alt"];

//--Player jump handler--BEGIN----------------------------------------------------------------------------------------//
if (_shift && _key == 47 && speed player > 8) then {
	private _max_height = 4.3;// SET MAX JUMP HEIGHT

	if (player == vehicle player && player getvariable ["jump", true] and isTouchingGround player) then {		
		player setvariable ["jump",false]; // DISABLE JUMP
	
		private _height = 6 - ((load player)*10); // REDUCE HEIGHT BASED ON WEIGHT

		// MAKE JUMP IN RIGHT DIRECTION
		private _vel = velocity player;
		private _dir = direction player;
		private _speed = 0.4;
		If (_height > _max_height) then {_height = _max_height}; // MAXIMUM HEIGHT OF JUMP 
		player setVelocity [(_vel select 0)+(sin _dir*_speed),(_vel select 1)+(cos _dir*_speed),(_vel select 2)+_height];
				
		[player] remoteExec ["WFCL_FNC_doJump", -2]; //BROADCAST ANIMATION		
		player spawn { sleep 1; _this setvariable ["jump",true]; }; //RE-ENABLE JUMP    
	};
};    
//--Player jump handler--END------------------------------------------------------------------------------------------//

//--INS/REMOVE earplugs handler--BEGIN--------------------------------------------------------------------------------//
if (_key in (actionKeys "User18")) then {		
	if(player getvariable["_earplugs", true]) then {
		0.1 fadeSound 0.1;
		player setvariable["_earplugs", false];
		HINT parseText(localize 'STR_HINT_EARPLUGS_INSERTED');
	} else {
		0.1 fadeSound 1;
		player setvariable["_earplugs", true];
		HINT parseText(localize 'STR_HINT_EARPLUGS_REMOVED');
	}		
};
//--INS/REMOVE earplugs handler--END----------------------------------------------------------------------------------//

//--Open WFMenu handler--BEGIN----------------------------------------------------------------------------------------//
if (_key in (actionKeys "User19")) then {
	if (!dialog) then {
		if(alive player) then {
		    createDialog "WF_Menu"
		};
	};
};
//--Open WFMenu handler--END------------------------------------------------------------------------------------------//

//--Change view distance handler--BEGIN-------------------------------------------------------------------------------//
if (_key in (actionKeys "User14") || _key in (actionKeys "User15")) then {		
	_currentVD = viewDistance;		
	
	if(_key in (actionKeys "User14")) then {
		if(_currentVD > 300) then {
			_currentVD = _currentVD - 100;					
		};
	};
	
	if(_key in (actionKeys "User15")) then {
		if(_currentVD < (missionNamespace getVariable "WF_C_ENVIRONMENT_MAX_VIEW")) then {
			_currentVD = _currentVD + 100;
		};
	};
	
	HINT parseText(format["%1 %2", localize "STR_WF_PARAMETER_ViewDistance_KEYBOARDCHANGED", _currentVD]);
	setViewDistance _currentVD;
	if !(isNil 'WFCO_FNC_SetProfileVariable') then {
		['WF_PERSISTENT_CONST_VIEW_DISTANCE', _currentVD] Call WFCO_FNC_SetProfileVariable;
	};
	
	if !(isNil 'WFCO_FNC_SaveProfile') then {Call WFCO_FNC_SaveProfile};
};
//--Change view distance handler--END---------------------------------------------------------------------------------//

//--Unflip vehicle handler--BEGIN-------------------------------------------------------------------------------------//
if (_key in (actionKeys "User2")) then {
	_vehicle = vehicle player;

    if (player == _vehicle) then {
    	_objects = player nearEntities[["Car","Motorcycle","Tank","Air"],10];
    	if (count _objects > 0) then {
    		{
    			if (getPos _x select 2 > 3 && !surfaceIsWater (getPos _x)) then {
    				[_x] Call WFCO_FNC_BrokeTerObjsAround;

    				[_x, getPos _x, 15] Call WFCO_FNC_PlaceSafe;
    			} else {
    				[_x] Call WFCO_FNC_BrokeTerObjsAround;

    				_x setPos [getPos _x select 0, getPos _x select 1, 0.5];
    				_x setVelocity [0,0,-0.5];
    			};
    		} forEach _objects;
    	};
    };
};
//--Unflip vehicle handler--END---------------------------------------------------------------------------------------//