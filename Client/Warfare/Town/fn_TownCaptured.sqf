/*
	Triggered everytime a capture is done (town captured or lost).
	 Parameters:
		- Town
		- Old side ID.
		- New side ID.
*/

private ["_color","_townMarker","_sv", "_townSpecialities"];
params ["_town", "_townName", "_town_side_value", "_town_side_value_new"];

_sv = _town getVariable "supplyValue";
_townSpecialities = _town getVariable "townSpeciality";
//--- Make sure that the client is concerned by the capture either by capturing or having a town captured.
if !(WF_Client_SideID in [_town_side_value,_town_side_value_new]) exitWith {};

_side_captured = (_town_side_value_new) Call WFCO_FNC_GetSideFromID;

//--- Color the town depending on the side which captured.
_color = missionNamespace getVariable (Format ["WF_C_%1_COLOR", _side_captured]);
_townMarker = Format ["WF_%1_CityMarker", _town getVariable "name"];
_townMarker setMarkerColorLocal _color;

//--- Display a title message.
_side_label = switch (_side_captured) do {case west: {localize "STR_WF_PARAMETER_Side_West"}; case east: {localize "STR_WF_PARAMETER_Side_East"}; case resistance: {localize "STR_WF_Side_Resistance"};	default {"Civilian"}};

//--- Task.
_task = _town getVariable 'taskLink';
_ptask = currentTask player;
if (isNil '_task') then {_task = objNull};

//--- Taskman
["TownUpdate", _town] Spawn WFCL_FNC_TaskSystem;

//--- Client side capture.
if (_town_side_value_new == WF_Client_SideID) then {

	//--- Retrieve the closest unit of the town.
	_closest = [_town, (units group player) Call WFCO_FNC_GetLiveUnits] Call WFCO_FNC_GetClosestEntity;
	
	//--- Client reward.
	_isComNear = false;
	if !(isNull _closest) then {
		//--- Check if the closest unit of the town in in range.
		_distance = _closest distance _town;
		
		_bonus = -1;
		_score = -1;
		if (_distance <= (missionNamespace getVariable "WF_C_TOWNS_CAPTURE_RANGE")) then {
			//--- Capture
			_bonus= 150*_sv;
			_score = missionNamespace getVariable "WF_C_PLAYERS_SCORE_CAPTURE";
		} else {
			//--- Is it an assist?.
			if (_distance <= (missionNamespace getVariable "WF_C_TOWNS_CAPTURE_ASSIST")) then {
				//--- Assist.
				_bonus= 150*_sv;
				_score = missionNamespace getVariable "WF_C_PLAYERS_SCORE_CAPTURE_ASSIST";
			};
		};
		
		//--- Update the funds if necessary.
		if (_bonus != -1) then {
		    _comBonus = 0;
            if !(isNull commanderTeam) then {
                if (commanderTeam == group player) then {
                    _isComNear = true;
                    _comBonus = (_town getVariable "startingSupplyValue") * (missionNamespace getVariable "WF_C_PLAYERS_COMMANDER_BOUNTY_CAPTURE_COEF")
                }
            };

			(_bonus + _comBonus) Call WFCL_FNC_ChangePlayerFunds;
			Format[Localize "STR_WF_CHAT_Town_Bounty_Full", _townName, _bonus] Call WFCL_FNC_CommandChatMessage;
		};
		
		//--- Update the score necessary.
		if (_score != -1) then {
			[player,score player + _score] remoteExecCall ["WFSE_fnc_RequestChangeScore",2];
		};
	};
	
	//--- Commander reward (if the player is the commander)
	if!(_isComNear) then {
	if !(isNull commanderTeam) then {
		if (commanderTeam == group player) then {
			_bonus = (_town getVariable "startingSupplyValue") * (missionNamespace getVariable "WF_C_PLAYERS_COMMANDER_BOUNTY_CAPTURE_COEF");
			if !(isNil "_bonus") then {
			(_bonus) Call WFCL_FNC_ChangePlayerFunds;
                    Format[Localize "STR_WF_CHAT_Commander_Bounty_Town", _bonus, _townName] Call WFCL_FNC_CommandChatMessage
		};
            [player,score player + (missionNamespace getVariable "WF_C_PLAYERS_COMMANDER_SCORE_CAPTURE")] remoteExecCall ["WFSE_fnc_RequestChangeScore",2]
		}
        }
	};
	
	//--- Taskman
	if !(isNull _task) then {
		if (_ptask == _task) then {
			["TownAssignClosest"] Spawn WFCL_FNC_TaskSystem;
		};
	};
};