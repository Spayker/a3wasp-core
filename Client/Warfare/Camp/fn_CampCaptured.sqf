/*
	A camp has been captured by a unit or repaired.
	 Parameters:
		- Camp.
		- New Side.
		- Old Side.
		- {Is repaired}.
*/

private ["_side","_side_new","_town"];
params ["_camp", "_sideID_new", "_sideID_old", ["_is_repair", false]];

_town = _camp getVariable "town";

//--- Does the new side match the client side?
if (WF_Client_SideID == _sideID_new) then {
	//--- The client side has captured a camp.
	(_camp getVariable "wf_camp_marker") setMarkerColorLocal WF_Client_Color;

	//--- Skip the reset upon repair.
	if (_is_repair) exitWith {};

	//--- Attempt to award the client if his orders were to take a town.
	// if ((WF_Client_Team getVariable "wf_task_order") == "towns") then {
		//--- Ensure that the destination is the camp's town.
		// if ((WF_Client_Team getVariable "wf_task_position") == _town) then {
			Private ["_closest"];
			//--- Get the closest unit from the player group near the camp.
			_closest = [_camp, units group player] Call WFCO_FNC_GetClosestEntity;

			//--- If the closest unit is in range, then award the player's group.
			if (_closest distance _camp < (missionNamespace getVariable "WF_C_CAMPS_RANGE")) then {
				hint parseText Format[localize "STR_WF_CHAT_Camp_Captured_Bounty",_town getVariable "name",missionNamespace getVariable "WF_C_CAMPS_CAPTURE_BOUNTY"];
				[player,score player + (missionNamespace getVariable 'WF_C_PLAYERS_SCORE_CAPTURE_CAMP')] remoteExecCall ["WFSE_fnc_RequestChangeScore",2];
				
				(missionNamespace getVariable "WF_C_CAMPS_CAPTURE_BOUNTY") Call WFCL_FNC_ChangePlayerFunds;
				["INFORMATION", Format ["Player %1 has captured camp in town: %2).", name player, _town getVariable "name"]] Call WFCO_FNC_LogContent;
			} else {
			    if(!(isNil 'commanderTeam')) then {
			        if (commanderTeam == group player) then {
                        _hcGroups = [WF_Client_SideJoined] call WFCO_FNC_getHighCommandGroups;
                        if (count _hcGroups > 0) then {
                            {
                                _closest = [_camp, units _x] Call WFCO_FNC_GetClosestEntity;
                                if (_closest distance _camp < (missionNamespace getVariable "WF_C_CAMPS_RANGE")) exitWith {
                                    hint parseText Format[localize "STR_WF_CHAT_Camp_Captured_Bounty",_town getVariable "name",missionNamespace getVariable "WF_C_CAMPS_CAPTURE_BOUNTY"];
                                    [player,score player + (missionNamespace getVariable 'WF_C_PLAYERS_SCORE_CAPTURE_CAMP')] remoteExecCall ["WFSE_fnc_RequestChangeScore",2];

                                    (missionNamespace getVariable "WF_C_CAMPS_CAPTURE_BOUNTY") Call WFCL_FNC_ChangePlayerFunds;
                                    ["INFORMATION", Format ["Player %1 has captured camp in town: %2).", name player, _town getVariable "name"]] Call WFCO_FNC_LogContent;
                                }
                            } forEach _hcGroups
                        }
                    }
			    }
			}
		// };
	// };
} else {
	//--- Did the client side lost a known camp?
	if (WF_Client_SideID in [(_town getVariable "sideID"), _sideID_old]) then {
		(_camp getVariable "wf_camp_marker") setMarkerColorLocal (missionNamespace getVariable Format ["WF_C_%1_COLOR",(_sideID_new) Call WFCO_FNC_GetSideFromID]);
	};
};