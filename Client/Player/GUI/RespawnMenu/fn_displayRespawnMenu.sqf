uiNamespace setVariable ["wf_display_respawn", _this select 0];

_map =  (_this select 0) displayCtrl 511001;
_drawMarkerId = _map ctrlAddEventHandler ["Draw", WF_C_MAP_MARKER_HANDLER];

//--- Focus on the player death location.
_map ctrlMapAnimAdd [0, .095, WF_DeathLocation];
ctrlMapAnimCommit ((uiNamespace getVariable "wf_display_respawn") displayCtrl 511001);


//--- Recall the last gear mode.
ctrlSetText [511004, if (WF_RespawnDefaultGear) then {localize "STR_WF_RESPAWN_GearDefault"} else {localize "STR_WF_RESPAWN_GearCurrent"}];

//--- Register the UI (if needed).
if (isNil 'WF_RespawnTime') then {
	WF_RespawnTime = missionNamespace getVariable "WF_C_RESPAWN_DELAY";
	[] Spawn {
		while {WF_RespawnTime > 0} do {
			sleep 1;			
			WF_RespawnTime = WF_RespawnTime - 1;
			if(WF_GameOver) then {WF_RespawnTime = 0};
		};
	};
};

_spawn_time = -1;_spawn_last_get = 0;
_spawn_at = objNull;_spawn_at_current = objNull;
_spawn_locations = [];
_spawn_locations_last = [];
_spawn_markers = [];
WF_MenuAction = -1;mouseButtonDown = -1;mouseButtonUp = -1;

//--- Start the tracker.
WF_MarkerTracking = objNull;
[] Spawn WFCL_FNC_respawnSelector;

while {WF_RespawnTime > 0 && dialog && alive player && !WF_GameOver} do
{
	//--- Toggle default gear.
	if (WF_MenuAction == 1) then {
		WF_MenuAction = -1;
		WF_RespawnDefaultGear = if (WF_RespawnDefaultGear) then {false} else {true};
		ctrlSetText [511004, if (WF_RespawnDefaultGear) then {localize "STR_WF_RESPAWN_GearDefault"} else {localize "STR_WF_RESPAWN_GearCurrent"}];
	};
	
	//--- Refresh all
	if (time - _spawn_last_get > 1) then {
		_spawn_last_get = time;
		
		//--- Return the available spawn locations
		_spawn_locations = [WF_Client_SideJoined, WF_DeathLocation] Call WFCL_FNC_GetRespawnAvailable;

		//---No spawn available at frist? get one!
		if (isNull _spawn_at_current) then {
			_spawn_at_current = [WF_DeathLocation, _spawn_locations] Call WFCO_FNC_GetClosestEntity;
		};
		
		//--- Remove some old spawn location if needed.
		_found = false;
		{
			if !(_x in _spawn_locations) then {
				_marker_id = _x getVariable 'wf_respawn_marker';
				if!(isNil '_marker_id') then {
				_index = _spawn_markers find _marker_id;
				if(_index > -1)then{_spawn_markers deleteAt _index};

				deleteMarkerLocal _marker_id;
				_x setVariable ['wf_respawn_marker', nil];
				if (_x == _spawn_at_current && !_found) then {
					_found = true;
					_spawn_at_current = [WF_DeathLocation, _spawn_locations] Call WFCO_FNC_GetClosestEntity;
                    }
				}
			}
		} forEach _spawn_locations_last;
		
		//--- Add markers to the spawn if needed.
		{
            if !(_x in _spawn_locations_last) then {
                _marker = createMarkerLocal [Format ["wf_cli_respawn_m%1", unitMarker], getPosATL _x];
                unitMarker = unitMarker + 1;
                _spawn_markers pushBack _marker;
                _marker setMarkerTypeLocal "Select";
                _marker setMarkerColorLocal "ColorYellow";
                _marker setMarkerSizeLocal [1,1];
                _x setVariable ['wf_respawn_marker', _marker];
            } else {
                _marker_id = _x getVariable 'wf_respawn_marker';
                if (getMarkerPos _marker_id distance _x > 1) then {_marker_id setMarkerPosLocal (getPosATL _x)};
            };
		} forEach _spawn_locations;
		_spawn_locations_last = _spawn_locations;
	};
	//--- Update timer.
	if (_spawn_time != WF_RespawnTime) then {
		_spawn_time = WF_RespawnTime;
		((uiNamespace getVariable "wf_display_respawn") displayCtrl 511002) ctrlSetStructuredText parseText Format[localize "STR_WF_RESPAWN_Status", WF_RespawnTime];
	};
	
	//--- Update spawn location.
	if (_spawn_at != _spawn_at_current) then {
		_spawn_at = _spawn_at_current;
		_spawn_label = getText(configFile >> 'CfgVehicles' >> typeOf _spawn_at >> 'displayname');
		((uiNamespace getVariable "wf_display_respawn") displayCtrl 511003) ctrlSetStructuredText parseText Format[localize "STR_WF_RESPAWN_Status_AT", _spawn_label];
		WF_MarkerTracking = _spawn_at;
	};
	
	//--- A Minimap click has been performed.
	if (mouseButtonDown == 0 && mouseButtonUp == 0) then {
		mouseButtonDown = -1;
		mouseButtonUp = -1;
		//--- Attempt to get the nearest respawn of the click.
		_clicked_at = ((uiNamespace getVariable "wf_display_respawn") displayCtrl 511001) ctrlMapScreenToWorld [mouseX, mouseY];
		_nearest = [_clicked_at, _spawn_locations] Call WFCO_FNC_GetClosestEntity;
		if (_nearest distance _clicked_at < 500) then {_spawn_at_current = _nearest};
	};

	sleep .01;
};

