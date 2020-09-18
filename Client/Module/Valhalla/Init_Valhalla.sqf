/*
	Script from Valhalla.
*/

VALHALLA_FNC_LowGear = compile preprocessFileLineNumbers "Client\Module\Valhalla\Func_Client_LowGear.sqf";

Local_HighClimbingModeOn = false;
Local_KeyPressedForward = false;

(findDisplay 46) displayAddEventHandler ["KeyDown",'Private ["_key"]; _key=_this select 1; if (_key in actionKeys "carForward" || _key in actionKeys "carFastForward" || _key in actionKeys "carSlowForward") then {Local_KeyPressedForward = true}'];
(findDisplay 46) displayAddEventHandler ["KeyUp","Local_KeyPressedForward=false;"];
