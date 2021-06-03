//Created in 0.6.0

if (! hasInterface) exitWith {};

private _duration = _this select 0;
private _fullDuration = _this select 1;

"detectorLayer" cutRsc ["RscWeaponChemicalDetector", "PLAIN", 1, false];
	
private _ui = uiNamespace getVariable "RscWeaponChemicalDetector";
private _obj = _ui displayCtrl 101;
 
_obj ctrlAnimateModel ["Threat_Level_Source",10 * _duration / _fullDuration, true];