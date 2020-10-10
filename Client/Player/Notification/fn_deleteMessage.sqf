
//  Author: Pizza Man
//  File: fn_deleteMessage.sqf
//  Description: Deletes a timed hint-type notification

// Error checks
if (isNull (uiNamespace getVariable ["life_message_hud", displayNull])) exitWith {};
if ((isNil "_thisScript") || !(canSuspend)) exitWith {_this spawn (call compile _fnc_scriptName)};

// Parameters
params[["_ctrlGroup", controlNull, [controlNull]]];

// Queue with message handling
for "_i" from 0 to 1 step 0 do {

    // Check to exit message queue
    if (life_message_active isEqualTo _thisScript) exitWith {};
    waitUntil {uiSleep 0.025; (scriptDone life_message_active)};
    life_message_active = _thisScript;
};

// Error checks
if (isNull _ctrlGroup) exitWith {};

// Hide message
_ctrlGroup ctrlSetFade 1;
_ctrlGroup ctrlCommit 0.20;
waitUntil {ctrlCommitted _ctrlGroup};

// Find message in list
private _index = life_message_list findIf {(_x select 1) isEqualTo _ctrlGroup};
if (_index isEqualTo -1) exitWith {false};

{

    // Init
    _x params ["_priority", "_control"];

    // All messages after insert
    if (_forEachIndex > _index) then {

        // Init
        private _messagePadding = 0.01;
        private _controlPosition = ctrlPosition _control;

        // Animate position down
        _controlPosition set [1, parseNumber(((_controlPosition select 1) - ((ctrlPosition _ctrlGroup) select 3) - _messagePadding) toFixed 4)];
        _control ctrlSetPosition _controlPosition;
        _control ctrlCommit 0.20;
    };
} forEach life_message_list;

// Wait until all control groups have been moved to new position
if ((count life_message_list) >= 1) then {waitUntil {ctrlCommitted ((life_message_list select ((count life_message_list) - 1)) select 1)}};

// Remove message from list - Not really necessary
private _index = life_message_list findIf {(_x select 1) isEqualTo _ctrlGroup};
if !(_index isEqualTo -1) then {life_message_list deleteAt _index};
if (!isNull _ctrlGroup) then {ctrlDelete _ctrlGroup};