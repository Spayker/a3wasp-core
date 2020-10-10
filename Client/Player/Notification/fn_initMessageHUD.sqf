
//  Author: Pizza Man
//  File: fn_initMessageHUD.sqf
//  Description: Initalize the display for handling notifications

// Check if message hud already exists
if (!isNull (uiNamespace getVariable ["life_message_hud", displayNull])) exitWith {true};

// Create display
2 cutRsc ["life_message_hud", "PLAIN"];
private _display = uiNamespace getVariable ["life_message_hud", displayNull];

// Reset message variables
life_message_active = scriptNull;
life_message_list = [];

// Exit
!isNull _display;