/*
	Triggered whenever a unit take a consequent hit.
	 Parameters:
		- Killed
		- Killer
		- Damage
*/

params ["_unit","_causedby","_damage"];

if (_damage >= 0.02) then {
    if(isPlayer _causedby || isPlayer (leader (group _causedby))) then {
        _unit setVariable ["wf_lasthitby", _causedby];
		_unit setVariable ["wf_lasthittime", time];
    };
};