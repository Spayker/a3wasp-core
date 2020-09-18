/*
A function created by Sergey Verminskiy:
Broke terrain objects around vehicle (trees and bushes).
This is need for vehicle unflip. If there are trees and others objects close with vehicle when it been unfliping, vehicles will be destroyed.
*/

Private ["_vehicle","_radius"];

_vehicle = _this select 0;
_radius = 10;

if (count _this > 1) then {
	_radius = _this select 2;
};

_nearObjs = nearestTerrainObjects [_vehicle, ["TREE", "SMALL TREE", "BUSH", "FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE", "FENCE",
 "WALL", "HIDE"], _radius];
 
 {
	_x setDamage 1;
 } forEach _nearObjs;