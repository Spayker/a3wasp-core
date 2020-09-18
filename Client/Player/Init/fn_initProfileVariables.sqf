/*
	Attempt to load variables from the client profileNamespace.
		Note:
			- Do not use "with" as it won't work with the profileNamespace.
			- Sanitize the variable to prevent variable hijacking.
*/

//--- View distance.
_profile_var = profileNamespace getVariable "WF_PERSISTENT_CONST_OBJECT_DISTANCE";
if !(isNil '_profile_var') then {
	if (typeName _profile_var == "SCALAR") then {
		if (_profile_var <= (missionNamespace getVariable "WF_C_OBJECT_MAX_VIEW")) then {
			setObjectViewDistance _profile_var;
		};
	};
};

//--- View distance.
_profile_var = profileNamespace getVariable "WF_PERSISTENT_CONST_VIEW_DISTANCE";
if !(isNil '_profile_var') then {
	if (typeName _profile_var == "SCALAR") then {
		if (_profile_var <= (missionNamespace getVariable "WF_C_ENVIRONMENT_MAX_VIEW")) then {
			setViewDistance _profile_var;
		};
	};
};

//--Shadows Distance--
_profile_var = profileNamespace getVariable "WF_PERSISTENT_CONST_SHADOWS_DISTANCE";
if !(isNil '_profile_var') then {
	if (typeName _profile_var == "SCALAR") then {
		if (_profile_var <= 200) then {
			setShadowDistance _profile_var;
			currentSD = _profile_var;
		};
	};
};

//--- Terrain Grid.
_profile_var = profileNamespace getVariable "WF_PERSISTENT_TERRAIN_GRID";
if !(isNil '_profile_var') then {
	if (typeName _profile_var == "SCALAR") then {
		if (_profile_var <= (missionNamespace getVariable "WF_C_ENVIRONMENT_MAX_CLUTTER")) then {
			setTerrainGrid _profile_var;
			currentTG = _profile_var;
		};
	};
};

["INITIALIZATION", "Init_ProfileVariables.sqf: Possible profile variables were defined."] Call WFCO_FNC_LogContent;