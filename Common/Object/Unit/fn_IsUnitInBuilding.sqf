private["_unit1","_building","_type","_relPos","_boundingBox","_min","_max","_myX","_myY","_myZ","_inside"];

params["_unit1"];

_inside = false;
_buildingsCheck = [];
_buildingsCheck = _unit1 call {
    _end = [];
    _array = lineIntersectsSurfaces [
      getPosWorld _this,  
      getPosWorld _this vectorAdd [0, 0, 50],  
      _this, objNull, true, 1, "GEOM", "NONE" 
    ];
	
    {
        _house = _x select 3;
        if (_house isKindOf "HouseBase") then {
            _end pushback _house;
        };
    } forEach _array;
	
    _end
};

{
    _relPos = _x WorldToModel (getposATL _unit1);
    _boundingBox = boundingBoxReal _x;
    _min = [];
    _max = [];
    _min = (_boundingBox select 0);
    _max = (_boundingBox select 1);
                 
    _myX = _relPos select 0;
    _myY = _relPos select 1;
    _myZ = _relPos select 2;
                
    if ((_myX > (_min select 0)) and (_myX < (_max select 0))) then {
            if ((_myY > (_min select 1)) and (_myY < (_max select 1))) then {
                    if ((_myZ > (_min select 2)) and (_myZ < (_max select 2))) then {
                            _inside = true;
                    } else { _inside = false; };
            } else { _inside = false; };
    } else { _inside = false; };
} forEach _buildingsCheck;
    
_inside
