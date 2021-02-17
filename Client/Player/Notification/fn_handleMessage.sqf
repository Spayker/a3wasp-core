
//  Author: Pizza Man
//  File: fn_handleMessage.sqf
//  Description: Handle the creation of new messages

// Error checks
waitUntil {!isNil "clientInitComplete"};
waitUntil {clientInitComplete};

if ((isNil "_thisScript") || !(canSuspend)) exitWith {_this spawn (call compile _fnc_scriptName)};

// Parameters
params [["_text", ""], ["_duration", 5], ["_priority", 5], ["_color", [0.50, 0, 0]], ["_condition", {true}]];
if (_text isEqualTo "") exitWith {};
if (_text isEqualTo WF_PREVIOUS_HINT_MESSAGE) exitWith {};

playSound "Hint";
WF_PREVIOUS_HINT_MESSAGE = _text;

// Queue message handling
for "_i" from 0 to 1 step 0 do {

	// Check to exit message queue
	if (life_message_active isEqualTo _thisScript) exitWith {};
	waitUntil {uiSleep 0.025; (scriptDone life_message_active)};
	life_message_active = _thisScript;
};

// Clean message list of any bad controls
life_message_list = life_message_list select {!isNull (_x select 1)};

// Init
private _insertIndex = 0;
private _currentMessages = +life_message_list;
reverse _currentMessages;

// Find target index
private _foundPriorities = {(_x select 0) isEqualTo _priority} count _currentMessages;
{if ((_x select 0) >= _priority) exitWith {_insertIndex = ((count _currentMessages) - (_forEachIndex + _foundPriorities))}} forEach _currentMessages;

// Create message
[_insertIndex, _text, _duration, _priority, _color, _condition] call WFCL_fnc_createMessage;
