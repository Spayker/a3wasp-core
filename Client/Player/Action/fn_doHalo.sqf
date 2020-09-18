/*
Parameters:
0: UNIT - (object) the unit that will be doing the HALO
1: (optional) AUTOOPEN -(boolean) true to auto open parachute at 150m
2: (optional) SAVELOADOUT - (boolean) true to save backpack and its contents, and add a "fake" backpack to the front of the unit.
*/
Private ["_unit","_vehicle"];

_vehicle = _this select 0;
_unit = _this select 1;

_unit action ["EJECT",_vehicle];
_unit setVelocity [0,0,0];

if (!isServer || isDedicated) exitWith {};

//Parameters
private ["_unit","_autoOpen","_saveLoadOut"];
_autoOpen 	 = true;
_saveLoadOut = true;

//Validate parameters
if (isNull _unit) exitWith {"Unit parameter must not be objNull. Accepted: OBJECT" call BIS_fnc_error};

//create a log entry
["HALO function has started"] call BIS_fnc_log;

//add immersion effects and sound
if (isPlayer _unit) then {
	cutText ["", "BLACK FADED",999];
	[_unit] spawn {
		private "_unit";
		_unit = _this select 0;

		sleep 2;

		"dynamicBlur" ppEffectEnable true;
		"dynamicBlur" ppEffectAdjust [6];
		"dynamicBlur" ppEffectCommit 0;
		"dynamicBlur" ppEffectAdjust [0.0];
		"dynamicBlur" ppEffectCommit 5;

		cutText ["", "BLACK IN", 5];

	};
};

//save the backpack and its contents, also adds fake pack to front of unit
if (_saveLoadOut && !isNull (unitBackpack _unit) && (backpack _unit) != "b_parachute") then {
private ["_pack","_class","_magazines","_weapons","_items","_helmet"];
_pack	   = unitBackpack _unit;
_class	   = typeOf _pack;
_magazines = getMagazineCargo _pack;
_weapons   = getWeaponCargo _pack;
_items	   = getItemCargo _pack;
_helmet	   = headgear _unit;

removeBackpack _unit; //remove the backpack
_unit addBackpack "b_parachute"; //add the parachute

[_unit,_class,_magazines,_weapons,_items,_helmet] spawn {
	private ["_unit","_class","_magazines","_weapons","_items","_helmet"];
	_unit		= _this select 0;
	_class		= _this select 1;
	_magazines	= _this select 2;
	_weapons 	= _this select 3;
	_items 		= _this select 4;
	_helmet		= _this select 5;

	private "_packHolder";
	_packHolder = createVehicle ["groundWeaponHolder", [0,0,0], [], 0, "can_collide"];
	_packHolder addBackpackCargoGlobal [_class, 1];

	waitUntil {animationState _unit == "HaloFreeFall_non"};
	_packHolder attachTo [_unit,[-0.12,-0.02,-.74],"pelvis"];
	_packHolder setVectorDirAndUp [[0,-1,-0.05],[0,0,-1]];

	waitUntil {animationState _unit == "para_pilot"};
	_packHolder attachTo [vehicle _unit,[-0.07,0.67,-0.13],"pelvis"];
	_packHolder setVectorDirAndUp [[0,-0.2,-1],[0,1,0]];

	waitUntil {isTouchingGround _unit || (getPos _unit select 2) < 1};
	detach _packHolder;
	deleteVehicle _packHolder; //delete the backpack in front

	_unit addBackpack _class; //return the backpack
	clearAllItemsFromBackpack _unit; //clear all gear from new backpack

	for "_i" from 0 to (count (_magazines select 0) - 1) do {
		(unitBackpack _unit) addMagazineCargoGlobal [(_magazines select 0) select _i,(_magazines select 1) select _i]; //return the magazines
	};
	for "_i" from 0 to (count (_weapons select 0) - 1) do {
		(unitBackpack _unit) addWeaponCargoGlobal [(_weapons select 0) select _i,(_weapons select 1) select _i]; //return the weapons
	};
	for "_i" from 0 to (count (_items select 0) - 1) do {
		(unitBackpack _unit) addItemCargoGlobal [(_items select 0) select _i,(_items select 1) select _i]; //return the items
	};
};
} else {
if ((backpack _unit) != "b_parachute") then {_unit addBackpack "B_parachute"}; //add the parachute if unit has no backpack
};

_unit setPos [(getPos _unit select 0), (getPos _unit select 1), (getPos _unit select 2)]; //Set the altitude of the HALO jump

if (!isPlayer _unit) then {
_unit allowDamage FALSE; //god mode :)
_unit switchMove "HaloFreeFall_non"; //place the AI into the free fall animation
_unit disableAI "ANIM"; //disable the AI animation so they cant switch back to standing
};

if (isPlayer _unit) then {
[_unit,_autoOpen] spawn {
	private ["_unit","_autoOpen"];
	_unit 	  = _this select 0;
	_autoOpen = _this select 1;

	if (_autoOpen) then {
		waitUntil {(getPos _unit select 2) < 150 || animationState _unit == "para_pilot" && alive _unit};
		_unit action ["OpenParachute", _unit]; //open parachute if 150m above ground
	};

	waitUntil {animationState _unit == "para_pilot"};

	// Parachute opening effect for more immersion
	playSound "open_chute"; //play chute opening sound
	setAperture 0.05;
	setAperture -1;
	"DynamicBlur" ppEffectEnable true;
	"DynamicBlur" ppEffectAdjust [8.0];
	"DynamicBlur" ppEffectCommit 0.01;
	sleep 1;
	"DynamicBlur" ppEffectAdjust [0.0];
	"DynamicBlur" ppEffectCommit 3;
	sleep 3;
	"DynamicBlur" ppEffectEnable false;
	"RadialBlur" ppEffectAdjust [0.0, 0.0, 0.0, 0.0];
	"RadialBlur" ppEffectCommit 1.0;
	"RadialBlur" ppEffectEnable false;

	while {(getPos _unit select 2) > 2} do {
		playSound "para_pilot";
		sleep 4.2;
	};
};
};

[_unit] spawn {
private "_unit";
_unit = _this select 0;

waitUntil {isTouchingGround _unit || (getPos _unit select 2) < 1 && alive _unit};

if (!isPlayer _unit) then {
	_unit enableAI "ANIM";  //enable the animations
	_unit setPos [(getPos _unit select 0), (getPos _unit select 1), 0]; //this removes the unit from the parachute
	_unit setVelocity [0,0,0]; //set speed to zero
	_unit setVectorUp [0,0,1]; //set the unit upright
	sleep 1;
	_unit allowDamage TRUE; //allow unit to be damaged again
} else {
	// Parachute closing effect for more immersion
	playSound "close_chute";//play chute closing sound
	cutText ["", "BLACK FADED", 999];
	sleep 2;
	cutText ["", "BLACK IN", 2];

	_unit setDamage 0; //heal the unit to 100% in case of injury
};
};

//create a log
["HALO function has completed"] call BIS_fnc_log;

//Return Value
_unit;