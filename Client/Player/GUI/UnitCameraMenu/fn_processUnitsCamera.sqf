_last_tracked = objNull;
_last_campos = [0,0,0];
_thirdperson = if (difficultyEnabled "3rdPersonView") then {true} else {false};

while { true } do {
	if (isNil {uiNamespace getVariable "wf_dialog_ui_unitscam"}) exitWith {}; //--- Menu is closed.

	_track = uiNamespace getVariable "wf_dialog_ui_unitscam_focus";
	if !(isNil "_track") then {
		if (isNull _track) then {
			uiNamespace setVariable ["wf_dialog_ui_unitscam_focus", player];
			//--- todo select the player back in the LB.
		} else {
			if (_thirdperson) then { //--- No need to do that with 3rd person disabled heh
				if (vehicle _track == _track) then { //--- On Foot.
					_pitch = uiNamespace getVariable "wf_dialog_ui_unitscam_pitch";
					_dir = uiNamespace getVariable "wf_dialog_ui_unitscam_dir";

					_distance = 2.5;
					_relPos = [(sin _dir)*(cos _pitch * _distance),(cos _pitch) * (cos _dir * _distance),1.5-(sin _pitch * _distance)]; //--- Orbit
					if (camTarget WF_UnitsCamera != _track || _last_tracked != _track) then { WF_UnitsCamera camSetTarget _track; WF_UnitsCamera camSetRelPos _relPos; WF_UnitsCamera camCommit 0 };
					WF_UnitsCamera camSetRelPos _relPos;
				} else {
					_vehicle = vehicle _track;
					_pitch = uiNamespace getVariable "wf_dialog_ui_unitscam_pitch";
					_dir = uiNamespace getVariable "wf_dialog_ui_unitscam_dir";

					_distance = switch (true) do {case (_vehicle isKindOf "Car" || _vehicle isKindOf "Motorcycle"): {13.5}; case (_vehicle isKindOf "Tank"): {15}; default {22.5} };
					_relPos = [(sin _dir)*(cos _pitch * _distance),(cos _pitch) * (cos _dir * _distance),1.5-(sin _pitch * _distance)]; //--- Orbit
					if (camTarget WF_UnitsCamera != _vehicle || _last_tracked != _track) then { WF_UnitsCamera camSetTarget vehicle _track; WF_UnitsCamera camSetRelPos _relPos; WF_UnitsCamera camCommit 0 };
					WF_UnitsCamera camSetRelPos _relPos;
				};
			};

			if (uiNamespace getVariable "wf_dialog_ui_unitscam_showmap") then {
				if (WF_UnitsCamera distance _last_campos > 1) then { //--- Only move the camera when there is a change
					_zoffset = (getPos vehicle _track) select 2;
					((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180010) ctrlMapAnimAdd [0, (_zoffset/10) max 0.2 min 0.8, getPos _track]; //.35
					ctrlMapAnimCommit ((uiNamespace getVariable "wf_dialog_ui_unitscam") displayCtrl 180010);
					_last_campos = getPos WF_UnitsCamera;
				};
			};
			WF_UnitsCamera camCommit 0.001;
			_last_tracked = _track;
		};
	};
	sleep .001;
};