params ["_dropPosition"];

waitUntil {!isNil "WF_C_CHEMICAL_DAMAGE_RADIUS"};

[_dropPosition] spawn {

    params ["_dropPosition"];
    //--- Chemical post effect
    _rad_prot_mask_obj	= [''];

    _velocityFog = [random 3, random 3, -0.2]; // fog spreading
    _colorFog = [0.5, 1.7, 0.2]; // fog color
    _alphaFog = 0.02 + random 0.2; // fog transparency
    _fog = "#particlesource" createVehicleLocal _dropPosition;
    _fog setParticleParams [["\A3\Data_F\ParticleEffects\Universal\universal.p3d" , 16, 12, 13, 0], "", "Billboard", 1, 10, [0, 0, -6], _velocityFog, 1, 1.275, 1, 0,[14,10], [_colorFog + [0], _colorFog + [_alphaFog], _colorFog  + [0]], [1000], 1, 0, "", "", WF_C_CHEMICAL_DAMAGE_RADIUS];
    _fog setParticleRandom [3, [55, 55, 0.2], [0, 0, -0.1], 2, 0.45, [0, 0, 0, 0.1], 0, 0];
    _fog setParticleCircle [0.001, [0, 0, -0.12]];
    _fog setDropInterval 0.01;

    _timeMissileStriked = time;
    _unitIsWeared = false;
    while {time - _timeMissileStriked < 300} do {

        _units = [];
        _units = _units + (_dropPosition nearEntities [WF_C_MAN_KIND, WF_C_CHEMICAL_DAMAGE_RADIUS]);
        _vehicles = _dropPosition nearEntities [WF_C_CHEMICAL_DAMAGE_VEHICLE_KINDS, WF_C_CHEMICAL_DAMAGE_RADIUS];

        {
            _vehicle = _x;
            { _units pushBackUnique _x } forEach (crew _vehicle)
        } foreach _vehicles;

        {
            _unit = _x;
            _unitIsWeared = false;
            _isUnitInLightVehicle = false;

            if !(_unitIsWeared) then {
                if ((goggles _unit) in WF_C_GAS_MASKS) then {
                    _unitIsWeared = true
                } else {
                    _unitIsWeared = false
                }
            };

            if (_unitIsWeared) then {
                sleep (1.2 + random 1)
            } else {
                _unitIsWeared = false;

                if (_isUnitInLightVehicle) then {
                    {
                        if(group _x == WF_Client_Team) then {
                            if(!isNull (missionNamespace getVariable "AIC_Remote_View_From_Unit")) then {
                                [] call AIC_fnc_terminateRemoteControl
                            };
                            
                            if(!isNull (missionNamespace getVariable "AIC_Remote_Control_From_Unit")) then {
                                [] call AIC_fnc_terminateRemoteControl
                            };
                        };
                    } foreach (crew (vehicle _unit))
                } else {
                    if(group _unit == WF_Client_Team) then {
                        if(!isNull (missionNamespace getVariable "AIC_Remote_View_From_Unit")) then {
                            [] call AIC_fnc_terminateRemoteControl
                        };

                        if(!isNull (missionNamespace getVariable "AIC_Remote_Control_From_Unit")) then {
                            [] call AIC_fnc_terminateRemoteControl
                        };
                    };
                };

                _amplificat_effect = linearConversion [0, 1,(getdammage _unit), 2, 0.1, true];
                sleep _amplificat_effect;
            };
        } forEach _units;
        sleep 5
    };

    deleteVehicle _fog
}

