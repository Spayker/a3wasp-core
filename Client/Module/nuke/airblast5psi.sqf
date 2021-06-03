private ["_blastPos","_radius5", "_rad20psi","_allBuildings", "_allTrees", "_allVehicles", "_allUnits"];
private ["_curRadius5", "_h", "_curDamage5","_mark20psi", "_abort", "_house", "_yVel", "_xVel", "_mass"];

_blastPos = _this select 0;
_radius5 = _this select 1;
_rad20psi = _this select 2;
_curRadius5 = 40 + _rad20psi;
_damageScript = "freestyleNuke\crater.sqf";

if (_curRadius5 > _radius5) then {_curRadius5 = _radius5};
_abort = false;

//get affected objects
_allTrees = nearestTerrainObjects [_blastPos, ["SMALL TREE", "BUSH"], _radius5];
_allBuildings = nearestObjects [_blastPos ,["Building"], _radius5];
_allVehicles = nearestObjects [_blastPos ,["Car", "LandVehicles", "Air", "Ship"], _radius5];
_allUnits = nearestObjects [_blastPos ,["Man"], _radius5];

{ _x hideObject true } forEach _allTrees;

private _maxB = count _allBuildings;

//damage affected objects
while{_curRadius5 <= _radius5} do {
    _h = (_radius5 - _curRadius5) / (_radius5 - _rad20psi);
    _curDamage5 = -0.5 * ((-1 * _h + 1)  ^ 0.2) + 1;

    if (_curDamage5 > 1) then {_curDamage5 = 1;};

    private _c = 0;

    while {(((getPos (_allBuildings # _c)) distance _blastPos) < (_curRadius5 - 100)) && (_c < _maxB)} do {_c = _c + 1;};

    while {((((getPos (_allBuildings # _c)) distance _blastPos) - 40) <= _curRadius5) && (_c < _maxB)} do
    {
        private _x = _allBuildings # _c;
        _h = (getPos _x) distance _blastPos;
        if (_h > ((_curRadius5 - 40) max _rad20psi) && _h <= _curRadius5) then {
            _x setDamage[(random 15) / 100 + _curDamage5 * 1.5 + damage _x, false]
        };
        _c = _c + 1;
    };

    {
        _h = (getPos _x) distance _blastPos;
        if (_h > ((_curRadius5 - 40) max _rad20psi) && _h <= _curRadius5) then {
            _x setDamage[0.9 * _curDamage5 + damage _x, true];

            _xVel = -(_blastPos select 0) + ((getPos _x) select 0);
            _yVel = -(_blastPos select 1) + ((getPos _x) select 1);
            _xVel = _xVel / ((_xVel ^ 2 + _yVel ^ 2) ^ 0.5);
            _yVel = _yVel / ((_xVel ^ 2 + _yVel ^ 2) ^ 0.5);
            _mass = getMass _x;
            if(_mass == 0) then {_mass = 80;};
            _x allowDamage false;
            _x setVectorDir vectorNormalized ([(vectorDir _x) select 0, (vectorDir _x) select 1, 0] vectorDiff ([_xVel, _yVel, 0] vectorMultiply ([_xVel, _yVel, 0] vectorDotProduct [(vectorDir _x) select 0, (vectorDir _x) select 1, 0])));
            //throw vehicle back
            _x setVelocity [_xVel * 10000 / _mass, _yVel * 10000 / _mass, 3];

            0 = [_x, [_xVel, _yVel,0]] spawn {
                sleep 0.5;
                (_this select 0) setVectorDirAndUp [vectorDir (_this select 0),(_this select 1)];
                (_this select 0) allowDamage true
            };
        }
    } forEach _allVehicles;

    {
        _h = (getPos _x) distance _blastPos;
        if (_h > ((_curRadius5 - 40) max _rad20psi) && _h <= _curRadius5 && isDamageAllowed _x) then {
            if (stance _x == "PRONE") then {
                _x setDamage[_curDamage5 * 1.5 + damage _x, true]
            } else {
                //throw units away
                _xVel = -(_blastPos select 0) + ((getPos _x) select 0);
                _yVel = -(_blastPos select 1) + ((getPos _x) select 1);
                _xVel = _xVel / ((_xVel ^ 2 + _yVel ^ 2) ^ 0.5);
                _yVel = _yVel / ((_xVel ^ 2 + _yVel ^ 2) ^ 0.5);

                _x allowDamage false;
                _x setVelocity [_xVel * 10, _yVel * 10, 2];


                0 = _x spawn {
                    sleep 0.5;
                    _this switchMove "amovppnemstpsnonwnondnon";
                    sleep 1.5;
                    _this allowDamage true;
                };
                _x setDamage[(random 30) / 100 + _curDamage5 * 1.5 + damage _x, true]
            }
        }
    } forEach _allUnits;

    if(_abort) exitWith{};

    _curRadius5 = _curRadius5 + 40;
    if (_curRadius5 > _radius5) then {_curRadius5 = _radius5; _abort = true;};
    sleep 0.1;
}; 

