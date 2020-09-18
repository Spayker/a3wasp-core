
fnc_marker_keyUp_EH = {
    private["_handled","_display","_dikCode","_control","_text"];
    _display = _this select 0;
    _dikCode = _this select 1;
    _out = false;

    if ((_dikCode == 28) || (_dikCode == 156)) then {
		_control = _display displayCtrl 101;
        _text = ctrlText _control;
        if (_text == "") then {
            _text = format ["%1", name player];
        } else {
            _text = format ["%1: %2", name player, _text];
        };
		_control ctrlSetText _text;		
        _display displayRemoveAllEventHandlers "keyUp";
        _display displayRemoveAllEventHandlers "keyDown";
    };
    _out;
};

fnc_marker_keyDown_EH = {
    private ["_handled", "_display", "_dikCode"];
    _display = _this select 0;
    _dikCode = _this select 1;
    _out = false;

    if (_dikCode == 1) then {
        _display displayRemoveAllEventHandlers "keyUp";
        _display displayRemoveAllEventHandlers "keyDown";
    };
    _out;
};

fnc_map_mouseButtonDblClick_EH = {
    private ["_display"];

    disableUserInput true;
    (time + 2) spawn{
        disableSerialization;

        while {time < _this} do {
            _display = findDisplay 54;
            if (!isNull _display) exitWith {
                _display displayAddEventHandler ["keyUp", "_this call fnc_marker_keyUp_EH"];
                _display displayAddEventHandler ["keyDown", "_this call fnc_marker_keyDown_EH"];
            };
        };
        disableUserInput false;
    };
    true;
};

if (local player) then {
    waitUntil {sleep 0.1; !isNull (findDisplay 12)};
    ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["mouseButtonDblClick", "call fnc_map_mouseButtonDblClick_EH"];
};