params ["_object"];

TER_VASS_shopObject = _object;
uiNamespace setVariable ["TER_VASS_shopObject",_object];

//--- Arsenal cargo
_cargo = _object getVariable ["TER_VASS_cargo",[]];
_cargo = _cargo select {_x isEqualType ""};
_cargo = _cargo select {
    _iValues = [_object, _x] call TER_fnc_getItemValues;
    _amount = _iValues # 2;
    if (_amount isEqualType 0) then {_amount > 0} else {_amount}
};

_vItems = [[/*Weapons*/],[/*Items*/],[/*Mags*/],[/*backpacks*/]];
{
    _category = (_x call BIS_fnc_itemType) select 0;
    _type = (_x call BIS_fnc_itemType) select 1;
    _ind = switch _category do {
        case "Weapon":{0};
        case "Equipment";
        case "Item":{1};
        case "Mine";
        case "Magazine":{2};
        default {3};
    };
    _ind = switch _type do {
        case "Backpack":{3};
        default{_ind};
    };
    _vItems # _ind pushback _x;
} forEach _cargo;
if (isNil {_object getvariable "bis_fnc_arsenal_action"}) then {
    _object setvariable ["bis_fnc_arsenal_action",-1];// Prevent default arsenal action. for some reason it's still getting added otherwise
};
{
    [_object, true, false] call call compile format ["BIS_fnc_removeVirtual%1Cargo",_x];
    [_object, _vItems select _forEachIndex, false, false] call call compile format ["BIS_fnc_addVirtual%1Cargo",_x];
} forEach ["Weapon","Item","Magazine","Backpack"];

//--- Open Arsenal
["Open",[nil,_object,player]] call bis_fnc_arsenal;


//--- Update shops array but only if the shop hasnt been added yet
if (isNil "TER_VASS_allShops") then {
	TER_VASS_allShops = [];
};
TER_VASS_allShops pushBackUnique _object;


