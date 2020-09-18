//--------------------------fn_RemoveAction-------------------------------------------------------------------------//
//																													//
//	Find action on object by params and remove it																	//
//--------------------------fn_RemoveAction-------------------------------------------------------------------------//
params ["_object", ["_title", ""], ["_script", ""]];
private ["_allIDs", "_index", "_id", "_condition"];

if(!isNil "_object") then {
	_allIDs = actionIDs _object;
	
	_id = -1;
	_index = -1;
	
	_condition = "";
	if(_title != "") then { _condition = _condition + "(_object actionParams _x) # 0 == '_title'"; };
	if(_script != "") then {
		if(_title != "") then { _condition = _condition + " && " };
		_condition = _condition + "(_object actionParams _x) # 1 == '_script'";
	};
	
	_index = (_allIDs findIf (compile _condition));
	
	if (_index >= 0) then {
		_id = _allIDs # _index;
		_object removeAction _id;
	};
};