//--If game is over while RespMenu is shown, close it--
if(WF_GameOver) then {

	//--- Destroy the camera.
	if !(isNil 'WF_DeathCamera') then {
		WF_DeathCamera cameraEffect ["TERMINATE", "BACK"];
		camDestroy WF_DeathCamera;
	};

	//--- Remove PP FX.
	"dynamicBlur" ppEffectEnable false;
	"colorCorrections" ppEffectEnable false;
	
	//--- Fade out.
	titleCut["","BLACK IN",1];

	WF_MarkerTracking = nil;
	{deleteMarkerLocal _x} forEach _spawn_markers;

	//--- Close dialog if opened.
	if (dialog) then {
	    _map ctrlRemoveEventHandler ["Draw", _drawMarkerId];
	    closeDialog 0
	};
	
	//--- Release the UI.
	uiNamespace setVariable ["wf_display_respawn", nil];
	
	if(WF_GameOver)exitWith{};
} else {
	//--- Process if alive.
	if (alive player) then {
		//--- Exit mode.
		if (WF_RespawnTime > 0) then {
			//--- Premature exit.
			(_spawn_at_current) Spawn {
				sleep 1;
				if (WF_RespawnTime > 0) then {
					createDialog "WF_RespawnMenu";
				} else {
					//--- Normal exit.
					WF_DeathLocation = nil;
					WF_RespawnTime = nil;
					
					//--- Execute actions on respawn.
					[player,_this] Call WFCL_FNC_onRespawnHandler;
					
					//--- Destroy the camera.
					if !(isNil 'WF_DeathCamera') then {
						WF_DeathCamera cameraEffect ["TERMINATE", "BACK"];
						camDestroy WF_DeathCamera;
					};

					//--- Remove PP FX.
					"dynamicBlur" ppEffectEnable false;
					"colorCorrections" ppEffectEnable false;

					//--- Fade out.
					titleCut["","BLACK IN",1];

				};
			};
		} else {
			//--- Normal exit.
			WF_DeathLocation = nil;
			WF_RespawnTime = nil;
			
			//--- Execute actions on respawn.
			[player,_spawn_at_current] Call WFCL_FNC_onRespawnHandler;
			
			//--- Destroy the camera.
			if !(isNil 'WF_DeathCamera') then {
				WF_DeathCamera cameraEffect ["TERMINATE", "BACK"];
				camDestroy WF_DeathCamera;
			};

			//--- Remove PP FX.
			"dynamicBlur" ppEffectEnable false;
			"colorCorrections" ppEffectEnable false;
			
			//--- Fade out.
			titleCut["","BLACK IN",1];
		};
	} else {
		//--- Died while respawning.
		WF_DeathLocation = nil;
		WF_RespawnTime = nil;

		//--- Destroy the camera.
		if !(isNil 'WF_DeathCamera') then {
			WF_DeathCamera cameraEffect ["TERMINATE", "BACK"];
			camDestroy WF_DeathCamera;
		};

		//--- Remove PP FX.
		"dynamicBlur" ppEffectEnable false;
		"colorCorrections" ppEffectEnable false;

		//--- Fade out.
        titleCut["","BLACK IN",1];
	};

	WF_MarkerTracking = nil;
	{deleteMarkerLocal _x} forEach _spawn_markers;

	//--- Close dialog if opened.
	if (dialog) then {
	    _map ctrlRemoveEventHandler ["Draw", _drawMarkerId];
	    closeDialog 0
	};

	//--- Release the UI.
	uiNamespace setVariable ["wf_display_respawn", nil];

	//--- Fade out.
    titleCut["","BLACK IN",1];
};