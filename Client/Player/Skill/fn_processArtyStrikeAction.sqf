private ["_rounds", "_roundType", "_radiusSpread", "_delay", "_reloadtime", "_position", "_binoculars"];

_rounds = 5;
_roundType = "Sh_120mm_HE";
_radiusSpread = 50;
_delay =  5;
_reloadtime = 600;

_binoculars = ["Laserdesignator", "Binocular", "Binocular_Vector","rhs_1PN138","rhs_pdu4","lerca_1200_black","lerca_1200_tan","Leupold_Mk4","Rangefinder"];
if !((currentWeapon player) in _binoculars) exitWith {
    [format["%1", localize "STR_WF_INFO_ArtyStrike_Info"]] spawn WFCL_fnc_handleMessage
};
WF_SK_V_LastUse_ArtyStrike = time;

["FIRE MISSION RECEIVED. WAIT OUT"] spawn WFCL_fnc_handleMessage;
sleep _delay;

_position = screenToWorld [0.5,0.5];
for "_round" from 1 to _rounds do {
    sleep 0.5;
    _mortarPos = [(_position select 0)-_radiusSpread*sin(random 360),(_position select 1)-_radiusSpread*cos(random 360),200];
    _bomb = _roundType createVehicle _mortarPos;
    [_bomb, -90, 0] call BIS_fnc_setPitchBank;
    _bomb setVelocity [0,0,-100];
    sleep _delay - 0.5;
};

["FIRE MISSION COMPLETE."] spawn WFCL_fnc_handleMessage;
["Artillary ready. Awaiting orders..."] spawn WFCL_fnc_handleMessage
