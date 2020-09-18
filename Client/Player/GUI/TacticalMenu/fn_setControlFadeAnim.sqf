Private ["_color","_control","_duration","_text","_textcontent"];
_control = _this select 0;
_text = _this select 1;
_duration = _this select 2;
_color = _this select 3;

//--- Animate.
_textcontent = parsetext (Format["<t size='0.8' color='#%1' font='PuristaMedium'>%2</t>",_color,_text]);
with uinamespace do {
	(currentBEDialog displayCtrl _control) ctrlSetStructuredText _textcontent;
	(currentBEDialog displayCtrl _control) ctrlShow true;
};

_i = 0;
while {_i < _duration} do {
	with uinamespace do {
		(currentBEDialog displayCtrl _control) ctrlSetFade (_i % 2);
		(currentBEDialog displayCtrl _control) ctrlCommit 1;
	};

	_i = _i + 1;
	sleep 1;
};

with uinamespace do {
	(currentBEDialog displayCtrl _control) ctrlSetStructuredText parseText ("");
	(currentBEDialog displayCtrl _control) ctrlShow false;
};