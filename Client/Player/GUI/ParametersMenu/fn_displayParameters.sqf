/* Ingame parameters dump. */

for [{_i = 0},{_i < (count (missionConfigFile/"Params"))},{_i = _i + 1}]  do {
	_paramName = (configName ((missionConfigFile >> "Params") select _i));
	_text = getText (missionConfigFile >> "Params" >> _paramName >> "title");
	_values = getArray (missionConfigFile >> "Params" >> _paramName >> "values");
	_texts = getArray (missionConfigFile >> "Params" >> _paramName >> "texts");
	
	_value = if (isMultiplayer) then {paramsArray select _i} else {getNumber (missionConfigFile >> "Params" >> _paramName >> "default")};
	_status = _texts select (_values find _value);

	lnbAddRow [22003,[_text,_status]];
};

while {alive player && dialog} do {
	sleep 0.1;
	if (side player != WF_Client_SideJoined) exitWith {closeDialog 0};
	if (!dialog) exitWith {};
	
	//--- Back Button.
	if (WF_MenuAction == 1) exitWith { //---added-MrNiceGuy
		WF_MenuAction = -1;
		closeDialog 0;
		createDialog "WF_Menu"
	};
};