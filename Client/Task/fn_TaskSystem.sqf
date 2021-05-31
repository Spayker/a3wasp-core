private ["_i","_location","_locations","_next","_sideID","_sorted","_task","_type"];
params ["_type", ["_location", objNull]];

switch (_type) do {
	//--- Complete Towns set initialization.
	case "TownAddComplete": {
		//--- Todo: improve the sort by with other digits instead of the first one.
		sleep 4;
		Private ["_addOrder","_returned","_town","_towns","_townsLabel"];
		_townsLabel = [];
		if(isNil "towns" || count towns <= 0) exitWith { towns = [] };
		{
		    _locationSpecialities = _x getVariable "townSpeciality";
		    if (count _locationSpecialities == 0) then { _townsLabel = _townsLabel + [_x getVariable 'name'] }
		} forEach towns;
		_towns = ([_townsLabel,true,towns] Call WFCO_fnc_sortArray) # 1;
		
		for '_i' from 0 to count(_towns)-1 do {
			_town = _towns # _i;
			_locationSpecialities = _town getVariable "townSpeciality";
			if (count _locationSpecialities == 0) then{
			waitUntil {_sideID = _town getVariable 'sideID';!isNil '_sideID'};
			_sideID = _town getVariable "sideID";
			_task = player createSimpleTask [Format["TakeTowns_%1",str _town]];

			if (_sideID != WF_Client_SideID) then {
				_task setSimpleTaskDescription [Format[localize "STR_WF_TaskTown",_town getVariable "name"], Format [localize "STR_WF_CHAT_TaskTown_Display",_town getVariable "name"], Format [localize "STR_WF_CHAT_TaskTown_Display",_town getVariable "name"]];
			} else {
				_task setSimpleTaskDescription [Format[localize "STR_WF_TaskTown_Complete",_town getVariable "name"], Format [localize "STR_WF_CHAT_TaskTown_Display",_town getVariable "name"], Format [localize "STR_WF_CHAT_TaskTown_Display",_town getVariable "name"]];
                        _task setTaskState "Succeeded"
			};

			_task setSimpleTaskDestination (getPos _town);
                _town setVariable ['taskLink',_task]
			}
		};
		
		["TownAssignClosest"] Spawn WFCL_FNC_TaskSystem;
	};
	
	//--- Assign the closest town to the player.
	case "TownAssignClosest": {
		sleep 4;
		_next = [player,WF_Client_SideJoined] Call WFCO_FNC_GetClosestLocationBySide;
		if !(isNull _next) then {
			["TownHintNew",_next] Spawn WFCL_FNC_TaskSystem;
			_task = (_next getVariable 'taskLink');
			if!(isNil "_task") then {
			/* Keep the commander order ! */
			if (!isNull comTask) then {
				if (taskState comTask == "Succeeded") then {player setCurrentTask _task};
			} else {
				player setCurrentTask _task;
                }
			}
		}
	};

	//--- Update a town's value.
	case "TownUpdate": {
		_task = _location getVariable 'taskLink';
		_sideID = _location getVariable ["sideID", WF_C_CIV_ID];
		_side = (_sideID) Call WFCO_FNC_GetSideFromID;
		if !(isNil '_task') then {
            _friendlySides = WF_Client_Logic getVariable ["wf_friendlySides", []];
			if (_side in _friendlySides) then {
				_task setTaskState "Succeeded";
				_task setSimpleTaskDescription [Format[localize "STR_WF_TaskTown_Complete",_location getVariable "name"], Format [localize "STR_WF_CHAT_TaskTown_Display",_location getVariable "name"], Format [localize "STR_WF_CHAT_TaskTown_Display",_location getVariable "name"]];
			} else {
				_task setTaskState "Created";
				_task setSimpleTaskDescription [Format[localize "STR_WF_TaskTown",_location getVariable "name"], Format [localize "STR_WF_CHAT_TaskTown_Display",_location getVariable "name"], Format [localize "STR_WF_CHAT_TaskTown_Display",_location getVariable "name"]];
			};
		}
	};

	case "TownCanceled": {
	    _task = _location getVariable 'taskLink';
	    player removeSimpleTask _task;
	};

	//--- Display for a new town task.
	case "TownHintNew": {
		["TaskAssigned",[localize "str_taskNew",format [localize "STR_WF_CHAT_TaskTown_Display",_location getVariable "name"]]] call BIS_fnc_showNotification;
	};
	
	//--- Display for a completed town task.
	case "TownHintDone": {
		["TaskSucceeded",[localize "str_taskAccomplished",format [localize "STR_WF_CHAT_TaskTown_Display",_location getVariable "name"]]] call BIS_fnc_showNotification;
	};
};

