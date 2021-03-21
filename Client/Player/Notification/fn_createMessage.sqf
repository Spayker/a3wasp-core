
//  Author: Pizza Man
//  File: fn_createMessage.sqf
//  Description: Creates a timed hint-type notification

// Parameters
params [["_insertIndex", 0], ["_text", ""], ["_duration", 5], ["_priority", 5], ["_color", [0.50, 0, 0]], ["_condition", {true}]];
if (_text isEqualTo "") exitWith {};
private ["_control", "_progress"];

// Check if display needs to be created first
if !(call WFCL_fnc_initMessageHUD) exitWith {};

// Find display
disableSerialization;
private _display = uiNamespace getVariable ["life_message_hud", displayNull];
if (isNull _display) exitWith {};

// Init main control group info
private _mainCtrlGroup = _display displayCtrl 245001;
private _mainCtrlGroupSize = ctrlPosition _mainCtrlGroup;
_mainCtrlGroupSize params ["_mainCtrlGroupX", "_mainCtrlGroupY", "_mainCtrlGroupW", "_mainCtrlGroupH"];

// Create sub-contol group
private _ctrlGroup = _display ctrlCreate ["Life_RscControlsGroupNoScrollbars", -1, _mainCtrlGroup];
_ctrlGroup ctrlSetPosition [0, 0, _mainCtrlGroupW, _mainCtrlGroupH];
_ctrlGroup ctrlSetFade 1;
_ctrlGroup ctrlCommit 0;

// Init sub-contol group info
private _ctrlGroupSize = ctrlPosition _ctrlGroup;
_ctrlGroupSize params ["_ctrlGroupX", "_ctrlGroupY", "_ctrlGroupW", "_ctrlGroupH"];

// Figure colors
_color pushBack 0.80;
private _colorBackground = _color;
_colorBackground set [3, ((_color select 3) - 0.30) max 0];

// Create RscProgress
_progress = _display ctrlCreate ["RscProgress", 1001, _ctrlGroup];
_progress ctrlSetPosition [0, 0, _ctrlGroupW, 0.01];
_progress ctrlSetTextColor _color;
_progress progressSetPosition 1;
_progress ctrlCommit 0;

// Create RscProgress background
_control = _display ctrlCreate ["Life_RscText", -1, _ctrlGroup];
_control ctrlSetPosition (ctrlPosition _progress);
_control ctrlSetBackgroundColor _colorBackground;
_control ctrlCommit 0;

// Create RscStructuredText
_control = _display ctrlCreate ["Life_RscStructuredText", 1000, _ctrlGroup];
_control ctrlSetStructuredText (parseText format["<t size='0.90'>%1</t>", _text]);
_control ctrlSetPosition [0, 0.01, _ctrlGroupW, 0.05];
_control ctrlSetBackgroundColor [0, 0, 0, 0.75];
_control ctrlCommit 0;

// Adjust for message height
private _messageHeight = 0.00;
_control ctrlSetPosition [0, 0.01, _ctrlGroupW, (ctrlTextHeight _control) + 0.01];
_control ctrlCommit 0;

{

    // Control does not overlap
    if !(_forEachIndex isEqualTo 1) then {

        // Add messsage height to total
        _messageHeight = _messageHeight + ((ctrlPosition _x) select 3);
    };
} forEach ((allControls _display) select {(ctrlParentControlsGroup _x) isEqualTo _ctrlGroup});
_ctrlGroup ctrlSetPosition [0, 0, _mainCtrlGroupW, _messageHeight];
_ctrlGroup ctrlSetFade 1;
_ctrlGroup ctrlCommit 0;

// Init
private _startPositionY = 0;

{

    // Init
    _x params ["_priority", "_control"];
    private _messagePadding = 0.01;

	// All messages after insert
	if (_forEachIndex >= _insertIndex) then {

	    // Animate position down
	    private _controlPosition = ctrlPosition _control;
	    _controlPosition set [1, parseNumber(((_controlPosition select 1) + ((ctrlPosition _ctrlGroup) select 3) + _messagePadding) toFixed 4)];
	    _control ctrlSetPosition _controlPosition;
	    _control ctrlCommit 0.20;
	} else {

        // Update start position
        _startPositionY = _startPositionY + ((ctrlPosition _control) select 3) + _messagePadding;
    };
} forEach life_message_list;

// Wait until all control groups have been moved to new position and then insert new message to master list
if ((count life_message_list) > 0) then {
    if(count (life_message_list select ((count life_message_list) - 1)) > 1) then {
        _control = (life_message_list select ((count life_message_list) - 1)) select 1;
        waitUntil {
            ctrlCommitted (_control)
        }
    }
};
life_message_list = [life_message_list, [_priority, _ctrlGroup], _insertIndex] call WFCL_fnc_insertElement;

// Move to start position
private _currentPosition = ctrlPosition _ctrlGroup;
_currentPosition set [1, _startPositionY];
_ctrlGroup ctrlSetPosition _currentPosition;
_ctrlGroup ctrlCommit 0;

// Show message
_ctrlGroup ctrlSetFade 0;
_ctrlGroup ctrlCommit 0.20;
waitUntil {ctrlCommitted _ctrlGroup};

// Animate progress bar
[_ctrlGroup controlsGroupCtrl 1001, _duration, _condition] spawn{

    // Init
    params [["_progress", controlNull], ["_duration", 5], ["_condition", {true}]];
    if (isNull _progress) exitWith {};

    // Init
    private _endTime = time + _duration;

    // Animate progress bar
    for "_i" from 0 to 1 step 0 do {

        // Ensure notification is visible before progressing
        waitUntil {(ctrlFade (ctrlParentControlsGroup _progress)) isEqualTo 0};

        // Animate progress bar
        _progress progressSetPosition ((_endTime - time) / _duration);
        if ((isNull _progress) || (time >= _endTime)) exitWith {};
        if !(call _condition) exitWith {};

        // Wait
        uiSleep 0.01;
    };

    // Remove message
    [ctrlParentControlsGroup _progress] call WFCL_fnc_deleteMessage;
};

// Exit
_ctrlGroup;