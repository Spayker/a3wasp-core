params ["_object", "_element", ["_from", "CfgVehicles"]];

if (typeName _object == 'OBJECT') then {_object = typeOf(_object)};

getText (configFile >> _from >> _object >> _element)