/*
	Create a unit.
	 Parameters:
		- Classname
		- Group
		- Position
		- Side ID
		- {Global Init}
		- {PLacement}
*/

params ["_unit", "_type", "_group", "_position", "_sideId", ["_global", true]];
private ["_get", "_skill"];

_side = _sideId call WFCO_FNC_GetSideFromID;
if(isNil '_group') then { _group = createGroup [_side, true]; };

//--Set unit skill according config core--
_upgrades = (_side) Call WFCO_FNC_GetSideUpgrades;
_current_infantry_upgrade = _upgrades select WF_UP_BARRACKS;
_skill = 0.3;
switch (_current_infantry_upgrade) do {
   case 1: { _skill = 0.65 };
   case 2: { _skill = 0.85 };
   case 3: { _skill = 1 };
};
_unit setSkill ["aimingShake", _skill];
_unit setSkill ["aimingAccuracy", _skill];
_unit setSkill ["aimingSpeed", _skill];
_unit setSkill ["spotTime", _skill];
_unit setSkill ["spotDistance", _skill];
_unit setSkill ["commanding", _skill];
_unit setSkill ["courage", 1];

if ((missionNamespace getVariable "WF_C_GAMEPLAY_FATIGUE_ENABLED") == 1) then {
    _unit enableFatigue true;
    _unit enableStamina true
} else {
    _unit enableFatigue false;
    _unit enableStamina false
};
if (_sideId != WF_DEFENDER_ID) then {
    if(!(_unit hasWeapon "CUP_NVG_PVS14_Hide_WASP")) then { _unit addWeapon "CUP_NVG_PVS14_Hide_WASP" }
};

    _unit unlinkItem  "ItemWatch";
    _unit unlinkItem  "ItemCompass";
    _unit unlinkItem  "ItemGPS";
_unit removeWeapon  (binocular _unit);

    _handgunMagazines = handgunMagazine _unit;
    if(count _handgunMagazines > 0) then { _unit removeMagazines (_handgunMagazines # 0) };
    _unit removeWeapon (handgunWeapon _unit);
    removeAllHandgunItems _unit;

    {
    	if(_x in WF_C_GEAR_CHEMLIGHT_TYPES) then { _unit removeItem _x }
} forEach (itemsWithMagazines _unit);

if!(isPlayer (leader _group)) then {
    _unit unlinkItem  "ItemMap";
};

//--Check the need for unit re-equip--
for "_x" from 0 to ((count WF_C_INFANTRY_TO_REQUIP) - 1) do {
	_currentElement = WF_C_INFANTRY_TO_REQUIP # _x;
	if ((typeOf _unit) in _currentElement) exitWith{(_unit) call WFCO_FNC_Requip_AI;};
};

if (_global) then {
    if ((missionNamespace getVariable "WF_C_UNITS_TRACK_INFANTRY") == 0) then {
        if (isPlayer leader _group) then {[_unit, _sideId] spawn WFCO_FNC_initUnit}
        }
};

_unit addMPEventHandler ['MPKilled', {
    params ["_unit", "_killer", "_instigator", "_useEffects"];
    [_unit,_killer] call WFCO_FNC_OnUnitKilled
}];

["INFORMATION", Format ["fn_InitManUnit.sqf: [%1] Unit [%2] skill [%5] with a was created at [%3] and has been assigned to team [%4]",
    _side, _type, _position, _group, _skill]] Call WFCO_FNC_LogContent;

_unit