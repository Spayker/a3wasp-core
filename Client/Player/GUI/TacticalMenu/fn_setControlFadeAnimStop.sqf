Private ["_control","_duration","_text","_textcontent"];
_control = _this select 0;

with uinamespace do {
	if !(ctrlShown (currentBEDialog displayCtrl _control)) exitWith {};

	(currentBEDialog displayCtrl _control) ctrlSetStructuredText parseText ("");
	(currentBEDialog displayCtrl _control) ctrlShow false;
};