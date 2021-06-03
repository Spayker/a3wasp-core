private ["_blastPos","_radius20", "_allBuildings", "_allTrees", "_allVehicles", "_allUnits", "_curRadius20", "_mark20psi", "_abort", "_hideRadius", "_o"];

_blastPos = _this select 0;
_radius20 = _this select 1;
_hideRadius = _this select 2;
_curRadius20 = 40;

if (_curRadius20 > _radius20) then {_curRadius20 = _radius20;};
_abort = false;

//get affected objects
_allTrees = nearestTerrainObjects [_blastPos, ["TREE", "SMALL TREE", "BUSH", "FOREST","FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE"], _radius20];
_allBuildings = nearestObjects [_blastPos ,["Building"], _radius20];
_allVehicles = _blastPos nearObjects ["AllVehicles", _radius20];
_craterHidden = nearestTerrainObjects [_blastPos, [], _hideRadius];

private _maxB = count _allBuildings;

{if(isDamageAllowed _x) then { _x hideObjectGlobal true;};} forEach _allTrees;
{if(isDamageAllowed _x) then { _x setDamage[1, false]; _x hideObjectGlobal true;};} forEach _craterHidden;

//iterate from the center and damage the affected objects
while{_curRadius20 <= _radius20} do {

    private _c = 0;
    while {(((getPos (_allBuildings # _c)) distance _blastPos) < (_curRadius20 - 80)) && (_c < _maxB)} do {_c = _c + 1;};

    while {((((getPos (_allBuildings # _c)) distance _blastPos) - 40) <= _curRadius20) && (_c < _maxB)} do {
        _o = _allBuildings # _c;
        //hide objects for crater generation
        _h = (getPos _o) distance _blastPos;
        if (_h > (_curRadius20 - 40) && _h <= _curRadius20 && _h <= _hideRadius && isDamageAllowed _o) then {_o hideObjectGlobal true;};
        if (_h > (_curRadius20 - 40) && _h <= _curRadius20 && _h > _hideRadius && isDamageAllowed _o) then {_o setDamage[1, false]; };
        _c = _c + 1;
    };

    {
        _h = (getPos _x) distance _blastPos;
        if(_h >= (_curRadius20 - 40) && _h <= _curRadius20 && isDamageAllowed _x) then {

            _xVel = -(_blastPos select 0) + ((getPos _x) select 0);
            _yVel = -(_blastPos select 1) + ((getPos _x) select 1);
            _xVel = _xVel / ((_xVel ^ 2 + _yVel ^ 2) ^ 0.5);
            _yVel = _yVel / ((_xVel ^ 2 + _yVel ^ 2) ^ 0.5);
            _mass = getMass _x;
            _mass = _mass / 2;
            if(_mass == 0) then {_mass = 40;};

            _x setVectorDir vectorNormalized ([(vectorDir _x) select 0, (vectorDir _x) select 1, 0] vectorDiff ([_xVel, _yVel, 0] vectorMultiply ([_xVel, _yVel, 0] vectorDotProduct [(vectorDir _x) select 0, (vectorDir _x) select 1, 0])));

            _x setVelocity [_xVel * 10000 / _mass, _yVel * 10000 / _mass, 3];
            0 = [_x, [_xVel, _yVel,0]] spawn {
                sleep 0.5;
                (_this select 0) setVectorDirAndUp [vectorDir (_this select 0),(_this select 1)];
            };

            if(_x isKindOf "Man") then {
                _x setDamage[1, false]

            } else {
                _x setDamage[1, false];

                {
                    _x setDamage[1, false]
                } forEach crew _x;
            }
        }
    } forEach _allVehicles;

    if(_abort) exitWith{};

    _curRadius20 = _curRadius20 + 40;
    if (_curRadius20 > _radius20) then {_curRadius20 = _radius20; _abort = true};
    sleep 0.1
}