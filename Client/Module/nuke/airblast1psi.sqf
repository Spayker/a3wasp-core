private ["_blastPos","_radius1", "_rad5psi","_allBuildings", "_allTrees", "_allVehicles", "_allUnits", "_curRadius1", "_h", "_curDamage1", "_abort"];

_blastPos = _this select 0;
_radius1 = _this select 1;
_rad5psi = _this select 2;
_curRadius1 = 40 + _rad5psi;

_damageScript = "freestyleNuke\crater.sqf";

if (_curRadius1 > _radius1) then {_curRadius1 = _radius1;};
_abort = false;

//get affected objects
_allBuildings = nearestObjects [_blastPos ,["Building"], _radius1];
_allVehicles = nearestObjects [_blastPos ,["LandVehicles", "Air", "Ship"], _radius1];
_allUnits = nearestObjects [_blastPos ,["Man"], _radius1];


private _maxB = count _allBuildings;

//damage objects 
while{_curRadius1 <= _radius1} do {

    _h = (_radius1 - _curRadius1) / (_radius1 - _rad5psi);
    _curDamage1 = 0.5 * (_h  ^ 0.2);

    if (_curDamage1 < 0.1) then {_curDamage1 = 0.1;};
    if (_curDamage1 > 1) then {_curDamage1 = 1;};

    private _c = 0;

    while {(((getPos (_allBuildings # _c)) distance _blastPos) < (_curRadius1 - 80)) && (_c < _maxB)} do {_c = _c + 1};
    while {((((getPos (_allBuildings # _c)) distance _blastPos) - 40) <= _curRadius1) && (_c < _maxB)} do
    {
        private _x = _allBuildings # _c;
        _h = (getPos _x) distance _blastPos;
        if (_h > ((_curRadius1 - 40) max _rad5psi) && _h <= _curRadius1) then {
            _x setDamage[_curDamage1 * 1.5 + damage _x, false];
        };
        _c = _c + 1;
    };

    {
        _h = (getPos _x) distance _blastPos;
        if (_h > ((_curRadius1 - 40) max _rad5psi) && _h <= _curRadius1) then {_x setDamage[_curDamage1 + damage _x, true] }
    } forEach _allVehicles;

    {
        _h = (getPos _x) distance _blastPos;
        if (_h > ((_curRadius1 - 40) max _rad5psi) && _h <= _curRadius1 && isDamageAllowed _x) then {
            if (stance _x == "PRONE") then {
                _x setDamage[(_curDamage1 / 1.5) + damage _x, true]
            } else {
                _x setDamage[_curDamage1 + damage _x, true]
            }
        }
    } forEach _allUnits;

    if(_abort) exitWith{};

    _curRadius1 = _curRadius1 + 40;
    if (_curRadius1 > _radius1) then {_curRadius1 = _radius1; _abort = true;};
    sleep 0.1;

}; 


