private ["_vehicle", "_objects"];

_vehicle = vehicle player;

if (player != _vehicle) then {
    if (((getPos _vehicle) select 2) > 3 && !surfaceIsWater (getPos _vehicle)) then {
        [_vehicle] Call WFCO_FNC_BrokeTerObjsAround;

        [_vehicle, getPos _vehicle, 15] Call WFCO_FNC_PlaceSafe;
    } else {
        [_vehicle] Call WFCO_FNC_BrokeTerObjsAround;

        _vehicle setPos [getPos _vehicle select 0, getPos _vehicle select 1, 0.5];
        _vehicle setVelocity [0,0,-0.5];
    };
};
if (player == _vehicle) then {
    _objects = player nearEntities[["Car","Motorcycle","Tank"],10];
    if (count _objects > 0) then {
        {
            if (getPos _x select 2 > 3 && !surfaceIsWater (getPos _x)) then {
                [_x] Call WFCO_FNC_BrokeTerObjsAround;

                [_x, getPos _x, 15] Call WFCO_FNC_PlaceSafe;
            } else {
                [_x] Call WFCO_FNC_BrokeTerObjsAround;

                _x setPos [getPos _x select 0, getPos _x select 1, 0.5];
                _x setVelocity [0,0,-0.5];
            };
        } forEach _objects;
    };
};